Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EA22182A3
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgGHIi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 04:38:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgGHIi1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 04:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594197506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69BhJ5TklPv9IEA6MOVSk3TCKrQG02Q0fSUC+Usvs9U=;
        b=euHwKtExHaIvocoPsx3+a4N2nBj8UuRMLDdbPh28kRoOrokiUtg9Rt5W7AcVEgQ2bMXnUw
        WS1dUJcK4d/V1OyhaITpruTOyMu9nyxmYhMscDgzdFvk4PQKzAYehexbBFDHzaL5jAt001
        FOQ4iYPIGGjc23TszNwl69spoUzh5XU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-kfT6D776MoSwsSLjT4abPQ-1; Wed, 08 Jul 2020 04:38:24 -0400
X-MC-Unique: kfT6D776MoSwsSLjT4abPQ-1
Received: by mail-wm1-f70.google.com with SMTP id 65so2190955wmd.8
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 01:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69BhJ5TklPv9IEA6MOVSk3TCKrQG02Q0fSUC+Usvs9U=;
        b=ERc7Yzg1Wn0GHZpPijjBmQhmmzOoWMnRlExgy+PP9RU18hjQa2fmMqINpNi4l0p3Dk
         vkzJ1EsBFXI6Zl14mu+Df1J0FaoYd0FRz79nD4so17nGEl0lybgMWT/+VSjG1RatJSl0
         bCSvWj6VLb/NruqUn7JtCE4BvFPL2YoiFf1zYh/UPYaaHG9AcgQifL26cjc9yhk0MIIE
         8qHIu4a1w8EA4eB5LR4hMzPtaUv914eHwjOn73PqNftfpFjJWyPirQuIYHIPNzPO23r4
         G69/TEVT63Kfgj49qbBmD9u47H2ditszuA5dlr/QPQ5FvjcxQDPGWDBA9eTQ+VfKkQoq
         OgRQ==
X-Gm-Message-State: AOAM533epL8sOgGK0nsBxvwz+CyIJJLmqoF9RVTfPFj2tlqDheZHt8hi
        fPr/Z9sE2A8yl4RfA+jubFsFc+OFIv8J2uM7VtvhwN65FSmrKPDVOgB1Xaxfu1NJONr0vNwvGjr
        TEdqtDeZ+Iz0e
X-Received: by 2002:a5d:6990:: with SMTP id g16mr48536911wru.131.1594197502900;
        Wed, 08 Jul 2020 01:38:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWePtjMU0TTtx2MY8HJ/yPg1WFUm+oDrlqf02p0ziiwedP9bBIT4OxuzK5wxCbzQvL73uVpw==
X-Received: by 2002:a5d:6990:: with SMTP id g16mr48536890wru.131.1594197502645;
        Wed, 08 Jul 2020 01:38:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id v12sm4815462wrt.31.2020.07.08.01.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 01:38:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <20200417163843.71624-1-pbonzini@redhat.com>
 <20200417163843.71624-2-pbonzini@redhat.com>
 <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57a405b3-6836-83f0-ed97-79f637f7b456@redhat.com>
Date:   Wed, 8 Jul 2020 10:38:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 10:17, Wanpeng Li wrote:
> On Sat, 18 Apr 2020 at 00:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> When a nested page fault is taken from an address that does not have
>> a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
>> (via mmu_set_spte) and kvm_mmu_page_fault then invokes svm_need_emulation_on_page_fault.
>>
>> The default answer there is to return false, but in this case this just
>> causes the page fault to be retried ad libitum.  Since this is not a
>> fast path, and the only other case where it is taken is an erratum,
>> just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
>> common case where the erratum is not happening.
>>
>> This fixes an infinite loop in the new set_memory_region_test.
>>
>> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 7 +++++++
>>  virt/kvm/kvm_main.c    | 1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index a91e397d6750..c86f7278509b 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>>         bool smap = cr4 & X86_CR4_SMAP;
>>         bool is_user = svm_get_cpl(vcpu) == 3;
>>
>> +       /*
>> +        * If RIP is invalid, go ahead with emulation which will cause an
>> +        * internal error exit.
>> +        */
>> +       if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
>> +               return true;
>> +
>>         /*
>>          * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>>          *
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index e2f60e313c87..e7436d054305 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1602,6 +1602,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>>  {
>>         return __gfn_to_memslot(kvm_vcpu_memslots(vcpu), gfn);
>>  }
>> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
> 
> This commit incurs the linux guest fails to boot once add --overcommit
> cpu-pm=on or not intercept hlt instruction, any thoughts?

Can you write a selftest?

Paolo

