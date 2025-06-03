Return-Path: <kvm+bounces-48273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB1CACC17A
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A181188F68D
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D78527F736;
	Tue,  3 Jun 2025 07:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="VpGQAxd9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DED27F195
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748937178; cv=none; b=BmOi8zZ1tAHJE7+iXQmdbNoX2XkslK9OYS3RI80zitMX15madyya6AgRDf8PQZY/Phkke4Yk8aDFkVG7EfUs72kXoM7hr6uedN2kYOKGLFb5dFLNMLloytmxp9fYMEJY94mTc2TkHlHyQYqAbAvN7D15j/MbCRjPBaoV8AFI3qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748937178; c=relaxed/simple;
	bh=uR7vhMh8E3nWQcmFiv44xaDg2BgbB/gwLbD+lRTfhKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cATww9EUrpM5Ha+v89md7G+L6EvAIY0cL+icfdznJVcRwIOTD/LecWRmeRSfFX16rzVqBc1errKi1iXO3pF6dp3zAfB8qKk2EC4BFmcbDt/MpsqdLEdcwSM8cbngwXAZ6Afig/kwgWR0X6wYss4EVqIglfCd0clecjsRhwOgIzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=VpGQAxd9; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4ef2c2ef3so4205647f8f.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 00:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1748937174; x=1749541974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m61OCXyKK9ERb/2rZMaZqgh2bdpfeXzO3x02hpwKUck=;
        b=VpGQAxd9L03IhZc7f1QUA4zeLuIAdIiREPIMmyrgeGEXu1yf9eG5mjys2QFUkP9wEE
         inJJLNyK9zPiBAVpKu2chR7HYgzjc0vwNYvxxlDCuWximF+D9WULwGVZIckHS+A+575N
         Xw84D2OcLuQsAZIOjs5AvM5kkjTIgri44dNjthB/dZAEfg82Ycf6xbkUKOf89RyuGdqU
         /UkeBoj2EU/jgVEy2jG1l+eLL5hZF3wQzgQvXj0iEPzovzfjCqZBnO2Psg1idlskpOix
         vT+2smBpcMokvodQNhYKGa2U5IFe1oiVrlAFjypaM8AcewLiGoou3O8T+vqIyhZOHwvM
         Chdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748937174; x=1749541974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m61OCXyKK9ERb/2rZMaZqgh2bdpfeXzO3x02hpwKUck=;
        b=njcouxnjgp8ehz44JcDv6IKhXU78f8yQk4QiUscifMisTZhkocdYOpgz9FDVn3MW98
         kuBHXKmTaeu5D16eCDKLYewICdiGDALPX0OcnIvSt9Ehn+iWQnr5P0mZEzRD2tWi/DYD
         HiXjAEwHezaFJ85KS57f4JlSlHmtulCrgCiTPSxNS1RG+CC8Qw/WsgizdgQK2srZHxeF
         DAA3upf+G5dOvSsnKHOtTJ9fVFFcZ07UfWa0Cd/uTHiJzFLdR4VhIwJT5SMyaieYam2g
         LRd6HUfmtansCAEDVaQGNvlV33tU7gbWGW7xnNOGFu+bROf7jyqgWCyjKjl07zvNJ+3b
         hpQw==
X-Gm-Message-State: AOJu0YysnfMo7TjkdMgef86e6e7PlaSV/71oXqcWGhq7ZGs4cSq4Ljm+
	qNGyKrk7WC2w7einkgFX9OEbu+u3KQ2MhM3f6DIX3LG5oaMqtG0LJp7KRCNoNx0GdrM=
X-Gm-Gg: ASbGncv2YbG0cGbyKinfn5AmAi3bMfp93eIiEGvu1J96KyDp/aHxkP8DcTHT5fQuqmZ
	D15iP7s0U/T1fPjbCEOgBpnx2W5aV8vH79fpe6g1qfIa9Jf3RuyQjbB7umMqDWDEs/IB0i7LrDj
	3UBSw782phYZ6jDeJV7JEXnYoyL11rHmqp3HEmU2JBVim/8z1m8Arz8Fl9hjPQaCLvaX+nDU5Yx
	N0kmrdr3FdgQFdlMdRwu6JwMlBYTOVMzHXp5oRiYNPqTETanxnfdmJ4BLlGIbEgXp+tfVKbXAw7
	L8hVgd2t3fEL5AE0cn2GkbtGXoy3cwVFZY/0SoMobo5/VL+n9JMXUiT0/E0bfOwhJdCD8FaAkNT
	InvBpRZTmtiWQBBnKE9TsrR6BWMnoya8=
X-Google-Smtp-Source: AGHT+IFj56gQIXjUxeVgr0DLD4EJHkF+7gB6PKwFHaTHu2meToVlvesVdcLfH9ZFmhcZfcce+aitmg==
X-Received: by 2002:a05:6000:40ca:b0:3a3:655e:d472 with SMTP id ffacd0b85a97d-3a4fe395a08mr8455530f8f.47.1748937174316;
        Tue, 03 Jun 2025 00:52:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe73ee0sm17254343f8f.46.2025.06.03.00.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 00:52:53 -0700 (PDT)
Message-ID: <9fbee56b-988d-4557-a8c5-e0c85d146a39@rivosinc.com>
Date: Tue, 3 Jun 2025 09:52:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] riscv: Add double trap testing
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250603-ae5b10c63b6ac83d206343fa@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250603-ae5b10c63b6ac83d206343fa@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 03/06/2025 09:10, Andrew Jones wrote:
> 
> Hi Clement,
> 
> You may want to add format.subjectprefix = kvm-unit-tests to your git
> config, since it's missing from this series.

Hi Drew,

Yeah sorry forgot the prefix !

> 
> On Fri, May 23, 2025 at 09:53:07AM +0200, Clément Léger wrote:
>> Add a test that triggers double trap and verify that it's behavior
>> conforms to the spec. Also use SSE to verify that an SSE event is
>> correctly sent upon double trap.
>>
>> In order to run this test, one can use the following command using an
>> upstream version of OpenSBI:
>>
>> $ qemu-system-riscv64 \
>> 	-M virt \
>> 	-cpu max \
>> 	-nographic -serial mon:stdio \
>> 	-bios <opensbi>/fw_dynamic.bin \
>> 	-kernel riscv/isa-dbltrp.flat
> 
> You can also do
> 
> $ QEMU=qemu-system-riscv64 FIRMWARE_OVERRIDE=<opensbi>/fw_dynamic.bin ./riscv-run riscv/isa-dbltrp.flat

Oh yeah I even used that as well...

Thanks,

Clément

> 
> Thanks,
> drew
> 
>>
>> Clément Léger (3):
>>   lib/riscv: export FWFT functions
>>   lib/riscv: clear SDT when entering exception handling
>>   riscv: Add ISA double trap extension testing
>>
>>  riscv/Makefile      |   1 +
>>  lib/riscv/asm/csr.h |   1 +
>>  lib/riscv/asm/sbi.h |   5 ++
>>  lib/riscv/sbi.c     |  20 +++++
>>  riscv/cstart.S      |   9 ++-
>>  riscv/isa-dbltrp.c  | 189 ++++++++++++++++++++++++++++++++++++++++++++
>>  riscv/sbi-fwft.c    |  49 ++++--------
>>  riscv/unittests.cfg |   5 ++
>>  8 files changed, 240 insertions(+), 39 deletions(-)
>>  create mode 100644 riscv/isa-dbltrp.c
>>
>> -- 
>> 2.49.0
>>


