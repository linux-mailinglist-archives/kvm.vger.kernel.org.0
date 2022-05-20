Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603D552EE9E
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350556AbiETPCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiETPCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:02:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017F84F444
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 08:02:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w17-20020a17090a529100b001db302efed6so8087472pjh.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 08:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qZz8FZUKECzNbnFY9lR47szCmiT+m34JVlG5HP+QTn0=;
        b=DPzty7wOyFBPH7nBmaSCp1zF+Qu7AFgBU08fZ/J6ZV3I9UZOl9K3s2S6vt+V/oqBjY
         sHUOsi3rrOntar7AKCoxb+FfbEpm/Q+wIRL2ycC7L8K3BRwBxtMd+Md8Qu6Pubhky3VY
         LbUhHE5/gUHLm+RzAxoWBf//KHBuH5+MXjl225wZ3HiYBUXzuFJBZPZZJz4pRuAvPPUf
         2nQoEss9uwYAA/4yNtIWVB4XDC1j/hQ/ovuk3sHMLwTIcH2EGnymMWY0RbNcXhpy44Wa
         JUM61y34EIspVfWpJCVMC5oZrL9m7SJOGr97rM7irmcuG+X8pUb0R2sSpM6I/mur9cfS
         CneQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qZz8FZUKECzNbnFY9lR47szCmiT+m34JVlG5HP+QTn0=;
        b=MsrmVkzL8ssfLLII5WQRph5y5J5ZUBnPDaTLmsz7VD/wFD8BsccF57+AF0b3xqmJcl
         Lnc97g7axTiay9T0MnTW+HjyQQfeNXgtfBDTpkTS2kqlYVgjNd7NyarqNTOY1e1+2j6g
         hQ0n67R7ZF95rm1o5oyM12OfdrwhZeVZlEZbgihmRTFJYY5H/RZQ2QW8Hq6nD/gAxgIF
         BPjYqC3ydIK5fVTu49x/+RFKs4xNOPvUZ5DDNDqlC5WnKnpbZ7yipiRioUhsjTaB5asV
         R4XkSXYrN73VtKIG7s4TUE2SB0pxpOy59yk8xtL8HNFICetbD0c0RrsjLNI2X6cqiApa
         Eqtg==
X-Gm-Message-State: AOAM531w5z3UKgq3Tj5aV3z+KqMpIfOgfIZ/0chRkeTF+3SKES1PB5do
        tRkIpBls/lW/zv8TF3+B2B1uRw==
X-Google-Smtp-Source: ABdhPJwGx7/ziDKYfEwbA7cv/TFh1iHd2mnAZbRvFEIzyRocHqSZvq6rVVrPIugR9QUgSsO/fi3hvw==
X-Received: by 2002:a17:90a:4d49:b0:1df:78ca:ae49 with SMTP id l9-20020a17090a4d4900b001df78caae49mr11190224pjh.121.1653058926286;
        Fri, 20 May 2022 08:02:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902c71100b0015e8d4eb28fsm5665018plp.217.2022.05.20.08.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 08:02:05 -0700 (PDT)
Date:   Fri, 20 May 2022 15:02:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
Message-ID: <YoetaoA7m4P5NQhy@google.com>
References: <20220427014004.1992589-1-seanjc@google.com>
 <20220427014004.1992589-7-seanjc@google.com>
 <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
 <4c617e69-f80a-1ee1-635e-c198cf93187e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c617e69-f80a-1ee1-635e-c198cf93187e@redhat.com>
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

On Fri, May 20, 2022, Paolo Bonzini wrote:
> On 5/20/22 16:49, Paolo Bonzini wrote:
> > On 4/27/22 03:40, Sean Christopherson wrote:
> > > +         * Wait for mn_active_invalidate_count, not mmu_notifier_count,
> > > +         * to go away, as the invalidation in the mmu_notifier event
> > > +         * occurs_before_  mmu_notifier_count is elevated.
> > > +         *
> > > +         * Note, mn_active_invalidate_count can change at any time as
> > > +         * it's not protected by gpc->lock.  But, it is guaranteed to
> > > +         * be elevated before the mmu_notifier acquires gpc->lock, and
> > > +         * isn't dropped until after mmu_notifier_seq is updated.  So,
> > > +         * this task may get a false positive of sorts, i.e. see an
> > > +         * elevated count and wait even though it's technically safe to
> > > +         * proceed (becase the mmu_notifier will invalidate the cache
> > > +         *_after_  it's refreshed here), but the cache will never be
> > > +         * refreshed with stale data, i.e. won't get false negatives.
> > 
> > I am all for lavish comments, but I think this is even too detailed.
> > What about:
> 
> And in fact this should be moved to a separate function.
> 
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 50ce7b78b42f..321964ff42e1 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -112,6 +112,36 @@ static void gpc_release_pfn_and_khva(struct kvm *kvm, kvm_pfn_t pfn, void *khva)
>  	}
>  }
> +
> +static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
> +{
> +	/*
> +	 * mn_active_invalidate_count acts for all intents and purposes
> +	 * like mmu_notifier_count here; but we cannot use the latter
> +	 * because the invalidation in the mmu_notifier event occurs
> +	 * _before_ mmu_notifier_count is elevated.
> +	 *
> +	 * Note, it does not matter that mn_active_invalidate_count
> +	 * is not protected by gpc->lock.  It is guaranteed to
> +	 * be elevated before the mmu_notifier acquires gpc->lock, and
> +	 * isn't dropped until after mmu_notifier_seq is updated.
> +	 */
> +	if (kvm->mn_active_invalidate_count)
> +		return true;
> +
> +	/*
> +	 * Ensure mn_active_invalidate_count is read before
> +	 * mmu_notifier_seq.  This pairs with the smp_wmb() in
> +	 * mmu_notifier_invalidate_range_end() to guarantee either the
> +	 * old (non-zero) value of mn_active_invalidate_count or the
> +	 * new (incremented) value of mmu_notifier_seq is observed.
> +	 */
> +	smp_rmb();
> +	if (kvm->mmu_notifier_seq != mmu_seq)
> +		return true;
> +	return false;

This can be

	return kvm->mmu_notifier_seq != mmu_seq;

Looks good otherwise.  It'll probably yield a smaller diff too.
