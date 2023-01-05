Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0FE65E864
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjAEJ5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjAEJ5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:57:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2994FD5B;
        Thu,  5 Jan 2023 01:57:44 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z7so19256172pfq.13;
        Thu, 05 Jan 2023 01:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qbcS2kAh7qKqu1Tcd+kRAYagIvCht+cBr4HMCNf5SE=;
        b=dxbrMS6ocOOad8B62fNsSZS9ih/clJTefmEBMIJ7VgmiirhlnHxz0NsoB+pMRrMjj/
         44P8V6Knx4dXLAF5qyytPrhqM0yMWEekP23utHYQDrhFgqoOCBgocIkda0sYV+KInfxE
         MODKKso97BdYrspU+q4YJ+/SsyK2vvxteqmQWTayuf/msOByn0VMp7wbQfzLEG06Jl6b
         RO4Z6G+fLarlApjENWWkCsRowsiq1nrnoN8XRrMNXaFtZM6cNpfjlp9UnC1T8KRmVR8G
         V8dWLkIjwMajfgY/nhQalmYYHgda+dkHihT1nTEOXnjFpsSRyyWluTzgoSIL9fFAei17
         lKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5qbcS2kAh7qKqu1Tcd+kRAYagIvCht+cBr4HMCNf5SE=;
        b=NRNttAOQ5iW87M1w4RL2/GugRhUpYjzKSy32RvEWXGb3Ct7xqaGlCbiceuuCBw/AyS
         QbVimiJwy/gaRiBYePLHFnEYdBGE4v9JwiJCx6otyOJS8CtgL3PsOvKBQ4i+otKdS08w
         3ul8UYRCcX10MQUIM2Ev+q0Eobt2Z8j1TnmsfylYgSLhCywUOwV8gI3GslYPceh0D9tR
         ejqr0aH+ikewwlaQzzvZf4NuUzB+0rFDoQFCgNbzdCjZ79ENXozF0nNnam9H6CbjxI5f
         Nj3ALAk+RbSGsnqXkXZSfxliiJIjidLBAkAg+QTMgciOMmwjU6a8MkEaBiU1YMGA+bxa
         soDw==
X-Gm-Message-State: AFqh2krspgOG3tSIDzXvbPQ6NdOwbopqbxGzPHmMkR7W4WvZcrGZHVXh
        IISEKyweR0zyrHhG8gqAggwXOGRo9Kk=
X-Google-Smtp-Source: AMrXdXv4uug4JkZySUhwZOKjIjQFeasqLgfgauccigVds449xxlHEN+xYGPtwVj8Ogx4a71DoTHLVA==
X-Received: by 2002:a62:7bcd:0:b0:581:1c64:92bc with SMTP id w196-20020a627bcd000000b005811c6492bcmr38273815pfc.3.1672912663320;
        Thu, 05 Jan 2023 01:57:43 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id i2-20020aa796e2000000b00581172f7456sm19549248pfq.56.2023.01.05.01.57.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:57:42 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 2/7] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in kvm_mmu_invpcid_gva()
Date:   Thu,  5 Jan 2023 17:58:43 +0800
Message-Id: <20230105095848.6061-3-jiangshanlai@gmail.com>
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
 arch/x86/kvm/mmu/mmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 90339b71bd56..b0e7ac6d4e88 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5742,27 +5742,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool tlb_flush = false;
+	ulong roots_to_invalidate = 0;
 	uint i;
 
-	if (pcid == kvm_get_active_pcid(vcpu)) {
-		if (mmu->invlpg)
-			mmu->invlpg(vcpu, gva, mmu->root.hpa);
-		tlb_flush = true;
-	}
+	if (pcid == kvm_get_active_pcid(vcpu))
+		roots_to_invalidate |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
-		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			if (mmu->invlpg)
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
-			tlb_flush = true;
-		}
+		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd))
+			roots_to_invalidate |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-	if (tlb_flush)
-		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
-
+	if (roots_to_invalidate)
+		kvm_mmu_invalidate_gva(vcpu, mmu, gva, roots_to_invalidate);
 	++vcpu->stat.invlpg;
 
 	/*
-- 
2.19.1.6.gb485710b

