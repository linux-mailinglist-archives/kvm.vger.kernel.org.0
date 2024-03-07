Return-Path: <kvm+bounces-11252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B80C38746DE
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 04:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9ADB1C21A5A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A973F1CD08;
	Thu,  7 Mar 2024 03:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BeyVSVQ6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7E81BDED
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 03:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709782634; cv=none; b=gWBW39he2nA8zF2hS/U/6p2XNFAbfzdWElYBeSvmij+p+0l47BlEJ3lBTxEaUZVusZMDYH9GUOLx4vg8s/qgecaxXr1Fl/wiRjZTBz164+S0vLAljc16WgDd/1gv6ts7qmigRjy0XC7ecYxMdgAjI8Ntp9dAfRRAM5Wk0GrkTwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709782634; c=relaxed/simple;
	bh=MNm53SQI0kuLGqu7cnUf5aFHc1wwQir271s70tcHUXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cg4gvSTeHBDE6frTTXD0fc1nHEWGXlBxryFKl5FWfmmZSy++6JwTjqqb5HOi8/cxfIlTC94D8b6KT5BVVJLYB9fDeFLyPrbD5MAjSwEW+f1+sl8bNqM2Dqbt7Tdk1039uGtoW3p3B++Z8ZgR0KcFb9Le7ejJXp4/ySnfI0Ef3mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BeyVSVQ6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709782631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8y9kCMp4YZz001b3u026e4uRLCFX1x1C4NsHFxqltps=;
	b=BeyVSVQ61xAISUffp2OXKctrWRsBLZDy2/aCzex5nrpqiZrE1bSfyn9RRXCdrYh0Iqp8vg
	kqQZLxylwnR00WyDeSlugxl8NLE1+71jSUsKMesfKo4Q6bsxYQeIXH/f0NhP875fpU2iGj
	VftVcpBSjywvm6DZY+RyFJtMP2Kl+mk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-FiHp8JkcOH-58m_ohkyO0g-1; Wed, 06 Mar 2024 22:37:10 -0500
X-MC-Unique: FiHp8JkcOH-58m_ohkyO0g-1
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6dea8b7e74aso114916a34.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 19:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709782629; x=1710387429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8y9kCMp4YZz001b3u026e4uRLCFX1x1C4NsHFxqltps=;
        b=HTPs4YAbe12sIeP+0S67eMnyveymIdEWLlngpsdZVISH3Obfhgf00+coa/l05xjhFg
         7Mg56KjfpQRqTtTGP/f8wiuI+bW3tNSJWNUFyrmOg8TW7O/M8rLSozyjF/auKikKLsld
         SJhQYeEBEufKuXVYb0Tmr12+2/e5Zrec81x4LSl/4GL4T2LcLYH0HXXEanDDpCecBZbW
         YZqtUYJMZxWejZX7vJoVzB16V111G6l5M4ZsF/TVMGJHBj85kpbfKc8d+R7a83kAEiox
         3fLZPX1STuuCz56sFyFxYSw3nKUDjUww9ZWchr5bBGXxe5a5e2ktkSc/1u46fwS2jewi
         1uHA==
X-Forwarded-Encrypted: i=1; AJvYcCW09CX5QwWchkTmEu676wkArz28ZTsRv0jL3lJZMbfu35IHKRI9NPkWA43zmmzAgFdYT+O7zAooB4T21C59yvaAr7Yy
X-Gm-Message-State: AOJu0YxnXgvw1dLQJzbsiXdVggGLPIzYpy3eFhysBcpLaNN3cyXaDrWe
	xsLGt3M30CUuj5WY1tJPTETHGKX6wUXEsJGTnguwiwTeI3UGNjxEGBi0u2BtPvbU2Diw6trAVAo
	SvVjggaIU9sK4z4hlIQGYLTMoT1ffSVH1ttsi1bGt1APn52qd6w==
X-Received: by 2002:a05:6830:1649:b0:6e5:5e6:273f with SMTP id h9-20020a056830164900b006e505e6273fmr1193234otr.3.1709782629715;
        Wed, 06 Mar 2024 19:37:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmoW2Hh6h0Llz9Gx2I+5/CZotcA1DFd+WYA/lYgqW7f3nGDbhAFQDrbK4aJFPfBriXdWTlcg==
X-Received: by 2002:a05:6830:1649:b0:6e5:5e6:273f with SMTP id h9-20020a056830164900b006e505e6273fmr1193227otr.3.1709782629436;
        Wed, 06 Mar 2024 19:37:09 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k3-20020a63d843000000b005dcbb855530sm11831867pgj.76.2024.03.06.19.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 19:37:08 -0800 (PST)
Message-ID: <a3688d18-3dbf-4064-b75b-6e13875f11ea@redhat.com>
Date: Thu, 7 Mar 2024 11:37:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 03/18] arm64: efi: Don't create dummy
 test
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-23-andrew.jones@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-23-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
> QEMU command line options that have been pulled together by the
> scripts will work. Since booting with UEFI and the -kernel command
> line is supported by QEMU, then we don't need to create a dummy
> test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
> execute it to prove the command line is OK, since we would have
> failed much before all that if it wasn't. Just run QEMU "normally",
> i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
> line options, in order to check the full command line.

It should absolutely accelerate the speed of efi tests.

> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/efi/run | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/efi/run b/arm/efi/run
> index 6872c337c945..e629abde5273 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -53,7 +53,14 @@ while (( "$#" )); do
>   done
>   
>   if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
> -	EFI_CASE=dummy
> +	EFI_CASE_DIR="$EFI_TEST/dummy"
> +	mkdir -p "$EFI_CASE_DIR"
> +	$TEST_DIR/run \
> +		$EFI_CASE \
> +		-bios "$EFI_UEFI" \
> +		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
> +		"${qemu_args[@]}"
> +	exit
>   fi
>   
>   : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"

-- 
Shaoqin


