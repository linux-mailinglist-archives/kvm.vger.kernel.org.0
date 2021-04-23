Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE14368F2B
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhDWJGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:06:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:18163 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhDWJGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 05:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619168771; x=1650704771;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=SiScQ0H7s9eUAFp0xeJC3NL931O8+l8uIOp8XRXepRo=;
  b=dfJNz87vkmsVK2TzSdO6OWgMR3OySfQ6YWSCmFM3j5b8oeIAB3+qGMIt
   7apu0EViaw9ytWqewWcKbNDiY9itZEfN4zNKOol3UxXI3FfLo0MZOprQN
   OgY9W5egBXC+icx5CF+szUqgMThheul6P2zs2fcy9TpksarNOZ6qVk3by
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="103552215"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 23 Apr 2021 09:04:03 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 96519A1760;
        Fri, 23 Apr 2021 09:03:58 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.209) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 09:03:51 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Date:   Fri, 23 Apr 2021 11:03:33 +0200
Message-ID: <20210423090333.21910-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D17UWB002.ant.amazon.com (10.43.161.141) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hypercall code page is specified in the Hyper-V TLFS to be an overlay
page, ie., guest chooses a GPA and the host _places_ a page at that
location, making it visible to the guest and the existing page becomes
inaccessible. Similarly when disabled, the host should _remove_ the
overlay and the old page should become visible to the guest.

Currently KVM directly patches the hypercall code into the guest chosen
GPA. Since the guest seldom moves the hypercall code page around, it
doesn't see any problems even though we are corrupting the exiting data
in that GPA.

VSM API introduces more complex overlay workflows during VTL switches
where the guest starts to expect that the existing page is intact. This
means we need a more generic approach to handling overlay pages: add a
new exit reason KVM_EXIT_HYPERV_OVERLAY that exits to userspace with the
expectation that a page gets overlaid there.

In the interest of maintaing userspace exposed behaviour, add a new KVM
capability to allow the VMMs to enable this if they can handle the
hypercall page in userspace.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>

CR: https://code.amazon.com/reviews/CR-49011379
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  5 +++++
 include/uapi/linux/kvm.h        | 10 ++++++++++
 4 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..2b560e77f8bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -925,6 +925,10 @@ struct kvm_hv {
 
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
+
+	struct {
+		u64 overlay_hcall_page:1;
+	} flags;
 };
 
 struct msr_bitmap_range {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..e7d9d3bb39dc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -191,6 +191,21 @@ static void kvm_hv_notify_acked_sint(struct kvm_vcpu *vcpu, u32 sint)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 }
 
+static void overlay_exit(struct kvm_vcpu *vcpu, u32 msr, u64 gpa,
+			 u32 data_len, const u8 *data)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	hv_vcpu->exit.type = KVM_EXIT_HYPERV_OVERLAY;
+	hv_vcpu->exit.u.overlay.msr = msr;
+	hv_vcpu->exit.u.overlay.gpa = gpa;
+	hv_vcpu->exit.u.overlay.data_len = data_len;
+	if (data_len)
+		memcpy(hv_vcpu->exit.u.overlay.data, data, data_len);
+
+	kvm_make_request(KVM_REQ_HV_EXIT, vcpu);
+}
+
 static void synic_exit(struct kvm_vcpu_hv_synic *synic, u32 msr)
 {
 	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
@@ -1246,9 +1261,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 		/* ret */
 		((unsigned char *)instructions)[i++] = 0xc3;
 
-		addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
-		if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
-			return 1;
+		if (kvm->arch.hyperv.flags.overlay_hcall_page) {
+			overlay_exit(vcpu, msr, data, (u32)i, instructions);
+		} else {
+			addr = data & HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_MASK;
+			if (kvm_vcpu_write_guest(vcpu, addr, instructions, i))
+				return 1;
+		}
 		hv->hv_hypercall = data;
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..b3e497343e5c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3745,6 +3745,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
 	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
@@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.bus_lock_detection_enabled = true;
 		r = 0;
 		break;
+	case KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE:
+		kvm->arch.hyperv.flags.overlay_hcall_page = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6afee209620..37b0715da4fd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -185,10 +185,13 @@ struct kvm_s390_cmma_log {
 	__u64 values;
 };
 
+#define KVM_EXIT_HV_OVERLAY_DATA_SIZE  64
+
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
 #define KVM_EXIT_HYPERV_SYNDBG         3
+#define KVM_EXIT_HYPERV_OVERLAY        4
 	__u32 type;
 	__u32 pad1;
 	union {
@@ -213,6 +216,12 @@ struct kvm_hyperv_exit {
 			__u64 recv_page;
 			__u64 pending_page;
 		} syndbg;
+		struct {
+			__u32 msr;
+			__u32 data_len;
+			__u64 gpa;
+			__u8 data[KVM_EXIT_HV_OVERLAY_DATA_SIZE];
+		} overlay;
 	} u;
 };
 
@@ -1078,6 +1087,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_HYPERV_OVERLAY_HCALL_PAGE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



