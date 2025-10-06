Return-Path: <kvm+bounces-59544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE95BBF17E
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2147A1898D5A
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08052DE715;
	Mon,  6 Oct 2025 19:26:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACD92D7803;
	Mon,  6 Oct 2025 19:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759778806; cv=none; b=tN+oKdV3btwxfmIIyLEAsRKOAcyYd3OPEk2FfbkaMXq60GZLQxLSIFQEQlzSUCAl0lZhxylvlvpTDDi2mFrVBrEViiTxI81EWJM374H911K5IM3asxCQxDVYMM4bawXxYMhp/zieg9w3F0r/4woOcsVUyM1muQM1c+toRJF7NNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759778806; c=relaxed/simple;
	bh=vUBnTJnshouH8Q+l4EvtuFnkCSf2h532KLfPXz8Faug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udjHLe57ml0sE8l1mMEoVLxuF6eSEh5luA79qg3Jv0l1TZdXs4f7Ox4+3MqYGtdY4ZPKW4sha/yus2N4Y/0H1Pq/CiEhIZ87o8QuqptFuK+Z4mYhpA7iX/+ttLWV5sPup2+2Ikj7FyAckpTpeLPQXWxbf1TWhpVjwgPW/L/1inI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id B80C02C05680;
	Mon,  6 Oct 2025 21:26:33 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 90C01549512; Mon,  6 Oct 2025 21:26:33 +0200 (CEST)
Date: Mon, 6 Oct 2025 21:26:33 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOQX6ZTMvekd6gWy@wunner.de>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>

On Mon, Oct 06, 2025 at 10:54:51AM -0700, Farhan Ali wrote:
> On 10/4/2025 7:54 AM, Lukas Wunner wrote:
> > I believe this also makes patch [01/10] in your series unnecessary.
> 
> I tested your patches + patches 2-10 of this series. It unfortunately didn't
> completely help with the s390x use case. We still need the check to in
> pci_save_state() from this patch to make sure we are not saving error
> values, which can be written back to the device in pci_restore_state().

What's the caller of pci_save_state() that needs this?

Can you move the check for PCI_POSSIBLE_ERROR() to the caller?
I think plenty of other callers don't need this, so it adds
extra overhead for them and down the road it'll be difficult
to untangle which caller needs it and which doesn't.


> As part of the error recovery userspace can use the VFIO_DEVICE_RESET to
> reset the device (pci_try_reset_function()). The function call for this is:
> 
> pci_dev_save_and_disable <https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_save_and_disable>();
> 
> __pci_reset_function_locked <https://elixir.bootlin.com/linux/v6.17.1/C/ident/__pci_reset_function_locked>();
> 
> pci_dev_restore
> <https://elixir.bootlin.com/linux/v6.17.1/C/ident/pci_dev_restore>();
> 
> So we can end up overwriting the initial saved state (added by you in
> pci_bus_add_device()). Do we need to update the pci_dev_save_and_disable()
> not to save the state?

The state saved on device addition is just the initial state and
it is fine if later on it gets updated (which is a nicer term than
"overwritten").  E.g. when portdrv.c instantiates port services
and drivers are bound to them, various registers in Config Space
are changed, hence pcie_portdrv_probe() calls pci_save_state()
again.

However we can discuss whether pci_save_state() is still needed
in pci_dev_save_and_disable().

Thanks,

Lukas

