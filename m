Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0938B3B0C40
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhFVSEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhFVSEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:12 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A49C0604CB
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:21 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so19031740qkc.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GFmSqL1fRu1x77v6GuXyeRAd8lytkFiB6WoZ78NJftw=;
        b=h8rKZtqgcHWYDg6qYyOxcz5EXRhV7X7mk5TWb1CDO+/bWd0H1HZ3pw50iIQX4bz3c6
         nQ+pfAFc99yXSG6lCHTjJd3VGPvS2TQJqeyUjE9s1vyYpGERitUZObd7VBOjLUov3w8U
         zmDyHVpOpnhGFyTSTA6YYya0vXr2YLGWqRybmpkf5xTgVv1XmS231qLr6vDQL3bF8yml
         PnbNMf3Jem+GsQgAreft00w7MZDSptyrHnlBDnZO1vIu4KXFcw0QhQ4IRBsIQXHlp60Y
         Um8WOXlYY89+qte2GKxLXCAhFPg3APbntPckSTx5GEHhNiFZ6ffOIZJ37pl2olysLMug
         B7lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GFmSqL1fRu1x77v6GuXyeRAd8lytkFiB6WoZ78NJftw=;
        b=F3U75k3d1k5g24S/alUNaD3awHFlivwvy9DwM6wkEcQb+rjcZamCgUivxsjWVj3Kw1
         RsLD9aCSyXqP0T2eN7z1FYylrFTgtfnON2EiPW2zoHamVYLiQy290kp5sw6AkS04h2Jh
         0kXxO1bwhWE+veOwlNkTkAt893G/VQ4d0Sdjr/45hObzDfBZziIKUnNufQD1QTBBo6lJ
         W3flAAPSBRtsKXbB4POKYHHwrHRwfPDp4t1/LWYx3xxZquzvqMbhvr/okHSdTjc0+i9g
         HyTboT/V7f2ao+z4qpR6QQMt8LLQ1aYf+mPxPczWKefwXmnZ4BhC1v12TkozWZ95MxFM
         SfwA==
X-Gm-Message-State: AOAM532OiG3zk98Vi/mSCd/CvgovQgDoUBTxWdh8Ez3DOXI/rBbJVWsl
        o8p78ADCHETg0m0hAwNbPgqunDiXZNY=
X-Google-Smtp-Source: ABdhPJxb9mJtgwKjWHe9lS4lXfoF74aK0R3gmHDbTDDxAJcbJV/tSyQ6pl8euCgd6zj/1MHVAFHr9aQbt8U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:2d0b:: with SMTP id t11mr7180655ybt.106.1624384760559;
 Tue, 22 Jun 2021 10:59:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:22 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-38-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 37/54] KVM: x86/mmu: Use MMU's role to get EFER.NX during MMU configuration
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get the MMU's effective EFER.NX from its role instead of using the
one-off, dedicated flag.  This will allow dropping said flag in a
future commit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30cbc6cdb0db..eb6386bcc2ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4212,7 +4212,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
-				context->root_level, context->nx,
+				context->root_level, is_efer_nx(context),
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
@@ -4278,7 +4278,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	 * NX can be used by any non-nested shadow MMU to avoid having to reset
 	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
 	 */
-	bool uses_nx = context->nx || !tdp_enabled;
+	bool uses_nx = is_efer_nx(context) || !tdp_enabled;
 
 	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
 	bool is_amd = true;
@@ -4375,6 +4375,7 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 	bool cr4_smep = is_cr4_smep(mmu);
 	bool cr4_smap = is_cr4_smap(mmu);
 	bool cr0_wp = is_cr0_wp(mmu);
+	bool efer_nx = is_efer_nx(mmu);
 
 	for (byte = 0; byte < ARRAY_SIZE(mmu->permissions); ++byte) {
 		unsigned pfec = byte << 1;
@@ -4400,7 +4401,7 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 			u8 kf = (pfec & PFERR_USER_MASK) ? 0 : u;
 
 			/* Not really needed: !nx will cause pte.nx to fault */
-			if (!mmu->nx)
+			if (!efer_nx)
 				ff = 0;
 
 			/* Allow supervisor writes if !cr0.wp */
-- 
2.32.0.288.g62a8d224e6-goog

