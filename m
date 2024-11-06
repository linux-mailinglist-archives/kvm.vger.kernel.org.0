Return-Path: <kvm+bounces-30888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C69999BE290
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09661C22E4E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C1A1DA10A;
	Wed,  6 Nov 2024 09:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h88ZiNiH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC671D934D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885561; cv=none; b=LcVBi+1zpErZ6VtQPjiRhBUTFG5XQ/3IG/L8xHX4PVKMOwEQI1zMBzfW8v+qxiuUhz2LENEU3sJf8E7+UBMK2MxB36thcJvqcE3sc78gxSzyNBBQztShwl8jtURcDkB6dP9RjpYlWmLGnnEsTf4a2pfNMPt+2nopFgvl0lbyhwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885561; c=relaxed/simple;
	bh=zLZtrbOm3tQO4cPR6OaXWHUBAUHtdy+WeL4yJVZKFZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPtyA7I4rwJYPIVd+MSRx81hMqfKcle7jMng44EPBTrup8jlUBdh1qAe0dav7PE5z+yJZftLsK5btSsjmZtlG3GNXXuIER//8vnjJWb3oT/vzxQM2jDUdjsgmUqtCiQvaN7L3qGeL+mYQoEe26AyDltp+OLgLEY+QhBA1PonMFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h88ZiNiH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730885558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YQCOzaaqSacr7sTCquGBzU/j66yk4mLPH1LOn1N3AI=;
	b=h88ZiNiHJYxu7sojYH4425RK4mfRUTQWa6EaiI7BFYkYk5H+b/N7prW9Cz2NxOdWDVhKfD
	6RJd8db2uT6OrTxbKVdMJq3helayhn+bcgueHJhaDi56rX/EqS4HKlYxw7sm3gJkMwgoIz
	NQ8KmGmP4R9drWXb1wZsCk/29LYF1i4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-DB7LPZoqPmCFBkaZt9ysRg-1; Wed, 06 Nov 2024 04:32:37 -0500
X-MC-Unique: DB7LPZoqPmCFBkaZt9ysRg-1
X-Mimecast-MFC-AGG-ID: DB7LPZoqPmCFBkaZt9ysRg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d462b64e3so3379370f8f.3
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 01:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730885556; x=1731490356;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YQCOzaaqSacr7sTCquGBzU/j66yk4mLPH1LOn1N3AI=;
        b=FPRROhFtH6tHyEobT3o/NLiwJIvDZHwHI9lRvvNwt3vELRs7YyfvXQ75DVLMtrLx/0
         zxxeNoyZNA/7aYDoe+0kmtAWnqtPlIf7z2hPwFcKyg6TctUQEItjno2o7DHUFOBw7nro
         gdi1cCWlBZGd/eiRpgdohSITvqgGUe5sF059fUjzt7v7gEEvxjkmQYnWzV4v25dRT08L
         561836EJiFq02JQKC81DC5hIJEGqWpGydnBJWdNJ6iEDeEyqQ+D0miJAoKqMnbHR3hZ3
         qeYqCZBbu3Bq8OpOuFMEEUZxMzuuAMoCnLqxGc/LQQXOg2xrV4M/dkL/wAKrSNvKih8v
         3gGA==
X-Forwarded-Encrypted: i=1; AJvYcCXaIgj8bp79t1x8tx+mg5Wcb8QEBtvFsucbV15soVZawsmAUXUri+cHtcwH6Z4mq9OYa7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqTQp8OJY7ogfeksO9HFXlRbkj2y3bH2ScKFGqNRUKUHke3l9y
	YT5O3a71QRhPS8TEkEOSIN2N/OpY/6oz3ZV05KdUd//sx2B/OCOY9iL0lVtOWqtsVmw16hp+kTb
	QGhxIOzy/Ht/DyMVbEiwNSAtSBadhiGwVzvexSkMHK7IuUrLz6w==
X-Received: by 2002:a5d:64c5:0:b0:37d:37b2:385d with SMTP id ffacd0b85a97d-381c7a47416mr16606925f8f.12.1730885556274;
        Wed, 06 Nov 2024 01:32:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGi1IM4BOoEQNw8UW9f+P1oxQf6UCUsiEK4Wx2gCs9qwZs3LuTdRj7XQ0sMEcPYmbuf2blZGA==
X-Received: by 2002:a5d:64c5:0:b0:37d:37b2:385d with SMTP id ffacd0b85a97d-381c7a47416mr16606899f8f.12.1730885555823;
        Wed, 06 Nov 2024 01:32:35 -0800 (PST)
Received: from redhat.com ([2a02:14f:178:e74:5fcf:8a69:659d:f2b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d4983sm18419369f8f.33.2024.11.06.01.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 01:32:35 -0800 (PST)
Date: Wed, 6 Nov 2024 04:32:31 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
	joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 0/7] Enhance the vfio-virtio driver to support
 live migration
Message-ID: <20241106043151-mutt-send-email-mst@kernel.org>
References: <20241104102131.184193-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241104102131.184193-1-yishaih@nvidia.com>

On Mon, Nov 04, 2024 at 12:21:24PM +0200, Yishai Hadas wrote:
> This series enhances the vfio-virtio driver to support live migration
> for virtio-net Virtual Functions (VFs) that are migration-capable.
>  
> This series follows the Virtio 1.4 specification to implement the
> necessary device parts commands, enabling a device to participate in the
> live migration process.
> 
> The key VFIO features implemented include: VFIO_MIGRATION_STOP_COPY,
> VFIO_MIGRATION_P2P, VFIO_MIGRATION_PRE_COPY.
>  
> The implementation integrates with the VFIO subsystem via vfio_pci_core
> and incorporates Virtio-specific logic to handle the migration process.
>  
> Migration functionality follows the definitions in uapi/vfio.h and uses
> the Virtio VF-to-PF admin queue command channel for executing the device
> parts related commands.


virtio things here:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Alex, your tree I presume? I hope the virtio changes do not
cause conflicts.


> Patch Overview:
> The first four patches focus on the Virtio layer and address the
> following:
> - Define the layout of the device parts commands required as part of the
>   migration process.
> - Provide APIs to enable upper layers (e.g., VFIO, net) to execute the
>   related device parts commands.
>  
> The last three patches focus on the VFIO layer:
> - Extend the vfio-virtio driver to support live migration for Virtio-net
>   VFs.
> - Move legacy I/O operations to a separate file, which is compiled only
>   when VIRTIO_PCI_ADMIN_LEGACY is configured, ensuring that live
>   migration depends solely on VIRTIO_PCI.
>  
> Additional Notes:
> - The kernel protocol between the source and target devices includes a
>   header containing metadata such as record size, tag, and flags.
>   The record size allows the target to read a complete image from the
>   source before passing device part data. This follows the Virtio
>   specification, which mandates that partial device parts are not
>   supplied. The tag and flags serve as placeholders for future extensions
>   to the kernel protocol between the source and target, ensuring backward
>   and forward compatibility.
>  
> - Both the source and target comply with the Virtio specification by
>   using a device part object with a unique ID during the migration
>   process. As this resource is limited to a maximum of 255, its lifecycle
>   is confined to periods when live migration is active.
> 
> - According to the Virtio specification, a device has only two states:
>   RUNNING and STOPPED. Consequently, certain VFIO transitions (e.g.,
>   RUNNING_P2P->STOP, STOP->RUNNING_P2P) are treated as no-ops. When
>   transitioning to RUNNING_P2P, the device state is set to STOP and
>   remains STOPPED until it transitions back from RUNNING_P2P->RUNNING, at
>   which point it resumes its RUNNING state. During transition to STOP,
>   the virtio device only stops initiating outgoing requests(e.g. DMA,
>   MSIx, etc.) but still must accept incoming operations.
> 
> - Furthermore, the Virtio specification does not support reading partial
>   or incremental device contexts. This means that during the PRE_COPY
>   state, the vfio-virtio driver reads the full device state. This step is
>   beneficial because it allows the device to send some "initial data"
>   before moving to the STOP_COPY state, thus reducing downtime by
>   preparing early and warming-up. As the device state can be changed and
>   the benefit is highest when the pre copy data closely matches the final
>   data we read it in a rate limiter mode and reporting no data available
>   for some time interval after the previous call. With PRE_COPY enabled,
>   we observed a downtime reduction of approximately 70-75% in various
>   scenarios compared to when PRE_COPY was disabled, while keeping the
>   total migration time nearly the same.
> 
> - Support for dirty page tracking during migration will be provided via
>   the IOMMUFD framework.
>  
> - This series has been successfully tested on Virtio-net VF devices.
> 
> Changes from V0:
> https://lore.kernel.org/kvm/20241101102518.1bf2c6e6.alex.williamson@redhat.com/T/
> 
> Vfio:
> Patch #5:
> - Enhance the commit log to provide a clearer explanation of P2P
>   behavior over Virtio devices, as discussed on the mailing list.
> Patch #6:
> - Implement the rate limiter mechanism as part of the PRE_COPY state,
>   following Alex’s suggestion.
> - Update the commit log to include actual data demonstrating the impact of
>   PRE_COPY, as requested by Alex.
> Patch #7:
> - Update the default driver operations (i.e., vfio_device_ops) to use
>   the live migration set, and expand it to include the legacy I/O
>   operations if they are compiled and supported.
> 
> Yishai
> 
> Yishai Hadas (7):
>   virtio_pci: Introduce device parts access commands
>   virtio: Extend the admin command to include the result size
>   virtio: Manage device and driver capabilities via the admin commands
>   virtio-pci: Introduce APIs to execute device parts admin commands
>   vfio/virtio: Add support for the basic live migration functionality
>   vfio/virtio: Add PRE_COPY support for live migration
>   vfio/virtio: Enable live migration once VIRTIO_PCI was configured
> 
>  drivers/vfio/pci/virtio/Kconfig     |    4 +-
>  drivers/vfio/pci/virtio/Makefile    |    3 +-
>  drivers/vfio/pci/virtio/common.h    |  127 +++
>  drivers/vfio/pci/virtio/legacy_io.c |  420 +++++++++
>  drivers/vfio/pci/virtio/main.c      |  500 ++--------
>  drivers/vfio/pci/virtio/migrate.c   | 1336 +++++++++++++++++++++++++++
>  drivers/virtio/virtio_pci_common.h  |   19 +-
>  drivers/virtio/virtio_pci_modern.c  |  457 ++++++++-
>  include/linux/virtio.h              |    1 +
>  include/linux/virtio_pci_admin.h    |   11 +
>  include/uapi/linux/virtio_pci.h     |  131 +++
>  11 files changed, 2594 insertions(+), 415 deletions(-)
>  create mode 100644 drivers/vfio/pci/virtio/common.h
>  create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
>  create mode 100644 drivers/vfio/pci/virtio/migrate.c
> 
> -- 
> 2.27.0


