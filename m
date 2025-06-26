Return-Path: <kvm+bounces-50878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CD1AEA66A
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:27:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2433D1C28065
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9475E2EFD92;
	Thu, 26 Jun 2025 19:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aEBrHu9h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E25194AD5
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750966031; cv=none; b=GeqEmd/JgE0yMe0syCT9FWo5tSH1AYDfa0Dg0JkaNPbK+OAdMZ3u2puygpsmRRvjd2V2tYV3v5GteyLVvkpbH+NpJwj+/t9KUEo6x4oryK3R2e5xfLpddpEnnubsbDsIMfy9duzrO5f0/MJ5jVSvq7FHiiM43R6kcN4RfzHf/5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750966031; c=relaxed/simple;
	bh=VoHLXhrxt49clTNfv3lQgWPn0b38/ZPWP7RXgS6ovnk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JikyYwHyIZ5f+aa/EihC5L6AGfHEWp35bqEGpqQbH5slJmKSpobZ8wALbarvpWGM0+8ZV46SZbCYWW6A/Cw2rgqhHuxA42G0ULTqMVVxJMTvw+zp0R42dj0G98BWo50CyqgH17mLA8apLqVX0SNh0DZbLTmBxYj2Cw5vMKikNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aEBrHu9h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750966025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iy+93BjVDbU12itM28HPPvChg4wvRtMxKuLlJrr8Bvw=;
	b=aEBrHu9hrr6UKoCh81C6vrk2XWsBBjb0krEKIy2ftdr5vUId/q6JS+MbIe+Iz46D2zt1VD
	FMX/a7k7My8LPKNiq7gR1F4S0y614ZRbMdjjrsBz9oXoxFaOK1YzJdjZ5vjBtH0/ffhnhh
	67c28kW/EndToDrvEFgbi/QD9sa95iY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-bqRS7oEDNRag0x342Es9ug-1; Thu, 26 Jun 2025 15:27:04 -0400
X-MC-Unique: bqRS7oEDNRag0x342Es9ug-1
X-Mimecast-MFC-AGG-ID: bqRS7oEDNRag0x342Es9ug_1750966024
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-86cf30a9be6so24162539f.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 12:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750966023; x=1751570823;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iy+93BjVDbU12itM28HPPvChg4wvRtMxKuLlJrr8Bvw=;
        b=YDy/V16ywZM7z+Lcf5VKh9sd4JMGwsDrZ0j2eSnArIcoTafonxTZpJQ150iigScgzg
         4WJyoXsFX7r+0oXj7V9ePUhuJbttfTei34R1JcGNRQG9WqodOjLRRRbACEybrEC7pBIX
         WQjlbcwSwCJyz3V5VLbB6ycTE3uz0it83C7xlkrgTDeH76bYTx19OEie58dixZt7ctIm
         APHGIFqcu3WApsOgjta0oPGEUFRg/dty8ycWCX/2mFq/P6kk+LRJokqWMziZvGHPct/n
         8Dan8/2+JerJffnodf3KouKfNaIPivq1HNtB+Fo79uptcZeQkHjNv7bKxA2jTVukW2kE
         pmmg==
X-Forwarded-Encrypted: i=1; AJvYcCWwcDCWTiMEJjDwJ3HGzbIoggFGMktnDF40fYZekxNJ6ibK5/TQYNwMQphKGjYxS8uiCxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvtX0mIGXh/uzFLl3C5OuokOs/Db19XB8DNK0dN3a3nlZOVFEX
	J4EHH2v6jcOhHGmvXtHJxjhsDgE6HvCZAVVkamFSPmFTCpLUjTqjOcHAzBO2epqyOF7Q1ItT5mr
	NxlszzwTPZome0myWfw1dfiOVtsO1Ul/yIR3Tmdo9u/DfLGJ5L9jsYQ==
X-Gm-Gg: ASbGncsc1Pp+P7Ki9JNxDXuoflM8j3xd3XNeFr3SNiEPRcn0ANlHtMWhbl+1u15y074
	K6HagUzDLp9sJG8LR8H/IN2biR5SM7DI0zSFQDPdpEhr+2mALUWaI4bg4dgwCb+IVnBXSaPFLjD
	KERDdnxvATYm4GGBGqIpMFcMyqpxCaN/EBw4Y59I2P7pWDXbjODqmF+NZ3dLsCGwrn129fZzq8x
	BR7ZI9fvUZXG6BApS1CGC2zVEZnZjBH20ekgiCjGE/r/ohJhCsjwf8uRlfWMK6DdcqywS4KqWkR
	8bNd2wrXAKtXOB1zWuZYWr5EKg==
X-Received: by 2002:a05:6602:160c:b0:86c:fea3:430 with SMTP id ca18e2360f4ac-8768832df10mr35923939f.2.1750966023533;
        Thu, 26 Jun 2025 12:27:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEowN7hTHPqQ5Srb/74ZIgzFaJNhRvOSXaCDqSrUIAX+Ulc2z8fCmrHtFn+GtGiLbP3mEJkCw==
X-Received: by 2002:a05:6602:160c:b0:86c:fea3:430 with SMTP id ca18e2360f4ac-8768832df10mr35922139f.2.1750966023036;
        Thu, 26 Jun 2025 12:27:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87687b0e190sm10848439f.40.2025.06.26.12.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 12:27:02 -0700 (PDT)
Date: Thu, 26 Jun 2025 13:26:59 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: bhelgaas@google.com, dmatlack@google.com, vipinsh@google.com,
 kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com, Jason Gunthorpe
 <jgg@nvidia.com>
Subject: Re: [RFC PATCH 0/3] vfio: selftests: Add VFIO selftest to
 demontrate a latency issue
Message-ID: <20250626132659.62178b7d.alex.williamson@redhat.com>
In-Reply-To: <20250626180424.632628-1-aaronlewis@google.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Jun 2025 18:04:21 +0000
Aaron Lewis <aaronlewis@google.com> wrote:

> This series is being sent as an RFC to help brainstorm the best way to
> fix a latency issue it uncovers.
> 
> The crux of the issue is that when initializing multiple VFs from the
> same PF the devices are reset serially rather than in parallel
> regardless if they are initialized from different threads.  That happens
> because a shared lock is acquired when vfio_df_ioctl_bind_iommufd() is
> called, then a FLR (function level reset) is done which takes 100ms to
> complete.  That in combination with trying to initialize many devices at
> the same time results in a lot of wasted time.
> 
> While the PCI spec does specify that a FLR requires 100ms to ensure it
> has time to complete, I don't see anything indicating that other VFs
> can't be reset at the same time.
> 
> A couple of ideas on how to approach a fix are:
> 
>   1. See if the lock preventing the second thread from making forward
>   progress can be sharded to only include the VF it protects.

I think we're talking about the dev_set mutex here, right?  I think this
is just an oversight.  The original lock that dev_set replaced was
devised to manage the set of devices affected by the same bus or slot
reset.  I believe we've held the same semantics though and VFs just
happen to fall through to the default of a bus-based dev_set.
Obviously we cannot do a bus or slot reset of a VF, we only have FLR,
and it especially doesn't make sense that VFs on the same "bus" from
different PFs share this mutex.

Seems like we just need this:

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcd..261a6dc5a5fc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	if (pci_is_root_bus(pdev->bus)) {
+	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
 		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);

Does that allow fully parallelized resets?

Meanwhile this is a good use case of selftests and further impetus for
me to get it working.  Thanks,

Alex

>   
>   2. Do the FLR for the VF in probe() and close(device_fd) rather than in
>   vfio_df_ioctl_bind_iommufd().
> 
> To demonstrate the problem the run script had to be extended to bind
> multiple devices to the vfio-driver, not just one.  E.g.
> 
>   $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -d 0000:16:01.7 -s
> 
> Also included is a selftest and BPF script.  With those, the problem can
> be reproduced with the output logging showing that one of the devices
> takes >200ms to initialize despite running from different threads.
> 
>   $ VFIO_BDF_1=0000:17:0c.1 VFIO_BDF_2=0000:17:0c.2 ./vfio_flr_test
>   [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
>   [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.
> 
> And the BPF script indicating that the latency issues are coming from the
> mutex in vfio_df_ioctl_bind_iommufd().
> 
>   [pcie_flr] duration = 108ms
>   [vfio_df_ioctl_bind_iommufd] duration = 108ms
>   [pcie_flr] duration = 104ms
>   [vfio_df_ioctl_bind_iommufd] duration = 212ms
> 
>   [__mutex_lock] duration = 103ms
>   __mutex_lock+5
>   vfio_df_ioctl_bind_iommufd+171
>   __se_sys_ioctl+110
>   do_syscall_64+109
>   entry_SYSCALL_64_after_hwframe+120
> 
> This series can be applied on top of the VFIO selftests using the branch:
> upstream/vfio/selftests/v1.
> 
> https://github.com/dmatlack/linux/tree/vfio/selftests/v1
> 
> Aaron Lewis (3):
>   vfio: selftests: Allow run.sh to bind to more than one device
>   vfio: selftests: Introduce the selftest vfio_flr_test
>   vfio: selftests: Include a BPF script to pair with the selftest vfio_flr_test
> 
>  tools/testing/selftests/vfio/Makefile         |   1 +
>  tools/testing/selftests/vfio/run.sh           |  73 +++++++----
>  tools/testing/selftests/vfio/vfio_flr_test.c  | 120 ++++++++++++++++++
>  .../testing/selftests/vfio/vfio_flr_trace.bt  |  83 ++++++++++++
>  4 files changed, 251 insertions(+), 26 deletions(-)
>  create mode 100644 tools/testing/selftests/vfio/vfio_flr_test.c
>  create mode 100644 tools/testing/selftests/vfio/vfio_flr_trace.bt
> 


