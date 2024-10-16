Return-Path: <kvm+bounces-29038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E529A15C2
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 00:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE4A91F21CFB
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 22:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510F41D45E2;
	Wed, 16 Oct 2024 22:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pwHcwj1Z"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BE71D2F5F;
	Wed, 16 Oct 2024 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729117257; cv=none; b=RG0XK4lNo48HxAnDfqN1DPOJCq/pWKnM32YpUdWBORMsusEuUNwzCB/DOcNeMdYWO5gfiKVGYJpfxPlv9xjz+mCBDj9wN1ch7UU9XERTx0QUCqnNwdh8gJrT6HbjtV6WTTrnkyb6B+UB/o4KiLOlfMco/1Qi7HtrglcTQFnKl98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729117257; c=relaxed/simple;
	bh=rpAo2bq/X0bzymyXl7qBfRjhyv0bI95I2EG0AS8gNCw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/U1eU24D8Pxl/zH9BnRWJD/RbfNCUok8Z27wvIZmwO8w4nuTl2RytupnUmVg6CNt8lhotd41zOA9kaK218jWGQuvs/utG2UM/f8LeNWYP0BlOjUEbgTw+ciy2bg87Uo66QzOpP5oeVzzRvORyOAfFMiVXKGjBcTYskRySDcEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pwHcwj1Z; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from DESKTOP-0403QTC. (unknown [20.236.11.29])
	by linux.microsoft.com (Postfix) with ESMTPSA id EEE8A20E1A5A;
	Wed, 16 Oct 2024 15:20:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EEE8A20E1A5A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1729117249;
	bh=WD3Ep8nGPeg1tM5YhegcRnyJhwTRJLT6LHrHFVSMVX8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=pwHcwj1ZTCxfkG6lQVmO6XgXN3JVRw5injt7MQgSQIWed4KS7nLVgv3LYpB2TtL2r
	 bs8lvZwXy0FT0M1o4at49XgSDJk0rNARIBhbp2cak03QSnsWqc89pKF/luci+cTBwG
	 5dAeCaQMoH3ZfG/Hd0bf3UA/zVrxxHpnB0UqU6mE=
Date: Wed, 16 Oct 2024 15:20:47 -0700
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: James Gowans <jgowans@amazon.com>
Cc: <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin
 Tian <kevin.tian@intel.com>, "Joerg Roedel" <joro@8bytes.org>, Krzysztof
 =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 <iommu@lists.linux.dev>, "Sean Christopherson" <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>, David Woodhouse
 <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Alexander Graf
 <graf@amazon.de>, <anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
 <nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>,
 jacob.pan@linux.microsoft.com
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and
 ioas
Message-ID: <20241016152047.2a604f08@DESKTOP-0403QTC.>
In-Reply-To: <20240916113102.710522-6-jgowans@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	<20240916113102.710522-6-jgowans@amazon.com>
Reply-To: jacob.pan@linux.microsoft.com, Saurabh Sengar
 <ssengar@linux.microsoft.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi James,

On Mon, 16 Sep 2024 13:30:54 +0200
James Gowans <jgowans@amazon.com> wrote:

> +static int serialise_iommufd(void *fdt, struct iommufd_ctx *ictx)
> +{
> +	int err = 0;
> +	char name[24];
> +	struct iommufd_object *obj;
> +	unsigned long obj_idx;
> +
> +	snprintf(name, sizeof(name), "%lu", ictx->persistent_id);
> +	err |= fdt_begin_node(fdt, name);
> +	err |= fdt_begin_node(fdt, "ioases");
> +	xa_for_each(&ictx->objects, obj_idx, obj) {
> +		struct iommufd_ioas *ioas;
> +		struct iopt_area *area;
> +		int area_idx = 0;
> +
> +		if (obj->type != IOMMUFD_OBJ_IOAS)
> +			continue;
I was wondering how device state persistency is managed here. Is it
correct to assume that all devices bound to an iommufd context should
be persistent? If so, should we be serializing IOMMUFD_OBJ_DEVICE as
well?

I'm considering this from the perspective of user mode drivers,
including those that use noiommu mode (need to be added to iommufd
cdev). In this scenario, we only need to maintain the device states
persistently without IOAS.

