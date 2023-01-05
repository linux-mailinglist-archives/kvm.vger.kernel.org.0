Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A3D65E866
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjAEJ55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjAEJ5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:57:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5353C4FD53;
        Thu,  5 Jan 2023 01:57:48 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 6so22202812pfz.4;
        Thu, 05 Jan 2023 01:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFBlCEkkeMFXKNXjqBf5YmfR6phY6GSxunVKRwig/QY=;
        b=qRAsikolVWzMWN7+LKgvVdopfnEsPKnRla4wlEIwWMXiLVhPPSaCuWYyzqhBJ3Q5rR
         SHXw1KgrEYOi3ZRj1kCkr0OsV7+qgROvTxwKwToQJR5ULejrG4jUCJ6DxclqeZ24H58t
         Yid9T7RsihB4v9i0FSKAsK3I2p8zjNglHi7CjuzrB5lfRFpXlzc0NFQqfixLwCBsXrL1
         8nhG2IO8q5BBvvjr7qIHd5wOq22xo4U0MRoz8wNrIBG+xqL52b2szmcnd0j2RKMZf0Op
         O7ftrzs2GpIkqqu5RgfXyJrv5QsWMnExWnFkFt8s7y7415Xo39eGrWWo8IX4nHdrwaOP
         7eaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFBlCEkkeMFXKNXjqBf5YmfR6phY6GSxunVKRwig/QY=;
        b=VRy959y7Q+mOiLtqA3HbaSO16LS3tEazUPHL5VnlQmtSoHJNOo2bmageoqylxNrUn9
         84xAjQkFsbvGuMq9vLd6WkZTLV9kppvc4jKap1hSB1ORLjWFSqwfUw9bUvqVgko0cvOU
         SAjn08q9OBA+Qiulek07UPDzdraD7gVU/C9MGM5xkXRK2Dv6ZsILfF3w+/y4/W4q+S80
         V6P1Xr6fufyg5e7u7rgj0/C32POyJjN9XWe4CWp7N/Ta4le55WvtRWH3zUcKq2Qampco
         Gnodo546HYX3qm1RjuagPvEiVYgpeHwDfPdE8aZmpYb28emFfis5njsxWBckEQObfRx+
         3M0Q==
X-Gm-Message-State: AFqh2kpqbLr4J9ioJ3oZ/gRsZkNVhwuo/BeTZ8t5pc6a37nik1uOb3KP
        pt4lO4LUhFT8j4GAqU1SPjxdM+H+oxA=
X-Google-Smtp-Source: AMrXdXuMNotVvt+JTSQiD8Eyv6IbYLiEV9hNLC/tpRlEcKzCqgm8DtLhLgzJtJyMz8hVvw6U0JavTA==
X-Received: by 2002:a62:d45e:0:b0:56e:dca8:ba71 with SMTP id u30-20020a62d45e000000b0056edca8ba71mr43994278pfl.32.1672912667522;
        Thu, 05 Jan 2023 01:57:47 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id p28-20020aa79e9c000000b00575caf8478dsm12208189pfq.41.2023.01.05.01.57.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:57:47 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 3/7] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in nested_ept_invalidate_addr()
Date:   Thu,  5 Jan 2023 17:58:44 +0800
Message-Id: <20230105095848.6061-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Use kvm_mmu_invalidate_gva() instead open calls to mmu->invlpg().

No functional change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c    | 1 +
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b0e7ac6d4e88..ffef9fe0c853 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5719,6 +5719,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    VALID_PAGE(mmu->prev_roots[i].hpa))
 			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..daf3138bafd1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -358,6 +358,7 @@ static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
 static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 				       gpa_t addr)
 {
+	ulong roots_to_invalidate = 0;
 	uint i;
 	struct kvm_mmu_root_info *cached_root;
 
@@ -368,8 +369,10 @@ static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 
 		if (nested_ept_root_matches(cached_root->hpa, cached_root->pgd,
 					    eptp))
-			vcpu->arch.mmu->invlpg(vcpu, addr, cached_root->hpa);
+			roots_to_invalidate |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
+	if (roots_to_invalidate)
+		kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, addr, roots_to_invalidate);
 }
 
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
-- 
2.19.1.6.gb485710b

