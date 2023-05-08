Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65216FB45D
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbjEHPvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbjEHPvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:51:03 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A3D04C
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:50:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-956ff2399c9so886667066b.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560989; x=1686152989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ijdgMy2gzr8fxjruFBoCk7W6yXaTsmVrltdYllWaDVQ=;
        b=r11KiSZgNh1mU+r6R32UakE8hFiaKOY6swUnOROKzVVXrufZ/3GAY8Y+ABGp25+zvQ
         KxngwUstZF6q2eI9lrl07iuwmUxDftlfoqIdVUGW9Br32jSyFLA1p0cESXx8m4xj+aFY
         84Zq2u0FancGS2FiXUYX1e3Erjgq/bdouEPSBB87FdB0yMiStuphxYFllEpNtSQtsiiv
         LPmQKH/YNd4NDhJ5Ew4gky+t/m8Ypf3PewTLiqqNL1TBwkn1zueOcGx2mwh6r0skknCW
         NvgS3/yb8ffBsqjKePvMXMpU3ZS1knqVOUm8OFitsIYf4jC6ELkNMvNBiaRSzkFoNk4H
         PzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560989; x=1686152989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijdgMy2gzr8fxjruFBoCk7W6yXaTsmVrltdYllWaDVQ=;
        b=PtvVQaf/C3643OBCe4UqncONjaKa3fTRaQyswgnAl/zzLfasnUHg49xTAzyZEw+PxT
         ZUAfyPfFQFxZOFMlp47+LEnefEZRIEtBxRyk1m9c9kHZ6zahiki5Jlh0t+1wKXPYYvVc
         jsxCWyhSJRG4zqsVWdYlUhHV0z688MhTc7pOMfOkoQqNZ6G8Mw/hRTuVejWgflDaaPO9
         2N1Te6oL/7opYe65KlBwluYrBv4U0VybqOW/Qr9OpNlzG1AKeTRFlvCVv2+yOlLiqNTg
         Xblk5hZla4jWRjsacZCrt80d4m1xCfCYrcVVG+X8GG00PNqvwkdEQKTZv47lJt5tUWoH
         s3dw==
X-Gm-Message-State: AC+VfDxb+grs1lMaOwEOPA7cX6DWMJjiZ0eu5OYsBnVl7IrkPvmIJ1Wd
        OCkoPJkEquRxuRXcQWjFDsg4Dw==
X-Google-Smtp-Source: ACHHUZ4HgqlMkSeNuYOcV94pLPpGObzUReiRdjPX/fuSl6ypjFj89BkId+IHXfeKexG21tVLjwXydw==
X-Received: by 2002:a17:907:96a4:b0:966:14ca:8cf9 with SMTP id hd36-20020a17090796a400b0096614ca8cf9mr8456700ejc.38.1683560989129;
        Mon, 08 May 2023 08:49:49 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id bu2-20020a170906a14200b0096654fdbe34sm117550ejb.142.2023.05.08.08.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:49:48 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.4 1/3] KVM: x86/mmu: Avoid indirect call for get_cr3
Date:   Mon,  8 May 2023 17:49:41 +0200
Message-Id: <20230508154943.30113-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154943.30113-1-minipli@grsecurity.net>
References: <20230508154943.30113-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 2fdcc1b324189b5fb20655baebd40cd82e2bdf0c ]

Most of the time, calls to get_guest_pgd result in calling
kvm_read_cr3 (the exception is only nested TDP).  Hardcode
the default instead of using the get_cr3 function, avoiding
a retpoline if they are enabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230322013731.102955-2-minipli@grsecurity.net
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.4.x
---
 arch/x86/kvm/mmu.c         | 14 +++++++-------
 arch/x86/kvm/mmu.h         | 11 +++++++++++
 arch/x86/kvm/paging_tmpl.h |  2 +-
 arch/x86/kvm/x86.c         |  2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 015da62e4ad7..a6efd71a0a6e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3815,7 +3815,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 	} else
 		BUG();
-	vcpu->arch.mmu->root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	vcpu->arch.mmu->root_cr3 = kvm_mmu_get_guest_cr3(vcpu, vcpu->arch.mmu);
 
 	return 0;
 }
@@ -3827,7 +3827,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn, root_cr3;
 	int i;
 
-	root_cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	root_cr3 = kvm_mmu_get_guest_cr3(vcpu, vcpu->arch.mmu);
 	root_gfn = root_cr3 >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -4191,7 +4191,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
 	arch.direct_map = vcpu->arch.mmu->direct_map;
-	arch.cr3 = vcpu->arch.mmu->get_cr3(vcpu);
+	arch.cr3 = kvm_mmu_get_guest_cr3(vcpu, vcpu->arch.mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4453,7 +4453,7 @@ void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_cr3);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+unsigned long get_guest_cr3(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr3(vcpu);
 }
@@ -5040,7 +5040,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
-	context->get_cr3 = get_cr3;
+	context->get_cr3 = get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
@@ -5187,7 +5187,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	kvm_init_shadow_mmu(vcpu);
 	context->set_cr3           = kvm_x86_ops->set_cr3;
-	context->get_cr3           = get_cr3;
+	context->get_cr3           = get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -5202,7 +5202,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_cr3           = get_cr3;
+	g_context->get_cr3           = get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ea9945a05b83..a53b223a245a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -102,6 +102,17 @@ static inline void kvm_mmu_load_cr3(struct kvm_vcpu *vcpu)
 					      kvm_get_active_pcid(vcpu));
 }
 
+unsigned long get_guest_cr3(struct kvm_vcpu *vcpu);
+
+static inline unsigned long kvm_mmu_get_guest_cr3(struct kvm_vcpu *vcpu,
+						  struct kvm_mmu *mmu)
+{
+	if (IS_ENABLED(CONFIG_RETPOLINE) && mmu->get_cr3 == get_guest_cr3)
+		return kvm_read_cr3(vcpu);
+
+	return mmu->get_cr3(vcpu);
+}
+
 /*
  * Currently, we have two sorts of write-protection, a) the first one
  * write-protects guest page to sync the guest modification, b) another one is
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1a1d2b5e7b35..b61ab1cdeab1 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -315,7 +315,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->root_level;
-	pte           = mmu->get_cr3(vcpu);
+	pte           = kvm_mmu_get_guest_cr3(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5e9590a8f31..f073c56b9301 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10130,7 +10130,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->direct_map &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_cr3(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_cr3(vcpu, vcpu->arch.mmu))
 		return;
 
 	vcpu->arch.mmu->page_fault(vcpu, work->cr2_or_gpa, 0, true);
-- 
2.39.2

