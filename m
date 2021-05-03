Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1D6372210
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhECUyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 16:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhECUyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 16:54:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EF5C061573
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 13:53:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id z34so809906pgl.13
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 13:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HG2iNPS4vD6GrbqrBfY2VORMzd+kD2GBhkRPz7mriA8=;
        b=n2ftQwm8noxgljSPL4wW5Y3SCTg7vd3R4Vy7KhuNmyKgm3rffGmKYAZHVOqlUp/Ary
         STPerdv+arJoa+ql79CrWotvXvy2wY/r7yQdYW7+b+WAFHe621SSDOFwnXBPx0HIO6bU
         D5/8di/nCu32y9NFL/tasW5xRLrMDw5tLP81BEwLjInJ2sD+BAKP17UeOpg0pih1j8gU
         ybsslREp0Fqrxstt2SIxjvo2nXSD26MW2fFH3XWNqmmAJhjrXUi4QVICj8l3sOdi3UIb
         waJPUX2VhYTdTxppxyToFNeo4cXrfxoAYvgNCDK3ItobxIl62P/fGelG2hGY8fWdYsFM
         x2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HG2iNPS4vD6GrbqrBfY2VORMzd+kD2GBhkRPz7mriA8=;
        b=IdU8KzyB2Km9kwZsMdzz+GWk7zkDMbtUINIrM2h08/ztQlqeuKseVnxPU37j/e2gLk
         x7rI5bG7qUQYwyvu0LjlaQugWrPo1PsD0Pl0dY2TW+omKNa3rI5c79IzorGyEzdbFgqX
         V3Xkxo5ChDzz7uUTlUZB/yQlLtx1lHsAM13YNE19pBxbtgyJQQUs5U+W0Kd/N3EsvM0V
         MY7STySKF/eaLTwKH3jMGtSeIt1vb0kfDGmoWf+pVCL+Qu2dTzO4F61lva+7ALCOm3t4
         eaLLAA7zVto5oBDKoHvhRvd5krf1jlFnMpHV5dQYRK8lzmqJkBe1uoBcDJfFeqByT/El
         M75A==
X-Gm-Message-State: AOAM532TZcXqP7L80n6snpsSrUxg+EGkUIk4mRn6uyMl6QTwvuI3VWqh
        wPNYwQbwzxIIDoMkAqLGJGnpnK/kSRLiMA==
X-Google-Smtp-Source: ABdhPJyAEygoMk7Ly1OgLpfsjKRWjlj1zjMSVtHgt83+UZ1qGH/TogN/idt2I2LqqUGNhSNwwo7AuQ==
X-Received: by 2002:a05:6a00:c8:b029:260:f25a:f2ef with SMTP id e8-20020a056a0000c8b0290260f25af2efmr20322820pfj.78.1620075193504;
        Mon, 03 May 2021 13:53:13 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g8sm9749944pfo.85.2021.05.03.13.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 13:53:12 -0700 (PDT)
Date:   Mon, 3 May 2021 20:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Hoist input checks in kvm_add_msr_filter()
Message-ID: <YJBitcip8/WIsaB9@google.com>
References: <20210503122111.13775-1-sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503122111.13775-1-sidcha@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 03, 2021, Siddharth Chandrasekaran wrote:
> In ioctl KVM_X86_SET_MSR_FILTER, input from user space is validated
> after a memdup_user(). For invalid inputs we'd memdup and then call
> kfree unnecessarily. Hoist input validation to avoid kfree altogether.
> 
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/kvm/x86.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ee0dc58ac3a5..15c20b31cc91 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5393,11 +5393,16 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
>  	struct msr_bitmap_range range;
>  	unsigned long *bitmap = NULL;
>  	size_t bitmap_size;
> -	int r;
>  
>  	if (!user_range->nmsrs)
>  		return 0;
>  
> +	if (user_range->flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE))
> +		return -EINVAL;
> +
> +	if (!user_range->flags)
> +		return -EINVAL;
> +
>  	bitmap_size = BITS_TO_LONGS(user_range->nmsrs) * sizeof(long);
>  	if (!bitmap_size || bitmap_size > KVM_MSR_FILTER_MAX_BITMAP_SIZE)
>  		return -EINVAL;
> @@ -5413,24 +5418,10 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
>  		.bitmap = bitmap,
>  	};
>  
> -	if (range.flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE)) {
> -		r = -EINVAL;
> -		goto err;
> -	}
> -
> -	if (!range.flags) {
> -		r = -EINVAL;
> -		goto err;
> -	}
> -
> -	/* Everything ok, add this range identifier. */
>  	msr_filter->ranges[msr_filter->count] = range;

Might be worth elminating the intermediate "range", too.  Doesn't affect output,
but it would make it a little more obvious that the new range is mostly coming
straight from userspace input.  E.g.

	msr_filter->ranges[msr_filter->count] = (struct msr_bitmap_range) {
		.flags = user_range->flags,
		.base = user_range->base,
		.nmsrs = user_range->nmsrs,
		.bitmap = bitmap,
	};

Either way:

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  	msr_filter->count++;
>  
>  	return 0;
> -err:
> -	kfree(bitmap);
> -	return r;
>  }
>  
>  static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
> -- 
