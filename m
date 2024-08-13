Return-Path: <kvm+bounces-24061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA507950DFF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 22:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E46F2B244BC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E70B1A7042;
	Tue, 13 Aug 2024 20:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/KJwZyO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272384436A;
	Tue, 13 Aug 2024 20:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723581204; cv=none; b=QM9x6FwS5AVn0qTgxOUlkoxMiJf4rzOLsErW3kvOQd39dwQj3fNzEyccpIf60LSpXce2ua5Iu+nUqW1pOrlv+IdAWL4InpMBy/USflKlur0eNc3x+ikyIsIzCv7cyoZ9GSx5MUmjK2+NO9awyiLGL++H6KIFfj0xIsqeKyKuacg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723581204; c=relaxed/simple;
	bh=k9NVdV7QJy7QWOchjNpKeM81d23iSXGuo+157PXQtbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXxj9iSPaYPZxkLNH3LUNFp1X0b+OT//N5IBadU13n4qt2c9AnB4Az9gQswvRr1nEeiFc998uiiYraV/Y6oSgygttUT2e8y/ENDm0uZiIh1TB4iCm33wNEhiMVRcFvbghsj8xVfEYGQXfTKZtC7bwAqFGPEpb8acS9eqIFB+0oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/KJwZyO; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso7881472a12.1;
        Tue, 13 Aug 2024 13:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723581201; x=1724186001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JqzZpM8PtuFAPQraVfX2TWqheb6GNwSDUTMcbEAdyPw=;
        b=i/KJwZyO9274oKmF9hJXxnWxyM6qhALl9IPyPZH8FTxpBGvA56gFkvNcmgQvX8V3bN
         QbYzcKPLnJexwVteeNpunrAhB1wsz2OYBbUKsiCsc4BNVx7ihsz4tHG4fnScHwtCcFS2
         D4T9IwPXtj7/A8ngPLGJDG2dGwMpEXLP+6dnmXvc5K5cSVai4gMKRd42zDyVPhrVcY6T
         iPRsxjF//vN1c1a/3DTStLCdKFwbbmK03A2lvRsAs4Zo9yXhBvEHytBYJTZNx8v+qzKe
         l6AucfPp79DDH2Qqkql8bUWLv9tyu07es2OsPYdCJ7or3BVsJECwTLya0Kb2sgECbIxW
         1cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723581201; x=1724186001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JqzZpM8PtuFAPQraVfX2TWqheb6GNwSDUTMcbEAdyPw=;
        b=rioQmGKHORbR45rDyZfPmPn41g1EdKlcqSTHwccHL2kR+vmiDXVK+D0mBBAN6g8uwg
         bF/ONz9sMLd0ZDxb8QYrcXdCmBV11SfoI3F4+Skw4WMJcLFUvFZKvYLW3GpsUJD/rFX5
         NV/CylD6gHS4t31gBnVL6kd+Iiazm78DvKlp1QLiBhkwLhw0jbHopXgippi+k9alaUJX
         hNH7hs81N20+smY8H5b5pGgM462JNsN9XKM9SIU/F70jxqX1wxhCgbVylvDGBL/8np9E
         L1TSA/CoBPna1OO2gMdhRRHPbbkiqXi20vzKxFAFVo+rCgE63evl5G2BPlPPk37pQE89
         Bo3A==
X-Forwarded-Encrypted: i=1; AJvYcCVKCdNUAnErdMflzm7ybgN2VZnPqtgoF6wRN8GEQ0dfI5NvamYB6L8sqVF4XGPz6pxchKgQMxyt5C76OkuQyRWyf3IuFnu6fb6fOENX
X-Gm-Message-State: AOJu0YzsBn3zS2qtNhiEkAUxqR8isDG9HcKImmxqNCz909ocPMJuJhIt
	WUM7Fr6B+05JY1FBR6ivnsSm10h3tpPTs1HV7TeoLyBW92ywvRAm
X-Google-Smtp-Source: AGHT+IENCWW45EkzC0VEt+p4fK0fVuN70Y+X10RXdlBebi1thH5+goIJmDuw3cMWbTIBOvoe2IGqrA==
X-Received: by 2002:a17:907:f786:b0:a77:e55a:9e92 with SMTP id a640c23a62f3a-a8366d47ebcmr35190366b.30.1723581200966;
        Tue, 13 Aug 2024 13:33:20 -0700 (PDT)
Received: from [192.168.178.20] (dh207-40-227.xnet.hr. [88.207.40.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f414f06bsm95426166b.159.2024.08.13.13.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 13:33:20 -0700 (PDT)
Message-ID: <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
Date: Tue, 13 Aug 2024 22:33:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5BBUG=5D_arch/x86/kvm/vmx/vmx=5Fonhyperv=2Eh=3A109?=
 =?UTF-8?B?OjM2OiBlcnJvcjogZGVyZWZlcmVuY2Ugb2YgTlVMTCDigJgw4oCZ?=
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
 <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com> <87a5i05nqj.fsf@redhat.com>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <87a5i05nqj.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/29/24 15:31, Vitaly Kuznetsov wrote:
> Mirsad Todorovac <mtodorovac69@gmail.com> writes:
> 
>> On 7/19/24 20:53, Sean Christopherson wrote:
>>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>>> Hi, all!
>>>>
>>>> Here is another potential NULL pointer dereference in kvm subsystem of linux
>>>> stable vanilla 6.10, as GCC 12.3.0 complains.
>>>>
>>>> (Please don't throw stuff at me, I think this is the last one for today :-)
>>>>
>>>> arch/x86/include/asm/mshyperv.h
>>>> -------------------------------
>>>>   242 static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
>>>>   243 {
>>>>   244         if (!hv_vp_assist_page)
>>>>   245                 return NULL;
>>>>   246 
>>>>   247         return hv_vp_assist_page[cpu];
>>>>   248 }
>>>>
>>>> arch/x86/kvm/vmx/vmx_onhyperv.h
>>>> -------------------------------
>>>>   102 static inline void evmcs_load(u64 phys_addr)
>>>>   103 {
>>>>   104         struct hv_vp_assist_page *vp_ap =
>>>>   105                 hv_get_vp_assist_page(smp_processor_id());
>>>>   106 
>>>>   107         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>>>   108                 vp_ap->nested_control.features.directhypercall = 1;
>>>>   109         vp_ap->current_nested_vmcs = phys_addr;
>>>>   110         vp_ap->enlighten_vmentry = 1;
>>>>   111 }
>>>>
> 
> ...
> 
>>
>> GCC 12.3.0 appears unaware of this fact that evmcs_load() cannot be called with hv_vp_assist_page() == NULL.
>>
>> This, for example, silences the warning and also hardens the code against the "impossible" situations:
>>
>> -------------------><------------------------------------------------------------------
>> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> index eb48153bfd73..8b0e3ffa7fc1 100644
>> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
>> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> @@ -104,6 +104,11 @@ static inline void evmcs_load(u64 phys_addr)
>>         struct hv_vp_assist_page *vp_ap =
>>                 hv_get_vp_assist_page(smp_processor_id());
>>  
>> +       if (!vp_ap) {
>> +               pr_warn("BUG: hy_get_vp_assist_page(%d) returned NULL.\n", smp_processor_id());
>> +               return;
>> +       }
>> +
>>         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>                 vp_ap->nested_control.features.directhypercall = 1;
>>         vp_ap->current_nested_vmcs = phys_addr;
> 
> As Sean said, this does not seem to be possible today but I uderstand
> why the compiler is not able to infer this. If we were to fix this, I'd
> suggest we do something like "BUG_ON(!vp_ap)" (with a comment why)
> instead of the suggested patch:

That sounds awesome, but I really dare not poke into KVM stuff at my level. :-/

> - pr_warn() is not ratelimited

This is indeed a problem. I did not see that coming.

> - 'return' from evmcs_load does not propagate the error so the VM is
> going to misbehave somewhere else.

Agreed. But, frankly, I do not see where to jump or return to in case of such bug.

I would just feel safer with a sentinel or a return value check, just as in userland some
people expect malloc() to always succeed - but the diligent check return value of this and
all syscalls. ;-)

Best regards,
Mirsad Todorovac

