Return-Path: <kvm+bounces-30819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 870AA9BD801
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 23:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 382441F275BC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 22:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810B2216432;
	Tue,  5 Nov 2024 21:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ofUrlJl3"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8586C2161FC
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 21:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730843896; cv=none; b=PnTokV8iRp+LMI3D4QRMCHQPPb+MFNhZ8PWkU6M7xCNRjjq67dr5JzH0j/YaTEpBeYPTUsxUx2gXWrGi3RgMCsARIrj6T6T6KkM/gvHqCkkhPkH6QlVZNf2FjFjgG8qGabG2AMmT+rtiZTSdUsUFXe/3kfgZqVVX9bd7/iEVgxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730843896; c=relaxed/simple;
	bh=hVXm/x+Hcry9OdlFuKIcpWUw3L40KjuKcLvxB4+5XzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiEy07vdZ6MnWXw+YWslEG95hApij9on7Wotq2qguko1EcGw1N53S69jWIR4BwnXsyCXNKCAHUIHsDKO0SLkX0Ef7UsqAByJ5c6qJxabUiByKFfIjWSyW7v5naA+qSbb4FGmoTuafdO4bDNLEhhOJO7XxP0R39JHJPJryuN7JKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ofUrlJl3; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 5 Nov 2024 13:58:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730843892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6UFzjbbeEdMdGk/8zVuKGqEE3W0fzh4S53TXeFLNMes=;
	b=ofUrlJl3MqEQTDpDzSvG2BfYpHL5QiKe1pqicdzJ4Vs4qAwutZF8JdxwTSaa2Kbi/p8Uum
	vj92nC7diqkZ1hFMgVHhQ2qwLyJF14ivcp+XdahigfYyvlb+yFaZFFZFGLxCG7Ku1KeMTg
	AHM2bugexVMwqGBe8qCiRKlJC//v4/Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v1 0/4] Fix a bug in VGIC ITS tables' save/restore
Message-ID: <ZyqU6-uz55xJbm1d@linux.dev>
References: <20241105193422.1094875-1-jingzhangos@google.com>
 <ZyqPMdH4anLEIq8G@linux.dev>
 <CAAdAUthd+c71BTSEvQvCZoYE2vQPHabofK=947MspU1hUbZd+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUthd+c71BTSEvQvCZoYE2vQPHabofK=947MspU1hUbZd+w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 05, 2024 at 01:56:14PM -0800, Jing Zhang wrote:
> On Tue, Nov 5, 2024 at 1:33 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Jing,
> >
> > On Tue, Nov 05, 2024 at 11:34:18AM -0800, Jing Zhang wrote:
> > > The core issue stems from the static linked list implementation of DTEs/ITEs,
> > > requiring a full table scan to locate the list head during restoration. This
> > > scan increases the likelihood of encountering orphaned entries.  To rectify
> > > this, the patch series introduces a dummy head to the list, enabling immediate
> > > access to the list head and bypassing the scan. This optimization not only
> > > resolves the bug but also significantly enhances restore performance,
> > > particularly in edge cases where valid entries reside at the end of the table.
> >
> > I think we need a more targeted fix (i.e. Kunkun's patch) to stop the
> > bleeding + backport it to stable.
> >
> > Then we can have a separate discussion about improving the save/restore
> > performance with your approach.
> 
> Yes, I'll respin Kunkun's patch soon. This patch series has the
> selftest which we can use for verification.

Right -- go ahead and include your selftest as part of that respin, I'd
definitely like to have some test coverage for this whole save/restore mess.

-- 
Thanks,
Oliver

