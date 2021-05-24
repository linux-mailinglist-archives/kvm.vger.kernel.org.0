Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6574638F1EA
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhEXRDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232543AbhEXRDv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621875742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcEmMLIpMt542BRC/ArOGeP47HD5D7lnjpPaTzmc9ZE=;
        b=QlVKloIjU3AIAbw0y2qpja744EZQbV0ko1ORS26Dh5DWZfu5iha/vnFRgqVF1rHW4tYH1E
        ISbpTtgIt+q+H7EgcycmPaHiluVEHA1jY59pB3y8omy6SQ02A/c1v8l+L9CjP2k7diwWRF
        2sGyspnfkyUuTSjPuMWbw3TXeQvPnZo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-4rnwcmtTO527gYbUCpIMOQ-1; Mon, 24 May 2021 13:02:21 -0400
X-MC-Unique: 4rnwcmtTO527gYbUCpIMOQ-1
Received: by mail-ej1-f72.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso7851268ejc.7
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcEmMLIpMt542BRC/ArOGeP47HD5D7lnjpPaTzmc9ZE=;
        b=C7ZKJQkNkUxe3qhY9PpFz6gV7ZA47PbMeD1H3EZQ0dmuqpjsOLv6j7D031rfYkbBAv
         tojwz//SdzpH5iNwmqdykKUqdyEt5cQMOM/tSki+XnewyWzPJxoEmoFWEVBT89durAg3
         r8QkgpFwwo6X3awy/NOrYmA7Uah+0tBll/JMytujp5bW8YqetskatP20YtnJT1lgdEHM
         XYkJD2kM6NiWts/xCnxThZGr6LQutazUBLQQEyVjWTNIBXfnOGUm46SQAt7QhhK1tOGw
         fBDaamcAktU8INLnrX40xKyvXbwqyhBWx+VyuGArSpqzD5INzoPh+50tt7Jx8hoMqxeY
         r58w==
X-Gm-Message-State: AOAM533uso6fakQmla5Zv/l0Yn+GIYI2w7yH7viKwQaugHNj/657oTMj
        c4UplrR17HCBZzw0h74Gcf9DiajoG2NPtgxPAcvMk93Wc7ZoZVqL+wWW6HDOsoI6VZfIDZZfn82
        3cfPem1/5TRJI
X-Received: by 2002:a50:9346:: with SMTP id n6mr26905867eda.365.1621875740147;
        Mon, 24 May 2021 10:02:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXLp1wRWeU2aBKnMEdIF+0UPlJKMdflp6xiudWJxTSxzYSssv1QjXUKON/oNsCX11ZOGuiqw==
X-Received: by 2002:a50:9346:: with SMTP id n6mr26905848eda.365.1621875739988;
        Mon, 24 May 2021 10:02:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q16sm9562165edw.87.2021.05.24.10.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 10:02:19 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for
 both APICv and AVIC
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-4-vkuznets@redhat.com> <YKQmG3rMpwSI3WrV@google.com>
 <12eadbce-f688-77a1-27bf-c33fee2e7543@redhat.com>
 <YKvZ6vI2vFVmkCeb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa5ef24e-6235-ad25-2f01-580efd2f1bbb@redhat.com>
Date:   Mon, 24 May 2021 19:02:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKvZ6vI2vFVmkCeb@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 18:52, Sean Christopherson wrote:
> On Mon, May 24, 2021, Paolo Bonzini wrote:
>> On 18/05/21 22:39, Sean Christopherson wrote:
>>>> +/* enable / disable AVIC */
>>>> +static int avic;
>>>> +module_param(avic, int, 0444);
>>> We should opportunistically make avic a "bool".
>>>
>>
>> And also:
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 11714c22c9f1..48cb498ff070 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -185,9 +185,12 @@ module_param(vls, int, 0444);
>>   static int vgif = true;
>>   module_param(vgif, int, 0444);
>> -/* enable / disable AVIC */
>> -static int avic;
>> -module_param(avic, int, 0444);
>> +/*
>> + * enable / disable AVIC.  Because the defaults differ for APICv
>> + * support between VMX and SVM we cannot use module_param_named.
>> + */
>> +static bool avic;
>> +module_param(avic, bool, 0444);
>>   bool __read_mostly dump_invalid_vmcb;
>>   module_param(dump_invalid_vmcb, bool, 0644);
>> @@ -1013,11 +1016,7 @@ static __init int svm_hardware_setup(void)
>>   			nrips = false;
>>   	}
>> -	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
>> -		avic = false;
>> -
>> -	/* 'enable_apicv' is common between VMX/SVM but the defaults differ */
>> -	enable_apicv = avic;
>> +	enable_apicv = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
>>   	if (enable_apicv) {
>>   		pr_info("AVIC enabled\n");
>>
>> The "if" can come back when AVIC is enabled by default.
> 
> But "avic" is connected to the module param, even if it's off by default its
> effective value should be reflected in sysfs.  E.g. the user may incorrectly
> think AVIC is in use if they set avic=1 but the CPU doesn't support AVIC.
> Forcing the user to check /proc/cpuinfo or look for "AVIC enabled" in dmesg is
> kludgy at best.

Indeed -- I even tested the above, but only before realizing that 
module_param_named would change the default.  So for now this needs to
be "enable_apicv = avic = ...", and later it can become just

	enable_apicv &= npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);

Paolo


