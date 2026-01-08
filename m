Return-Path: <kvm+bounces-67351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CC3D013B3
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 07:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BABB130478CC
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 06:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D5433A706;
	Thu,  8 Jan 2026 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uz9JD/QB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqItVALm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C8127CB35
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 06:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767852851; cv=none; b=A2KeYZHRgkg8Iit6JPw7rqiBT+JVhJQiLV55+DaSwMV1SQzC+vKrxYVwi2SWJtw7Qq4CEjjAcehJWyiaq1LXbQShdntLZu8zme24qVpMYX1W+WdH0badyG4+9tuKKAiJrSAYkP3np+q8C6wCOJ/1zrsQa3ouZR6swl+3+dfrXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767852851; c=relaxed/simple;
	bh=95+hvgZmWBmKLUF7KdsEmQQmkMg5+rOsYbWCPJ0Lnk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PjxnI54ARNUmLtAKcN5yHW/KsgcOHzMuSRd3ByxPbY0/oGlXk8z/92mqhABFIxhDYoXrLFuibo4fBTnK2vpowsPbcwGccP2kxTqhjjEmIUw7D6V2VoSO7rOnApFE3nRecNgMqmDZdO+8cj4r4Vh911iprb7YfIXceladS7tdklU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uz9JD/QB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CqItVALm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767852848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l/lzNt1si/El5u/3JxuEqXHb6Skth5KuEneedRtr6Z4=;
	b=Uz9JD/QB1WZCPsB4K415hoYO04iE/IJ5A5uJ7Csq8ZSDPAhnLIlowc19kAOlJMloiH0ABS
	G1IdmmXgPAojDeroOo8KNZ7iya1AXnBDUUTsQapf10ITGlK3akMIFIMyJc17r3Y2m4lW1y
	2Z0Tr9qPqwnFUkNyfGEE8zDuxTJ8AKI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-0kdJB36FM2adXQPZEMLhjw-1; Thu, 08 Jan 2026 01:14:06 -0500
X-MC-Unique: 0kdJB36FM2adXQPZEMLhjw-1
X-Mimecast-MFC-AGG-ID: 0kdJB36FM2adXQPZEMLhjw_1767852845
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b807c651eefso348416966b.3
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 22:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767852845; x=1768457645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=l/lzNt1si/El5u/3JxuEqXHb6Skth5KuEneedRtr6Z4=;
        b=CqItVALmcuavA1IevntE1BUuKJ4eOj/RR8XDtPeSIqCz0SdZk5whpEqrGHLhylRs6e
         qsqGfDoJJ1580u9XPfaKes0N558vNKkZjtK2thppSAzrKvDIAorkOw+gfCb5Cl0M9fpr
         M0feDIxjA51rJTNsWlrDy1xvDaYlO0eOhPriWfctV1uLwQZtesHJocmPBtMmpowJ0fLV
         1SOlY+IuOZwFUogfSp5yfDI3iqmaL2xH63BOnDn4Q/b1xPQHzkEowLAemaLLhgLdcel1
         K2jseeq5yDxjNxvKLm0jLyyJ+lClM/TqJZe+h7d8Arj7QLTSj5tuHPQq2n4fj5Uj9e2A
         2gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767852845; x=1768457645;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/lzNt1si/El5u/3JxuEqXHb6Skth5KuEneedRtr6Z4=;
        b=EmdqySOGkMUU6ETLbA7wg61Nj2q/A2iP4ihWIgvby5nJlHKIwcvLftXze0feMAiRr+
         iWEBPkxciFeTl527REGIdnOa5A1FUz+T+9SGnaO1QU8u2DiaUAOmR5NC26bdAa8J7Re9
         xiI3SgZwAL6vVZGNRv+v5CTmBFYdegoohPcEJlWZu++SI+XP+4dn5U0DzOVXm0bid2ZN
         XmGrkjLvYEXcQltJ9p4RjJEQZtsuPZSdXLLTF7EzcZuQsVwZQYnUQgMmpq7+mCA4wDmx
         QyEOWoa6LZtupzuicW3VA05I+5rXwv8umzgiywNo9vy5XAL2FVnGkAynzwB/8YeGtEJy
         WGqw==
X-Forwarded-Encrypted: i=1; AJvYcCW+N9NZo+7+b0PJS1UVlCg5h+iAJqh1BgkwYWiN2hW5PQlUDOCLWYBnZVfks828E37MBfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmgTGaQqqiqw9fZbp9NAmb0VNLqp2H5sGuZ3TbtixQQrL9XQDZ
	s2efD2vOsSZX841cG7Hl7CSVBRglfJJCQQ3urdMtgi4aRdVIu8BCNWgqI9hvcKxq7pt1LLcCelR
	6DmCQPubqHgpdAMqtqUe2yXaYZWkDtN+lVdokwsEJyCPnslLwDXg1Dg==
X-Gm-Gg: AY/fxX5BIhnFadjOOnthrEouunz94H6hCh8eJJXQxZxOCjfSNdiM/SzEGXJcoSY+nf+
	SpfEgjpk7IcYdxQcLp/SuSqUiiwC4q1SinrVIOG+raCCAnOdH5WUFOX5+I+lRbXQHGYeFXPwQ2u
	8sYjxOspfsC/Tm7p4mzlml9QZ1nvnmN21kuJRA0iz8k8mNUBNOwFKb0aqwzYgbG+qJGWXyGuaMc
	A7WszZ434Q5O52ci5k8ocoiVO3FHCOhm/4LFCqmPWErmOaQP9YWC9rxN6TTo2IeG2z/0agxoxoY
	W7gSKnjmtd1mdy+5urxDLjJlkCUjW2l+wPJlaQHDrUtF5d/NeZYijw44BRknh8gRcv1pzAkjhCC
	Bm89cgYI=
X-Received: by 2002:a17:907:2daa:b0:b83:972a:cb85 with SMTP id a640c23a62f3a-b8444c99d69mr493960666b.21.1767852844992;
        Wed, 07 Jan 2026 22:14:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVRsnS9p9n7drdpE60e89TgHoiXqmd2qOHrMYP6giCCfm+VLK5zTWUF3eXR7xUrA4bvP5uMg==
X-Received: by 2002:a17:907:2daa:b0:b83:972a:cb85 with SMTP id a640c23a62f3a-b8444c99d69mr493958166b.21.1767852844503;
        Wed, 07 Jan 2026 22:14:04 -0800 (PST)
Received: from [192.168.0.9] ([47.64.114.194])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a564284sm729832166b.62.2026.01.07.22.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 22:14:04 -0800 (PST)
Message-ID: <87cda384-3199-42b5-905f-a4a0488dfaba@redhat.com>
Date: Thu, 8 Jan 2026 07:14:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/27] hw/i386: Assume fw_cfg DMA is always enabled
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: qemu-devel@nongnu.org, devel@lists.libvirt.org, kvm@vger.kernel.org,
 qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Sergio Lopez <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Amit Shah <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 BALATON Zoltan <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>,
 Jiri Denemark <jdenemar@redhat.com>
References: <20260108033051.777361-1-zhao1.liu@intel.com>
 <20260108033051.777361-15-zhao1.liu@intel.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260108033051.777361-15-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/01/2026 04.30, Zhao Liu wrote:
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> Now all calls of x86 machines to fw_cfg_init_io_dma() pass DMA
> arguments, so the FWCfgState (FWCfgIoState) created by x86 machines
> enables DMA by default.
> 
> Although other callers of fw_cfg_init_io_dma() besides x86 also pass
> DMA arguments to create DMA-enabled FwCfgIoState, the "dma_enabled"
> property of FwCfgIoState cannot yet be removed, because Sun4u and Sun4v
> still create DMA-disabled FwCfgIoState (bypass fw_cfg_init_io_dma()) in
> sun4uv_init() (hw/sparc64/sun4u.c).
> 
> Maybe reusing fw_cfg_init_io_dma() for them would be a better choice, or
> adding fw_cfg_init_io_nodma(). However, before that, first simplify the
> handling of FwCfgState in x86.
> 
> Considering that FwCfgIoState in x86 enables DMA by default, remove the
> handling for DMA-disabled cases and replace DMA checks with assertions
> to ensure that the default DMA-enabled setting is not broken.
> 
> Then 'linuxboot.bin' isn't used anymore, and it will be removed in the
> next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> Acked-by: Igor Mammedov <imammedo@redhat.com>
> ---
> Changes since v4:
>   * Keep "dma_enabled" property in fw_cfg_io_properties[].
>   * Replace DMA checks with assertions for x86 machines.
> ---
>   hw/i386/fw_cfg.c     | 16 ++++++++--------
>   hw/i386/x86-common.c |  6 ++----
>   2 files changed, 10 insertions(+), 12 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


