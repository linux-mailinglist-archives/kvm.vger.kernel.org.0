Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF22777849
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbjHJM1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjHJM1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 08:27:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674DB2728
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 05:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691670379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnvMtwrO+HlpCnGD+Ie1TBrDV8keaKNA7WfaJ+XMfts=;
        b=PThITPCV91zKh135syv7wW8rJbf8dZOP8YA3duXGMz/cGQH8wLsvzIULnY53qbPxfYXAQ4
        VbCReSC32+VDIcQWUIeF+V0aIFbQriTeuTyVDPVt+ABPz+SA91wJ2dQRZahBwukOb1lYe5
        HdWHv+GMM4J9VHpzP/dIjUtP0t90SRU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-iCzWf0XnOZWS1qJkmAdCYg-1; Thu, 10 Aug 2023 08:26:18 -0400
X-MC-Unique: iCzWf0XnOZWS1qJkmAdCYg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-686f376f2b8so191935b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 05:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691670377; x=1692275177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnvMtwrO+HlpCnGD+Ie1TBrDV8keaKNA7WfaJ+XMfts=;
        b=LrPVfNFGOmz+bgxJcZPHTA+iZ9pCOFivpAR0pyt0p8CYzupBIQWCec85DagxXUOP7c
         BV4W9uarszunkIOZhDlPQQm6fazqsXb6Jd01ZrbnwTCc12A007Q9CXSDoVi7EnzZMg2z
         ybuCld9UGVPYOSxuXUz04coyVF6lNtl+pIrA6i/ipIheGFY8bzGh+A+wdaCeNbZRp6Hr
         E/Se9h3GmUUAhfaL3jfxcxEvBg4QK8Skc8NynJZwjINNlectUW0ES6ZycozWy3nKNf3Z
         KrIj4vCRNsTAI49u0yqpoKqo5ne45Zh+MprsmehB6DqOwyQt/WUlGS0P1dwbpGOqWIow
         OPpA==
X-Gm-Message-State: AOJu0Yw5SqwEmUwUHKv80dRjZ7pqPBz1SXCLcW9qq4RNaX4qai6hz3eR
        SXCo9XwcDIVIcIUOS5isqdgXiTy31qtQhXXLXGdXkATQUcTHylITT6mtmW7FhRgrgGHzels0JwS
        05Pjxhg5Xh046
X-Received: by 2002:a05:6a00:d96:b0:687:874c:7ce0 with SMTP id bf22-20020a056a000d9600b00687874c7ce0mr2463233pfb.1.1691670377121;
        Thu, 10 Aug 2023 05:26:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbuLOrMlEpRqBni5bZEXHe0+/YLy2srme8Tcb0EpGLk+ZLZKJl+h1qsrD5Yo9JHMcHNLUrCg==
X-Received: by 2002:a05:6a00:d96:b0:687:874c:7ce0 with SMTP id bf22-20020a056a000d9600b00687874c7ce0mr2463218pfb.1.1691670376757;
        Thu, 10 Aug 2023 05:26:16 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s11-20020aa78d4b000000b006878f50d071sm1393686pfe.203.2023.08.10.05.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 05:26:16 -0700 (PDT)
Message-ID: <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com>
Date:   Thu, 10 Aug 2023 20:26:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs()
 globally
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Gavin Shan <gshan@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
 <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> Hi Gavin,
> 
> On Tue, Aug 8, 2023 at 9:00 PM Gavin Shan <gshan@redhat.com> wrote:
>>
>>
>> On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
>>> There's no reason for the architectures to declare
>>> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
>>> avoid this duplication, make the declaration global, leaving
>>> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>>> as needed.
>>>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>    arch/mips/include/asm/kvm_host.h | 1 -
>>>    include/linux/kvm_host.h         | 2 ++
>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
>>> index 9b0ad8f3bf327..54a85f1d4f2c8 100644
>>> --- a/arch/mips/include/asm/kvm_host.h
>>> +++ b/arch/mips/include/asm/kvm_host.h
>>> @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>>>    static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>
>>>    #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>>> -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>>>
>>>    #endif /* __MIPS_KVM_HOST_H__ */
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index e3f968b38ae97..ade5d4500c2ce 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>>>    {
>>>        return -ENOTSUPP;
>>>    }
>>> +#else
>>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>>>    #endif
>>>
>>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
>>
>> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_host.h?
>> In order to keep them consistent, I guess we need move kvm_arch_flush_remote_tlbs()
>> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to be dropped.
>>
> Unsure of the original intentions, I didn't want to disturb any
> existing arrangements. If more people agree to this refactoring, I'm
> happy to move.

This is amazing to me. This change can be compiled without any error 
even if the declaration inconsistent between the kvm_host.h and x86's 
header file.

I'm curious which option make it possible?

Thanks,
Shaoqin

> 
> Thank you.
> Raghavendra
>> Thanks,
>> Gavin
>>
> 

-- 
Shaoqin

