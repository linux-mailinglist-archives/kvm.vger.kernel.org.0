Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97C6915E4
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjBJAuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBJAub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:50:31 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761D6A73E
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:50:26 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z1so4853813plg.6
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RtDJLw8vwdwAjsAtx/I+c5vwGL5haek+8I4l9FjaPbM=;
        b=hCDE+HV/2hOt1IgVLF7MFI+Z7OlBIYifdE740L3dN+7Wk841ZR8dcb+mDJgQfuAKxm
         ZyL89KQ0CZvLo9Vy0fPjcZ6XsGRSFTegm6RalA2ISYNQvvkPSpcgNq8MeLAZKR3LYmoA
         xruHmL1ix31r2F6SkbKZ8eiT+t3LjufZKaVhGAYQ6NDn4QUbi2HzdrbtGUF9TfsbJmNF
         Aym2Yv1LQHiMudQtt7RN2kLHaipSzgnnWJfk7n/p23yfY/k7kVm8eibMhrXANpIP8TLr
         kdGvClaWoh/4p3nU2IxLZ8cUGayiqOn623qIrsOqj1JtIko7pKY+ikOOp8EffcI5p/5r
         UbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RtDJLw8vwdwAjsAtx/I+c5vwGL5haek+8I4l9FjaPbM=;
        b=WtY+8JNIyX8uYffGk/ocIxfDSMzyPnLPtyuDNs1+l47zEq7FQgQX1+irtPqdnn0IYf
         QJe03OJAjfjCEn0q0rxEvHDFP/u39X1WBVdB94JME5VXNCB9TkzBB6kevaMh16zfsTqr
         X484Dce0ZXiBCIYKGoYYZ+fjMGawqSid8iY92MK74nhtWasW45Xb5znZWGi07+udnc9D
         b3XfNjMo/VjjCUumxXc2cZCKFrANISKgxV5hZ7BYDtG5tgreSolJnhJ0gVzmKPq24ScS
         D9/H6a8oycs/ZfSDfcPbaK5l8tFuolDIvN5j71Mr232XLf5B0dFprq7IXNvbWSd4QIA9
         BSYg==
X-Gm-Message-State: AO0yUKXm9A5jIkCUdz0aPs7/zZ+NArO7YkNKSDASzpfpDK4XrtdPRBW+
        jRAVfpPjoTy1sdWgTrOknjfWzg==
X-Google-Smtp-Source: AK7set/kW+orNWUKnpWhKkeGtB7x+mkiP/yWiREM6SpbaG+BpIZ+uOp12qlNVThoWo/IYCSO/OUKGQ==
X-Received: by 2002:a17:903:2792:b0:198:af4f:de08 with SMTP id jw18-20020a170903279200b00198af4fde08mr100831plb.8.1675990226095;
        Thu, 09 Feb 2023 16:50:26 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e23-20020a63db17000000b004fb26a80875sm1891297pgg.22.2023.02.09.16.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 16:50:25 -0800 (PST)
Date:   Fri, 10 Feb 2023 00:50:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH V2 1/8] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for
 kvm_mmu_invalidate_gva()
Message-ID: <Y+WUzgsBck4f8N4F@google.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
 <20230207155735.2845-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207155735.2845-2-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023, Lai Jiangshan wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c91ee2927dd7..958e8eb977ed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5707,10 +5707,12 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
>  
>  void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -			    gva_t gva, hpa_t root_hpa)
> +			    gva_t gva, unsigned long roots)
>  {
>  	int i;
>  
> +	WARN_ON_ONCE(roots & ~KVM_MMU_ROOTS_ALL);

This does nothing since KVM_MMU_ROOTS_ALL is ~0ul.  What I wanted is below, can
you slot that it?  Compile tested only.

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 9 Feb 2023 16:37:43 -0800
Subject: [PATCH 2/8] KVM: x86/mmu: Sanity check input to kvm_mmu_free_roots()

Tweak KVM_MMU_ROOTS_ALL to precisely cover all current+previous root
flags, and add a sanity in kvm_mmu_free_roots() to verify that the set
of roots to free doesn't stray outside KVM_MMU_ROOTS_ALL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..01d34f7d009d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -422,6 +422,10 @@ struct kvm_mmu_root_info {
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
+#define KVM_MMU_ROOT_CURRENT		BIT(0)
+#define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
+#define KVM_MMU_ROOTS_ALL		(BIT(1 + KVM_MMU_NUM_PREV_ROOTS) - 1)
+
 #define KVM_HAVE_MMU_RWLOCK
 
 struct kvm_mmu_page;
@@ -1978,10 +1982,6 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
 	return !!(*irq_state);
 }
 
-#define KVM_MMU_ROOT_CURRENT		BIT(0)
-#define KVM_MMU_ROOT_PREVIOUS(i)	BIT(1+i)
-#define KVM_MMU_ROOTS_ALL		(~0UL)
-
 int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
 void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..896abf9c1126 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3513,6 +3513,8 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 	LIST_HEAD(invalid_list);
 	bool free_active_root;
 
+	WARN_ON_ONCE(roots_to_free & ~KVM_MMU_ROOTS_ALL);
+
 	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
 
 	/* Before acquiring the MMU lock, see if we need to do any real work. */
-- 

