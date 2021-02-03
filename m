Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B065030DD23
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhBCOo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:44:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232417AbhBCOoz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 09:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612363409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FnKWIbAvlReT+a8OV1eghAeUCiuhQjhUDbs/VIFt6oA=;
        b=f4TiYHlt5CDkR4Sq9OMCIc0bxugE2hYixv0k/Gxq4N2fzigut7xrqSChyoLDvBjOGiTZ/a
        bu9QESL904KGPCuBu4uBLRWFdtMg2kFknchNTVq7x16ytJw21nKRmiqhpCAVOuTzjyJLJp
        MeBkVa/sVmcLyuMNEjIepulwVNY706E=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-0xXhdARaNuKje0CcALrPbg-1; Wed, 03 Feb 2021 09:43:27 -0500
X-MC-Unique: 0xXhdARaNuKje0CcALrPbg-1
Received: by mail-ed1-f71.google.com with SMTP id g2so586620edq.14
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 06:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FnKWIbAvlReT+a8OV1eghAeUCiuhQjhUDbs/VIFt6oA=;
        b=NdiSwvRCXCtkXC57nlUEtjR1UrAgdTBraFYHYaVeE1DQ3fCjw31H8NO9DdOxxvtey0
         CFxzxjJN5INIIT2OvSQp8G5PvKkcUpRXrK41HRW1itK7m7sCrAGc5XfAfpltka+jCFSt
         w3w9Jbd6kCcyoxTnS6xCkpaDhcYGNMX5KV6oe/jXkVIdfruo80tBZmtfbljLr5qmYCET
         VN/3BVME5kGVaekqpC5qsjL79M5mM2uA4QlRdDT1d9duE9CbYUwGMAfzx/rrgHap3KWO
         kO6usp29e27leDa2c4dIzUq96iXkausoBGvA4QOPF/kpxOA4JCeKIHsnicY0q/5qzKxg
         u+2g==
X-Gm-Message-State: AOAM530ENvaXD3Xznj9MCGzvr93Xf5Ei4j0ibh5kGVqs3P7XSivSZNuM
        P6kSJQmWbCbvd0PkUzYfgeNbreNmUH0nJ2zE9ybMQd2VAi9NZtNBT0m1lfalypHfNzyhr0EBE1J
        7Ak+7UH34EpnP
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr3437041ejd.215.1612363406348;
        Wed, 03 Feb 2021 06:43:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjSatodhbf1eKBAM0/fZuokcjFJSmbxbPgnrq5jXK5sygUQkllM/cjNhFTky/9dYepGP8yCw==
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr3437016ejd.215.1612363406155;
        Wed, 03 Feb 2021 06:43:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x17sm957498edd.76.2021.02.03.06.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 06:43:24 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Make HVA handler retpoline-friendly
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <c3f775de-9cb5-5f30-3fbc-a5e80c1654de@redhat.com>
 <771da54d-0601-ccd2-8edf-814086739e53@maciej.szmigiero.name>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b15ae06-4b56-0259-6950-6781622020ab@redhat.com>
Date:   Wed, 3 Feb 2021 15:43:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <771da54d-0601-ccd2-8edf-814086739e53@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 16:19, Maciej S. Szmigiero wrote:
> On 01.02.2021 09:21, Paolo Bonzini wrote:
>> On 01/02/21 09:13, Maciej S. Szmigiero wrote:
>>>   static int kvm_handle_hva_range(struct kvm *kvm,
>>>                   unsigned long start,
>>>                   unsigned long end,
>>> @@ -1495,8 +1534,9 @@ static int kvm_handle_hva_range(struct kvm *kvm,
>>
>>
>>> -static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned 
>>> long start,
>>> -        unsigned long end, unsigned long data,
>>> -        int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
>>> -                   struct kvm_mmu_page *root, gfn_t start,
>>> -                   gfn_t end, unsigned long data))
>>> -{
>>
>> Can you look into just marking these functions __always_inline?  This 
>> should help the compiler change (*handler)(...) into a regular 
>> function call.
> 
> That looks even better - I see the compiler then turns the indirect call
> into a direct one.
> 
> Will change to __always_inline instead of static dispatch in the next
> version.
> Thanks for the pointer.

Feel free to send this separately as it's a self-contained change.

Thanks,

Paolo

