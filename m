Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0754D38F533
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 23:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhEXVza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 17:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhEXVz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 17:55:29 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E2C061756
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:54:01 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i5so21132795pgm.0
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 14:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y7H6pCP7/yViKEmHdKMC147HRDRySUoBtMkLMOdzOEY=;
        b=QkDsj98CjSxsb0UVBSUKnaRnpNYKcn+hGZ9oD5zxCYio1dHxtpr/gk8UTTwhWYwyYP
         h1RBH+oRPt5vanKSGKlCbL7DCgH3Jqo+i4kcIxadUbNjV1jMH7fIu8gc8hgo8aBLGeAG
         D40biFug8QAimDQ3VPX5TDjLk/0ySZebc4j5D5kFYrX0ODB1XVMF6ogSm6ahTsyxrnK1
         j2Otr8+l2q9GHCs1T4MA1zQYvTYOdTcfawV+5vjb2a9otNsa0QUxd0DDrddKHf5AlqKF
         UfuBH8aQvpsvk97CFt4byKXdErvqzoDGe/EDQmJGTI5Jp8TVmeyycw/XBOcz4ahUf7+a
         VI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y7H6pCP7/yViKEmHdKMC147HRDRySUoBtMkLMOdzOEY=;
        b=iG1opvs/c30wgNxaijoKHbbPXSvKxcsaguMQ9BIT2FYdGWgYfKOWQnNHzNwD3RkpFs
         SeoH99ZxoAcla56s5Qp2A4ghDp4eW4bZurXylkFuIjWWNPB4mt709PQEPfSAS5nKP4Vc
         AM9QdJ+h9dZYfFYJLmujn4NtwXunvMKZTBOG9QgfBaUOZImekMoWmJr8jRH75lTOmSNg
         /rNQ/WGTB0MXHzeIwkHSPYgS3Lk/PC9eUBPjzogWq2F2mqJ3aG0vI41kHALCA9sYUJK4
         RGdIaXFdoZaBuuEUs7FdZkFKy4G7+XfE4auspVNw3wd0vMvhoFVHmIxClQucCmkjJmaT
         kG3w==
X-Gm-Message-State: AOAM533y+lDaPr+yDysStaZrzQLh8NdEaGI3Ep7SxpuUhFTYN13UrAAa
        A+f7yCRseaklpUWyvoZwMp98Jw==
X-Google-Smtp-Source: ABdhPJwOHx8ecBfE8DDXSATrpxTZSwQywYuF9nhhh9re21Qri4jNYnxAiTEG7CWkP8IKSrkddgSz8g==
X-Received: by 2002:a05:6a00:882:b029:2de:b01d:755a with SMTP id q2-20020a056a000882b02902deb01d755amr26872259pfj.43.1621893240451;
        Mon, 24 May 2021 14:54:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id q24sm12235699pgk.32.2021.05.24.14.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:53:59 -0700 (PDT)
Date:   Mon, 24 May 2021 21:53:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Liu <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 7/7] kvm: x86: AMX XCR0 support for guest
Message-ID: <YKwgdBTqiyuItL6b@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-8-jing2.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207154256.52850-8-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021, Jing Liu wrote:
> Two XCR0 bits are defined for AMX to support XSAVE mechanism.
> Bit 17 is for tilecfg and bit 18 is for tiledata.

This fails to explain why they must be set in tandem.  Out of curisoity, assuming
they do indeed need to be set/cleared as a pair, what's the point of having two
separate bits?

> Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> ---
>  arch/x86/kvm/x86.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bfbde877221e..f1c5893dee18 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -189,7 +189,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
>  				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> -				| XFEATURE_MASK_PKRU)
> +				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>  
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
> @@ -946,6 +946,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  		if ((xcr0 & XFEATURE_MASK_AVX512) != XFEATURE_MASK_AVX512)
>  			return 1;
>  	}
> +
> +	if (xcr0 & XFEATURE_MASK_XTILE) {
> +		if ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE)
> +			return 1;
> +	}
> +
>  	vcpu->arch.xcr0 = xcr0;
>  
>  	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
> -- 
> 2.18.4
> 
