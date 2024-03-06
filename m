Return-Path: <kvm+bounces-11161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00146873C72
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C63C28824A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CDC13A26B;
	Wed,  6 Mar 2024 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILOz7FdH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688713791A
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709743311; cv=none; b=EtJwcVuAjFR1fTZPb0eu3nLcClXvMsxIqSan+Wo2CE83rL7xEhuUKP4xj57i7r0hQL4EMp1UhTPdaE+F7LIwo6TbhGmIKgC4j59x2h+kzWlIHHDSA3bv8qjhZEa6O+ZabwZdoE9XT4MuaNkNXIOwDq6ukGYOa7YWHauF2oV9CGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709743311; c=relaxed/simple;
	bh=waEnAVsLhKyLwqQidxLz8WvxLo/eMJMdN0ZXTVP9W5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/c7kgfk01FpuOlDl3ud+jvMaBUafF2caNHj240VFePmF6SQzgIW7Zp5oz3+7amxx/XQ48zsQLr29umHjwt9APSBdIa25CyzDXuF7Zie8dbh6p2zWsVlod7I0hp7LkQwBFLuRfQ5gLsxCXN90I6JO/K5Q18dKiNwvfkcP3dI+d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILOz7FdH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709743308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V8VOOJzg7EU1rcgDZalKtXvCRPqpjoeKlonHGIvbJe0=;
	b=ILOz7FdHGd1Rw7D9fw5cbPHFCxB4fWvlhlat5QavHesW5HWyZ33FFN49fgxfLxC/SZt8WW
	MhX3itJTAkOIzyPNsRnCihzEv8eWtkSjDHl8p99GMH6uucIEEFCUt30jarzSYRiqkBnz3G
	GFdRZ/ziV/JrUB+OT1pyhKyt20iMSEU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-Hu1LAU6wNF2LGwjtqa-OuQ-1; Wed, 06 Mar 2024 11:41:47 -0500
X-MC-Unique: Hu1LAU6wNF2LGwjtqa-OuQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-558aafe9bf2so7376108a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:41:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709743306; x=1710348106;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8VOOJzg7EU1rcgDZalKtXvCRPqpjoeKlonHGIvbJe0=;
        b=TFix/suPv9D0R5FRzsWss4A8olCYW8PsycOTSltJRrBEIym5Xa6YWiadNFLgU6vph1
         pBqowVL27P80xnq8ssJDy1tT1MukPPf3j2QL/I78jIqm5aUEKdziUVfBBGbEO3uy8N9T
         x2321YcqMN9dZ+PC23O0fW8BJ9rAt7zv2+gqvdcaeMps+lTwzqWhrMurYkNYHBmstqrQ
         gz1KT77eoXOVjXv88x23/kMJy0amAhn9R55gTTjRoqKtbj8B/EAXSHhyL/5E4kjZHGdy
         S3AOL1bPGDpBaHhUGiFDOe4EeZgjC9LsOAxMXt1SKU87VRALPxdsNtVUL8CWfnheh4Co
         4gUg==
X-Forwarded-Encrypted: i=1; AJvYcCVocJmR9bsg6B/AejujP8egojyhdlyLf3YcwPvrSriXNX8xhSn4aH/cW8tmSr9NlA+HQIriD9fppU4LmecRFttAn4Iy
X-Gm-Message-State: AOJu0Yy1VI3KunGP+M+azabzCNveb1DW0ILiDKr9aJK77za+vX6XmB1O
	GaqtFdaTd1LZOx5G6KRWcMBtvLk/IPwnPhCHqBkMYoodwGnaPyJJsGPnlf9A/KQFmpvp1h7pOTI
	PjlOHPw0uP45iYiVA9e7VNdl+oCL9+XN1KFze8+rOKgIBUmFbtw==
X-Received: by 2002:a50:8d86:0:b0:566:825b:98 with SMTP id r6-20020a508d86000000b00566825b0098mr11232267edh.6.1709743306155;
        Wed, 06 Mar 2024 08:41:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEL4qHcVN9nkeyWoAJu9LMysctnxQMaIsiMCnnrKmreq1AJI22WOebtuymhBjq2UGu7Q7XllQ==
X-Received: by 2002:a50:8d86:0:b0:566:825b:98 with SMTP id r6-20020a508d86000000b00566825b0098mr11232254edh.6.1709743305859;
        Wed, 06 Mar 2024 08:41:45 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id s12-20020a056402520c00b0056691924615sm7068330edd.2.2024.03.06.08.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:41:45 -0800 (PST)
Message-ID: <571fb716-2f13-4ad7-b47b-8104ec46d1d3@redhat.com>
Date: Wed, 6 Mar 2024 17:41:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 01/18] hw/i386/pc: Remove deprecated pc-i440fx-2.0
 machine
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
 <20240305134221.30924-2-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> The pc-i440fx-2.0 machine was deprecated for the 8.2
> release (see commit c7437f0ddb "docs/about: Mark the
> old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
> time to remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   docs/about/deprecated.rst       |  2 +-
>   docs/about/removed-features.rst |  2 +-
>   include/hw/i386/pc.h            |  3 ---
>   hw/i386/pc.c                    | 15 -------------
>   hw/i386/pc_piix.c               | 37 ---------------------------------
>   5 files changed, 2 insertions(+), 57 deletions(-)
> 
> diff --git a/docs/about/deprecated.rst b/docs/about/deprecated.rst
> index 8565644da6..6d4738ca20 100644
> --- a/docs/about/deprecated.rst
> +++ b/docs/about/deprecated.rst
> @@ -221,7 +221,7 @@ deprecated; use the new name ``dtb-randomness`` instead. The new name
>   better reflects the way this property affects all random data within
>   the device tree blob, not just the ``kaslr-seed`` node.
>   
> -``pc-i440fx-2.0`` up to ``pc-i440fx-2.3`` (since 8.2)
> +``pc-i440fx-2.1`` up to ``pc-i440fx-2.3`` (since 8.2)
>   '''''''''''''''''''''''''''''''''''''''''''''''''''''
>   
>   These old machine types are quite neglected nowadays and thus might have
> diff --git a/docs/about/removed-features.rst b/docs/about/removed-features.rst
> index 417a0e4fa1..156737989e 100644
> --- a/docs/about/removed-features.rst
> +++ b/docs/about/removed-features.rst
> @@ -801,7 +801,7 @@ mips ``fulong2e`` machine alias (removed in 6.0)
>   
>   This machine has been renamed ``fuloong2e``.
>   
> -``pc-0.10`` up to ``pc-i440fx-1.7`` (removed in 4.0 up to 8.2)
> +``pc-0.10`` up to ``pc-i440fx-2.0`` (removed in 4.0 up to 9.0)
>   ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
>   
>   These machine types were very old and likely could not be used for live
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index b958023187..3360ca2307 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -285,9 +285,6 @@ extern const size_t pc_compat_2_2_len;
>   extern GlobalProperty pc_compat_2_1[];
>   extern const size_t pc_compat_2_1_len;
>   
> -extern GlobalProperty pc_compat_2_0[];
> -extern const size_t pc_compat_2_0_len;
> -
>   #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
>       static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
>       { \
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index f5ff970acf..bb7ef31af2 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -311,21 +311,6 @@ GlobalProperty pc_compat_2_1[] = {
>   };
>   const size_t pc_compat_2_1_len = G_N_ELEMENTS(pc_compat_2_1);
>   
> -GlobalProperty pc_compat_2_0[] = {
> -    PC_CPU_MODEL_IDS("2.0.0")
> -    { "virtio-scsi-pci", "any_layout", "off" },
> -    { "PIIX4_PM", "memory-hotplug-support", "off" },
> -    { "apic", "version", "0x11" },
> -    { "nec-usb-xhci", "superspeed-ports-first", "off" },
> -    { "nec-usb-xhci", "force-pcie-endcap", "on" },
> -    { "pci-serial", "prog_if", "0" },
> -    { "pci-serial-2x", "prog_if", "0" },
> -    { "pci-serial-4x", "prog_if", "0" },
> -    { "virtio-net-pci", "guest_announce", "off" },
> -    { "ICH9-LPC", "memory-hotplug-support", "off" },

I think you could clean up memory-hotplug-support for the ICH9-LPC device 
now, too (in a separate patch).

For this patch here:
Reviewed-by: Thomas Huth <thuth@redhat.com>


