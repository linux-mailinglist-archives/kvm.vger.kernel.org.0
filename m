Return-Path: <kvm+bounces-8574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC7A851E9B
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 21:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F189A1C2205C
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 20:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF15487A7;
	Mon, 12 Feb 2024 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="huo7uteC"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E232482CA
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 20:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707769490; cv=none; b=tSw/Ki7QkG88gKLQgt8oa6NrBZ8lYH5VoKGw+TIw5ZZZLFkGvLs/8xTYY8CSKt22EaF2bkH8BsXKSM1J1FRILhE6V4ea1nNYPkWD826nZsHEBHHf0IJ/NAEUU/Oe21OrXaIJJeZHq1qLb3ydysidreXszYKwefVYMeqzZZwsL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707769490; c=relaxed/simple;
	bh=EW1iwgQRXKT66+pbcKRYd+o9vCcGD15QbpagYfyY78A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8AwQ8IgEFRRR7tYcyYRWlPSYXDnBfHdfVgAvpVXBZ4ZzPGsbvBbXe6f5kFlqk1RAMJWeSfIWF3pBQBE8VT6A1/59Ncaj/JG6bzWBqZ5MOHSKE6HQku9eF3lCaYkCKiMKlegl93ERGsTqHw62RYJEQjZUuQwlI3xKYqtw7HvN5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=huo7uteC; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 12 Feb 2024 20:24:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707769486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i4xg3mWKHsd+1fYsNi4Rtxp1tHHU5nJ+XHR6qN8at3A=;
	b=huo7uteCfELHBo8TMxLabpBxYmnmzdwnN/sLcsP79jePf7Mc8c3/ILRzwhsJOrGHEPkbR0
	Lfz4a2Uc0mYAV80Yt4bS38aTzrhDI9TTjC4BCAus3jHCiReJKZ0qQEjMGD5T2Uq1fuQlKc
	MJLrzegOaL66bjag9WKDbaF9pWlQRPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, alex.williamson@redhat.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, andreyknvl@gmail.com,
	wangjinchao@xfusion.com, gshan@redhat.com, shahuang@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, david@redhat.com,
	linus.walleij@linaro.org, bhe@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <Zcp-hIlV-ZEu0Jou@linux.dev>
References: <20240211174705.31992-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240211174705.31992-1-ankita@nvidia.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 11, 2024 at 11:17:01PM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> with DEVICE_nGnRE memory attributes; this setting overrides (per
> ARM architecture [1]) any device MMIO mapping present at stage 1,
> resulting in a set-up whereby a guest operating system cannot
> determine device MMIO mapping memory attributes on its own but
> it is always overridden by the KVM stage 2 default.
> 
> This set-up does not allow guest operating systems to select device
> memory attributes independently from KVM stage-2 mappings
> (refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
> which turns out to be an issue in that guest operating systems
> (e.g. Linux) may request to map devices MMIO regions with memory
> attributes that guarantee better performance (e.g. gathering
> attribute - that for some devices can generate larger PCIe memory
> writes TLPs) and specific operations (e.g. unaligned transactions)
> such as the NormalNC memory type.
> 
> The default device stage 2 mapping was chosen in KVM for ARM64 since
> it was considered safer (i.e. it would not allow guests to trigger
> uncontained failures ultimately crashing the machine) but this
> turned out to be asynchronous (SError) defeating the purpose.
> 
> For these reasons, relax the KVM stage 2 device memory attributes
> from DEVICE_nGnRE to Normal-NC.

Hi Ankit,

Thanks for being responsive in respinning the series according to the
feedback. I think we're pretty close here, but it'd be good to address
the comment / changelog feedback as well.

Can you respin this once more? Hopefully we can get this stuff soaking
in -next thereafter.

-- 
Thanks,
Oliver

