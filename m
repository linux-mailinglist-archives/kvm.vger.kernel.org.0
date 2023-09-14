Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBF579FD0D
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 09:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjINHQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 03:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINHQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 03:16:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16EFA91
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694675764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eC3Q4tzSYTsbLn58OTI918IEI3Pmjt2ebY6pz298m/8=;
        b=OYdcSxpGdzHZkypaZKMxt5jIPYVhFVLHxQ/RdMk3PP80yf+nikmWoVynQnseRXjXx8SX3Z
        dj9ltr/oKp1yOriIjvwNnRxrywuui9eFgVOaP+MdvT1z2hXbq4ycSUdNefFHyo6N2/kwUJ
        swnI11Xv0p0MuwImgJS9sR8IJ9tzkN8=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-R-bYe_lAN-WV3WYE50_k1g-1; Thu, 14 Sep 2023 03:16:02 -0400
X-MC-Unique: R-bYe_lAN-WV3WYE50_k1g-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3ab244d5c9cso955488b6e.3
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 00:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694675762; x=1695280562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC3Q4tzSYTsbLn58OTI918IEI3Pmjt2ebY6pz298m/8=;
        b=LeII4f6joH6eoS16W0nP8OK7FqJl+2gAqb+kxm0AFpOhcHLe3fqUw6pJokl0m6UerX
         2BzBJmQMhUnFlYIK0AAfFAHzvG0pxppUdlCXqn/1BzsEVjsXeGZMi4TiLKAeJEh0l0Ol
         0xwjLD5d++bcP2H/+VXEa7g9KBBnH37sY19NTayxiG1OBbsTksxNzYxZQ4gnKL62mPqj
         LaFgQtZD2RCBvl9y/OfhK9pewF+zhVpccZE0OsrKchGrtv+cMweIGV7tF6hk9cQlsbLW
         VE3xEEpC6zohiXGbudV6sTxcQMHHoAE5spCZ6M2TqtOJPYi0BTrXoy2k86/xCAN7twqD
         6tiA==
X-Gm-Message-State: AOJu0YxcnEGAa2qXmu3A5AZ+/DeD0KjkCmyegweJ9l2x1DD0zu9KiZZA
        vkfpYvCx36FIq+dhV6naTFoYictLI1g+x8fqbbE1xhcJsfdwl7rNEWblxSX4gyGqCbv3b1NAaaH
        0P7UIOIyn42Hr
X-Received: by 2002:a05:6808:23c9:b0:3a8:4903:5688 with SMTP id bq9-20020a05680823c900b003a849035688mr5939020oib.34.1694675762029;
        Thu, 14 Sep 2023 00:16:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1dHblLDCutO1e4SrBBOXVzPFTKh/pwI1PBXkNsyUyD3N+1Zj3QTMPNbg93xvLyuk+507vxw==
X-Received: by 2002:a05:6808:23c9:b0:3a8:4903:5688 with SMTP id bq9-20020a05680823c900b003a849035688mr5939012oib.34.1694675761799;
        Thu, 14 Sep 2023 00:16:01 -0700 (PDT)
Received: from redhat.com ([2804:1b3:a803:4ff9:7c29:fe41:6aa7:43df])
        by smtp.gmail.com with ESMTPSA id t25-20020a9d66d9000000b006b9a98b9659sm423555otm.19.2023.09.14.00.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 00:16:01 -0700 (PDT)
Date:   Thu, 14 Sep 2023 04:15:54 -0300
From:   Leonardo Bras <leobras@redhat.com>
To:     Tyler Stachecki <stachecki.tyler@gmail.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dgilbert@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
Message-ID: <ZQKzKkDEsY1n9dB1@redhat.com>
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914010003.358162-1-tstachecki@bloomberg.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023 at 09:00:03PM -0400, Tyler Stachecki wrote:
> Live-migrations under qemu result in guest corruption when
> the following three conditions are all met:
> 
>   * The source host CPU has capabilities that itself
>     extend that of the guest CPU fpstate->user_xfeatures
> 
>   * The source kernel emits guest_fpu->user_xfeatures
>     with respect to the host CPU (i.e. it *does not* have
>     the "Fixes:" commit)
> 
>   * The destination kernel enforces that the xfeatures
>     in the buffer given to KVM_SET_IOCTL are compatible
>     with the guest CPU (i.e., it *does* have the "Fixes:"
>     commit)
> 
> When these conditions are met, the semantical changes to
> fpstate->user_features trigger a subtle bug in qemu that
> results in qemu failing to put the XSAVE architectural
> state into KVM.
> 
> qemu then both ceases to put the remaining (non-XSAVE) x86
> architectural state into KVM and makes the fateful mistake
> of resuming the guest anyways. This usually results in
> immediate guest corruption, silent or not.
> 
> Due to the grave nature of this qemu bug, attempt to
> retain behavior of old kernels by clamping the xfeatures
> specified in the buffer given to KVM_SET_IOCTL such that
> it aligns with the guests fpstate->user_xfeatures instead
> of returning an error.

So, IIUC, the xfeatures from the source guest will be different than the 
xfeatures of the target (destination) guest. Is that correct?

It does not seem right to me. I mean, from the guest viewpoint, some 
features will simply vanish during execution, and this could lead to major 
issues in the guest.

The idea here is that if the target (destination) host can't provide those 
features for the guest, then migration should fail.

I mean, qemu should fail the migration, and that's correct behavior.
Is it what is happening?

Regards,
Leo

> 
> Fixes: ad856280ddea ("x86/kvm/fpu: Limit guest user_xfeatures to supported bits of XCR0")
> Cc: stable@vger.kernel.org
> Cc: Leonardo Bras <leobras@redhat.com>
> Signed-off-by: Tyler Stachecki <tstachecki@bloomberg.net>
> ---
>  arch/x86/kvm/x86.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6c9c81e82e65..baad160b592f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5407,11 +5407,21 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
>  static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
>  					struct kvm_xsave *guest_xsave)
>  {
> +	union fpregs_state *ustate = (union fpregs_state *) guest_xsave->region;
> +	u64 user_xfeatures = vcpu->arch.guest_fpu.fpstate->user_xfeatures;
> +
>  	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>  		return 0;
>  
> -	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
> -					      guest_xsave->region,
> +	/*
> +	 * In previous kernels, kvm_arch_vcpu_create() set the guest's fpstate
> +	 * based on what the host CPU supported. Recent kernels changed this
> +	 * and only accept ustate containing xfeatures that the guest CPU is
> +	 * capable of supporting.
> +	 */
> +	ustate->xsave.header.xfeatures &= user_xfeatures;
> +
> +	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, ustate,
>  					      kvm_caps.supported_xcr0,
>  					      &vcpu->arch.pkru);
>  }
> -- 
> 2.30.2
> 

