Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21B677D8DD
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241514AbjHPDLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241504AbjHPDLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:11:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2DBE6B;
        Tue, 15 Aug 2023 20:11:07 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bda9207132so48075675ad.0;
        Tue, 15 Aug 2023 20:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692155467; x=1692760267;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFcNtuBxixf5wJuU8gYA0YbfyYSQsy3zy43VL6AoIEY=;
        b=SRUA0K5UfvnzSINPXjOGsfInJgg9jLJF8AFzEUCIEEszX7g/RIcWRPwaQLREyXJX9a
         AhgL1fflrqmmLxB6lHSJEmG2HoIpjYvR64CUmme8fbdv22c2H89taCMOtxO8AliL9JMb
         aI1Ariuz+hDlNOhbZqQqbQOAEn/900EFSxsQlMxwCai/8Xh5tqp4dRI1zbbsLvI9lYlZ
         2D86rkm/j9FeEZ+B592IY90PpCv44KAnVnSLOByafiS1c1JZTO8PUpoOzFe6RfApse6I
         W2GbwGUZ1MnGpObtJR0VRpLbUNKMq43wXqfhdgxt+o4To/FZlvVj5snta8zDTy6NyAyi
         riFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692155467; x=1692760267;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CFcNtuBxixf5wJuU8gYA0YbfyYSQsy3zy43VL6AoIEY=;
        b=hnOHHlW24pvZ4USgSGqrF4nIE8ejsN0JOVPMbLvSwFnIqr9cv5b6coLm/6fV8grpoW
         zJgSs14bDEbaXfjgLHIgBaCDDvV893mUTpc5xpJvKK4WDR4TstYmXpPR/bOhBxAaMdHm
         oJxc1nLXGfRxIp+vQ1OIkDnLlxkHiWTUjBLKssMlc44bKGDM0A9wAZgOvVSFV8h8OarQ
         R6EcSchYXzoA4xTSikpMnn6zo/+HQIZUL5GPFuJ55ym30+SvNtz1HJI1M5sAw+GZAI4o
         GK9JAs6Gof+85k38nwBitGhipLkcVCCAn/aFMVMc1/ReduP0J0XiDVh4kayC20rffvee
         MjBQ==
X-Gm-Message-State: AOJu0Yw/gtHhYEOhw9ahCrcBZGVEpOb/JprDwMzrgc//GZ+Xw3bIVEoK
        m8Jf5+wclF3GNUAkQcx/jCc=
X-Google-Smtp-Source: AGHT+IGkc2hUDta+IGakHFjBInQVHNIBETmu5s9HDyvblnc18wwsR4JMRHOdec1VsGltqDsuiTUy+w==
X-Received: by 2002:a17:902:bd42:b0:1bd:d663:45ad with SMTP id b2-20020a170902bd4200b001bdd66345admr723438plx.68.1692155466914;
        Tue, 15 Aug 2023 20:11:06 -0700 (PDT)
Received: from localhost.localdomain ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b001b8622c1ad2sm11792839plx.130.2023.08.15.20.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:11:06 -0700 (PDT)
Subject: Re: [PATCH v3 1/6] KVM: PPC: Use getters and setters for vcpu
 register state
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, mikey@neuling.org,
        paulus@ozlabs.org, vaibhav@linux.ibm.com, sbhat@linux.ibm.com,
        gautam@linux.ibm.com, kconsul@linux.vnet.ibm.com,
        amachhiw@linux.vnet.ibm.com
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-2-jniethe5@gmail.com>
 <CUS44PQRFL72.28PFLWO36FYAO@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <71e14e67-3ba4-4ddd-921d-38181f3c0159@gmail.com>
Date:   Wed, 16 Aug 2023 13:11:00 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CUS44PQRFL72.28PFLWO36FYAO@wheely>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/8/23 6:08 pm, Nicholas Piggin wrote:
> On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
>> There are already some getter and setter functions used for accessing
>> vcpu register state, e.g. kvmppc_get_pc(). There are also more
>> complicated examples that are generated by macros like
>> kvmppc_get_sprg0() which are generated by the SHARED_SPRNG_WRAPPER()
>> macro.
>>
>> In the new PAPR "Nestedv2" API for nested guest partitions the L1 is
>> required to communicate with the L0 to modify and read nested guest
>> state.
>>
>> Prepare to support this by replacing direct accesses to vcpu register
>> state with wrapper functions. Follow the existing pattern of using
>> macros to generate individual wrappers. These wrappers will
>> be augmented for supporting Nestedv2 guests later.
>>
>> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
>> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
>> ---
>> v3:
>>    - Do not add a helper for pvr
>>    - Use an expression when declaring variable in case
>>    - Squash in all getters and setters
>>    - Guatam: Pass vector registers by reference
>> ---
>>   arch/powerpc/include/asm/kvm_book3s.h  | 123 +++++++++++++-
>>   arch/powerpc/include/asm/kvm_booke.h   |  10 ++
>>   arch/powerpc/kvm/book3s.c              |  38 ++---
>>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |   4 +-
>>   arch/powerpc/kvm/book3s_64_mmu_radix.c |   9 +-
>>   arch/powerpc/kvm/book3s_64_vio.c       |   4 +-
>>   arch/powerpc/kvm/book3s_hv.c           | 220 +++++++++++++------------
>>   arch/powerpc/kvm/book3s_hv.h           |  58 +++++++
>>   arch/powerpc/kvm/book3s_hv_builtin.c   |  10 +-
>>   arch/powerpc/kvm/book3s_hv_p9_entry.c  |   4 +-
>>   arch/powerpc/kvm/book3s_hv_ras.c       |   5 +-
>>   arch/powerpc/kvm/book3s_hv_rm_mmu.c    |   8 +-
>>   arch/powerpc/kvm/book3s_hv_rm_xics.c   |   4 +-
>>   arch/powerpc/kvm/book3s_xive.c         |   9 +-
>>   arch/powerpc/kvm/emulate_loadstore.c   |   2 +-
>>   arch/powerpc/kvm/powerpc.c             |  76 ++++-----
>>   16 files changed, 395 insertions(+), 189 deletions(-)
>>
> 
> [snip]
> 
>> +
>>   /* Expiry time of vcpu DEC relative to host TB */
>>   static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
>>   {
>> -	return vcpu->arch.dec_expires - vcpu->arch.vcore->tb_offset;
>> +	return kvmppc_get_dec_expires(vcpu) - kvmppc_get_tb_offset_hv(vcpu);
>>   }
> 
> I don't see kvmppc_get_tb_offset_hv in this patch.

It should be generated by:

KVMPPC_BOOK3S_VCORE_ACCESSOR(tb_offset, 64)

> 
>> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
>> index 7f765d5ad436..738f2ecbe9b9 100644
>> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
>> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
>> @@ -347,7 +347,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
>>   	unsigned long v, orig_v, gr;
>>   	__be64 *hptep;
>>   	long int index;
>> -	int virtmode = vcpu->arch.shregs.msr & (data ? MSR_DR : MSR_IR);
>> +	int virtmode = kvmppc_get_msr(vcpu) & (data ? MSR_DR : MSR_IR);
>>   
>>   	if (kvm_is_radix(vcpu->kvm))
>>   		return kvmppc_mmu_radix_xlate(vcpu, eaddr, gpte, data, iswrite);
> 
> So this isn't _only_ adding new accessors. This should be functionally a
> noop, but I think it introduces a branch if PR is defined.

That being checking kvmppc_shared_big_endian()?

> 
> Shared page is a slight annoyance for HV, I'd like to get rid of it...
> but that's another story. I think the pattern here would be to add a
> kvmppc_get_msr_hv() accessor.

Yes, that will work.

> 
> And as a nitpick, for anywhere employing existing access functions, gprs
> and such, could that be split into its own patch?

Sure will do. One other thing I could do is make the existing functions 
use the macros if they don't already. Do you think that is worth doing?

> 
> Looks pretty good aside from those little things.

Thanks.

> 
> Thanks,
> Nick
> 
