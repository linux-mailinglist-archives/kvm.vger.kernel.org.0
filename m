Return-Path: <kvm+bounces-21934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CB79379BA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 17:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C3B21F215A9
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 15:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60ADB1459E0;
	Fri, 19 Jul 2024 15:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NbqaaX+A"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BCA4C85
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 15:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721402124; cv=none; b=rq2kbf1FVxAUzCaurv6HfM7IIdgf0/GjNyNslTtNyue3uRzgu6Bo1l9H/0Ny3PsbpriOd3QCdCiaL4Zp/V8luC5pjSZ4pL5kOlfJkQt2rWGjzTG+j4BFFtBWH8G4a4ov4ZIGKx+9GVVQheK7mdriIieK4o+uIto7on01qR2JeSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721402124; c=relaxed/simple;
	bh=thwOw1vk9TnMZIKOwscqEUgDmmNtS6ELjP4bw+r51mg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJh9ucj/86WLRaoAJOu4HR5tOanF3kX7KDQYie2voDUP53htD6GUw07iWCNyOyKCp2ky85UBNPrbg6EJ7d3KEJqsuiTq9W1UJOdJ1F7d+aNf5YYgs8Wml0wPVETDjARwRzANZuuwEOOSWreY18arGXEqc5aqfgAau4zPphSV0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NbqaaX+A; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: coltonlewis@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721402120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PAQuHshHUyfYgFLJbuvQs9agkb4OM0cf5/CJu/pDDvc=;
	b=NbqaaX+AoiTKB6AilVIQfAGASOmSzu18lsVoSK2FBH19PAfvHgJ3lZ8WaC9c817ThB9sHk
	ZzlJFzHmZlIISb0zj940TTxdE1H7Kep6O7SP5RLxmTAmVWmi4UHfnwD0IMxYDKdo37JlW8
	DPgyC/VUUmc6D7lRUJ5siYKzRLlocLI=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2024 08:15:14 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Move data barrier to end of split walk
Message-ID: <ZpqDAqgbP7Rxhxt4@linux.dev>
References: <20240718223519.1673835-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718223519.1673835-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 10:35:19PM +0000, Colton Lewis wrote:
> Moving the data barrier from stage2_split_walker to after the walk is
> finished in kvm_pgtable_stage2_split results in a roughly 70%
> reduction in Clear Dirty Log Time in dirty_log_perf_test (modified to
> use eager page splitting) when using huge pages. This gain holds
> steady through a range of vcpus used (tested 1-64) and memory
> used (tested 1-64GB).
> 
> This is safe to do because nothing else is using the page tables while
> they are still being mapped and this is how other page table walkers
> already function. None of them have a data barrier in the walker
> itself.

nitpick: in the interest of the reader, it'd be a good idea to state
explicitly what purpose the DSB serves, which is to guarantee page table
updates have been made visible to hardware table walker.

Relative ordering of table PTEs to table contents comes from the fact
that stage2_make_pte() has release semantics.

-- 
Thanks,
Oliver

