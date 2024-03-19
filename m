Return-Path: <kvm+bounces-12147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E961687FFE9
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 15:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A087B284941
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90A062818;
	Tue, 19 Mar 2024 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+kczf6W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704A3D2F5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710859820; cv=none; b=kwpFqgEr79o86UZyF4srt+kfHtw8MsCcAuSlo75n9JiMgtg90bp3/zBcLHJgo8tsuL+VT3RKVBxsOnbK1bnZxnIfvlJ9WrEQFksN7LIqjc+9l2hHZREib5VTq8Olnz/AdyEQ7ZUEOksm1QZZeWQ1ZmcrU0nxuj+o1PCKCipF0Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710859820; c=relaxed/simple;
	bh=9Or02ADRX8u+teHk/fSbctDIgcqOyiCVTsoWY9rQI2A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=czG0C1enffq6Un8Ul4e1ZhRqDkd54qQkCKP4HTrCAQLkYmDzhue1IIrJ8LS6/pkxXTfIDAludFow0y4FCnXgoEAbITowhUsEB2nxtmXGJKo/xEZ07R62NJe+L0NnNqNZOUPrHifLTQOE4ZWqoiQslhBOCmFwx0HsrmgDTA+Tp1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+kczf6W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710859817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQVEbtTOwcCbdEEQDCGW8gxi2FS5l5Frw2gE9pER4XY=;
	b=K+kczf6WxjRNyGBWfs0EuukM3dRbY698RRwq+Iai0dUExPy/MUC5o2s00EnNZhpE6wxJf9
	LLud0nvPQ5+fh+JWMpCFJzOidB6sotyoTIHBoMKFCg+csMvagzEFHEaCqY3BH0yg+DjQjf
	/dN5jW/YU06VHLfS7fzurPw+gH7blh0=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-CiG0h4ZaPHWRrV_Zuu6zhA-1; Tue, 19 Mar 2024 10:50:16 -0400
X-MC-Unique: CiG0h4ZaPHWRrV_Zuu6zhA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-221d4bbc770so7223247fac.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 07:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710859815; x=1711464615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQVEbtTOwcCbdEEQDCGW8gxi2FS5l5Frw2gE9pER4XY=;
        b=qD+/GrpIuf6i6t9eeNxIPERWPwnhSajyBI+j/67HtyQahvmKmf3yufe8DDTVhXdsxi
         GJ5KmDC1XEmKfrrGlHcW5lA74TpU/MmHX4YuTF0efPe+ikUuP3YcPsBMXnILlSbSebM9
         5YOyppHQow+n5/9LWBoN9tT/QdOw0RRsjxn2tdCDCUrVrgW3bBiPpcShkZW7a5qDy/Nq
         tfzx3nSiOu8m13BuW0HMKzM3bbdmpnhjvo7FY85Xj7o6oR54SRS5fxm8FLe5zV2tnTKz
         GR50FbRSuiAZcY39Y7m5Reme9MTM9r0jVup+h34w8qUW0C45LM38BmRMmKYhbNjaMLkx
         7dcg==
X-Forwarded-Encrypted: i=1; AJvYcCXDY7aGJsD2GIe9Yg+pYegSLMxiacaxN4nqzOT0XjVm0lInopALdH4VTCpIUa7mezxYgJRNQU3Hr7v7i6oBpiKPyIXT
X-Gm-Message-State: AOJu0YwvRdqbaGgt/8Tku5UAB0uvwhw5evIayzsN4GFtZkINV7sIqtqh
	IijZzKljXJ8ONU3QyqNpyBIdPvVZ7v6855VhLI0GclImzgJWAeEpJCa+FtDyIPF/3a+1wizEvXW
	HhzxC8RCQNDtFylnn38Iyy8FDAd923p0jl5maZ3m+bVdbPhRDRg==
X-Received: by 2002:a05:6870:4345:b0:221:c9ef:3e with SMTP id x5-20020a056870434500b00221c9ef003emr16362031oah.13.1710859815376;
        Tue, 19 Mar 2024 07:50:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG95zfhgakQbD+IW3Q6yfYsnzRgRRliSdgUB3UoL9l6r9IzAM8N4q69arDelFugd9JQVbllDA==
X-Received: by 2002:a05:6870:4345:b0:221:c9ef:3e with SMTP id x5-20020a056870434500b00221c9ef003emr16362019oah.13.1710859815111;
        Tue, 19 Mar 2024 07:50:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id g18-20020a02c552000000b00474fd401b8fsm2885461jaj.34.2024.03.19.07.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 07:50:14 -0700 (PDT)
Date: Tue, 19 Mar 2024 08:50:11 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mikhail Malyshev <mike.malyshev@gmail.com>
Cc: jgg@ziepe.ca, yi.l.liu@intel.com, kevin.tian@intel.com,
 tglx@linutronix.de, reinette.chatre@intel.com, stefanha@redhat.com,
 abhsahu@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Reenable runtime PM for dynamically unbound devices
Message-ID: <20240319085011.2da113ae.alex.williamson@redhat.com>
In-Reply-To: <20240319120410.1477713-1-mike.malyshev@gmail.com>
References: <20240319120410.1477713-1-mike.malyshev@gmail.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Mar 2024 12:04:09 +0000
Mikhail Malyshev <mike.malyshev@gmail.com> wrote:

> When trying to run a VM with PCI passthrough of intel-eth-pci ETH device
> QEMU fails with "Permission denied" error. This happens only if
> intel-eth-pci driver is dynamically unbound from the device using
> "echo -n $DEV > /sys/bus/pci/drivers/stmmac/unbind" command. If
> "vfio-pci.ids=..." is used to bind the device to vfio-pci driver and the
> device is never probed by intel-eth-pci driver the problem does not occur.
> 
> When intel-eth-pci driver is dynamically unbound from the device
> .remove()
>   intel_eth_pci_remove()
>     stmmac_dvr_remove()
>       pm_runtime_disable();

Why isn't the issue in intel-eth-pci?

For example stmmac_dvr_remove() does indeed call pm_runtime_disable()
unconditionally, but stmmac_dvr_probe() only conditionally calls
pm_runtime_enable() with logic like proposed here for vfio-pci.  Isn't
it this conditional enabling which causes an unbalanced disable depth
that's the core of the problem?

It doesn't seem like it should be the responsibility of the next driver
to correct the state from the previous driver.  You've indicated that
the device works with vfio-pci if there's no previous driver, so
clearly intel-eth-pci isn't leaving the device in the same runtime pm
state that it found it.  Thanks,

Alex

> Later when QEMU tries to get the device file descriptor by calling
> VFIO_GROUP_GET_DEVICE_FD ioctl pm_runtime_resume_and_get returns -EACCES.
> It happens because dev->power.disable_depth == 1 .
> 
> vfio_group_fops_unl_ioctl(VFIO_GROUP_GET_DEVICE_FD)
>   vfio_group_ioctl_get_device_fd()
>     vfio_device_open()
>       ret = device->ops->open_device()
>         vfio_pci_open_device()
>           vfio_pci_core_enable()
>               ret = pm_runtime_resume_and_get();
> 
> This behavior was introduced by
> commit 7ab5e10eda02 ("vfio/pci: Move the unused device into low power state with runtime PM")
> 
> This may be the case for any driver calling pm_runtime_disable() in its
> .remove() callback.
> 
> The case when a runtime PM may be disable for a device is not handled so we
> call pm_runtime_enable() in vfio_pci_core_register_device to re-enable it.
> 
> Mikhail Malyshev (1):
>   vfio/pci: Reenable runtime PM for dynamically unbound devices
> 
>  drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --
> 2.34.1
> 


