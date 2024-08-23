Return-Path: <kvm+bounces-24956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F9995D92C
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E693C1C21B5E
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5677E1C8716;
	Fri, 23 Aug 2024 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ke59IqoH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AC8192590;
	Fri, 23 Aug 2024 22:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724451540; cv=none; b=YDOYoBlNpwUuJWVnyzlFsv44rGRE3igc03MbmoQ9C40z2ZTvmtN/EtmKcZgb/h9PS1OMwwmiV5LzOWcW45egOFAYrti9q7i83qbH/eAt42BfPhxzLOqvo+5cfERbyy4woWnQ0TbGkc+JiBdQq6q28i0AmQ44aQJ+P4Jmha5CLkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724451540; c=relaxed/simple;
	bh=CywqaPcWvNQMLuUnkX/D3hSMUqm1ICaLWW3Thh45dw0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=kGB69gOlD+bjn4IxgiCng93LO7P4yjzW4sLz20NZHiNMMtouPuL1ucyxevdyMJvc0tuUlh1PSw86Sa4xUnJRrTBj7JDsoFTmDn/P0kTp/01qGZKC8T2RaQl4AVxmkOBA1w+80eDMaQwHJHlyFWs7/OqqXLDhbt+RXqmaMOn1M9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ke59IqoH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EEEC32786;
	Fri, 23 Aug 2024 22:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724451540;
	bh=CywqaPcWvNQMLuUnkX/D3hSMUqm1ICaLWW3Thh45dw0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=ke59IqoHdwWW2oE3BIQfAPs3rJONg0ExI12ZbP2VJ3exAtt+JA8hSSFaHb4YWKGqr
	 J4UY4PAUQ77lcGUt+zbx6JnqWjkmVUHqGtJY/fWZEYU4Ag3zaFbKi5HtuNIc6c7sRd
	 TutZaZheyRE3bD1YWuq6+5nQBaFqDDus9M5RWtfoEnAtmxg5r4JM1DiVX3IU9o92iX
	 j1tetuYvZubPZ/rYU/vntqkHWoqRuQ5vj8iLBD8s161gcQ1nVb/uPjMZaD8B5B7gH4
	 xSfNFkqgaVVpTABmbMf990VUELduRPL44tT0tc0jg31JWVc+gPY3Wpc2r6cWeyDF7i
	 Kfq82khHDTTMg==
Date: Fri, 23 Aug 2024 17:18:57 -0500
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
Subject: Re: [RFC PATCH 02/21] pci/doe: Define protocol types and make those
 public
Message-ID: <20240823221857.GA391220@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-3-aik@amd.com>

Run "git log --oneline" and follow the drivers/pci capitalization
convention.

On Fri, Aug 23, 2024 at 11:21:16PM +1000, Alexey Kardashevskiy wrote:
> Already public pci_doe() takes a protocol type argument.
> PCIe 6.0 defines three, define them in a header for use with pci_doe().

Include section number, e.g., PCIe r6.0, sec xxx.

Rewrap to fill 75 columns (or add a blank line if you intend two
paragraphs).

