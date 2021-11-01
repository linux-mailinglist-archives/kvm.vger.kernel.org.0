Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B934E44206F
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 20:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhKATGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 15:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhKATGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 15:06:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC657C061764
        for <kvm@vger.kernel.org>; Mon,  1 Nov 2021 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lHUY/Ne/8mMkM91pGC+iUrznkdvU6hkXNH/kM/Tzif8=; b=Xi4plcP08BvhE+KgB8QPBvJaWG
        qW3zOeIvLoi9l0vD6Jm0Jm84MEDtQubfHlKltUwn78g9egqZUMWeNYd1pZIUYGUtfdAoV+BrARdi1
        nkD1m1ENwI5Tim4vfp3oYRCAmVBtuYCxvkmfussYqEToYWnSj8QW2Ow0fuZ6pz4a+z8GQNHV6zjuv
        Xk5bEvjNQhJTIrgOP7uYRdclneF+56P7k1wHRwhqfeQN4HnqrLvzdRspKRnzf9uJTJYB071xMoIW/
        XVhrTAr47m/+T1/6hFDROJmrWoGC19hCB6G6ADDuPIXD5LcDdIdVFwZ/a355/hE4k/uo+/ZLxFQHF
        sRsuEdVw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-00DcY1-Jp; Mon, 01 Nov 2021 19:03:16 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhcaS-0004hR-AK; Mon, 01 Nov 2021 19:03:16 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        KarimAllah Raslan <karahmed@amazon.com>
Subject: [PATCH v2 2/6] KVM: selftests: Add event channel upcall support to xen_shinfo_test
Date:   Mon,  1 Nov 2021 19:03:10 +0000
Message-Id: <20211101190314.17954-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101190314.17954-1-dwmw2@infradead.org>
References: <20211101190314.17954-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When I first looked at this, there was no support for guest exception
handling in the KVM selftests. In fact it was merged into 5.10 before
the Xen support got merged in 5.11, and I could have used it from the
start.

Hook it up now, to exercise the Xen upcall delivery. I'm about to make
things a bit more interesting by handling the full 2level event channel
stuff in-kernel on top of the basic vector injection that we already
have, and I'll want to build more tests on top.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 75 ++++++++++++++++---
 1 file changed, 66 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index eda0d2a51224..a0699f00b3d6 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -24,8 +24,12 @@
 
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
 #define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
+#define VCPU_INFO_ADDR	(SHINFO_REGION_GPA + 0x40)
 
 #define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + 0x20)
+#define VCPU_INFO_VADDR	(SHINFO_REGION_GVA + 0x40)
+
+#define EVTCHN_VECTOR	0x10
 
 static struct kvm_vm *vm;
 
@@ -56,15 +60,44 @@ struct vcpu_runstate_info {
     uint64_t time[4];
 };
 
+struct arch_vcpu_info {
+    unsigned long cr2;
+    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
+};
+
+struct vcpu_info {
+        uint8_t evtchn_upcall_pending;
+        uint8_t evtchn_upcall_mask;
+        unsigned long evtchn_pending_sel;
+        struct arch_vcpu_info arch;
+        struct pvclock_vcpu_time_info time;
+}; /* 64 bytes (x86) */
+
 #define RUNSTATE_running  0
 #define RUNSTATE_runnable 1
 #define RUNSTATE_blocked  2
 #define RUNSTATE_offline  3
 
+static void evtchn_handler(struct ex_regs *regs)
+{
+	struct vcpu_info *vi = (void *)VCPU_INFO_VADDR;
+	vi->evtchn_upcall_pending = 0;
+
+	GUEST_SYNC(0x20);
+}
+
 static void guest_code(void)
 {
 	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
 
+	__asm__ __volatile__(
+		"sti\n"
+		"nop\n"
+	);
+
+	/* Trigger an interrupt injection */
+	GUEST_SYNC(0);
+
 	/* Test having the host set runstates manually */
 	GUEST_SYNC(RUNSTATE_runnable);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] != 0);
@@ -153,7 +186,7 @@ int main(int argc, char *argv[])
 
 	struct kvm_xen_vcpu_attr vi = {
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
-		.u.gpa = SHINFO_REGION_GPA + 0x40,
+		.u.gpa = VCPU_INFO_ADDR,
 	};
 	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &vi);
 
@@ -163,6 +196,16 @@ int main(int argc, char *argv[])
 	};
 	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &pvclock);
 
+	struct kvm_xen_hvm_attr vec = {
+		.type = KVM_XEN_ATTR_TYPE_UPCALL_VECTOR,
+		.u.vector = EVTCHN_VECTOR,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &vec);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vm_install_exception_handler(vm, EVTCHN_VECTOR, evtchn_handler);
+
 	if (do_runstate_tests) {
 		struct kvm_xen_vcpu_attr st = {
 			.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR,
@@ -171,9 +214,14 @@ int main(int argc, char *argv[])
 		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
 	}
 
+	struct vcpu_info *vinfo = addr_gpa2hva(vm, VCPU_INFO_VADDR);
+	vinfo->evtchn_upcall_pending = 0;
+
 	struct vcpu_runstate_info *rs = addr_gpa2hva(vm, RUNSTATE_ADDR);
 	rs->state = 0x5a;
 
+	bool evtchn_irq_expected = false;
+
 	for (;;) {
 		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 		struct ucall uc;
@@ -193,16 +241,21 @@ int main(int argc, char *argv[])
 			struct kvm_xen_vcpu_attr rst;
 			long rundelay;
 
-			/* If no runstate support, bail out early */
-			if (!do_runstate_tests)
-				goto done;
-
-			TEST_ASSERT(rs->state_entry_time == rs->time[0] +
-				    rs->time[1] + rs->time[2] + rs->time[3],
-				    "runstate times don't add up");
+			if (do_runstate_tests)
+				TEST_ASSERT(rs->state_entry_time == rs->time[0] +
+					    rs->time[1] + rs->time[2] + rs->time[3],
+					    "runstate times don't add up");
 
 			switch (uc.args[1]) {
-			case RUNSTATE_running...RUNSTATE_offline:
+			case 0:
+				evtchn_irq_expected = true;
+				vinfo->evtchn_upcall_pending = 1;
+				break;
+
+			case RUNSTATE_runnable...RUNSTATE_offline:
+				TEST_ASSERT(!evtchn_irq_expected, "Event channel IRQ not seen");
+				if (!do_runstate_tests)
+					goto done;
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT;
 				rst.u.runstate.state = uc.args[1];
 				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
@@ -236,6 +289,10 @@ int main(int argc, char *argv[])
 					sched_yield();
 				} while (get_run_delay() < rundelay);
 				break;
+			case 0x20:
+				TEST_ASSERT(evtchn_irq_expected, "Unexpected event channel IRQ");
+				evtchn_irq_expected = false;
+				break;
 			}
 			break;
 		}
-- 
2.31.1

