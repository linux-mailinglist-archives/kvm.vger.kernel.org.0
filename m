Return-Path: <kvm+bounces-16402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4113F8B96E7
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 724281C210D1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AC44F88C;
	Thu,  2 May 2024 08:53:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E7D22F00
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714640020; cv=none; b=O9HhrFXC4aH+Dmi1WdTIrLwG1tmxchNst+JeEC3qPG038AQRSGlEYmDQb4BDUacTHcGDPPBC9PcV/EVmAvjhIzt0o82EjzmtJnaR2xZSV7LfSP8BvRRV+xWUQQmbLWJ8GK2bABFCeY1wSSpbcNociccdaMEYz+AYCmxu4a/iJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714640020; c=relaxed/simple;
	bh=kBXFxcRpsGgFL2gsK677E62BQQH6Ff9kxpq2NmgT9ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fw4HVCPd8t7lHPqPSNuVjBLiURX06WfDXyx/TP6rEIMlnJa7Jdk2LhfSZQ3grLeONQgsFtGBC68bZCuWFcd7FNV/HzGRKqBFRVLsPZNvLjDn2ztceUNa2PyH+opYCKEgJ9X80aeh0LJZYVl5R2K/NVQP6g4bnpggPvEsDoA6HuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2A882F4;
	Thu,  2 May 2024 01:54:03 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5DAC3F71E;
	Thu,  2 May 2024 01:53:36 -0700 (PDT)
Date: Thu, 2 May 2024 09:53:34 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
Message-ID: <ZjNUjrPUb28mOe4W@raptor>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
 <c0c32041-38b8-4918-bd6f-7637ce515fd2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0c32041-38b8-4918-bd6f-7637ce515fd2@redhat.com>

Hi,

On Thu, May 02, 2024 at 09:58:39AM +0200, Thomas Huth wrote:
> On 02/05/2024 09.41, Oliver Upton wrote:
> > Some arm64 implementations in the wild, like the Apple parts, do not
> > support the 64K translation granule. This can be a bit annoying when
> > running with the defaults on such hardware, as every test fails
> > before getting the MMU turned on.
> > 
> > Switch the default page size to 4K with the intention of having the
> > default setting be the most widely applicable one.
> 
> What about using "getconf PAGESIZE" to get the page size of the host
> environment? Would that work, too?

That would definitely make the tests run,  but I'm worried about
reproducibility. If you want to re-run a failed test on a different
machine, this introduces a new variable, the host's page size, which might
be different between the machines. Or, if you want to look it another way,
another configuration knob that the user has to be aware of and control.

Unless there's a system out there that doesn't support 4K pages, I'm in
favour of having 4K the default.

Thanks,
Alex

> 
>  Thomas
> 
> 

