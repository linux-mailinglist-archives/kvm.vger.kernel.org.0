Return-Path: <kvm+bounces-41177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 379FDA64585
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C9F116B3BE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03703191499;
	Mon, 17 Mar 2025 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGnwQi4U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E69220680
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 08:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742200262; cv=none; b=EzdelcyKupg09iDfDFMvxlNERnfWYXEUxJ3G+VvhJdb+PYBnbObaq4teiLRXOovg/Z1Vp4No89VsHfjMs1AmLeU8vWzlSin39ONaXmh4XvH3RONfmc1DJDqH5l8inPv37WU9E2nrEavxM/sZL+BZhQ/gfNW3m0DSOzeQbaLHFqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742200262; c=relaxed/simple;
	bh=Xn19XTUr5ev5X1WgzYXlLi6OfNH9omI0wHFJgrgHR4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDJ6OEXd1SCZLTH7rPY/kgcM5L4+5rkLpbdAJ6VSJ5NBgXjbv6a9o5m5avFS9ljCIg7PLENK9QAz6wC9IRsIfW0AhdNGxqG9MX2bULfvovxl35TthfeUYzUxF4GOVeiTHljM+QcDzGGfmgjFrQRaE+ITqHUD4ED5cpQk4hwI7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGnwQi4U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742200259;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1e1w7vkGVe2zlHjiuKVaRcK3voy6SpJyKXoctlZSYQI=;
	b=gGnwQi4Uld/CwUHGsjeFf+IqdbFLJ2VFQPGirBb3g3nG+2fiW7n1p73ucQl3TjusxLj0Cr
	wKfAhEDgkAyDB7w6Sh1wtg44yLuAPVYE+OihpKPyxHLB62ebH4mX/vuHDIbBKWK1cA+G24
	gRpVWrX53y6FtjGxIeboFcPhlJLF640=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-uUNhvSR1PyGwWNXpSzfnPg-1; Mon, 17 Mar 2025 04:30:57 -0400
X-MC-Unique: uUNhvSR1PyGwWNXpSzfnPg-1
X-Mimecast-MFC-AGG-ID: uUNhvSR1PyGwWNXpSzfnPg_1742200257
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ce3bbb2b9dso45850255ab.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 01:30:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742200257; x=1742805057;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1e1w7vkGVe2zlHjiuKVaRcK3voy6SpJyKXoctlZSYQI=;
        b=K6pntXgJAs3OsgYFjTmpIkSxyFAvzaEV+x5GUi6/8F3eV5916QSUpnOyu3BqqEOLuq
         er5hUBRIyfvi0LN10UPTmvRlwz2IHVVkTrBijtHwkFIHB4nOeX0mzE3p2zJgbCmJEjw0
         +Int1WuZ8YZk+Sv0g/D3qJgS8abOfQHsskRFDw43p6MzG6B+5n7oKUghchLtHL+o2Ljd
         DBlljatrVNggjVbzPhvdNuw2/S/+MO/aoEiUDl/2apIZBV+WHm/i0pkwFdbm4wDBgvLq
         MHArwMmKAsUB81sAQT7zWMHSArpaw0f/kUAgZgbOhTe4b6+OpsoDOJ6kP4WUgsZ7h2sN
         m0Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUa1VmfdLxxMr7St2rmwT+pLsa3NxxiU2ivD4ldip3o73aMx1g3ZRnrTt/RZVWwa1tBJO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKAyXvbjNrrby52mE5pdX79k+54Dj/Pe057kqNK7GALEcg40mK
	T37AEcioNx7JUP1uCe4qdVyVRh3XeyxTiH5CVSooW8bJ2CpT1+4pbgAM9WDcyx3x+6F/f3d5lzT
	6e5zn6LWR9HGNk90/ltGlxvT3oSZCtkNNp3nDyOBOdUA5cclcSA==
X-Gm-Gg: ASbGncturiBPAnE9MaV69DlWKShw7RiozbRBbWYpwrj3R6g5RfU2IHX/I7UuLaJU4D8
	fmx8B83dNwuXd18vLUIzN3rxwTKNp9ghXnUg9L47ajzB78sAGbOdeJ4dVne7ae16iKlHcWRnAZ/
	z/Nbfgqh7okVAG8i17naySZalrV0tcczjwayrUTHjXo7WTMJeaDpxcyAEIJL2vvJrGGzyKnJltG
	9wiCP9QHyFKK/MgLLgy9Jyskbd/OmXw+fYzpcP64LEqDG1OpHjMa7XB5RaZAvz2mAk7Gw5bPm+L
	lKTi/mm8PvhjUboVT2QH4xMifH/o797WpIJ1/62NgLAXn9NbqBnrpJ+WOZssJdQ=
X-Received: by 2002:a05:6e02:3285:b0:3d0:bd5:b863 with SMTP id e9e14a558f8ab-3d483a82c1amr138000845ab.20.1742200256993;
        Mon, 17 Mar 2025 01:30:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHWx2BOAFHAQf6kpPdPpo9RU9ar3l1mcm+p8VJlq5wP/AXtSk7y90EOST3/f9LTxyG//NWIw==
X-Received: by 2002:a05:6e02:3285:b0:3d0:bd5:b863 with SMTP id e9e14a558f8ab-3d483a82c1amr138000645ab.20.1742200256699;
        Mon, 17 Mar 2025 01:30:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb2b2sm2162086173.94.2025.03.17.01.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:30:55 -0700 (PDT)
Message-ID: <312bfffa-8e91-4b64-b88e-c9868a59d7ec@redhat.com>
Date: Mon, 17 Mar 2025 09:30:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Display the
 correct default processor
Content-Language: en-US
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-4-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-4-jean-philippe@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> The help text for the --processor option displays the architecture name as
> the default processor type. But the default for arm is cortex-a15, and for
> arm64 is cortex-a57. Teach configure to display the correct default
> processor type for these two architectures.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
*
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

*
> ---
>  configure | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
>
> diff --git a/configure b/configure
> index dc3413fc..5306bad3 100755
> --- a/configure
> +++ b/configure
> @@ -5,6 +5,24 @@ if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
>      exit 1
>  fi
>  
> +function get_default_processor()
> +{
> +    local arch="$1"
> +
> +    case "$arch" in
> +    "arm")
> +        default_processor="cortex-a15"
> +        ;;
> +    "arm64")
> +        default_processor="cortex-a57"
> +        ;;
> +    *)
> +        default_processor=$arch
> +    esac
> +
> +    echo "$default_processor"
> +}
> +
>  srcdir=$(cd "$(dirname "$0")"; pwd)
>  prefix=/usr/local
>  cc=gcc
> @@ -43,13 +61,14 @@ else
>  fi
>  
>  usage() {
> +    [ -z "$processor" ] && processor=$(get_default_processor $arch)
>      cat <<-EOF
>  	Usage: $0 [options]
>  
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch). ARCH can be one of:
>  	                           arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
> -	    --processor=PROCESSOR  processor to compile for ($arch)
> +	    --processor=PROCESSOR  processor to compile for ($processor)
>  	    --target=TARGET        target platform that the tests will be running on (qemu or
>  	                           kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
> @@ -319,13 +338,8 @@ if [ "$earlycon" ]; then
>      fi
>  fi
>  
> -[ -z "$processor" ] && processor="$arch"
> -
> -if [ "$processor" = "arm64" ]; then
> -    processor="cortex-a57"
> -elif [ "$processor" = "arm" ]; then
> -    processor="cortex-a15"
> -fi
> +# $arch will have changed when cross-compiling.
> +[ -z "$processor" ] && processor=$(get_default_processor $arch)
>  
>  if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86


