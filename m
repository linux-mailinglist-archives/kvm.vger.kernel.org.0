Return-Path: <kvm+bounces-50288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C60EBAE38EA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 10:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82FA816E1ED
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 08:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB0B622FDFF;
	Mon, 23 Jun 2025 08:49:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAB322DFB5;
	Mon, 23 Jun 2025 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750668540; cv=none; b=CLLTYQc+aMnh/1/BPN26171JDT8JXll93vwqE0sLm1nIRt87WbhCw/YBsyCyayttHb+56zYwr8k4u80jHplSS85dD0VCEGOpRsQspC5wc5PbcwmGMlkgk5LzqZLOxeHEgL7ZgidoQuui9Z9xUACNJ4USUrk6ari2fYUD3ChIqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750668540; c=relaxed/simple;
	bh=C9SOOGoa6Xk+PFkOm1w1yIEgDP8716caW/HXobeuvNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZ6zttBAmkTonmebhcsqsWE6c4lwKChF3sp41OuYmY8De19Ox82x84IXtrTSyf27FRGYlcGeGJprIK2G7rUT3udm4A6+q832ritJlkX+8Qv7uuRE/6M3rCVM3ayWSMI5JsPydpNHyjZrhRtm2wmlxy3EMDSBZmKsKtt1X1pYAzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id A60C943210;
	Mon, 23 Jun 2025 08:48:44 +0000 (UTC)
Message-ID: <1ebde39e-f5b4-4f8c-a0df-f53cce67f4ef@ghiti.fr>
Date: Mon, 23 Jun 2025 10:48:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] Move duplicated instructions macros into
 asm/insn.h
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Andrew Jones <ajones@ventanamicro.com>
References: <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
 <c12729a1-5046-4821-b5fe-5fea72af76c8@rivosinc.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <c12729a1-5046-4821-b5fe-5fea72af76c8@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddvgdduieehjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhepudffueegvddtgeeluefhueetteeugeeffeekhfehffdvudfhgedvheduudekffegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpihhnfhhrrgguvggrugdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmedvieeijeemvgejvgdtmeehudeltdemfhgvtdehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmedvieeijeemvgejvgdtmeehudeltdemfhgvtdehpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmedvieeijeemvgejvgdtmeehudeltdemfhgvtdehngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopedufedprhgtphhtthhopegtlhgvghgvrhesrhhivhhoshhinhgtrdgtohhmpdhrtghpthhtoheprghlvgigghhhihhtihesrhhivhhoshhinhgtr
 dgtohhmpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhivhgvrdgtohhmpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegrnhhuphessghrrghinhhfrghulhhtrdhorhhgpdhrtghpthhtoheprghtihhshhdrphgrthhrrgeslhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
X-GND-Sasl: alex@ghiti.fr


On 6/23/25 10:07, Clément Léger wrote:
>
> On 20/06/2025 22:21, Alexandre Ghiti wrote:
>> The instructions parsing macros were duplicated and one of them had different
>> implementations, which is error prone.
>>
>> So let's consolidate those macros in asm/insn.h.
>>
>> v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
>> v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
>> v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/
>> v4: https://lore.kernel.org/linux-riscv/20250516140805.282770-1-alexghiti@rivosinc.com/
>>
>> Changes in v5:
>> - Rebase on top of 6.16-rc1
>>
>> Changes in v4:
>> - Rebase on top of for-next (on top of 6.15-rc6)
>>
>> Changes in v3:
>> - Fix patch 2 which caused build failures (linux riscv bot), but the
>>    patchset is exactly the same as v2
>>
>> Changes in v2:
>> - Rebase on top of 6.15-rc5
>> - Add RB tags
>> - Define RV_X() using RV_X_mask() (Clément)
>> - Remove unused defines (Clément)
>> - Fix tabulations (Drew)
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>> ---
>> Alexandre Ghiti (3):
>>        riscv: Fix typo EXRACT -> EXTRACT
>>        riscv: Strengthen duplicate and inconsistent definition of RV_X()
>>        riscv: Move all duplicate insn parsing macros into asm/insn.h
>>
>>   arch/riscv/include/asm/insn.h          | 206 +++++++++++++++++++++++++++++----
>>   arch/riscv/kernel/machine_kexec_file.c |   2 +-
>>   arch/riscv/kernel/traps_misaligned.c   | 144 +----------------------
>>   arch/riscv/kernel/vector.c             |   2 +-
>>   arch/riscv/kvm/vcpu_insn.c             | 128 +-------------------
>>   5 files changed, 188 insertions(+), 294 deletions(-)
>> ---
>> base-commit: 731e998c429974cb141a049c1347a9cab444e44c
>> change-id: 20250620-dev-alex-insn_duplicate_v5_manual-2c23191c30fb
>>
>> Best regards,
> Hi Alex,
>
> I already gave my Reviewed-by for the last two commits of this series in V4.


Sorry, I'll add them when I merge this patchset.

Thanks,

Alex


> Thanks,
>
> Clément
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

