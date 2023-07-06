Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6828B74934F
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 03:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjGFBy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 21:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjGFBy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 21:54:56 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22725E57;
        Wed,  5 Jul 2023 18:54:53 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6b71cdb47e1so169604a34.2;
        Wed, 05 Jul 2023 18:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688608492; x=1691200492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1R7giHFFm9lzKa2KFRVnvuXui30YgtW+mLiZpS636v4=;
        b=DVvGohzInocB2G0CE5BHhj00dNWqGoqrHPqrt2G17lPCsMUYKKsSVbf/v2qs4vd+BH
         TVAuRlrgj7qFdyc7ySUeR1ptkT6VqY8g0PcTuoGbfj+zpJtxWVA3ExnG9inRg72NB8ya
         97PvzrwpvZTE/IpWdnMQdtsBQKUgGylnqxFb0d+ku33oYPoxzLJqPitoAXs7P6qyNyOu
         WBvlYk74ZsB1GmBvxmmGoVL2B7UDS4BtOjPnsr9uMZp+cLqX2sFGbdLdIRNR0a2Ixofc
         kvxyXlICSAK6MZrMjNfH4kDVoONsBeKJXmSqNW6LuF2yi5fD78o/J6TRC+FmmtIvuU18
         uIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688608492; x=1691200492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1R7giHFFm9lzKa2KFRVnvuXui30YgtW+mLiZpS636v4=;
        b=j/MGsMJJLe0Q95Q2o3uKUD632R6UGGASrXKP9myUS+ki8aMAc1BNuLusR/Kwyr17UQ
         4Hw4e7V4YjhrmlXZxc1JTadYAF16tRw7gXDH7XdSYw2gt1XmxkYs1vjKy+asRBs5ekZ0
         nZGBA6hA2yRcxegkJas0XPy5B6gqLuxJA9cQzlZXd03nyiVfhyyrv32C1SVJGLsebilp
         dAWhW39uC7pPNPUPHc8xK+8VJE9oKyJ0mPRdSgp1gz0Em9aIqSnlBAoPNYrwmNx5Cp2d
         MXl5fW8reR7PAMx4GnM9tCu8yUp0TW29RiedLOn/A/zDjOBi5drwMsRGt2EyjTOmxu3i
         ikcA==
X-Gm-Message-State: ABy/qLbNZaao0U/UGORBcYfVTWZTtkU8iSJdhOJeUb/F0S0Anqyr0tAS
        hAQJ6RuBAhq1D2+LL6qCvMw=
X-Google-Smtp-Source: APBJJlG1rcUiA7G6cfKIni/3YPqB6pOv+DveqzIRXSNVbOaD89TbpWJy4qWw7jhrSgFyIxdPitrcKA==
X-Received: by 2002:a05:6358:98a2:b0:134:c530:c2fa with SMTP id q34-20020a05635898a200b00134c530c2famr436044rwa.30.1688608491138;
        Wed, 05 Jul 2023 18:54:51 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090301d000b001a5fccab02dsm122674plh.177.2023.07.05.18.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 18:54:50 -0700 (PDT)
Date:   Wed, 5 Jul 2023 18:54:49 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com
Subject: Re: [PATCH v7 4/8] KVM: x86/mmu: Migrate to __kvm_follow_pfn
Message-ID: <20230706015449.GB3894444@ls.amr.corp.intel.com>
References: <20230704075054.3344915-1-stevensd@google.com>
 <20230704075054.3344915-5-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230704075054.3344915-5-stevensd@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 04, 2023 at 04:50:49PM +0900,
David Stevens <stevensd@chromium.org> wrote:

> From: David Stevens <stevensd@chromium.org>
> 
> Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..e44ab512c3a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4296,7 +4296,12 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> -	bool async;
> +	struct kvm_follow_pfn foll = {
> +		.slot = slot,
> +		.gfn = fault->gfn,
> +		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
> +		.allow_write_mapping = true,
> +	};
>  
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
> @@ -4325,12 +4330,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	async = false;
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> -	if (!async)
> -		return RET_PF_CONTINUE; /* *pfn has correct page already */
> +	foll.flags |= FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))

We have pfn in struct kvm_follow_pfn as output. Can we make __kvm_follow_pfn()
return int instead of kvm_pfn_t?  KVM_PFN_* seems widely used, though.


> +		goto success;
> +
> +	if (fault->pfn != KVM_PFN_ERR_NEEDS_IO)
> +		return RET_PF_CONTINUE;
>  
>  	if (!fault->prefetch && kvm_can_do_async_pf(vcpu)) {
>  		trace_kvm_try_async_get_page(fault->addr, fault->gfn);
> @@ -4348,9 +4355,17 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * to wait for IO.  Note, gup always bails if it is unable to quickly
>  	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
>  	 */
> -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, true, NULL,
> -					  fault->write, &fault->map_writable,
> -					  &fault->hva);
> +	foll.flags |= FOLL_INTERRUPTIBLE;
> +	foll.flags &= ~FOLL_NOWAIT;
> +	fault->pfn = __kvm_follow_pfn(&foll);
> +
> +	if (!is_error_noslot_pfn(fault->pfn))
> +		goto success;
> +
> +	return RET_PF_CONTINUE;
> +success:
> +	fault->hva = foll.hva;
> +	fault->map_writable = foll.writable;
>  	return RET_PF_CONTINUE;
>  }
>  
> -- 
> 2.41.0.255.g8b1d071c50-goog
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
