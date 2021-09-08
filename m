Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573F24031C5
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 02:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbhIHAIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 20:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbhIHAIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 20:08:49 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043B1C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 17:07:42 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s11so590795pgr.11
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 17:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fCvjHDf9KGIiGHjDCefyCqJZ5JZISjuKfKdmD//avU=;
        b=BhyC1yVOHW/h10hVsNbRrSm8Ej1gHTMXX3iTFQQq2GUHF3Sr9D00KCqQrC5WTFUBA9
         QZ7YbIdb4oMafCvO03W8iEql06DV0W9RQ19EFnI3QNalMG4vLxzOVP5ur/YzkRKgmx/P
         mp+bM+/D8YTYoQ3/vKJQgTh/bsbpcFzDPB7rQ474CACwSGXCDotzR2NG7S56V74vEdQE
         tqlIpGq+kOkp2Iox/k0pq6QKYAmFj5I1lCr3m4pscUPyCte/gnIloD/E8d9LsimXC4y4
         iuyqAqNebZwr0uBN8E5sxnjnTq85ZXpyRiVIcqGpVtQhtvg/4aBR3s0Rg/DI2bzLtz6P
         3CFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2fCvjHDf9KGIiGHjDCefyCqJZ5JZISjuKfKdmD//avU=;
        b=qSXmAXLOzfJsC1Jw0+l6oagB07WhfZQ68b4ZPyGnKyhalGeAKtRklqzKbPk/kX6NGT
         2NmclnhW1b24Juzt5x8+qODQr26j7KUxf0mN7oWvE0tK9CGoqcLiFXVPWaAA2sfN4BFU
         UFhztSVD31xzYAaMdZwzc7l7ToEXU9nKKEw8QNoGwnU2OfHfH2mWXb2hprYhEGuPQlus
         WpVhM8grM7HWnNMbgcpIDAXJY2COvBZbDrh6Fg5XMpjrjo3QPHCgB6EYEbiOCgPr1wrv
         WuAdDopt8HovHSF5IZy7Sm/eQzNcIO0ZVZZ+f5RTRORlzmHS+C1FydeQ7Lzxx8B7hgpj
         8GTg==
X-Gm-Message-State: AOAM530R0vozxoflDLYs3M6v2hd54WFTaBZeNzg4c3RDU32nWG+9PL77
        XXWUTnV07HYOn6A3rM+5ubYZLQ==
X-Google-Smtp-Source: ABdhPJyZewfiLnqQlasRdxCfn1bHxX5afk7F0zUPiVLjsx2DMGr9Kq7zwb1Q1aTLVuQUEileUMMP4A==
X-Received: by 2002:a63:c045:: with SMTP id z5mr896214pgi.374.1631059662344;
        Tue, 07 Sep 2021 17:07:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u7sm159614pjn.45.2021.09.07.17.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 17:07:41 -0700 (PDT)
Date:   Wed, 8 Sep 2021 00:07:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
Message-ID: <YTf+ygFFLWdHXHX3@google.com>
References: <20210906014323.170235-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906014323.170235-1-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 06, 2021, Zhenzhong Duan wrote:
> Host value of TSX_CTRL_CPUID_CLEAR field should be unchangable by guest,
> but the mask for this purpose is set to a wrong value. So it doesn't
> take effect.

It would be helpful to provide a bit more info as to just how bad/boneheaded this
bug is.  E.g.

  When updating the host's mask for its MSR_IA32_TSX_CTRL user return entry,
  clear the mask in the found uret MSR instead of vmx->guest_uret_msrs[i].
  Modifying guest_uret_msrs directly is completely broken as 'i' does not
  point at the MSR_IA32_TSX_CTRL entry.  In fact, it's guaranteed to be an
  out-of-bounds accesses as is always set to kvm_nr_uret_msrs in a prior
  loop.  By sheer dumb luck, the fallout is limited to "only" failing to
  preserve the host's TSX_CTRL_CPUID_CLEAR.  The out-of-bounds access is
  benign as it's guaranteed to clear a bit in a guest MSR value, which are
  always zero at vCPU creation on both x86-64 and i386.   

> Fixes: 8ea8b8d6f869 ("KVM: VMX: Use common x86's uret MSR list as the one true list")

Cc: stable@vger.kernel.org

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..36588b5feee6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6812,7 +6812,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  		 */
>  		tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
>  		if (tsx_ctrl)
> -			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +			tsx_ctrl->mask = ~(u64)TSX_CTRL_CPUID_CLEAR;

Egad, that's a horrific oversight on my part.

Reviewed-by: Sean Christopherson <seanjc@google.com>
