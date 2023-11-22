Return-Path: <kvm+bounces-2266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F207F433A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41101281457
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE42C21A10;
	Wed, 22 Nov 2023 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZJHztzK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784B7100;
	Wed, 22 Nov 2023 02:07:04 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507bd19eac8so8632762e87.0;
        Wed, 22 Nov 2023 02:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700647623; x=1701252423; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R0+XfKuM9Y0ZNl5hDp6sO3vLEtpG295qVGbb4kQD/kE=;
        b=TZJHztzKokU2AJsd1GrGAHt82/OlV6Ehu7bDj0cFGR7iQt8TTUE/4cvv4XXqVI/MG9
         O5KPdXOwblQihcgWOIR/XpY7BsWH1czzzN7jGBpNdqV1pAfD8eTgxb/RhiShZb3OOBci
         9w6AcqQLRGopigKCDfd310r6xuq4ljBfgF+Ma20JhxqaLR4CmGQvyqakT9je0I27o7Ar
         H7rXSVQT3vgbwrX8ycV0TQcK3jO4iuW5Asu+m6cGVJpZDwix+eLw3nexbs4PaAuyOrbH
         uu9C0DqT8IS8XBdsSjOe5v/rkzKml671gOBVrA38DqEM+aphDICWALO/CAmMyhFHYSr+
         i/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700647623; x=1701252423;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0+XfKuM9Y0ZNl5hDp6sO3vLEtpG295qVGbb4kQD/kE=;
        b=FUjK7fL8+W7CuvdoP/EaPg2L8ZgUwGyT4w78ZUuOwQzNISrVfbtBLRykVPWa0ySfTh
         5NO8qscP1YoVbaqRA4hSSnjPCmjK5HRE3P+t41g5106c40r8DqHNuqJ80CO9tiGEhL4Y
         P3Sy6iIAJtgfe10KwIDaSUu45yEw2X1CHkS8Aqw49b5ZccVttMsqdUIN/EiYr3rPR1Vs
         BCVADijH9hhqHPt+cDTJWr81B5+dlUW+GdUL6bx8ZHI+ID7qeI7zCWpbV+4VrsABdnAi
         znMaKfTYRNnQswO0bnbgTtAsYlughbe27R7ULlyPx6eUU0w/WkX9lWpgj+yTIbApLf/E
         Wegg==
X-Gm-Message-State: AOJu0YxCnibB57vx8bBZEsui6WbwbI5wHP6hsJJHkWjQTlMbdV/scZDF
	Dq+woBy6VrVh5nMMzM0N1uU=
X-Google-Smtp-Source: AGHT+IFkDwjlMfSKlUr9YgNxElddYa6sPr9m+mc6ZuFXAoZcBTuttiiSXwheDeifmxdNw6IBTp1+8Q==
X-Received: by 2002:ac2:5ec2:0:b0:503:2623:7cfa with SMTP id d2-20020ac25ec2000000b0050326237cfamr1009610lfq.35.1700647622328;
        Wed, 22 Nov 2023 02:07:02 -0800 (PST)
Received: from [10.95.134.92] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id p9-20020a5d6389000000b00332cc3e0817sm5510256wru.39.2023.11.22.02.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 02:07:02 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <5e0e13ea-3eee-41bd-a070-e7bd9ed5d2e9@xen.org>
Date: Wed, 22 Nov 2023 10:07:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v8 08/15] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231121180223.12484-1-paul@xen.org>
 <20231121180223.12484-9-paul@xen.org>
 <ec89ab12288426761ab5bd7d05562a4e8834e5f1.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <ec89ab12288426761ab5bd7d05562a4e8834e5f1.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/2023 22:47, David Woodhouse wrote:
> On Tue, 2023-11-21 at 18:02 +0000, Paul Durrant wrote:
>>
>> -static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>> +static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, u64 addr, bool addr_is_gpa,
>>                               unsigned long len)
>>   {
>>          struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
>> -       unsigned long page_offset = offset_in_page(gpa);
>> +       unsigned long page_offset = offset_in_page(addr);
>>          bool unmap_old = false;
>>          kvm_pfn_t old_pfn;
>>          bool hva_change = false;
>> @@ -244,12 +244,21 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
>>          old_pfn = gpc->pfn;
>>          old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
>>   
>> -       /* If the userspace HVA is invalid, refresh that first */
>> -       if (gpc->gpa != gpa || gpc->generation != slots->generation ||
>> -           kvm_is_error_hva(gpc->uhva)) {
>> -               gfn_t gfn = gpa_to_gfn(gpa);
>> +       if (!addr_is_gpa) {
>> +               gpc->gpa = KVM_XEN_INVALID_GPA;
>> +               gpc->uhva = PAGE_ALIGN_DOWN(gpc->uhva);
>> +               addr = PAGE_ALIGN_DOWN(addr);
>> +
>> +               if (gpc->uhva != addr) {
>> +                       gpc->uhva = addr;
>> +                       hva_change = true;
>> +               }
>> +       } else if (gpc->gpa != addr ||
>> +                  gpc->generation != slots->generation ||
>> +                  kvm_is_error_hva(gpc->uhva)) {
>> +               gfn_t gfn = gpa_to_gfn(addr);
>>   
>> -               gpc->gpa = gpa;
>> +               gpc->gpa = addr;
>>                  gpc->generation = slots->generation;
>>                  gpc->memslot = __gfn_to_memslot(slots, gfn);
>>                  gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
> 
> Hrm, now that a previous patch means we're preserving the low bits of
> gpc->uhva surely you don't *need* to mess with the gpc struct?
> 

I'm not messing with it, am I?

> If gpc->gpa == KVM_XEN_INVALID_GPA (but gpc->uhva != KVM_ERR_ERR_BAD &&
> gpc->active) surely that's enough to signal that gpc->uhva is canonical
> and doesn't need to be looked up from the GPA?
> 
> And I think that means the 'bool addr_is_gpa' argument can go away from
> __kvm_gpc_refresh(); you can set it up in {__,}kvm_gpc_activate*()
> instead?

Alas not... __kvm_gpc_refresh() still needs to know *something* has 
changed, otherwise the khva will be stale.

   Paul



