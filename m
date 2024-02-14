Return-Path: <kvm+bounces-8703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 581B285522A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 19:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD90292142
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 18:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A244613A26B;
	Wed, 14 Feb 2024 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CP+h46Zp"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1813A262
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 18:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935534; cv=none; b=BsGLiCNj5AlaNkIptSSUqHt1mbLf+thBEH5DyHPa4juiXfwx5sICE54UorMpkJUwbK0SiEL7eFYx3+a8qu4Q2fCm4394SomQBD3nfQH9/K4zTPxYusD7pa28v+SD+LB1qucjy5E+y0LZ3H/34QLx12dS1J+4FBd0KrxZHQxAfXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935534; c=relaxed/simple;
	bh=hQJBRQGs+RMDCzJU9MhP0ybkU+4yNcL1dqxEYsEzrCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onjTv36txctfI2u2zKFnMQh+GRQvHmYYPKukliOJ0gtPIWVH0nfHdlzSaLEQReTgDqZDrZxiSyBwFQh7dUCrJueBHizo0l7KNS0P9iJaeU+bk8Gs0cmeMJa1yinuN1eQvwhtBP42aCe2Y5iyH8H/JT5SPJqpBMFqRFGdYVa7HwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CP+h46Zp; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 14 Feb 2024 10:32:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707935531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfEPhq0mY5MqLsPcWaUBe1RZW2jMzAXPTv3wIHSwKlQ=;
	b=CP+h46ZpoN7SQ22Jluz5ihfwrCgfTdgpoPkPirGUtf3QP+9gfQ7TEZm0pRPTbYuEMl+pm6
	Ww60ZIbeXtIkx2Xu/Bq+4IhqE7Uhwq33o4iA5pVBPTUjRu3nib+0GpnTUKxEf3sTAFbAJW
	3lyWZklfv39+UBTo+dfGIdiaYZGg6Ts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/23] KVM: arm64: vgic: Use atomics to count LPIs
Message-ID: <Zc0HIorNZG9KG5Mg@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <20240213093250.3960069-8-oliver.upton@linux.dev>
 <861q9f56x6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q9f56x6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Feb 14, 2024 at 04:47:49PM +0000, Marc Zyngier wrote:
> I'd like to propose an alternative approach here. I've always hated
> this "copy a bunch of INTIDs" thing,

Agree. 

> and the only purpose of this
> silly counter is to dimension the resulting array.

Well, we also use it to trivially print the number of LPIs for a
particular vgic in the debug interface.

> Could we instead rely on an xarray marking a bunch of entries (the
> ones we want to 'copy'), and get the reader to clear these marks once
> done?

I think that'd work. I'm trying to convince myself we don't have bugs
lurking in some of the existing usage of vgic_copy_lpi_list()...

> Of course, we only have 3 marks, so that's a bit restrictive from a
> concurrency perspective, but since most callers hold a lock, it should
> be OK.

They all hold *a* lock, but maybe not the same one! :)

Maybe we should serialize the use of markers on the LPI list on the
config_lock. A slight misuse, but we need a mutex since we're poking at
guest memory. Then we can go through the whole N-dimensional locking
puzzle and convince ourselves it is still correct.

-- 
Thanks,
Oliver

