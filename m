Return-Path: <kvm+bounces-59652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B6DBC6431
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 20:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D35119E3E5F
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 18:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5542C0323;
	Wed,  8 Oct 2025 18:14:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD485296BDF;
	Wed,  8 Oct 2025 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759947288; cv=none; b=VpwwEn1H5P1Fh2pjhgPEL43/JhxjhlaNrySwEMJ3G24naD3bFgNpyZL0iu1W8KMIEht/94sud2oU1tiXeBzJ4Zo5TIKpxb9jVz5tq3wYMmZZBrzJES7G1fOTt+weDrFI6VlTdxUqT7LIychReEdzmQORzIj43edYbJyPKGgrYws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759947288; c=relaxed/simple;
	bh=f1Xfh73fYAwwEybiYSkzZMhz8dgwcwrqwJs+/7FLw/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B31HCG5xtylUVOLAeuug4eF68R39PaWjs7lSrpvYZ/2xyoR3j6p7VGvrEBvbfvN9sg974ElJhiDIO4ippAHIk5zo3ykJO0H34wDOdlnwGH55GBOGZjS9O+Wb+8kabyKeFJOau/kes+bpr0MaTJYP6GfPutlowF/Bx10F3RDbr5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 8F8E62C1B98C;
	Wed,  8 Oct 2025 20:14:42 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 7AC8F5F7D1C; Wed,  8 Oct 2025 20:14:42 +0200 (CEST)
Date: Wed, 8 Oct 2025 20:14:42 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOaqEhLOzWzswx8O@wunner.de>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>

On Wed, Oct 08, 2025 at 10:56:35AM -0700, Farhan Ali wrote:
> On 10/8/2025 6:34 AM, Lukas Wunner wrote:
> > I'm not sure yet.  Let's back up a little:  I'm missing an
> > architectural description how you're intending to do error
> > recovery in the VM.  If I understand correctly, you're
> > informing the VM of the error via the ->error_detected() callback.
> > 
> > You're saying you need to check for accessibility of the device
> > prior to resetting it from the VM, does that mean you're attempting
> > a reset from the ->error_detected() callback?
> > 
> > According to Documentation/PCI/pci-error-recovery.rst, the device
> > isn't supposed to be considered accessible in ->error_detected().
> > The first callback which allows access is ->mmio_enabled().
> > 
> 
> The ->error_detected() callback is used to inform userspace of an error. In
> the case of a VM, using QEMU as a userspace, once notified of an error QEMU
> will inject an error into the guest in s390x architecture specific way [1]
> (probably should have linked the QEMU series in the cover letter). Once
> notified of the error VM's device driver will drive the recovery action. The
> recovery action require a reset of the device and on s390x PCI devices are
> reset using architecture specific instructions (zpci_device_hot_reset()).

According to Documentation/PCI/pci-error-recovery.rst:

   "STEP 1: Notification
    --------------------
    Platform calls the error_detected() callback on every instance of
    every driver affected by the error.
    At this point, the device might not be accessible anymore, [...]
    it gives the driver a chance to cleanup, waiting for pending stuff
    (timers, whatever, etc...) to complete; it can take semaphores,
    schedule, etc... everything but touch the device."
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

And yet you're touching the device by trying to reset it.

The code you're introducing in patch [01/10] only becomes necessary
because you're not following the above-quoted protocol.  If you
follow the protocol, patch [01/10] becomes unnecessary.

> > I also don't quite understand why the VM needs to perform a reset.
> > Why can't you just let the VM tell the host that a reset is needed
> > (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
> > behalf of the VM?

Could you answer this question please?

Thanks,

Lukas

