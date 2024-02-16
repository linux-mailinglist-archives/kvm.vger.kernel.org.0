Return-Path: <kvm+bounces-8854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 06CE385760F
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 07:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FF28B234D4
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 06:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEE81429F;
	Fri, 16 Feb 2024 06:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEMgBKMX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CED14003
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 06:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708065122; cv=none; b=Ik6ZH3kpZohiXp2EdD6lYC8xIHBZBWDAR/lYGffoqFA18RihTSbX2iDsi3tOMqYk7i5aO/JDjr7kIoC9/YIgJRzDkHFj5gSWHKAe4YoLRW74ycap39NXbbrPA5GYcve6MqJHzUQlak3ZleG+XdsqfmbsoHu3iZ+aBZNW/8eSpwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708065122; c=relaxed/simple;
	bh=CHeBZVA05dPeLqjBvbNG3dAPeMKLkLDQY4UQJqoWtmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJxDpwWKpNe7u0qLsHbtI9QxEW4QIeFzlGOlkZ+JJkOgalvxzYX6KMyOwWlFGPHSylmcEaYhohiRl7C0OZIdWFGTFQkRb0eN5b3W3r8VUpJRD+pe+Ccj2avzVkU6w3qgnv+mTWYLByM4gzJpfnFEpVQl0iYM8Ync7ZzBcIfNUeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEMgBKMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708065119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NWj08zEz4FnmRIWCreh0rVEojnaOMABy5TQpgmQ1fl0=;
	b=JEMgBKMXbtAS+PeSAXjWPvkedP7JTOUL60vrq/yb/CxBCt/KUeR+5Pdnn7MQ4rSNZfVA10
	dCvjJjyBmng+ZtZ9vbnkNcxqTBYUyTmXr5v3GjG4GsmVHC45W9PB4z1/SVDlVxNKMtwNC1
	wjBdxBPjmOQ4o+qFHZvJkXRRuZuc3Zw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-j7-u3gN2PzOv5gykDWDaIQ-1; Fri, 16 Feb 2024 01:31:57 -0500
X-MC-Unique: j7-u3gN2PzOv5gykDWDaIQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a2cb0d70d6cso108342966b.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 22:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708065116; x=1708669916;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NWj08zEz4FnmRIWCreh0rVEojnaOMABy5TQpgmQ1fl0=;
        b=WIo3ck1BtdvNkDn8Vb1GA9pV/rG62GGufEy+LHVA3gN1fbeCpvZOmcmbrNY2d7PEeC
         lSPUr6uN2+8jOHOuiGdD3Tl2bjVHeJXv/nJimJ/u1cxz2AhUKrKdtWWEhUiXp/urUlH5
         qhXcxQioDHuUnDx8/TXbmImZjoXz+QULYMU/4jD65/tC50VqZyrQBDAwYqD9r81CaQug
         dDoxmp6R9ABXIgxS+gyhFq4H5WDsem/a7xf51NZEXetpfY3uwV6b2drqCblc2FBBQv06
         vsWdMOYVg6b4DMh7gxNVe7+TpI7TGn/VfF8YYKt3Mlbr/0Qc51EJV4XNgumlg79NeU5A
         /c8A==
X-Forwarded-Encrypted: i=1; AJvYcCU8sYIHotQgNgYH/aWxejEsszw1OBaNszcAaegBDXqE5lZ6so9DVecTyQkPC38EqQ5rucRvWMmSAHdx7HQ6T+5DlTfK
X-Gm-Message-State: AOJu0Yy+71safi7Tf1dJSD/49ioKXA01C4S+ppd77BAon9qVLF4WLhyJ
	sbqrptMTdQw5aggx5KpUmjbUKD7Zli46V/7C0IB+4P7Op22CTn0OpuSzbV+AqbBjkdqCFRiydqn
	oJtp6TMu0YNDJ+ycm/y5V9iYL+ApRnv4hX+lLJUaWLKlpvbZ5Tg==
X-Received: by 2002:a17:906:34cb:b0:a3d:eb0a:be43 with SMTP id h11-20020a17090634cb00b00a3deb0abe43mr171075ejb.1.1708065116334;
        Thu, 15 Feb 2024 22:31:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZTGxLBFRFEbfDbIquT8Onv+s2L6kNc0guP2/iwG8OkouD12dwyrV4hQz0Gt6aWDbXuFC0dg==
X-Received: by 2002:a17:906:34cb:b0:a3d:eb0a:be43 with SMTP id h11-20020a17090634cb00b00a3deb0abe43mr171057ejb.1.1708065115947;
        Thu, 15 Feb 2024 22:31:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id qo3-20020a170907874300b00a3d9e6e9983sm1137823ejc.174.2024.02.15.22.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 22:31:55 -0800 (PST)
Message-ID: <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
Date: Fri, 16 Feb 2024 07:31:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
Content-Language: en-US
To: Xin Li <xin@zytor.com>, Sean Christopherson <seanjc@google.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
 Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 03:10, Xin Li wrote:
> On 2/15/2024 11:55 AM, Sean Christopherson wrote:
>> +Paolo and Stephen
>>
>> FYI, there's a build failure in -next due to a collision between 
>> kvm/next and
>> tip/x86/fred.  The above makes everything happy.
>>
>> On Thu, Feb 15, 2024, Max Kellermann wrote:
>>> When KVM is disabled, the POSTED_INTR_* macros do not exist, and the
>>> build fails.
>>>
>>> Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
>>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
>>> ---
>>>   arch/x86/entry/entry_fred.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
>>> index ac120cbdaaf2..660b7f7f9a79 100644
>>> --- a/arch/x86/entry/entry_fred.c
>>> +++ b/arch/x86/entry/entry_fred.c
>>> @@ -114,9 +114,11 @@ static idtentry_t 
>>> sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
>>>       SYSVEC(IRQ_WORK_VECTOR,            irq_work),
>>> +#if IS_ENABLED(CONFIG_KVM)
>>>       SYSVEC(POSTED_INTR_VECTOR,        kvm_posted_intr_ipi),
>>>       SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    kvm_posted_intr_wakeup_ipi),
>>>       SYSVEC(POSTED_INTR_NESTED_VECTOR,    kvm_posted_intr_nested_ipi),
>>> +#endif
>>>   };
>>>   static bool fred_setup_done __initdata;
>>> -- 
>>> 2.39.2
> 
> We want to minimize #ifdeffery (which is why we didn't add any to
> sysvec_table[]), would it be better to simply remove "#if 
> IS_ENABLED(CONFIG_KVM)" around the the POSTED_INTR_* macros from the
> Linux-next tree?
> 
> BTW, kvm_posted_intr_*() are defined to NULL if !IS_ENABLED(CONFIG_KVM).

It is intentional that KVM-related things are compiled out completely
if !IS_ENABLED(CONFIG_KVM), because then it's also not necessary to have

# define fred_sysvec_kvm_posted_intr_ipi                NULL
# define fred_sysvec_kvm_posted_intr_wakeup_ipi         NULL
# define fred_sysvec_kvm_posted_intr_nested_ipi         NULL

in arch/x86/include/asm/idtentry.h. The full conflict resultion is

diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index ac120cbdaaf2..660b7f7f9a79 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -114,9 +114,11 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
  
      SYSVEC(IRQ_WORK_VECTOR,            irq_work),
  
+#if IS_ENABLED(CONFIG_KVM)
      SYSVEC(POSTED_INTR_VECTOR,        kvm_posted_intr_ipi),
      SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    kvm_posted_intr_wakeup_ipi),
      SYSVEC(POSTED_INTR_NESTED_VECTOR,    kvm_posted_intr_nested_ipi),
+#endif
  };
  
  static bool fred_setup_done __initdata;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 749c7411d2f1..758f6a2838a8 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -745,10 +745,6 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,        sysvec_irq_work);
  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,        sysvec_kvm_posted_intr_ipi);
  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,    sysvec_kvm_posted_intr_wakeup_ipi);
  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,    sysvec_kvm_posted_intr_nested_ipi);
-#else
-# define fred_sysvec_kvm_posted_intr_ipi        NULL
-# define fred_sysvec_kvm_posted_intr_wakeup_ipi        NULL
-# define fred_sysvec_kvm_posted_intr_nested_ipi        NULL
  #endif
  
  #if IS_ENABLED(CONFIG_HYPERV)

and it seems to be a net improvement to me.  The #ifs match in
the .h and .c files, and there are no unnecessary initializers
in the sysvec_table.

Paolo


