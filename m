Return-Path: <kvm+bounces-20214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE80911E49
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:15:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53CE61F21177
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C623416D9D1;
	Fri, 21 Jun 2024 08:08:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EFB16D9B9;
	Fri, 21 Jun 2024 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718957305; cv=none; b=c3UB/hEibUecBz6l0+sZXHvjr2RtUSV9veX8H2mR3t1uVTXyPTARE/OvF7iyY/55baN3vzndlF04gxCC41Et79scHH45ktTXPEO9/LGpMgTDOU57kJhKik/VyF5ifqX5g/7DRSkYFGGnhZI02nOEmRRIPxAe2pODGIqhy22MCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718957305; c=relaxed/simple;
	bh=s/eg7PPI3tkjEc3HqJCdmDkCsHvLK7SBk3JKr5vz/dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFH4L1UKMIleWfu/GDkXL9P39gXqcQu0qwYkqt4s/AVq99R0rTwR7/8JNR0O31k3TJR2RYBGc3gciUOjJuDhhD7WLAu8PZ/dK45qv5qtEAnpFu95w5q8KXGii9tXgRpE5vl3bLnPvcCkpWCH7X56ipV9knvR42g0GKSOC2lbnuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 43368C0004;
	Fri, 21 Jun 2024 08:08:04 +0000 (UTC)
Message-ID: <ed87b4d8-1a74-4d9a-9beb-296db1f12043@ghiti.fr>
Date: Fri, 21 Jun 2024 10:06:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, apatel@ventanamicro.com, ajones@ventanamicro.com,
 greentime.hu@sifive.com, vincent.chen@sifive.com,
 Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>,
 Samuel Ortiz <sameo@rivosinc.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?=
 <cleger@rivosinc.com>, Evan Green <evan@rivosinc.com>,
 Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Jisheng Zhang <jszhang@kernel.org>, Charlie Jenkins <charlie@rivosinc.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Leonardo Bras <leobras@redhat.com>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <09f427cd-74ad-4aa5-81b1-995af2b6e1d1@ghiti.fr>
 <20240621-enchanted-unfasten-6d71b1ecd791@wendy>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240621-enchanted-unfasten-6d71b1ecd791@wendy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Conor,

On 21/06/2024 10:01, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 09:52:01AM +0200, Alexandre Ghiti wrote:
>> On 05/06/2024 14:15, Yong-Xuan Wang wrote:
>>> Svade and Svadu extensions represent two schemes for managing the PTE A/D
>>> +/*
>>> + * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
>>> + * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
>>> + * DT.
>>> + */
>>> +#define arch_has_hw_pte_young arch_has_hw_pte_young
>>> +static inline bool arch_has_hw_pte_young(void)
>>> +{
>>> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU) &&
>>> +	       !riscv_has_extension_likely(RISCV_ISA_EXT_SVADE);
>>> +}
>>
>> AFAIK, the riscv_has_extension_*() macros will use the content of the
>> riscv,isa string. So this works fine for now with the description you
>> provided in the cover letter, as long as we don't have the FWFT SBI
>> extension. I'm wondering if we should not make sure it works when FWFT lands
>> because I'm pretty sure we will forget about this.
>>
>> So I think we should check the availability of SBI FWFT and use some global
>> variable that tells if svadu is enabled or not instead of this check.
> No. If FWFT stuff arrives, it should be plumbed into exactly the same
> interface. "Users" should not have to think about where the extension is
> probed from and be able to use the same interface regardless.
>
> The interfaces we have have already caused some confusion, we should not
> make them worse.


Understood, we need to keep that in mind then.


>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

