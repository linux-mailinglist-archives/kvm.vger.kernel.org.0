Return-Path: <kvm+bounces-59683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DA6BC763C
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 06:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65D9419E5113
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 04:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A630225CC7A;
	Thu,  9 Oct 2025 04:52:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D746725BEE5;
	Thu,  9 Oct 2025 04:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.9.242.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759985567; cv=none; b=qx8itO1hIsFa/WXgISxaY9mA37BOc2wYBsxf0Q3zG7i76HfeLcWx6ssniKDlcx0EvLEUpIxhCL0oZkWqGyI0a64sJCGY4JLThhUBHBkZT9aQGanQbNe9fX+3tAs6Az0UeysxeXnO9uZ+C3dDrlH97dw56lXDRnDE9iM6zqCoId8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759985567; c=relaxed/simple;
	bh=Eg0o3cXJFUa57cyz0G/lNiiaYxdQ4CsTwGmcdV2/0R8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpRoygaxtNVGkfACO5Gkezo8XOTN1cl/fI+mYkSMiic/8oXIK11E/sBHMZ8KZUlet/pxZNuin+SRXgQQ9FHxCXgpWI+1yj5wZ3hbgbpW0xs33p3M5nUaxRsNFvyew9tTl9JL3CqqJC/0LYyr4kdN2i9e/QPCfOgbt94p9i77lJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=176.9.242.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout3.hostsharing.net (Postfix) with ESMTPS id 8D3882C11C63;
	Thu,  9 Oct 2025 06:52:35 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 6003654C92; Thu,  9 Oct 2025 06:52:35 +0200 (CEST)
Date: Thu, 9 Oct 2025 06:52:35 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOc_k2MjZI6hYgKy@wunner.de>
References: <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <6c514ba0-7910-4770-903f-62c3e827a40b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c514ba0-7910-4770-903f-62c3e827a40b@linux.ibm.com>

On Wed, Oct 08, 2025 at 02:55:56PM -0700, Farhan Ali wrote:
> > > On 10/8/2025 6:34 AM, Lukas Wunner wrote:
> > > > I also don't quite understand why the VM needs to perform a reset.
> > > > Why can't you just let the VM tell the host that a reset is needed
> > > > (PCI_ERS_RESULT_NEED_RESET) and then the host resets the device on
> > > > behalf of the VM?
> 
> The reset is not performed by the VM, reset is still done by the host. My
> approach for a VM to let the host know that reset was needed, was to
> intercept any reset instructions for the PCI device in QEMU. QEMU would then
> drive a reset via VFIO_DEVICE_RESET. Maybe I am missing something, but based
> on what we have today in vfio driver, we don't have a mechanism for
> userspace to reset a device other than VFIO_DEVICE_RESET and
> VFIO_PCI_DEVICE_HOT_RESET ioctls.

The ask is for the host to notify the VM of the ->error_detected() event
and the VM then responding with one of the "enum pci_ers_result" values.

If the VM returns PCI_ERS_RESULT_NEED_RESET from ->error_detected(),
the host knows that it shall reset the device.  There is no need
for the VM to initiate a reset through an ioctl.  Just integrate
with the existing error handling flow described in
Documentation/PCI/pci-error-recovery.rst and thereby use the
existing mechanism to reset the device.

Thanks,

Lukas

