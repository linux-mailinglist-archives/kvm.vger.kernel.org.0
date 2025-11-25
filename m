Return-Path: <kvm+bounces-64486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6268CC847DB
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 29BCA4E9FF6
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376012FF67F;
	Tue, 25 Nov 2025 10:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oAhSySDs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C821FF2E
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066521; cv=none; b=ZMst7NNGdACh74jWJT5fbmMK2nIlirozl50A1svHP6t3Vg/Xy8M+4/mPHlBxVm5qAFudahNi9yNQ4rcYkKF/cvLM/JJtZe46eyVjhQI5SxKJJWY05fQoZ9DaxLI4qwiIDL9oHFLcCVg2aRQy9GnEXJ0PICdlDUpTwHjfmDyE/Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066521; c=relaxed/simple;
	bh=uagLwtLyI7jDwFKgZ/q/4r9kdla6Yp3feTH5YWEBNIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSVq10GZC3t/qQYxB5xJEv8bU0Dv7LMP59XWWmZ9x9b1D1iUY8JVHb3AQzDe9N8fe3OYx3Gz7LDyEuJzce+T/YryiudQ8lwzxSzcHeIiqFoeRaOdmmGpvwLChale1RTHscFrCNhHfL0ow21e7GiJmpC2tdPRGPvX5IL/cSXogGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oAhSySDs; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7355f6ef12so1118042266b.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066518; x=1764671318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s1upGUE7YIUICVmJUED5d5whRme8CL9poQ2KbESMmuo=;
        b=oAhSySDsgFjFPtA0WxBxJCvfOI872rLy58Rw3/wMnbOFWOuRQIq8vnePXyYfUkRDLn
         rqmeUqPFzDjMURgmvWhZb3Os/pHze15kugsbg4bOYWheG4etIC2ppGdYHira/9MUC020
         tjvrg/Dzytp3+tsSbUKIk3fL1p5gVitVg5Ix7M9koZWBo5UaE7gVc7PAs0krE4porCdW
         DfCscxaf3xy+eLPw5OkM4+amJJAi82YHtM++VEHO4v8HjXqDBlTlBLR1WpKI29JHT3b2
         S2VF3w4DNIn4up30qd9JJD/ey23t7j9pVGlFd8KV0xR1IsbAS2bkZxj7A7a6Rqpl16F0
         LWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066518; x=1764671318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1upGUE7YIUICVmJUED5d5whRme8CL9poQ2KbESMmuo=;
        b=c5xtqigeIXIeI//v3isuDIhJInFeZyAEa1GnLxvF0npJ+BnxPI2/I5Y27K2Tts6z2t
         qbVu65HjRMOPGDrdlw7ClQ8eXEgGFr8QnKq4Y5K5nQCy4NI0t/BMitYTZU3CYfNZPF8u
         wYSDBwESleG8UWxs4qOMOSNmJFkXXZthC8EDF4o5VAnbKWcirVoB4XCpsZTav/uevqXo
         U+eK9otEdP462aGes/kIDPqtzHV1luIkI5MnAsC/MNWG6urmih4A9GVRkT7ezp+bOq9u
         aflcG1fz8L17g+XCP5o1cvgvtCEueu9CLt0xtMVbBHeqRoOlizKop5TB3vuDSSsdCCrJ
         yEMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgaKxqkntVTtPLn5gqQdTkyFFGYxD4xbb9uvMPtqtF+Zz8C5iwGCI5cw/aDo0JzCDNnZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5yMZ124zLSFSrQptfSrBOOPzXycyGHrTpJd6R01XmBSvaQbxb
	Fsg2s7vWj6SrAjGR1GGqKimcEMA+ZPBlkAbh1kOgrhPfvwBINILhEI9A+959TvvPCSM=
X-Gm-Gg: ASbGnctWn9Y8jecx7QijLalCgvoPOruTFAvJUtuAbtd3evf6MLG9/RlgDFD1/eAakkb
	OrjsHRWJNV8Wrrpe9jhzUQmek7+WAJbOJ7rawqJ5nRHaVCApe06Ni8rSl08O2sHfpeKkaldlSPS
	Ts1zIaWGEAoSELT1PIAs+yg9sXpRCJHQcFxYEgiQmCWqZ6ClbbWkUuFt5imQRG4Ji6IHJWUymd9
	p5hf4e+r3iqQdRDvDf2T2eJgM3/jjZzebyUk75leaTCWdLPOPv6AZJwM3BpeqdrdMbHF1llSlUm
	XKMr3KKx1VMrT3jhFZQDlEbAOXKSyKRWK9Sy0A/LE6rLVrZuGQDViQ5bfROqxEhZOp5Q9f4n0IB
	q5jsytmbQPhKEtv3UAMTgXoiwHsD71njAhcerisAEF8rANhXLHT88VHwaZa6+glDfOlXhivm1xU
	Ozj6L0RDI8YbFzalvydWCJLL6vNw3hlO1sZdoh/Jlw78qjB4IHNkcltg==
X-Google-Smtp-Source: AGHT+IF59L37GgnGAgNCiHvqRTLRI2aTvHyr6yOsdF3ewgBPJ+5ZCFL6F0XLm22Mv4gcL1oVkiKNmQ==
X-Received: by 2002:a17:906:fe0a:b0:b73:8bd4:8fb with SMTP id a640c23a62f3a-b76717322d4mr1729884566b.42.1764066517609;
        Tue, 25 Nov 2025 02:28:37 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654d3bfcesm1536852566b.15.2025.11.25.02.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:28:37 -0800 (PST)
Message-ID: <b9cd0110-4a91-4ef5-a139-2dcd45b2a0cc@linaro.org>
Date: Tue, 25 Nov 2025 11:28:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/15] blkdebug: Use error_setg_file_open() for a
 better error message
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-10-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-10-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      Could not read blkdebug config file: REASON
> 
> to
> 
>      Could not open 'FNAME': REASON
> 
> I think the exact file name is more useful to know than the file's
> purpose.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   block/blkdebug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


