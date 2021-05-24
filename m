Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8C38F628
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhEXXXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:23:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B8FC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:22:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f22so13733182pfn.0
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 16:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sA426J+Q2BdIVmCpajOCZw4cS8H0Ji1hdX8R5Wdp894=;
        b=u7hHqTZywIxE8MLoyFW2EXZb5cjlAcVqaOlOQFmXQhqR+MynE/hfxzd89RQ/T2rj/y
         93XD3Xo/NIu8edKaE3ESqTpNvlgNKL5vV6aMKM5S8Z7VPGQf2NnMHLzRhT6/sMskHmqY
         PfkmFVyifd9lR8eW1KswnJaeTdednpFz8bX9/6eUDVJlXmSWhm9tbRtmpejEkapDl/Wm
         AV7QUbP0piVTIxrmC5k2zefoG3aKqgpCMaqeY/LrF62NIRNweyFGpu3G7vrkFxjlq3AK
         qRlMH96CahWBG0E0AJ7jHEFvIomYYL9rtayY95B18I33Ynwvy703376UlJFWHj1rmCH8
         3ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sA426J+Q2BdIVmCpajOCZw4cS8H0Ji1hdX8R5Wdp894=;
        b=r5NpPjKEDfDeMw0t8G1ieVcFcELh3m1AW22EJI8zw5q5uVwjVWBLJRq6yxSsAu0x9f
         gVFaCyOKdBZVajjlhcvqok51wV3ujgMQTY27AqWyvp3bNn2OMnq0sM1n9/GJLJ7Q9kUo
         XNe5OJHVrqDS5tWHcHWEYgUphEpBtLAmVeztoeNWuTSwPrwcS+rLN99lEBzFzIZS7cpp
         AL8umR8oZr3NtxfqY8stjsIwIV9oReo34GrQNdSq/wohSJYT76uGaWvc3awA/fJ9ll9G
         CVH5X4njPb1yM4v7HsSZCgUxnTHBydaLaWDtSt3fUplHfzGKDALUQbZ9buTbWE4AEj+5
         /Zgw==
X-Gm-Message-State: AOAM533KLM6Jkf4ft3X15Aoi6JTKezMNzmgJeiWmNIfZDVJ/U5NCEyMo
        OBFVKxX1IwbYeqWDn9kbFNprmQ==
X-Google-Smtp-Source: ABdhPJxvG2W6zf5u94rM+ZpnqP6aARzp6QYL4zvpGDgITn+W0Kuj+uyQ9GrIirblRjMQQoNluoVnuQ==
X-Received: by 2002:a63:5a5d:: with SMTP id k29mr15680986pgm.215.1621898520339;
        Mon, 24 May 2021 16:22:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z2sm4550841pgz.64.2021.05.24.16.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:21:59 -0700 (PDT)
Date:   Mon, 24 May 2021 23:21:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if
 vmcs12 PID isn't mappable
Message-ID: <YKw1FGuq5YzSiael@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-8-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520230339.267445-8-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021, Jim Mattson wrote:
> Don't allow posted interrupts to modify a stale posted interrupt
> descriptor (including the initial value of 0).
> 
> Empirical tests on real hardware reveal that a posted interrupt
> descriptor referencing an unbacked address has PCI bus error semantics
> (reads as all 1's; writes are ignored). However, kvm can't distinguish
> unbacked addresses from device-backed (MMIO) addresses, so it should
> really ask userspace for an MMIO completion. That's overly
> complicated, so just punt with KVM_INTERNAL_ERROR.
> 
> Don't return the error until the posted interrupt descriptor is
> actually accessed. We don't want to break the existing kvm-unit-tests
> that assume they can launch an L2 VM with a posted interrupt
> descriptor that references MMIO space in L1.
> 
> Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 706c31821362..defd42201bb4 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  				offset_in_page(vmcs12->posted_intr_desc_addr));
>  			vmcs_write64(POSTED_INTR_DESC_ADDR,
>  				     pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
> +		} else {
> +			/*
> +			 * Defer the KVM_INTERNAL_ERROR exit until
> +			 * someone tries to trigger posted interrupt
> +			 * processing on this vCPU, to avoid breaking
> +			 * existing kvm-unit-tests.

Run the lines out to 80 chars.  Also, can we change the comment to tie it to
CPU behavior in someway?  A few years down the road, "existing kvm-unit-tests"
may not have any relevant meaning, and it's not like kvm-unit-tests is bug free
either.  E.g. something like

			/*
			 * Defer the KVM_INTERNAL_ERROR exit until posted
			 * interrupt processing actually occurs on this vCPU.
			 * Until that happens, the descriptor is not accessed,
			 * and userspace can technically rely on that behavior.
			 */ 

> +			 */
> +			vmx->nested.pi_desc = NULL;
> +			pin_controls_clearbit(vmx, PIN_BASED_POSTED_INTR);
>  		}
>  	}
>  	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
> @@ -3689,10 +3698,14 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>  	void *vapic_page;
>  	u16 status;
>  
> -	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
> +	if (!vmx->nested.pi_pending)
>  		return 0;
>  
> +	if (!vmx->nested.pi_desc)
> +		goto mmio_needed;
> +
>  	vmx->nested.pi_pending = false;
> +
>  	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
>  		return 0;
>  
> -- 
> 2.31.1.818.g46aad6cb9e-goog
> 
