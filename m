Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75D94533C4
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbhKPOOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:14:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35000 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbhKPON5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 09:13:57 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83C9B218D6;
        Tue, 16 Nov 2021 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637071859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1/Kjxk7P20z4/cSuq8O5K4p1sb9GgHDo99aesOCdltE=;
        b=H+10kwp1qpOcdlUGsbjydeY2SvSwTR63zx6MPMxsVhYLf/Ce8R8rBzvhFpJPm1Gmet14q5
        omJsyKflcLJ+lFVScy0QyuRJy6srJRRRImQ7qoQJvdwwShYuBbe65CtrtaC/683MZzkAIq
        dwQM7KlpLjoT3DPSSQklBGWPvgUTOxg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F72913BAE;
        Tue, 16 Nov 2021 14:10:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uJ9qBvO7k2ExEQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 16 Nov 2021 14:10:59 +0000
From:   Juergen Gross <jgross@suse.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 2/4] x86/kvm: introduce a per cpu vcpu mask
Date:   Tue, 16 Nov 2021 15:10:52 +0100
Message-Id: <20211116141054.17800-3-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211116141054.17800-1-jgross@suse.com>
References: <20211116141054.17800-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support high vcpu numbers per guest don't use an on stack
vcpu bitmask. As this currently used bitmask is not used in functions
subject to recursion it is fairly easy to replace it with a percpu
bitmask.

Allocate this bitmask dynamically in order to support boot time
specified max number of vcpus in future.

Disable preemption while such a bitmask is being used in order to
avoid double usage in case we'd switch cpus.

Note that this doesn't apply to vcpu bitmasks used in hyperv.c, as
there the max number of vcpus is architecturally limited to 4096 and
that bitmask can remain on the stack.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- use local_lock() instead of preempt_disable() (Paolo Bonzini)
V3:
- drop hyperv.c related changes (Eduardo Habkost)
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/ioapic.c           |  8 +++++++-
 arch/x86/kvm/irq_comm.c         |  9 +++++++--
 arch/x86/kvm/x86.c              | 18 +++++++++++++++++-
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bcef56f1039a..886930ec8264 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/cpumask.h>
 #include <linux/irq_work.h>
 #include <linux/irq.h>
+#include <linux/local_lock.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -1612,6 +1613,12 @@ extern bool kvm_has_bus_lock_exit;
 /* maximum vcpu-id */
 unsigned int kvm_max_vcpu_ids(void);
 
+/* per cpu vcpu bitmask, protected by kvm_pcpu_mask_lock */
+DECLARE_PER_CPU(local_lock_t, kvm_pcpu_mask_lock);
+extern unsigned long __percpu *kvm_pcpu_vcpu_mask;
+#define KVM_VCPU_MASK_SZ	\
+	(sizeof(*kvm_pcpu_vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS))
+
 extern u64 kvm_mce_cap_supported;
 
 /*
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 64ba9b1c8b3d..c81963a27594 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -320,7 +320,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 	bool mask_before, mask_after;
 	union kvm_ioapic_redirect_entry *e;
 	int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
-	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	unsigned long *vcpu_bitmap;
 
 	switch (ioapic->ioregsel) {
 	case IOAPIC_REG_VERSION:
@@ -384,6 +384,10 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			irq.shorthand = APIC_DEST_NOSHORT;
 			irq.dest_id = e->fields.dest_id;
 			irq.msi_redir_hint = false;
+
+			local_lock(&kvm_pcpu_mask_lock);
+
+			vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
 			bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
 			kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 						 vcpu_bitmap);
@@ -403,6 +407,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
 			}
 			kvm_make_scan_ioapic_request_mask(ioapic->kvm,
 							  vcpu_bitmap);
+
+			local_unlock(&kvm_pcpu_mask_lock);
 		} else {
 			kvm_make_scan_ioapic_request(ioapic->kvm);
 		}
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..c331204de007 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -47,7 +47,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 {
 	int i, r = -1;
 	struct kvm_vcpu *vcpu, *lowest = NULL;
-	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
+	unsigned long *dest_vcpu_bitmap;
 	unsigned int dest_vcpus = 0;
 
 	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
@@ -59,7 +59,10 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		irq->delivery_mode = APIC_DM_FIXED;
 	}
 
-	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
+	local_lock(&kvm_pcpu_mask_lock);
+	dest_vcpu_bitmap = this_cpu_ptr(kvm_pcpu_vcpu_mask);
+
+	memset(dest_vcpu_bitmap, 0, KVM_VCPU_MASK_SZ);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_apic_present(vcpu))
@@ -93,6 +96,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		lowest = kvm_get_vcpu(kvm, idx);
 	}
 
+	local_unlock(&kvm_pcpu_mask_lock);
+
 	if (lowest)
 		r = kvm_apic_set_irq(lowest, irq, dest_map);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61bab2bdeefb..a388acdc5eb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -215,6 +215,10 @@ unsigned int kvm_max_vcpu_ids(void)
 }
 EXPORT_SYMBOL_GPL(kvm_max_vcpu_ids);
 
+DEFINE_PER_CPU(local_lock_t, kvm_pcpu_mask_lock) =
+	INIT_LOCAL_LOCK(kvm_pcpu_mask_lock);
+unsigned long __percpu *kvm_pcpu_vcpu_mask;
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -11247,9 +11251,16 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
+					    sizeof(unsigned long));
+	if (!kvm_pcpu_vcpu_mask) {
+		r = -ENOMEM;
+		goto err;
+	}
+
 	r = ops->hardware_setup();
 	if (r != 0)
-		return r;
+		goto err;
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
@@ -11277,11 +11288,16 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	kvm_init_msr_list();
 	return 0;
+
+ err:
+	free_percpu(kvm_pcpu_vcpu_mask);
+	return r;
 }
 
 void kvm_arch_hardware_unsetup(void)
 {
 	static_call(kvm_x86_hardware_unsetup)();
+	free_percpu(kvm_pcpu_vcpu_mask);
 }
 
 int kvm_arch_check_processor_compat(void *opaque)
-- 
2.26.2

