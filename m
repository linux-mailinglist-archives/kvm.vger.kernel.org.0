Return-Path: <kvm+bounces-37981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B359A32DE7
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 18:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8396E7A1A0E
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 17:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8A525D538;
	Wed, 12 Feb 2025 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/Du+3LF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358A2116E0;
	Wed, 12 Feb 2025 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739382664; cv=none; b=YGLy3wcb9juAQR7uwqUxENf2QW6ljVrgPGLu7mwuKu5EmV4HydbCKTktJs7535u52OPs0V86u1nFuF/u+kpg3UZfKk0etTKwilgPsM8xMgMO5xYKf/5ZHaOPOncC79uPvNSj5JK0j30iv7MIl4lsj9CuzAX/mjbM4jD+yDzJLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739382664; c=relaxed/simple;
	bh=am/bFZ5n+x/LiN4DKmDL+UQAHSZFP6LZFw/XXWZjeNA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NX94dwuez0Xqae8lmrBq6NjkSmqV3bzvozvjy5ZdZHOIpoyCVL3r0NaYtJpnam4p3RBY6wjKXkD4islwbhPALPSQ7h+lNkfht+xH+gl+/QkJKRsz/5P4Oa1TSXsGvOWr/aSdp/O3bpn21L1Ehm4PsDpCrqKkT07UGhilOi/CG3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/Du+3LF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0FEC4CEDF;
	Wed, 12 Feb 2025 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739382663;
	bh=am/bFZ5n+x/LiN4DKmDL+UQAHSZFP6LZFw/XXWZjeNA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=h/Du+3LFQEJrp5IxiAYoRoHP12C9WU8T37rPCFO1pTpEo5RCm579OH76aGlnFQ1hk
	 r4oflm4TFXg4Wufml7sduTPiZVqAlEamBAdM6ktgngZ5iprNDYN0OVQPfAD8OBINEJ
	 csS79ZbPcr6IUBpikpTnVW8qkhQ0Ov9rdaw4HxhT+WQqUTxly9n3F7g3vmJsks15k3
	 SDbG8HSdj22ypg8ubci3oyMC4dgHtpzsxe+9mZulUcOZjIoBu3qvKRkZTudwyDtmKu
	 pawZWdTejdb0VXwmF9flaWqmuyeak/oTjAL2X9YVlrjdvyQUyDZ9uV3tYz4/2rclqV
	 JHeWh8NVNrUPg==
Date: Wed, 12 Feb 2025 11:51:02 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 2/2] PCI: s390: Support mmap() of BARs and replace
 VFIO_PCI_MMAP by a device flag
Message-ID: <20250212175102.GA85244@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212-vfio_pci_mmap-v5-2-633ca5e056da@linux.ibm.com>

On Wed, Feb 12, 2025 at 04:28:32PM +0100, Niklas Schnelle wrote:
> On s390 there is a virtual PCI device called ISM which has a few
> peculiarities. For one, it presents a 256 TiB PCI BAR whose size leads
> to any attempt to ioremap() the whole BAR failing. This is problematic
> since mapping the whole BAR is the default behavior of for example
> vfio-pci in combination with QEMU and VFIO_PCI_MMAP enabled.
> 
> Even if one tried to map this BAR only partially, the mapping would not
> be usable without extra precautions on systems with MIO support enabled.
> This is because of another oddity, in that this virtual PCI device does
> not support the newer memory I/O (MIO) PCI instructions and legacy PCI
> instructions are not accessible through writeq()/readq() when MIO is in
> use.
> 
> In short the ISM device's BAR is not accessible through memory mappings.
> Indicate this by introducing a new non_mappable_bars flag for the ISM
> device and set it using a PCI quirk. Use this flag instead of the
> VFIO_PCI_MMAP Kconfig option to block mapping with vfio-pci. This was
> the only use of the Kconfig option so remove it. Note that there are no
> PCI resource sysfs files on s390x already as HAVE_PCI_MMAP is currently
> not set. If this were to be set in the future pdev->non_mappable_bars
> can be used to prevent unusable resource files for ISM from being
> created.
> 
> As s390x has no PCI quirk handling add basic support modeled after x86's
> arch/x86/pci/fixup.c and move the ISM device's PCI ID to the common
> header to make it accessible. Also enable CONFIG_PCI_QUIRKS whenever
> CONFIG_PCI is enabled.
> 
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> +++ b/include/linux/pci_ids.h
> @@ -518,6 +518,7 @@
>  #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
>  #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
>  #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
> +#define PCI_DEVICE_ID_IBM_ISM		0x04ED

Use lower-case hex to match other entries.

>  #define PCI_SUBVENDOR_ID_IBM		0x1014
>  #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
> 
> -- 
> 2.45.2
> 

