Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBFF540237
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbiFGPQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245056AbiFGPQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4009C72220
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654615015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R4Rt9+RaXRrx0q4tp9eJetSTPNClVuwlW698zPsAo+Y=;
        b=N9TXVJC9IqHqoIZZ4UR3Jo65KRb4Qg9h57O1V/3SKyrs8xQ2ClOv0c5wWiZb39E/HcHA7n
        IywskypmO8L+OgcUfudl8b7bBoIYLS0HzjZdKIoKyPQIF30tYz0+fcKR+nVklgmiksM/sg
        NjdAaWy1rWXGMHsCsVGTMQ8MwDcVFsE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-ENqCJdRtMX6nuHmT3Aq6tA-1; Tue, 07 Jun 2022 11:16:52 -0400
X-MC-Unique: ENqCJdRtMX6nuHmT3Aq6tA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BB2D1C1C1A4;
        Tue,  7 Jun 2022 15:16:51 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0A2B4538A0;
        Tue,  7 Jun 2022 15:16:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: preserve interrupt shadow across SMM entries
Date:   Tue,  7 Jun 2022 18:16:47 +0300
Message-Id: <20220607151647.307157-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the #SMI happens while the vCPU is in the interrupt shadow,
(after STI or MOV SS),
we must both clear it to avoid VM entry failure on VMX,
due to consistency check vs EFLAGS.IF which is cleared on SMM entries,
and restore it on RSM so that #SMI is transparent to the non SMM code.

To support migration, reuse upper 4 bits of
'kvm_vcpu_events.interrupt.shadow' to store the smm interrupt shadow.

This was lightly tested with a linux guest and smm load script,
and a unit test will be soon developed to test this better.

For discussion: there are other ways to fix this issue:

1. The SMM shadow can be stored in SMRAM at some unused
offset, this will allow to avoid changes to kvm_vcpu_ioctl_x86_set_vcpu_events

2. #SMI can instead be blocked while the interrupt shadow is active,
which might even be what the real CPU does, however since neither VMX
nor SVM support SMM window handling, this will involve single stepping
the guest like it is currently done on SVM for the NMI window in some cases.

What do you think?

Also this might need a new KVM cap, I am not sure about it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 28 +++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cf5d77d78969..4ee14dc79646f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -939,6 +939,9 @@ struct kvm_vcpu_arch {
 	 */
 	bool pdptrs_from_userspace;
 
+	/* saved interrupt shadow on smm entry */
+	u8 smm_interrupt_shadow;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db6f0373fa3f..28d736b74eec6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4915,6 +4915,8 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	events->interrupt.soft = 0;
 	events->interrupt.shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
 
+	events->interrupt.shadow |= vcpu->arch.smm_interrupt_shadow << 4;
+
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
 	events->nmi.masked = static_call(kvm_x86_get_nmi_mask)(vcpu);
@@ -4988,9 +4990,6 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	vcpu->arch.interrupt.injected = events->interrupt.injected;
 	vcpu->arch.interrupt.nr = events->interrupt.nr;
 	vcpu->arch.interrupt.soft = events->interrupt.soft;
-	if (events->flags & KVM_VCPUEVENT_VALID_SHADOW)
-		static_call(kvm_x86_set_interrupt_shadow)(vcpu,
-						events->interrupt.shadow);
 
 	vcpu->arch.nmi_injected = events->nmi.injected;
 	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
@@ -5024,6 +5023,14 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (events->flags & KVM_VCPUEVENT_VALID_SHADOW) {
+		static_call(kvm_x86_set_interrupt_shadow)(vcpu, events->interrupt.shadow & 0xF);
+		if (events->flags & KVM_VCPUEVENT_VALID_SMM)
+			vcpu->arch.smm_interrupt_shadow = events->interrupt.shadow >> 4;
+		else
+			vcpu->arch.smm_interrupt_shadow = 0;
+	}
+
 	if (events->flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT) {
 		if (!vcpu->kvm->arch.triple_fault_event)
 			return -EINVAL;
@@ -8282,6 +8289,15 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 
 	if (entering_smm) {
 		vcpu->arch.hflags |= HF_SMM_MASK;
+
+		/* Stash aside current value of the interrupt shadow
+		 * and reset it on the entry to the SMM
+		 */
+		vcpu->arch.smm_interrupt_shadow =
+				static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+
+		static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
+
 	} else {
 		vcpu->arch.hflags &= ~(HF_SMM_MASK | HF_SMM_INSIDE_NMI_MASK);
 
@@ -8294,6 +8310,12 @@ static void kvm_smm_changed(struct kvm_vcpu *vcpu, bool entering_smm)
 		 * guest memory
 		 */
 		vcpu->arch.pdptrs_from_userspace = false;
+
+		/* Restore interrupt shadow to its pre-SMM value */
+		static_call(kvm_x86_set_interrupt_shadow)(vcpu,
+					vcpu->arch.smm_interrupt_shadow);
+
+		vcpu->arch.smm_interrupt_shadow = 0;
 	}
 
 	kvm_mmu_reset_context(vcpu);
-- 
2.31.1

