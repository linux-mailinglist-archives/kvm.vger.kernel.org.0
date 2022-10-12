Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D705FC96C
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJLQqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 12:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJLQqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 12:46:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A28CDD881
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:46:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n7so16798021plp.1
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 09:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4/SxT9WXP86l+o0DWBekitp4ZdIgzH5udKb6UlO/lM=;
        b=ib+6UivP//E8nL8k6ksvAUIJQTZ3hvKI9UQtlL90TePrFXIvmB+s3vBimAD/hRcfsK
         L7itR2oOUL+cCDxmX75z6BCSSl9pCv5fKm4J8Qj8uDL1rN0E8LVKjySfjuQCbFjPXBVh
         RD6jTPfkB7KhQNAxGERTyj/bdff+EDzrMAkEYQ3kPWssrPad0mpgfZMvBkbTH9RZAJ2T
         PiMe+8MHBJmomArLumtsec5n3c97jhglfm7+QMhWTOwtCaI/+am0mgEk+5n5ywBxvsei
         Y+1g2rfj8TF8WVe9WT/3WffEr1eDR9GKceZY5Aa29bJoJoSvg7DZsTXcwOAbJGQu6eAC
         5omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4/SxT9WXP86l+o0DWBekitp4ZdIgzH5udKb6UlO/lM=;
        b=Nj4Q3F5+vGXJWkUG+ifg6RWYCtlSrLb3tJbC+J+imV79idtPM14EBgX4lmPCiSaeYp
         6+b2U7qgQP4xV4N3sL+w3Ioxv/fmgdTWU6yRb/remJHyS1Nyob9jZp9gsu2y66CS/EjZ
         JMjviZJYvLhrhp45lwnQ4viKhjmXxNVJmC7gSm7p/ZBKpy7ILlHF973XduNBFeZhZmhr
         7veyIh9ZfXSyi6PGadqyXsW0cjoBwWtvl+2y1VN5uYCnPg9y/2hrQF2eoAiNQKUGI0VW
         YmaWAeCEu2LgUS6NMLOk1dCdLIBZZBZ5WjHFOXFCQOh0SSN5Cm/A1Wv8Et3YlqX31gHr
         Nmug==
X-Gm-Message-State: ACrzQf2IojoujQyWniRp7U/k+m+Rt/UOKul+xWq72dZv3o2MJeWxWhSO
        9AeOUilROR+YxRabuY0ktxl9bA==
X-Google-Smtp-Source: AMsMyM6alaWfTTlvUHvRgG4dPW7MCm9VOEIR2aj0c7pDunNqsAfe37N6LDR3WNl6bxsU5oTHZrEvIg==
X-Received: by 2002:a17:902:ef47:b0:179:d18e:4262 with SMTP id e7-20020a170902ef4700b00179d18e4262mr29808345plx.22.1665593171139;
        Wed, 12 Oct 2022 09:46:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090a65c700b0020a0571b354sm1627890pjs.57.2022.10.12.09.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:46:10 -0700 (PDT)
Date:   Wed, 12 Oct 2022 16:46:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86/mmu: Fix wrong gfn range of tlb flushing
 in kvm_set_pte_rmapp()
Message-ID: <Y0bvT8k9vlDUPup+@google.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
 <0ce24d7078fa5f1f8d64b0c59826c50f32f8065e.1665214747.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ce24d7078fa5f1f8d64b0c59826c50f32f8065e.1665214747.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022, Hou Wenlong wrote:
> When the spte of hupe page is dropped in kvm_set_pte_rmapp(), the whole
> gfn range covered by the spte should be flushed. However,
> rmap_walk_init_level() doesn't align down the gfn for new level like tdp
> iterator does, then the gfn used in kvm_set_pte_rmapp() is not the base
> gfn of huge page. And the size of gfn range is wrong too for huge page.
> Use the base gfn of huge page and the size of huge page for flushing
> tlbs for huge page. Also introduce a helper function to flush the given
> page (huge or not) of guest memory, which would help prevent future
> buggy use of kvm_flush_remote_tlbs_with_address() in such case.
> 
> Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          |  4 +++-
>  arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7de3579d5a27..4874c603ed1c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1430,7 +1430,9 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  	}
>  
>  	if (need_flush && kvm_available_flush_tlb_with_range()) {
> -		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> +		gfn_t base = gfn_round_for_level(gfn, level);
> +
> +		kvm_flush_remote_tlbs_gfn(kvm, base, level);
>  		return false;
>  	}
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 17488d70f7da..249bfcd502b4 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -168,8 +168,18 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
>  bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>  				    struct kvm_memory_slot *slot, u64 gfn,
>  				    int min_level);
> +
>  void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
>  					u64 start_gfn, u64 pages);
> +
> +/* Flush the given page (huge or not) of guest memory. */
> +static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
> +{
> +	u64 pages = KVM_PAGES_PER_HPAGE(level);
> +

Rather than require the caller to align gfn, what about doing gfn_round_for_level()
in this helper?  It's a little odd that the caller needs to align gfn but doesn't
have to compute the size.

I'm 99% certain kvm_set_pte_rmap() is the only path that doesn't already align the
gfn, but it's nice to not have to worry about getting this right, e.g. alternatively
this helper could WARN if the gfn is misaligned, but that's _more work.

	kvm_flush_remote_tlbs_with_address(kvm, gfn_round_for_level(gfn, level),
					   KVM_PAGES_PER_HPAGE(level);

If no one objects, this can be done when the series is applied, i.e. no need to
send v5 just for this.


> +	kvm_flush_remote_tlbs_with_address(kvm, gfn, pages);
> +}
> +
>  unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
>  
>  extern int nx_huge_pages;
> -- 
> 2.31.1
> 
