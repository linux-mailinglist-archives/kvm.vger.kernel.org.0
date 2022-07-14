Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B720575746
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 23:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiGNV46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 17:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiGNV45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 17:56:57 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43852CE00
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 14:56:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q5so1603472plr.11
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 14:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0MLlwBdCINQBCAOIgWWL7C9DlFRyFHQeIiEsS+XwBQ=;
        b=krdIljcH2zQ7xGnfzMDPa9QFjX6aCi+7rw7tMFTC1n5hwheceH5369coQUOrX2AqAM
         LLp8ZGhJs1slOYn4MqqVY+YtsgsgzckQANMrRoOmqDseM+rdu7aXtZjc0KeVY+45wVa6
         6kfzUKa0jwNecF+Unl2i81JKcLa6yIWJ65YSyWHaEQkigb9sQT8eYt8mEGM5YGmedenw
         ywpnFMbMRuzIbd+t4jNttUK4VsPsF82werJTF+ynpvudlpD2TuClVa+y88Pa+1v/UNPd
         ImSopTUSyCxWqG7erU6QvEFljA1KctOnaDYugdkUlIZPzKV7vbpwfR6+5+vDlXLyUiv+
         qnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0MLlwBdCINQBCAOIgWWL7C9DlFRyFHQeIiEsS+XwBQ=;
        b=5sETTxVMWAV5oGjHxKL4Ju5LKaPDj1L1jfOhPGdgbXLK31+XrIrpII7G4LTvdqStMG
         aNBDn19co5sc9ySMpgo7Lk5t/scdy1Y90Vpqd7Z9NEWerszCY4E4NC/UDJ9SxGGvxrBP
         m2Ki2WgOxCGxCIw5AfM/rssmiK2DOCWvCOqS5U9HLpJ5ALEIwih746F8OQood5QKNLST
         mo9vrs3uc4C1YyKrxsVaG4Bu551R526j16FUNnsOPQWxtkCidC4d1DMqCl+NZEf8/uan
         wXhtilIN4mz0BN6+rJK57vubFRoyAIR34sE4p+yKzfYS32lZfGuo4437oMxRQbkK8UvZ
         H1mg==
X-Gm-Message-State: AJIora/mrT63JnKKi9fKNntigDbLqwdwYThtDU4WxKoRi4pEBMR+slaq
        s8zoLQK3pNuAgVW/4CVBDx/KTA==
X-Google-Smtp-Source: AGRyM1sO3XH/3jbrL787iYI3U2XpFIxgT5ZRw5cPMHq0vJt49LmspUXgH0RX5tghqMZyjKOzy/Y1aQ==
X-Received: by 2002:a17:902:8bc2:b0:16c:2bd8:8dae with SMTP id r2-20020a1709028bc200b0016c2bd88daemr10261021plo.160.1657835816235;
        Thu, 14 Jul 2022 14:56:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x89-20020a17090a6c6200b001e2f892b352sm4141358pjj.45.2022.07.14.14.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 14:56:55 -0700 (PDT)
Date:   Thu, 14 Jul 2022 21:56:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [RFC PATCH] KVM: x86: Protect the unused bits in MSR exiting
 flags
Message-ID: <YtCRJAbGLbdhdIdG@google.com>
References: <20220714161314.1715227-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714161314.1715227-1-aaronlewis@google.com>
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

On Thu, Jul 14, 2022, Aaron Lewis wrote:
> The flags for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
> have no protection for their unused bits.  Without protection, future
> development for these features will be difficult.  Add the protection
> needed to make it possible to extend these features in the future.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
> 
> Posting as an RFC to get feedback whether it's too late to protect the
> unused flag bits.  My hope is this feature is still new enough, and not
> widely used enough, and this change is reasonable enough to be able to be
> corrected.  These bits should have been protected from the start, but
> unfortunately they were not.
> 
> Another option would be to correct this by adding a quirk, but fixing
> it that has its down sides.   It complicates the code more than it
> would otherwise be, and complicates the usage for anyone using any new
> features introduce in the future because they would also have to enable
> a quirk.

The tried and true KVM method of adding '2' is probably the way to go:

	case KVM_CAP_X86_USER_SPACE_MSR2:
		r = -EINVAL;
		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK))
			break;
		fallthrough;
	case KVM_CAP_X86_USER_SPACE_MSR:
		if (cap->cap == KVM_CAP_X86_USER_SPACE_MSR)
			cap->args[0] &= KVM_MSR_EXIT_REASON_VALID_V1_MASK;
		kvm->arch.user_space_msr_mask = cap->args[0];
		r = 0;
		break;

Or maybe

	case KVM_CAP_X86_USER_SPACE_MSR2:
	case KVM_CAP_X86_USER_SPACE_MSR:
		r = -EINVAL;
		if (cap->cap == KVM_CAP_X86_USER_SPACE_MSR)
			cap->args[0] &= KVM_MSR_EXIT_REASON_VALID_V1_MASK;
		else if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK))
			break;
		kvm->arch.user_space_msr_mask = cap->args[0];
		r = 0;
		break;

Ugly, but not too complex.  But I'm getting ahead of things :-)

> For long term simplicity my hope is to be able to just patch the original
> change.

Agreed.

>  arch/x86/kvm/x86.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1910e1e78b15..ae9b7df86b1a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6029,6 +6029,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		break;
>  	case KVM_CAP_X86_USER_SPACE_MSR:
> +		r = -EINVAL;
> +		if (cap->args[0] & ~(KVM_MSR_EXIT_REASON_INVAL |
> +				     KVM_MSR_EXIT_REASON_UNKNOWN |
> +				     KVM_MSR_EXIT_REASON_FILTER))

Add a KVM_MSR_EXIT_REASON_VALID_MASK to define all of these.  Ditto for the
filter flags even though there's only one.  And if we want to go this route, we
shouldn't definitely add a testcase in selftests.

> +			break;
>  		kvm->arch.user_space_msr_mask = cap->args[0];
>  		r = 0;
>  		break;
> @@ -6183,6 +6188,9 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>  	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
>  		return -EFAULT;
>  
> +	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
> +		return -EINVAL;
> +
>  	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
>  		empty &= !filter.ranges[i].nmsrs;
>  
> -- 
> 2.37.0.144.g8ac04bfd2-goog
> 
