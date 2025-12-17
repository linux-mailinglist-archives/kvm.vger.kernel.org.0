Return-Path: <kvm+bounces-66185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DE522CC8F10
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 18:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DE15B30022EE
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 17:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AE433D6FE;
	Wed, 17 Dec 2025 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GgiOi410";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfWGWoVB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E4D2874E0
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990917; cv=none; b=LmhZADITQSsGFtdbE7p9zQb9zJl+Lpusfe/8xl5zwP1q2tPUMjcMVgXpy/uD1AuTfmuNevzxlBrPafd1MUHDYw2qYn9c6uLr9h7Ty/yJnxqfCfbY2bcwFvQRDeknAiZT0FxfWOH4+59foTeZwhV2ZVJiEK9GY9dt5Ux2RU5T/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990917; c=relaxed/simple;
	bh=2D02SqJKD+nsCsJr8M1rCApsCcKMVZUyPH+0iU3i6ZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0/8Y7PiF1hjV3mMSuXwAmlsQVkx4qSxLWJVQNn+cnQOF0i+GvCNnjKUlZ7IbHKTsaG1MYiEBqArMN/hMiG1cVm2dvG8dVre97CsphjjlNQV5sWjAzgcv9TUIZDe80+gMC7IynDSqC26Vuq8E7tS9bRd7bpCvRNV/Mm1Cp/phok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GgiOi410; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KfWGWoVB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765990914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
	b=GgiOi410rEbM5qoh/XTgGkX/2ZM8cxiJKvdhhAKca+n703m1yATjSO+iiMY2hgCJKLcD5a
	V6l0XS3C+3vZuVAUcvzCfeypZy+oofZloa0xYY92M8/He1rFiEZuBZyzZrrjmLE10itg4U
	KHfAHiuKHBEkz2e3Jdv7x7RwgmQkozQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-Odeky_j4N2qIk09TwwcyTQ-1; Wed, 17 Dec 2025 12:01:52 -0500
X-MC-Unique: Odeky_j4N2qIk09TwwcyTQ-1
X-Mimecast-MFC-AGG-ID: Odeky_j4N2qIk09TwwcyTQ_1765990912
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43101a351c7so2976348f8f.2
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 09:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765990911; x=1766595711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
        b=KfWGWoVB/l6mxGUtQdYJe6v0cGKG6MK4aIQ45f5K4IPOpgUkWjKS5X7i4dZgAg+fPi
         +QhOK3g56CelitpLkjJ4o77TeDMC9OoT5AExk9Iq3SL2XUAxZLCtB2xQbi2wPjVNZeFq
         VPA4UnXxe6s7uB4qiV2SUPoPIRmYgcJYTp1xS9NyHhI2ql0oyQRFxUEF6+QTETg0akif
         5qTKrt7DywoVakjGzvhSFMpgLqiUacbdk1eX6loJbrfqhfFVTf74j872IUymPYcoO3On
         vKAi8kWiPDcPjT5oKxfuc+V+BC0Dl0wKz3s9zLGYJyTaxQILAF8UgHwTOLvrvLvivk6o
         xZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990911; x=1766595711;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dD5nFNFh+CHq/nzULmKKE12yIQGGBSkgJsl56ofghHQ=;
        b=ub/ZkW5M1s1SJfVZ+Rx9KTgSe3t4RdKe+YBHdOe9SIyzKgGd1BVyiQvMI+Frb54SZ0
         bH+DvjXSgdMgtAIybbmC858laMTr2QyrTslk3RSdPTsgYXxV8cWQ/lobUFqLK84yD0hc
         Ns+ltbDWq4suB/yl1OGZo4m8fUnTfU6G756hP8jBFNs2DImwjX78UwIhcfzO/ieo/XV6
         8HAORx+O7HaK+QX3dzBSrv/SiBmrGh6FxlqGCAOLdXOjNDDslwksD9UagZ9ldohhNC47
         Nqto4LQxMqnrXzi/5S0ugBV10lOdj3B13eNPzz09+wP4bwK4y2LJ+otpUDC93RtS8xeF
         qeRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx3bmDtmfhAXJFspPFrz9YYH06LJFwxg0SL9db4boH2+EC+4gciovGYsmNXfsVbJ43qs8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyfuap/Dpd/TFp+yCiBkXN++MhHoVlvfAfRVuk9H0GG4qyX/Ey
	jDpLXNrsj6kZnQjrDexkbqSRCvSV/lGfUtYCpCNyjE636FtPoCCn5QD31o/UCtXsZvDmys2Nd7p
	GAeg+NCktlAsoO1RLASnr5pPx33PPtTvdb0e2wculc/K9/hjgz5Zv8w==
X-Gm-Gg: AY/fxX5iYwNSGJKVg0eV9m+8TnRCRFyUZ7O3+btM6BzpJlpjvS7HIiZ/hE2hosNH9kV
	15B/+64PcZLIVXwK/usEmpkP+emtUYTIW9+QZviCddTrlu7Z33JVtgB54JxwDwC1qqJ7Ag+uyyl
	rTPgXyIL2bxUERUj+oyvG9by0OIFbUe3wZ8g3JyxwlQdUAgCt8sYmaew71sTR01f/+UXcTiTxsG
	7xzwavvoWJ0wgtyYGV4NGclXdOjRWK0XP0AuepxM8Pku+KuN7+2HTzeCrYirFgNJ8FudaBikd2Y
	o36xXmEat/xFn1r++cxh3aAmo0yYGauM+UIbSJBKgYxzsh2rQAUFmtKm91q3TGLSeZQoqdqYgw/
	+Rm+a7Hxib2TavCEIEwGHaq/AEFkKQpw51u6PHNK/KXaCsVyF
X-Received: by 2002:a5d:64e6:0:b0:430:f5c3:39fe with SMTP id ffacd0b85a97d-430f5c33c72mr16059991f8f.4.1765990911447;
        Wed, 17 Dec 2025 09:01:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7naa2xfBN81UFldN7VJ60YMv46kr3qq+t2tP1xJU0lrdjUCzUiNloJ8sGrQh5v79JlM1s8w==
X-Received: by 2002:a5d:64e6:0:b0:430:f5c3:39fe with SMTP id ffacd0b85a97d-430f5c33c72mr16059928f8f.4.1765990910912;
        Wed, 17 Dec 2025 09:01:50 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244949ba6sm34714f8f.19.2025.12.17.09.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:01:50 -0800 (PST)
Message-ID: <9d06837d-7aed-43ef-87c2-1ce4f921dff2@redhat.com>
Date: Wed, 17 Dec 2025 18:01:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To: Nicolin Chen <nicolinc@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Vivek Kasireddy <vivek.kasireddy@intel.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <aQpRz74RurfhZK15@Asurada-Nvidia>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <aQpRz74RurfhZK15@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Nicolin,

On 11/4/25 20:19, Nicolin Chen wrote:
> On Sun, Nov 02, 2025 at 10:00:48AM +0200, Leon Romanovsky wrote:
>> Changelog:
>> v6:
>>   * Fixed wrong error check from pcim_p2pdma_init().
>>   * Documented pcim_p2pdma_provider() function.
>>   * Improved commit messages.
>>   * Added VFIO DMA-BUF selftest.
>>   * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
>>   * Fixed error unwind when dma_buf_fd() fails.
>>   * Document latest changes to p2pmem.
>>   * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
>>   * Moved DMA mapping logic to DMA-BUF.
>>   * Removed types patch to avoid dependencies between subsystems.
>>   * Moved vfio_pci_dma_buf_move() in err_undo block.
>>   * Added nvgrace patch.
> 
> I have verified this v6 using Jason's iommufd dmabuf branch:
> https://github.com/jgunthorpe/linux/commits/iommufd_dmabuf/
> 
> by drafting a QEMU patch on top of Shameer's vSMMU v5 series:
> https://github.com/nicolinc/qemu/commits/wip/iommufd_dmabuf/
> 
> with that, I see GPU BAR memory be correctly fetched in the QEMU:
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 0", offset: 0x0, size: 0x1000000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 2", offset: 0x0, size: 0x44f00000
> vfio_region_dmabuf Device 0009:01:00.0, region "0009:01:00.0 BAR 4", offset: 0x0, size: 0x17a0000000
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Do you plan to provide P2P support with IOMMUFD for QEMU ?

Thanks,

C.


