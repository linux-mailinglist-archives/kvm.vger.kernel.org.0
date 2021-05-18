Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C63876FE
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 12:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348685AbhERLBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 07:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243635AbhERLBK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 07:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621335592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hMetlmNBWaKkSQsHWQlPS1UZ381FEjltyXsY7/tZa1o=;
        b=UuEAQokTZai6HOtbJhBpS0tZUPe6C2AQ6HVIg9YqPQlEqnkqP44LwfA85texkfJTC2M8M/
        pCKc7Tarv2bb6vEGbE7AipcCuBKfRnaKyCRV1KmKjR5VP0UQvBhoa4rbD4wczhxLZo+t+Q
        BaEfFVVL2zoaVvJG05s08y8yrYwrbZM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-Gs0cPdfNPDmaxdAy1aVbqg-1; Tue, 18 May 2021 06:59:49 -0400
X-MC-Unique: Gs0cPdfNPDmaxdAy1aVbqg-1
Received: by mail-wr1-f72.google.com with SMTP id p11-20020adfc38b0000b0290111f48b8adfso1938508wrf.7
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 03:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hMetlmNBWaKkSQsHWQlPS1UZ381FEjltyXsY7/tZa1o=;
        b=d4BnC/A8d9zTI8RQ/lDM8P+4yiHXifHxmVdeHf9FLu/x6V2nISPRaJD3v3yZZA+EQk
         gHlY7aOjm+PM/ftaUEFuOZVi3KZCa/0r235Z4wum8FUIT9/Fg51sZ41uTioel+dryoJ4
         YoSqXvoSKmbPhSVUulL2v5Ahk2ch4RSsTf7EtUMktJPPWK/0P2fcFAG0Iep6GZkX2Ul7
         4jDf66BfHc8/Ls1TWj6Ox3wj/ZPerIOqDgoKINxJH0gGdmZbXfr3zu7M3JY49fgmDT98
         C+t5/jKbx291joLjgR3FKZab06r52dsE2w/t9aSQK73MQJciBKjBJgJKgEloQbb5JAPl
         0GyA==
X-Gm-Message-State: AOAM530PT7EFR0sZ6NYbBwnMIoEeI+d/04CfzPbnZWBjNOXuGxn8ZfCd
        aY6cuflNqGfyY5QTs5rFU5vPwlPPiXVR+kKv87rdY6IKGaKUwbq+XExdOq0fDcFy6TfLICC6JiD
        yFBYF2VzFyuuI
X-Received: by 2002:a1c:a7c2:: with SMTP id q185mr4773576wme.112.1621335588449;
        Tue, 18 May 2021 03:59:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxllCecXZGTpo+tx3njY/mjs6yhhjT7+AqQP3UBaqDnyvze9lTSIc9uLbe6ZeMkLFhxkbOrw==
X-Received: by 2002:a1c:a7c2:: with SMTP id q185mr4773567wme.112.1621335588276;
        Tue, 18 May 2021 03:59:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p14sm21023492wrm.70.2021.05.18.03.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 03:59:47 -0700 (PDT)
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
 <YJHCadSIQ/cK/RAw@google.com>
 <1b50b090-2d6d-e13d-9532-e7195ebffe14@redhat.com>
 <CALMp9eSSiPVWDf43Zed3+ukUc+NwMP8z7feoxX0eMmimvrznzA@mail.gmail.com>
 <4a4b9fea4937da7b0b42e6f3179566d73bf022e2.camel@redhat.com>
 <YJlluzMze2IfUM6S@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1245ad2f-78b2-a334-e36a-524579274183@redhat.com>
Date:   Tue, 18 May 2021 12:59:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJlluzMze2IfUM6S@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/05/21 18:56, Sean Christopherson wrote:
> On Mon, May 10, 2021, Maxim Levitsky wrote:
>> On Tue, 2021-05-04 at 14:58 -0700, Jim Mattson wrote:
>>> On Tue, May 4, 2021 at 2:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>> On 04/05/21 23:53, Sean Christopherson wrote:
>>>>>> Does the right thing happen here if the vCPU is in guest mode when
>>>>>> userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
>>>>>> off?
>>>>> I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
>>>>> you specifically mean running in L2?
>>>>>
>>>>
>>>> Guest mode should mean L2.
>>>>
>>>> (I wonder if we should have a capability that says "KVM_SET_CPUID2 can
>>>> only be called prior to KVM_RUN").
>>>
>>> It would certainly make it easier to reason about potential security issues.
>>>
>> I vote too for this.
> 
> Alternatively, what about adding KVM_VCPU_RESET to let userspace explicitly
> pull RESET#, and defining that ioctl() to freeze the vCPU model?  I.e. after
> userspace resets the vCPU, KVM_SET_CPUID (and any other relevant ioctls() is
> disallowed.
> 
> Lack of proper RESET emulation is annoying, e.g. userspace has to manually stuff
> EDX after vCPU creation to get the right value at RESET.  A dedicated ioctl()
> would kill two birds with one stone, without having to add yet another "2"
> ioctl().

That has a disadvantage of opting into the more secure behavior, but we 
can do both (forbidding KVM_SET_CPUID2 after both KVM_RUN and KVM_RESET).

Paolo

