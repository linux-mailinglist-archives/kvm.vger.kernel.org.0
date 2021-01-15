Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F203A2F7D6C
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732672AbhAON6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:58:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732082AbhAON6N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610719006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVQxHC5aDenqNcWvmG07Bn72UrucFZIJp0uxXWZdvVg=;
        b=STFeHCjsTgXB5dWXiPqoIE2T5WzlXgmA7EStt6v8tXTdVB5vNIiKEWG6ps+p6QrVSuhmCf
        +pb8fMfv89Z5yNAJrOgsryqzLtFJaSDsVo0kZ8U5UgfaykaJmnp2qMD2AloGoSPIJrQpDs
        FxI2b6m9CnPfrGxREA83N85AHG4PCrs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-U1lFFAw5Ofm5TwBtwfXFbg-1; Fri, 15 Jan 2021 08:56:45 -0500
X-MC-Unique: U1lFFAw5Ofm5TwBtwfXFbg-1
Received: by mail-ej1-f71.google.com with SMTP id jg11so2977650ejc.23
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 05:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVQxHC5aDenqNcWvmG07Bn72UrucFZIJp0uxXWZdvVg=;
        b=gwo4q+WaQfE4W2A/OXNEiYimbXehJRzHqMc/8nPTLy/3jf0s/qlpH3dnyT4bbxhnB4
         ahFWErrHeK5fonQQKFDQYfpUiBO3FTmvLwxDXT59WeqgT60eNXDg2huLAHSMo9QREv1m
         /+Za4XGEpBH+S7RnbJBuuFKrFglxrNsJuOLSygtRbWsdkWJskKdba2AAJclLiibadhqB
         4Ey2193Gsd1CiyDUWXM60+45bWvjdNJe54N3Z0rewjp1EDb4cPNxJcfVRvW8aqYjsc6/
         CgOumMm/qENoHyiLHVRIKhMLzlm3iTN63lr6bm5o8zLzS/KMpXLfTrYjVl1Kvl2LJR50
         5r5w==
X-Gm-Message-State: AOAM530rmymlOxG+14RBsJWC/MhLUxeQ8u/6tzvhaix3GDIhhR3b3G6R
        TNR+3rJIh9SMsDi2o+57sF0PkquOCLAk0/KJasmpwhHvWcGTMleY9ByUA4q2mpH0wP/WYvU1kW9
        aNqIdMT1uijwX
X-Received: by 2002:a17:906:2648:: with SMTP id i8mr3523386ejc.262.1610719003675;
        Fri, 15 Jan 2021 05:56:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIIhl/T+nMWLDpTcbKOVPkHNGdwkNyQg86Kt82V1Ox5TAYsXX+C+MiQjW40aRyOm7KmSGPHA==
X-Received: by 2002:a17:906:2648:: with SMTP id i8mr3523373ejc.262.1610719003537;
        Fri, 15 Jan 2021 05:56:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm1459370ejj.43.2021.01.15.05.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 05:56:42 -0800 (PST)
Subject: Re: [PATCH v2 3/3] KVM: x86: use static calls to reduce kvm_x86_ops
 overhead
To:     Peter Zijlstra <peterz@infradead.org>,
        Jason Baron <jbaron@akamai.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1610680941.git.jbaron@akamai.com>
 <e057bf1b8a7ad15652df6eeba3f907ae758d3399.1610680941.git.jbaron@akamai.com>
 <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e13aa15-2f64-8e54-03b1-c4843af96bc1@redhat.com>
Date:   Fri, 15 Jan 2021 14:56:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <YAFkTSnSut1h/jWt@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 10:45, Peter Zijlstra wrote:
> On Thu, Jan 14, 2021 at 10:27:56PM -0500, Jason Baron wrote:
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 5060922..9d4492b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1350,7 +1350,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
>>   static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>>   {
>>   	if (kvm_x86_ops.tlb_remote_flush &&
>> -	    !kvm_x86_ops.tlb_remote_flush(kvm))
>> +	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
>>   		return 0;
>>   	else
>>   		return -ENOTSUPP;
> 
> Would you be able to use something like this?
> 
>    https://lkml.kernel.org/r/20201110101307.GO2651@hirez.programming.kicks-ass.net
> 
> we could also add __static_call_return1(), if that would help.
> 

I think I'd rather make the default callee return -ENOTSUPP directly and 
remove the "if" completely.  So __static_call_return1() is not 
particularly useful here.

Paolo

