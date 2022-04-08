Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BB94F9DAF
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 21:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239254AbiDHTeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 15:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237476AbiDHTd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 15:33:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D267647045
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 12:31:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so8774397plh.1
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 12:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nAhd+e1VLA336/mZCn3lDY8+NbNK0VdRPAd/7u4RqTQ=;
        b=XWdQa8qAEH5VB1ontDMQ52QfzbJoWBgxn/ohqzG1cUID42xFznBlPqmi98x6fjmoQR
         pMpEwW7K/05nnyuOWCpKicD8pdy6+TuRFTr0G55Pf77IQhTNs/TMO0aI/DiYB8TffBKg
         C2+InvQcJvq69nnBxZbJaSgbsEHXLuYWrtXlCMe1b9vImxzGDriVrk9MlY8Hf3iCOpM7
         OijSKtBYXwqC5wavGdFLebbz59Z5Dp45XpYCOJ/zClLDdb7VR1Sr+OOX/QAfUhlQEndj
         sKv/IjiKk58Wzx2WU1BKKUC+M9icvtcNxmGmeKqqZMfZ1WYTrJb+lffiSHfB/snTQVg/
         dqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nAhd+e1VLA336/mZCn3lDY8+NbNK0VdRPAd/7u4RqTQ=;
        b=FmR0BdCtl1hzrEeSCBK907NCpxKAjblLhtDwUw7vWdBfLL7TpbXUNRJcbPvE3vWJw5
         us1prSfzCjwPPx2FdtCljyHSiuSIa/bGiCLzUNqhZR595EBZFxdTLTR64XRnBSkeulOB
         dTk4G7PK4eH9KyGXuKwxSy7S4eCE4/4UOg482MY/Rt1Mzp8GvThIqHH3GY7vOhs8E9wC
         1NURvyzckx4RMDAg0WnwCYyUp7TMIR3cM5Yq1LRranJKzFmxYNyn51LUC+7v9mdpFDWt
         Hd0+8vJZcmaZCV0h3azTYusMEKSebUdxfnIwWjh1pDeYzxlyXHR7gTMSsscKFzM0wpRW
         08Dg==
X-Gm-Message-State: AOAM531DUICDsLUkdom8lOdY7HXAKPXGNCX2R11ROsQ5SXgXC0wjnjum
        JaDGqq+gRimBENTOzRyvxgpeKw==
X-Google-Smtp-Source: ABdhPJzq04lr8ySKICE/znS41U3/sMfGzYTNu890ARARttOSfPftZr6YYDT1YQiY6wh6UcRu823deA==
X-Received: by 2002:a17:902:dac7:b0:154:4899:85db with SMTP id q7-20020a170902dac700b00154489985dbmr21232112plx.9.1649446313147;
        Fri, 08 Apr 2022 12:31:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pi2-20020a17090b1e4200b001c7b15928e0sm12977460pjb.23.2022.04.08.12.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 12:31:52 -0700 (PDT)
Date:   Fri, 8 Apr 2022 19:31:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Update number of zapped pages even if
 page list is stable
Message-ID: <YlCNpQ9nkD1ToY13@google.com>
References: <20211129235233.1277558-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129235233.1277558-1-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Very high latency ping, this is still problematic and still applies cleanly.

On Mon, Nov 29, 2021, Sean Christopherson wrote:
> When zapping obsolete pages, update the running count of zapped pages
> regardless of whether or not the list has become unstable due to zapping
> a shadow page with its own child shadow pages.  If the VM is backed by
> mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> the batch count and thus without yielding.  In the worst case scenario,
> this can cause a soft lokcup.
> 
>  watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
>    RIP: 0010:workingset_activation+0x19/0x130
>    mark_page_accessed+0x266/0x2e0
>    kvm_set_pfn_accessed+0x31/0x40
>    mmu_spte_clear_track_bits+0x136/0x1c0
>    drop_spte+0x1a/0xc0
>    mmu_page_zap_pte+0xef/0x120
>    __kvm_mmu_prepare_zap_page+0x205/0x5e0
>    kvm_mmu_zap_all_fast+0xd7/0x190
>    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
>    kvm_page_track_flush_slot+0x5c/0x80
>    kvm_arch_flush_shadow_memslot+0xe/0x10
>    kvm_set_memslot+0x1a8/0x5d0
>    __kvm_set_memory_region+0x337/0x590
>    kvm_vm_ioctl+0xb08/0x1040
> 
> Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> Reported-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2:
>  - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
>  - Collect Ben's review, modulo bad splat.
>  - Copy+paste the correct splat and symptom. [David].
> 
> @David, I kept the unstable declaration out of the loop, mostly because I
> really don't like putting declarations in loops, but also because
> nr_zapped is declared out of the loop and I didn't want to change that
> unnecessarily or make the code inconsistent.
> 
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0c839ee1282c..208c892136bf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5576,6 +5576,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
>  	int nr_zapped, batch = 0;
> +	bool unstable;
>  
>  restart:
>  	list_for_each_entry_safe_reverse(sp, node,
> @@ -5607,11 +5608,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
>  			goto restart;
>  		}
>  
> -		if (__kvm_mmu_prepare_zap_page(kvm, sp,
> -				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
> -			batch += nr_zapped;
> +		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
> +				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
> +		batch += nr_zapped;
> +
> +		if (unstable)
>  			goto restart;
> -		}
>  	}
>  
>  	/*
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog

