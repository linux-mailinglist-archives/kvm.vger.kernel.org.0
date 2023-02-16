Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF769A2A4
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 00:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPXwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 18:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPXwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 18:52:23 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED214BEAA;
        Thu, 16 Feb 2023 15:52:22 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b5so3838244plz.5;
        Thu, 16 Feb 2023 15:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SlhoB6i+2mk1EJVjbBztFsISdkHxk3ce01t+gVZR5M=;
        b=kiXZiS3WWc/7Zy1SOoCV4QCxMSZr2DwCbhgt7byORT2MyV/qZLAxeyapO5zzm0kcC2
         Vu9kWR+1yENW1Zin4ITOqpflqF8GLkKK+2sK+P/vupS822b8xdRXeI9XYkedmzvmoSRt
         ZbIj2fgFmy8/tofLpFBpdN014PlUsXt731e5BRrehQolhAD73tSgdPZy4FNZe9jCkiGw
         PWFE+zmf3riS83yyP4eonhJNHaZ62AiOuscD7b6RKmlFPc0DXQCV1yXvL7nGCdxwqI3P
         Ck0RM6D6Hw2otibc0NyFeC8l5z6gYZ0g3bUBOg39yKfdrY+ZrTMi9YFGkUz9uAMYSESG
         w0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9SlhoB6i+2mk1EJVjbBztFsISdkHxk3ce01t+gVZR5M=;
        b=uPS6En0Ggd6VUyjlpnyxuIiIecY4UhFf/6HNWBCJxv8bJhtT7zZF+CRxg0yGZPlbUg
         XmadK9Sri98yqXUC708eLuXmhFdxeMOESu63pdWETmraY3RKPODV7m60qU7zrdVDptTy
         iB8wB4pnEVpH2PIA2+Z7B1Fs6rNvVIA2Znlay2FNhda1Xz4KWEzE5sTU5vqO/Ch/Jd7Z
         BIDj5/E51Qjq2GLRNzCpPmk57+/HqEr3ZXhOQECBemh+fYLmC4lue3o0I9RU0Fmtid7W
         1TnYnOJPJmWkQiqc8Jc9wQOoPFg8qxGduFsLatrBw+8PXhaS62mhyw1Rwn7K0tYCXW9V
         mXiQ==
X-Gm-Message-State: AO0yUKWOrno7yxjwCoqy9SXhNmtSQBHAlwgW/cagB3aSru30n4ZiE1sC
        0DrDCv4VNF+GXYJhN1J1mm/xZiv2pwg=
X-Google-Smtp-Source: AK7set+ZgLvFcBOHeA3PISBcN6oxKM9ZjIkdXMjIQLNGinDBRIUlYLibkQ52ZGgO4lUV+58uVYPxkQ==
X-Received: by 2002:a17:902:d486:b0:19a:b033:2bb1 with SMTP id c6-20020a170902d48600b0019ab0332bb1mr10260416plg.44.1676591541853;
        Thu, 16 Feb 2023 15:52:21 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b00194caf3e975sm1830488plw.208.2023.02.16.15.52.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 15:52:21 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 10/14] kvm: x86/mmu: Use kvm_mmu_invalidate_addr() in nested_ept_invalidate_addr()
Date:   Fri, 17 Feb 2023 07:53:17 +0800
Message-Id: <20230216235321.735214-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
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

Use kvm_mmu_invalidate_addr() instead open calls to mmu->invlpg().

No functional change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c    | 1 +
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c48f98fbd6ae..9b5e3afbcdb4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5791,6 +5791,7 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			mmu->invlpg(vcpu, addr, mmu->prev_roots[i].hpa);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..cb502bbaee87 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -358,6 +358,7 @@ static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
 static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 				       gpa_t addr)
 {
+	unsigned long roots = 0;
 	uint i;
 	struct kvm_mmu_root_info *cached_root;
 
@@ -368,8 +369,10 @@ static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
 
 		if (nested_ept_root_matches(cached_root->hpa, cached_root->pgd,
 					    eptp))
-			vcpu->arch.mmu->invlpg(vcpu, addr, cached_root->hpa);
+			roots |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
+	if (roots)
+		kvm_mmu_invalidate_addr(vcpu, vcpu->arch.mmu, addr, roots);
 }
 
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
-- 
2.19.1.6.gb485710b

