Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C804749B119
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbiAYKCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiAYJ7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:25 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52148C061747;
        Tue, 25 Jan 2022 01:59:25 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h23so17806688pgk.11;
        Tue, 25 Jan 2022 01:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sFcu61MZ2RkaH+ZyWsgAfQkoqzX6pbxtu6BZspxx0Xc=;
        b=QT54k1tCufiOx+YVxE6HumrP+DNXKuk5L+k+bjRS0b2lw1vWHg8wr5sYQ2uUxoFexl
         DIwVskQW4gsK2jXahHsK53XODLiZAsfYdSZGP9rpCiyhFh3769ccPuYXWSZci5StAKf9
         uiI8Hhs0PVvrrFO+66DdGOuKaa03btdF17R4JaWwJGw+JYBF2m+fcCcMf7rjJgy7A/OZ
         PlppjIIwNKSGcsxteWYCXJ55c+EoJg8d7k8o6EebGgW8RWvtwM9qwogKUW5nry7r81Iv
         ssHvaD2ENoU3mhjVBg7xOKuAsWjnT0egZn/K7ticw2I0tWsYGmkjLEmu6wJjlE6LVJ74
         ixrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sFcu61MZ2RkaH+ZyWsgAfQkoqzX6pbxtu6BZspxx0Xc=;
        b=FL+Yhyoko8+80DSfTEQ0vEnT6DpIIF/ucKV6g1gGYw0Vj/LjKZNE+L7ynw/CYfg4jX
         JAHgm0yYthSECgbnOKDaEKVHbVaQIXnpLCFa8olSco34zhJccfWaH2Qk/olfXkF5fNMs
         bULgvDrULZjwH+QSGyZwv8xRjAuJAIpT6k4lEWYIVd41USksNN4VNvfzM7MP4mDxGsyg
         49Z/zzHtzf5V55GUeOc9I7GRPGZINHaA31v+QtPZ7HbkWRBUmESurrrc9ssJD5UQoNXa
         hYotKZfMsIg42jVOy2fOYbGHVfqLl39Pl8+TcQ8ABoN+QKy6KVQ+3RpMAK1wFw38eFn6
         ARng==
X-Gm-Message-State: AOAM531I/Yz5pXbwSfOIOiKmcabQ0zwRh+AigV1nC+VQDu+zYG9eyQN3
        HcrKNfY6RPHuhsti2kdkF/8=
X-Google-Smtp-Source: ABdhPJwquQamYHSxsC3lEIS7IKvKf6wBEC/mw7iq2LyFO56MVpNoYvwYoPIF2BtEN9I1Oi/rzpa04A==
X-Received: by 2002:a63:2262:: with SMTP id t34mr14735801pgm.341.1643104764866;
        Tue, 25 Jan 2022 01:59:24 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:24 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] KVM: x86/mmu: Remove unused "vcpu" of reset_{tdp,ept}_shadow_zero_bits_mask()
Date:   Tue, 25 Jan 2022 17:58:53 +0800
Message-Id: <20220125095909.38122-4-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of reset_ept_shadow_zero_bits_mask()
and reset_tdp_shadow_zero_bits_mask() is not used, so remove it.

No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bb9791564ca9..b29fc88b51b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4473,8 +4473,7 @@ static inline bool boot_cpu_is_amd(void)
  * possible, however, kvm currently does not do execution-protection.
  */
 static void
-reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-				struct kvm_mmu *context)
+reset_tdp_shadow_zero_bits_mask(struct kvm_mmu *context)
 {
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
@@ -4505,8 +4504,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
  * is the shadow page table for intel nested guest.
  */
 static void
-reset_ept_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-				struct kvm_mmu *context, bool execonly)
+reset_ept_shadow_zero_bits_mask(struct kvm_mmu *context, bool execonly)
 {
 	__reset_rsvds_bits_mask_ept(&context->shadow_zero_check,
 				    reserved_hpa_bits(), execonly,
@@ -4793,7 +4791,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = paging32_gva_to_gpa;
 
 	reset_guest_paging_metadata(vcpu, context);
-	reset_tdp_shadow_zero_bits_mask(vcpu, context);
+	reset_tdp_shadow_zero_bits_mask(context);
 }
 
 static union kvm_mmu_role
@@ -4947,7 +4945,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	update_permission_bitmask(context, true);
 	context->pkru_mask = 0;
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
-	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
+	reset_ept_shadow_zero_bits_mask(context, execonly);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-- 
2.33.1

