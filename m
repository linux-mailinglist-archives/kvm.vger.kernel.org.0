Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006063B0C38
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhFVSEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbhFVSDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:03:23 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61A8C0610FF
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:12 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 2-20020a3709020000b02903aa9873df32so19081954qkj.15
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pivc7qr4sT4+j8JNTwOxv+4OmDX8fKwSLBhBV0jBRec=;
        b=LOuf/n0b/jOkC5l+HdXmVP2fx3jHAayfatW/ZxJfv7QSu3qjpg4JIH8rFgP6oRLRUu
         SezQXmkFyqC6cuhiG+sqEIcSRc+m8F1kv77AZ4k/7jytk5vO2HXkruApcAaJoVR3+1QT
         gFs3f3BYboxssIi5RubGLwZtoHW54N98O1wf0WKxBRQnlS7AYWtyjDlSwkd/luvYw+Vo
         S1W1L+ERGK3ZIY2jjXLlibdxJzQtgTCRSFapZhKcgQopIoBzBpJjMfn8Qraz6tk5Cta8
         NTeIakwjnIwQ/N0b9nr+kBSiPCs+xD/PqA1417nOMcT+mVNiw3qzOOkKYx6LIsAlkSul
         eCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pivc7qr4sT4+j8JNTwOxv+4OmDX8fKwSLBhBV0jBRec=;
        b=ephWR0cE0/j2EkdBbtT6oWjAPiws0rWmbujved4KGlWeKJ5YKXzq/kwh5OWnYx04DS
         tcRkENjL1xQfICwGARggrF3E/WnHQeffzD2L9f8PURPEuheMwJNz8zH+Vp9l2WiEAoDW
         F0fKYq6gr1AAYMOwNFcQG2cRIMJpfDcKtyTZ3JJnsznGl7Rq/lvNbGKgK3CobDPmChnI
         VoUqDt1/lFL9jDSPTnBT83JPe3IbeGstoW1xVLubiEfE8UT2QvVUYQy8g1lE86tbYdBL
         9NswHhh8LnJX+ma0HhXeKyCTpdbFCTYC4K07k4X+FddZbJtcpcJgwW4LKKYQHHOk4IuA
         sjLQ==
X-Gm-Message-State: AOAM5327R5QcGm4MnCD7hOC+2NVBs4LXMNEICZPoyQ3poPdP8SkdUn4I
        Y1GLelfUsbtv8uv6vKFAVbfgT0IWnkQ=
X-Google-Smtp-Source: ABdhPJwg+YfK5rGt1xANj5+v6A8EJYEtR3MwEoo21FvvNMZSylbJP4YmYXQ6EQwFD8xXHO+jh0xQzxEG0sA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:da8f:: with SMTP id n137mr6440668ybf.520.1624384751889;
 Tue, 22 Jun 2021 10:59:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:18 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-34-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 33/54] KVM: x86/mmu: Use MMU's role to compute PKRU bitmask
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

Use the MMU's role to calculate the Protection Keys (Restrict Userspace)
bitmask instead of pulling bits from current vCPU state.  For some flows,
the vCPU state may not be correct (or relevant), e.g. EPT doesn't
interact with PKRU.  Case in point, the "ept" param simply disappears.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bd412e082356..dcde7514358b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4460,24 +4460,17 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 * away both AD and WD.  For all reads or if the last condition holds, WD
 * only will be masked away.
 */
-static void update_pkru_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				bool ept)
+static void update_pkru_bitmask(struct kvm_mmu *mmu)
 {
 	unsigned bit;
 	bool wp;
 
-	if (ept) {
+	if (!is_cr4_pke(mmu)) {
 		mmu->pkru_mask = 0;
 		return;
 	}
 
-	/* PKEY is enabled only if CR4.PKE and EFER.LMA are both set. */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) || !is_long_mode(vcpu)) {
-		mmu->pkru_mask = 0;
-		return;
-	}
-
-	wp = is_write_protection(vcpu);
+	wp = is_cr0_wp(mmu);
 
 	for (bit = 0; bit < ARRAY_SIZE(mmu->permissions); ++bit) {
 		unsigned pfec, pkey_bits;
@@ -4672,7 +4665,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(context, false);
-	update_pkru_bitmask(vcpu, context, false);
+	update_pkru_bitmask(context);
 	update_last_nonleaf_level(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
 }
@@ -4730,7 +4723,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	if (____is_cr0_pg(regs)) {
 		reset_rsvds_bits_mask(vcpu, context);
 		update_permission_bitmask(context, false);
-		update_pkru_bitmask(vcpu, context, false);
+		update_pkru_bitmask(context);
 		update_last_nonleaf_level(vcpu, context);
 	}
 	context->shadow_root_level = new_role.base.level;
@@ -4838,8 +4831,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->direct_map = false;
 
 	update_permission_bitmask(context, true);
-	update_pkru_bitmask(vcpu, context, true);
 	update_last_nonleaf_level(vcpu, context);
+	update_pkru_bitmask(context);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
@@ -4935,7 +4928,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	}
 
 	update_permission_bitmask(g_context, false);
-	update_pkru_bitmask(vcpu, g_context, false);
+	update_pkru_bitmask(g_context);
 	update_last_nonleaf_level(vcpu, g_context);
 }
 
-- 
2.32.0.288.g62a8d224e6-goog

