Return-Path: <kvm+bounces-5635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A38824050
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1211286B7A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08231210F6;
	Thu,  4 Jan 2024 11:08:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B629720DDF;
	Thu,  4 Jan 2024 11:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: from relay2-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::222])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id 29B06C3F28;
	Thu,  4 Jan 2024 11:08:03 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPSA id A524C40009;
	Thu,  4 Jan 2024 11:07:51 +0000 (UTC)
Message-ID: <752c11ea-7172-40ff-a821-c78aeb6c5518@ghiti.fr>
Date: Thu, 4 Jan 2024 12:07:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Require HAVE_KVM
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>, linux-riscv@lists.infradead.org,
 linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 anup@brainfault.org, atishp@atishpatra.org, rdunlap@infradead.org,
 sfr@canb.auug.org.au, mpe@ellerman.id.au, npiggin@gmail.com,
 linuxppc-dev@lists.ozlabs.org
References: <20240104104307.16019-2-ajones@ventanamicro.com>
 <20240104-d5ebb072b91a6f7abbb2ac76@orel>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240104-d5ebb072b91a6f7abbb2ac76@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

On 04/01/2024 11:52, Andrew Jones wrote:
> This applies to linux-next, but I forgot to append -next to the PATCH
> prefix.


Shoudn't this go to -fixes instead? With a Fixes tag?


>
> On Thu, Jan 04, 2024 at 11:43:08AM +0100, Andrew Jones wrote:
>> KVM requires EVENTFD, which is selected by HAVE_KVM. Other KVM
>> supporting architectures select HAVE_KVM and then their KVM
>> Kconfigs ensure its there with a depends on HAVE_KVM. Make RISCV
>> consistent with that approach which fixes configs which have KVM
>> but not EVENTFD, as was discovered with a randconfig test.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Closes: https://lore.kernel.org/all/44907c6b-c5bd-4e4a-a921-e4d3825539d8@infradead.org/
> I think powerpc may need a patch like this as well, since I don't see
> anything ensuring EVENTFD is selected for it anymore either.
>
> Thanks,
> drew
>
>> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
>> ---
>>   arch/riscv/Kconfig     | 1 +
>>   arch/riscv/kvm/Kconfig | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index a935a5f736b9..daba06a3b76f 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -128,6 +128,7 @@ config RISCV
>>   	select HAVE_KPROBES if !XIP_KERNEL
>>   	select HAVE_KPROBES_ON_FTRACE if !XIP_KERNEL
>>   	select HAVE_KRETPROBES if !XIP_KERNEL
>> +	select HAVE_KVM
>>   	# https://github.com/ClangBuiltLinux/linux/issues/1881
>>   	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !LD_IS_LLD
>>   	select HAVE_MOVE_PMD
>> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
>> index 1fd76aee3b71..36fa8ec9e5ba 100644
>> --- a/arch/riscv/kvm/Kconfig
>> +++ b/arch/riscv/kvm/Kconfig
>> @@ -19,7 +19,7 @@ if VIRTUALIZATION
>>   
>>   config KVM
>>   	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
>> -	depends on RISCV_SBI && MMU
>> +	depends on HAVE_KVM && RISCV_SBI && MMU
>>   	select HAVE_KVM_IRQCHIP
>>   	select HAVE_KVM_IRQ_ROUTING
>>   	select HAVE_KVM_MSI
>> -- 
>> 2.43.0
>>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

