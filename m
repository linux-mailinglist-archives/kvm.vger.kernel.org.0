Return-Path: <kvm+bounces-34675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A08F7A03F7F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 13:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0882B3A1A8E
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 12:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D351E885C;
	Tue,  7 Jan 2025 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B8zGD0lw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D92E6136
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736253717; cv=none; b=c9Ain41dMM6ElBKySb6RTO3YrNnmcWBBs6qwGBv3Ev6BLYF/uQm1EV/Osm/e84caNzrcMoFEOGUKz+owBJs3jcTKwyeeUYuSVluKCKOEL89w3YSoZX8OZl2M7Mu39ttvPKwgLQU/jQ1IFPIDsS/tni2dHvgqtL9Bg3ojh+SxZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736253717; c=relaxed/simple;
	bh=VaPSil/xFUZKZBdrr/UMv3gfLn36VxEgu6ey8vlPX8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s82vu3cGfI2SYWrpPomQvm4cITln87X0Rt34TZwO0Mb2aGOyUh/KQxgXRD72XhsBsRzes1YC00GP7M6Dp5ontdBL3Q+jJQnOD0i0xQSQcUFq/KXQos2l7sLMTyczMKsnpyI81ADI84DAMcy3ZlzbviteOTI6iBof5GHOzJ5lTCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B8zGD0lw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-436202dd7f6so175501065e9.0
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 04:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736253713; x=1736858513; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DtLfX1vfHpElmPmkOd6B6Z2Dl4xWa+S6C0xYlZKfN7c=;
        b=B8zGD0lwMVjNPBFqjYRkZ4K5eRTU42oCEwRENiCJYvYvpwbsQK5LdptHAEVuV4EKrR
         Vj77wm9IR3apKZbsx54OCr9rVyi2brfnO5zqiKusG9J1oaAXgFVKk0WGwsZUH+n1hT2m
         7T4+wL4LI+/WCXydoIPZtlA/4hyfrrLB1bkohW27X5LsYQhBGY+7QxvTbQ50mqK1QmM5
         F11oAA+TkKv/RQeri9JYdQTUx9wOtn5sbu/fiykrCBK+kFJUMoUp9iPf1PbD/vzASsuV
         6Ns2Vy4Vg32ZTGIyU1lJQve1tWn7CZOT4SBmA/muXg8BbzWNftOC0ldDLr+gRlrzppjB
         RrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736253713; x=1736858513;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtLfX1vfHpElmPmkOd6B6Z2Dl4xWa+S6C0xYlZKfN7c=;
        b=rPe4ECyY9ZjvNu8rh9EGz0CZugFAeffuxjWXrRqHNutxSMqephg4Z2gqL+0NtDxFfJ
         AluSCzdARYckBJCIbFEolgUxGCjF8yPoAUZWGlH0eZ1eQQViEsnikAVEMaIP4krklMGF
         5t3PSl3tWo24fB3D9KKRn627ZGE04NNtA7u7NMtN3DhieUase2IcbcDJ2XTvHuf9Uo3x
         6WO5Uemonv3ureUjc5ss/orTf627iDnKMqbKG5cbZkssBogtYXmdDGrG+x5JAewMjykR
         6uErs4pQndvvAY1y5nXQ+ZvfmoAoIoKQW3UP0FkRvBu4Hw4bu5hFDei+GYUATAOMr66J
         u3gw==
X-Forwarded-Encrypted: i=1; AJvYcCWJblPbqh6pQBCJT4fTB8k89pRuGiPTttyfqyAlnOJnbQJAQf4apPcsuj71t9SX/IShfr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsKTHzgKrQik9gWRusXsPlVR4a5jBPjI+Gju5yHACCPDWWSOXj
	6vqRG5neyhN/DqBXyY8jlT9nFU3CRsJEBBC/ygR9C5sjhM9Ug0Rt/zQTBM8ZfhI=
X-Gm-Gg: ASbGncvsVYRt2YmucAqmSkU3epKGZePL7ROGhXyduB0hxaooDYYuOH/rmcnWgtXEnup
	KI+KQWwy0MxBp6akx8Xv1ujYreeGhO01SrSUQglRsF1RVfZolfr1cu8slQXfaLDsdLtQwtiEfsP
	I+aWj7i0qHkCfpaZWBz97TCjghlXfot6bFsBZQU2BBv+m3KdmABZ7RmHQB3TrZkg1ueEN0sBCKX
	DTwYhfJo5gPTC6BaBW8gdA/x5RzO6gv9jNYNc4nkwpowSqPoP9RW1rXmAogjA==
X-Google-Smtp-Source: AGHT+IEKVFWofdmR779GCffISYCKUDYqpt0f5REtBvJSH6t3eLDJHz6L2x61Od8gTltEX7suLqOfbQ==
X-Received: by 2002:a05:600c:310a:b0:434:fddf:5bfa with SMTP id 5b1f17b1804b1-4366854bfc0mr481439425e9.2.1736253712740;
        Tue, 07 Jan 2025 04:41:52 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b00cf6sm638967985e9.10.2025.01.07.04.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 04:41:52 -0800 (PST)
Message-ID: <7f8d0beb-cc02-467d-ae2a-10e22571e5cf@suse.com>
Date: Tue, 7 Jan 2025 14:41:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
To: Tony Lindgren <tony.lindgren@linux.intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
 <Z3zZw2jYII2uhoFx@tlindgre-MOBL1>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <Z3zZw2jYII2uhoFx@tlindgre-MOBL1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7.01.25 г. 9:37 ч., Tony Lindgren wrote:
> On Sat, Jan 04, 2025 at 01:43:56AM +0000, Edgecombe, Rick P wrote:
>> On Mon, 2024-12-23 at 17:25 +0100, Paolo Bonzini wrote:
>>> 22: missing review comment from v1
>>>
>>>> +     /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
>>>> +     if (!vcpu->arch.apic)
>>>> +             return -EINVAL;
>>>
>>> nit: Use kvm_apic_present()
>>
>> Oops, nice catch.
> 
> Sorry this fell through. I made a patch for this earlier but missed it
> while rebasing to a later dev branch and never sent it.
> 
> Below is a rebased version against the current KVM CoCo queue to fold
> in if still needed. Sounds like this might be already dealt with in
> Paolo's upcoming CoCo queue branch though.
> 
> Regards,
> 
> Tony
> 
> 8< --------------------
>  From aac264e9923c15522baf9ae765b1d58165c24523 Mon Sep 17 00:00:00 2001
> From: Tony Lindgren <tony.lindgren@linux.intel.com>
> Date: Mon, 2 Sep 2024 13:52:20 +0300
> Subject: [PATCH 1/1] KVM/TDX: Use kvm_apic_present() in tdx_vcpu_create()
> 
> Use kvm_apic_present() in tdx_vcpu_create(). We need to now export
> apic_hw_disabled for kvm-intel to use it.
> 
> Suggested-by: Nikolay Borisov <nik.borisov@suse.com>
> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> ---
>   arch/x86/kvm/lapic.c   | 2 ++
>   arch/x86/kvm/vmx/tdx.c | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index fcf3a8907196..2b83092eace2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -139,6 +139,8 @@ __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>   EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
>   
>   __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> +EXPORT_SYMBOL_GPL(apic_hw_disabled);

Is it really required to expose this symbol? apic_hw_disabled is defined 
as static inline in the header?

 > +>   __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, 
HZ);
>   
>   static inline int apic_enabled(struct kvm_lapic *apic)
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d0dc3200fa37..6c68567d964d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -8,6 +8,7 @@
>   #include "capabilities.h"
>   #include "mmu.h"
>   #include "x86_ops.h"
> +#include "lapic.h"
>   #include "tdx.h"
>   #include "vmx.h"
>   #include "mmu/spte.h"
> @@ -674,7 +675,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   		return -EIO;
>   
>   	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> -	if (!vcpu->arch.apic)
> +	if (!kvm_apic_present(vcpu))
>   		return -EINVAL;
>   
>   	fpstate_set_confidential(&vcpu->arch.guest_fpu);


