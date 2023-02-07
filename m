Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB3368D3BC
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjBGKKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjBGKKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:10:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C042237F29
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675764549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZR0ulCP18stSdAGdIDCbqMw0+hgLOSFlaljh5KnkP+U=;
        b=CeGDtGYdAT+1n6jjkbN4pFodykZUVl9o3QmS6ol9ID9DaGdXhmzfboJikqoBNs78JWUOFr
        RX11t7CIFrxi8c4fiXcj7sqScTBCxq9/+dqcvjedJ48mhbrRvlqUk3fjM91bfO93AxnT+R
        KnWSBuZx3lM0Tmjrxrr8MZZlpjRDHmk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-m8AB8_FrOw65l2iFk4Wh3g-1; Tue, 07 Feb 2023 05:09:06 -0500
X-MC-Unique: m8AB8_FrOw65l2iFk4Wh3g-1
Received: by mail-qk1-f197.google.com with SMTP id op32-20020a05620a536000b0072e2c4dea65so7659033qkn.12
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:09:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR0ulCP18stSdAGdIDCbqMw0+hgLOSFlaljh5KnkP+U=;
        b=IwcGsn+jpPc+T0lTB9oAqOJm7TBvEXhP4L5WD0R00Lixh857Y0XWXj+rx9WjQfqGcb
         X3efQjqLO+kljyLOl270IvnfdvcNV29rUqIl23FMnCc9OrwmMsTpkZoPwN9+MI/FQvs5
         G30NZqNXn26M8V9D1h9SEIVMMDJTs11oP8kFbgsxa1Aei7HIQGTSWJXTFyUi0z0JPhHm
         HsopewFcJ9BuZw6jIESIuNYCNFYx5IReNz1sWkeqlIT/LsLbOrDEQf1XQHO27wusq0Fg
         /oNI16jd0O6xGjcyM/3LDF3vUCVnA0tgw7g+XYR/cK3e+MbRybTMNhtiWVvGXS4FkaNZ
         +fUw==
X-Gm-Message-State: AO0yUKW/DUzguZ9ui2wdRODJ2hI/6eLN2x3+KG+KGM/ImJqwh9ehdCpk
        TXoBFzoW4XpgXENvpM814aAuoLLGhyb/dq03tSYX26H3R1tNsb2YIHIIKyI7J00DyhljW8F2NYm
        sD6WaAhNLqkcP
X-Received: by 2002:a05:622a:1106:b0:3b6:3a12:2bf9 with SMTP id e6-20020a05622a110600b003b63a122bf9mr4752907qty.2.1675764545702;
        Tue, 07 Feb 2023 02:09:05 -0800 (PST)
X-Google-Smtp-Source: AK7set+kMUgLmXDnmLUe9OBwQo0pZwTWJP+zfBA/Ea2dEBA2nMdufvraXZdginHor8Q4n1IhuHpRow==
X-Received: by 2002:a05:622a:1106:b0:3b6:3a12:2bf9 with SMTP id e6-20020a05622a110600b003b63a122bf9mr4752889qty.2.1675764545475;
        Tue, 07 Feb 2023 02:09:05 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-120.web.vodafone.de. [109.43.176.120])
        by smtp.gmail.com with ESMTPSA id p13-20020a05620a056d00b007208dd55183sm9072533qkp.40.2023.02.07.02.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 02:09:04 -0800 (PST)
Message-ID: <7b32d58b-846f-b8d7-165b-9f505e5f00f0@redhat.com>
Date:   Tue, 7 Feb 2023 11:09:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, Eric Auger <eric.auger@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-7-thuth@redhat.com>
 <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Change return type of
 kvm_vm_ioctl_mte_copy_tags() to "int"
In-Reply-To: <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2023 01.09, Gavin Shan wrote:
> Hi Thomas,
> 
> On 2/3/23 8:42 PM, Thomas Huth wrote:
>> This function only returns normal integer values, so there is
>> no need to declare its return value as "long".
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 4 ++--
>>   arch/arm64/kvm/guest.c            | 4 ++--
>>   2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h 
>> b/arch/arm64/include/asm/kvm_host.h
>> index 35a159d131b5..b1a16343767f 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -963,8 +963,8 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>>   int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>                      struct kvm_device_attr *attr);
>> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> -                struct kvm_arm_copy_mte_tags *copy_tags);
>> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> +                   struct kvm_arm_copy_mte_tags *copy_tags);
>>   /* Guest/host FPSIMD coordination helpers */
>>   int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index cf4c495a4321..80e530549c34 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -1013,8 +1013,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>       return ret;
>>   }
>> -long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> -                struct kvm_arm_copy_mte_tags *copy_tags)
>> +int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> +                   struct kvm_arm_copy_mte_tags *copy_tags)
>>   {
>>       gpa_t guest_ipa = copy_tags->guest_ipa;
>>       size_t length = copy_tags->length;
>>
> 
> It's possible for the function to return number of bytes have been copied.
> Its type is 'size_t', same to 'unsigned long'. So 'int' doesn't have sufficient
> space for it if I'm correct.
> 
> long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>                                  struct kvm_arm_copy_mte_tags *copy_tags)
> {
>          gpa_t guest_ipa = copy_tags->guest_ipa;
>          size_t length = copy_tags->length;
>          :
>          :
> out:
>          mutex_unlock(&kvm->slots_lock);
>          /* If some data has been copied report the number of bytes copied */
>          if (length != copy_tags->length)
>                  return copy_tags->length - length;
>          return ret;
> }

Oh, drat, I thought I had checked all return statements ... this must have 
fallen through the cracks, sorry!

Anyway, this is already a problem now: The function is called from 
kvm_arch_vm_ioctl() (which still returns a long), which in turn is called 
from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that functions stores the 
return value in an "int r" variable. So the upper bits are already lost there.

Also, how is this supposed to work from user space? The normal "ioctl()" 
libc function just returns an "int" ? Is this ioctl already used in a 
userspace application somewhere? ... at least in QEMU, I didn't spot it yet...

  Thomas

