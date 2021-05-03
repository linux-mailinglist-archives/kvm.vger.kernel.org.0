Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785D3371727
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhECOz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 10:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229903AbhECOzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 10:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620053671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3b540+x5tTROkhNIivHz2jfrf6p5DdmXEjkUmZeSpJM=;
        b=A5Ptyk7vR/V2/ULPbO2gsdYtkQR9m7/9bs84JP3eCO6aB8enjn0FusPEUskvJzg9X7cQWa
        XXbenGT2rs9cG15GFO5RKqB2hdOyodpilfitwuLAawtLaih4gp/n2x/e7YjdQ2MzyYfnJY
        2dduNU8ihCEs7hXf1K/034g71hRTxiU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-zTE4NdSPMYm13HNmpQJmSQ-1; Mon, 03 May 2021 10:54:30 -0400
X-MC-Unique: zTE4NdSPMYm13HNmpQJmSQ-1
Received: by mail-ed1-f72.google.com with SMTP id f8-20020a0564020688b029038840895df2so4683065edy.17
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 07:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3b540+x5tTROkhNIivHz2jfrf6p5DdmXEjkUmZeSpJM=;
        b=tPcH6BzIakevfhxfKealMQK9ngCwprtoBgnydLz0/G6YTcO9XlREagVQ0Ifw9JMcQa
         nIbsnXyAfGrElL1vMJMEUmJk+7JUMgih2ATThESBh9Dp5ANpwQvzmYqXQesIq5cbvP5Z
         BLkAdtoW5xVsGnjHkiEN/PfCaq1tTxz4g8vDKgd6Mbwgoa53SxybcEVdXxkF2uBECJw7
         zxq+7/Y+hTWZ5/fciTUsRJ0MUdjhyxCuku3rBzKZnXZUQPwiL+lYSeVKklQBWenoUC8o
         PJDvdMkbI3F4M8Zd32yJy+Tqleqpfq9nFcA+8suA/EAENFWG57BOsnYltPv+Ix1RI0Db
         fSBA==
X-Gm-Message-State: AOAM5317x751zZb93dq9CJF/wXFxCW8m58+Pn8XeRLq3qB4hurMnXQhn
        y2ew6fRvKPU0EY7JVzqsoRzHZ3AXy9AN0mv/+7yaSwWEcJMojCXlJhwFyPxqwZ8nYg9KpgtCwmq
        9qv6vuD8N4NFn
X-Received: by 2002:a17:906:3884:: with SMTP id q4mr3800244ejd.492.1620053669155;
        Mon, 03 May 2021 07:54:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoR23CFOSjH9ccO37wfLz2PUmLdvsRxh6LTPVmadaUWrtpbDf7jx//gWJ/S64YXlz2inuaaw==
X-Received: by 2002:a17:906:3884:: with SMTP id q4mr3800225ejd.492.1620053668986;
        Mon, 03 May 2021 07:54:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id go38sm11070888ejc.40.2021.05.03.07.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 07:54:28 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
To:     Sean Christopherson <seanjc@google.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, Denis Lunev <den@openvz.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210428172729.3551-1-valeriy.vdovin@virtuozzo.com>
 <YIoFFl72VSeuhCRt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d68dbc3-8462-7763-fbad-f3b895fcf6e6@redhat.com>
Date:   Mon, 3 May 2021 16:54:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIoFFl72VSeuhCRt@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 03:00, Sean Christopherson wrote:
> On Wed, Apr 28, 2021, Valeriy Vdovin wrote:
>> It's very explicit by the code that it was designed to receive some
>> small number of entries to return E2BIG along with the corrected number.
> 
> LOL, saying KVM_GET_CPUID2 was "designed" is definitely giving the KVM
> forefathers the benefit of the doubt.

I was going to make a different joke, i.e. that KVM_GET_CPUID2 was 
indeed designed the way Valeriy described, but that design was forgotten 
soon after.

Really, this ioctl has been such a trainwreck that I think the only good 
solution here is to drop it.

Paolo

>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index efc7a82ab140..3f941b1f4e78 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4773,14 +4773,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>   		r = -EFAULT;
>>   		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>>   			goto out;
>> +
>>   		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
>>   					      cpuid_arg->entries);
>> -		if (r)
>> +
>> +		if (r && r != -E2BIG)
>>   			goto out;
>> -		r = -EFAULT;
>> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
>> +
>> +		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid))) {
>> +			r = -EFAULT;
>>   			goto out;
> 
> As I pointed out[*], copying the number of entries but not the entries themselves
> is wrong.  All of my feedback on v1 still stands.
> 
> [*] https://lkml.kernel.org/r/YIl4M/GgaYvwNuXv@google.com
> 
>> -		r = 0;
>> +		}
>>   		break;
>>   	}
>>   	case KVM_GET_MSRS: {
> 

