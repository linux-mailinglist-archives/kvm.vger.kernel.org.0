Return-Path: <kvm+bounces-24118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5BB49516DF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4147B215E4
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6332214373B;
	Wed, 14 Aug 2024 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTygB0x1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8E217721
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723625108; cv=none; b=DzYe17maTvSGIUWCONEGNXwioxG2mrwBPATMMt0iFUnls8y4OlwpU6/dkDBnVQdWnaE9NszPx0DvxqMvKoq4A2I3CppV2D9G5OkVtQlRLMuofHG7joZVoXW6odGyZz+21AxZ5+hLJxCDOi1XUkLz625XWMyE59RL0y0jUu/i3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723625108; c=relaxed/simple;
	bh=QrDGC86x1xaRXuKpPMO6Uk2eDrZ9ud7JG3yamK/yxnk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PoPlGjXcLmcLDNWpzYTp9BPyo8hrmbe3P5Wrn0fV7tPLvvXnVoo0/oOjqn2Lfw2EoSM5z4p/E9kf2BZm7k+jrfMAhXhG532Dc/VF68JR9UwfZUdyYPI2nX442i8dr297Vo8+j4eg4xKr6e7sAen7LkG1SF85KCZP9cNLCIhFxJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fTygB0x1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723625105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7hwkKCoOBN+b1OvqT/QSoUQZv/ejIIMA/dhfZb9tdx0=;
	b=fTygB0x1qVdDpgUlzFHzCBNX8rT+mg5fs1CP4EoYkGMnrJrLlGhz40BCmD5Sk8IYf1AhAx
	2YzYY549epLBxIJTC9TFh7rqoAoIVBairU21KhSAiim6ZRu/qPQMLQERj62h68VNonn+wb
	Ajb9QdzQcnVzGpm0zywI96c7FNi8GTE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-ZkB5xVjdPYqJz0b5TJdG1A-1; Wed, 14 Aug 2024 04:45:03 -0400
X-MC-Unique: ZkB5xVjdPYqJz0b5TJdG1A-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-52efce218feso7905033e87.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 01:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723625102; x=1724229902;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hwkKCoOBN+b1OvqT/QSoUQZv/ejIIMA/dhfZb9tdx0=;
        b=H20lQn0QkVOl9CgvIuhp3mpq7PHnM2tfHMakTa2zAqDwNf/QMwYwS9k+TTzH232/Cj
         4jOMKUQBtlDNygNBDHIsvzwdMKHrfTpeM4PY5Yxv8HUsoN2mai5jhjVzRF+AXPZaxa4T
         LogLXhF06lRYoF1EwRNltsyxZtI/EvAjKOvM8wqnGVq1OL3AQv4HpkxrhEjfwnzXWg/J
         mnCuawmAV1DWSruG7aTbcuNArvPeVfp72VY7IkpIydS4ObvtlEtmldx2nKd7/L7h/6xD
         jZjcz6lHGoQTUAgx8+F3Zn8l4WtOu+SWhdiKmrvOrQPONUdy30LOYU8i8m3+saLLyEhW
         sK8A==
X-Gm-Message-State: AOJu0YzuGxqfaqnrKrwl3kKA5LlgOk2/JBJ2qlJmRbuKtqpHP0aUB325
	PzZYBGBbFMuPP8WRNc0JdoUdLufsM6a7CLO1J9mWM3V0/XNz+HulY3mf8Xeacd2QtGH9ce97oUA
	8lblIMg5CTmh8VxuBPJajkddfkvl9KTKef7Yu+tlFMbqTs2u7vA==
X-Received: by 2002:a05:6512:1388:b0:52e:7542:f471 with SMTP id 2adb3069b0e04-532eda83bd3mr1535837e87.29.1723625101821;
        Wed, 14 Aug 2024 01:45:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExvv2JH1bujn3OdzYrvDxJ3jmVSbA8zfxLsfLv8SXbL6vxyV/RWT5TFXZWT1E65o1HmeWJUQ==
X-Received: by 2002:a05:6512:1388:b0:52e:7542:f471 with SMTP id 2adb3069b0e04-532eda83bd3mr1535805e87.29.1723625101246;
        Wed, 14 Aug 2024 01:45:01 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4ebd2bb4sm12394742f8f.91.2024.08.14.01.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 01:45:00 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [BUG] arch/x86/kvm/vmx/vmx_onhyperv.h:109:36: error:
 dereference of NULL =?utf-8?B?4oCYMOKAmQ==?=
In-Reply-To: <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com>
 <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
 <87a5i05nqj.fsf@redhat.com>
 <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com>
Date: Wed, 14 Aug 2024 10:44:59 +0200
Message-ID: <87plqbfq7o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mirsad Todorovac <mtodorovac69@gmail.com> writes:

> On 7/29/24 15:31, Vitaly Kuznetsov wrote:
>> Mirsad Todorovac <mtodorovac69@gmail.com> writes:
>> 
>>> On 7/19/24 20:53, Sean Christopherson wrote:
>>>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
>>>>> Hi, all!
>>>>>
>>>>> Here is another potential NULL pointer dereference in kvm subsystem of linux
>>>>> stable vanilla 6.10, as GCC 12.3.0 complains.
>>>>>
>>>>> (Please don't throw stuff at me, I think this is the last one for today :-)
>>>>>
>>>>> arch/x86/include/asm/mshyperv.h
>>>>> -------------------------------
>>>>>   242 static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
>>>>>   243 {
>>>>>   244         if (!hv_vp_assist_page)
>>>>>   245                 return NULL;
>>>>>   246 
>>>>>   247         return hv_vp_assist_page[cpu];
>>>>>   248 }
>>>>>
>>>>> arch/x86/kvm/vmx/vmx_onhyperv.h
>>>>> -------------------------------
>>>>>   102 static inline void evmcs_load(u64 phys_addr)
>>>>>   103 {
>>>>>   104         struct hv_vp_assist_page *vp_ap =
>>>>>   105                 hv_get_vp_assist_page(smp_processor_id());
>>>>>   106 
>>>>>   107         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>>>>   108                 vp_ap->nested_control.features.directhypercall = 1;
>>>>>   109         vp_ap->current_nested_vmcs = phys_addr;
>>>>>   110         vp_ap->enlighten_vmentry = 1;
>>>>>   111 }
>>>>>
>> 
>> ...
>> 
>>>
>>> GCC 12.3.0 appears unaware of this fact that evmcs_load() cannot be called with hv_vp_assist_page() == NULL.
>>>
>>> This, for example, silences the warning and also hardens the code against the "impossible" situations:
>>>
>>> -------------------><------------------------------------------------------------------
>>> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
>>> index eb48153bfd73..8b0e3ffa7fc1 100644
>>> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
>>> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
>>> @@ -104,6 +104,11 @@ static inline void evmcs_load(u64 phys_addr)
>>>         struct hv_vp_assist_page *vp_ap =
>>>                 hv_get_vp_assist_page(smp_processor_id());
>>>  
>>> +       if (!vp_ap) {
>>> +               pr_warn("BUG: hy_get_vp_assist_page(%d) returned NULL.\n", smp_processor_id());
>>> +               return;
>>> +       }
>>> +
>>>         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>>>                 vp_ap->nested_control.features.directhypercall = 1;
>>>         vp_ap->current_nested_vmcs = phys_addr;
>> 
>> As Sean said, this does not seem to be possible today but I uderstand
>> why the compiler is not able to infer this. If we were to fix this, I'd
>> suggest we do something like "BUG_ON(!vp_ap)" (with a comment why)
>> instead of the suggested patch:
>
> That sounds awesome, but I really dare not poke into KVM stuff at my level. :-/
>

What I meant is something along these lines (untested):

diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
index eb48153bfd73..e2d8c67d0cad 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.h
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
@@ -104,6 +104,14 @@ static inline void evmcs_load(u64 phys_addr)
        struct hv_vp_assist_page *vp_ap =
                hv_get_vp_assist_page(smp_processor_id());
 
+       /*
+        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
+        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
+        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
+        * but compilers may still complain.
+        */
+       BUG_ON(!vp_ap);
+
        if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
                vp_ap->nested_control.features.directhypercall = 1;
        vp_ap->current_nested_vmcs = phys_addr;

the BUG_ON() will silence compiler warning as well as become a sentinel
for future code changes.

-- 
Vitaly


