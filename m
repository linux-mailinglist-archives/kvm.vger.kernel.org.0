Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A7758480D
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiG1WNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiG1WNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:13:34 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4197785B8
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:13:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x7so2960206pll.7
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=l+5rBl2AK20PKGSH65YU4OKpcYRMAbAXO924wPV6Eik=;
        b=G8r95Q5hVuJdINZ5QqtY3e6DleLLl6mJ8NIAFZtg9iYDfXUfTrEfqm91RDT9EPqoXH
         v/h2kLU9U4IM03G3Y3Syt3PeuvRfeMeHuytOAsJFNn4HkAS0CWdFNUNxpK9Xqm1z69Yz
         ofZSMnadJWIBesKXLIWCCNeW5w5zzy2Lgrph55zYPmUWos4Sx638KPd/A2K+CbOKnexw
         FJMZw6w3cOeJydQGZ89N8ZOyWsVESGDUsZSKlzzPSoRmAH3b5eDw0j/SASSXovoly4EG
         pgoJKE3WAWl6SLP4OioP1JsCteYpM+rVXi/iwQyxpJuYAWSRfKaqTbRU2udnrO2F6eKS
         42ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=l+5rBl2AK20PKGSH65YU4OKpcYRMAbAXO924wPV6Eik=;
        b=0Die/0qJyZi725EnOwfAjF5AWvn+GZYc9OyKk+RxB6eL2S9PkSDvtjNz/71+3PsSug
         XrCrugYQN6sd3BhKmx70vua56czhNwKztTS/p4vYiod4vP0PyEOJsfI2lZO6Boag4EKT
         rBrkp4j3lcf2oLBTCxlA8QF8OzM3nuYvxJvdcSNaY3dxCG/7PsoZgyxwMfzmFaKJ1rtS
         aAVwh3Inv3Yz6FXevsiiGm1Z6fSy/rLpKoOu4/Gng9e3TkVr0At5/JH6bwyYGLE8NeT2
         /PWAovjsrv/hcLzig+Q0hShbJ1/+XyyQ8Qxl7thuzFaZd08lOs3j/ohRi7/zBCvtPgJu
         ASxQ==
X-Gm-Message-State: ACgBeo3SWU6OdxlZcCo2JMOJk3/IgRCFy+zow1y18Xokp6s4iUKtphDa
        WoCEGJDCtE/r8H9dDmZVCSJhKw==
X-Google-Smtp-Source: AA6agR6+VxdW2AncFaQzR2JNzm9++SeJViANFTSi6sftkYixtXxow5mvN8+au9fN/WbG/faRu1Swfg==
X-Received: by 2002:a17:902:cf06:b0:16b:cc33:5bce with SMTP id i6-20020a170902cf0600b0016bcc335bcemr864483plg.152.1659046412192;
        Thu, 28 Jul 2022 15:13:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0016db7f49cc2sm1826843plg.115.2022.07.28.15.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:13:31 -0700 (PDT)
Date:   Thu, 28 Jul 2022 22:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <YuMKBzeB2cE/NZ2K@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-10-vkuznets@redhat.com>
 <YtnMIkFI469Ub9vB@google.com>
 <48de7ea7-fc1a-6a83-3d6f-e04d26ea2f05@redhat.com>
 <Yt7ehL0HfR3b97FQ@google.com>
 <870d507d-a516-5601-4d21-2bfd571cf008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <870d507d-a516-5601-4d21-2bfd571cf008@redhat.com>
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

On Thu, Jul 28, 2022, Paolo Bonzini wrote:
> On 7/25/22 20:18, Sean Christopherson wrote:
> > > I kind of like the idea of having a two-dimensional array based on the enums
> > > instead of switch statements, so for now I'll keep Vitaly's enums.
> > I don't have a strong opinion on using a 2d array, but unless I'm missing something,
> > that's nowhere to be found in this patch.  IMO, having the enums without them
> > providing any unique value is silly and obfuscates the code.
> 
> Yeah, like this:
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index d8da4026c93d..8055128d8638 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -342,9 +342,10 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
> -enum evmcs_v1_revision {
> +enum evmcs_revision {
>  	EVMCSv1_2016,
>  	EVMCSv1_2022,
> +	EVMCS_REVISION_MAX,
>  };
>  enum evmcs_unsupported_ctrl_type {
> @@ -353,13 +354,37 @@ enum evmcs_unsupported_ctrl_type {
>  	EVMCS_2NDEXEC,
>  	EVMCS_PINCTRL,
>  	EVMCS_VMFUNC,
> +	EVMCS_CTRL_MAX,
> +};
> +
> +static u32 evmcs_unsupported_ctls[EVMCS_CTRL_MAX][EVMCS_REVISION_MAX] = {

Can this be const?

> +	[EVMCS_EXIT_CTLS] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
> +	},
> +	[EVMCS_ENTRY_CTLS] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
> +		[EVMCSv1_2022] =  EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
> +	},
> +	[EVMCS_2NDEXEC] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_2NDEXEC,
> +	},
> +	[EVMCS_PINCTRL] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_PINCTRL,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_PINCTRL,
> +	},
> +	[EVMCS_VMFUNC] = {
> +		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMFUNC,
> +		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMFUNC,
> +	},
>  };

...

> +	return evmcs_unsupported_ctls[ctrl_type][evmcs_rev];
>  }

The only flaw in this is if KVM gets handed a CPUID model that enumerates support
for 2025 (or whenever the next update comes) but not 2022.  Hmm, though if Microsoft
defines each new "version" as a full superset, then even that theoretical bug goes
away.  I'm happy to be optimistic for once and give this a shot.  I definitely like
that it makes it easier to see the deltas between versions.
