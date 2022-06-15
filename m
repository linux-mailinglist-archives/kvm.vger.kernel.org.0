Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C4754CB91
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245626AbiFOOmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349219AbiFOOlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:41:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 596713153D
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655304089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PF6zqQnyPSf5DhKZM4pIhF6Gs544Q4BUxgZ4sGWs3gk=;
        b=EqFBvJ+A+Q4WajZSP7YCb9CGyOgmA/iYYtYf5W0Fb2gL6pBRrR3ArRJWdBpLcw8uOQbz3v
        3RC0t5D5VJpVrrFdBPdN28/JBT4sdXib7B9/K11SmvoxSTgGgmdoq/0zwRY6R60MaClf7f
        mSknzTKHs8AePTofL+o+aZMUdieHN5c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-5p7cls1BOuyVkfRrzdFLCg-1; Wed, 15 Jun 2022 10:41:28 -0400
X-MC-Unique: 5p7cls1BOuyVkfRrzdFLCg-1
Received: by mail-wm1-f72.google.com with SMTP id j20-20020a05600c1c1400b0039c747a1e5aso1299460wms.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=PF6zqQnyPSf5DhKZM4pIhF6Gs544Q4BUxgZ4sGWs3gk=;
        b=bMfR+VsKR3jL+bBCDs/U8MgGviZ3pjJtTPyl+DWluwU5m8SSbXfnS9Atg6W21TAGTH
         JQGm14QtQKQYxuDjIS52QI/2vQmY26KPznMpGPf1KWm2ok077Sgpc6rJ9InKGf5mH660
         wENtnWFz+6MXSzTYNQzdT17fIxhGnnZHVOXqmy9GKodMJza0EuhPTnwW0SbrZneDEXle
         ws+0QSUadcp1/kfQPF8w8ZnOkYOuHN/nCNd4cdCX5VAfJ29cOHWYPSD/l97ezICxgfHo
         K/Qj4dYQ5THPsoVccRUfOXnatP4ARIpgThhAzXPR59WcsY3gCU/w8qJS0G/E/pdLsJZs
         ODLg==
X-Gm-Message-State: AJIora+JGsbElqpqpfWEvQlOh7QF840uiAbklG4uBAzR2wTVo3L1lNoW
        3dpzvMRIcafrO1l3Y3Miue2l4pL8mg9YJmUdO2gQiWPbCIez8mX5IPek5NvPMiJyMbucYcvfw6H
        XU+im87nNKPCW
X-Received: by 2002:a5d:5c04:0:b0:21a:23e0:6ba3 with SMTP id cc4-20020a5d5c04000000b0021a23e06ba3mr143466wrb.71.1655304086178;
        Wed, 15 Jun 2022 07:41:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tM2UgzMTtlFDYLrxnzoxjjBmm/N+BB0gblnqodYLm//YxFzehP59lNUWCo87G4DF8GEoCU7A==
X-Received: by 2002:a5d:5c04:0:b0:21a:23e0:6ba3 with SMTP id cc4-20020a5d5c04000000b0021a23e06ba3mr143453wrb.71.1655304085947;
        Wed, 15 Jun 2022 07:41:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q1-20020adff501000000b002117ef160fbsm15081710wro.21.2022.06.15.07.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 07:41:25 -0700 (PDT)
Message-ID: <c6cd0617-7b32-7f87-6f55-52ec097fb250@redhat.com>
Date:   Wed, 15 Jun 2022 16:41:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-7-pbonzini@redhat.com> <YqJ5OXwAyXvQuC2/@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/6] KVM: SEV-ES: reuse advance_sev_es_emulated_ins for
 OUT too
In-Reply-To: <YqJ5OXwAyXvQuC2/@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/22 00:50, Sean Christopherson wrote:
> On Wed, Jun 08, 2022, Paolo Bonzini wrote:
>> complete_emulator_pio_in only has to be called by
>> complete_sev_es_emulated_ins now; therefore, all that the function does
>> now is adjust sev_pio_count and sev_pio_data.  Which is the same for
>> both IN and OUT.
>>
>> No functional change intended.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fd4382602f65..a3651aa74ed7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -13007,6 +13007,12 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned int bytes,
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_sev_es_mmio_read);
>>   
>> +static void advance_sev_es_emulated_pio(struct kvm_vcpu *vcpu, unsigned count, int size)
>> +{
>> +	vcpu->arch.sev_pio_count -= count;
>> +	vcpu->arch.sev_pio_data += count * size;
>> +}
>> +
>>   static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>>   			   unsigned int port);
>>   
>> @@ -13030,8 +13036,7 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>>   		int ret = emulator_pio_out(vcpu, size, port, vcpu->arch.sev_pio_data, count);
>>   
>>   		/* memcpy done already by emulator_pio_out.  */
>> -		vcpu->arch.sev_pio_count -= count;
>> -		vcpu->arch.sev_pio_data += count * vcpu->arch.pio.size;
>> +		advance_sev_es_emulated_pio(vcpu, count, size);
> 
> I think this is a bug fix that should go in a separate patch.  size == vcpu->arch.pio.size
> when kvm_sev_es_outs() is called from complete_sev_es_emulated_outs(), but when
> it's called from kvm_sev_es_string_io() it will hold the size of the previous PIO.

It's not a bugfix for current master, because emulator_pio_out() sets 
vcpu->arch.pio.size = size.

However, it has to be moved before "KVM: x86: wean in-kernel PIO from 
vcpu->arch.pio*" or squashed therein.

Paolo

>>   		if (!ret)
>>   			break;
>>   
>> @@ -13047,12 +13052,6 @@ static int kvm_sev_es_outs(struct kvm_vcpu *vcpu, unsigned int size,
>>   static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>>   			  unsigned int port);
>>   
>> -static void advance_sev_es_emulated_ins(struct kvm_vcpu *vcpu, unsigned count, int size)
>> -{
>> -	vcpu->arch.sev_pio_count -= count;
>> -	vcpu->arch.sev_pio_data += count * size;
>> -}
>> -
>>   static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned count = vcpu->arch.pio.count;
>> @@ -13060,7 +13059,7 @@ static int complete_sev_es_emulated_ins(struct kvm_vcpu *vcpu)
>>   	int port = vcpu->arch.pio.port;
>>   
>>   	complete_emulator_pio_in(vcpu, vcpu->arch.sev_pio_data);
>> -	advance_sev_es_emulated_ins(vcpu, count, size);
>> +	advance_sev_es_emulated_pio(vcpu, count, size);
>>   	if (vcpu->arch.sev_pio_count)
>>   		return kvm_sev_es_ins(vcpu, size, port);
>>   	return 1;
>> @@ -13076,7 +13075,7 @@ static int kvm_sev_es_ins(struct kvm_vcpu *vcpu, unsigned int size,
>>   			break;
>>   
>>   		/* Emulation done by the kernel.  */
>> -		advance_sev_es_emulated_ins(vcpu, count, size);
>> +		advance_sev_es_emulated_pio(vcpu, count, size);
>>   		if (!vcpu->arch.sev_pio_count)
>>   			return 1;
>>   	}
>> -- 
>> 2.31.1
>>
> 

