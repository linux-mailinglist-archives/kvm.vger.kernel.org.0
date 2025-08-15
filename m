Return-Path: <kvm+bounces-54805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA65B28619
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 20:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60824B05C3F
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 18:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A5F304BB5;
	Fri, 15 Aug 2025 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EUyntAwU"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EFD41C63
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755284197; cv=none; b=Cu5tuu0ODKNCHNUj8CX4F2KB8IW90CuQbunkqHgElJYL3OefS0eQ4WLI8/FVxHjBxMMsdbvlxDcc0FHLjo9AitwU3Y9k0s8KicDXr2MLv3aJhJ0/FyicAWLzEbHkB+7JIDcHNSQ9Vr2PlXN1Y96Vnhkp5aTNexafGUk5Z3d8vfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755284197; c=relaxed/simple;
	bh=EnaU4b4BQq+lkAyTdDiB/9LaASwrKTZEFuTi9pN7/P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5ZQEc2GX5Mzfd8yADQg30MMNfHXhDUhH3+ixH3bhpy++ZZeSy1pd/qBIUDs+QNoCvbKO3Ha78GzpqkCbxO+VP4L4RCOHL4/ZE8+ZA/jjxp7O7fQ0X1QsvyUQ7lad0TeLVO5IHR6oOJNJptzSl0CnKKo5B0ajUSKoEV5a29JGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EUyntAwU; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 15 Aug 2025 11:56:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755284192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lcbfpvMeFZQQn0Wme2x0gtEmZjwzrQjTk83v9La0I3o=;
	b=EUyntAwUGNP/CpsSxVdmHUhjkdjEdHDWrZWWYFZIDeeITLWtAbhB3hO+OwHpaSTwnIx21Q
	01GwZJmbrE0uNEcu0XDorAhiZVvHELUpOkSvwqt9MpAMSmjB+Jp6bewqgzu3Lz0ifQUmBh
	vALVpkSNpUgK73qZTRlhGWrPhb8WSK4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Volodymyr Babchuk <volodymyr_babchuk@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Fix vcpu_{read,write}_sys_reg() accessors
Message-ID: <aJ-C1-t34aVmHLjY@linux.dev>
References: <20250809144811.2314038-1-maz@kernel.org>
 <20250809144811.2314038-3-maz@kernel.org>
 <aJuixWlc87f2UlK0@linux.dev>
 <86ikipev46.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikipev46.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 14, 2025 at 05:16:57PM +0100, Marc Zyngier wrote:
> My current conclusion is that a macro hack is not really practical, if
> only because we end-up here from out-of-line C code, and that at this
> stage we've lost all symbolic information.
> 
> We *could* take the nuclear option of re-modelling the sysreg enum as
> a bunch of #define, similar to the way we deal with vcpu flags, and
> have accessors for the various bits of information, but that comes
> with two different problems:
> 
> - we don't have a good way to iterate over symbolic registers
> 
> - we need to repaint a large portion of the code base
> 
> Given that, I've taken another approach, which is to move all these
> things close together (no more inlining), and add enough WARN_ON()s
> that you really have to try and game the code to miss something and
> not get caught. In the process, I found a couple of extra stragglers
> that are always loaded when running a 32bit guest (the *32_EL2
> registers...).
> 
> I've pushed the current state on my kvm-arm64/at-fixes-6.17 branch,
> and I'll try to repost patches over the weekend.

Thanks! I've taken a glance at the branch and LGTM. Just wanted to make
sure we have sufficient idiotproofing for the next time I misuse this
stuff ;-)

Best,
Oliver

