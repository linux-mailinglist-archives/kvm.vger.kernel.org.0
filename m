Return-Path: <kvm+bounces-64281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 055D6C7CD00
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 11:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA8103A8A24
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 10:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C48142FD66F;
	Sat, 22 Nov 2025 10:58:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2B2FC005;
	Sat, 22 Nov 2025 10:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763809090; cv=none; b=HLhC65xsjiz7+ciG1cLyn28ns/4Q5ZNc+2bf4nSOtbNArTMPiTXOZPLKFLzME2VAHKuq4Wk17VpAZq2LtkBsEkRoDL9xjhwV6iKiHtLMZT0lGtn3QVAwTOgj8/GCQpbBw7yV+u13HHsImLJkG6NRgoQFWO0ByIkTVDBtuVPsAII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763809090; c=relaxed/simple;
	bh=RSZ498+qoeQDHURZOxifLzXL2J1l5TCP3+W2eBr7IcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EP/r9vMlE9L0nwxWRGK7+0FE1v0zPAlyzKSUkwrwW5q3yEfNQd6eR/t7sqsdYwRwU81TTXlSRKwcQCS/hc6S+ANMqkeVtk63oNqNfi6SLH1Vf4A9KlRwWhtd/s8YrqOpaWwHyKcePpTfJOf3UB9f7esKa16FOtejaOs7cekaJLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 0CED02C000AC;
	Sat, 22 Nov 2025 11:58:05 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E6AEA1BFB7; Sat, 22 Nov 2025 11:58:04 +0100 (CET)
Date: Sat, 22 Nov 2025 11:58:04 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Farhan Ali <alifm@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aSGXPJdqjGn8e_Tw@wunner.de>
References: <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
 <aOtL_Y6HH5-qh2jD@wunner.de>
 <bb59edee909ceb09527cedec10896d45126f0027.camel@linux.ibm.com>
 <aPT26UZ41DsN5C01@wunner.de>
 <0f4776c0eac3c004d36677377525662d75752ebd.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f4776c0eac3c004d36677377525662d75752ebd.camel@linux.ibm.com>

On Mon, Oct 20, 2025 at 10:59:48AM +0200, Niklas Schnelle wrote:
> Yeah I think we're talking past each other a bit. In my mind we're
> really not doing the recovery in ->error_detected() at all. Within that
> callback we only do the notify, and then do nothing in the rest of
> recovery. Only after will the guest do recovery though I do see your
> point that leaving the device in the error state kind of means that
> recovery is still ongoing even if we're not in the recovery handler
> anymore. But then any driver could also just return
> PCI_ERS_RESULT_RECOVERED in error_detected() and land us in the same
> situation.

That would be a bug in the driver.  The point of the pci_error_handlers
is to attempt recovery of the device in concert with the driver.
If the driver "fakes" a recovered device towards the PCI core and then
attempts recovery behind the PCI core's back, it gets to keep the pieces...

> But let's put that aside, say we want to implement your model where we
> do check with the guest and its device driver. How would that work,
> somehow error_detected() would have to wait for the guest to proceed
> into recovery and since the guest could just not do that we'd have to
> have some kind of timeout.

Right, a timeout seems reasonable.

> Also we can't allow the guest to choose
> PCI_ERS_RESULT_RECOVERED because otherwise we'd again be in the
> situation where recovery is completed without unblocking I/O.

The guest should only return that if the device has really recovered.
On an architecture which blocks I/O upon an error, by definition the
device cannot already be recovered in the ->error_detected() stage.

> And if we
> want to stick to the architecture QEMU/KVM will have to kind of have a
> mode where after being informed of ongoing recovery for a device they
> intercept attempts to reset / firmware calls for reset and turn that
> into the correct return. And somehow also deal with the timeout because
> e.g. old Linux guests won't do recovery but there is also no
> architected way for a guest to say that it does recovery.

I guess there are gaps in qemu with regards to error recovery,
but I think the solution is to add the missing functionality,
not try to work around the gaps.

Thanks,

Lukas

