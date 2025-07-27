Return-Path: <kvm+bounces-53512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF98B13123
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1229E16335F
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B2A223DE9;
	Sun, 27 Jul 2025 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qlDB3QF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DF37080D
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753640381; cv=none; b=SxqEljQAsTc37XrBDxcEcOwHPdEL7DSvAZqiqRQ+C4DCAXLO46sX0zZbILzn9CuQJk0maikn4uLSk1c6k4DDnBfTwoXj8JME+hO4ebR0N/kPuAKkJkQ3/iYoJCr5pUO3yJsNxeYAkB1uYk/EVvVYTgNKuf6FRVyg71bAGJY4dic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753640381; c=relaxed/simple;
	bh=APgS6VGEdvJdOGKM9bhuUehMeZT/sRX2bnLIHUsxGXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D93OnfcVOD67HIbRRLa7bhUO6lPmo2eqdUK1o65fVwoFX9Ydr18lFRzhblSYLNcCklvUm7Lpgh5KoIaB6Gm73UXmGns7hamPpjmKTolCzyPcXfn0jFvuN3MRTd9pogOANy3UibzcRGGb8EeuUCtuZ4+xkNOp3kU3Eqb9FbyVbjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qlDB3QF0; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4561b43de62so86745e9.0
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753640378; x=1754245178; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q0M8fsrWrwY1LbS2E8opsAOuwLoDMCajZwvtOZXJQyY=;
        b=qlDB3QF0tScQmIYe7s1mGNwHnWjHmCOMmYX1xuAlMGjGqMzrzN62VX/vZSFk6aQWKf
         g52lOlseBIhzIOMsWjyEa9XT2uaD3JkNC2WI4+iiVNoXRtA+vWj8+QjRvjVVopmgS3ys
         qdZIChdtLBJDToHgOQHkSb79TUNel8scoLegvOHvlYk/Q2njnaIj7vg0wOpQ9vtSuzEK
         MT/CXSLpWesXbbqyuDPaZKSrvkbB7fjsAPgInetZmMcwQeKtRXAk1Ue5QrrUkybwAaIL
         S8ITwGkWdKn6JoDXDFMH/E5vjhMLnG1SoznByE7dLEdndauTOQ74m+M+6tE3zu5KuRuX
         1Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753640378; x=1754245178;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0M8fsrWrwY1LbS2E8opsAOuwLoDMCajZwvtOZXJQyY=;
        b=qFCdebLiu61qUXM5C5q02FjKfokVL06m0phz7F5wsAzB+AruxetR8LJqNj3uimI7Ev
         uKzlXbPesiZwrW4Psfs1fSw0F1esCZ4McQx3GXIE2xXXOLOY8VBi8/FiUIDy/wUjJFIR
         A1ev48IdN4+C5S+8A/D2OfFK15WmOX+so3FdosaaVBH28/hErAO/arBl6ZHrH7Mzgr+b
         TRzIKwmG4VlelOcFm9ITByj1tea6F8RALhjLOeZ4/6mz062gL4EU0wGu1PWygb2i1i/4
         Q+wDNDDPQropjIIrKcHgtyiRJPd7N1PVA+3/mMeU1O6Sk8ZXPKtTdrqWWpZiInQc4sGY
         2Szg==
X-Gm-Message-State: AOJu0YwPsv8xjnCAaO9wK4U8u99RinYP+dRTJ8CSE+JFahG4ztd+8jna
	ybjrg316bzv/RuhI03Ee9Wp+gGuVmQPZX1GNNHMhd/CNus7MXK72P2xsfXpFD9PRbA==
X-Gm-Gg: ASbGnctUPsUP7gPHisxqcBgykZQQiYqBI0oIUmv/c9Hxt+GS4lu+1XCV8rdbS6f58pz
	n/hW5APio99FXPZP5d3uPD/PqTP12Nx9uB/DkpOJ0SuvG8mW5sqGd1NR2DYxsiNZV6Q3E1DEQme
	9WZm/bUg6Vcybd4igw7vO+UnTHrJpm0NyksodSlD1EncGRFZvblhIDfO9CdYYSQCFikHx3kkVTE
	Pi4Jo2A9vXx7TyrsB59JUCR1/F01kWEagQTXewfGCsTM96s7GMBd4gnv9dHz4bTNvZRlZGbf41x
	KVqjuaIE0R01mFh8k4Elj2B0CVLej/hu39L65Ax3lRLqex0RuDfFwFFvahm1LXSzjnP5ATPVGhV
	0GxiG5ge0SsXV0wbmmIxgiJPlUkmaeOU2JhCKLzjMWQT8HEyQVD9nvxNFO0K1/fyKZg2D
X-Google-Smtp-Source: AGHT+IGWn4UljXAVQh1tPhh9y2lVmnGXIlW5tJn5QmVwy9yex4NSPQCowiAIBfpR4y3rbnE335azuA==
X-Received: by 2002:a05:600c:3591:b0:453:65f4:f4c8 with SMTP id 5b1f17b1804b1-458833afd98mr999075e9.3.1753640378155;
        Sun, 27 Jul 2025 11:19:38 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705bcb61sm124186555e9.20.2025.07.27.11.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:19:37 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:19:34 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 01/10] vfio: Associate vm instance with vfio
 fd
Message-ID: <aIZttsPmeU4TkEci@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>

Hi Aneesh,

On Sun, May 25, 2025 at 01:19:07PM +0530, Aneesh Kumar K.V (Arm) wrote:
> This is needed for followup patches
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  vfio/core.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/vfio/core.c b/vfio/core.c
> index 3ff2c0b075df..c6b305c30cf7 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -9,6 +9,7 @@
>  #define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
>  
>  static int vfio_container;
> +static int kvm_vfio_device;
>  static LIST_HEAD(vfio_groups);
>  static struct vfio_device *vfio_devices;
>  
> @@ -437,8 +438,19 @@ static int vfio_configure_groups(struct kvm *kvm)
>  		ret = vfio_configure_reserved_regions(kvm, group);
>  		if (ret)
>  			return ret;
> -	}
>  
> +		struct kvm_device_attr attr = {
> +			.group = KVM_DEV_VFIO_FILE,
> +			.attr = KVM_DEV_VFIO_FILE_ADD,
> +			.addr = (__u64)&group->fd,
> +		};
> +
> +		if (ioctl(kvm_vfio_device, KVM_SET_DEVICE_ATTR, &attr)) {
> +			pr_err("Failed KVM_SET_DEVICE_ATTR for KVM_DEV_VFIO_FILE");
> +			return -ENODEV;
> +		}
> +
I think it’s better if we get and print the error code of the ioctl in case it
fails instead of masking it as -ENODEV.

> +	}
>  	return 0;
>  }
>  
> @@ -656,6 +668,16 @@ static int vfio__init(struct kvm *kvm)
>  	if (!vfio_devices)
>  		return -ENOMEM;
>  
> +	struct kvm_create_device device = {
> +		.type = KVM_DEV_TYPE_VFIO,
> +	};
> +
> +	if (ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &device)) {
> +		pr_err("Failed KVM_CREATE_DEVICE ioctl");
> +		return -ENODEV;
> +	}
> +	kvm_vfio_device = device.fd;

Do we need to close this file in vfio_group_exit()?

Thanks,
Mostafa

> +
>  	ret = vfio_container_init(kvm);
>  	if (ret)
>  		return ret;
> -- 
> 2.43.0
> 

