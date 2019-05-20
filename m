Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5ED123B3B
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbfETOvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:51:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35740 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732283AbfETOvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:51:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id q15so13360717wmj.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVnNdGNMs8bTXbs9VrRakZb20feSs6msPHalAjE5cPg=;
        b=n7SRdUaPg0lu6m2jPco0zPCSYj3s/JibN2NJCYAjw8Kos/8hcVqtrQP4SjbhfVG+DH
         flILe3L50VqF4gLcnqBDGqkid7jVu6TpA8Vr+90r4HGOwMSmOxSSPhfH8iR48mrWUgJR
         Whm8skWflwrwTJoecWIxO8SGxDt4dvXUXt0LIMKAXV0/uGE+aHf8OR4xkeqGV7mRV2yF
         C1jjoBh62CIHtbhxu7d8nmQN7LQuLcY5jNAaNIySZDmxPODdAKFPpVaWWgrBCQkAjZvH
         5cJlPHjIeS1L/NPQSYpRrgs3+6f20hj//bLRqYD5aNQHM+RXMfKgUo+x5JN9rApfpk9T
         8r+g==
X-Gm-Message-State: APjAAAVAGXs31QQitQ8rulLGjo7aILoiOayr6bZc7qKiv9KgL6OnL20B
        yxW++T1saBV/cEbKiILLUNn1fA==
X-Google-Smtp-Source: APXvYqy5IrnbFK294qNTk0siRww4OSbJLe/xpQhNDgRgPdJn+ZO/FzlN2WH4xrXCxiNfCxh3xo0UFw==
X-Received: by 2002:a1c:c5cf:: with SMTP id v198mr12251187wmf.84.1558363875571;
        Mon, 20 May 2019 07:51:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id t19sm12385232wmi.42.2019.05.20.07.51.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:51:15 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index
 check
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190518163743.5396-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9fc48e70-0aa0-2a97-5a65-17e842efb08e@redhat.com>
Date:   Mon, 20 May 2019 16:51:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190518163743.5396-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/19 18:37, Nadav Amit wrote:
> The test that checks the maximum VMCS field encoding does not probe all
> possible VMCS fields. As a result it might fail since the actual
> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.
> 
> Change the test to check that the maximum of the supported probed
> VMCS fields is lower/equal than the actual reported
> IA32_VMX_VMCS_ENUM.MAX_INDEX.
> 
> This test might still fail on bare-metal due to errata (e.g., BDX30).
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 962ec0f..f540e15 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -361,8 +361,8 @@ static void test_vmwrite_vmread(void)
>  	report("VMWRITE/VMREAD", __check_all_vmcs_fields(0x42, &max_index));
>  
>  	vmcs_enum_max = rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK;
> -	report("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
> -		vmcs_enum_max == max_index, max_index, vmcs_enum_max);
> +	report("VMX_VMCS_ENUM.MAX_INDEX expected at least: %x, actual: %x",
> +		vmcs_enum_max >= max_index, max_index, vmcs_enum_max);
>  
>  	assert(!vmcs_clear(vmcs));
>  	free_page(vmcs);
> 

Queued, thanks.

Paolo
