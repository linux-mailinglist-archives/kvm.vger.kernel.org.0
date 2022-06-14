Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1C54BDF8
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 00:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355775AbiFNW4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 18:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbiFNW4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 18:56:21 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B4627B3D
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:56:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 72-20020a63014b000000b003fce454aaf2so5612894pgb.6
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4uqQQ6qeopHxiKXYe8TwBEAoHxCFaxNJ6CSjV0zGEsY=;
        b=flswYiWQxE4WTApN5/DEWkYG2KWcokKtn2lPaQH7Xyye98omQl8xdRUhTnqHhop7v9
         Vyaktsw/qBrV4quVMg/lcLT/2XDMjUKYMhZ/mko53KpXD0TMapqY0T7L5FYjuluXzcMj
         Hi2/JYBIi0YFH0LsPxv51wWeuuA9WlDwAjLN70/SltZfCpcAkEK2vBTxqZpWwoxvQX1j
         BCP1ZrkaN/k5pienYL6Fqm33rCT4tJx0nDMuFLfxGObtYiFv606hN9sRJqxXyKXoGx/g
         o8GA5Lj5mn5mcARKRCuWeQhclasEATRz4sMHUlfYYQvsTbLX3yylsJrH+zpCx1HWdfPQ
         s35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=4uqQQ6qeopHxiKXYe8TwBEAoHxCFaxNJ6CSjV0zGEsY=;
        b=fJc9hXRCu3NDXxjbnGAv0cIcoC/f/D3aupupJpIAX0uJIOlqZxW9WmV2028mBprwXI
         ORMNUdjVWdy3yLzP9VY1gN7FlkdrH34GHyvvoyrPs5v5hI3QPePuhvXBnvYnj7rTYDg9
         SR2fvEGD3r6xAwPFjROtnZgRjB0R/ya8ZOoL8XgCXhM1fu74upS8Yjlv/MHK+vPfjDlE
         RbxMLVHkXivecYdSutTTxbI4pnJAx2i/hE7UtMMlAQLV4qSg/Sm937Pxv/TWznC38i/U
         7GcsVb09Kvd7ypNbjtQ/P5GsnMcpY+Kkjhen9cbdbc2ZqynA2jH3NCjhkTeyHvpy9kwB
         5FwQ==
X-Gm-Message-State: AJIora9rTpRy4Z1FYAgdCfYh4fdt6P8DgGIBb7MLe5EZivZRCbk+Fwdo
        0jTwOlERPAyc/1h/2KnTJNXEnNeqPY0=
X-Google-Smtp-Source: AGRyM1tdPEjnCayzw9nFRZR/AD46ULgBXNEk4IhMT+cphQI/79J1vk0BNSU03l7/llYgi05a65NiFZJPM6Y=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr202967pje.0.1655247377887; Tue, 14 Jun
 2022 15:56:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 22:56:15 +0000
Message-Id: <20220614225615.3843835-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH] KVM: x86: Query vcpu->vcpu_idx directly and drop its
 accessor, again
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Read vcpu->vcpu_idx directly instead of bouncing through the one-line
wrapper, kvm_vcpu_get_idx(), and drop the wrapper.  The wrapper is a
remnant of the original implementation and serves no purpose; remove it
(again) before it gains more users.

kvm_vcpu_get_idx() was removed in the not-too-distant past by commit
4eeef2424153 ("KVM: x86: Query vcpu->vcpu_idx directly and drop its
accessor"), but was unintentionally re-introduced by commit a54d806688fe
("KVM: Keep memslots in tree-based structures instead of array-based ones"),
likely due to a rebase goof.  The wrapper then managed to gain users in
KVM's Xen code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/xen.c       | 10 +++++-----
 include/linux/kvm_host.h |  5 -----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 610beba35907..a0c05ccbf4b1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1049,7 +1049,7 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 	else
 		vcpu->arch.xen.poll_evtchn = -1;
 
-	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask);
+	set_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
 
 	if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports)) {
 		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
@@ -1071,7 +1071,7 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 	*r = 0;
 out:
 	/* Really, this is only needed in case of timeout */
-	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask);
+	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
 
 	if (unlikely(sched_poll.nr_ports > 1))
 		kfree(ports);
@@ -1311,7 +1311,7 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
 	int poll_evtchn = vcpu->arch.xen.poll_evtchn;
 
 	if ((poll_evtchn == port || poll_evtchn == -1) &&
-	    test_and_clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask)) {
+	    test_and_clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask)) {
 		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 		kvm_vcpu_kick(vcpu);
 	}
@@ -1344,7 +1344,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		vcpu = kvm_get_vcpu_by_id(kvm, xe->vcpu_id);
 		if (!vcpu)
 			return -EINVAL;
-		WRITE_ONCE(xe->vcpu_idx, kvm_vcpu_get_idx(vcpu));
+		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
 	}
 
 	if (!vcpu->arch.xen.vcpu_info_cache.active)
@@ -1540,7 +1540,7 @@ int kvm_xen_setup_evtchn(struct kvm *kvm,
 	 */
 	vcpu = kvm_get_vcpu_by_id(kvm, ue->u.xen_evtchn.vcpu);
 	if (vcpu)
-		e->xen_evtchn.vcpu_idx = kvm_vcpu_get_idx(vcpu);
+		e->xen_evtchn.vcpu_idx = vcpu->vcpu_idx;
 	else
 		e->xen_evtchn.vcpu_idx = -1;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c20f2d55840c..ef9ab2cfe66a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -907,11 +907,6 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 	return NULL;
 }
 
-static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
-{
-	return vcpu->vcpu_idx;
-}
-
 void kvm_destroy_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);

base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

