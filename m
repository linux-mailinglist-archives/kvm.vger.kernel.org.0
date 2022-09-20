Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5475BEF2F
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiITVdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiITVdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:33:08 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F371D72B43
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:33:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id a29so3967730pfk.5
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qWwy1T8n8n9Tdvr/DoRypsDG6NkS92TiQuapV97dptc=;
        b=rr/PyHgkYMcKbfqM25TQNVASBHHOBEQkboP19XA1vMntPblYqzwOIut6VRxQw8KnAb
         ET0SHpQmfmNYDiQNzROGuIyFhrXSR80luXEw+gPjsgLRFvOKRbyDnuZCWxX2FcOdX8AU
         ITD3WMMfDbH94Wt6mt+Z7yloO5UVwhHa1QERIfAQrLe5SDSBnJDYieTNfMEz4Rh+EnaX
         URCnxCR+46yzz8fZwtIyQHagefWs89TrrZiV4gfl2BrKyw91f/zgIjxDnAV1m9MkweJ0
         fHGy1w/997SH1yfQONaFlYmt8sTNIAaYw0w74gv6u9MpTOOUKiVuPp3b7zZOAdZp7H6R
         HaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qWwy1T8n8n9Tdvr/DoRypsDG6NkS92TiQuapV97dptc=;
        b=to0UvkxbgPmCPt/USX26KIJSGnrxhFz7HqjauGXJFVd+0laiM5M7EO8LjI7SuhptBH
         ALn+t0T53Wr1GbFtL1AOME+zcoyzt2aQp580Mo45tnmdx/wUifh89ok50VLpy31edlfy
         iaNp/4up3kIuL/MiZBYkyuh5WVa24uuPkwyMcpEe/yfeLe7dfY4zQzue9SewsAThEn9I
         lvw8UTPcigHWOlDPZQyWWMpR2gLqlrv9nnSGzh37dIbVS8LZrfaV5Nx1q/isMyUmX0/E
         iQx1kGVNCrzKBjXEB7nDXNu4acNWZpbGeSkUC1Pv8Pz8uAC1MmuiBGtH2YB1wDb4D+JE
         nl7A==
X-Gm-Message-State: ACrzQf3BCKymXeDBz1JTD6JPAvT6Psa687HUmCMvlENDe+y5FS/WUQHx
        Yp1aZkxXE7AVIV6AO6wScGYljw==
X-Google-Smtp-Source: AMsMyM4Youx+wm+8ZwytM+QL6YFCmfmIzS9qtDmO5B6oTXCy6kEUvUc/ikMI8Wcejri5VupgWi5YpA==
X-Received: by 2002:a62:4e4c:0:b0:53e:22b6:6869 with SMTP id c73-20020a624e4c000000b0053e22b66869mr24959226pfb.29.1663709587388;
        Tue, 20 Sep 2022 14:33:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s16-20020aa78bd0000000b0053e7d3b8d6dsm407223pfd.1.2022.09.20.14.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 14:33:06 -0700 (PDT)
Date:   Tue, 20 Sep 2022 21:33:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Justinien Bouron <justinien.bouron@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Handle MXCSR in
 kvm_arch_vcpu_ioctl_{get,set}_fpu.
Message-ID: <YyoxjwuCVTsbmpYv@google.com>
References: <20220917000928.118-1-justinien.bouron@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220917000928.118-1-justinien.bouron@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 17, 2022, Justinien Bouron wrote:
> kvm_arch_vcpu_ioctl_get_fpu does not set the mxcsr in the kvm_fpu
> struct; conversely kvm_arch_vcpu_ioctl_set_fpu does not set the mxcsr
> value in the fxregs_state struct of the vcpu.
> This leads to the KVM_GET_FPU ioctl returning 0 as the mxcsr value,
> regardless of the actual value on the vcpu; while KVM_SET_FPU leaves the
> MXCSR on the vcpu untouched.
> 
> Fix kvm_arch_vcpu_ioctl_{get,set}_fpu to properly handle MXCSR.
> 
> Signed-off-by: Justinien Bouron <justinien.bouron@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 43a6a7efc6ec..c33a2599a497 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11462,6 +11462,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  	fpu->last_ip = fxsave->rip;
>  	fpu->last_dp = fxsave->rdp;
>  	memcpy(fpu->xmm, fxsave->xmm_space, sizeof(fxsave->xmm_space));
> +	fpu->mxcsr = fxsave->mxcsr;
>  
>  	vcpu_put(vcpu);
>  	return 0;
> @@ -11486,6 +11487,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  	fxsave->rip = fpu->last_ip;
>  	fxsave->rdp = fpu->last_dp;
>  	memcpy(fxsave->xmm_space, fpu->xmm, sizeof(fxsave->xmm_space));
> +	fxsave->mxcsr = fpu->mxcsr;

The incoming MXCSR needs to be vetted, e.g. see fpu_copy_uabi_to_guest_fpstate().

That said, this code is incredibly ancient and has been obsolete for years.  I
wonder if we can get away with deprecating KVM_{G,S}ET_FPU on x86 and leaving the
broken behavior as-is.
