Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0540C3A20E4
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFIXpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhFIXo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:44:58 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807E0C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 16:43:02 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ca13-20020ad4560d0000b029023ebd662003so1202205qvb.17
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ITsTEXIXZfR4GZglAO2blyali5OWfQZ4wyKMhZGD1zU=;
        b=q4yijGpdjTGlevoC5SnN9mqDG878mTfvCHQ5l56bZpLHvufpGtXexLHoR8+Z7j2DXh
         rGnIqdVKv9m5owlAzRpgopaIIWUMYRJEQoOqQoPEPsVl9k0BtA4qBGi9P6smrzQmHsGv
         nyAacDgxBgVoeYAh/20lXc2M0HVdkGr7lMcfPdifYKDq4kj9rYHN4WYRK5l5vMJr6NDo
         uRU0fpdAYLlG+rPDphY66uIIZOpcBMJOdmJpWtE7Tgk+v5ouVFJ+m7kmkyD2Rvr1keV2
         QoyyicDtX0sR5MfxxPoh3SX4IXix9X2yZHN+LQgnDDoVJolOgi6WNNUW9AwAKDO9Sq4T
         EX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ITsTEXIXZfR4GZglAO2blyali5OWfQZ4wyKMhZGD1zU=;
        b=l7Oj8f3IxjW8YDUxQZZ5AHFlX2EIHtUO4Bik6jhtpWMkvWUN0acw2ojxHvGncgp/Iz
         kkSCgR8MEvOmzLcXHDwooM3UhtymjHq+7cNVKnsm2bN1CVWUnQmbXo3S/uszv67NbNbX
         t3Xnr5iyUu9XFTlLUDFcUv776+DCTWmfWV7SwA3EXTgibQ2b+yQPRKCSUd7Vc9qxf3jI
         ya6h9yFqsfTG10SOH3vYnJQE1oFKqIkdo/bWKtrPpeqJQu0khsrDnWVy5hlTMIbl0Pzm
         IUvS5fis5qmGhjpixAZueiQhErqhsBmfeq0gkcbOTK7UmtG/+FT0Gamj4yxX06XYp2tN
         xroQ==
X-Gm-Message-State: AOAM530RKgeTIx1INxnw4NxzH3HlOpqskgI1xiOacrnngXCl6cfKharo
        2q/XWH6OlwL632EytbTi9Ix6MSG9ct8=
X-Google-Smtp-Source: ABdhPJwTG/9fZnINaggj2dmoIUsmhPVmm1t+BG2C4LqlRv1t+8rbK0VeKZxOWz9+KKZa0Zqfvb+RGI/EmsI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:a0c:fec3:: with SMTP id z3mr2517850qvs.57.1623282180796;
 Wed, 09 Jun 2021 16:43:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:28 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 08/15] KVM: nVMX: Consolidate VM-Enter/VM-Exit TLB flush and
 MMU sync logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the dedicated nested_vmx_transition_mmu_sync() now that the MMU sync
is handled via KVM_REQ_TLB_FLUSH_GUEST, and fold that flush into the
all-encompassing nested_vmx_transition_tlb_flush().

Opportunistically add a comment explaning why nested EPT never needs to
sync the MMU on VM-Enter.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 91 +++++++++++----------------------------
 1 file changed, 25 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3fb87e5aead4..6d7c368c92e7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1057,48 +1057,6 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 	}
 }
 
-/*
- * Returns true if the MMU needs to be sync'd on nested VM-Enter/VM-Exit.
- * tl;dr: the MMU needs a sync if L0 is using shadow paging and L1 didn't
- * enable VPID for L2 (implying it expects a TLB flush on VMX transitions).
- * Here's why.
- *
- * If EPT is enabled by L0 a sync is never needed:
- * - if it is disabled by L1, then L0 is not shadowing L1 or L2 PTEs, there
- *   cannot be unsync'd SPTEs for either L1 or L2.
- *
- * - if it is also enabled by L1, then L0 doesn't need to sync on VM-Enter
- *   VM-Enter as VM-Enter isn't required to invalidate guest-physical mappings
- *   (irrespective of VPID), i.e. L1 can't rely on the (virtual) CPU to flush
- *   stale guest-physical mappings for L2 from the TLB.  And as above, L0 isn't
- *   shadowing L1 PTEs so there are no unsync'd SPTEs to sync on VM-Exit.
- *
- * If EPT is disabled by L0:
- * - if VPID is enabled by L1 (for L2), the situation is similar to when L1
- *   enables EPT: L0 doesn't need to sync as VM-Enter and VM-Exit aren't
- *   required to invalidate linear mappings (EPT is disabled so there are
- *   no combined or guest-physical mappings), i.e. L1 can't rely on the
- *   (virtual) CPU to flush stale linear mappings for either L2 or itself (L1).
- *
- * - however if VPID is disabled by L1, then a sync is needed as L1 expects all
- *   linear mappings (EPT is disabled so there are no combined or guest-physical
- *   mappings) to be invalidated on both VM-Enter and VM-Exit.
- *
- * Note, this logic is subtly different than nested_has_guest_tlb_tag(), which
- * additionally checks that L2 has been assigned a VPID (when EPT is disabled).
- * Whether or not L2 has been assigned a VPID by L0 is irrelevant with respect
- * to L1's expectations, e.g. L0 needs to invalidate hardware TLB entries if L2
- * doesn't have a unique VPID to prevent reusing L1's entries (assuming L1 has
- * been assigned a VPID), but L0 doesn't need to do a MMU sync because L1
- * doesn't expect stale (virtual) TLB entries to be flushed, i.e. L1 doesn't
- * know that L0 will flush the TLB and so L1 will do INVVPID as needed to flush
- * stale TLB entries, at which point L0 will sync L2's MMU.
- */
-static bool nested_vmx_transition_mmu_sync(struct kvm_vcpu *vcpu)
-{
-	return !enable_ept && !nested_cpu_has_vpid(get_vmcs12(vcpu));
-}
-
 /*
  * Load guest's/host's cr3 at nested entry/exit.  @nested_ept is true if we are
  * emulating VM-Entry into a guest with EPT enabled.  On failure, the expected
@@ -1125,18 +1083,9 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		}
 	}
 
-	if (!nested_ept) {
+	if (!nested_ept)
 		kvm_mmu_new_pgd(vcpu, cr3);
 
-		/*
-		 * A TLB flush on VM-Enter/VM-Exit flushes all linear mappings
-		 * across all PCIDs, i.e. all PGDs need to be synchronized.
-		 * See nested_vmx_transition_mmu_sync() for more details.
-		 */
-		if (nested_vmx_transition_mmu_sync(vcpu))
-			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-	}
-
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
@@ -1172,18 +1121,29 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * If VPID is disabled, linear and combined mappings are flushed on
-	 * VM-Enter/VM-Exit, and guest-physical mappings are valid only for
-	 * their associated EPTP.
-	 */
-	if (!enable_vpid)
-		return;
-
 	/*
 	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
-	 * for *all* contexts to be flushed on VM-Enter/VM-Exit.
+	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
+	 * full TLB flush from the guest's perspective.  This is required even
+	 * if VPID is disabled in the host as KVM may need to synchronize the
+	 * MMU in response to the guest TLB flush.
 	 *
+	 * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
+	 * EPT is a special snowflake, as guest-physical mappings aren't
+	 * flushed on VPID invalidations, including VM-Enter or VM-Exit with
+	 * VPID disabled.  As a result, KVM _never_ needs to sync nEPT
+	 * entries on VM-Enter because L1 can't rely on VM-Enter to flush
+	 * those mappings.
+	 */
+	if (!nested_cpu_has_vpid(vmcs12)) {
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
+	}
+
+	/* L2 should never have a VPID if VPID is disabled. */
+	WARN_ON(!enable_vpid);
+
+	/*
 	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
 	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
 	 * a VPID for L2, flush the current context as the effective ASID is
@@ -1195,13 +1155,12 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	 *
 	 * If a TLB flush isn't required due to any of the above, and vpid12 is
 	 * changing then the new "virtual" VPID (vpid12) will reuse the same
-	 * "real" VPID (vpid02), and so needs to be sync'd.  There is no direct
+	 * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
 	 * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
-	 * all nested vCPUs.
+	 * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
+	 * guest-physical mappings, so there is no need to sync the nEPT MMU.
 	 */
-	if (!nested_cpu_has_vpid(vmcs12)) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
-	} else if (!nested_has_guest_tlb_tag(vcpu)) {
+	if (!nested_has_guest_tlb_tag(vcpu)) {
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 	} else if (is_vmenter &&
 		   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
-- 
2.32.0.rc1.229.g3e70b5a671-goog

