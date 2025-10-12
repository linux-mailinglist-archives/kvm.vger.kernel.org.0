Return-Path: <kvm+bounces-59840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7684ABCFFE3
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 08:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5712D1896AA8
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 06:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6BD21ADB7;
	Sun, 12 Oct 2025 06:43:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1378D1EB5D6;
	Sun, 12 Oct 2025 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760251395; cv=none; b=rvSBAM8Re+MMhRHG1javbVgQ0/T6qdx8hGy0dlMNwwMrWriSP7S3JWBtBXHpWjpXj35YZvPrRnGveFKOZWiB7GsA9elf9319HzomA+CavB5+N0qCTrgnWOph9+4t5+fFmAuMQcTdL9lDe8RB/Gby1vpMlRYo+lA4In6dm6chCSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760251395; c=relaxed/simple;
	bh=bcQXN32qsXPlYtfEKyarfkb1c85Nh2zRAf0ze6cI/Ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tahx7tfjQWvyeCDHKxfHLYhblc8r9J0TmtU4vYjna7Y+xbSPcLgEAie8anOFeavFvfpLcaklMBT69ZuPApBJGVamvNIO+ZSmWSXl0JagO0VCpaERf7ZoKnY6VgSlT2+F7ihLfsyDivqyWwQgdelK1RNUTG2zlWnOfBAGm5fVIDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 2905A2C06646;
	Sun, 12 Oct 2025 08:43:10 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 1518D4A12; Sun, 12 Oct 2025 08:43:10 +0200 (CEST)
Date: Sun, 12 Oct 2025 08:43:10 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOtN_r_Mp-nQ6Ckj@wunner.de>
References: <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <6c514ba0-7910-4770-903f-62c3e827a40b@linux.ibm.com>
 <aOc_k2MjZI6hYgKy@wunner.de>
 <3df48e3e-48e1-4cfb-aca9-7af606481b7c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3df48e3e-48e1-4cfb-aca9-7af606481b7c@linux.ibm.com>

On Thu, Oct 09, 2025 at 10:02:12AM -0700, Farhan Ali wrote:
> On 10/8/2025 9:52 PM, Lukas Wunner wrote:
> > On Wed, Oct 08, 2025 at 02:55:56PM -0700, Farhan Ali wrote:
> > > > > On 10/8/2025 6:34 AM, Lukas Wunner wrote:
> > > > > > I also don't quite understand why the VM needs to perform a reset.
> > > > > > Why can't you just let the VM tell the host that a reset is needed
> > > > > > (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
> > > > > > behalf of the VM?
> > > The reset is not performed by the VM, reset is still done by the host. My
> > > approach for a VM to let the host know that reset was needed, was to
> > > intercept any reset instructions for the PCI device in QEMU. QEMU would
> > > then drive a reset via VFIO_DEVICE_RESET. Maybe I am missing something,
> > > but based on what we have today in vfio driver, we don't have a mechanism
> > > for userspace to reset a device other than VFIO_DEVICE_RESET and
> > > VFIO_PCI_DEVICE_HOT_RESET ioctls.
> > The ask is for the host to notify the VM of the ->error_detected() event
> > and the VM then responding with one of the "enum pci_ers_result" values.
> 
> Maybe there is some confusion here. Could you clarify what do you mean by VM
> responding with "enum pci_ers_result" values? Is it a device driver (for
> example an NVMe driver) running in the VM that should do that? Or is it
> something else you are suggesting?

My expectation was that the host notifies the VM of the error,
the kernel in the VM notifies the nvme driver of the error,
the nvme driver returns a pci_ers_result return value from
its pci_error_handlers which the VM passes back to the host,
the host drives error recovery normally.

I was missing the high-level architectural overview that Niklas
subsequently provided.  You should provide it as part of your
series because otherwise it's difficult for reviewers to understand
what the individual patches are trying to achieve as a whole.

Thanks,

Lukas

