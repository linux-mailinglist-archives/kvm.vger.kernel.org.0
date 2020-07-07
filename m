Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A00E217516
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 19:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgGGR0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 13:26:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45579 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728182AbgGGR0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 13:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594142804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3LrO7VqgYVoFRtAEnJtwxKftEVr1AjGjug4X5J7y9k0=;
        b=F/uPo7luGfoPPqW3ZvwIvtlRDQuev8kovfOIROAiH4AwZLPlfUW5UgJFeAgVThTbygNWmW
        pCCw95rFDaaF9ZBmPScm6rd6jJqMQq10IYP65qztiCYGLWNDlGXi+btzKXxLcfVYb/cJ66
        UuMgLg0tthARZZ2zySmiD6tHJqZq3Ew=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-XKt6xsNNPK27gqdAtMTU8g-1; Tue, 07 Jul 2020 13:26:42 -0400
X-MC-Unique: XKt6xsNNPK27gqdAtMTU8g-1
Received: by mail-wr1-f72.google.com with SMTP id d11so31728216wrw.12
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 10:26:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3LrO7VqgYVoFRtAEnJtwxKftEVr1AjGjug4X5J7y9k0=;
        b=QgLe8UenNWHITfSNkVebHYAfks/zWaytvV2Bg67Lwv6wgJGDk6nNX+7KQbbtkh7LDo
         VRrwMH3zVH2FvEuzZbr1lLyRS2XlVZwbdAbf4rKtu53AZnYeCxZrcKpQrkt1tWWTaOE7
         THg7TggBTzg3dsYBj/NxYb5nXOGHR+nG37inzvkWLc192vYyj1CN1p+FPJbF0z6D408s
         sfqTGNXWpWOuFUpmaNVQrBp+n1w2SfA5nUykKcTDOqGhCNfecZNQf3Rt5EcjNK9qmwst
         qk/oNakwYKYqr5wuppDv8YvxLqrmA9GB4A7fAU59nR59YktjNF4iLTX0mM0cVv//xJwt
         50aQ==
X-Gm-Message-State: AOAM531O9BdUWP2XlrhahTvS2YY2d+MXnle4JwJfzB9iH8u16RLAwcqf
        7ykycUH5aclu4/uYlOEDUi465f51LM9vadhmuRlcMmKjWnbAK6tRAU8f6D/IrtYTxJ3V0ni9hOX
        mJ6UJnDT8V8uY
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr5663948wme.177.1594142801244;
        Tue, 07 Jul 2020 10:26:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNNrn3AIg1g3/5R2NVngn8kYJ+htIdF6x+ntfOrYeAJwFW3NKZhvcjYcIPkbdIJED+yPp84A==
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr5663931wme.177.1594142801054;
        Tue, 07 Jul 2020 10:26:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id a12sm1870753wrv.41.2020.07.07.10.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:26:40 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
 <a0ab28aa726df404962dbc1c6d1f833947cc149b.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e49c6f78-ac9a-b001-b3b6-7c7dcccc182c@redhat.com>
Date:   Tue, 7 Jul 2020 19:26:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a0ab28aa726df404962dbc1c6d1f833947cc149b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 13:30, Maxim Levitsky wrote:
>> Somehwat crazy idea inbound... rather than calculating the valid bits in
>> software, what if we throw the value at the CPU and see if it fails?  At
>> least that way the host and guest are subject to the same rules.  E.g.
>>
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2062,11 +2062,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>                     !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>>                         return 1;
>>
>> -               if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
>> -                       return 1;
>> -
>> +               ret = 0;
>>                 vmx->spec_ctrl = data;
>> -               if (!data)
>> +
>> +               local_irq_disable();
>> +               if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &data))
>> +                       ret = 1;
>> +               else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, vmx->spec_ctrl))
>> +                       ret = 1;
>> +               else
>> +                       wrmsrl(MSR_IA32_SPEC_CTRL, data))
>> +               local_irq_enable();
>> +
>> +               if (ret || !vmx->spec_ctrl)
>>                         break;
>>
>>                 /*
>>
> I don't mind this as well, knowing that this is done only one per VM run anyway.

Maxim, this is okay as well; can you send a patch for it?

Paolo

