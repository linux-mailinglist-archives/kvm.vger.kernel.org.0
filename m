Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D8A56ABBF
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 21:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiGGTVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiGGTVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 15:21:16 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C3CE4
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 12:21:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j3so8690707pfb.6
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 12:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2OOLLrTcrQtidHb2+zGL75wMQqYiaMGjbuq8np4uHTg=;
        b=YOv1JLWDM4ImVZcanpRaxjVzUT4gR+mMzVxZp3MJekk6P9yLcNHAH/RN+WobjmPMS4
         P27llEfBRHZyrxQ9pOLkcg7wf1g3NH+gtd5vTeinN/YHmgCDantoL1eBoGrsX9Icc7UA
         qlJwCACBCit7/G9U4yV9iNfkoe6c+h5VCqSInrnGhXwY6KZ7fUnPGcE+pwz0BTnUMvro
         uqt5dQZBLw2QhnxJH/DeApbJ0ErenboQoowYX7pmjnTTwVAzo5BHGNQNNWiywZ2ZQkpR
         mc8mjLec2/jL9wnw/UvPCyzNszz8kn9tUinr0l1V80cNKrElaNqn++QFpjfq4z5MEIm3
         n6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OOLLrTcrQtidHb2+zGL75wMQqYiaMGjbuq8np4uHTg=;
        b=fQbLz3NwyopkJATf1EYvGprFAFbs2TU4TtA6LXV+YQsxLKdGaRH06NIGTnFDZVqebO
         D2CNAmNRV3kNUbJiDHsrGragXHfahCJNpYe7maol7ty0nXPxAnbeRe4/yUp7CvdA6e+c
         pdw2QfB1NsEHnEwcBuVCUY/i2yNx/8qUc2Sr5ToF7jg4eiyLXl3p3dnD+kHbTFfhbhRA
         QOoD3lDFdvmRC2pbQfSOkb7dHJvzKX6N0P2LNuMZY0PYHPuq7kU9RJm92ZTJcM+CSYGX
         Njy7Xc8tvP00dYSfw1WpMGucBJLWFZlBCIEagBvfNPYcadzdrb8BTcvWpXBb92ZWDum2
         Y32g==
X-Gm-Message-State: AJIora9Ma4sEoKWHFwnnRrTriizbMtyfYVamWt+r+pD/u0XbAeQ9qQp1
        0zWRUHRlCdNqjiEUrO/O7+qi5g==
X-Google-Smtp-Source: AGRyM1t8opT4+wmjuZULtYNS9M8AQb4kneJPVKozZvyB1CuFGMWw+rFlAXf8PyGr05PMZ/zIcdi2YA==
X-Received: by 2002:a17:902:ce8f:b0:16b:fbc1:9529 with SMTP id f15-20020a170902ce8f00b0016bfbc19529mr12854883plg.159.1657221674255;
        Thu, 07 Jul 2022 12:21:14 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z67-20020a623346000000b005288b568d17sm6274632pfz.167.2022.07.07.12.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 12:21:13 -0700 (PDT)
Date:   Thu, 7 Jul 2022 19:21:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/3] KVM: x86: Don't deflect MSRs to userspace that can't
 be filtered
Message-ID: <YscyJf3pzsSVZonS@google.com>
References: <20220703191636.2159067-1-aaronlewis@google.com>
 <20220703191636.2159067-4-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220703191636.2159067-4-aaronlewis@google.com>
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

On Sun, Jul 03, 2022, Aaron Lewis wrote:
> If an MSR is not permitted to be filtered and deflected to userspace,
> don't then allow it to be deflected to userspace by other means.  If an
> MSR that cannot be filtered #GP's, and KVM is configured to send all
> MSRs that #GP to userspace, that MSR will be sent to userspace as well.
> Prevent that from happening by filtering out disallowed MSRs from being
> deflected to userspace.

Why?  Honest question.  KVM doesn't allow filtering x2APIC accesses because
supporting that would be messy, and there's no sane use case for intercepting
x2APIC accesses if userspace has enabled the in-kernel local APIC.

I can't think of a meaningful use case for intercepting faults on x2APIC MSRs,
but I also don't see anything inherently broken with allowing userspace to intercept
such faults.

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/x86.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 031678eff28e..a84741f7d254 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1712,6 +1712,15 @@ void kvm_enable_efer_bits(u64 mask)
>  }
>  EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
>  
> +bool kvm_msr_filtering_disallowed(u32 index)

Should be static, per the test bot.

> +{
> +	/* x2APIC MSRs do not support filtering. */
> +	if (index >= 0x800 && index <= 0x8ff)
> +		return true;
> +
> +	return false;
> +}
> +
>  bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  {
>  	struct kvm_x86_msr_filter *msr_filter;
> @@ -1721,8 +1730,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  	int idx;
>  	u32 i;
>  
> -	/* x2APIC MSRs do not support filtering. */
> -	if (index >= 0x800 && index <= 0x8ff)
> +	/* Prevent certain MSRs from using MSR Filtering. */
> +	if (kvm_msr_filtering_disallowed(index))
>  		return true;
>  
>  	idx = srcu_read_lock(&kvm->srcu);
> @@ -1962,6 +1971,9 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
>  	if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
>  		return 0;
>  
> +	if (kvm_msr_filtering_disallowed(index))
> +		return 0;
> +
>  	vcpu->run->exit_reason = exit_reason;
>  	vcpu->run->msr.error = 0;
>  	memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
