Return-Path: <kvm+bounces-64860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CB0C8DCB3
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 11:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E4E95351D82
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 10:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1408E322C66;
	Thu, 27 Nov 2025 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxGZefJg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C00D79DA
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764239705; cv=none; b=XronhUQ73NkyDC0/MBr/+0ACpx52sQ99ftrxLyUcxm3/an6eNJxyDG8Wx+AC3FX1y1lXosQSeaOsF6yHcS6Tm2egxhm0SMRmiURj2pt7StE6DSP0sTrGjLXM3ffp/UEiZ1ROmSBh0du3HUj7z5iXrdglKqpxBEQZLs3k0NO8f2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764239705; c=relaxed/simple;
	bh=DpiI8GgMDHD1LVQiscwaq9jAgParWgWZMDwjFqItjQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RYxjBKkw3aCMXCQHsa1ylQE5094BewMQFU8y0+QS8rQoXbiQn4c9n09Aa8m4wa1h2KRJmM0nwBu4nSXp2F8PccfQHZTzu5inRs5mDI+XaIB/pWo8xvKaTWJ5fp2qTQajiLv7LkpQzeMmEZmCNC1D9Z307Aoragts+rP9/atIQV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxGZefJg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764239702;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tiBBX2HMY2n/AxbltWad/ANX3RKH0tf+SEsscaE7SL0=;
	b=TxGZefJg0l9wxcHwI+W7ioFed2CQXLvf6ReDSu3dflMQAlz87bETyDZ/uwJ9pbeOnarEdg
	ZCrii1UeTNKno/Oqn/Wq6Fy8cOFozboup6CyR4YN1B1uFY10HJt1KOruQpP5/03JnhLGSe
	L0Um/gc/dHlkBN7NMu0VPT9CE3lGh28=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-Mrcdso2hNMyDLirj5rxFuw-1; Thu, 27 Nov 2025 05:35:00 -0500
X-MC-Unique: Mrcdso2hNMyDLirj5rxFuw-1
X-Mimecast-MFC-AGG-ID: Mrcdso2hNMyDLirj5rxFuw_1764239700
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88050708ac2so15394006d6.2
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 02:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764239700; x=1764844500;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiBBX2HMY2n/AxbltWad/ANX3RKH0tf+SEsscaE7SL0=;
        b=PYucW/taXWjt7OFY/ylUSIeDidSwNJF5wIDUgajoETop6xgvMkDu/w5uxtJpKSJZAN
         6DBUUyM4fz2H1FocsHWdaSNiEqlJIUC1M/Wl3RKaeT4iZLISpGE6EoXOgp/wmCoVm2zx
         P4dxRiKEeRXkm/izIB++U1ZGM9IqSB9tRAb2RmKyYG7uRMhngIN8PyyukVzp4PHnTOJ8
         4eySBsxNgJeplmQnvvFd3/NLl8Hfw8nT5u5wrsWc57aqp7zLJiuru1tGZ5insPdK8OST
         UrS4FVc69rutzFVD2YMzna4Vw6zc9D8F85LENliUhGHSF063W8zEYnMiCfHa61gzk5Ea
         lp9A==
X-Forwarded-Encrypted: i=1; AJvYcCWelrJTsLw7mu8zJ+Wm3lNAWYmH3n6+fXUkIDaTVRYqbu25PSQQUyj3X97T1H4N+H2SXwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTCnlsIAWWj4OJ9UD6SqNwGjATkhxiN2P2vgpW/cljUn0A77/I
	xDrm8eZOMFz2HAW1mRZ5Qtem3J+cl7Da2A4f7guMefQKnr9p9wHt3TJPtg3F2PAew8uW3aE2dTD
	alWHg3/GY1LepOfQ+9us7mNwCzUKruLqBSOEEWOXkO7pJc/yaA1Ptvw==
X-Gm-Gg: ASbGnctJfXInYK7U73byQNzjRG1UT4ow1bl0nlYT8AHkkQRxSD9ryYUthM8ZVzm/248
	lwjxRMM9eyts+XYkmpe6c1B5hbPduZjJUbe5N0OEYXWyjZkRKQW0HKw38WLyvTaGti2StvXHM/h
	zM1QkkmAWhi2jvVF9ULToDYkgIrCNB2hkMvPTtLb9dMU/3ZQDRCaKxkNnB+/6JC6OuEo+J5jbbE
	905OyfjbjNdrXmW6gM/Jc8jfak6udcqHhyXuh5hoPiKNfdeHBKKAVs72GCGew4VCAsIfv53PxGU
	9R99RkkPVWCrVdU+G+Ll/6yE18e1IShicosILtA6Ld4eVmuMChjAFVwK6UYFbHNX+lySafBatkw
	Fkym6kHE0VnNXfKtgefgVkmQcpb8vTsmalN6YmkBC2uKR6v5Z1PzGO98l5Q==
X-Received: by 2002:ad4:4eeb:0:b0:880:447d:407c with SMTP id 6a1803df08f44-8847c4d5850mr321245686d6.9.1764239699731;
        Thu, 27 Nov 2025 02:34:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IENQI5eX5Oevifu0hA7wSdkD485RV3dcludhFKndd5LnRSAV5DrFbgSaQBSwuSBHJCvcKCXCg==
X-Received: by 2002:ad4:4eeb:0:b0:880:447d:407c with SMTP id 6a1803df08f44-8847c4d5850mr321245286d6.9.1764239699383;
        Thu, 27 Nov 2025 02:34:59 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b4ac25sm6980896d6.28.2025.11.27.02.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 02:34:58 -0800 (PST)
Message-ID: <6e735f02-dbd6-4807-95b3-4043049d4557@redhat.com>
Date: Thu, 27 Nov 2025 11:34:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 10/10] arm64: add EL2 environment
 variable
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-11-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-11-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> This variable when set to 1 will cause QEMU/kvmtool to start at EL2.

Misses the Sob.

Besides Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 858333fc..2a9c0de0 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" = "1" ]; then
> +		M+=",virtualization=on"
> +	fi
> +
>  	if ! $qemu $M -device '?' | grep -q virtconsole; then
>  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
>  		exit 2
> @@ -116,6 +120,9 @@ function arch_run_kvmtool()
>  	fi
>  
>  	command="$(timeout_cmd) $kvmtool run"
> +	if [ "$EL2" = "1" ]; then
> +		command+=" --nested"
> +	fi
>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else


