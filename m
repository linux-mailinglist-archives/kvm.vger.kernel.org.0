Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FB83B0C4B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhFVSFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVSFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:02 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C7C06114B
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:36 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y35-20020a0cb8a30000b0290270c2da88e8so9360283qvf.13
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hRJEGhbhqAfNPA27dpmj7uFB2lkP9w7d+2FH9hTQv88=;
        b=LbT2NueKOHWi3WQ9RrIdxDQukWUrHBAy8KHwwTY0PfGQdvo/rfzzCU/pUOetX+Gt+7
         +ty6lgib0c8N5qi5RRnDTG7Lrm0NODd41wWo5cyiSel2S80Rz2DgY4z2ghdQWEocKCZn
         J+S0yZrGoHEJaADq0l2rrDG6KB2gQE+MRnpq3YZ4D9+ijHqE5gHol4yoaP9R2jezvX+j
         lO8bcI394J4YuhqTck7GPx1Utc8qZfoUCvARNhfeQFL2lDiWWevxpVA5axo7gJK2o19F
         X/WXVBkuWIyivjwh1Mi5IkbEVDx+s02urFIIeQni7sIsf0GC7DtiiEhUz+VdifdMU1kl
         r5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hRJEGhbhqAfNPA27dpmj7uFB2lkP9w7d+2FH9hTQv88=;
        b=CbGIvrmVDTVl6XMbIZdktynK6jvz9QwAqjgfHLRjLG5Q/CKgVaP80epNHmcejtxYIb
         DNOLNOFypwa414nj97N9wyYgsbGzHZY/6EB+/IkR5ZUPhiBeewXECtbNTC7Mhu3nx03j
         zXCmymwZHZ8mFMvojhTQPUI0HfUkSPPENLRqDYNhrK/02vCG2IRU+Fcnqz0EUyj4lefI
         +aQm0BzwKYnzIdIFLuGFPJKAxc/Yw674YkSSIC4ghLUDriGzF83NkLfFNC4+PnoKoSrO
         +7/DftEo16Zy+WR4BJiUWFKJ7Rg6Aeu4UgLX9WYtiHo9fosH/bVsu1UzqI/BplWcuJfu
         0AzQ==
X-Gm-Message-State: AOAM5324Z/RX/DL3PG+dixk5eLmyyAqURwcWoasqVuwa8GIvquCvY1/g
        kpZsMzVEKo7CP2t+Rb20k5zXqbi/seo=
X-Google-Smtp-Source: ABdhPJzluTOXRCgRoqzpFVGxHtv5KgW0UhCZNTXUeKDUhFO4g61nDrIyNf/ErV5RUcJdmrUHVxw8MkXBgnE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a05:6214:14e4:: with SMTP id
 k4mr16630569qvw.3.1624384775081; Tue, 22 Jun 2021 10:59:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:28 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-44-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 43/54] KVM: x86/mmu: Add helper to update paging metadata
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

Consolidate MMU guest metadata updates into a common helper for TDP,
shadow, and nested MMUs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30eb1364fc20..a79871fe5b01 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4507,6 +4507,18 @@ static void update_last_nonleaf_level(struct kvm_mmu *mmu)
 		mmu->last_nonleaf_level++;
 }
 
+static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu)
+{
+	if (!is_cr0_pg(mmu))
+		return;
+
+	reset_rsvds_bits_mask(vcpu, mmu);
+	update_permission_bitmask(mmu, false);
+	update_pkru_bitmask(mmu);
+	update_last_nonleaf_level(mmu);
+}
+
 static void paging64_init_context_common(struct kvm_mmu *context,
 					 int root_level)
 {
@@ -4646,12 +4658,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = paging32_gva_to_gpa;
 	}
 
-	if (is_cr0_pg(context)) {
-		reset_rsvds_bits_mask(vcpu, context);
-		update_permission_bitmask(context, false);
-		update_pkru_bitmask(context);
-		update_last_nonleaf_level(context);
-	}
+	reset_guest_paging_metadata(vcpu, context);
 	reset_tdp_shadow_zero_bits_mask(vcpu, context);
 }
 
@@ -4705,12 +4712,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	else
 		paging32_init_context(context);
 
-	if (____is_cr0_pg(regs)) {
-		reset_rsvds_bits_mask(vcpu, context);
-		update_permission_bitmask(context, false);
-		update_pkru_bitmask(context);
-		update_last_nonleaf_level(context);
-	}
+	reset_guest_paging_metadata(vcpu, context);
 	context->shadow_root_level = new_role.base.level;
 
 	reset_shadow_zero_bits_mask(vcpu, context);
@@ -4899,12 +4901,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	else
 		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
 
-	if (is_cr0_pg(g_context)) {
-		reset_rsvds_bits_mask(vcpu, g_context);
-		update_permission_bitmask(g_context, false);
-		update_pkru_bitmask(g_context);
-		update_last_nonleaf_level(g_context);
-	}
+	reset_guest_paging_metadata(vcpu, g_context);
 }
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
-- 
2.32.0.288.g62a8d224e6-goog

