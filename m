Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A76444CCD1
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhKJWdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbhKJWdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:47 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DF7C06127A
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:59 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l10-20020a17090a4d4a00b001a6f817f57eso1808798pjh.3
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LbThUuaOpzCbOzZAIPBZcmEtqbOiPlEJtesgwMaSYDQ=;
        b=GdALKheein9Cb85IAuoDwJOYJGpvSzm5GwacVa/XVjVCJl1ynuK+EpRV3FPQMTk9CY
         9THiBOiwH1i4LGVI97p6IPgtVpxwEkZy9Mtvs6Ih1BjdW80NRz43d0dlyG739eeZ666F
         ghqI8TdJmMwDdm2sify4R0wlPK7OVgv5K0iCLdiK0B406bBxCvjmd7gcFjZseXynMAHn
         UpZ/FahkjP9LPAUzx8xeLTKs98McpM+9hGDrgJK1DX/e8ezLHlPe9JLayL7KL4ijA157
         JzY89qViwsCprqSzX1+rheQPZNA0F8CzdLSQ4x7FnZIM15Gcjbj4v7E0BluWlP7pMBY4
         wXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LbThUuaOpzCbOzZAIPBZcmEtqbOiPlEJtesgwMaSYDQ=;
        b=DY7zjX+glBa9UqT9UPOv1UQwqI2lUZbeew6OswOUSm1vYqGWwvNKaFT5SDdI5ngnim
         o4bjYNEVSJ0WRQLUY1PQ0ForFKq8Bfp/LGZzXQ4mKkcoiOwPNbLVrA3INQZwqHdBnfxc
         ZFjaPzEo55CYGOgBmjdUTv0V/BjaFlnVtYlHLykVuF5y6X2dFLFrvm/R2svRIChK/eg8
         dj5/8MlubnIk2EuJlYy75RaE3hldSRPvK+s9pZAGVEA1boVhfin4+/v9pLEWPgwvhvux
         1GUHIVMutz3xqxcYayRdhJPuMVirrzUbNjBETX4hRyxBF7hK01xUqu7Dvozeyf3zTNpF
         iOUw==
X-Gm-Message-State: AOAM532eAv5pwsuPbet/Khut3Z5UbQr0+k979cyVTbXwmwQp0T9/Qdo1
        WLxetNk5qScWVGm1D12EzMq2C9rB10b2
X-Google-Smtp-Source: ABdhPJwVt+Qc1aJV9QEwJFviIGlNtIREHh7km4Ycaep0pTfsFtmaYAT/hX7M+OXMOkXF8niNc+7/1tfKcBRF
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90b:384d:: with SMTP id
 nl13mr2941669pjb.80.1636583459164; Wed, 10 Nov 2021 14:30:59 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:04 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-14-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 13/19] KVM: x86/mmu: Factor out the meat of reset_tdp_shadow_zero_bits_mask
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the implementation of reset_tdp_shadow_zero_bits_mask to a
helper function which does not require a vCPU pointer. The only element
of the struct kvm_mmu context used by the function is the shadow root
level, so pass that in too instead of the mmu context.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e890509b93f..fdf0f15ab19d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4450,17 +4450,14 @@ static inline bool boot_cpu_is_amd(void)
  * possible, however, kvm currently does not do execution-protection.
  */
 static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-				struct kvm_mmu *context)
+build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
+				int shadow_root_level)
 {
-	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-	shadow_zero_check = &context->shadow_zero_check;
-
 	if (boot_cpu_is_amd())
 		__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
-					context->shadow_root_level, false,
+					shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
 					false, true);
 	else
@@ -4470,12 +4467,20 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	if (!shadow_me_mask)
 		return;
 
-	for (i = context->shadow_root_level; --i >= 0;) {
+	for (i = shadow_root_level; --i >= 0;) {
 		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
 		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
 	}
 }
 
+static void
+reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
+				struct kvm_mmu *context)
+{
+	build_tdp_shadow_zero_bits_mask(&context->shadow_zero_check,
+					context->shadow_root_level);
+}
+
 /*
  * as the comments in reset_shadow_zero_bits_mask() except it
  * is the shadow page table for intel nested guest.
-- 
2.34.0.rc0.344.g81b53c2807-goog

