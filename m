Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF983B0C16
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhFVSCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhFVSB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:01:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE53C061226
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:40 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id n195-20020a3740cc0000b02903b2ccb7bbe6so2526820qka.20
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3dZybjy6vwU9WfW0H4YoDO4hpVV/AUIoIg4sHYrpcm8=;
        b=D80TzGeFtbzp+OgIhK2zHERLxniKlpWd//90G4A5NN9szTRrAuf1HHhd10pjxv8HUM
         sXISFGUYrWRuAKT6TsZ8bWq958xK7V05X21BEb0fp8t8sKDxQ1Zo8Lg6aaxPkoiB4GNY
         0lzhlee5RKkrjurvphE/x9YYJLLCsQ9drbsYo+c32wPY+/YzhjM43gDEiD9I0zL/KTYA
         Hc3xFbwjsHuvNtRIYPL0AZD952qUVDpbI2sUxBKT2lu3raV5DDy8EQ34v5+3ctnA+wAj
         dHZ/jftE61JWUrRvYp3bdT7LkuhS1BQLMvb2gxpV38LmVRoFKb+TJ1+5zSEJ+jjRr63g
         az8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3dZybjy6vwU9WfW0H4YoDO4hpVV/AUIoIg4sHYrpcm8=;
        b=MsBGy4M04IxDF3R3Rd0rWs4UmHJs7gYpoAZ2XbZShIvY1GTEQbJUXIaMIbwXWohBVx
         XphpOTH9LXjwTdgCb7Vv88n0kZ9qf8lVzhceKhfTKvQ4ZmtxLwyPwJ+ZKYbGM6EyvkzL
         FTonASV2KYd68gMGJt+LOGC93gMeSfCh/CwiW9ruS3nQoxBcvSdomV0o1KtX4Qfbp1t0
         xrqpkR5IWXLad/RteZn8xurlVzV0gqTwokp3WXRM2SuyTonRhNy5ySR3XQ6fIzXW7Rox
         zWdGQ+mjnouUtNkTfO5Bkf860a3Wl2Hgzqy1RprpelLchCpfN6GVlzOmF0JPUaz5w+67
         ZJVQ==
X-Gm-Message-State: AOAM531TRx5pJ6gVtnwuDu9SOjyk2R7ozwZRAsIZSu5ShA1JxPnWB3Vq
        aOVToPy3shA1ADPUF07H47SqpVA0HFg=
X-Google-Smtp-Source: ABdhPJyf7SXRR+kMnblZcElhy/0cxr30tGVPxHF1h18GpS9LWm9iYp5muMU6PIgPPN0gJqMgm/qgnOdS7p0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:7109:: with SMTP id m9mr6679225ybc.274.1624384719700;
 Tue, 22 Jun 2021 10:58:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:04 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-20-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 19/54] KVM: x86/mmu: Grab shadow root level from mmu_role for
 shadow MMUs
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

Use the mmu_role to initialize shadow root level instead of assuming the
level of KVM's shadow root (host) is the same as that of the guest root,
or in the case of 32-bit non-PAE paging where KVM forces PAE paging.
For nested NPT, the shadow root level cannot be adapted to L1's NPT root
level and is instead always the TDP root level because NPT uses the
current host CR0/CR4/EFER, e.g. 64-bit KVM can't drop into 32-bit PAE to
shadow L1's NPT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a46a87b23b0..5e3ee4aba2ff 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3898,7 +3898,6 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
 	context->root_level = 0;
-	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = true;
 	context->nx = false;
 }
@@ -4466,10 +4465,10 @@ static void update_last_nonleaf_level(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
 
 static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 					 struct kvm_mmu *context,
-					 int level)
+					 int root_level)
 {
 	context->nx = is_nx(vcpu);
-	context->root_level = level;
+	context->root_level = root_level;
 
 	reset_rsvds_bits_mask(vcpu, context);
 	update_permission_bitmask(vcpu, context, false);
@@ -4481,7 +4480,6 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
-	context->shadow_root_level = level;
 	context->direct_map = false;
 }
 
@@ -4509,7 +4507,6 @@ static void paging32_init_context(struct kvm_vcpu *vcpu,
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
-	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->direct_map = false;
 }
 
@@ -4669,6 +4666,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	else
 		paging32_init_context(vcpu, context);
 
+	context->shadow_root_level = new_role.base.level;
+
 	context->mmu_role.as_u64 = new_role.as_u64;
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4704,16 +4703,9 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64) {
+	if (new_role.as_u64 != context->mmu_role.as_u64)
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 
-		/*
-		 * Override the level set by the common init helper, nested TDP
-		 * always uses the host's TDP configuration.
-		 */
-		context->shadow_root_level = new_role.base.level;
-	}
-
 	/*
 	 * Redo the shadow bits, the reset done by shadow_mmu_init_context()
 	 * (above) may use the wrong shadow_root_level.
-- 
2.32.0.288.g62a8d224e6-goog

