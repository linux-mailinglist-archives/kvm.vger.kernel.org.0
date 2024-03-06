Return-Path: <kvm+bounces-11177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 046FD873D4B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28A071C22675
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD046135401;
	Wed,  6 Mar 2024 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4vNQh5q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D7C13B2BC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745513; cv=none; b=iZVt+fa4/ibH0WTP6dI9F2FwgfJDfK0xS8bvJMcPFa9vS3+ipoHL7YgKS/wM2e+ah9xEbhqYASwNITVZZK0pBplRGmmqnBaviHVscbjTleFRZBNWk76IadjbKEUVLJeTDYW/sZN3FoVtleobieR8bxJga49AJeN9u/Y8x+rWLY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745513; c=relaxed/simple;
	bh=MaTqz0uuh3utPXgCU4B7IbDggqkh59U9xpShKGYytaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VvxgsQ1FHWF90p5YHFctdQ1CogPHGdQ44tkoppvL9heZFShC+3QsD3Ym0jDrJLWf7kHwJt+jxbptVVfMa5KAg8ULh9QFXjLHC7a3BeCc1XeFmuRISGO13ToKJg1aSLQwT/iL8vXQ2qSc2a4z4abVu0OojkXb7ACEG3gojYa7/34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4vNQh5q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1Ydr15yj5uaSflubi3seQTmmw/6T2QcyxkefdZwGlGA=;
	b=Z4vNQh5qSJ2i+rRGsJrCtYAPW59o4sxHWtmvVcnPKK2Jjj0zF/mhFBolw+zQ505WR/EN2i
	jjCzn+Lb2ssbDjPo8ShVzkb/+y4PrcFh+IrBGl0b0CUe31RYdi6q87AtxCBAipCgCUZYCv
	oE3C/e6pFRK2trW5gkhJQ5Ve3CYnhfc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-zDbv3lvrP1ihUlIuwkOedQ-1; Wed, 06 Mar 2024 12:18:28 -0500
X-MC-Unique: zDbv3lvrP1ihUlIuwkOedQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a4489805a2dso257315466b.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 09:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745507; x=1710350307;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Ydr15yj5uaSflubi3seQTmmw/6T2QcyxkefdZwGlGA=;
        b=n2CKMZqNZD0+mg+uUVh3yyUVgA1AyeoKJ6xB52WoJxaATyUukNKPlKIcffgMf5exbT
         I03v+Z8VQn2F5CEj3RnRfyG5r/LkloVCdkboi78TIhexI9LYuWxkTbOealte8dIGJ0U0
         8BjUqtXHncj9q6SuOj8AhUX4qWq21NqVpkpFernPX+THIX/QxM79jrY4ZX1bhgLDOdxr
         tFnRwbYxTyice12U+Hpf0SvT+OogPvrnYWAJyjbzbdmT1aZ+N/wQhJsc6dpJI5wJ98pb
         Wh9vbBdWZ7vQ+Zu/jfV4GhUZkWnLIz9VZeMdUdtIdUiszF6HtPCk9SygWMcCPF3Me2Zv
         Smcw==
X-Forwarded-Encrypted: i=1; AJvYcCXIEnYyIJzavm54pGyNkGHAEl4IOSrbR+utn8lAZ87D4qIwrawJl8FWrhRAf8JaARBOQ+a9zeljlX0mW/BVeXlj8Lf5
X-Gm-Message-State: AOJu0Yw7fmer67oN7n50GN7Koi4V7RrUZ0Q+DbicmjsGv4RW/KJd4mwd
	gdGihamtyHWwgtDhPMIOodnPM0kAHawPt2c8r9VuZ8UvoLiuedxAAkIrrSXxyBxSsyqkLLNQjHy
	Kl9xm4/Itwy1P1WvcUZrARWE5SCTlXJvqfXlGiQz29Qn2xIiBrQ==
X-Received: by 2002:a17:906:3941:b0:a3f:ce8:1234 with SMTP id g1-20020a170906394100b00a3f0ce81234mr10874536eje.68.1709745507250;
        Wed, 06 Mar 2024 09:18:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj8TT2W1utQYYB8sOG6p+2oVtoAhvB7cAz+/v303oOYvnweRrDtoE/5KD6MUDoyDYogcH1lg==
X-Received: by 2002:a17:906:3941:b0:a3f:ce8:1234 with SMTP id g1-20020a170906394100b00a3f0ce81234mr10874516eje.68.1709745506956;
        Wed, 06 Mar 2024 09:18:26 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id ld15-20020a170906f94f00b00a44e7afde87sm5113636ejb.148.2024.03.06.09.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 09:18:26 -0800 (PST)
Message-ID: <0fa16043-1def-4256-a773-fc0d0897fd37@redhat.com>
Date: Wed, 6 Mar 2024 18:18:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 14/18] hw/i386/pc: Remove
 PCMachineClass::rsdp_in_ram
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-15-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> PCMachineClass::rsdp_in_ram was only used by the
> pc-i440fx-2.2 machine, which got removed. It is
> now always true. Remove it, simplifying acpi_setup().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/i386/pc.h |  1 -
>   hw/i386/acpi-build.c | 35 ++++-------------------------------
>   hw/i386/pc.c         |  1 -
>   3 files changed, 4 insertions(+), 33 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


