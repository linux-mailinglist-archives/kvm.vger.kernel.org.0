Return-Path: <kvm+bounces-35338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BE5A0C596
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 00:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E0EE1887428
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C83A1FA143;
	Mon, 13 Jan 2025 23:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivxoqvRd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471AA16EC19;
	Mon, 13 Jan 2025 23:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736810742; cv=none; b=fkKqt+wt/CNwHkr+V8C2hTC3fRblQkcjSpUIb4sVKou7osklSzvZIhO5po1jprw4QjowxmhK/q0v5Npt9MxKirS5Zez2/yVwDD3/30eqgZUkitf2gAKMSTAX8BKoOCNiuXSLO3NCCfEe9pMDlNsDkmqGYwpjCl2OyFaf0anIaiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736810742; c=relaxed/simple;
	bh=FGsvei6NACUd2ysYKOzG3uR2HPewnzz1Q0j1OfAgPXE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=BoFadA3x1uAcrYINd3sSXoFt4H2TkGrmDXX6R7GQU6CqBt//nImwESj2dIa2s6e8aPCyEbK4OEDrSgElzkkFXykorsBkqIF1fb5/jjNaQWn1feFJ23zX9Nk22K++B8kLHPt4njixwJduZvIziaLHy7+Z7vb3WKZu0GZmDZIZU30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivxoqvRd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A234DC4CED6;
	Mon, 13 Jan 2025 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736810741;
	bh=FGsvei6NACUd2ysYKOzG3uR2HPewnzz1Q0j1OfAgPXE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ivxoqvRdslEzsYqgN2x6cy+dBL4XAiO5FwrY59SmQDsaQzKEEqo32+Q2XxL8z6Kpk
	 IWbAFdDUyT1ckmPEflV8Hn/9sPm+QOYw3j4PrvnmUzgGhbouvaZamBLz5X8C8pSGyr
	 t4hZdqrKTkuVs6mhuS3yqCdKqLaoX2SViHXcC6+eh3dR1mdo66Gf2DQEDz5k3NVg4a
	 mGtRVTurb5RMGhJntqRlMEgherjxPmyG2924BQ793nVJtrBuYoefp1WdONulD+XknV
	 6RHBRL0ypZkXh55fGB0yUl5J58T0aVKePQ2H9U+y22TW7pgfKCMYp7p5GE45eNwAIN
	 KlX/cAQtYo1Xg==
Date: Mon, 13 Jan 2025 17:25:40 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Nishanth Aravamudan <naravamudan@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable
Message-ID: <20250113232540.GA442403@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106215231.2104123-1-naravamudan@nvidia.com>

Please update subject line to match historical capitalization
convention.

On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> device supports reset.
> 
> However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> device reset mechanism") added support for userspace to disable reset of
> specific PCI devices (by echo'ing "" into reset_method) and
> pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> see if userspace has disabled reset. Therefore, if an administrator
> disables PCI reset of a specific device, but then uses vfio-pci with
> that device (e.g. with qemu), vfio-pci will happily end up issuing a
> reset to that device.

Please consistently add "()" after function names.

> Add an explicit check of pci_reset_supported() in both paths.

Bjorn

