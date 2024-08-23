Return-Path: <kvm+bounces-24957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC31195D930
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79B7C284A4F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B9C1C8FA0;
	Fri, 23 Aug 2024 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okluX9yT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1658B193412;
	Fri, 23 Aug 2024 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724451574; cv=none; b=aqXdAFls7jijVEG6xK+wyHCufE7Q7PyTu6kj7GuVBlu+t8hTbsXUYh9NVfgSqluKqQW7dA7NijtpMflbqCw2c9jgQePhjGrJKeheIt5dOtxsQBl3tmxz2Ea7eMMgwh6B2sOWEGuufZ9scVbiwVgboVlcGDvpUb6nDkyDy1fX5t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724451574; c=relaxed/simple;
	bh=/F0b1uuhv3m1T+EaJ2Y5pyv58PDUAkO9520ZE6t+XnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mf44viST3gsHpyJuW8n2parEtA7Jk0pMgcWdVl3dlDvJ+LE7bveje5uloCNf6LOwqKabUIDSPsByEtScQtkWN5iBTbgtNwEOLrIRg75P9eX8w6nFhTax6SOnvJ6UvzqFD2kWwEtJgTD0gvAsUvW7CGP2p2ddmdc+ISVGI/KrfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okluX9yT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CBCC32786;
	Fri, 23 Aug 2024 22:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724451573;
	bh=/F0b1uuhv3m1T+EaJ2Y5pyv58PDUAkO9520ZE6t+XnQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=okluX9yTNaLp1ZnfXm5XuQcGsseEhB9qCbbfmdcd8qUM1skse1yH0v/FPViawqyuY
	 l48bn/xGRebnBUJ9AdABzj0ay7c/iWiI8P40kPBqrVviF9Dbbni8LZxryEBh1wwCfN
	 zuXMZPYlJjTrUFEdaGnap6ut+le2i59kCS5XV85+NjiCmT1FdGgBp3Acsyyk+GlMo2
	 mUxHJ0QProqiW5DM9feYvygRc9KZUjmgnC4psp/F4RCCulWbOvjkvLXpIGn2Ec0RE2
	 gr/J83XM9cZaVu7xDoBOlzdSr7rjVAdSiz2Smvp+mXazvOVmze72JZ+kdy/tV8R2cM
	 NcuKIjx81ftaQ==
Date: Fri, 23 Aug 2024 17:19:32 -0500
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
Subject: Re: [RFC PATCH 03/21] pci: Define TEE-IO bit in PCIe device
 capabilities
Message-ID: <20240823221932.GA391302@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-4-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:17PM +1000, Alexey Kardashevskiy wrote:
> A new bit #30 from the PCI Express Device Capabilities Register is defined
> in PCIe 6.1 as "TEE Device Interface Security Protocol (TDISP)".

Include spec section number.

