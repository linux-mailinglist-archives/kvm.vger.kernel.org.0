Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC153FF820
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 01:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbhIBXzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 19:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhIBXza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 19:55:30 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A838C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 16:54:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c5so1313191plz.2
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ALCe2Y9tD7D4EzHwRtzJyz3KblrehEB2Tj1eJEVNa2I=;
        b=F9uMSgxlOHs9ljrCqUQG+ZckVxyaKUVScP3Lrq20y/phQWhe3Kv9bYgSTv88cvhACu
         +n0Hf2A9XCNyX686+4h9dLrWtYisIBI/m30uAbic+xAQuN7/KGPBNi2QdhQRYdmJ4yZO
         gWQKfqhD91rw/33sbKXrvL9jYuwcXMO/EW6ghYTO3FplmXUvI7Xj9Q82ePSutrJLb/D0
         BYPEob89dHdCg/MAhhfFucZl3EAuJ/kM3jvAV5ZROd2JLFLPv8RTXGD+sl1CqX4CuyDm
         A0997Oo6cltrkryX0P4aj0DjHCwhEGY+fPUswWFzllhIyJ5Ygb5jfwhcNIDTxu/HK3Qt
         bDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ALCe2Y9tD7D4EzHwRtzJyz3KblrehEB2Tj1eJEVNa2I=;
        b=gfB3ePluyJcYjQbmZnoS8+5QPijyfCmX3K4ILVvqI5sHv3veMB/NdhrUlAfmGobaX/
         jrycwVVmQKj2jbBGd0ai6i/m89z+C1rIOx7bSkHLHEiHxi+2MlKxuVwWKc9kaeUAJzz5
         IKM2IKgPIslozjsn9igcNNnH+TDXdP6paywCxliNrataic0IHMdJbR/rcdA5av41987A
         oWQrorC55/hxbgOJNX3I4Xzy3u3Bw0glv+Ohod+nqknQH1Oux8txLw+KUezaTgLbKqBX
         Gets1dmH7Zg66wFRzah9uXEl5bTksXqQHxLFdCcZTEAthc2L2/s2lMHkq1NFjR3xuK/H
         nvbg==
X-Gm-Message-State: AOAM530dySLn4LUNBRvz/tybCC5xO/yBCtDaksam+u4Ve1NobcfMz9bz
        uIfAs+MlbAXF6W844oAPNfa8jg==
X-Google-Smtp-Source: ABdhPJyCLGhwa4xKFLXtfHZJ+MCgNXISiGHM4wK6jDNCZxqajozANwdIfdXxV24Pji2DFnP0OAXgGA==
X-Received: by 2002:a17:902:ed8b:b0:138:b1c7:f3ab with SMTP id e11-20020a170902ed8b00b00138b1c7f3abmr441629plj.77.1630626870371;
        Thu, 02 Sep 2021 16:54:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r2sm3881988pgn.8.2021.09.02.16.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 16:54:29 -0700 (PDT)
Date:   Thu, 2 Sep 2021 23:54:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
Message-ID: <YTFkMvdGug3uS2e4@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com>
 <YTFhCt87vzo4xDrc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTFhCt87vzo4xDrc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Sean Christopherson wrote:
> On Tue, Aug 24, 2021, Lai Jiangshan wrote:
> Rather than force the sync here, what about kicking all vCPUs and retrying the
> page fault?  The only gross part is that kvm_mmu_get_page() can now fail :-(
> 
> ---
>  arch/x86/include/asm/kvm_host.h | 3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 9 +++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..332b9fb3454c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -57,7 +57,8 @@
>  #define KVM_REQ_MIGRATE_TIMER		KVM_ARCH_REQ(0)
>  #define KVM_REQ_REPORT_TPR_ACCESS	KVM_ARCH_REQ(1)
>  #define KVM_REQ_TRIPLE_FAULT		KVM_ARCH_REQ(2)
> -#define KVM_REQ_MMU_SYNC		KVM_ARCH_REQ(3)
> +#define KVM_REQ_MMU_SYNC \
> +	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_CLOCK_UPDATE		KVM_ARCH_REQ(4)
>  #define KVM_REQ_LOAD_MMU_PGD		KVM_ARCH_REQ(5)
>  #define KVM_REQ_EVENT			KVM_ARCH_REQ(6)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..03293cd3c7ae 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2143,8 +2143,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  		}
> 
> -		if (sp->unsync_children)
> -			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +		if (sp->unsync_children) {
> +			kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> +			return NULL;
> +		}
> 
>  		__clear_sp_write_flooding_count(sp);
> 
> @@ -2999,6 +3001,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 
>  		sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
>  				      it.level - 1, true, ACC_ALL);
> +		BUG_ON(!sp);
> 
>  		link_shadow_page(vcpu, it.sptep, sp);
>  		if (fault->is_tdp && fault->huge_page_disallowed &&
> @@ -3383,6 +3386,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
>  	struct kvm_mmu_page *sp;
> 
>  	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> +	BUG_ON(!sp);

Gah, this is obviously wrong when allocating an indirect root.  On the happy side,
it points out a cleaner approach.  I think this is what we want?

---
 arch/x86/kvm/mmu/mmu.c         | 3 ---
 arch/x86/kvm/mmu/paging_tmpl.h | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..f24e8088192c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2143,9 +2143,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}

-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-
 		__clear_sp_write_flooding_count(sp);

 trace_get_page:
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..5b13918a55c2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -704,6 +704,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
 					      it.level-1, false, access);
+			if (sp->unsync_children) {
+				kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
+				return RET_PF_RETRY;
+			}
 		}

 		/*
--
