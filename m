Return-Path: <kvm+bounces-59839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B6DBCFFD7
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 08:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADF691895132
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 06:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E0E219A8A;
	Sun, 12 Oct 2025 06:34:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D811E5B71;
	Sun, 12 Oct 2025 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760250890; cv=none; b=AIpoMWSywDqjtrsrw4YG22miaHR2OkJztiGte+wVp0ED5Bk376jbiUlKjt/gJRIcQiS2yHX3IkBw6+X6SlPOjM3a0KdMAY2aaIXnRqRlgpd6C7jc7hEG+vv2OH2IvzFDQfIm0GrXJl1Dg1dV0ghd1JAvGecp+2MkMneW5t70CJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760250890; c=relaxed/simple;
	bh=LiSurZAtGfp1vzW2kzC2/cKeiPOwaeE3HkoNSkO3WKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/AgLzExSoCGpoBi8bYJxwfIzSZLC4dVOiwzpf4GkEHsDcRuWdp3YI323hcZko4pKMinHAEyHhpbyqpltYKAwThCbZ60eBnEMbFi+wOR06NfyUZbA6a9gJyAy6i8/jjIIZNyNTQZLfLFVUCXtia8pBQWdIO+uHH8gIksOl6d030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 2478B2C06845;
	Sun, 12 Oct 2025 08:34:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 0A6EE4A12; Sun, 12 Oct 2025 08:34:37 +0200 (CEST)
Date: Sun, 12 Oct 2025 08:34:37 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Farhan Ali <alifm@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOtL_Y6HH5-qh2jD@wunner.de>
References: <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
 <aOE1JMryY_Oa663e@wunner.de>
 <c0818c13-8075-4db0-b76f-3c9b10516e7a@linux.ibm.com>
 <aOQX6ZTMvekd6gWy@wunner.de>
 <8c14d648-453c-4426-af69-4e911a1128c1@linux.ibm.com>
 <aOZoWDQV0TNh-NiM@wunner.de>
 <21ef5524-738a-43d5-bc9a-87f907a8aa70@linux.ibm.com>
 <aOaqEhLOzWzswx8O@wunner.de>
 <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69f239040b830718b124c5bcef01b5075768226.camel@linux.ibm.com>

On Thu, Oct 09, 2025 at 11:12:03AM +0200, Niklas Schnelle wrote:
> On Wed, 2025-10-08 at 20:14 +0200, Lukas Wunner wrote:
> > And yet you're touching the device by trying to reset it.
> > 
> > The code you're introducing in patch [01/10] only becomes necessary
> > because you're not following the above-quoted protocol.  If you
> > follow the protocol, patch [01/10] becomes unnecessary.
> 
> I agree with your point above error_detected() should not touch the
> device. My understanding of Farhan's series though is that it follows
> that rule. As I understand it error_detected() is only used to inject
> the s390 specific PCI error event into the VM using the information
> stored in patch 7. As before vfio-pci returns
> PCI_ERS_RESULT_CAN_RECOVER from error_detected() but then with patch 7
> the pass-through case is detected and this gets turned into
> PCI_ERS_RESULT_RECOVERED and the rest of the s390 recovery code gets
> skipped. And yeah, writing it down I'm not super happy with this part,
> maybe it would be better to have an explicit
> PCI_ERS_RESULT_LEAVE_AS_IS.

Thanks, that's the high-level overview I was looking for.

It would be good to include something like this at least
in the cover letter or additionally in the commit messages
so that it's easier for reviewers to connect the dots.

I was expecting paravirtualized error handling, i.e. the
VM is aware it's virtualized and vfio essentially proxies
the pci_ers_result return value of the driver (e.g. nvme)
back to the host, thereby allowing the host to drive error
recovery normally.  I'm not sure if there are technical
reasons preventing such an approach.

If you do want to stick with your alternative approach,
maybe doing the error handling in the ->mmio_enabled() phase
instead of ->error_detected() would make more sense.
In that phase you're allowed to access the device,
you can also attempt a local reset and return
PCI_ERS_RESULT_RECOVERED on success.

You'd have to return PCI_ERS_RESULT_CAN_RECOVER though
from the ->error_detected() callback in order to progress
to the ->mmio_enabled() step.

Does that make sense?

Thanks,

Lukas

