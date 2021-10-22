Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625F6436F04
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJVAvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhJVAvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 20:51:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FA9C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so2213661yba.11
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 17:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zAlLHoW+/UWSIgBF8f8U1vIlbDY/y6L+gJgFXs+sPxE=;
        b=S0RhVxjB1Wo/yOzZTb5f1CnLnkAkLr79rT8KMKgkbmdFqPccf7mZHnYMsbmqvFjobo
         S7yA3+EaYGrJDQ/4Ffalnrtg7UpVhEQNjWrqgyOqXTo2Gieryyap7jLeqFqvPdrTLz8S
         vCq60ymXOF+5l40jvwyNWAnrn37kUdN2nrz2vSzwp2jX9LsEsi4eyos6ccB2+rtdd2Kg
         ZDvMnA0ge9QhzlaWVIRS7mH5i7tAcybZRqpQ05wMFc6DG6XTYUePut/lIXkvs2hb1grf
         L9z/t0RuawOJBRsAnOY5VLeMmJLUvrVl/HhoXUM+SayQx5T3tgi/3pOSXbEctiM2ZkSk
         IsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zAlLHoW+/UWSIgBF8f8U1vIlbDY/y6L+gJgFXs+sPxE=;
        b=HNdliu/wAeTKZc0GKEZv21OHUdlWbdFEMZ6sv+74zMlYugj3idIwde5kaP975G4Nn2
         lKwgqh8DwnsERXKWrDDhm+tccrShO6E8XF03Sfju2wgFyRFSBPH/zsm5+tZ+tDzU2Oqt
         KdSy7pmPDZgbfAF5dOuef1ZgYg919IY9MXB56fxTimcySm/++7br5SitxcmDTLM1Q1F9
         SDoelcJC9M0uzu61+IYc/a3eVyf/NLuENvPCXF0VJxReEmZc0/fMCNCyC0lSC0JoeXnY
         r2GCGnCSnjim1rjDeEYncuMI2gQ8mTuRKJYThVbWoSFzE0COFgXa2joU8W4lnw06spPg
         4YjQ==
X-Gm-Message-State: AOAM532LouoAMunrsjLArhS/9zloovp7lx2YWT1voDGh13qIEhSawjtb
        Dtu5edgFUZgxxpzSq+2y28rpqt+TTQU=
X-Google-Smtp-Source: ABdhPJzE8/0GOKsH+J1FGlagWki612oU7RRmK0uz/ACvkjgw7Ou4i08OidFCoVSNcOcJ4KDQWZ/pr94HamE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a5b:cce:: with SMTP id e14mr6917124ybr.486.1634863772008;
 Thu, 21 Oct 2021 17:49:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 17:49:24 -0700
In-Reply-To: <20211022004927.1448382-1-seanjc@google.com>
Message-Id: <20211022004927.1448382-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211022004927.1448382-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 1/4] KVM: x86/mmu: Use vCPU's APICv status when handling
 APIC_ACCESS memslot
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query the vCPU's APICv state, not the overall VM's state, when handling
a page fault that hit the APIC Access Page memslot.  While the vCPU
state can be stale with respect to the overall VM APICv state, it's at
least coherent with respect to the page fault being handled, i.e. is the
value of the vCPU's APICv enabling at the time of the fault.

Using the VM's state is not functionally broken, but neither does it
provide any meaningful advantages, and arguably retrying the faulting
instruction, as will happen if the vCPU state is stale (see below), is
semantically the desired behavior as it aligns with existing KVM MMU
behavior where a change in VM state invalidates the context for handling
a page fault.

The vCPU state can be stale if a different vCPU (or other actor) toggles
APICv state after the page fault exit from the guest, in which case KVM
will attempt to handle the page fault prior to servicing the pending
KVM_REQ_APICV_UPDATE.  However, by design such a race is benign in all
scenarios.

If APICv is globally enabled but locally disabled, the page fault handler
will go straight to emulation (emulation of the local APIC is ok even if
APIC virtualization is enabled while the guest is running).

If APICv is globally disabled but locally enabled, there are two possible
scenarios, and in each scenario the final outcome is correct: KVM blocks
all vCPUs until SPTEs for the APIC Access Page have been zapped.

  (1) the page fault acquires mmu_lock before the APICv update calls
      kvm_zap_gfn_range().  The page fault will install a "bad" SPTE, but
      that SPTE will never be consumed as (a) no vCPUs can be running in
      the guest due to the kick from KVM_REQ_APICV_UPDATE, and (b) the
      "bad" SPTE is guaranteed to be zapped by kvm_zap_gfn_range() before
      any vCPU re-enters the guest.  Because KVM_REQ_APICV_UPDATE is
      raised before the VM state is update, all vCPUs will block on
      apicv_update_lock when attempting to service the request until the
      lock is dropped by the update flow, _after_ the SPTE is zapped.

  (2) the APICv update kvm_zap_gfn_range() acquires mmu_lock before the
      page fault.  The page fault handler will bail due to the change in
      mmu_notifier_seq made by kvm_zap_gfn_range().

Arguably, KVM should not (attempt to) install a SPTE based on state that
is knowingly outdated, but using the per-VM state suffers a similar flaw
as not checking for a pending KVM_REQ_APICV_UPDATE means that KVM will
either knowingly install a SPTE that will get zapped (page fault wins the
race) or will get rejected (kvm_zap_gfn_range() wins the race).  However,
adding a check for KVM_REQ_APICV_UPDATE is extremely undesirable as it
implies the check is meaningful/sufficient, which is not the case since
the page fault handler doesn't hold mmu_lock when it checks APICv status,
i.e. the mmu_notifier_seq mechanism is required for correctness.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f9f228963088..6530d874f5b7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3911,10 +3911,35 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		 * If the APIC access page exists but is disabled, go directly
 		 * to emulation without caching the MMIO access or creating a
 		 * MMIO SPTE.  That way the cache doesn't need to be purged
-		 * when the AVIC is re-enabled.
+		 * when the AVIC is re-enabled.  Note, the vCPU's APICv state
+		 * may be stale if an APICv update is in-progress, but KVM is
+		 * guaranteed to operate correctly in all scenarios:
+		 *
+		 * 1.  APICv is globally enabled but locally disabled.  This
+		 *     vCPU will go straight to emulation without touching the
+		 *     MMIO cache or installing a SPTE.
+		 *
+		 * 2a. APICv is globally disabled but locally enabled, and this
+		 *     vCPU acquires mmu_lock before the APICv update calls
+		 *     kvm_zap_gfn_range().  This vCPU will install a bad SPTE,
+		 *     but the SPTE will never be consumed as (a) no vCPUs can
+		 *     be running due to the kick from KVM_REQ_APICV_UPDATE,
+		 *     and (b) the "bad" SPTE is guaranteed to be zapped by
+		 *     kvm_zap_gfn_range() before any vCPU re-enters the guest.
+		 *     Because KVM_REQ_APICV_UPDATE is raised before the VM
+		 *     state is update, vCPUs will block on apicv_update_lock
+		 *     when attempting to service the request until the lock is
+		 *     dropped by the update flow, _after_ the SPTE is zapped.
+		 *
+		 * 2b. APICv is globally disabled but locally enabled, and the
+		 *     APICv update kvm_zap_gfn_range() acquires mmu_lock before
+		 *     this vCPU.  This vCPU will bail from the page fault
+		 *     handler due kvm_zap_gfn_range() bumping mmu_notifier_seq,
+		 *     and will retry the faulting instruction after servicing
+		 *     the KVM_REQ_APICV_UPDATE request.
 		 */
 		if (slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
-		    !kvm_apicv_activated(vcpu->kvm)) {
+		    !kvm_vcpu_apicv_active(vcpu)) {
 			*r = RET_PF_EMULATE;
 			return true;
 		}
-- 
2.33.0.1079.g6e70778dc9-goog

