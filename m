Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0D4C90F4
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiCAQ44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiCAQ4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:56:55 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C1C5D
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 08:56:12 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z16so14798146pfh.3
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 08:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f5MQggBxdZ8lhJMoW8sZBNRF0A6bMvBQ7KGlaa1mElM=;
        b=Hpr31JSpl9gDEeu3tZzed090pVBm2YQ6j/clb0mb44Lo4JlyoQCc6hRGJd4IMPQY5F
         cGR4O4E24d5QZN43NFb1XSq/l4CgVbZC9YRU6kkVNp+vcu17OXnprzFxlkzCqr8M9w9I
         snmauyge+aMOisb9kdb29TGybMqDAQuUIcokB+EkqpTeMwQ+cs4DY60ggkvqAiA9UNCf
         rD/ijG119Ig3Hn4XNLxSLKc/OtjACoLxu4tL/IWc3fPmRdRH8SEGkFYkke+lvsRjVAwW
         hLGLD1qcwhxYWsYroE8eDfcIqo+c5tYz9dJ653XfAd8PlPjy194x7RGk7+S6c6o2L0w8
         6XEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f5MQggBxdZ8lhJMoW8sZBNRF0A6bMvBQ7KGlaa1mElM=;
        b=WhTPy9qCmqljrVmb/CdhNIcnw6+gDvbk5aXwX9ZAMeeb4wsHA/MM03lMI996YGJUmz
         YQ6VarUwRajimjxDbqgkUD7grSrm0JT2pfscXmbu0WBsTTHe/Km9W+ROvXjTIR/swiKD
         k0bCf+y3l9PGGGvivF49qT+rZoGpA/lYrXDtZjwfJFUgNlGw7xdpnhCxFa73aZ48z00F
         oduF1QXbcjPISuCtI2xobKHfN7BtuvYYeTdJ1wTyr7XWF7s5BHRQfLz50HGs21cQbLm0
         kJX0gmTtS60fVLMX8FdMtwE83dJvURvD57PL/80daf3aQHDqW49UvHJQdYkcQSu4idFc
         CRsw==
X-Gm-Message-State: AOAM530z8h1q2bydeRApP1Ncgic9XXJBCpvj4Z3hZLWZT3g9Ld+3DrMA
        +RCAEoF5pbOB2uzUOHo5rsB9Gw==
X-Google-Smtp-Source: ABdhPJxSMdN2Be+c/CTYH6J/sqMogimTKOSutSxPfFUPKygB/d+95Ao+R0h699MNvWMBlMDR5vkkww==
X-Received: by 2002:a05:6a00:238a:b0:4f3:fbf3:e611 with SMTP id f10-20020a056a00238a00b004f3fbf3e611mr15213646pfc.11.1646153772268;
        Tue, 01 Mar 2022 08:56:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d15-20020a17090ab30f00b001b8e65326b3sm2474768pjr.9.2022.03.01.08.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:56:11 -0800 (PST)
Date:   Tue, 1 Mar 2022 16:56:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default apic
 id when not using x2apic api
Message-ID: <Yh5QJ4dJm63fC42n@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301135526.136554-5-mlevitsk@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please, please post standalone patches/fixes as standalone patches/fixes.  And in
general, keep series to one topic.  There is very real value in following the
established and documented process, e.g. avoids creating artificial dependencies
where a changes works only because of an "unrelated" patch earlier in the series.
And for us reviewers, it helps tremendously as it means I can scan just the cover
letter for a series to prioritize review accordingly.  Bundling things together
means I have to scan through every patch to triage the series..

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> Fix a loop hole in setting the apic state that didn't check if

Heh, "loophole", took me a second to figure out there was no literal loop. :-)

> apic id == vcpu_id when x2apic is enabled but userspace is using
> a older variant of the ioctl which didn't had 32 bit apic ids.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 80a2020c4db40..8d35f56c64020 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2618,15 +2618,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
>  		u64 icr;
>  
> -		if (vcpu->kvm->arch.x2apic_format) {
> -			if (*id != vcpu->vcpu_id)
> -				return -EINVAL;
> -		} else {
> -			if (set)
> -				*id >>= 24;
> -			else
> -				*id <<= 24;
> -		}
> +		if (!vcpu->kvm->arch.x2apic_format && set)
> +			*id >>= 24;
> +
> +		if (*id != vcpu->vcpu_id)
> +			return -EINVAL;

This breaks backwards compability, userspace will start failing where it previously
succeeded.  It doesn't even require a malicious userspace, e.g. if userspace creates
a vCPU with a vcpu_id > 255 vCPUs, the shift will truncate and cause failure.  It'll
obviously do weird things, but this code is 5.5 years old, I don't think it's worth
trying to close a loophole that doesn't harm KVM.

If we provide a way for userspace to opt into disallowiong APICID != vcpu_id, we
can address this further upstream, e.g. reject vcpu_id > 255 without x2apic_format.

> +
> +		if (!vcpu->kvm->arch.x2apic_format && !set)
> +			*id <<= 24;
>  
>  		/*
>  		 * In x2APIC mode, the LDR is fixed and based on the id.  And
> -- 
> 2.26.3
> 
