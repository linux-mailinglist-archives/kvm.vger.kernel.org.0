Return-Path: <kvm+bounces-59439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F114BB4A49
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 19:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A4A442290F
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 17:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F223126F2B7;
	Thu,  2 Oct 2025 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZK8k7e7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEEE8F40;
	Thu,  2 Oct 2025 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759425413; cv=none; b=cTdB3IPN7NV9Qyj8xXGko7Hq3uRF8BwDd3jf/lTTq+boyfV5/AwMqhRkYL1PBVcNDH8C4u2w2fLB8hE6wlzI8Y2HKvdQG3pl4pm++2o4MzH/67y6YIzxTlW0sHRQm1FDwb3NjPwYzq1xKt8c8kzBFOjGw+TF2D9CxRtMOS9W/CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759425413; c=relaxed/simple;
	bh=aZhPS9fU3PhP1m0ZhYKaDD4HdmmwcbPttec4pw/X+Zc=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=URXzjkLumTTYS6sq9PPaa6c/zeedYwimfp3CsJlCmLRcX7xdxQCUU0PfPJEVu8npyEyoPjaDSTLjpkBD836ushwK3UEAEIQWDVyPUP+UNfDS3WoIL/JU5n0xXRfEPh/I1zWq8BzeQOK6keFf/bERkP3lu6Ps7bg2MUIR+LE3bvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZK8k7e7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759425411; x=1790961411;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=aZhPS9fU3PhP1m0ZhYKaDD4HdmmwcbPttec4pw/X+Zc=;
  b=AZK8k7e7ZXWX7Rd1oBrELXjtXvE9IWZA51vpn+JCQX4UoUanKe+UHJIW
   E1SPiq3DIkBl0GaUvj5TAcVx034lhi8xEL9iaJIGaiv4RLQdimODoqUob
   iMgZoJmUGbN/Ldcqbuy0UuWPGRhLsIYVzgLeuC+dxJ72b0vqXR3zDCJkE
   QeZff5Tx1GDpZ7Rq3esNt87WidaScTYKXg914zZLfUKdjCaBJV3Fk+Yc6
   Kiz79TVW8C493Iad4c+qtgHe+PU5OaSg0K2VZzDwHruO3eRM7ApzRtlde
   3Kis0F2rTcsX2xZy0I1D+R/4PBC30+uv8j76i3HAeDutpr9zgsSG298up
   g==;
X-CSE-ConnectionGUID: ZkCDfFtHTfCsjOvwTXcWgA==
X-CSE-MsgGUID: oF2R9SE1SwqZ8ZmrZM5FGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11570"; a="61877846"
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="61877846"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:16:50 -0700
X-CSE-ConnectionGUID: uVTS2FXCRKK5MiK3D+54Kg==
X-CSE-MsgGUID: gXSfJDlKTC6JqmZHNoaI2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="183113418"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.246])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 10:16:45 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 2 Oct 2025 20:16:42 +0300 (EEST)
To: Bjorn Helgaas <helgaas@kernel.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>
cc: Niklas Schnelle <schnelle@linux.ibm.com>, alex.williamson@redhat.com, 
    clg@redhat.com, mjrosato@linux.ibm.com, Farhan Ali <alifm@linux.ibm.com>, 
    linux-s390@vger.kernel.org, kvm@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific resource/bus
 address translation
In-Reply-To: <20251002170013.GA278722@bhelgaas>
Message-ID: <62669f67-d53e-2b56-af8c-e02cdff480a8@linux.intel.com>
References: <20251002170013.GA278722@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 2 Oct 2025, Bjorn Helgaas wrote:

> On Thu, Oct 02, 2025 at 02:58:45PM +0200, Niklas Schnelle wrote:
> > On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> > > On s390 today we overwrite the PCI BAR resource address to either an
> > > artificial cookie address or MIO address. However this address is different
> > > from the bus address of the BARs programmed by firmware. The artificial
> > > cookie address was created to index into an array of function handles
> > > (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmware
> > > but maybe different from the bus address. This creates an issue when trying
> > > to convert the BAR resource address to bus address using the generic
> > > pcibios_resource_to_bus().
> > > 
> > > Implement an architecture specific pcibios_resource_to_bus() function to
> > > correctly translate PCI BAR resource addresses to bus addresses for s390.
> > > Similarly add architecture specific pcibios_bus_to_resource function to do
> > > the reverse translation.
> > > 
> > > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > > ---
> > >  arch/s390/pci/pci.c       | 74 +++++++++++++++++++++++++++++++++++++++
> > >  drivers/pci/host-bridge.c |  4 +--
> > >  2 files changed, 76 insertions(+), 2 deletions(-)
> > > 
> > 
> > @Bjorn, interesting new development. This actually fixes a current
> > linux-next breakage for us. In linux-next commit 06b77d5647a4 ("PCI:
> > Mark resources IORESOURCE_UNSET when outside bridge windows") from Ilpo
> > (added) breaks PCI on s390 because the check he added in
> > __pci_read_base() doesn't find the resource because the BAR address
> > does not match our MIO / address cookie addresses. With this patch
> > added however the pcibios_bus_to_resource() in __pci_read_base()
> > converts  the region correctly and then Ilpo's check works. I was
> > looking at this code quite intensely today wondering about Benjamin's
> > comment if we do need to check for containment rather than exact match.
> > I concluded that I think it is fine as is and was about to give my R-b
> > before Gerd had tracked down the linux-next issue and I found that this
> > fixes it.
> > 
> > So now I wonder if we might want to pick this one already to fix the
> > linux-next regression? Either way I'd like to add my:
> > 
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> Hmmm, thanks for the report.  I'm about ready to send the pull
> request, and I hate to include something that is known to break s390
> and would require a fix before v6.18.  At the same time, I hate to add
> non-trivial code, including more weak functions, this late in the
> window.
> 
> 06b77d5647a4 ("PCI: Mark resources IORESOURCE_UNSET when outside
> bridge windows") fixes some bogus messages, but I'm not sure that it's
> actually a functional change.  So maybe the simplest at this point
> would be to defer that commit until we can do it and the s390 change
> together.

Hi,

I didn't notice any issues because of the conflict messages, but then, I 
didn't look very deeply into what those pnp things were as it seemed bug 
in PCI core we want to fix anyway.

Deferring the commit 06b77d5647a4 would be prudent as there seems to be 
another problem in Geert's case discussed in the other thread. Even this 
short time in next has already served us well by exposing things that need 
fixing so better to wait until we've known things resolved.

-- 
 i.


