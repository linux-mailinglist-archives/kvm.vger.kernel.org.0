Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6969991E
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBPPlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjBPPlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:41:20 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD4A59B4C;
        Thu, 16 Feb 2023 07:40:53 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d8so2389808plr.10;
        Thu, 16 Feb 2023 07:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIz1dd81kBqa+9U0EZQc5mAaI8eBbOT1aGkH7E8Ns+A=;
        b=LeQ0PkaPg1S/RJKzvxMWzRoPm2TilEGhUb05Y8tNiKntvJqcRwrzdR8FlLw6lnR6NS
         iBJ+q5ebLXCp05ZbA6P76F7cMmKbyOh26BV/SPcQJSrwMO7W4XwGNWRjBrGK/zMO6amC
         Z0B48T7TIV3tpYbLBOnTSGCn6oremsRZiuN8zSkvKNXconJfooJPHn0hiwljxuTyIj4x
         AoTcRhB7xn0mvK1Wg1/qKk7C8eoqCeWOnBzlo5C8DlW22frTOQkgsVIgyV78bV50WRvG
         G1ex2WWFEoyUhJ6Qov6tA7wK8DV93OBHodz/w1Z59rahiilgQW3QxpjiFH1AZfBMC1rW
         MWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIz1dd81kBqa+9U0EZQc5mAaI8eBbOT1aGkH7E8Ns+A=;
        b=s6g67vgLt6/Y3/1gpUGuuxxoqNP3ydsDFUqoegenT7eMJRN2fKsjTPCujWKVhWyG+B
         GPrv7NZdq0EcV0HbuCK7kR24BXelH3IxOulZvbpXPIkWCTl8RfqOFL4rvSxgShggjXpJ
         TD5j+06H4M4zAyyvvcJLEiLxyT0DoPYemHZjWw2sWD7W24gCPotVs3kb3FuCVq2ynqIz
         YK6kMZlAFr5oLR4ypzMRkn+vpmkLz8l6YMVeuGMLHpQm/xUjwdEywnKhbQmQVZeiJslb
         sp5p9KCY+qa50klnZbHjPRLaMrhIo2oV/aDyxVN3kKzVp5uX9p9etlkIoTBrD2hOfvkP
         qWFA==
X-Gm-Message-State: AO0yUKWQa7low5YXFGP4MOD0DLuNdVMzbEa6BQA3er03Mu2IuSXIObMN
        QyI2t3TcvbJpvZWviyLVt5IlsrEVsP4=
X-Google-Smtp-Source: AK7set9Yw38AXdWKTGvpIOUs7nGALUrb4vZ+A2fpL7v79d0+g9bCMtCyTOhPZFO4GpefUq+xG2KCUw==
X-Received: by 2002:a17:902:cacd:b0:196:68ee:f363 with SMTP id y13-20020a170902cacd00b0019668eef363mr5087318pld.69.1676562051903;
        Thu, 16 Feb 2023 07:40:51 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b00198e346c35dsm1491649plj.9.2023.02.16.07.40.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:51 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 09/14] kvm: x86/mmu: Use kvm_mmu_invalidate_addr() in kvm_mmu_invpcid_gva()
Date:   Thu, 16 Feb 2023 23:41:15 +0800
Message-Id: <20230216154115.710033-10-jiangshanlai@gmail.com>
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
 arch/x86/kvm/mmu/mmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9f261e444a32..c48f98fbd6ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5814,27 +5814,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool tlb_flush = false;
+	unsigned long roots = 0;
 	uint i;
 
-	if (pcid == kvm_get_active_pcid(vcpu)) {
-		if (mmu->invlpg)
-			mmu->invlpg(vcpu, gva, mmu->root.hpa);
-		tlb_flush = true;
-	}
+	if (pcid == kvm_get_active_pcid(vcpu))
+		roots |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
-		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			if (mmu->invlpg)
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
-			tlb_flush = true;
-		}
+		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd))
+			roots |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-	if (tlb_flush)
-		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
-
+	if (roots)
+		kvm_mmu_invalidate_addr(vcpu, mmu, gva, roots);
 	++vcpu->stat.invlpg;
 
 	/*
-- 
2.19.1.6.gb485710b

