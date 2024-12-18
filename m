Return-Path: <kvm+bounces-34087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C6529F707B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 00:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F29DB163788
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 23:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9A01FC7E2;
	Wed, 18 Dec 2024 23:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="GhPcx1mx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E981517A586
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 23:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734563174; cv=none; b=R5b2V565CnDxcF9Q992kpMoo8fNpSrhQqK5bMdO5wsDaABLaPI6rYtzW8WvD58M4WC7Srik/wewZRWtG6ms+psbnzczo0xoELNHxbWQljs0I4JOqCbPyWxmV7Q9ObCW9Mocw6X7XPxWDJoueabul36EO2v3uYUw3KBiKEi929+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734563174; c=relaxed/simple;
	bh=fRe8ZcT8Qv2LG2jmF50fLPy1C0nzpFNglHQAfcyWYvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyYLcI3DhgkOhmRixah4zEZmCdnFspuUumNe9qtScyjrvjN6NJLaX1X2Ea/iD2RUuAMo1fuXpDaf1d0xS1GQOqvhufwNosw38kpCOj0duzRprXtM+EJCaLhAKxpc/y3B/jRE6uEWaFXQWnXQ7WyDD35HxpWthtgfwQw4A/b4cZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=GhPcx1mx; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-844eac51429so14106939f.2
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 15:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1734563172; x=1735167972; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NdX+lP1p9saWFa7UrS9rJ2NBXojnnsTry5fzeCGF/rE=;
        b=GhPcx1mx7EFTygmZKpeVOweAACr6SgoXQvHlusQIKbpayVoayZVF8hR9fvRE7z/o2y
         SCR1M0NsA+dP9ZZ6WYwwt5p3MQ/6HEnd1R39/+jJr4mNGsmuIBJb7VDDvRu4rKAEKj2t
         3bN21cBdV4gcOmdnSdPFyV/PIVD4KVQ2Affecwo4SC1QbIHZQ9wcnuyCTEMy969QfKiP
         iugxMtNN03HP4HR5AdfpKxFX4i8XsbPmklxNnRjQoCjwVtnJDFrnxA8XQl4T//vSMLs+
         wb6kynNRftRv9ss619c/y5G+5taViklqedReh2c2eE56joTispzIdp+iw8lyjmccP2Sp
         +FTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734563172; x=1735167972;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NdX+lP1p9saWFa7UrS9rJ2NBXojnnsTry5fzeCGF/rE=;
        b=bEfbalh7WeRlep018mSU2Fv5LnZtX/tOWQlfZx/tlpk5jNnuq6fZb/M+QyFure5geZ
         8RkqE4vx6slPLtTZ60p8DUyYKybixH3KpVYnwvC49MKH8JRvd0k+cP71wxC2hsH8Ow2r
         yKTdneYQemOeJ6IODKpSOqWxuCE0v99g3lPd41U4NRJRubphP/N9xJcEHW+pwOJgKjDV
         /wwdt8/DcaP4JebGxfCdzEd9MNPnDDF/aIWKKbRQNdHYvDn2EIGsu3D2yO8404xqxwB6
         qgRsSJBGP85mkUzPoVYvp5xgZZwkdQIYK6+CUzVOVUlNtCwA9Aa7vT0URJnFXBj5xDwZ
         YHpw==
X-Gm-Message-State: AOJu0Yyp65dyQufG/90NA+A7ByX/031ko+eiTvY/Q07HT/35w+HElTwG
	GCDRMwxZA7Y5fqbAecXhA9tWbxUd0PPaZBEtK8lVuouVSlEBnDKK+x9Z4EeEHUYq/Ar5lw7phXa
	b
X-Gm-Gg: ASbGncsxbVcghAGqgcRSYj9tIhRRbgU+0UeTzMAx35frYzUvMpc10wkQ35EgHJxFO4N
	ctacRsVt1UTv0KBoIb6N0/HxQcWMSIXDJJBqZtSgp7vnTWAGOPG3eJe8MrBvbap04yt45pLGi6/
	tPPI17jGDxgBJZ8HUkcYbkJ6iK/gGQq3OZTSGyYGUjr06zhJbBkN7rZOdSSvoY2rQDMbOjoOKuM
	j0UZoT54hgWuVgPH0zPFaDjdKrwPzI1b1lt/3M6zm4ZJiMMgij8OzgMNC3e//plNd0zQFO+7DRx
X-Google-Smtp-Source: AGHT+IH2MJrI/IZ2LqRS3AkIyRb4htj83tDMNdH6z9h7/1tTIbMjHX77aIB4Or4PMEhUoD0sg3k/Ww==
X-Received: by 2002:a05:6602:14d1:b0:843:f220:fa3d with SMTP id ca18e2360f4ac-84758551095mr488370739f.7.1734563172084;
        Wed, 18 Dec 2024 15:06:12 -0800 (PST)
Received: from [100.64.0.1] ([165.188.116.15])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844f62583f6sm245678239f.14.2024.12.18.15.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 15:06:11 -0800 (PST)
Message-ID: <dbb66354-b08d-49f6-82a4-840be58bddb1@sifive.com>
Date: Wed, 18 Dec 2024 17:06:09 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/3] riscv: Add Image header to flat
 binaries
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20241210044442.91736-1-samuel.holland@sifive.com>
 <20241210044442.91736-2-samuel.holland@sifive.com>
 <20241218-d2753dad681a37b3b15c7c75@orel>
Content-Language: en-US
From: Samuel Holland <samuel.holland@sifive.com>
In-Reply-To: <20241218-d2753dad681a37b3b15c7c75@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 2024-12-18 4:13 AM, Andrew Jones wrote:
> On Mon, Dec 09, 2024 at 10:44:40PM -0600, Samuel Holland wrote:
>> This allows flat binaries to be understood by U-Boot's booti command and
>> its PXE boot flow.
>>
>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>> ---
>>  riscv/cstart.S | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/riscv/cstart.S b/riscv/cstart.S
>> index b7ee9b9c..106737a1 100644
>> --- a/riscv/cstart.S
>> +++ b/riscv/cstart.S
>> @@ -39,15 +39,29 @@
>>   * The hartid of the current core is in a0
>>   * The address of the devicetree is in a1
>>   *
>> - * See Linux kernel doc Documentation/riscv/boot.rst
>> + * See Linux kernel doc Documentation/arch/riscv/boot.rst and
>> + * Documentation/arch/riscv/boot-image-header.rst
>>   */
>>  .global start
>>  start:
>> +	j	1f
>> +	.balign	8
>> +	.dword	0				// text offset
> 
> When I added a header like this for the bpi I needed the text offset to be
> 0x200000, like Linux has it.  Did you do something to avoid that?

It turns out that U-Boot on my board is configured to ignore the first 0x200000
bytes of DRAM entirely, so the binary ended up at the right address for the
wrong reason. I can send a v2 with this field changed to 0x200000 (which also
works on my board).

Regards,
Samuel

>> +	.dword	stacktop - ImageBase		// image size
>> +	.dword	0				// flags
>> +	.word	(0 << 16 | 2 << 0)		// version
>> +	.word	0				// res1
>> +	.dword	0				// res2
>> +	.ascii	"RISCV\0\0\0"			// magic
>> +	.ascii	"RSC\x05"			// magic2
>> +	.word	0				// res3
>> +
>>  	/*
>>  	 * Stash the hartid in scratch and shift the dtb address into a0.
>>  	 * thread_info_init() will later promote scratch to point at thread
>>  	 * local storage.
>>  	 */
>> +1:
>>  	csrw	CSR_SSCRATCH, a0
>>  	mv	a0, a1
>>  
>> -- 
>> 2.39.3 (Apple Git-146)
>>
> 
> Thanks,
> drew


