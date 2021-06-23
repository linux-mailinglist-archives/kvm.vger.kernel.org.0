Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD043B18E9
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFWLch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:32:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230206AbhFWLce (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GCtL5TkdUY64I6EFpPbwPPAhw4APmhcFr8dcpbAliMg=;
        b=MmtLIo2NunyfR4yNGv9yiol+UClMc4w4B4a0v9TpkMZ+LoIJG4c4JBECJR7bz3yZ5qoqpc
        zUGjGEfGbGOj3UuoiLIvb8esI/xxx7P8Jlt1LNpVLPnFUztYn6AUWhbSJHIQDFc6SObVoS
        GgjexECHk47/KxqyMcPCAi2+b9jVjRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-hPP9iZ9jNai_cQe79kvurQ-1; Wed, 23 Jun 2021 07:30:15 -0400
X-MC-Unique: hPP9iZ9jNai_cQe79kvurQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48B6919067E1;
        Wed, 23 Jun 2021 11:30:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C5A53A47;
        Wed, 23 Jun 2021 11:30:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 01/10] KVM: x86: extract block/allow guest enteries
Date:   Wed, 23 Jun 2021 14:29:53 +0300
Message-Id: <20210623113002.111448-2-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Master clock update sets and then clears a request which is not
handled by KVM as a means to block and then allow guest entries.
Extract this to kvm_allow_guest_entries/kvm_block_guest_entries.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/x86.c              | 25 +++++++++++++++----------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e11d64aa0bcd..cadb09c6fb0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -68,7 +68,7 @@
 #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
 #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
 #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
-#define KVM_REQ_MCLOCK_INPROGRESS \
+#define KVM_REQ_BLOCK_GUEST_ENTRIES \
 	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_SCAN_IOAPIC \
 	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
@@ -1831,7 +1831,8 @@ u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier);
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm);
+void kvm_block_guest_entries(struct kvm *kvm);
+void kvm_allow_guest_entries(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76dae88cf524..9af2fbbe0521 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2735,9 +2735,18 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 #endif
 }
 
-void kvm_make_mclock_inprogress_request(struct kvm *kvm)
+void kvm_block_guest_entries(struct kvm *kvm)
 {
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_BLOCK_GUEST_ENTRIES);
+}
+
+void kvm_allow_guest_entries(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_clear_request(KVM_REQ_BLOCK_GUEST_ENTRIES, vcpu);
 }
 
 static void kvm_gen_update_masterclock(struct kvm *kvm)
@@ -2750,9 +2759,8 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 
 	kvm_hv_invalidate_tsc_page(kvm);
 
-	kvm_make_mclock_inprogress_request(kvm);
+	kvm_block_guest_entries(kvm);
 
-	/* no guest entries from this point */
 	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	pvclock_update_vm_gtod_copy(kvm);
 	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
@@ -2760,9 +2768,7 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-	/* guest entries allowed */
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+	kvm_allow_guest_entries(kvm);
 #endif
 }
 
@@ -8051,7 +8057,7 @@ static void kvm_hyperv_tsc_notifier(void)
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_make_mclock_inprogress_request(kvm);
+		kvm_block_guest_entries(kvm);
 
 	hyperv_stop_tsc_emulation();
 
@@ -8070,8 +8076,7 @@ static void kvm_hyperv_tsc_notifier(void)
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
-		kvm_for_each_vcpu(cpu, vcpu, kvm)
-			kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+		kvm_allow_guest_entries(kvm);
 	}
 	mutex_unlock(&kvm_lock);
 }
-- 
2.26.3

