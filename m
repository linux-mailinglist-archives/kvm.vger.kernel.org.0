Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5DA57BD3C
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbiGTRxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiGTRxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:53:48 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81A85C9F6
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:53:47 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y15so10915244plp.10
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O/Al1R5ZaPxag7zuieAh2Klr5l3IIXmTVtnz4DBe9kE=;
        b=L5eCiHPic82jvrGy8eviOxLocm+bUhF9zXDvSe3lXquqr5BiyI7gWbliS5TOC0uzTK
         vpCZR49PHCShxi6qUHYcu76iIqJtC+pOobAqfEKUYeR57fYA+VVz2o22lEXIUNo8VuLc
         OignMRlx3uxLF1Xzphm/gw+52RX8aa9KgW48tavtReu7JSfk9zR6w+Of0D2wiCzadVNo
         OsxLuViI5K7FxrofivrD8OOOZ8iycP3vK65xoIj/IMEQb7oy4eXoeRcAS/hRbm+IJGNh
         mK9g9PeeWD1WcJ97Sk1EH6lGweFo0tKUuawgOQkRPcj1FXpRu8O0YX62iUuIW1w74skl
         FLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O/Al1R5ZaPxag7zuieAh2Klr5l3IIXmTVtnz4DBe9kE=;
        b=QZErc7P4iMbkAnFwc4TOs8XFuVAgB4tAfQsAdJQBQCupo4enD3Y4vvDZtwZbd9GSmU
         6URpzot2mRRhwxJXQgica0Xo/Qzpb2znDqsaYYY6mYcwDBQFC44Ctbagka5/bsmhJPIc
         8jFwX3xXtEFEXqqssudwQLKppR7oWpf0+Hbl8tFN/MhBBf4Z8+VOabe0gUee0sbXK1pH
         k1HThKPc/VdhunNsrkq9P9WPfa3krPb+so0yBhc/TGdQrzyzXlsEjUJfGTm0n0ebqITg
         h/noG5ytCjcuMOoIQobcwHE79c/FUcmZ4k7L440CGSXJ4UfkMXulOWHMyKJtqRKwJqpA
         AY4Q==
X-Gm-Message-State: AJIora82JhXWuOs7I4d6e00Qu0UCRDRsR38VPEko3fkzlZW42U9IH46Z
        m5PsJIFMXbdkQ/yAhXUEdHoaZg==
X-Google-Smtp-Source: AGRyM1vsyixSW4O3ki2duNTHeATcGTzaR/YXOLSIDbM9C3jky/23fESZc/anbhv3UrAtkeLB9U2tjA==
X-Received: by 2002:a17:90b:4d0e:b0:1f1:9109:99df with SMTP id mw14-20020a17090b4d0e00b001f1910999dfmr6716536pjb.234.1658339627255;
        Wed, 20 Jul 2022 10:53:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c135-20020a621c8d000000b005290553d343sm13793677pfc.193.2022.07.20.10.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:53:46 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:53:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 3/7] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Message-ID: <YthBJsKOhgHfVs1u@google.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-4-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622004924.155191-4-kechenl@nvidia.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Kechen Lu wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
> exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
> not allowed in guest, e.g. because it's not supported or the CPU doesn't
> have an aways-running APIC timer.
> 
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Kechen Lu <kechenl@nvidia.com>

Needs your SOB.

> Suggested-by: Chao Gao <chao.gao@intel.com>

For code review feedback of this nature, adding Suggested-by isn't appropriate.
Suggested-by is for when the idea of the patch itself was suggested by someone,
where as Chao's feedback was a purely mechanical change.

> ---
>  arch/x86/kvm/x86.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b419b258ed90..6ec01362a7d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4199,6 +4199,16 @@ static inline bool kvm_can_mwait_in_guest(void)
>  		boot_cpu_has(X86_FEATURE_ARAT);
>  }
>  
> +static u64 kvm_get_allowed_disable_exits(void)
> +{
> +	u64 r = KVM_X86_DISABLE_VALID_EXITS;

In v3 I "voted" to keep the switch to KVM_X86_DISABLE_VALID_EXITS in the next
patch[*], but seeing the result I 100% agree it's better to handle it here since
the "enable" patch previously used KVM_X86_DISABLE_VALID_EXITS.

[*] https://lore.kernel.org/all/Ytg428sleo7uMRQt@google.com

> +
> +	if(!kvm_can_mwait_in_guest())

Space after the "if".
