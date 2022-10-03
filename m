Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBCD5F363E
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJCTX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJCTX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:23:57 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3AB36869
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:23:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w2so11056396pfb.0
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=C3egDvylzJ91lMlqfRWFmIDJyZplta/IkZur/8yyuJo=;
        b=N6jg3ONuuod1yowMNrjd3DUsmf7Ak6Ozv0kTSg9cW1s5CKxNZOwv93RtEZqexaorwu
         cbttS8aYYtA/beqdWV/WlKFMP7SDdLK2+LCW6wFNhRQK5Po+IiL+aNyn4+NNIfRaEASb
         4YssHEfOPj8IauXA+/2+s51XuunmXAazxqkl81Yi4/2j/7n59BNcnTv4nzi89q8IDkyL
         iVxpAab+U9QEetiN7RSf6tJTTDRJLy6+0jzEwDGWezjwntX5Ibk8690o2i9xVIDPs4uS
         AC0INFAtC5wRT/UAGmiKZSq03ND27PC9/4IwI3XVoXud6kwU3avXuHkqTVUto/gssFHT
         WyqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=C3egDvylzJ91lMlqfRWFmIDJyZplta/IkZur/8yyuJo=;
        b=ZeEoSDLqhZHei9rnBjVM0J9pi5dgTPFuCxHtEmGflWB7Xsgb9O9rXlb5uNsvWzKwtq
         2yehUMgT2brGJAmLQZSbeljVRJGBxoiJBZJdZAFP8aNrJ5OIKozZ0LuKAdJzzWoGgPz1
         XbpC9OziqArZaYUpOPSuLvZs7D5eG/F5W63lmZ5aWswnd+dBFU+glSbvJvarDo2gLmvK
         zLvb+K6Nr8DEt8Pgo7n08/myWeuGq8WxmcFQ8DvOXa0kZtfxtJk1VqDPcorfcyZIbm/1
         uIVY6t32Nycu3HJjmSs3AvR72Mh8xFX9JuI8BsNAzxZOEPC7c6qYr1/kPuPOqyU139ca
         tXrQ==
X-Gm-Message-State: ACrzQf3V9UFAWg+Eu+Bsh2/HUwt6Z8muzi4tEChr7gLrbxsLvosHM+YB
        d8ISQcVTziwjFqpbcXH9g7M=
X-Google-Smtp-Source: AMsMyM69zjSG0jL4nKeiQ0A7ARGH57ufSCK9IkL06nMqfP6Hlgt7/wf++FgXGelQzqliRoBUZ0RzCA==
X-Received: by 2002:a63:5766:0:b0:440:2960:37d with SMTP id h38-20020a635766000000b004402960037dmr20400838pgm.278.1664825032646;
        Mon, 03 Oct 2022 12:23:52 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902f68b00b0017dd839f2a5sm5034897plg.38.2022.10.03.12.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:23:52 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:23:50 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 05/10] KVM: x86/mmu: Avoid memslot lookup during
 KVM_PFN_ERR_HWPOISON handling
Message-ID: <20221003192350.GD2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-6-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:41AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Pass the kvm_page_fault struct down to kvm_handle_error_pfn() to avoid a
> memslot lookup when handling KVM_PFN_ERR_HWPOISON. Opportunistically
> move the gfn_to_hva_memslot() call and @current down into
> kvm_send_hwpoison_signal() to cut down on line lengths.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 49a5e38ecc5c..b6f84e470677 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3136,23 +3136,25 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	return ret;
>  }
>  
> -static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
> +static void kvm_send_hwpoison_signal(struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
> +	unsigned long hva = gfn_to_hva_memslot(slot, gfn);
> +
> +	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva, PAGE_SHIFT, current);
>  }
>  
> -static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> +static int kvm_handle_error_pfn(struct kvm_page_fault *fault)
>  {
>  	/*
>  	 * Do not cache the mmio info caused by writing the readonly gfn
>  	 * into the spte otherwise read access on readonly gfn also can
>  	 * caused mmio page fault and treat it as mmio access.
>  	 */
> -	if (pfn == KVM_PFN_ERR_RO_FAULT)
> +	if (fault->pfn == KVM_PFN_ERR_RO_FAULT)
>  		return RET_PF_EMULATE;
>  
> -	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(kvm_vcpu_gfn_to_hva(vcpu, gfn), current);
> +	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> +		kvm_send_hwpoison_signal(fault->slot, fault->gfn);
>  		return RET_PF_RETRY;
>  	}
>  
> @@ -4193,7 +4195,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		return ret;
>  
>  	if (unlikely(is_error_pfn(fault->pfn)))
> -		return kvm_handle_error_pfn(vcpu, fault->gfn, fault->pfn);
> +		return kvm_handle_error_pfn(fault);
>  
>  	return RET_PF_CONTINUE;
>  }
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
