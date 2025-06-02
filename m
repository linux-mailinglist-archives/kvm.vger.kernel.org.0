Return-Path: <kvm+bounces-48152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 308E2ACA951
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 08:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4B73189DD1D
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 06:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FA0190497;
	Mon,  2 Jun 2025 06:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LFchXKqS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D447317A303
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 06:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748844798; cv=none; b=Ov2Dig/u3j6K3P79JdAjfGBt2tneLtBpCTd5d9If+S0937JhHA5ncf1Ppa3j3xmTM6BsFBDirEQgClmRgI63r5HESKYeVk7LZVuucWflKJWdRvfrlzIeMD7ngIAxkiqjWRCdKGpojikeCKVpi9WeEMSKo5xwt+eSKtD0PAd+LjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748844798; c=relaxed/simple;
	bh=+DdImxtgbvGyy6AztvO2xh9B/UD4LpZSgsZG8BQ/0s4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gaUADsT5QmgTd8d4BT2r4MHHIYJ5t1skgUvHGc77msqCVCCJ5fLzjkXHRRO833vAZwgVxSHUdFWH43O0TDb6k6SiwkRpWzfqxbmgbFtQHY25c0VgGSR9FZ9LFB3LFzJ9BEzxCSv21sq7+hJS/BpWWUFf5GuPLLfKS01FYXgyhjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LFchXKqS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748844795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L7z/Vson2+vm5SuDJMltMJCFrsEVrDfsRIHMTfqIJtk=;
	b=LFchXKqSmuMyZa5g387fajbLAMfw/rWf6Y7/CyMkb95RlqOXhZXv6DD/Hk2yr16y1dVNT6
	fAOOqVR5bjrClNTCq3xGGSZqlAElXgKXr6UIhgMKun66mVgpe9dUopH12ZHGPVVLGmuHLA
	/9eLKacd2h6+7JlncTZGgDWckUd2U1k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558--w5ORIotO-av8TtyjJ9S_g-1; Mon, 02 Jun 2025 02:13:11 -0400
X-MC-Unique: -w5ORIotO-av8TtyjJ9S_g-1
X-Mimecast-MFC-AGG-ID: -w5ORIotO-av8TtyjJ9S_g_1748844790
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450db029f2aso10721085e9.3
        for <kvm@vger.kernel.org>; Sun, 01 Jun 2025 23:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748844790; x=1749449590;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L7z/Vson2+vm5SuDJMltMJCFrsEVrDfsRIHMTfqIJtk=;
        b=xO0ReidpilbZqsSpbArMdhOE8/hyc1qhPtj+6DrN/OOP5jHJyyEp3LDV0kc53uezxR
         H9/WVA321FZUEzRdJQ/0R66hV743RwK09RbGt8iRUmC5PO1C2K9+uurgQH2VKvIYBWDd
         K93IDhJiaxgmc6rtOjDLHOe5yqxyJwOk2NP1kT7thW+WmomZ+1IiUYKpuy23mj7rU1rO
         uK7bHNJLOgwWIRM4SgwR9TrXkVnjRsY/KjlcNnWCwFTgi3W4tyn0T+LMXaDvDKV/k+h0
         c8+6o7S3eWVaTBysCcZhjwT8NU2HR5pqfO7R2ARD4Z3OW0RiiJ9ElW798WQh3Y5SI/0v
         8Pwg==
X-Forwarded-Encrypted: i=1; AJvYcCVgdLxvT32AxikE8/4ecfKJLOlqmcql4qtZziKK2yFgWODzOjYqva9ugg3aWWfYg841ym0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHIo0yE7hWNpZiTmhP0IWj0fZu2A33ceHMkLHReHq8wHQJZ85I
	m8wRoAQ1l3rzCYo7fRcWfHMf/kBDAepORmkmBDertXhB4LHjc03eNdfz6jtwi9YDRy8Ae2S8bjI
	j3Y25SSzNs18HxtCpJHPHbE1ynZvXKftTDiMpBus30fhgqiae4RTV8w==
X-Gm-Gg: ASbGncsRi1wDaFspbTGp5CVJfGjcREQq7bA9QC4IH0aFCpLXW3avZd5/mXcaLehOfhZ
	eHU0sB7KCQKd2ifJTvKJOf/jD7FcSW9ztKWi1RqJ5ARqvKrNzJfMnLOBG8ikQLI5zmS5FD/Vrs0
	Hb8N8i/oGlwZ/Bh70eG5vo7AbEfbehf0i/2WDuM60W3PXD7xepmxmpb1DMbqdDRtLVMUsFW2H9N
	Z7wg9RlCZkwtPSs1T4ZknHpozdh9DmHwsGlIQ1/bA9vKVnWrHF4Z+KoI168djP/E6bGdkHbWSVb
	t8khSwjMYiz7qI/9lN4YigkmnW01Aa2tIgpglDYiVC7oz3pZxf42
X-Received: by 2002:a05:6000:220b:b0:3a4:d3ff:cef2 with SMTP id ffacd0b85a97d-3a4f89dddd5mr8407308f8f.27.1748844790148;
        Sun, 01 Jun 2025 23:13:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPvh/MxcIe0mgsORpWvEw3wa4aIPsAM8b0Y6hL8Xq17MRPx1fejaIFB69npiqnU06zAU5iHA==
X-Received: by 2002:a05:6000:220b:b0:3a4:d3ff:cef2 with SMTP id ffacd0b85a97d-3a4f89dddd5mr8407268f8f.27.1748844789702;
        Sun, 01 Jun 2025 23:13:09 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-112-237.pools.arcor-ip.net. [47.64.112.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fb80e9sm107138185e9.27.2025.06.01.23.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jun 2025 23:13:09 -0700 (PDT)
Message-ID: <91c4bf9f-3079-4e2f-9fbb-e1a2a9c56c7b@redhat.com>
Date: Mon, 2 Jun 2025 08:13:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/27] hw/i386/pc: Remove deprecated pc-q35-2.6 and
 pc-i440fx-2.6 machines
To: Igor Mammedov <imammedo@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
 Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
 Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
 Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Jason Wang <jasowang@redhat.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-2-philmd@linaro.org>
 <20250509172336.6e73884f@imammedo.users.ipa.redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250509172336.6e73884f@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/05/2025 17.23, Igor Mammedov wrote:
> On Thu,  8 May 2025 15:35:24 +0200
> Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> 
>> These machines has been supported for a period of more than 6 years.
>> According to our versioned machine support policy (see commit
>> ce80c4fa6ff "docs: document special exception for machine type
>> deprecation & removal") they can now be removed.
> 
> if these machine types are the last users of compat arrays,
> it's better to remove array at the same time, aka squash
> those patches later in series into this one.
> That leaves no illusion that compats could be used in the later patches.

IMHO the generic hw_compat array should be treated separately since this is 
independent from x86. So in case someone ever needs to backport these 
patches to an older branch, they can decide more easily whether they want to 
apply the generic hw_compat part or only the x86-specific part of this series.

  Thomas


