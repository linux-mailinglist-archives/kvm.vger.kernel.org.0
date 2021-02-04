Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8248330FA18
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhBDRpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:45:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238569AbhBDRav (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFpHt7ahtiWyI8hSPQbU/qGuLyn4UFc9M7zanW3r47A=;
        b=U3ERHe76RucETXQzAIqDO0iroIefYh+apdH/Rq++rzvyV7ZLGNYGUI8RrShc83Uj/BUYUr
        kk9tcG7ZRkzhQeGwMER/tqWrYl/9I2xj9R/A2w4h08O/ibxSHpPh+AVSJfSQy30oF5SwzM
        9xqetVRT4z+onF+3lrzY8TX6O8YSKdk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-CIrNzj_0OZKgmClhlLImPg-1; Thu, 04 Feb 2021 12:29:22 -0500
X-MC-Unique: CIrNzj_0OZKgmClhlLImPg-1
Received: by mail-ej1-f69.google.com with SMTP id eb5so3134291ejc.6
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 09:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gFpHt7ahtiWyI8hSPQbU/qGuLyn4UFc9M7zanW3r47A=;
        b=PMi7fCzR5DBSA0AeSFmADhGTykH521VYfZrdJsrAUl1R727WHFtZ6ZVs4xnVASsrPF
         SFO67fzPNLZa25j/jISiVE1SVNNrjJiio/O9YZRMuM0yfnc1BQLc2xCwQb/nxmg3Mk8r
         hYXp5qTX+M8oAectj2OAzV3n8+4/qN1A939D+TiLOUDObhp4CoMAbSZ5dQQx4tyu5BwU
         ZrzucnqaK9q5nN9Blpy1cczuIiQLswWgVcSVj7QAOjnTOHJfYQl3nrVT0G/C4EkgpB3D
         c0zE0xMfY3WpKtiZzpS/xtuvddCCKf+HuQbAFPNjNjoqCOWZ4FG5YonzjCSd/7mmYzt2
         CftA==
X-Gm-Message-State: AOAM530fZMNZhjoe98osT9kdU/Dfoda10bJ9bkLlbr7zI4veFN7j5xYO
        I+4MVDHuet0Hk2mSbzmP4mnvrfc1bqHgmKvnuRrOIqnBfvPpl467/XsRQg6ktwUHKKwGeTXIDH8
        jCPjqlZQq6lcU
X-Received: by 2002:aa7:c9c9:: with SMTP id i9mr61168edt.160.1612459760707;
        Thu, 04 Feb 2021 09:29:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJztaTv2pVAyoYOPJ3kepgWu3iCSAzPutECTPP0Bi8bIM7i7j9sdJUrZNJqP2AyGVilMDYxYkw==
X-Received: by 2002:aa7:c9c9:: with SMTP id i9mr61158edt.160.1612459760554;
        Thu, 04 Feb 2021 09:29:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y8sm2728387eje.37.2021.02.04.09.29.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 09:29:19 -0800 (PST)
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yu.c.zhang@linux.intel.com
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com> <YBsZwvwhshw+s7yQ@google.com>
 <5b822165-9eff-bfa9-000f-ae51add59320@redhat.com>
 <YBwj78dE5iGZOLed@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aaf2c197-6122-3214-a0f1-d9a763c12439@redhat.com>
Date:   Thu, 4 Feb 2021 18:29:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBwj78dE5iGZOLed@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/21 17:42, Sean Christopherson wrote:
> On Thu, Feb 04, 2021, Paolo Bonzini wrote:
>> On 03/02/21 22:46, Sean Christopherson wrote:
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index dbca1687ae8e..0b6dab6915a3 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -2811,7 +2811,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>>>                  /* VM-entry interruption-info field: deliver error code */
>>>                  should_have_error_code =
>>>                          intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
>>> -                       x86_exception_has_error_code(vector);
>>> +                       x86_exception_has_error_code(vcpu, vector);
>>>                  if (CC(has_error_code != should_have_error_code))
>>>                          return -EINVAL;
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 28fea7ff7a86..0288d6a364bd 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -437,17 +437,20 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
>>>   #define EXCPT_CONTRIBUTORY     1
>>>   #define EXCPT_PF               2
>>>
>>> -static int exception_class(int vector)
>>> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>>>   {
>>>          switch (vector) {
>>>          case PF_VECTOR:
>>>                  return EXCPT_PF;
>>> +       case CP_VECTOR:
>>> +               if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
>>> +                       return EXCPT_BENIGN;
>>> +               return EXCPT_CONTRIBUTORY;
>>>          case DE_VECTOR:
>>>          case TS_VECTOR:
>>>          case NP_VECTOR:
>>>          case SS_VECTOR:
>>>          case GP_VECTOR:
>>> -       case CP_VECTOR:
> 
> This removal got lost when squasing.
> 
> arch/x86/kvm/x86.c: In function ‘exception_class’:
> arch/x86/kvm/x86.c:455:2: error: duplicate case value
>    455 |  case CP_VECTOR:
>        |  ^~~~
> arch/x86/kvm/x86.c:446:2: note: previously used here
>    446 |  case CP_VECTOR:
>        |  ^~~~

Well, it shows that I haven't even started including those 
unlikely-for-5.12 patches (CET and #DB bus lock) in my builds, since 
today I was focusing on getting a kvm/next push done.

I'll probably push all those to kvm/intel-queue and remove them from 
everyone's view, for now.

Paolo

