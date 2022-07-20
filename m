Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728B957BC6C
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbiGTRNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbiGTRNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:13:49 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2746E8B9
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:13:47 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id e16so17014848pfm.11
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2iDISCtMujoYb4pXrtkdCn8rbdQJ82HuBDJ0+/zcH90=;
        b=FH+PekUtFfV6pCGLo8uxIDW9LlIKE8Oj1r0NOE0z9UjfPdJ6jNT52Sw/k7AsmP9Syd
         c+Nf2wjxnJodwudEymZdXsJGWMO6ZhKl+NFWUK6gugXNnKi806TXU3PO/+0QOMVviOzX
         NMkCcOkk57XTehSLbxDd6wmgYI9ZH0E3Sqc0BU/3EJk4AHfiNsIUua4pOgZjdiUAgp2o
         4UkaLNfp9uWOPEUTOulda8K7Yrn1l/Ij3uwNt4/3El0vpK+19DYn+xo/Le6ddGizayDA
         y9eZbH14mzK8vrr1Q1Qhc7RFniEVi/CYnspteYo6Q7BJou9yyyg0RUewg2Yks91NNxUI
         +dcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2iDISCtMujoYb4pXrtkdCn8rbdQJ82HuBDJ0+/zcH90=;
        b=xiZXM3gUYAjnt9sn+/gU7gvVvK8W1i+CH7x+/tCvZD4fDd9fY9xK69MifKSA5Iau+m
         Bwvfok2PnyVlYIyiTorAd1dhVKPuoUuKT8BCPFUFarFX8u9QyW2Zuexa5DWfcEsX851U
         PWGxNoirN+MMktnfSeYLKktmHzwYpOSh6MEIpawXwPGUZVhpw5sXzAxp8J7D++z8T7kp
         gyn4pr6eh9MuCFmXkxm/yRuJaaW6//57lT7NCbYINmFbEb76l+347C2JYqGTj2X2ULOh
         4JbUEOerRxGwXvCeUIwl7Ve1AxllYYVEOKeOb+tYaJUCZDKpKxRB80RSGHP6zsM6ly52
         G32A==
X-Gm-Message-State: AJIora8SsBBj52LmUAeUX1XEKAoB/QGwASmoHmRoATlevkoETGHKEJoy
        AtP4092IUI073J7RmkmKDRD4+g==
X-Google-Smtp-Source: AGRyM1ukaae49eieQG9eqzW9jOyZthb7CjGb22iyaiJSCFelzdR6Ij6IZfypk2lJdDbeFNT43k1yrQ==
X-Received: by 2002:aa7:870b:0:b0:522:c223:5c5e with SMTP id b11-20020aa7870b000000b00522c2235c5emr40260065pfo.6.1658337226778;
        Wed, 20 Jul 2022 10:13:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h14-20020a63e14e000000b004161b3c3388sm12108750pgk.26.2022.07.20.10.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:13:46 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:13:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        somduttar@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/7] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Message-ID: <Ytg3xjZ48w/3Hh6n@google.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
 <20220615011622.136646-4-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615011622.136646-4-kechenl@nvidia.com>
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

On Tue, Jun 14, 2022, Kechen Lu wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable MWAIT
> exits and KVM previously reported (via KVM_CHECK_EXTENSION) that MWAIT is
> not allowed in guest, e.g. because it's not supported or the CPU doesn't
> have an aways-running APIC timer.
> 
> Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT intercepts")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b419b258ed90..f31ebbb1b94f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4199,6 +4199,17 @@ static inline bool kvm_can_mwait_in_guest(void)
>  		boot_cpu_has(X86_FEATURE_ARAT);
>  }
>  
> +static u64 kvm_get_allowed_disable_exits(void)
> +{
> +	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
> +		KVM_X86_DISABLE_EXITS_CSTATE;
> +
> +	if(kvm_can_mwait_in_guest())

Probably my fault for not fixing this during copy+paste, but add a space after the if, i.e.

	if (kvm_can_mwait_in_guest())

> +		r |= KVM_X86_DISABLE_EXITS_MWAIT;
> +
> +	return r;
> +}
