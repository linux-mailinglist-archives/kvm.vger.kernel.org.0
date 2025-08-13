Return-Path: <kvm+bounces-54609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 430A3B25489
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 22:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894A65873F4
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 20:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B251A2D3727;
	Wed, 13 Aug 2025 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADIeVCv9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6621448E3
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755117037; cv=none; b=JrDrcC1DfpurPN4vw6f6eySbueJd9C+BO8ugnsGYpkx4wE2Kfk5IaXHmF28m0BeJAbqpwBj/Ya8pu8HPz6lMaRgiPef2ihnFfos3mGYzNJESPAnhiIpbMFDQXMkHcKjdwsqZ+gceNCmuLPHBX7cjnVQsFerlBbR0Xmh0p1xCQ/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755117037; c=relaxed/simple;
	bh=TUWUvUZoTPLkbh4j8BITpAkVoVy6W3JXAa84nclCMwU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGPbB+fxA/UfvSmuo97kFnupcWwWT1NPHvRiASNM7RIygTRYUtOFKDx42rsf0u7t9g5cFliJQp+2RlbEPtV4xwIMCfH1ZRiz+CPwfENt4s4JVQ/k7fASeNomMOP/D+FQ1w/qbImb3+ijmi++iWy8iqPHozoK6cOSfXK2FE+WmsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADIeVCv9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755117034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ybiuLaukfgYUnCV8dSXZqE5iKES2KXuJCfBdh1/Gwr8=;
	b=ADIeVCv9/hgSEbTpBi2UkaVnVRQX/APB/T3h1lHcFJ62Nav5d3i7c4Rkf74zggmkfHil2X
	u+yYIRC4JcQqyyown/7wHkXJ4bJi2oTIRxvRzcPWN5EQROcPK2Ylz1G3uUicL9ZOpTfj9U
	FBi00KiG+Bp8Co+0JXdlEBeM3IcFoac=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-YEZj4HUHMsKkumNKN9VldQ-1; Wed, 13 Aug 2025 16:30:32 -0400
X-MC-Unique: YEZj4HUHMsKkumNKN9VldQ-1
X-Mimecast-MFC-AGG-ID: YEZj4HUHMsKkumNKN9VldQ_1755117032
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e56ffd00ccso669435ab.1
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 13:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755117032; x=1755721832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybiuLaukfgYUnCV8dSXZqE5iKES2KXuJCfBdh1/Gwr8=;
        b=Kv5SpYJSRETUEC3AJVnV/3pAZtP7EZxouEGA9jmwBwwD++okfTAuqQmjigBjoLa43I
         k8ge+OtNpykeGaj3GYJHn6vQCqTYBY1uVA7pHIDIqTu9aa/XvTHEXiLAwOzL9scHDkim
         qeCM2mxlpl9ySb4TddWYJg/Pxrlqq34MBvsFuSgfEj87fOp+7/ypRF9lU2oCNYVVnHlJ
         TRdRNk+o5Prqhcb/rliZZmvjgacnfV6jGpVO87rZvs7FeBMcxmC5zOAAg10M32KyQLum
         5NBlOO/PVwklZJgkxPT6ejYLi/WFfA4HlhwxRXvbTW+7SZNI9KAq+2KStw7KtktAb7e7
         +FHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxVdblkKGadCeRo/eWNgnsmBTY45MuNBxm5gk/YyhBhhqG66DiWNNtMgsJRfKn8+jbeCw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfOiMHSkP02/kXASswrnm6YkV3uI1Lpgp2rsLc/A1CWkVwkBkL
	MuTtZYMAedmpPbTptKhT1dwaTVhiQ5Mj11cbJchWJFfIXoAwpZkw0zaK7yg3eDy78XnrmpYBEgw
	zXNLp6xX/NGzjF1tumX1MlvODKHm21SGQi2DK5UJIYSH65xS53T1zyQ==
X-Gm-Gg: ASbGncv7100XhSZ1nBsh4T4RvwmvBzM0xmIzQ+KrZaJ8pD2Qc6+3EFzqouBeLg5d5OJ
	sbOyLy72smC38P3BJyzw/oDEaqmVOGDilQJJrr0/Ee2yrWyMnNLWP5Q6wA4FjLJzjkbTuUB/w6r
	avxoh0/IX3Wz/KxpJBvFwEuWPOTCluBweesc6rxznkD+8qY+zfd1Sr2nwiNFABJgvlZuxXHSYlf
	BlorT1BC/F44nvuRTId3PvTxLsOSSkD+86dDSp4cGeDJW6u6pNU+LjPMlfkaEjqNHnl+JTflphi
	a535w95wlh1+QL6d6Vf+MM7zHwhE8MCMy8bzNYGaR4k=
X-Received: by 2002:a05:6e02:4801:b0:3e5:6882:661e with SMTP id e9e14a558f8ab-3e568826ad7mr13160275ab.1.1755117032064;
        Wed, 13 Aug 2025 13:30:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcKo+ouYURgN6xzgrRL/vMnntYrb2krbn/TmGX1YtA8BbnW1ZDyxxp/DIRh8HDMtndTjAL+g==
X-Received: by 2002:a05:6e02:4801:b0:3e5:6882:661e with SMTP id e9e14a558f8ab-3e568826ad7mr13160095ab.1.1755117031676;
        Wed, 13 Aug 2025 13:30:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae99cff85sm4118311173.37.2025.08.13.13.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:30:30 -0700 (PDT)
Date: Wed, 13 Aug 2025 14:30:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v1 4/6] vfio-pci/zdev: Setup a zpci memory region for
 error information
Message-ID: <20250813143028.1eb08bea.alex.williamson@redhat.com>
In-Reply-To: <20250813170821.1115-5-alifm@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
	<20250813170821.1115-5-alifm@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Aug 2025 10:08:18 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index 77f2aff1f27e..bcd06f334a42 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -82,4 +82,9 @@ struct vfio_device_info_cap_zpci_pfip {
>  	__u8 pfip[];
>  };
>  
> +struct vfio_device_zpci_err_region {
> +	__u16 pec;
> +	int pending_errors;
> +};
> +
>  #endif

If this is uapi it would hopefully include some description, but if
this is the extent of what can be read from the device specific region,
why not just return it via a DEVICE_FEATURE ioctl?  Thanks,

Alex


