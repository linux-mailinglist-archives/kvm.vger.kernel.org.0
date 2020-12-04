Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D092CE4EC
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388391AbgLDBUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388205AbgLDBUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD3EC08E85F
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zXcnTM/BxDT1oqD6xZCDg6AyUlQdFYvXAbZCud3KsgY=; b=QAyhn5HS9lrKDUnL6UEJQaOi54
        gRIDAYsp8jkycNwq1hXrsxoolFnze3z30kHJ8AJ/4FSKPVDwS1oLuCKfq9aVsZ30UA+3e8RBWIpvh
        20mhZJ1MHdc1pe/akTQkNvAHXBM5nx0oCKGxFEPlo8IgdzoSJ+1spFf9ZsAwwwVaFUMqeCldi2IfF
        /3RSuY+tPOu2i4IFyslB9t96Ooat0JqP4QinlHV+AP8R1L1dxXJnsByCBEnpKvao7NKTr6jj5GVga
        oa4Ec2zvYnY+9gcS/GfO+OFOQbCg+mvLNEPzP2lQdIz2TtpDqABALi8Vil9WDsXi+JCXaF7oxkz+q
        VdzvnGzA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Ka-NM; Fri, 04 Dec 2020 01:18:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CS9t-98; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 04/15] KVM: x86/xen: Fix coexistence of Xen and Hyper-V hypercalls
Date:   Fri,  4 Dec 2020 01:18:37 +0000
Message-Id: <20201204011848.2967588-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Disambiguate Xen vs. Hyper-V calls by adding 'orl $0x80000000, %eax'
at the start of the Hyper-V hypercall page when Xen hypercalls are
also enabled.

That bit is reserved in the Hyper-V ABI, and those hypercall numbers
will never be used by Xen (because it does precisely the same trick).

Switch to using kvm_vcpu_write_guest() while we're at it, instead of
open-coding it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/hyperv.c                         | 40 ++++++++++++++-----
 arch/x86/kvm/xen.c                            |  6 +++
 .../selftests/kvm/x86_64/xen_vmcall_test.c    | 39 +++++++++++++++---
 3 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5c7c4060b45c..347ff9ad70b3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -23,6 +23,7 @@
 #include "ioapic.h"
 #include "cpuid.h"
 #include "hyperv.h"
+#include "xen.h"
 
 #include <linux/cpu.h>
 #include <linux/kvm_host.h>
@@ -1139,9 +1140,9 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			hv->hv_hypercall &= ~HV_X64_MSR_HYPERCALL_ENABLE;
 		break;
 	case HV_X64_MSR_HYPERCALL: {
-		u64 gfn;
-		unsigned long addr;
-		u8 instructions[4];
+		u8 instructions[9];
+		int i = 0;
+		u64 addr;
 
 		/* if guest os id is not set hypercall should remain disabled */
 		if (!hv->hv_guest_os_id)
@@ -1150,16 +1151,33 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 			hv->hv_hypercall = data;
 			break;
 		}
-		gfn = data >> HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_SHIFT;
-		addr = gfn_to_hva(kvm, gfn);
-		if (kvm_is_error_hva(addr))
-			return 1;
-		kvm_x86_ops.patch_hypercall(vcpu, instructions);
-		((unsigned char *)instructions)[3] = 0xc3; /* ret */
-		if (__copy_to_user((void __user *)addr, instructions, 4))
+
+		/*
+		 * If Xen and Hyper-V hypercalls are both enabled, disambiguate
+		 * the same way Xen itself does, by setting the bit 31 of EAX
+		 * which is RsvdZ in the 32-bit Hyper-V hypercall ABI and just
+		 * going to be clobbered on 64-bit.
+		 */
+		if (kvm_xen_hypercall_enabled(kvm)) {
+			/* orl $0x80000000, %eax */
+			instructions[i++] = 0x0d;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x00;
+			instructions[i++] = 0x80;
+		}
+
+		/* vmcall/vmmcall */
+		kvm_x86_ops.patch_hypercall(vcpu, instructions + i);
+		i += 3;
+
+		/* ret */
+		((unsigned char *)instructions)[i++] = 0xc3;
+
+		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
+		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
 			return 1;
 		hv->hv_hypercall = data;
-		mark_page_dirty(kvm, gfn);
 		break;
 	}
 	case HV_X64_MSR_REFERENCE_TSC:
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b76d121a86c0..503935d8212e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -8,6 +8,7 @@
 
 #include "x86.h"
 #include "xen.h"
+#include "hyperv.h"
 
 #include <linux/kvm_host.h>
 
@@ -99,6 +100,11 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 
 	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
 
+	/* Hyper-V hypercalls get bit 31 set in EAX */
+	if ((input & 0x80000000) &&
+	    kvm_hv_hypercall_enabled(vcpu->kvm))
+		return kvm_hv_hypercall(vcpu);
+
 	longmode = is_64_bit_mode(vcpu);
 	if (!longmode) {
 		params[0] = (u32)kvm_rbx_read(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
index 3f1dd93626e5..24f279e1a66b 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -15,6 +15,7 @@
 
 #define HCALL_REGION_GPA	0xc0000000ULL
 #define HCALL_REGION_SLOT	10
+#define PAGE_SIZE		4096
 
 static struct kvm_vm *vm;
 
@@ -22,7 +23,12 @@ static struct kvm_vm *vm;
 #define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
 #define RETVALUE 0xcafef00dfbfbffffUL
 
-#define XEN_HYPERCALL_MSR 0x40000000
+#define XEN_HYPERCALL_MSR	0x40000200
+#define HV_GUEST_OS_ID_MSR	0x40000000
+#define HV_HYPERCALL_MSR	0x40000001
+
+#define HVCALL_SIGNAL_EVENT		0x005d
+#define HV_STATUS_INVALID_ALIGNMENT	4
 
 static void guest_code(void)
 {
@@ -30,6 +36,7 @@ static void guest_code(void)
 	unsigned long rdi = ARGVALUE(1);
 	unsigned long rsi = ARGVALUE(2);
 	unsigned long rdx = ARGVALUE(3);
+	unsigned long rcx;
 	register unsigned long r10 __asm__("r10") = ARGVALUE(4);
 	register unsigned long r8 __asm__("r8") = ARGVALUE(5);
 	register unsigned long r9 __asm__("r9") = ARGVALUE(6);
@@ -41,18 +48,38 @@ static void guest_code(void)
 			     "r"(r10), "r"(r8), "r"(r9));
 	GUEST_ASSERT(rax == RETVALUE);
 
-	/* Now fill in the hypercall page */
+	/* Fill in the Xen hypercall page */
 	__asm__ __volatile__("wrmsr" : : "c" (XEN_HYPERCALL_MSR),
 			     "a" (HCALL_REGION_GPA & 0xffffffff),
 			     "d" (HCALL_REGION_GPA >> 32));
 
-	/* And invoke the same hypercall that way */
+	/* Set Hyper-V Guest OS ID */
+	__asm__ __volatile__("wrmsr" : : "c" (HV_GUEST_OS_ID_MSR),
+			     "a" (0x5a), "d" (0));
+
+	/* Hyper-V hypercall page */
+	u64 msrval = HCALL_REGION_GPA + PAGE_SIZE + 1;
+	__asm__ __volatile__("wrmsr" : : "c" (HV_HYPERCALL_MSR),
+			     "a" (msrval & 0xffffffff),
+			     "d" (msrval >> 32));
+
+	/* Invoke a Xen hypercall */
 	__asm__ __volatile__("call *%1" : "=a"(rax) :
 			     "r"(HCALL_REGION_GPA + INPUTVALUE * 32),
 			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
 			     "r"(r10), "r"(r8), "r"(r9));
 	GUEST_ASSERT(rax == RETVALUE);
 
+	/* Invoke a Hyper-V hypercall */
+	rax = 0;
+	rcx = HVCALL_SIGNAL_EVENT;	/* code */
+	rdx = 0x5a5a5a5a;		/* ingpa (badly aligned) */
+	__asm__ __volatile__("call *%1" : "=a"(rax) :
+			     "r"(HCALL_REGION_GPA + PAGE_SIZE),
+			     "a"(rax), "c"(rcx), "d"(rdx),
+			     "r"(r8));
+	GUEST_ASSERT(rax == HV_STATUS_INVALID_ALIGNMENT);
+
 	GUEST_DONE();
 }
 
@@ -73,11 +100,11 @@ int main(int argc, char *argv[])
 	};
 	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
 
-	/* Map a region for the hypercall page */
+	/* Map a region for the hypercall pages */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
                                     HCALL_REGION_GPA, HCALL_REGION_SLOT,
-				    getpagesize(), 0);
-	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 1, 0);
+				    2 * getpagesize(), 0);
+	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 2, 0);
 
 	for (;;) {
 		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
-- 
2.26.2

