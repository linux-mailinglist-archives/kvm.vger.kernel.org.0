Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDAC4BBE5B
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238548AbiBRR1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:27:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238539AbiBRR1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:27:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59452FD1A
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645205220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=upweF6mJlzxIKcNN/0kmnYngCUVtOGRIXfAJ2sVsDfw=;
        b=hFGmEMhh9PzZXqO3BAPFPsxYsfHDmWWANQOyfHvLl0rHUL6P39okcP4w9WShPUUk2asVM6
        cQlzY+d/uFoOEYD3fYx7kKvBk0St1wGxb2i5X3tdPAeGIR5ZarN3h7wsZkNjNAQqkDL5jf
        3HPMov7EMo2Wa19e/28AgQK9sgsaB/k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-zCxBrfmxN86ApHndd9HF6w-1; Fri, 18 Feb 2022 12:26:59 -0500
X-MC-Unique: zCxBrfmxN86ApHndd9HF6w-1
Received: by mail-ed1-f69.google.com with SMTP id r9-20020a05640251c900b00412d54ea618so228002edd.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=upweF6mJlzxIKcNN/0kmnYngCUVtOGRIXfAJ2sVsDfw=;
        b=KXpHJ5HDetD2HdyoXdpRJluJushx9bng4Hu8pO7UWdoIk2LiDE20aodtz3MgfyqIpR
         oa1m/RKpz22qoNUxOujCcvsRXsjfmsew4m7cL0yvsfX2jjGMYjLir4hq2/6RDro1NHbm
         MYaLdPJzCC+A+g4qNAvjTho7DsGUfyD6CPiudHjjKdbt8EiQr4x4dSiZVWT+d+D5nDYk
         V0FjdCy8lYYxixBjRraU0BkV/uMxwrtcYG8vTVOQTHN5+CAFP9JTDQld3eJ6jAbNeodz
         oO2/W4AqbJHL8oTXtxQoyzILzB/Qu8CFnxQMMygrkMywyA8jkWJizI7pXOJ7P3ZKDsdS
         MifA==
X-Gm-Message-State: AOAM531vEGySHBxg4N0D/t9NgiJp0mS/sTMfl+bLlMOdC2edBErFnM/c
        Mh8Fl1Pl4oFFdjOk/G5gO87WoqG68zjz2s7UXsiIbC8dcoqEbi9FaqdPzMKOFFGfJ2jSIW2X3rm
        EuvSAsuu0bbKb
X-Received: by 2002:a17:906:f115:b0:6b8:7a29:e60f with SMTP id gv21-20020a170906f11500b006b87a29e60fmr6946365ejb.706.1645205217407;
        Fri, 18 Feb 2022 09:26:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/81bd1BueB+HdpPjgcMOvE/9BWHDqPOZaCj83zw0giSvBVCxqBHjRDBU7PKEiR2f8opRVFg==
X-Received: by 2002:a17:906:f115:b0:6b8:7a29:e60f with SMTP id gv21-20020a170906f11500b006b87a29e60fmr6946347ejb.706.1645205217167;
        Fri, 18 Feb 2022 09:26:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h14sm1298837edz.29.2022.02.18.09.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 09:26:56 -0800 (PST)
Message-ID: <b6553a40-3a4c-4bd7-ea4e-2d5cf649d0f8@redhat.com>
Date:   Fri, 18 Feb 2022 18:26:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 01/18] KVM: x86: host-initiated EFER.LME write affects
 the MMU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-2-pbonzini@redhat.com> <Yg/Sd3UE2aCNimGj@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yg/Sd3UE2aCNimGj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 18:08, Sean Christopherson wrote:
> The shortlog doesn't come remotely close to saying what this patch does, it's
> simply a statement.
> 
>    KVM: x86: Reset the MMU context if host userspace toggles EFER.LME

I'd like not to use "reset the MMU context" because 1) the meaning 
changes at the end of the series so it's not the best time to use the 
expression, 2) actually I hope to get rid of it completely and just use 
kvm_init_mmu.

I'll use "Reinitialize MMU" which is the important part of 
kvm_reset_mmu_context().

Paolo

> On Thu, Feb 17, 2022, Paolo Bonzini wrote:
>> While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and therefore
>> EFER.NX is the only bit that can affect the MMU role.  However, set_efer accepts
>> a host-initiated change to EFER.LME even with CR0.PG=1.  In that case, the
>> MMU has to be reset.
> 
> Wrap at ~75 please.
> 
>> Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
> 
> With nits addressed,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>>   arch/x86/kvm/mmu.h | 1 +
>>   arch/x86/kvm/x86.c | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 51faa2c76ca5..a5a50cfeffff 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -48,6 +48,7 @@
>>   			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
>>   
>>   #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
>> +#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
>>   
>>   static __always_inline u64 rsvd_bits(int s, int e)
>>   {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d3da64106685..99a58c25f5c2 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1647,7 +1647,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	}
>>   
>>   	/* Update reserved bits */
> 
> This comment needs to be dropped, toggling EFER.LME affects more than just reserved
> bits.
> 
>> -	if ((efer ^ old_efer) & EFER_NX)
>> +	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
>>   		kvm_mmu_reset_context(vcpu);
>>   
>>   	return 0;
>> -- 
>> 2.31.1
>>
>>
> 

