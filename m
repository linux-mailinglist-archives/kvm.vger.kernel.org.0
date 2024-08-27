Return-Path: <kvm+bounces-25188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62F039614D6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 19:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 960E71C229C2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C681CEAB4;
	Tue, 27 Aug 2024 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PKS77+tp"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142931BF54
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724778076; cv=none; b=YgIjWO4R6k0ZulCvRmtjvC7Dl2M8X9NL6j27YMo6pR0B91dYNhhgNFui7M+8h8LSIRFuz10DTw09I+dZTx8WYQiEeCk9JJh318bSe6g/pds/DaJELQKpSHu2sH742i7NysLGhv2FoFy2kNkfwhhaxnsy6wCQ3a7ltVFYcQY9Ups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724778076; c=relaxed/simple;
	bh=s+s49fN/FAiOcamtBM8CmOMVLJc/w0FfOuGGIjEMgkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAJZkFS1uXpzm7l6gnkya9PmyxJ+g6FoPVJKhkTy/J4w35mfVJzUQPyPvW+oaRmGyHNqoNcrF5pOeRBC7iUmfFghN5/wXjtns3zY6V/2Il/IH8/a7YOWTdJcpjRbeKDdAQjceQLvdMj9FXfzxa1+rOkakW7sYyuY3rSsM97i3fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PKS77+tp; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 27 Aug 2024 10:01:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724778072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MV12ntjo4cxMXNDjQ7ec7Q6W3AL3teSESN1/QLqjjxw=;
	b=PKS77+tp3JM/UMvuFCxQQnisoTXR7DAgJVmkv+pcVUDEXyzMr29CfF79jnqKuIqnoYWAB2
	b172WCEOzib9d3mSliGTuxS0y+aSTiWc0e0lbxebReSkwOXvX+plEEmwVJvPfFbc33z+Za
	MJ9Bm3AnZaUTqive9F/CmyPRkhz/VCk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2 00/11] KVM: arm64: Handle the lack of GICv3 exposed to
 a guest
Message-ID: <Zs4GTkO8CCiQMWG-@linux.dev>
References: <20240827152517.3909653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 27, 2024 at 04:25:06PM +0100, Marc Zyngier wrote:
> It recently appeared that, when running on a GICv3-equipped platform
> (which is what non-ancient arm64 HW has), *not* configuring a GICv3
> for the guest could result in less than desirable outcomes.
> 
> We have multiple issues to fix:
> 
> - for registers that *always* trap (the SGI registers) or that *may*
>   trap (the SRE register), we need to check whether a GICv3 has been
>   instantiated before acting upon the trap.
> 
> - for registers that only conditionally trap, we must actively trap
>   them even in the absence of a GICv3 being instantiated, and handle
>   those traps accordingly.
> 
> - finally, ID registers must reflect the absence of a GICv3, so that
>   we are consistent.
> 
> This series goes through all these requirements. The main complexity
> here is to apply a GICv3 configuration on the host in the absence of a
> GICv3 in the guest. This is pretty hackish, but I don't have a much
> better solution so far.

LGTM, thanks for respinning.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

