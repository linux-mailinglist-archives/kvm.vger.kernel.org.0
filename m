Return-Path: <kvm+bounces-16424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 074F28B9F2B
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 19:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B08791F21E2C
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3BA16F914;
	Thu,  2 May 2024 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XBY2AG1P"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B4415D5C4
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669360; cv=none; b=mXNX9BeUcR9kgSJzUwKPFJyte3GmRxsrGuKPOaCSsFX/WoC8/0V2mTTz62AiZGexrD6E7qc9eOTu+HtNFygqhycHCaqXTfpO0z+GYm+xQkN5VNRrcGe7SFL5Ju7OrQbX+SenQMfN2lJERe0dnL5bIXYvSR3KlgEhD2jcRoQLFL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669360; c=relaxed/simple;
	bh=oMBavOVRepl04bw2bX07AP1jx/mND6Jb2CJjAf48G8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmCGfqYd7MEeVErG94XK9fB2kb/CQ9EzsHfNGfVuO15wTrkTL+o5f8hcjK+5fCkZCxTT9mFAOKGZKKZpaa64v4rUoDydiNNOHkvWBOaKxSEHpYZgAAenLlAUIsRO1DYxXnuyGvJN3odeAQU51FJ0SF5+XjYcOa81YhlBA6ga6i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XBY2AG1P; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 10:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714669357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L3xYKyc7qvWlRo+eUMy1DICO6wKLqe1hNLnJT3EGrvc=;
	b=XBY2AG1PJtUIyIMli8kLg1I+5+Y3BxBqZNwcuUo5klSqpCgLxfm3TuTppC/bu53KxgLfYh
	L2Q0s6Vze7mjA3PMQmtoWc5uBByXHZctZunvX3BJOJmXFfjrnx9FZxJzUGVU2fLwrKIkFA
	RCXQQ2USwbgt4m/MY7Q1ryG5grQB1EU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic: Allocate private interrupts on demand
Message-ID: <ZjPHJjSJMe2BgaXr@linux.dev>
References: <20240502154545.3012089-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502154545.3012089-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 04:45:45PM +0100, Marc Zyngier wrote:
> Private interrupts are currently part of the CPU interface structure
> that is part of each and every vcpu we create.
> 
> Currently, we have 32 of them per vcpu, resulting in a per-vcpu array
> that is just shy of 4kB. On its own, that's no big deal, but it gets
> in the way of other things:
> 
> - each vcpu gets mapped at EL2 on nVHE/hVHE configurations. This
>   requires memory that is physically contiguous. However, the EL2
>   code has no purpose looking that the interrupt structures and

typo: looking at the interrupt ...

>   could do without them being mapped.
> 
> - supporting features such as EPPIs, which extend the number of
>   privrate interrupts past the 32 limit would make the array

typo: private

>   even larger, even for VMs that do not use the EPPI feature.
> 
> Address these issues by moving the private interrupt array outside
> of the vcpu, and replace it with a simple pointer. We take this
> opportunity to make it obvious what gets initialised when, as
> that path was remarkably opaque, and tighten the locking.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

