Return-Path: <kvm+bounces-24958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05B4695D944
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FEB286363
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CB41C8FCD;
	Fri, 23 Aug 2024 22:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ryK+a0iw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE15E191F6B;
	Fri, 23 Aug 2024 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724452124; cv=none; b=BOK92SO9oQVDQsdO/4JhncPiJ3+dkNp+pzMAdlAahDrri8gz0awcGnCJJyikovRL1yBc6k3bYgJ9e2k5bb/sGlgCUAP3fmo3fAUX/ZsG1pNZpDQt2U5Y8R3h87jeGu3piCWFo+Qcocv/gPVP/z0kJI0/Ohv/zQPPT1rAFohADPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724452124; c=relaxed/simple;
	bh=Qs39FblAkTcX+TOCH/V8pHu5sKlaGsewyduXogMPXP4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=LQQis4I25xn/cM0TtRK8L34JULZtFquts3pMe9XZnUp+ODJ6dlgpMp5ECp8oP8XZVQtuAQmXSk7ABWKSiZHV/57qEikrRb7yatNtwFo7YNOi1L2RHP5xxyL6pK6peDsq3xs2vd5+4B3H1G+azCVCrWXLwRgkmJ11Wuh0in/l9UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ryK+a0iw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317D7C32786;
	Fri, 23 Aug 2024 22:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724452124;
	bh=Qs39FblAkTcX+TOCH/V8pHu5sKlaGsewyduXogMPXP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ryK+a0iwyx5CrpUAJuRVRSfd/Pl/KLmRMMnBg89uzLgxIKSWo7DwyafWbFQeQTmJo
	 0MHFh1ID6b+t5ZZozcxIB9OczAAWSbidOO7YGfe5sYS4OXVa6C8tovttfaHEDCRLgE
	 jTFLJeo9YZooZR2kpixEZIgkFufRgch3m/sDbVj2ojDOgoD9+BQQln1z6yNbfQv1A1
	 U3mY4CVOGD5pvtdRWgKwmyGONDq6NwmPxxnoNne7Jz3KTG2D+EDYKMe3KZLEPkV5B5
	 1gbY4z1PeiUsl99D341sFMvlcIaeniNr1dDH1EGnlVYpxn5aGOj7Zx5Qo6Rm7FHNQc
	 tGGz2qaq+RftA==
Date: Fri, 23 Aug 2024 17:28:42 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 04/21] PCI/IDE: Define Integrity and Data Encryption
 (IDE) extended capability
Message-ID: <20240823222842.GA391351@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-5-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:18PM +1000, Alexey Kardashevskiy wrote:
> PCIe 6.0 introduces the "Integrity & Data Encryption (IDE)" feature which
> adds a new capability with id=0x30.

Include section number.

> Add the new id to the list of capabilities. Add new flags from pciutils.
> Add a module with a helper to control selective IDE capability.

s/id/ID/  Maybe even include the name of the #define.

What's the "new flags from pciutils" about?  I don't think we need to
add #defines until they're used in Linux.

No comments on the code except to notice that 95%+ fits in 80 columns,
but some function prototypes are needlessly 90-100.

