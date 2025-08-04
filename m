Return-Path: <kvm+bounces-53942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C53D5B1A9FE
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 22:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D6D36210FF
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 20:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAAF22D4F9;
	Mon,  4 Aug 2025 20:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="QDyJVIRS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634992163BD
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 20:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754338196; cv=none; b=ZrOHqlMn2rCHt1RPGhrcexfBiT1JSFwlrmwnFwSuOtrWDQkuMUw+vAdh3LicryNIkdB/7Pd/Sd9SBP4zYHI6Dg6jzvHEL51xvL8yivG5i32aZmcEvAR2tPCRvRAceXgCBNtKwoXh1VEPFO7EKvYtD3Yw8g9fvtpu5BQ+7dF+Bzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754338196; c=relaxed/simple;
	bh=LlFQt1npKd9E4Y229fB9LDmsb/DxHpM1loy0sxSSBx0=;
	h=Subject:From:To:CC:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LndK5apK2miFdYygK4v2LQiSzzHXP6j2UMYeGEOZvHTJCdATK1YAQJpxtYsitZUEzUed8OXC7FTQd5llV3JjbMovYCp41urcYKOf3TTiVBDjHXbg6Vcl3Gynp3fqSSldaUM9FFiAeLGWtxMdudV/A1Ksr4GSJyEiSDmzZG76EPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=QDyJVIRS; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754338194; x=1785874194;
  h=from:to:cc:in-reply-to:references:date:message-id:
   mime-version:subject;
  bh=ujtsu1cKS+pAlUW6T11oIWDs07fg2e8k56UaKs5EiHM=;
  b=QDyJVIRSjiVz0bS3IWSOHNApIFuaJVv3cpeTlriY6I/xEiH02A8dbyNU
   o67Bie/QlHOzvfb5W3obh10qfocNgvPwpTmCPXy2W6asJWJwl2Ubul4+w
   oOID53On1lApN5CAdRm6ugQ6ePU57klooopmm5FVhep5ZEvXCxltMCbje
   UtJmzidS/lAa2rxxmOMqT971QYJV9UA2xLfHg0Dg/EZaXAI7VHMKCl1j/
   +vmpMusRvWEj+tNSO1/cXdNIpkHr88Rw6aQm0mJOb2GQBh4YPEHzi1il/
   2sFzmUHU2KWVdFJuy3fPkNRJx/lGpeeCXMr83CQG4FWJFqtRaa/7bmpXn
   g==;
X-IronPort-AV: E=Sophos;i="6.17,265,1747699200"; 
   d="scan'208";a="219205153"
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 20:09:52 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:3825]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.29.0:2525] with esmtp (Farcaster)
 id 98e78347-9cd6-4d3e-a348-f584c2a21f08; Mon, 4 Aug 2025 20:09:51 +0000 (UTC)
X-Farcaster-Flow-ID: 98e78347-9cd6-4d3e-a348-f584c2a21f08
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 20:09:50 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 20:09:47 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>, "David
 Woodhouse" <dwmw@amazon.co.uk>, <pravkmr@amazon.de>, <nagy@khwaternagy.com>
In-Reply-To: <20250804124909.67462343.alex.williamson@redhat.com> (Alex
	Williamson's message of "Mon, 4 Aug 2025 12:49:09 -0600")
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
Date: Mon, 4 Aug 2025 22:09:44 +0200
Message-ID: <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWA001.ant.amazon.com (10.13.139.124) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)

Alex Williamson <alex.williamson@redhat.com> writes:


>
> I'm lost.  AIUI, there was a proposal to manage region offsets via a
> maple tree, specifically to get a more compact mapping, which I think
> is meant to allow new regions (mmap cookies) to be created which are
> effectively aliases to other regions with different mapping attributes.
>
> Here we have a partial conversion to a maple tree, but the proposed
> ioctl is only specifying a mapping attribute for an existing offset.
> How does this require or take advantage of the maple tree?
>

I think you are mentioning the vfio-pci-core ioctl implementation, as I
mentioned in the proposed patch I'm using region insert with mt which is
using the same offset calculation for the transitioning period, but this
will change to allocating a free region in maple_tree after moving the
vfio-pci devices to the new ops and changing the usage of the
OFFSET_TO_INDEX macros.

I wanted first to move all the vfio-pci devices to the new ops first,
then changing the OFFSET_TO_INDEX macro afterwards, to avoid duplicating
all the codes that do this calculations which includes page faults code
etc..

But so far we are advantaging from per FD range attributes for mmaping,
and extra regions can already be used by design.


> We should be able to convert to a maple tree without introducing these
> "legacy" ops.

This technically be done directly by changing the current ops (ioctl,
mmap, read & write) to add vmmap argument in place and call the ops with
NULL for vmmap entry if the entry not found in the mt, instead of
returning -EINVAL in vfio (vfio-devices could check that
themselves). instead of this transitioning stage that this RFC is
implementing.

I probably need to also update read & write ops to use the vmmap in the
same patch as well.

Thanks,
MNAdam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


