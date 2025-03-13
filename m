Return-Path: <kvm+bounces-40910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3AAA5EF48
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:14:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84FF817183D
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 09:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0E2264630;
	Thu, 13 Mar 2025 09:13:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE5264623
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741857237; cv=none; b=G8QIfjjS868ZMxq49lTE5Y3Z3byUmQBTynDK8WH/3bpaAVW4XUN9gp2kDFXvZe1ftHiaPY8yMoTGw9fIDG1Ql2c46QP383tIFaUrSiyPpH9HvRlDMqo36oSdYnwlyyWucP3D0o0y4tjyzQcN2H0gtimwJaIm4h1Hb13+nTH6TSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741857237; c=relaxed/simple;
	bh=D8GqWj54rNQzl6V25ALpztmfuPmNfOaft6V/tc0zXeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftveZ9WiEhap/Ixhh4RYIttNBJYnxP+bZHHTOXLEgJj6Ub5a5UlTbJTTjYJSIlTadNfde23a5Vk//qHrTAqulkwH64OTQx86sJzOCEocSY7FGh2We1eN/wPMhzTEiJI3YsJ3eqb5UR+14RCJxHVKljjFFoKpm5RxMK1vx9nltG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D72568AA6; Thu, 13 Mar 2025 10:13:49 +0100 (CET)
Date: Thu, 13 Mar 2025 10:13:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>, chaitanyak@nvidia.com,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, kwankhede@nvidia.com,
	alex.williamson@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to
 indicate SGLs not supported
Message-ID: <20250313091349.GA18939@lst.de>
References: <20250313052222.178524-1-michael.christie@oracle.com> <20250313052222.178524-4-michael.christie@oracle.com> <970e0d79-f338-4803-92c4-255156a8257e@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970e0d79-f338-4803-92c4-255156a8257e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 13, 2025 at 06:02:29PM +0900, Damien Le Moal wrote:
> On 3/13/25 14:18, Mike Christie wrote:
> > The nvmet_mdev_pci driver does not initially support SGLs. In some
> > prelim testing I don't think there will be a perf gain (the virt related
> > interface may be the major bottleneck so I may not notice) so I wasn't
> > sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
> > so we can tell nvmet core to tell the host we do not supports SGLS.
> 
> That is a major spec violation as NVMe fabrics mandates SGL support.

But this is a PCIe controller implementation, not fabrics.

Fabrics does not support PRPs and has very different SGLs from the
PCIe ones.  The fact that the spec conflates those in very confusing
ways is one of the big mistakes in the spec.


