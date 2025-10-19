Return-Path: <kvm+bounces-60452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D69BEE725
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 16:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01C7F420CFF
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 14:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636E62EAB8D;
	Sun, 19 Oct 2025 14:34:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25C1C8606;
	Sun, 19 Oct 2025 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760884463; cv=none; b=HJEsjeqZKnWU6l79K1bkLO+5u4UCpbawJDCpw9c2GF7qM7LZ0xAAXtZWgqeL+EiropKUSNilUMrXnjq/qlVI2RWf9SDxNFcjzmGx2RIvcqidvM9s2zXaM2MVVzsZCee4n1oB4QUw9TcGZxznoBJjfxP/iabV43xI3K2vgLvUpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760884463; c=relaxed/simple;
	bh=t18vQoHoWWi+2K+Sy4tvcn/q0aoEmipmVLsee3uj1eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s75qDz8SjqGS1A7rbx2TTHxIuVQoe1bqxbHJqh22p/peOhSJrxmc0vpVim61IGf1IiqY1YRGwPAg3lIQsxg4jIRwv7hWyDmfQ/RTFIKmxgPtMFWf7IGStQcNkEuVsZ2SfC/c5K8pP/FfL2PB+taeBE9okBPuy8tkm4pvpExiFSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 6CFF22C051E9;
	Sun, 19 Oct 2025 16:34:17 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 35A0B4A12; Sun, 19 Oct 2025 16:34:17 +0200 (CEST)
Date: Sun, 19 Oct 2025 16:34:17 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Farhan Ali <alifm@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aPT26UZ41DsN5C01@wunner.de>
References: <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
 <aOtL_Y6HH5-qh2jD@wunner.de>
 <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>

On Tue, Oct 14, 2025 at 02:07:57PM +0200, Niklas Schnelle wrote:
> On Sun, 2025-10-12 at 08:34 +0200, Lukas Wunner wrote:
> > If you do want to stick with your alternative approach,
> > maybe doing the error handling in the ->mmio_enabled() phase
> > instead of ->error_detected() would make more sense.
> > In that phase you're allowed to access the device,
> > you can also attempt a local reset and return
> > PCI_ERS_RESULT_RECOVERED on success.
> > 
> > You'd have to return PCI_ERS_RESULT_CAN_RECOVER though
> > from the ->error_detected() callback in order to progress
> > to the ->mmio_enabled() step.
> 
> The problem with using ->mmio_enabled() is two fold. For one we
> sometimes have to do a reset instead of clearing the error state, for
> example if the device was not only put in the error state but also
> disabled, or if the guest driver wants it,

Well in that case you could reset the device in the ->mmio_enabled() step
from the guest using the vfio reset ioctl.

> Second and more
> importantly this would break the guests assumption that the device will
> be in the error state with MMIO and DMA blocked when it gets an error
> event. On the other hand, that's exactly the state it is in if we
> report the error in the ->error_detected() callback

At the risk of continuously talking past each other:

How about this, the host notifies the guest of the error in the
->error_detected() callback.  The guest notifies the driver and
collects the result (whether a reset is requested or not), then
returns PCI_ERS_RESULT_CAN_RECOVER to the host.

The host re-enables I/O to the device, invokes the ->mmio_detected()
callback.  The guest then resets the device based on the result it
collected earlier or invokes the driver's ->mmio_enabled() callback.

If the driver returns PCI_ERS_RESULT_NEED_RESET from the
->mmio_enabled() callback, you can likewise reset the device from
the guest using the ioctl method.

My concern is that by insisting that you handle device recovery
completely in the ->error_detected() phase, you're not complying
with the protocol specified in Documentation/PCI/pci-error-recovery.rst
and as a result, you have to amend the reset code in the PCI core
because it assumes that all arches adheres to the protocol.
In my view, that suggests that the approach needs to be reworked
to comply with the protocol.  Then the workarounds for performing
a reset while I/O is blocked become unnecessary.

Thanks,

Lukas

