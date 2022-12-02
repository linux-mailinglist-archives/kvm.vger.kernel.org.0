Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A598640CDA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiLBSMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiLBSMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:12:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22E1ECE76
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670004666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XeeaXrmiSXAz7yiwwsn7OAqyBFbYdfVCZ2HcYBmojMY=;
        b=N71wNqaqhzVQFV4Jql99CBlCmlOsRRVISAoq/bh5qsceSBuRvWdRJE8Ek8owW4LrtQvpDm
        OnLKpHkRev81/d/Mq3VlE/fqE7i8SDhX9J2LBoWU8Zo7ZruNd7MkMgh15cahld9CJ6PLnp
        keQkJNXvLvs/lhdyC+fTiYUvre9JFA8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-MbnpdZ7XMs-5wldeI_52Rw-1; Fri, 02 Dec 2022 13:11:03 -0500
X-MC-Unique: MbnpdZ7XMs-5wldeI_52Rw-1
Received: by mail-wm1-f70.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so2218697wmb.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:11:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XeeaXrmiSXAz7yiwwsn7OAqyBFbYdfVCZ2HcYBmojMY=;
        b=uEb+yB78D2fhxaSapDSVZcYwAeOELlY/L5odxENT3BD85Lmdb4jSBqDkFpvUmFwsmY
         nYOACZVIIYTFlC98nxXmvhiEQbnK5ftK8Z3KMc9KSH0gDlIMxVLGBV38zhwoOYPY41ny
         eClbQLKznnp4CLSAFF2bxdpqO67CrDJN/aBjRnqH5F7zLg7bq+0HRiOSKH0NA3JEKCg9
         gQqgA41804kUMvM1SoB6kU6kaOi/eFWSUm+DJ65i48TqjbAhFK+yLlmDLh9IPRjPMeU2
         ormobv0YT+OCBuyAOajv4ntCOypWJCtfsvqiPpmYKZ3IBXAN7ZA1lJ/+1WIG+yJ5Ecyk
         bWTA==
X-Gm-Message-State: ANoB5pmmGUlB27nf9kBtryqvJvprsQ9ryk2RrhAfSl2E4DY7x2ItXL7o
        Gt5sF1mZG/Obd1vghFH+1jPgBOV9gU9Zp8vuDG6LmgK8EP4zbtpHmOqozM5VmOFQeHBPxYJOgdu
        xmOD0li1DVc5c
X-Received: by 2002:adf:fc48:0:b0:236:e0d:9ad with SMTP id e8-20020adffc48000000b002360e0d09admr34642318wrs.692.1670004662298;
        Fri, 02 Dec 2022 10:11:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4xWcTwPRLiOiZsUXz8fZzsv2cqll2GO9uYls5i+J9Nl6ucOPyDDmBw9oVRGcoRF6b305NMrw==
X-Received: by 2002:adf:fc48:0:b0:236:e0d:9ad with SMTP id e8-20020adffc48000000b002360e0d09admr34642303wrs.692.1670004662050;
        Fri, 02 Dec 2022 10:11:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w12-20020a05600c474c00b003b435c41103sm16843406wmo.0.2022.12.02.10.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:11:00 -0800 (PST)
Message-ID: <fe8c3a38-5d91-aed3-1e7d-6923aa157e79@redhat.com>
Date:   Fri, 2 Dec 2022 19:10:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: x86: fix APICv/x2AVIC disabled when vm reboot by
 itself
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mlevitsk@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1669984574-32692-1-git-send-email-yuanzhaoxiong@baidu.com>
 <Y4oeh6XWw2qzETEQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4oeh6XWw2qzETEQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/2/22 16:49, Sean Christopherson wrote:
> On Fri, Dec 02, 2022, Yuan ZhaoXiong wrote:
>> This patch fixes that VM rebooting itself will cause APICv
>> disabled when VM is started with APICv/x2AVIC enabled.
>>
>> When a VM reboot itself, The Qemu whill reset LAPIC by invoking
>> ioctl(KVM_SET_LAPIC, ...) to disable x2APIC mode and set APIC_ID
>> to its vcpuid in xAPIC mode.
>>
>> That will be handled in KVM as follows:
>>
>>       kvm_vcpu_ioctl_set_lapic
>>         kvm_apic_set_state
>> 	  kvm_lapic_set_base  =>  disable X2APIC mode
>> 	    kvm_apic_state_fixup
>> 	      kvm_lapic_xapic_id_updated
>> 	        kvm_xapic_id(apic) != apic->vcpu->vcpu_id
>> 		kvm_set_apicv_inhibit(APICV_INHIBIT_REASON_APIC_ID_MODIFIED)
>> 	   memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s))  => update APIC_ID
>>
>> kvm_apic_set_state invokes kvm_lapic_set_base to disable x2APIC mode
>> firstly, but don't change APIC_ID, APIC_ID is 32 bits in x2APIC mode
>> and 8 bist(bit 24 ~ bit 31) in xAPIC mode. So kvm_lapic_xapic_id_updated
>> will set APICV_INHIBIT_REASON_APIC_ID_MODIFIED bit inhibit and disable
>> APICv/x2AVIC.
>>
>> kvm_lapic_xapic_id_updated must be called after APIC_ID is changed.
>>
>> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
>>
>> Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
>> ---
>>   arch/x86/kvm/lapic.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index d7639d1..bf5ce86 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2722,8 +2722,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>>   			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>>   			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>>   		}
>> -	} else {
>> -		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
>>   	}
>>   
>>   	return 0;
>> @@ -2759,6 +2757,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>>   	}
>>   	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>>   
>> +	if (!apic_x2apic_mode(apic))
>> +		kvm_lapic_xapic_id_updated(apic);
>> +
> 
> Already posted[*], along with a pile of other APIC fixes.  Hopefully it will land
> in 6.2.

I'll let this patch overtake the others since it is stable@ material.

I'll also volunteer someone to write a testcase (we can add an 
apicv_enabled boolean statistic too for the sake of the test).

Paolo

> [*] https://lore.kernel.org/all/20221001005915.2041642-7-seanjc@google.com

