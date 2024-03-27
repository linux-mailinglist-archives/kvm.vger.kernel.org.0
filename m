Return-Path: <kvm+bounces-12896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1499188ECC9
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DAF129F90D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AB714E2F0;
	Wed, 27 Mar 2024 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hm5ab98R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612E512E1F0
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561162; cv=none; b=bhCsd+KG4P3/9c9UMdbZa92J5Zy1Te+6oNLgYa2Tya94pi+zOxxr32moOKbh0KJ4SdEEldEN87Jor/LuI7kKdwHVVHGX/AcHQsjxkdjRksBV17ART15oZ8Xn/j0rxUP3RyOsxRPDAImtcaU8qnijR3uvESSDF0UTFTLePK4y6ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561162; c=relaxed/simple;
	bh=rY+4Qi6s2hSMDUadPkGzndYTTSQBH8UinTr0ZNlbGec=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=njTISsM8DyRGmgtdH2YQO5qGd5CvnjwixQi/l/Ix7NTaiqmN8W0uI2DtgtyqtIdQxfMxfZ1rGxqpZ/2HmCX1hzba6FlOYrjbRW0kP7VTWA3CyGvsHwIi2tzG/GheDh1J2rfKzPxo5WJjoVY/1GRFEJNWBXA52tSivS59d0ZqF2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hm5ab98R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711561159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+s/5bKOADtr4YhqJM2+cgt9HQcERQGr9y8REbauQW4=;
	b=hm5ab98RfpmwxI3ahKKCqRsClGO+tsD3umUOs+UcCi3ZNhvIa5LvtG3G+1SpH03LT9U3jC
	YsmCCxo8Uh9LqXIG2c7ULjM7UmMjw4jZRIES6orcXpq8wW6SielhoD47z6VO03kklt7Vmi
	2iLg3Lzr4a6LBrOOpowNFNLv4myt4cY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-4jCU5M0pOueDT9drB9hUDg-1; Wed, 27 Mar 2024 13:39:18 -0400
X-MC-Unique: 4jCU5M0pOueDT9drB9hUDg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3665991058fso972055ab.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561157; x=1712165957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+s/5bKOADtr4YhqJM2+cgt9HQcERQGr9y8REbauQW4=;
        b=oUHfyBNFpaTwOvAgkN3eJu8Tvo5quV80jdqsMFMETR11LA/tI14++oiShbPM3sw+cL
         4gVqRMdRzhlScsmtUaN3FSZKRJgQKvM9erucrT0rzWfINrZ9qsckGyeh4cJE4E+pXNmW
         rjtdJ1iXjRDYbQSfOGSgfdIHPOU6rDG3NHKOSA54K4rTRA69wG/tQjWUeA8wj3nKAT2n
         Zd6Iv7Xh+tPJc4guFOVJf4d8D3W/021a1RPDtfZdFy0p2k7QuV8mL9JhdemsE6vX63dx
         YDxyI7fxUzSY/EBiRkh8wZRZQnLFilaINJ/MVI0pXzCLyTv+ToHDiZ/zCb1yaWSNICSC
         YJZA==
X-Forwarded-Encrypted: i=1; AJvYcCVde/qK+C5rXva7nYdQLwpME9+8b4FeDN4VPmexW5nOSJTcjrhdonk9TSKusZKMzzyxSUCJ23rj2e9T+L7WRHZ+uh0x
X-Gm-Message-State: AOJu0Yy7q2nDZmxgDhuFvzuzW/qE+u9hjJbgh80C3052l6Qdgoq2VLBj
	1gwEVQWcOJP7F5jc99Jo4noYEX2zmUGhUP603fLDsmWKkyClAqj8Vi7Y4ZU9ptAgMTWEYJMR070
	z0cLcvxeku87Va8azu6WsoNhZFkNrQ4/Klpuia3V59PXOKA5lEg==
X-Received: by 2002:a05:6e02:104a:b0:368:8ab5:5926 with SMTP id p10-20020a056e02104a00b003688ab55926mr249481ilj.14.1711561157289;
        Wed, 27 Mar 2024 10:39:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKUe8mZYkM8M8mtPHG1OIyuyZQvi/BjfhDQc8fVeTIVtAc6K6DDfez/eDR3cYAn8ATfNHfWg==
X-Received: by 2002:a05:6e02:104a:b0:368:8ab5:5926 with SMTP id p10-20020a056e02104a00b003688ab55926mr249462ilj.14.1711561157035;
        Wed, 27 Mar 2024 10:39:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id b1-20020a92db01000000b0036699bc65aesm3683073iln.26.2024.03.27.10.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 10:39:16 -0700 (PDT)
Date: Wed, 27 Mar 2024 11:39:15 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Vinayak Kale <vkale@nvidia.com>
Cc: <qemu-devel@nongnu.org>, <mst@redhat.com>, <marcel.apfelbaum@gmail.com>,
 <avihaih@nvidia.com>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <targupta@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
Message-ID: <20240327113915.19f6256c.alex.williamson@redhat.com>
In-Reply-To: <20240322064210.1520394-1-vkale@nvidia.com>
References: <20240322064210.1520394-1-vkale@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Mar 2024 12:12:10 +0530
Vinayak Kale <vkale@nvidia.com> wrote:

> In case of migration, during restore operation, qemu checks config space of the
> pci device with the config space in the migration stream captured during save
> operation. In case of config space data mismatch, restore operation is failed.
> 
> config space check is done in function get_pci_config_device(). By default VSC
> (vendor-specific-capability) in config space is checked.
> 
> Due to qemu's config space check for VSC, live migration is broken across NVIDIA
> vGPU devices in situation where source and destination host driver is different.
> In this situation, Vendor Specific Information in VSC varies on the destination
> to ensure vGPU feature capabilities exposed to the guest driver are compatible
> with destination host.
> 
> If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
> volatile Vendor Specific Info in VSC then qemu should exempt config space check
> for Vendor Specific Info. It is vendor driver's responsibility to ensure that
> VSC is consistent across migration. Here consistency could mean that VSC format
> should be same on source and destination, however actual Vendor Specific Info
> may not be byte-to-byte identical.
> 
> This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
> device by clearing pdev->cmask[] offsets. Config space check is still enforced
> for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
> config space check for that offset.
> 
> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> ---
> Version History
> v2->v3:
>     - Config space check skipped only for Vendor Specific Info in VSC, check is
>       still enforced for 3 byte VSC header.
>     - Updated commit description with live migration failure scenario.
> v1->v2:
>     - Limited scope of change to vfio-pci devices instead of all pci devices.
> 
>  hw/vfio/pci.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)


Acked-by: Alex Williamson <alex.williamson@redhat.com>

 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index d7fe06715c..1026cdba18 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2132,6 +2132,27 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
>      }
>  }
>  
> +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
> +                                        uint8_t size, Error **errp)
> +{
> +    PCIDevice *pdev = &vdev->pdev;
> +
> +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
> +    if (pos < 0) {
> +        return pos;
> +    }
> +
> +    /*
> +     * Exempt config space check for Vendor Specific Information during restore/load.
> +     * Config space check is still enforced for 3 byte VSC header.
> +     */
> +    if (size > 3) {
> +        memset(pdev->cmask + pos + 3, 0, size - 3);
> +    }
> +
> +    return pos;
> +}
> +
>  static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>  {
>      PCIDevice *pdev = &vdev->pdev;
> @@ -2199,6 +2220,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>          vfio_check_af_flr(vdev, pos);
>          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>          break;
> +    case PCI_CAP_ID_VNDR:
> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> +        break;
>      default:
>          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>          break;


