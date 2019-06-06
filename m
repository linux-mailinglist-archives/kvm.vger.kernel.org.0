Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C295537389
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfFFLy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:54:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37616 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbfFFLy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 07:54:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so2118343wrr.4
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 04:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O9d8DyvhSQnR+00J9yqVmQ+mfLvj/3bQILzmW2iL+pM=;
        b=KqbiWQiC1mxdcLgk02TfFbJcs2L9BznGJ4RU1f+fRIg+EHQCaMbv27FoCd59/EROdj
         3ws7s2w1MM5hBAA4lmastxqdToO8wrTb5TwZ7D3iMTcJTiURWMJsT1JBDPMJl1CKZGiC
         DrVy5Lk24xH8VmVoe0zoPi9mUHddj2kQfJ4Wv9L0OtJZZIUTcoCJlRo5YoAbSngXiUFM
         0l1bVTcuGPP4xxSDDOZiH6FT8fzCexbaE+Cd2qJPhinZnml5g5Br6VzdJB0iQzzDP1LE
         ATRuYxlxUTOU+NkpnpZCs2N3dG32wyI49tiaetSCuTfuoAPyxiDjmSFtMwu9lR297+15
         yiYw==
X-Gm-Message-State: APjAAAWTy4LgSI1jlah50LHGjG4D0lLc1xFBJgUVZnFNM+eupXH/IHGO
        aOiFXYeJ3/qdNw1VIu5fwz/poQ==
X-Google-Smtp-Source: APXvYqx9TooafeA6Yp4IYC1HnDP0bVaKDbXN4TgHoj6jQR2XwUs3to8P2Vo8KYqZMXn9DxGcXqMm1g==
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr19988587wrq.251.1559822066368;
        Thu, 06 Jun 2019 04:54:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 95sm2039518wrk.70.2019.06.06.04.54.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 04:54:25 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: x86: Add Intel CPUID.1F cpuid emulation support
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        sean.j.christopherson@intel.com, xiaoyao.li@linux.intel.com,
        linux-kernel@vger.kernel.org, like.xu@intel.com
References: <20190606011845.40223-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0dd149a1-cc3b-0ac7-fe91-0a4dabd9c36e@redhat.com>
Date:   Thu, 6 Jun 2019 13:54:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606011845.40223-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 03:18, Like Xu wrote:
> Add support to expose Intel V2 Extended Topology Enumeration Leaf for
> some new systems with multiple software-visible die within each package.
> 
> Because unimplemented and unexposed leaves should be explicitly reported
> as zero, there is no need to limit cpuid.0.eax to the maximum value of
> feature configuration but limit it to the highest leaf implemented in
> the current code. A single clamping seems sufficient and cheaper.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> 
> ---
> 
> ==changelog==
> 
> v4:
> - Limited cpuid.0.eax to the highest leaf implemented in KVM
> 
> v3: https://lkml.org/lkml/2019/5/26/64
> - Refine commit message and comment
> 
> v2: https://lkml.org/lkml/2019/4/25/1246
> 
> - Apply cpuid.1f check rule on Intel SDM page 3-222 Vol.2A
> - Add comment to handle 0x1f anf 0xb in common code
> - Reduce check time in a descending-break style
> 
> v1: https://lkml.org/lkml/2019/4/22/28
> ---
>  arch/x86/kvm/cpuid.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e18a9f9f65b5..f819011e6a13 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -426,7 +426,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	switch (function) {
>  	case 0:
> -		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));
> +		/* Limited to the highest leaf implemented in KVM. */
> +		entry->eax = min(entry->eax, 0x1f);
>  		break;
>  	case 1:
>  		entry->edx &= kvm_cpuid_1_edx_x86_features;
> @@ -546,7 +547,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->edx = edx.full;
>  		break;
>  	}
> -	/* function 0xb has additional index. */
> +	/*
> +	 * Per Intel's SDM, the 0x1f is a superset of 0xb,
> +	 * thus they can be handled by common code.
> +	 */
> +	case 0x1f:
>  	case 0xb: {
>  		int i, level_type;
>  
> 

Queued, thanks.

Paolo
