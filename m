Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72A83182D9
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBKA4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 19:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhBKA43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 19:56:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7246BC061574
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:55:42 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l18so2293524pji.3
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 16:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YsAaPUzH+52WvyXeY90ahv9OuWJHtFAVFBPiZZac1ds=;
        b=qEVZfph1M01ZVvfeLpepP//ra05A1+WWTevSBNjr1mCJPzK+wMxf04AR71hFXeNblS
         8FkWcV3XIOdjRYYXRHarMT1uAyPxaWn/uXDm/EM2iFGWGtKVaCAXF9+3XstmbyfEWuOt
         0vMQodRK3eJtZUBX3hhcwRwBEY+ihAxrXG+LFn5J2+XAnIU6BniCaMPKq62JXVVpDECc
         dQdprmd1jix4FZkcG+SYLw0SkGM//setoIM1cSABOdc5MqbhMZwUkwU3fX0tPiBhCdaz
         v4uK/XQLzgNz4R4bzeqcwbgx+U6a8olESLh6pwPq6PEbQDncEhvS5gl0Wu9voTD3EpsJ
         +YFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YsAaPUzH+52WvyXeY90ahv9OuWJHtFAVFBPiZZac1ds=;
        b=LCsc7xESD2sDafs5miZVMSn39GpJjiWU1ZH9nItHyaqaaiM56bfc/oKlP2J5/x08NH
         5fQTBdU9U/125YzPVep90iYXdh6u/pT2wJUZo2KvVWRR34gyIMT2SHfqDNkkKzG1KSQ7
         i0ynXi+7yxV5FuL7MOBLBUk+wkm2cUF9tndzqNSdubJe9/veJRuFZzKRvUxVMlwshL8q
         bKItn5PkuZO9hhv2cLybf2ldVGeJV8ijEJClSvGOrArobQya7MmUwburidXImenWESkH
         sd0fS3f/NVIBboJsyze0NpxTV0BoyqfhNoMDjsGqR3BlDs32vPMDrdNsS06dzGX3sgrf
         aFKA==
X-Gm-Message-State: AOAM531wXRocAf//ijvl7rQdAsF9HCLS+vlp0hlYGIiDrXGYn88hcWTS
        jsYx/jGcCH0o+PhJcBqyMk727A==
X-Google-Smtp-Source: ABdhPJzjqR6+m27sjFHGYIhB+TyrDJyinEkqEw2zhQPuUjCGBt0STr1TFobeNkw6rURZa6sP2vpphA==
X-Received: by 2002:a17:90a:f416:: with SMTP id ch22mr1505340pjb.61.1613004941923;
        Wed, 10 Feb 2021 16:55:41 -0800 (PST)
Received: from google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
        by smtp.gmail.com with ESMTPSA id v4sm3282037pff.156.2021.02.10.16.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 16:55:41 -0800 (PST)
Date:   Wed, 10 Feb 2021 16:55:35 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, pshier@google.com, jmattson@google.com,
        Ben Gardon <bgardon@google.com>
Subject: Re: [RESEND PATCH ] KVM: VMX: Enable/disable PML when dirty logging
 gets enabled/disabled
Message-ID: <YCSAh31LP4QwBfHZ@google.com>
References: <20210210212308.2219465-1-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210212308.2219465-1-makarandsonare@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Makarand Sonare wrote:
> @@ -7517,9 +7531,39 @@ static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  static void vmx_slot_disable_log_dirty(struct kvm *kvm,
>  				       struct kvm_memory_slot *slot)
>  {
> +	/*
> +	 * Check all slots and disable PML if dirty logging
> +	 * is being disabled for the last slot
> +	 *
> +	 */
> +	if (enable_pml &&
> +	    kvm->dirty_logging_enable_count == 0 &&
> +	    kvm->arch.pml_enabled) {
> +		kvm->arch.pml_enabled = false;
> +		kvm_make_all_cpus_request(kvm,
> +			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
> +	}
> +
>  	kvm_mmu_slot_set_dirty(kvm, slot);
>  }

...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ee4ac2618ec59..c6e5b026bbfe8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -307,6 +307,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  {
>  	return kvm_make_all_cpus_request_except(kvm, req, NULL);
>  }
> +EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);

If we move enable_pml into x86.c then this export and several of the kvm_x86_ops
go away.  I know this because I have a series I was about to send that does that,
among several other things.  I suspect that kvm->arch.pml_enabled could also go
away, but that's just a guess.

Anyways, I'll work with you off-list to figure out a plan.  The easiest thing is
probably for me to tack it on to the end of my series.  I completely spaced on
the fact that my series would conflict with this code, sorry :-/
