Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3C8359ED4
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 14:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhDIMe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 08:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231756AbhDIMe4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 08:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617971681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrEm6vZHVri6hjV+VlEozAzJGJuNVgmg6MRBLGVidsk=;
        b=O3zTGjnJIVAR7QMEFSiU8/2Nhp2BeXtq+dPKSWmseCY42xccjRjOjbw3oN2/sTeJRCORnQ
        5QIWNFfn1UNiJWod5945YLFQAKO4W0Qpz2l85gwKCLSAVZZoHnl/DsvLiB4JCHEaxRfTIH
        p8cPPyMKYW/KmCBTbwoTxc9kQDLxKJ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-66koFG17NBG-VQNCIR8Qmg-1; Fri, 09 Apr 2021 08:34:39 -0400
X-MC-Unique: 66koFG17NBG-VQNCIR8Qmg-1
Received: by mail-wm1-f70.google.com with SMTP id p11-20020a05600c358bb029011630279b61so738609wmq.7
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 05:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WrEm6vZHVri6hjV+VlEozAzJGJuNVgmg6MRBLGVidsk=;
        b=eMHuaCatCUzNgAxYzaiD7ZhKoB4cS3MpxCq6jaRi8V/o5PzJMkgfphXUeVp8cD+7+Z
         52cqI0/7XhFF5sPap8wvcimlzTkPLqp/zHaEsLTQW5L7DVMlH0sGUfEQ4oZOMdyD2CTi
         UjtqeAyX4x+v4FmzD+nIxeAktuRd1pQ4gAwnmnWkKjtxuK4HTQBUNSoAv03WtH71z0Tp
         7Ki/d4FfsKeYhJWeNl0BzUG24c9slgO/n7s/jYAn0tBYJ2PV4tos/RAJ1ObOAC37r8Hy
         M2cCSutlCd0guiitDOXEqCCqzp2gMNxKczKh8ygILIMKCLv2IXvX8HAIae56jiTvIE3D
         ghlA==
X-Gm-Message-State: AOAM53328PODUgFI4jUCj5qDecuuiv0Bt+Ij8sz5rSvuyElTasa5xcHf
        SoendhTaCzfEP05a9/xViMJ5mrjMRnJ0WuwxfKVpSznAy5OEOmtQWW5tqGjZCX4pypWgVGgNBJ9
        Z9cYPeTYzV/AQ
X-Received: by 2002:a5d:644e:: with SMTP id d14mr17123598wrw.339.1617971678240;
        Fri, 09 Apr 2021 05:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxUGpD7HjO5daDt1oGsFMpgGK4lWP5dsiPMLmwvcZD85K+7Mp5kdBf3eYobr4sxrvRT5Q9mQ==
X-Received: by 2002:a5d:644e:: with SMTP id d14mr17123579wrw.339.1617971678102;
        Fri, 09 Apr 2021 05:34:38 -0700 (PDT)
Received: from localhost.localdomain ([194.230.155.173])
        by smtp.gmail.com with ESMTPSA id p17sm3774470wmg.5.2021.04.09.05.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 05:34:36 -0700 (PDT)
Subject: Re: [PATCH v4 1/4] KVM: x86: Fix a spurious -E2BIG in
 KVM_GET_EMULATED_CPUID
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210408114303.30310-1-eesposit@redhat.com>
 <20210408114303.30310-2-eesposit@redhat.com> <YG9nq6Y7GhFo9dUh@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <74b017e4-5a44-e20f-3435-ec48c4927ec4@redhat.com>
Date:   Fri, 9 Apr 2021 14:34:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YG9nq6Y7GhFo9dUh@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/04/2021 22:29, Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Emanuele Giuseppe Esposito wrote:
>> When retrieving emulated CPUID entries, check for an insufficient array
>> size if and only if KVM is actually inserting an entry.
>> If userspace has a priori knowledge of the exact array size,
>> KVM_GET_EMULATED_CPUID will incorrectly fail due to effectively requiring
>> an extra, unused entry.
>>
>> Fixes: 433f4ba19041 ("KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)")
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
>>   1 file changed, 16 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 6bd2f8b830e4..d30194081892 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -567,34 +567,33 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>>   
>>   static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>>   {
>> -	struct kvm_cpuid_entry2 *entry;
>> -
>> -	if (array->nent >= array->maxnent)
>> -		return -E2BIG;
>> +	struct kvm_cpuid_entry2 entry;
>>   
>> -	entry = &array->entries[array->nent];
>> -	entry->function = func;
>> -	entry->index = 0;
>> -	entry->flags = 0;
>> +	memset(&entry, 0, sizeof(entry));
>>   
>>   	switch (func) {
>>   	case 0:
>> -		entry->eax = 7;
>> -		++array->nent;
>> +		entry.eax = 7;
>>   		break;
>>   	case 1:
>> -		entry->ecx = F(MOVBE);
>> -		++array->nent;
>> +		entry.ecx = F(MOVBE);
>>   		break;
>>   	case 7:
>> -		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> -		entry->eax = 0;
>> -		entry->ecx = F(RDPID);
>> -		++array->nent;
>> -	default:
>> +		entry.flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> +		entry.ecx = F(RDPID);
>>   		break;
>> +	default:
>> +		goto out;
>>   	}
>>   
>> +	/* This check is performed only when func is valid */
> 
> Sorry to keep nitpicking and bikeshedding.  

No problem at all. Any comment is very welcome :)

Funcs aren't really "invalid", KVM
> just doesn't have any features it emulates in other leafs.  Maybe be more literal
> in describing what triggers the check?
> 
> 	/* Check the array capacity iff the entry is being copied over. */

What I mean here is that a func is "valid" if it matches one of the 
cases of the switch statement. If it is not valid, it ends up in the 
default case. But I agree, will change the comment your suggestion and 
resend.

Thank you,
Emanuele

> 
> Not a sticking point, so either way:
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>> +	if (array->nent >= array->maxnent)
>> +		return -E2BIG;
>> +
>> +	entry.function = func;
>> +	memcpy(&array->entries[array->nent++], &entry, sizeof(entry));
>> +
>> +out:
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.30.2
>>
> 

