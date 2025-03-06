Return-Path: <kvm+bounces-40260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 020CDA5517F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 262B016B5E8
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FC1233D9E;
	Thu,  6 Mar 2025 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y/L7qs1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3616F2206B1
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278946; cv=none; b=pOcYtZh4WVtq48yMdnnG/IYQgfBzIeVPOSZH51NfN6Ldct6IklPp/lK+CNJnUw+4W07pInj9t59XW8NQrw6PCaqUaTuwUMe1J7c65hqIoJ1zxmQAAEazuisd+kXVOMCFvke+orkaSsKOBlE+xGj49poKzL5my1p/XelzQMAgssY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278946; c=relaxed/simple;
	bh=PjsZy6pUh2IVS2HVuZ8PxRieG8UqIYLw57Zj3Hp+27M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iPhLDTtoHBYAwM8zmLKr8SM0C2NqyuGWBJtzZC5g2OwcMHeQD6geH7W+TTLFQHfR5Js67kKvj2gHsh7TSPek+NF+ZVOpsXwDWflcJpdBRywrUUYWQao+LFY6Xt67lfu+XkQxGRNtKX174WCdNRPGHWS7vArmaXNXfmKTV3wMNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y/L7qs1f; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2235189adaeso15451185ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741278944; x=1741883744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XAgfEPaoGHSZq07mbdjEXSxpSubJXrriPtuulftaiNs=;
        b=Y/L7qs1fYP9vQlvp2R8r4VSThhYRQr8VgszTdNLXrNKAFQqObNEoatewb5sYFA2sRH
         XD+3kcoE/OLO6MppP2AgkbyB+DKwDbmVgA4UMN7d/BW2pd+at3ZyMPDRlos8nniYog9L
         UJUKqkxcmce2oHTxjoUoF2k/RYNtFenHlCJMFvkieJPceDPEMxzXkDyYYjdAT4iF+80j
         u2NjRjCjR1hX/oiCiTR/84+70TmnxRn5JRECrFnaznkRXqaO5l6kDLMpOao3hjKPh9uN
         i/h6ktYCJa0fOX7w/P31ytGPFVBS79e97EuH97m+GjxJN5IwRaKBxLGmZqxNIcoAfYz/
         pIFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741278944; x=1741883744;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XAgfEPaoGHSZq07mbdjEXSxpSubJXrriPtuulftaiNs=;
        b=Mr1gApgdBNTgz1qhin08V7ir2o5g7RS3y/gT/nl6kCfMJ+ImDM2bFZb6zfsKu8PeE2
         +UWglPeTJ11A/2sYKjBDIWRwiBuriT1cuYjDr+hmQRawXefxVqy5heFRd/N++AGF1xhy
         nW2zMGUDCN2J/Hk6hAWmu/9h6XImsdOJ2q/mnBmffDpc41Xi9//HxBac2jXNDhchGtwc
         fg9ayHX2z0Xn2PQqkN2c1Nx+kTsct5sORDEFh9nvgQXnRGLD/ZLz18qCWCIuWPkIEWHw
         Eq4tMRrjbB0MVExI1tyPyEqDloEyC9+gOM4kZmeub7Fn9vcvMc+DHrWZ7Jl/5ndMpDeK
         pLgQ==
X-Gm-Message-State: AOJu0YzkWQzBbkA0gsrDlmv0c3WbK9Xhw6RjvweemLdsXbLHPhJCGrZ+
	M2dQXGY2aNAoJBdEeyLP3JJRc2CTnduD2aJzfe6IkaD9EHdjRvGKlV+M4VqZddE=
X-Gm-Gg: ASbGncujuhpl6Y7jtES8CnnsTX2bfhRLI1N7UJy+p1EVd4+rflYmQLnzZTdAacbUkRO
	MGbkae0T/NDt7+TQGgE9DszEop/T7qV0UXCtzW6g1mWHq8OpXUq96tK/rQkvx8JtSgz1fqoi4yy
	kVFw8eMUU5Y5gJXP4n3YcnKcQ+ufLm+jfrUqv06scgF6sfs27DhEZaktdPFBsdKEbJNjZZEwT8o
	MwJCK6nilW/stx3ROmSsIK7cxViS7DYsf+dC9w5bf6//TWBuBghgjC7WqM2oSs2l3GaYiuGDk2w
	iZo6IbiZb8oNpO5DN1lQNxOL90KDrpJaJ16zKiYY39PQO3MPrjSgO13eKQ==
X-Google-Smtp-Source: AGHT+IFEcsPPTb++NpYeNs25boDWH44SnjrXjA5LUkchp6XeuV57Gmop2Z0lHg35HUzrTyjL9tiNsw==
X-Received: by 2002:a17:902:e802:b0:221:89e6:ccb6 with SMTP id d9443c01a7336-22427071ce8mr2054765ad.25.1741278944389;
        Thu, 06 Mar 2025 08:35:44 -0800 (PST)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddbf2sm14609215ad.18.2025.03.06.08.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 08:35:43 -0800 (PST)
Message-ID: <9604ac56-4fff-40da-a95a-57bca9d88251@linaro.org>
Date: Thu, 6 Mar 2025 08:35:43 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] hw/hyperv: remove duplication compilation units
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, philmd@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, manos.pitsidianakis@linaro.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, alex.bennee@linaro.org
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
 <0226e9d5-edbc-417a-8cf0-8c752f52b7ed@linaro.org>
 <badcb867-64db-4b45-93b0-fd4ff203c35a@linaro.org>
In-Reply-To: <badcb867-64db-4b45-93b0-fd4ff203c35a@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/25 08:35, Pierrick Bouvier wrote:
> On 3/6/25 08:26, Richard Henderson wrote:
>> On 3/5/25 22:41, Pierrick Bouvier wrote:
>>> Work towards having a single binary, by removing duplicated object files.
>>>
>>> hw/hyperv/hyperv.c was excluded at this time, because it depends on target
>>> dependent symbols:
>>> - from system/kvm.h
>>>        - kvm_check_extension
>>>        - kvm_vm_ioctl
>>> - from exec/cpu-all.h | memory_ldst_phys.h.inc
>>>        - ldq_phys
>>>
>>> Pierrick Bouvier (7):
>>>      hw/hyperv/hv-balloon-stub: common compilation unit
>>>      hw/hyperv/hyperv.h: header cleanup
>>>      hw/hyperv/vmbus: common compilation unit
>>>      hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
>>>      hw/hyperv/syndbg: common compilation unit
>>>      hw/hyperv/balloon: common balloon compilation units
>>>      hw/hyperv/hyperv_testdev: common compilation unit
>>>
>>>     include/hw/hyperv/hyperv-proto.h | 12 ++++++++
>>>     include/hw/hyperv/hyperv.h       |  4 ++-
>>>     target/i386/kvm/hyperv-proto.h   | 12 --------
>>>     hw/hyperv/syndbg.c               |  7 +++--
>>>     hw/hyperv/vmbus.c                | 50 ++++++++++++++++----------------
>>>     hw/hyperv/meson.build            |  9 +++---
>>>     6 files changed, 49 insertions(+), 45 deletions(-)
>>>
>>
>> I'm reasonably certain that hyperv is specific to x86.
> 
> That's correct.
> 

But potentially could be extended to arm64 one day as well.

>> Are these only "duplicated" because of qemu-system-{i386,x86_64}?
>>
> 
> Yes. A lot of duplications in hw/ is related to 32/64bits variants.
> 
>>
>> r~
> 


