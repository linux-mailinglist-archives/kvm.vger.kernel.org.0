Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8648B410281
	for <lists+kvm@lfdr.de>; Sat, 18 Sep 2021 02:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343695AbhIRA65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 20:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245742AbhIRA64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 20:58:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3DAC061574;
        Fri, 17 Sep 2021 17:57:34 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k24so11193717pgh.8;
        Fri, 17 Sep 2021 17:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fZOpI0Kg9/SwIlD9AruKFcQ1gB54Skfl4iNTdeLQxsk=;
        b=gcj1lMhCGb960WHbCZmDbWnmCIQawH5HQPuUyDL1FqU2v+bSGrbp5k0UTeo7P7vQcO
         vekhdBPbDnJp1gu7sBlonFC7qRjyaCKaicXInqlINNppFmxPZhdAwwqiC/E9xc3FJKvp
         eUyI8AJLvt9dNH0fLdfHcG/9wDecB/AuheZjhq0U1A3/ZEC+WG7jxupzrFIMyE/+mceh
         TMdvY5PF0lPzs24jIWKprn7YszAa0twCJleFUNyC83VGHUsFwhul7NSlXr+BELAiaMky
         8+FthGU/dKCfr7iX2I/6WhPCjqx8cNMhetyvl3Lz8GKpR4JnerJElS7QbIR+39hYpnN7
         9DMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fZOpI0Kg9/SwIlD9AruKFcQ1gB54Skfl4iNTdeLQxsk=;
        b=KO4JqUh38iqd/yn04kkBoOrIQO0LKQhwNLV+3+abTI/OGRrdb9+cZSVbeaGFW/9Bug
         AwNm8anNI5OKN7iBYqxGXcJCnY2TSgWlpctUiHPPZcP7D/JEF6XkB63CPxyTwm7cxUDs
         KiLchQYRJwScVQqdgrJRW9e/28eEX6UFqAsIxWxQbvnouwPJWWPEPvXZrwDrYUoBeblm
         Wcfu3eeMksUzLIPFuDYV1stVK4ELgXJYeB6ZhUXIAaIusu/1vKZr3vZbk7vianYkEZPL
         l1n8FFND2tHrEbkgbKM/R1rsVPcLWMwmXSGQTpVA3Y7QYCzf2I7AmamrpYCsIEpT33hr
         7vNA==
X-Gm-Message-State: AOAM530Guqoru0botvLy7Cg4ENjgcs03KtHC5BHGDYGt5mLJbgTDbLtX
        Ht03X5lgQ8IYg5aS3XDqeIa9QiTRLXw=
X-Google-Smtp-Source: ABdhPJwbk09tnMeg41qjh0f52hhNukoj1z39zpZtN02KDU/j2EZxNgb5EXnl9/Ukpe989TOqUAxilA==
X-Received: by 2002:a63:3587:: with SMTP id c129mr12462353pga.127.1631926653208;
        Fri, 17 Sep 2021 17:57:33 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id i7sm362314pgp.39.2021.09.17.17.57.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 17:57:32 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2 09/10] KVM: X86: Don't unsync pagetables when speculative
Date:   Sat, 18 Sep 2021 08:56:35 +0800
Message-Id: <20210918005636.3675-10-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210918005636.3675-1-jiangshanlai@gmail.com>
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

We'd better only unsync the pagetable when there just was a really
write fault on a level-1 pagetable.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c          | 6 +++++-
 arch/x86/kvm/mmu/mmu_internal.h | 3 ++-
 arch/x86/kvm/mmu/spte.c         | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ff52e8354148..e3213d804647 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2577,7 +2577,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
+			    bool speculative)
 {
 	struct kvm_mmu_page *sp;
 	bool locked = false;
@@ -2603,6 +2604,9 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 		if (sp->unsync)
 			continue;
 
+		if (speculative)
+			return -EEXIST;
+
 		/*
 		 * TDP MMU page faults require an additional spinlock as they
 		 * run with mmu_lock held for read, not write, and the unsync
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 658d8d228d43..f5d8be787993 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -116,7 +116,8 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
+			    bool speculative);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3e97cdb13eb7..b68a580f3510 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -159,7 +159,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync)) {
+		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync, speculative)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
-- 
2.19.1.6.gb485710b

