Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71AA3B0C33
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhFVSDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhFVSDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:03:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16900C061A31
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d12-20020ac8668c0000b0290246e35b30f8so35081qtp.21
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=H8ArnWlUNfoAxDJNt3hI336FC1ZAyBAzOuUBrFRlP+c=;
        b=Bnv/Cqw3SGOaMwXrlE5IAjRdvibUZQO8cQGd0wND0ys5E1f5JsNoZWowJ9r18xA0Xv
         RWvITiqcwT9afAr4UHD9PKLMYehdKpU8F1eKy0vqvShSL0NiJtDNI5QM6GgSrypwHKA2
         MMT7ERrOit0WNsvi2nBgoOskdg8K5emIPBSWJFy1ZJJkJZrlvwi2jmNn/n7l7HJRZtp9
         Qvt9doF6vHYsAZhQaXPk/N8zFt0BwOtUGHrHVcLEBOpXriOsL+2lxxOU+epq0nrP2aCZ
         KoDMFj8HyCW/KBWUS9/iMqdzhsc2h1HqwLTw0iD4l2w37GD7vyeM3uM/8jEWFdakn/Nr
         vSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=H8ArnWlUNfoAxDJNt3hI336FC1ZAyBAzOuUBrFRlP+c=;
        b=fhWL79YF6oKQu0oBO5U39AIwhIYbkyKV+JVvfv5B2HeaJ2YP3fnZvqk1ER5DL9JUHW
         TegBE25Hz9P99HU2ZYChgTAKxLqBlta38w1MycBtKRQ0tHDCZQIy+jPI9Ye6d13M1XM0
         PApX1Zel6yLh0H/sE4qj5GOBvDtGfo/2PF/brd3DYOrPf4YFjj5XHJxt23iy+dFSqO9Z
         Bx5h4xnf1IdZ5lWwNN4vfx59r5Fvyn/Hw38w4f6sKvOGtZYl6hphfcHBfO8vVazP2scg
         +tu1H7iKXBETNYJtgviGLweBU9F+D/vCJhLkZcgu6FGXvbJrHSmLrEXU7eZjr0LIUva0
         n76g==
X-Gm-Message-State: AOAM531BCxjswAYqYbaC/Arfw8Aux05sjz4tyxPPSXcuiZDHfTfZKCFC
        PEeFDNu9IzqQyjRNwhffTYbBgI/y33o=
X-Google-Smtp-Source: ABdhPJy7prasZnVsVu93Mki513dM4gcsPMBYy1gDNHzMWo2A+0gIm7DNpjphZgOl8rawhlsX+kVCfpmA4GA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:8607:: with SMTP id y7mr6676021ybk.17.1624384747179;
 Tue, 22 Jun 2021 10:59:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:16 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-32-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 31/54] KVM: x86/mmu: Drop vCPU param from reserved bits calculator
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

Drop the vCPU param from __reset_rsvds_bits_mask() as it's now unused,
and ideally will remain unused in the future.  Any information that's
needed by the low level helper should be explicitly provided as it's used
for both shadow/host MMUs and guest MMUs, i.e. vCPU state may be
meaningless or simply wrong.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e912d9a83e22..c3bf5d4186e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4119,8 +4119,7 @@ static inline bool is_last_gpte(struct kvm_mmu *mmu,
 #undef PTTYPE
 
 static void
-__reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
-			struct rsvd_bits_validate *rsvd_check,
+__reset_rsvds_bits_mask(struct rsvd_bits_validate *rsvd_check,
 			u64 pa_bits_rsvd, int level, bool nx, bool gbpages,
 			bool pse, bool amd)
 {
@@ -4212,7 +4211,7 @@ __reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
-	__reset_rsvds_bits_mask(vcpu, &context->guest_rsvd_check,
+	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
 				context->root_level, context->nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
@@ -4292,8 +4291,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	WARN_ON_ONCE(context->shadow_root_level < PT32E_ROOT_LEVEL);
 
 	shadow_zero_check = &context->shadow_zero_check;
-	__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-				reserved_hpa_bits(),
+	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->shadow_root_level, uses_nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse, is_amd);
@@ -4328,8 +4326,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	shadow_zero_check = &context->shadow_zero_check;
 
 	if (boot_cpu_is_amd())
-		__reset_rsvds_bits_mask(vcpu, shadow_zero_check,
-					reserved_hpa_bits(),
+		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 					context->shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
-- 
2.32.0.288.g62a8d224e6-goog

