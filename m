Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7902A68DD6D
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjBGP4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBGP4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:56:35 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014C061A4;
        Tue,  7 Feb 2023 07:56:30 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so14787880pjp.0;
        Tue, 07 Feb 2023 07:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1yYdus7dKKkMlbDfPhfvxL4FYYeMhTDOYIC9ymbscZ4=;
        b=o0e8+3+c4Md/NPq+c0373J4woOiYj9bLd4hEWPkGMMF+pT30BMbvFFRmosmA0Skq9t
         LdNrqFsh5tP3gDiOKZ61M+nBMVnK6r94e4MiEGTptFal9azeTXUt21VBVuW5pzVVHgxb
         6GPL4J1F1kbnZ/lpIxi8+eVR8YC+YtI2Rj5pE4KwIbzDaP/2kVpaPdaszkXtnIIKNKKa
         FrSG9yYHzjzI6yR4pyLZP2dBBzrsNBr8WeZb4L7zMJ7TA1lsHrEb4Qg3yrtL9Ng2pXSw
         WHiaUYBEyX2Co7PDsxuHMezqh9DdfyKf54Zznf0cwVu5Kx+djdx9Q1KPFLjx7eCFGjpS
         ujyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1yYdus7dKKkMlbDfPhfvxL4FYYeMhTDOYIC9ymbscZ4=;
        b=bs88CEkdAzUcEsk5WK+xU46nDDE/3xV/64W93DjK/q+Arout9PiIBQ5cKvVhB0uPIN
         NdgNU7X/RwM3p6p8hMRBdW4MSjCmRiOYIvELD1NYxVjOvlL/1tEPO095pGHLFFeNZjNK
         YkFs/VNdYWflInPW1zh3zET9NuD8suAi2IphZiYH6Vf6bWLtw6bmLmUKWUb2j/KFtyCz
         gn+Ybn+rzFe88td5XAVdFGBWJnR+YApiaOyYdNeaXRIXKFnzWKbaBPfpJddqp+B9++wK
         vS8dH38xhtInb5kH892FfcCSWdfHyforZrL9xry5Ly574esxuPfwvnsLqtV8/lY4g/kZ
         eM8A==
X-Gm-Message-State: AO0yUKX75LZ/8hT7aD3Wu9us3GKEVkvSqMjnTafY6zCAaapPkwOTgeXd
        AynupG7BPTs7b0LkXnsYnhPaDMwUM5Y=
X-Google-Smtp-Source: AK7set+eyy44U0q2wWGu5RTvXQmwtsMl63mctcywFQm5vAs63mlGNWJ8GZIwPGvnyr/9oYTjjv8iVA==
X-Received: by 2002:a17:902:ced0:b0:196:725c:6ea with SMTP id d16-20020a170902ced000b00196725c06eamr4266341plg.19.1675785390089;
        Tue, 07 Feb 2023 07:56:30 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id jk16-20020a170903331000b001993909eae4sm392926plb.253.2023.02.07.07.56.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:29 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 3/8] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in nested_ept_invalidate_addr()
Date:   Tue,  7 Feb 2023 23:57:29 +0800
Message-Id: <20230207155735.2845-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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
index 8563b52b8bb7..e03cf5558773 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5734,6 +5734,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..f552f3c454b1 100644
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
+		kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, addr, roots);
 }
 
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
-- 
2.19.1.6.gb485710b

