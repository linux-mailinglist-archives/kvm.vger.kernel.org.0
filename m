Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B57E325803
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBYUvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbhBYUtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:49:46 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C33CC0617AB
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:17 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id k4so5230376qvf.8
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DM1qAEmP5vcSYf3rgtbYxteKXUrb+lcNyYCUDv3yLOQ=;
        b=jFieCwfy3h6lwGBHiM8luxx6QrR+gEE6E5SrdJyhG1HUzaUWgCNyBY5g5OBj5LoL78
         SQ3SNHuUzw+lziT3yp3jICHEgZtR7Q0Od+Mglfp324M4pTprI8vz8uKDXz8se9nywHj8
         I7TMwaB+3ElDgNUTqkX7LGxaFWKrAtZr3uDb/hOp/YQieDkqOGg/cBiaKNkfcnp7GptT
         vJ+WQRvUqNhtENU8c3zF3S87AHqfaw0/mmkJeL+6v++6+Zwp48BWVuJDpGRln28I6GfP
         BGPydtbj3SZAHzV1Vqm1iwNvDZOyCsQRLva+TDWvU4R8stNQ6C25AsPyxy3Y7/vQ7avr
         s+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DM1qAEmP5vcSYf3rgtbYxteKXUrb+lcNyYCUDv3yLOQ=;
        b=MlCI3N6bsIgCrLGvJe5X15Qu0Y1geJmQ4Lo8b5dN0N/GPI/C5o6v9PoOR3LgSBTrmq
         YABs6fuSZzmjGEuCs80jr1xFP0iiZmUkKRL9gdiL2COUcsYW7hxGMWCPcM8nNVSFmpzP
         JFXaGKyQrywrUY7o4IWz1OyXbdNj50nJPQlhUXNzsT7DGS+tLtaGTutgDRRS29k7euuq
         K0RPoN8mgKwEsyDCo4tXtflnU5Ol7sSxzq7EcXubiJwunoQkMSdVeo5kN43SJM97+Akx
         PQ1JBPaw2++ahjBARHGMBXv9+dyzzVh345ZBvrhQlU+NO//7RACUwsxpLUQEN5dsUWmn
         J8DA==
X-Gm-Message-State: AOAM532nHKKnqQBcNuY/DkrGlnVV17wpf5+awvFDr74fpV8qAbj9iQqa
        AJGRBtr7AJeGd9X2NbLz3rdRk1bBM1U=
X-Google-Smtp-Source: ABdhPJxT6pBdGVJUan0VMfxpqpDlOWmP38QMUiqE51EoL0OYKpibDAY3S8ka0tGPT9m+ik4osCDk0BYQGb0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a0c:b526:: with SMTP id d38mr4582364qve.7.1614286096636;
 Thu, 25 Feb 2021 12:48:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:32 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 07/24] KVM: x86/mmu: Handle MMIO SPTEs directly in mmu_set_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that it should be impossible to convert a valid SPTE to an MMIO SPTE,
handle MMIO SPTEs early in mmu_set_spte() without going through
set_spte() and all the logic for removing an existing, valid SPTE.
The other caller of set_spte(), FNAME(sync_page)(), explicitly handles
MMIO SPTEs prior to calling set_spte().

This simplifies mmu_set_spte() and set_spte(), and also "fixes" an oddity
where MMIO SPTEs are traced by both trace_kvm_mmu_set_spte() and
trace_mark_mmio_spte().

Note, mmu_spte_set() will WARN if this new approach causes KVM to create
an MMIO SPTE overtop a valid SPTE.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37c68abc54b8..4a24beefff94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -236,17 +236,6 @@ static unsigned get_mmio_spte_access(u64 spte)
 	return spte & shadow_mmio_access_mask;
 }
 
-static bool set_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
-			  kvm_pfn_t pfn, unsigned int access)
-{
-	if (unlikely(is_noslot_pfn(pfn))) {
-		mark_mmio_spte(vcpu, sptep, gfn, access);
-		return true;
-	}
-
-	return false;
-}
-
 static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 {
 	u64 kvm_gen, spte_gen, gen;
@@ -2561,9 +2550,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	struct kvm_mmu_page *sp;
 	int ret;
 
-	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
-		return 0;
-
 	sp = sptep_to_sp(sptep);
 
 	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
@@ -2593,6 +2579,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	pgprintk("%s: spte %llx write_fault %d gfn %llx\n", __func__,
 		 *sptep, write_fault, gfn);
 
+	if (unlikely(is_noslot_pfn(pfn))) {
+		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
+		return RET_PF_EMULATE;
+	}
+
 	if (is_shadow_present_pte(*sptep)) {
 		/*
 		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
@@ -2626,9 +2617,6 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn,
 				KVM_PAGES_PER_HPAGE(level));
 
-	if (unlikely(is_mmio_spte(*sptep)))
-		ret = RET_PF_EMULATE;
-
 	/*
 	 * The fault is fully spurious if and only if the new SPTE and old SPTE
 	 * are identical, and emulation is not required.
-- 
2.30.1.766.gb4fecdf3b7-goog

