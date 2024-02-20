Return-Path: <kvm+bounces-9225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C47A685C323
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 18:57:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65B721F250A9
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF2077658;
	Tue, 20 Feb 2024 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CJr/Pn8O"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA376C70
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451861; cv=none; b=Lgnv7mRzetQT/UQ65szQghY9qr/oXfOVkWUzSdgduZAGeMXksyq+UidMZHp/P2gWI4YHWLHDRLn9PeJL3nsHvh9NCp/rqgGoczrQ4KsyTSxLGzWIAVAy/7aG0A9ZugT86sGcf+nCc+BQQmgkScxUktd8sz2U9PNmR7dEhooWpaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451861; c=relaxed/simple;
	bh=JM53lWnvE6SqliDKSCYuchF19mgSxwrFWeot9zR3M7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuNB9nqXKd0644ldP4uNI4Sst4UjMWlm3cExZku95Fgof6bToKLXvGZ1nYa+iLJPX++o4Cfq5tRRB2VYyTonaBpJA44vv9TOptQrD1qnPOsH1ekDXZ+RFZ3A9/lo3XBY7JIKU9+Q0IkUUzQK5ttE0eZGqXTtnViYvh7ph2ga9O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CJr/Pn8O; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Feb 2024 09:57:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708451858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W3c+aRtUD1dd66eZygChyjJvf2ILxG0fQE6zxgpa+Vs=;
	b=CJr/Pn8OsUzShpXOWyY9n1E8x3uhRIUVyFuj4PioBFQdigtbTVv8LZqg5dPoBjZT7oKM/Z
	L27+oV2rljPnloaZKVVIjDH1GZPUDkN+ZrHAwWO0umLSqGJ1VOO/T9d6XrjJAqCnMTDQTq
	JZVtv59QXm/iWpRtA63UlQ3OHYKJSY0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
Message-ID: <ZdToC9apbWmDaugn@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-2-oliver.upton@linux.dev>
 <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev>
 <86wmqz2gm5.wl-maz@kernel.org>
 <ZdTkp3MnffZwJkyf@linux.dev>
 <86v86j2f9o.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v86j2f9o.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 20, 2024 at 05:53:55PM +0000, Marc Zyngier wrote:
> On Tue, 20 Feb 2024 17:43:03 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > I think we can get into here both from contexts w/ interrupts disabled
> > or enabled. irqfd_wakeup() expects to be called w/ interrupts disabled.
> > 
> > All the more reason to use irqsave() / irqrestore() flavors of all of
> > this, and a reminder to go check all callsites that implicitly take the
> > xa_lock.
> 
> Sounds good. Maybe you can also update the locking order
> "documentation" to include the xa_lock? I expect that it will
> ultimately replace lpi_list_lock.

Yep, I got to the point of deleting the lpi_list_lock on the full
series, which is where I update the documentation. I really didn't want
people to know I'm adding yet another layer of locking in the interim...

Anyways, I think there's sufficient feedback to justify a respin. I'll
make sure the documentation is updated w/ the xa_lock for the stuff I'm
trying to land in 6.9.

-- 
Thanks,
Oliver

