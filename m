Return-Path: <kvm+bounces-11153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8233873B97
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:05:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 173731C23FD5
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEC2135A52;
	Wed,  6 Mar 2024 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFf9InTb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1C3136668
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740921; cv=none; b=HPQJqnae7Q6n5A60YWazdRLzqXJ7kpkRn/1d/0JpUVpMQEN+vZSGig4Weqw/hbM1WzAsm2jZnObUG6g9bK7tjs4CuJ+6D3t4bWGEaed6qeUnUqVYKywf2bEBD5ErKDUyVpsBqLzZfeSfGLzUVsdQWbmR994v+ofVmi47DY8lKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740921; c=relaxed/simple;
	bh=EE98jEkK2IgxbIB0yhqU7nlbCvA7qeSvYdi35YbgGXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H1TivNqglbWefoabTJLPxF2OO9l2CfjWXiC9cOTHfgytETlp/xRIb5GqpuWAfOwSbk6US4JuqYYxJGcUwXVoJUtAC48krHfeVEjuyHTzyvEjC7cxvvcOq+T5xquKlSqLisWw4DsbSth89yWjdmcjp9S20bA+O2DfxKV6FIIrzDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFf9InTb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709740918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HIKrZDxlEHFzlQCbSggPchCcXnWZkSttvq8u+AjlpFs=;
	b=AFf9InTb09bmOWSDnsxP8PIgtTWEYSIX7XOQbdQyjZF+fmydkSW48Y6bJ5ozjV6RwIUnA1
	m2RzYSVzMM98xAksaLpi2U/QueQzlI5qFx79P2B3ocQBLrv7NYA9giIwKGepEBE1sYklmB
	CB/U6XblpfKL5f0wrcehYAUByTN1pCI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-YDGDVx7MPTWz0cPVXXee9A-1; Wed, 06 Mar 2024 11:01:56 -0500
X-MC-Unique: YDGDVx7MPTWz0cPVXXee9A-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-55d71ec6ef3so6541129a12.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709740915; x=1710345715;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIKrZDxlEHFzlQCbSggPchCcXnWZkSttvq8u+AjlpFs=;
        b=MT6MaBkzh3lL36On9+yMG6dA3XKmqoH7YZ8PSKDkyfxm9VuSUllusHu4YUkiNbvp1B
         MuPMiqsnL8ADyDaiioFJ/eyUvfQ9c6xPH5ezaBwgsDoiYUtEntt0qltYFc9aNgVAcrEm
         m0d+x+gq7/0lQcvkurafZwZ9ol7DYzL/OSBjpJr3GNSB2P02arRDT8WIqKtDeFKV0KhG
         CEgWl0OUc24IG0a1xqdzBFG0P110zSExnZ7/srfMAGBe1v7lIxpCRiPF61Vyn7LhyLZf
         5wbNRP4cQi40UJr7BDshABErRPHUJu6A7xSL+H2N/xKI7yFvi2x2Hio4NtGQF9aMqBsw
         GXGg==
X-Forwarded-Encrypted: i=1; AJvYcCUAtn9tg+nw1Z+YTCiQ6uun3RAelS0KS9w+4KVRjb09z+O3t5gMV3Uo9hR/kLr4uECYC9DfsLQEWXalZkRPOeejFKsZ
X-Gm-Message-State: AOJu0YwP9tz5aYum7G9vWOGcfsIE//WTtzrWlXn1NidbddMAZwJz366P
	2MRoBgDUW+PlXthU0lLLJ7bSv+trTzu03Ioq1nsJV/2zTMtaRSwtcOTVce4uLtuu/mhbnpsQbvx
	LClhBozUagMXBbK/HKQnz1SQTJBUenVHA14iEqkuAgeIMA6cSZw==
X-Received: by 2002:a50:c8cb:0:b0:566:a235:9355 with SMTP id k11-20020a50c8cb000000b00566a2359355mr11404490edh.33.1709740915740;
        Wed, 06 Mar 2024 08:01:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlStsX0L5rrMhZ5WBqFHt/WXXTtiOgD+MZyXs0J2J16cUAoPHyWAoXJfdhAF4xwrLrtAJ88Q==
X-Received: by 2002:a50:c8cb:0:b0:566:a235:9355 with SMTP id k11-20020a50c8cb000000b00566a2359355mr11404457edh.33.1709740915184;
        Wed, 06 Mar 2024 08:01:55 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id f16-20020aa7d850000000b00563f3ee5003sm7003058eds.91.2024.03.06.08.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:01:54 -0800 (PST)
Message-ID: <2a01baa6-b6a3-4572-94cd-63b2eaab7b38@redhat.com>
Date: Wed, 6 Mar 2024 17:01:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 16/18] hw/i386/pc: Remove deprecated pc-i440fx-2.3
 machine
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
 <20240305134221.30924-17-philmd@linaro.org>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-17-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> The pc-i440fx-2.3 machine was deprecated for the 8.2
> release (see commit c7437f0ddb "docs/about: Mark the
> old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
> time to remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   docs/about/deprecated.rst       |  7 -------
>   docs/about/removed-features.rst |  2 +-
>   hw/i386/pc.c                    | 25 -------------------------
>   hw/i386/pc_piix.c               | 20 --------------------
>   4 files changed, 1 insertion(+), 53 deletions(-)
> 
> diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> index 84c82d85e1..78be35e42a 100644
> --- a/docs/about/deprecated.rst
> +++ b/docs/about/deprecated.rst
> @@ -221,13 +221,6 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
>   better reflects the way this property affects all random data within
>   the device tree blob, not just the ``kaslr-seed`` node.
>   
> -``pc-i440fx-2.3`` (since 8.2)
> -'''''''''''''''''''''''''''''
> -
> -This old machine type is quite neglected nowadays and thus might have
> -various pitfalls with regards to live migration. Use a newer machine type
> -instead.

Instead of removing this section, could you please change it to deprecate 
the next set of old PC machine types here (say 2.4 - 2.7 or so)?

  Thanks,
   Thomas


