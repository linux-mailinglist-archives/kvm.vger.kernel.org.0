Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF623F688D
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241280AbhHXSAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 14:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbhHXSAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 14:00:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC1C0E56B5;
        Tue, 24 Aug 2021 10:40:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so2356843pjb.1;
        Tue, 24 Aug 2021 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAE5yTJRw6nBnT3NDMYKf0lO0HsM6MD7ZAUs+Qxrxdo=;
        b=qHc1MzXMh9BICBEj+LBI2CJGYybR3PU2mIS0KKSjnQcsEt+LNM5Bl3Jk9xQDfj5reE
         t1HUvnJYhjrENMLAGuaBnrnzC4wjLQ2ViAHRKL/AbGPYdIeEIV/UYca8V2xyLDdSHopH
         0pU6RGseeT0K8rUPrHhTyvctCkJ7LYIHjGqBaItsDf4iau14sDPU8KYgf8mU2uZhyd4A
         3pw4lYtOQRZEojlNCG9aw077sFCms0fHeOrYsBW9xFusfB8SQqw8984UCUBEYaVrBblC
         NnPUt7i2PvYMv3b5Eaj9z76AOKpXx5iyBKurcvRr4m5aB0a3Z1osLoTrhvvtjHfb8XX8
         nFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAE5yTJRw6nBnT3NDMYKf0lO0HsM6MD7ZAUs+Qxrxdo=;
        b=XwjYYUPBUcBVH/tCDMUoJ+Jf61s46fgjbfJtBzkPO9LiNxdUjoMsZLfq/dMC5qVZXJ
         qJk2SI03vsL4xvrVZzJRQS+lpGJTAjM+Gkf010e9ZoBMLoz3xJEQxf46HI6Wyi0Q2qLI
         3p0Dka2lD2eH1HcrVPRUZWXrZ22XTmkJ9GQgTuA4Yn6MgjbS7OcAElYtucFXqUepZICT
         jPgTHebhy1pwnwnamARFoxz1RdsGvSp82h3izZKAii255PtNXj6F9npXHuYFmZjEG2UJ
         vBEKg3r3YMleJuq9L1Ds0AyQrcdbUcTDRK3rgjd/jJP+gVRPAsk1hEZLbPfNj44JWYUY
         Tfqw==
X-Gm-Message-State: AOAM533FXbKdqEv1Jye2zVXcBS7iERuiiIUmV/n7NoLl9nqtXaVfPF6H
        muXsRYgMTKfefbjrEA2jcQFKYZ4sH7c=
X-Google-Smtp-Source: ABdhPJwHhxNxGV8NlXRLDHA/ZMupB/ML9PT4Hy2f65d7cjBdFLDnvuZCOIx20fKABMSZ/D6dyN8FCQ==
X-Received: by 2002:a17:90b:155:: with SMTP id em21mr5638212pjb.116.1629826856841;
        Tue, 24 Aug 2021 10:40:56 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id z33sm22371593pga.20.2021.08.24.10.40.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 10:40:56 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 5/7] KVM: X86: Don't unsync pagetables when speculative
Date:   Tue, 24 Aug 2021 15:55:21 +0800
Message-Id: <20210824075524.3354-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210824075524.3354-1-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
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
index a165eb8713bc..e5932af6f11c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2600,7 +2600,8 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
+			    bool speculative)
 {
 	struct kvm_mmu_page *sp;
 	bool locked = false;
@@ -2626,6 +2627,9 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
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

