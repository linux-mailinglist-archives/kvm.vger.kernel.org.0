Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF8C5F80A8
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJGWEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJGWEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:04:10 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378AF103DAE
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:04:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i6so6052435pfb.2
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XOsZTqhkBGMUO8URWfinOEHlfVIqBHPrmMM4nBhifZ0=;
        b=BYgLfXc7qksBEdgpNlm5bLpaxhrhf1ttIAi6HaQSRzZ0xVZvbdcpQBzpibi+dl/EXh
         mugi+qEMuNGllKZnd8xkpAxnJlSZvVTGy6sfpl1DdiLlwGMmndkyPidFE4l3dtJMfObv
         oDihQpbzqNZLYmm6fm+9QB+QbjOfxZPrhr9E3hoQBetqxP6sZuYDEhsRCgdi8uamTT05
         LBPK0gIe64Qwxlv5uq9Svb/M8YcOnkuC4x6U0ePTo+/Akf8Nii6DC2JbIVDXSZ+CajpL
         KfMzl0lclBm+GqSNl4rUTtRENijaU5I4QqJM2YUWPrfVw7nmx/HuS85hnXtwUlKmiuMc
         A4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOsZTqhkBGMUO8URWfinOEHlfVIqBHPrmMM4nBhifZ0=;
        b=pBiZ1QB6MzvEs7wy8yaPgpDpHTarNIzelDnirAXkNXJnJP6p9i/SZGVaGMs9e5udnc
         Jyi7qr7o+cUpUN7uA5j6t0mExM+IUj1oDIZGJQ4j7tH48s/vH/GkmNiDW2bdr0dpunK1
         /LMck4onoe7W1nWbaD94636IYLstFYH1Y9xYrzAv803yYwkpSg+0NkyEFcSjWKV9yfzM
         bIbe/63N7A17Dqyyhszhg53Hl/3/3RtX+FJqbq5D4keCEOnF2QiHvlcTAMTNfcoly/F5
         z96oV9MVAcfjgac10fDLmvSMllJwTYJ/SrFN7c1kqkcDERgNfUVw4CJz+IESo7oxhlCB
         kaRg==
X-Gm-Message-State: ACrzQf0SY58MoHi3939vWiUXSHh7ilK/5/toh3bRPMUbhxiqHjaC/dR1
        iN6pGJyvmQks+DxaatOTZwRDhQ==
X-Google-Smtp-Source: AMsMyM5th3Hita1D7a77UmGVauIdvaps3Egmrqh9W7V0OmJE3Hv+/asvr+fdj/gXidareKnVVBZYgw==
X-Received: by 2002:a05:6a00:1702:b0:562:dda1:c94 with SMTP id h2-20020a056a00170200b00562dda10c94mr2118814pfc.40.1665180248621;
        Fri, 07 Oct 2022 15:04:08 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c3c500b0017c3776634dsm2018042plj.32.2022.10.07.15.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:04:08 -0700 (PDT)
Date:   Fri, 7 Oct 2022 22:04:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v4 2/5] KVM: x86: Add a VALID_MASK for the MSR exit
 reason flags
Message-ID: <Y0CiVMWB3o1b7i/x@google.com>
References: <20220921151525.904162-1-aaronlewis@google.com>
 <20220921151525.904162-3-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921151525.904162-3-aaronlewis@google.com>
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

On Wed, Sep 21, 2022, Aaron Lewis wrote:
> Add the mask KVM_MSR_EXIT_REASON_VALID_MASK for the MSR exit reason

Uber nit, "the mask" is rather redundant, e.g.

Add KVM_MSR_EXIT_REASON_VALID_MASK to track the allowed MSR exit reason
flags.

> flags.  This simplifies checks that validate these flags, and makes it
> easier to introduce new flags in the future.
> 
> No functional change intended.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/x86.c       | 4 +---
>  include/uapi/linux/kvm.h | 3 +++
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..852614246825 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6182,9 +6182,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		break;
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  		r = -EINVAL;
> -		if (cap->args[0] & ~(KVM_MSR_EXIT_REASON_INVAL |
> -				     KVM_MSR_EXIT_REASON_UNKNOWN |
> -				     KVM_MSR_EXIT_REASON_FILTER))
> +		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK)
>  			break;
>  		kvm->arch.user_space_msr_mask = cap->args[0];
>  		r = 0;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eed0315a77a6..44d476c3143a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -485,6 +485,9 @@ struct kvm_run {
>  #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
>  #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
>  #define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
> +#define KVM_MSR_EXIT_REASON_VALID_MASK	(KVM_MSR_EXIT_REASON_INVAL   |	\
> +					 KVM_MSR_EXIT_REASON_UNKNOWN |	\
> +					 KVM_MSR_EXIT_REASON_FILTER)

Put all of these VALID_MASK defines in arch/x86/include/asm/kvm_host.h so that
they aren't exposed to userspace, e.g. see KVM_X86_NOTIFY_VMEXIT_VALID_BITS.
Generally speaking, things should be kept in-kernel unless there's an actual need
to expose something to userspace.  Once something is exposed to userspace, our
options become much more limited.

E.g. if userspace does something silly like:

	filters = KVM_MSR_EXIT_REASON_VALID_MASK;

then upgrading kernel headers will unexpectedly change and potentially break
userspace, and then KVM is stuck having a bogus VALID_MASK.
