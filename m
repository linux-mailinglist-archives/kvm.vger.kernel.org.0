Return-Path: <kvm+bounces-11165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E9F873CBC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B3321F26E51
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6079137938;
	Wed,  6 Mar 2024 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Usxwx5rd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E062605DC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709744270; cv=none; b=HYLsEoL/UovVtBO6XlWPllr8KPA1kthHUXsiSG3OSOFnFEdBt99t8fSzx2cknusrOYLKEoU4bs89Hm5O/cBtSKt/PEqrHxHFNocbxeMGGCaY/jJZJFI6K3BeTUJanCgcPXMxiReu5+KfM5yB8PRg40eaahhEZj/0TmD79lRF/bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709744270; c=relaxed/simple;
	bh=6bObcZL7xX5s0b9fUHNg0AQNl9wFEEmGUXIOETIVSiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYRzFGEn8RDww6xmDUZm8+l/mcSzqDsUmZQOtbkI+AhIyqJZuuBfJFpNNQyOxXbiGP+Nu4oViTUxLCzd6byM5jdN35rCwWKozPw/7qW4Tm4cPJL7XHiEd7sGuEBRpLllVll2C+SSCgmTa8sYsAkGREsgvjG8pQZoO2dX9EZtNhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Usxwx5rd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709744268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FVWQV0jRaGpJuKMtdpHVmyHOgCYVqPnJLOckdknQiRI=;
	b=Usxwx5rddDezgzsY1lCjZt7NMoCdyUe9EgxXXuzngbkuvegYX6jwqod7dawb1Z6/hwfuqn
	/Hsr1Y8LcrZSMVh/qbk9WLDhTiUhH8ugMMjdToLZga704egUMm/4ow/P/iu2EUwQB30sZB
	OQmXneyrtVBQQZYSotQu0nDd95K1ZXg=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-qQ9ZuL5pM0mf9Zb2BWtd_w-1; Wed, 06 Mar 2024 11:57:47 -0500
X-MC-Unique: qQ9ZuL5pM0mf9Zb2BWtd_w-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c1f586cb52so665934b6e.0
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:57:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709744265; x=1710349065;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FVWQV0jRaGpJuKMtdpHVmyHOgCYVqPnJLOckdknQiRI=;
        b=gkq3K4Hx5JAdZ77OQZOBEOPf+G67eU1PH+AvlhgC3crlDcyL0eZJ5U6Fu5TnoguxxG
         hAZZ6h8KY2VQ8Qikgr5a1IhI9VWDQ4qR6/SNHRhWsLKocx/mMzyfLIu6Z/x7/QVCQDJF
         F+g0tg7jEDEyRnRzDXgKKHXElbHab7aydjYI1YUKsZ60ofIWmDeiGJHD6GvMnhE6qbZj
         yluOTdnAPzQV0Yd1MoLCcoNI7Ew5qtborq05VKa6XpEY7s3G0JgN7x5Kb6rBhrs1J3QB
         33IcxnNuuJNho9xks3Ih9PGBPdIvRZXx2YpXD8shUrFLbEq33T6127JWZ9UaLD4fDsqO
         nrOw==
X-Forwarded-Encrypted: i=1; AJvYcCU5zlnTSoRiZbubCWjY+siEOrt3aJ9SUm0UZ0Lwh7HO9xUgxMA2fCtlCFiNtC/NokXVL7Lc+X8zIwp3M4bDcAYkaGqa
X-Gm-Message-State: AOJu0YzXvXaKpW2e8vwPQJreaV4mdGLGPC5vssj2T3MVyf0UCPOukmtR
	ZyUp6FILTXU7GV70B57ziq+SwiGLTaV3Sk9Q/zimad6pLL2PD8fVQMjWSp31nW4FQMyg6PumBrk
	MBOde5CeWkzJyTwaHC2qmzpMQkvQFIKDKegAEv0443PTOhhITew==
X-Received: by 2002:a05:6808:2111:b0:3c2:1051:ee94 with SMTP id r17-20020a056808211100b003c21051ee94mr323653oiw.5.1709744265397;
        Wed, 06 Mar 2024 08:57:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExaWNWz+8FAdyHD42Segvt9jWCc56GjQzK533355gLxz7rIzD0UR0zrXkU6PwGOO91v4DPMQ==
X-Received: by 2002:a05:6808:2111:b0:3c2:1051:ee94 with SMTP id r17-20020a056808211100b003c21051ee94mr323643oiw.5.1709744265095;
        Wed, 06 Mar 2024 08:57:45 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id t11-20020a0568080b2b00b003c1f461d1cbsm760543oij.37.2024.03.06.08.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:57:44 -0800 (PST)
Message-ID: <399a594d-4f7a-4068-8dad-ea01dfea939a@redhat.com>
Date: Wed, 6 Mar 2024 17:57:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 09/18] hw/i386/pc: Remove
 PCMachineClass::enforce_aligned_dimm
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
 <20240305134221.30924-10-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> PCMachineClass::enforce_aligned_dimm was only used by the
> pc-i440fx-2.1 machine, which got removed. It is now always
> true. Remove it, simplifying pc_get_device_memory_range().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/i386/pc.h |  3 ---
>   hw/i386/pc.c         | 14 +++-----------
>   2 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index f051ddafca..bf1d6e99b4 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -74,8 +74,6 @@ typedef struct PCMachineState {
>    *
>    * Compat fields:
>    *
> - * @enforce_aligned_dimm: check that DIMM's address/size is aligned by
> - *                        backend's alignment value if provided
>    * @acpi_data_size: Size of the chunk of memory at the top of RAM
>    *                  for the BIOS ACPI tables and other BIOS
>    *                  datastructures.
> @@ -114,7 +112,6 @@ struct PCMachineClass {
>       /* RAM / address space compat: */
>       bool gigabyte_align;
>       bool has_reserved_memory;
> -    bool enforce_aligned_dimm;

This is also mentioned in a comment in tests/avocado/mem-addr-space-check.py 
... it would be nice if you could update that, too.

  Thanks,
   Thomas



