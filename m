Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D083B0C63
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhFVSH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhFVSG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:06:59 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F58C03540F
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 11:00:00 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w3-20020ac80ec30000b029024e8c2383c1so101884qti.5
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IqH/coxPh0ByAAe8tc78x3ztmN8TTOQkDLtNWwfe75w=;
        b=DZs+osiJDshw77pcrc5vq2d1EvY10o5PpgQ80tI2x4sJk3l67+x33t6zY4B/q2ah3T
         6FzcG+++e9Scl8IAVpYAsFQSiEgLoeS8Dj0RQbfreQ1j5lF/jGl0GIs/tde7hvZZJn/w
         Z5KOR/RHhRkCuKSc4gwR9d7E0gHMclLI19VWY8NOnd4co/3Wl5ESvIiLKMt2E7ZsJzyh
         s9tFz7fOAUk5Clxao2Sd2f1ochsswYBo5tNkKKkTOhr5o/jEjD/+Zmw8RVUHMLh/0egd
         hfmMQaa3KlGUyhZy3szAxfwNoGoBNzNy3/Wm7iOOX/fE5CqTHJcmKtWposnQ0oynuCNK
         zshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IqH/coxPh0ByAAe8tc78x3ztmN8TTOQkDLtNWwfe75w=;
        b=pKd/hvXKLQlc1hXpNOHSDFn670ZDH16GXVISFGLV7QFydeXyFhzE1+8qcF44DuoRWy
         Ip152fR7ZYt4Nz377XuHJDCOnltSWZjPZRVrHaSaT8kqwTZI8x52sP6RIXQlDL7SnIsH
         ruIyruhL2ioXwkapQ8NbGFgzkMsZVCA1DBF9sGnX4RBfMKBBXRMpHnl/f1O5rXrUtGxy
         SVKd4S04UxR+WPTX9f5NpQwJg8AlGrrHPiEPxnl/I96XRG8BjNtollzVdWPFRK/X8Vmq
         EIau/+9Ia+h2wA3+ikdeipdjMl3U4eGZVXuoJzknzO+zd6K/fyZkKiL0SHS6MytK20m/
         /8cA==
X-Gm-Message-State: AOAM5338NKyqVIhvcYE04mghABtRFDAlsGwyaHvAYByhRn0Ls2+NH0eH
        fxSGjj3waqRjg/kkSfpid+B/x9ZxktE=
X-Google-Smtp-Source: ABdhPJwP4Zh3alZPREoZIcweWAzgk0DTf86jxxhCnxkCnpRIQOV32EVth3C48VrQ1ng8hVQ2RwJSEKi9nK0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:cf92:: with SMTP id f140mr5867665ybg.38.1624384799659;
 Tue, 22 Jun 2021 10:59:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:39 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-55-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 54/54] KVM: x86/mmu: Let guest use GBPAGES if supported in
 hardware and TDP is on
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

Let the guest use 1g hugepages if TDP is enabled and the host supports
GBPAGES, KVM can't actively prevent the guest from using 1g pages in this
case since they can't be disabled in the hardware page walker.  While
injecting a page fault if a bogus 1g page is encountered during a
software page walk is perfectly reasonable since KVM is simply honoring
userspace's vCPU model, doing so arguably doesn't provide any meaningful
value, and at worst will be horribly confusing as the guest will see
inconsistent behavior and seemingly spurious page faults.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d4969ac98a4b..684255defb33 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4174,13 +4174,28 @@ __reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 	}
 }
 
+static bool guest_can_use_gbpages(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
+	 * hardware.  The hardware page walker doesn't let KVM disable GBPAGES,
+	 * i.e. won't treat them as reserved, and KVM doesn't redo the GVA->GPA
+	 * walk for performance and complexity reasons.  Not to mention KVM
+	 * _can't_ solve the problem because GVA->GPA walks aren't visible to
+	 * KVM once a TDP translation is installed.  Mimic hardware behavior so
+	 * that KVM's is at least consistent, i.e. doesn't randomly inject #PF.
+	 */
+	return tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
+			     guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
+}
+
 static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
 				context->root_level, is_efer_nx(context),
-				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
+				guest_can_use_gbpages(vcpu),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
 }
@@ -4259,8 +4274,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->shadow_root_level, uses_nx,
-				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
-				is_pse, is_amd);
+				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
 		return;
-- 
2.32.0.288.g62a8d224e6-goog

