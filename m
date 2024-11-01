Return-Path: <kvm+bounces-30310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A87D49B9373
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32B59B23709
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135BA1AA786;
	Fri,  1 Nov 2024 14:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cn2Mnfum"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E71A4F12
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730471892; cv=none; b=YOYg90DvIzbg2KKWsNQr9dB7GTJoezytoAIY5ml9/3a2/ByblCpEFIHjNuRBUOpL8oKpJL+qzsIxQxPjPVWHlWfuN8v8e/Hn+H3UBm3G41QQePfP+fXB2WRLsMxgdPPekhwqw/Crx0xS8pSjUVI4aVDSzCks09x2OQ9rDyZUnM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730471892; c=relaxed/simple;
	bh=AjV3KOmTQnBtBgqgDRTdiS8Vk+F9jjcQQcys2nNY5GI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=paHEP45bzGswos/iBk3xLioeRccTvm8ecXD0ieM12OcHwW2oUzCYkIpwUv8Yowwr/BkC7Jiaw/QppSwTQ83P8oah5JGH8lJteB8nIEiUN5/8eDWrl3Ksg5DgOoUMPHo9n6jqKlc7ZRpoa5R6zjSDAxDHccQ6RNSXvkZJX/2Vbps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cn2Mnfum; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730471888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qV7dwY45yM9S1ZYcLQd9U+2DZJRTGxY0iWGmYsPKj1s=;
	b=cn2MnfumRSuDVm3xnzo+7fcTE/4Ia7hGpr4W3cK0rLQbBvVaz+HW1Vmitr070pzQ2AaZij
	2SEqvl18kAHXTc1YTEv9vT1PqvzHgmCxg4ExHWFGE71P08dg+7CCZw1h4cryk/EPbiHv5c
	3WPVkeaKE9UPVIaa4qWGObitKFn0Wvg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-trfHUnvIMzuvYCZ5mG3dFQ-1; Fri, 01 Nov 2024 10:38:07 -0400
X-MC-Unique: trfHUnvIMzuvYCZ5mG3dFQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4da5c5c02so1794235ab.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 07:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730471887; x=1731076687;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qV7dwY45yM9S1ZYcLQd9U+2DZJRTGxY0iWGmYsPKj1s=;
        b=I1Wx9NNmXL78ZIDcHJ3xqHQxauzwtwCm2a693ur/SbjxVqnSk1NMnNP9BrOh42pKyv
         LKLcgHAG7GKHM4RjM5Ve7h7GmA9FLqgr4pvAnBiYgmTykUZwfHM5Ghun8n0n+tQKdelp
         92vk5e/AnxHUwFIp/HwaaaqRXJG0rzFseh7RuYjrg/kUrOCv3p/xw3cLXBk/XDQa5JeK
         kM4L5fvZWyVAlm8ZMWSMPQOZxdAgO9BGthEeSL7RUuKBnxkjH1nCdQLlCMlEEHCMqke/
         N4Vq+owVvAJV9hWjBQnf2VNKZswaLCC9EnzjvzyVLTcBw9lNipuaVTj7P7mXfQYu+TC4
         pryQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjnntirA//VyubVa3cyBlEAhgYog1ibZJ8b4cvAieK6TlaKprkYKfnVs15YNKHutTzMLA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuBjP/6isqZMPJI09ick5UuJTYEMERh6neuhpASivzsUSBMw31
	3d4SDgvSSrDx9IXHAqtgC9hKaPyXOl4UZPM/lByLvwX3nXlhcyTL4curJyPERtDi9kUDUXf9IVz
	rLPsPqfvXHroYp3ncoG7gUbs+3YGiPbuyoTArx7mlVMV5XU9HdQ==
X-Received: by 2002:a05:6602:2150:b0:83a:acc8:5faf with SMTP id ca18e2360f4ac-83b1c62fb00mr540837239f.5.1730471886937;
        Fri, 01 Nov 2024 07:38:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXJW/i7LBIXYahlsw8I7b7GzGZ4pKFWW6BKIF/t1yROBU3vqy0nknibGhVjgr7ahX2TXz8DQ==
X-Received: by 2002:a05:6602:2150:b0:83a:acc8:5faf with SMTP id ca18e2360f4ac-83b1c62fb00mr540836139f.5.1730471886606;
        Fri, 01 Nov 2024 07:38:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67bbe8ddsm83510839f.32.2024.11.01.07.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 07:38:06 -0700 (PDT)
Date: Fri, 1 Nov 2024 08:38:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <zhiw@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
 <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
 <danw@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: Add a new GH200 SKU to the
 devid table
Message-ID: <20241101083803.3418d15b.alex.williamson@redhat.com>
In-Reply-To: <20241013075216.19229-1-ankita@nvidia.com>
References: <20241013075216.19229-1-ankita@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 13 Oct 2024 07:52:16 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA is planning to productize a new Grace Hopper superchip
> SKU with device ID 0x2348.
> 
> Add the SKU devid to nvgrace_gpu_vfio_pci_table.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index a7fd018aa548..a467085038f0 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -866,6 +866,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
>  	/* GH200 480GB */
>  	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	/* GH200 SKU */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
>  	{}
>  };
>  

Applied to vfio next branch for v6.13.  Thanks,

Alex


