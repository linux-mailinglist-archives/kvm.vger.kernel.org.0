Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ACB3F1E23
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhHSQkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:40:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234789AbhHSQjj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 12:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629391142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3p2/vtk0jECaEq9Opdy1U0ndXxwF4zZ0NkReVHjVbJo=;
        b=FXJMBj+foCCU1nZivMeHH8RmPNc+FjWQlgmdRiU5OFVPVAzAai9mwu4qy2BjvC1XtiHocA
        ULnTPuFc9p1mm1OJLuw7+zwKq5EnMZ666r1gxVL0/aUOswa/lwp2cMdRNzDqNLFYuqnKdB
        YCExbgX5P1PWX2zCh0ONxgUHIMyqxJQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-kF9uFPxXPsKsFizpNbctdA-1; Thu, 19 Aug 2021 12:39:01 -0400
X-MC-Unique: kF9uFPxXPsKsFizpNbctdA-1
Received: by mail-ej1-f69.google.com with SMTP id e1-20020a170906c001b02905b53c2f6542so2483727ejz.7
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:39:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3p2/vtk0jECaEq9Opdy1U0ndXxwF4zZ0NkReVHjVbJo=;
        b=BvA01XcNvopAU/j5aF898Wu6yhd51mZ3IFemVrKUmpADJtN0oOYu/R8ntErrN8Te5W
         j9PtdTCWzq6LucO6hKMkGx+PvgYHwg1YwCxrn0jH0ypGEUPag5OdagR88l1nt+LOFMLr
         xCmhYjIbEXuJbBlTkF+tZHCoDRRtRs+spLmia0iDa8aS0FoknY+WwB6JkYbvkEndnC++
         KPsqnCtRGnFjyLMhqSF9kfrFduF7LVinc8otcLxJpINI4Lm/XKMqg3bWgps2FED421UI
         SB0xjiWWD7bYcZ6CXOkog3scXIlx7d92qw7dhZnjhjfg3cRoEC9Z1/Ok0bLK55qZAgq2
         0t3Q==
X-Gm-Message-State: AOAM533gGjrQtmNPbHjt/JmK/mlz4aksRNW2SKz78v4dVNzxmm2n0HzU
        t2TRNmgvK6Pd9M5UI2IiFOdPSp2AeLZQ7tTBoDbX0kJV/LDSB+YQvWrLASMcqqBet6O1tzBB8qi
        raAhwgqc4Ewqv
X-Received: by 2002:a17:906:a18b:: with SMTP id s11mr17076315ejy.8.1629391139969;
        Thu, 19 Aug 2021 09:38:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOdH+eJ6Wno44KalFXnhRgah0GFAbuXK7572PyLLUjd5u6riwor5wGbINUfFiggJne5e+AnA==
X-Received: by 2002:a17:906:a18b:: with SMTP id s11mr17076280ejy.8.1629391139764;
        Thu, 19 Aug 2021 09:38:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id da1sm2054086edb.26.2021.08.19.09.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:38:59 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] KVM: SVM: Add 5-level page table support for SVM
To:     Sean Christopherson <seanjc@google.com>,
        Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com
References: <20210818165549.3771014-1-wei.huang2@amd.com>
 <20210818165549.3771014-4-wei.huang2@amd.com> <YR1EPNRNtIZZ7LXd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d5894435-c5e1-890d-880c-6b6390fe50d8@redhat.com>
Date:   Thu, 19 Aug 2021 18:38:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YR1EPNRNtIZZ7LXd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/21 19:32, Sean Christopherson wrote:
> On Wed, Aug 18, 2021, Wei Huang wrote:
>> When the 5-level page table is enabled on host OS, the nested page table
>> for guest VMs must use 5-level as well. Update get_npt_level() function
>> to reflect this requirement. In the meanwhile, remove the code that
>> prevents kvm-amd driver from being loaded when 5-level page table is
>> detected.
>>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> If this patch authored by Paolo, he needs to be attributed via From:.  If Paolo
> is a co-author, he needs a Co-developed-by:.  If either of those is true, your
> SOB needs to be last in the chain since you are the last handler of the patch.
> If neither is true, Paolo's SOB should be removed.

I didn't even remember writing this, but it's possible I pseudocoded in 
an email just like you did below.

>> -	return PT64_ROOT_4LEVEL;
>> +	bool la57 = (cr4_read_shadow() & X86_CR4_LA57) != 0;
>> +
>> +	return la57 ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
> 
> Why obfuscate this?  KVM is completely hosed if pgtable_l5_enabled() doesn't
> match host CR4.  E.g.
> 
> 	return pgtable_l5_enabled() ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;

That also suggests the above pseudocoding scenario, where I'd be too 
lazy to look up the correct spelling of pgtable_l5_enabled().

Paolo

>>   #else
>>   	return PT32E_ROOT_LEVEL;
>>   #endif
>> @@ -462,11 +464,6 @@ static int has_svm(void)
>>   		return 0;
>>   	}
>>   
>> -	if (pgtable_l5_enabled()) {
>> -		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
>> -		return 0;
>> -	}
>> -
>>   	return 1;
>>   }
>>   
>> -- 
>> 2.31.1
>>
> 

