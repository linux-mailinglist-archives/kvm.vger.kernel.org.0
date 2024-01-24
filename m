Return-Path: <kvm+bounces-6777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03824839FF2
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 04:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96FE81F2C964
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42780539E;
	Wed, 24 Jan 2024 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="n5yGbGCt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFCF5392
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 03:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706065725; cv=none; b=EOF2/gQtnp+EOAW0xcFM2j2cvM1AqK1yG8hINrri6JEhFW4NCzPRYjFsETKd7fK4e7Ba0mu9IXCubizzq+RbrBe8zyBv/ihM3OxzRPoISWAl2vmp4ZcGqR5BiYA7otvkOmIdWNrBJlxUlfz5BvFqrIBcJ58wGdehQz4dWjkWrBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706065725; c=relaxed/simple;
	bh=SKTN3Bke7HunQNGVCzoxHL9wIhe07jUBks3xSkRRgp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=biemtl7t+CKyisbtOuSppXEVDNJfh2e4mhyEl1PC+i52gP2rGkyIJZgd+SZ3eb+V0PeFK3eO5H0nbHGx1q/2sdecGLyZhrQA7V7or+JBJ60rjqW1OIKlmxNkP8b+7H6N5mP2gC3B2n/DeBR7UnYuJDAmQzF63H5MUmawG+sPeGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=n5yGbGCt; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5ce6b5e3c4eso2624767a12.2
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 19:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1706065723; x=1706670523; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VFo8VE/oCNQcg7y+0hi3tk0ijg8Jc1j7rMhdDApnhJI=;
        b=n5yGbGCto4yYtnkCBJxQMUPDbOXKgB33jhPCiuc2a/+UIcy3O0rCLcPnf9TlF9evgl
         T2rAvjDabtMUrj3nKTplgtlLFWGglY0sQx1+5oPidgxWTSoCG2di5hQOb0H06Zt/2Zj+
         hnhxvsAm+lPOGcVdzYu9xGhbC1P5IjBSSGQ/aUx4WDDRgFd+dQsHXjHNJgtKsUeIRhcX
         eokwffIFScgVS0uN7i4YfZxx704xQ9PjvO6cga5Q4VeSJxrzi/4+GctYdkBiwoGuy3O2
         G/7nV8fvU/2Ea/aXVlIVRSjLqHKy/GYNqiS4iriAUInFafTxQQtbMuNtfHEDl+/GS4XI
         vQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706065723; x=1706670523;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFo8VE/oCNQcg7y+0hi3tk0ijg8Jc1j7rMhdDApnhJI=;
        b=YduoyTtibo06DOgazWKiWmINmox+mF5FoneBI+IBJK0cHxrWsIr0Ay9BfVKNd4f7Eo
         rdMuJJIJ3u1I6+70Q+8RnnWzqYe9sX7gwmJe44qBP/Mqhl61QfQ9CYsVUrA980/E3axN
         tukHvQGBC7BldlcfFUg6wSYmns0iZD/h4xu4cuVjjPp3LYNCj4lTWxXWsEb1rOH622VA
         o8GEI8OV5SkGvxwv8ZYL0tooCGSuOGhaMR4vkF/lchgoJCR2N3T2R/eOtA6+VvaAzs7C
         ORGbs6OjANYe3UfuWszM4q0yBGI/ro0i9c4ff6TAN3c0rMbRX5HEocs7XlCPEjvmGO7D
         LAig==
X-Gm-Message-State: AOJu0YzRnwznfddWbcXUt4PVOeU3bZH0Awa/RjKuURCJH2hbR6H+QGAE
	+vf1U943tvxge96u1/4fJrKg6hUtjDaOx774JRdW2xwNPJTP/Hmdgk8yKBDLGFs=
X-Google-Smtp-Source: AGHT+IHfntglvY7cr85OSIKd+heawzghHZglxVkz5tGKJB42nnuYpbxcKdH1C6I7IIHf5nsB+5FoRQ==
X-Received: by 2002:a05:6a20:7284:b0:19c:53aa:53dd with SMTP id o4-20020a056a20728400b0019c53aa53ddmr210373pzk.42.1706065722914;
        Tue, 23 Jan 2024 19:08:42 -0800 (PST)
Received: from [157.82.200.138] ([157.82.200.138])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902c9cc00b001d7267934c7sm7127456pld.298.2024.01.23.19.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 19:08:42 -0800 (PST)
Message-ID: <15d2f958-a51e-4b87-9a70-28edf3b55491@daynix.com>
Date: Wed, 24 Jan 2024 12:08:33 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of misa_mxl_max
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Andrew Jones <ajones@ventanamicro.com>
Cc: qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Rolnik <mrolnik@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Laurent Vivier
 <laurent@vivier.eu>, Yanan Wang <wangyanan55@huawei.com>,
 qemu-ppc@nongnu.org, Weiwei Li <liwei1518@gmail.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Peter Maydell <peter.maydell@linaro.org>, Alexandre Iooss
 <erdnaxe@crans.org>, John Snow <jsnow@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 David Woodhouse <dwmw2@infradead.org>, Cleber Rosa <crosa@redhat.com>,
 Beraldo Leal <bleal@redhat.com>, Bin Meng <bin.meng@windriver.com>,
 Nicholas Piggin <npiggin@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>,
 Paul Durrant <paul@xen.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
 <20240122145610.413836-2-alex.bennee@linaro.org>
 <20240123-b8d1c55688885bfc9125c42b@orel>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240123-b8d1c55688885bfc9125c42b@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/01/23 17:20, Andrew Jones wrote:
> On Mon, Jan 22, 2024 at 02:55:50PM +0000, Alex Bennée wrote:
>> From: Akihiko Odaki <akihiko.odaki@daynix.com>
>>
>> The effective MXL value matters when booting.
> 
> I'd prefer this commit message get some elaboration. riscv_is_32bit()
> is used in a variety of contexts, some where it should be reporting
> the max misa.mxl. However, when used for booting an S-mode kernel it
> should indeed report the effective mxl. I think we're fine with the
> change, though, because at init and on reset the effective mxl is set
> to the max mxl, so, in those contexts, where riscv_is_32bit() should
> be reporting the max, it does.
> 
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
>> Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>> ---
>>   hw/riscv/boot.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
>> index 0ffca05189f..bc67c0bd189 100644
>> --- a/hw/riscv/boot.c
>> +++ b/hw/riscv/boot.c
>> @@ -36,7 +36,7 @@
>>   
>>   bool riscv_is_32bit(RISCVHartArrayState *harts)
>>   {
>> -    return harts->harts[0].env.misa_mxl_max == MXL_RV32;
>> +    return harts->harts[0].env.misa_mxl == MXL_RV32;
>>   }
> 
> Assuming everyone agrees with what I've written above, then maybe we
> should write something similar in a comment above this function.
> 
> Thanks,
> drew

The corresponding commit in my series has a more elaborated message:
https://patchew.org/QEMU/20240115-riscv-v9-0-ff171e1aedc8@daynix.com/20240115-riscv-v9-1-ff171e1aedc8@daynix.com/

Alex, can you pull it?

Regards,
Akihiko Odaki

