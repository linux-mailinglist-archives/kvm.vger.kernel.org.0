Return-Path: <kvm+bounces-7210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD37783E3B3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:11:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5DDE1C217DC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445C9249F0;
	Fri, 26 Jan 2024 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lcprd8Ap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6138717BCC
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706303488; cv=none; b=s9hzXKzJe8PLQEav6dVzh7w12UCAe8OJbmSe74ekITK5A8Jdbr4geS0KIUqp/AR9MLy/G0fBB/d8yP9fSvpOtokFRrXFG7CjEShG+DAgzg6qKfWm6BqOzi+0mNiyjGV3TPDGKQe5DAmS3FKl1zOpEK5lICoqdCo+zs3hvw/zQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706303488; c=relaxed/simple;
	bh=oeMGFSTsx6aIFKDjJ2qotWWszLxg77seC592pC0gMLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IwjgFs0yFE0DAs7JBGH525khitQwo6bCk8pkzkCwc+Qa+P3BboTBdvTMRivvh8OgEIgN0tyuwn3miczJpAW0a+CcnxCXZ6IhZeRqx5ag6+GdkaAhj707f4iaTDdjX3qq1cyvZnnTfYASoFAEIi5XRmj8Cr0Ia6qOcqpnr/U+3B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lcprd8Ap; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40ee418e7edso12407015e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 13:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706303475; x=1706908275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vxYwthXZn31ySjM2DeVKX29v0Ws6VePUGUeM9gtZWoA=;
        b=lcprd8Ap7fHwdbhzz1caQ9bGQQZE3NWHZEGEPyfBsvg8cK9wSpfDGkRelDk59tEItG
         kSzZIj23sbeRQZ9lgrp4s/Iw7ldxPhTp7mdotyBbgJ63cAdO3GKRQ+I1IdMbWpVmnSNu
         S2GGc1MMtnKmTEyh7lpIs7KH3bW9tA4MR7LW4QDZm/z3egIdXPYzCHY8pEhbC9kexhBe
         T0fajJX3qPTvDkMeEOLt4P4jFgWfM6p7XavWvlizNrhS4jovTRPqMqKHNwVQWuwdSiRp
         74AyTwGULTsg/NIdLVvZFNk4bK8EiMQaXhUYCzOSAA50GroRikdJn6l5V3kVaS9WdIsT
         GaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706303475; x=1706908275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vxYwthXZn31ySjM2DeVKX29v0Ws6VePUGUeM9gtZWoA=;
        b=LwQHXV3ZcD+x10muwQtYeQMzXGZi+DsZ95XyZXYABeoxFQb6rWDnW6JCPoDnpzT6uZ
         T2axNTZcnhAce9WtJKD/UsIQUfnsj+LkBn0x1AXaZf0v9FvwQo3Nsb82l7btvO9M0Vdu
         KAbbU3drup0DfzWklY3XK6tfZoR0JmoRrXpRPAqoW3og1xXeT5pPicW6NJCpQOqmAPpo
         U7MPnRLzXJIcc4rFF+tAjnOFYvMO6eomdqAekxBPoVniEdlsJfrLv1DToiDCN67alwAW
         6VlEW5wfYdqmcrsPzJFINIZKqy+4qPyBvjZfEbOU4Y3QTZDkm9HPavugPDCNr5GFT6PG
         3CFQ==
X-Gm-Message-State: AOJu0Yy03Kg/SCzPndbeCewP/v72givGdJj1dovuTVBR72N/LYAQqghN
	up+d7m9NSIArz8FUcoLMHqW396TKI6/DXEU6hdNfxeZfuyICecq4HH8qVrz8PTw=
X-Google-Smtp-Source: AGHT+IHPfVDNkHfFEZ920e1AvtHAgCTjycghkqkwfmMNm/uoHYkWmbEXdBjZ/pk1I5xFKz0+SjDwuw==
X-Received: by 2002:a05:600c:4ca7:b0:40e:5534:728c with SMTP id g39-20020a05600c4ca700b0040e5534728cmr286415wmp.136.1706303475465;
        Fri, 26 Jan 2024 13:11:15 -0800 (PST)
Received: from [192.168.69.100] ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id a5-20020a05600c348500b0040e48abec33sm6615547wmq.45.2024.01.26.13.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 13:11:15 -0800 (PST)
Message-ID: <c4c07c69-11c6-4883-8ff8-1e5ec627d9bc@linaro.org>
Date: Fri, 26 Jan 2024 22:11:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bulk: Prefer fast cpu_env() over slower CPU QOM cast
 macro
Content-Language: en-US
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-s390x@nongnu.org,
 qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>, Paul Durrant <paul@xen.org>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Nicholas Piggin <npiggin@gmail.com>, =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?=
 <fbarrat@linux.ibm.com>, Daniel Henrique Barboza <danielhb413@gmail.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Alexander Graf
 <agraf@csgraf.de>, Michael Rolnik <mrolnik@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Laurent Vivier <laurent@vivier.eu>,
 Aurelien Jarno <aurelien@aurel32.net>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>, Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 Huacai Chen <chenhuacai@kernel.org>, Chris Wulff <crwulff@gmail.com>,
 Marek Vasut <marex@denx.de>, Stafford Horne <shorne@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bin.meng@windriver.com>, Weiwei Li <liwei1518@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 David Hildenbrand <david@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Artyom Tarasenko <atar4qemu@gmail.com>,
 Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
 Max Filippov <jcmvbkbc@gmail.com>, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org
References: <20240125165648.49898-1-philmd@linaro.org>
 <20240125165648.49898-3-philmd@linaro.org>
 <135941df-2f8b-4fd5-91c7-40b413e6eae3@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <135941df-2f8b-4fd5-91c7-40b413e6eae3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/1/24 18:09, Thomas Huth wrote:
> On 25/01/2024 17.56, Philippe Mathieu-Daudé wrote:
>> Mechanical patch produced running the command documented
>> in scripts/coccinelle/cpu_env.cocci_template header.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---

>>   114 files changed, 273 insertions(+), 548 deletions(-)
> 
> A huge patch ... I wonder whether it would make sense to split it up by 
> target architecture to ease the review?
> 
> ...
>> diff --git a/hw/i386/vmmouse.c b/hw/i386/vmmouse.c
>> index a8d014d09a..eb0613bfbe 100644
>> --- a/hw/i386/vmmouse.c
>> +++ b/hw/i386/vmmouse.c
>> @@ -74,8 +74,7 @@ struct VMMouseState {
>>   static void vmmouse_get_data(uint32_t *data)
>>   {
>> -    X86CPU *cpu = X86_CPU(current_cpu);
>> -    CPUX86State *env = &cpu->env;
>> +    CPUX86State *env = cpu_env(CPU(current_cpu));
> 
> No need for the CPU() cast here, current_cpu is already
> of type "CPUState *".

Yes, Paolo noticed and I fixed for v2.

> I'll stop here, please respin with the cpu_env(CPU(current_cpu)) fixed to
> cpu_env(current_cpu), and please split the patch by target CPU types.

Well I don't know, this is an reproducible mechanical patch..
But indeed as Paolo you found an optimization so worth not making
human review a pain.

I was about to post v2 but I'll see how to split.

Thanks for the review!

Phil.

