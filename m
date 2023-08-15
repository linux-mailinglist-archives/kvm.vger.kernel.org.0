Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5C77C471
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 02:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjHOAbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 20:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbjHOAa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 20:30:57 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E6710E3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 17:30:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 686E184;
        Mon, 14 Aug 2023 17:30:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id EIdT79S7Kxa0; Mon, 14 Aug 2023 17:30:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 5104E45;
        Mon, 14 Aug 2023 17:30:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 5104E45
Date:   Mon, 14 Aug 2023 17:30:55 -0700 (PDT)
From:   Eric Wheeler <kvm@lists.ewheeler.net>
To:     Sean Christopherson <seanjc@google.com>
cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
In-Reply-To: <ZNJ2V2vRXckMwPX2@google.com>
Message-ID: <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
References: <ZHZCEUzr9Ak7rkjG@google.com> <20230721143407.2654728-1-amaan.cheval@gmail.com> <ZLrCUkwot/yiVC8T@google.com> <CAG+wEg21f6PPEnP2N7oE=48PBSd_2bHOcRsTy_ZuBpa2=dGuiA@mail.gmail.com> <ZMAGuic1viMLtV7h@google.com> <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com> <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com> <ZNJ2V2vRXckMwPX2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Aug 2023, Sean Christopherson wrote:
> > If you have any suggestions on how modifying the host kernel (and then migrating
> > a locked up guest to it) or eBPF programs that might help illuminate the issue
> > further, let me know!
> > 
> > Thanks for all your help so far!
> 
> Since it sounds like you can test with a custom kernel, try running with this
> patch and then enable the kvm_page_fault tracepoint when a vCPU gets stuck.  The
> below expands said tracepoint to capture information about mmu_notifiers and
> memslots generation.  With luck, it will reveal a smoking gun.

Getting this patch into production systems is challenging, perhaps live
patching is an option:


Questions:

1. Do you know if this would be safe to insert as a live kernel patch?
For example, does adding to TRACE_EVENT modify a struct (which is not
live-patch-safe) or is it something that should plug in with simple
function redirection?
	

2. Before we try it, do you know off the top of your head if the patch
below relies on any code that Linux v6.1 would not have?


--
Eric Wheeler



> 
> ---
>  arch/x86/kvm/mmu/mmu.c          | 10 ----------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 ++
>  arch/x86/kvm/mmu/tdp_mmu.h      | 10 ++++++++++
>  arch/x86/kvm/trace.h            | 28 ++++++++++++++++++++++++++--
>  4 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9e4cd8b4a202..122bfc884293 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2006,16 +2006,6 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
>  	return true;
>  }
>  
> -static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> -{
> -	if (sp->role.invalid)
> -		return true;
> -
> -	/* TDP MMU pages do not use the MMU generation. */
> -	return !is_tdp_mmu_page(sp) &&
> -	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> -}
> -
>  struct mmu_page_path {
>  	struct kvm_mmu_page *parent[PT64_ROOT_MAX_LEVEL];
>  	unsigned int idx[PT64_ROOT_MAX_LEVEL];
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index f1ef670058e5..cf7ba0abaa8f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -6,6 +6,8 @@
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_host.h>
>  
> +#include "mmu.h"
> +
>  #ifdef CONFIG_KVM_PROVE_MMU
>  #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
>  #else
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 0a63b1afabd3..a0d7c8acf78f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -76,4 +76,14 @@ static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu
>  static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
>  #endif
>  
> +static inline bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	if (sp->role.invalid)
> +		return true;
> +
> +	/* TDP MMU pages do not use the MMU generation. */
> +	return !is_tdp_mmu_page(sp) &&
> +	       unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
> +}
> +
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 83843379813e..ff4a384ab03a 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -8,6 +8,8 @@
>  #include <asm/clocksource.h>
>  #include <asm/pvclock-abi.h>
>  
> +#include "mmu/tdp_mmu.h"
> +
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kvm
>  
> @@ -405,6 +407,13 @@ TRACE_EVENT(kvm_page_fault,
>  		__field(	unsigned long,	guest_rip	)
>  		__field(	u64,		fault_address	)
>  		__field(	u64,		error_code	)
> +		__field(	unsigned long,  mmu_invalidate_seq)
> +		__field(	long,  mmu_invalidate_in_progress)
> +		__field(	unsigned long,  mmu_invalidate_range_start)
> +		__field(	unsigned long,  mmu_invalidate_range_end)
> +		__field(	bool,		root_is_valid)
> +		__field(	bool,		root_has_sp)
> +		__field(	bool,		root_is_obsolete)
>  	),
>  
>  	TP_fast_assign(
> @@ -412,11 +421,26 @@ TRACE_EVENT(kvm_page_fault,
>  		__entry->guest_rip	= kvm_rip_read(vcpu);
>  		__entry->fault_address	= fault_address;
>  		__entry->error_code	= error_code;
> +		__entry->mmu_invalidate_seq		= vcpu->kvm->mmu_invalidate_seq;
> +		__entry->mmu_invalidate_in_progress	= vcpu->kvm->mmu_invalidate_in_progress;
> +		__entry->mmu_invalidate_range_start	= vcpu->kvm->mmu_invalidate_range_start;
> +		__entry->mmu_invalidate_range_end	= vcpu->kvm->mmu_invalidate_range_end;
> +		__entry->root_is_valid			= VALID_PAGE(vcpu->arch.mmu->root.hpa);
> +		__entry->root_has_sp			= VALID_PAGE(vcpu->arch.mmu->root.hpa) &&
> +							  to_shadow_page(vcpu->arch.mmu->root.hpa);
> +		__entry->root_is_obsolete		= VALID_PAGE(vcpu->arch.mmu->root.hpa) &&
> +							  to_shadow_page(vcpu->arch.mmu->root.hpa) &&
> +							  is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root.hpa));
>  	),
>  
> -	TP_printk("vcpu %u rip 0x%lx address 0x%016llx error_code 0x%llx",
> +	TP_printk("vcpu %u rip 0x%lx address 0x%016llx error_code 0x%llx, seq = 0x%lx, in_prog = 0x%lx, start = 0x%lx, end = 0x%lx, root = %s",
>  		  __entry->vcpu_id, __entry->guest_rip,
> -		  __entry->fault_address, __entry->error_code)
> +		  __entry->fault_address, __entry->error_code,
> +		  __entry->mmu_invalidate_seq, __entry->mmu_invalidate_in_progress,
> +		  __entry->mmu_invalidate_range_start, __entry->mmu_invalidate_range_end,
> +		  !__entry->root_is_valid ? "invalid" :
> +		  !__entry->root_has_sp ? "no shadow page" :
> +		  __entry->root_is_obsolete ? "obsolete" : "fresh")
>  );
>  
>  /*
> 
> base-commit: 240f736891887939571854bd6d734b6c9291f22e
> -- 
> 
> 
