Return-Path: <kvm+bounces-11555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB178782A9
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C2BA1F251FD
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 15:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9A643ACA;
	Mon, 11 Mar 2024 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ki/YFcTD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7066F4206A
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710169381; cv=none; b=J78YzTJxUwH95vafJsNTg394/gD33hPZ+jzQJv6jMC8w3tXItW/6cdxf2Y20p2caBCyTik3+KXHaNTf9PNSWns/+PVdK7ymI2V342xR46D2Vthals5x+vsmRkG7iIzwP9nrjeutw0bRsstA/sDg8UDl7KFaSx2lOGyPZoxt3LVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710169381; c=relaxed/simple;
	bh=8aMQ3LPouEMH3kDiQAv94s76fA/BjE5uIKE2nerFB7M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rce2L31Y/zfW4DMwChBD9Ee4rEQy8XNTqA5QmsZpV2IOWWDqwGvsniOT4w9UP4IeuXZW5VBld1WGATx71uCirnsJYNbfvHt8GcPjRfbVh3dKTnNjGmxTKqfldxlwmVCBr30m4Kop7mi4gRekF0KIOHOUrauUWe0OHXjV8iWFka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ki/YFcTD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710169378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3k4Q7Tm466fEItdGrwmYPATdJiQXiuGrp52WUVmVRY=;
	b=Ki/YFcTDjpSJUZroKj/RmYJNWpPHBYk+LjZufM61LO1PJSmQ9E3SL9DYtsSlvDvp2LalU7
	p07qgDVPEC+/x2/DfT2LQ3TPrpGOhmbIYjXOyb0CDroPKH3cl0p58wOHzIT+rNqGZOv7dm
	+NLGfLMP5JLdUImM+OtcwdPh7mtCk8A=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-cl88dX_vOrKfUOzktj51YA-1; Mon, 11 Mar 2024 11:02:44 -0400
X-MC-Unique: cl88dX_vOrKfUOzktj51YA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c85f86e4c7so302611939f.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 08:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710169364; x=1710774164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3k4Q7Tm466fEItdGrwmYPATdJiQXiuGrp52WUVmVRY=;
        b=ERmyrYnL7qE7TnvRBUa0gzcSWlYHqZVDTrjvgqb3w0tI+1Df3meH7I3M5CB0bhIsoI
         oZga4QoDlASDoNKMwJQgcIAhwRHoBep5kBy98Ovfj2rM3fqUGV3QvhFkbtZWzYCQfEgI
         6ZedSY4GQ50zo2A/3KUiPgRWnpztG/YNl/0xHeMCQQn/y5A6k8V54eUK7ssPKRAsbfAM
         gEB6GVV/UtupAG/qDzoo0BGcx3DoyAS4RajcH3MiLDdVpwhnr2VL9pMVzSIVgq/t9IQF
         ESb5sV81i2H4LFz7JCMc6RmSTXE3+leVaI0HrdKBIhutY3oVQusCfURNHlZBvrxuWdPy
         BKPw==
X-Forwarded-Encrypted: i=1; AJvYcCXiMT6TIQXyXLmOg8mJlqasIgeLOp/E5Swbnx+m3PGTtMAKFpV8OmdCgbbKUhBUhoYgnnrGehdPmbWB+w/Io7vNF9NJ
X-Gm-Message-State: AOJu0YyfIhy1YiB50AWUDs4xRAI8nyBK31aMarb0+MKmCNG+chzyHaMK
	uL8dkOH1kvrAk63JSTQ4lOAHGs7vhkiMHVx2jZwOJoSimdWKmCxHotj9tcH776ZMb+AFpS/CwSI
	io9tPJstRyQz5E8bYOb4K4KvCI3q/23HWDPyHVSAM8N9Wv0v96g==
X-Received: by 2002:a05:6e02:1808:b0:366:3686:5356 with SMTP id a8-20020a056e02180800b0036636865356mr9315831ilv.5.1710169364050;
        Mon, 11 Mar 2024 08:02:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFinSAzKcScCZNQtVdABTq4pR7MYQjZQekD0tQNEa3ddytF0vBXhjuvG3HxHH4HlCFQNBYCKQ==
X-Received: by 2002:a05:6e02:1808:b0:366:3686:5356 with SMTP id a8-20020a056e02180800b0036636865356mr9315785ilv.5.1710169363628;
        Mon, 11 Mar 2024 08:02:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id b22-20020a026f56000000b00474782f85d3sm1756018jae.94.2024.03.11.08.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 08:02:43 -0700 (PDT)
Date: Mon, 11 Mar 2024 09:02:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Vinayak Kale <vkale@nvidia.com>
Cc: <qemu-devel@nongnu.org>, <mst@redhat.com>, <marcel.apfelbaum@gmail.com>,
 <avihaih@nvidia.com>, <acurrid@nvidia.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <targupta@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] vfio/pci: migration: Skip config space check for
 vendor specific capability during restore/load
Message-ID: <20240311090242.229b80ec.alex.williamson@redhat.com>
In-Reply-To: <20240311121519.1481732-1-vkale@nvidia.com>
References: <20240311121519.1481732-1-vkale@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Mar 2024 17:45:19 +0530
Vinayak Kale <vkale@nvidia.com> wrote:

> In case of migration, during restore operation, qemu checks config space of the
> pci device with the config space in the migration stream captured during save
> operation. In case of config space data mismatch, restore operation is failed.
> 
> config space check is done in function get_pci_config_device(). By default VSC
> (vendor-specific-capability) in config space is checked.
> 
> Ideally qemu should not check VSC for VFIO-PCI device during restore/load as
> qemu is not aware of VSC ABI.

It's disappointing that we can't seem to have a discussion about why
it's not the responsibility of the underlying migration support in the
vfio-pci variant driver to make the vendor specific capability
consistent across migration.

Also, for future maintenance, specifically what device is currently
broken by this and under what conditions?

> 
> This patch skips the check for VFIO-PCI device by clearing pdev->cmask[] for VSC
> offsets. If cmask[] is not set for an offset, then qemu skips config space check
> for that offset.
> 
> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
> ---
> Version History
> v1->v2:
>     - Limited scope of change to vfio-pci devices instead of all pci devices.
> 
>  hw/vfio/pci.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> index d7fe06715c..9edaff4b37 100644
> --- a/hw/vfio/pci.c
> +++ b/hw/vfio/pci.c
> @@ -2132,6 +2132,22 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
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
> +    /* Exempt config space check for VSC during restore/load  */
> +    memset(pdev->cmask + pos, 0, size);

This excludes the entire capability from comparison, including the
capability ID, next pointer, and capability length.  Even if the
contents of the capability are considered volatile vendor information,
the header is spec defined ABI which must be consistent.  Thanks,

Alex

> +
> +    return pos;
> +}
> +
>  static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>  {
>      PCIDevice *pdev = &vdev->pdev;
> @@ -2199,6 +2215,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>          vfio_check_af_flr(vdev, pos);
>          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>          break;
> +    case PCI_CAP_ID_VNDR:
> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
> +        break;
>      default:
>          ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>          break;


