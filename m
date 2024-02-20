Return-Path: <kvm+bounces-9216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EB285C16F
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3CA8280A82
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E449768E6;
	Tue, 20 Feb 2024 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i54KhuKP"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7DD692EB;
	Tue, 20 Feb 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708446661; cv=none; b=lQvOSfENeR0Bg0gJkh7zPhS/JRBGU5yoD1sTIVz1owx/N51qYkTa9P1GOeHdDqXI3/WI9ujtFBjPz/r98o4NHznOJ7OidVjcCnlhW6bjdOdgh+xCdjZuAcQEI4jbt3fmonBAUXUUtGJ9Ya8ED9TiMRYoRQZpXnU+b/qhR6m8VX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708446661; c=relaxed/simple;
	bh=1+/RA9pWeDwmtnkvb1unZWEhB64IvThTUVkVaz20I0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tl6f8zzXdO3qWma6hXoUnMbbRohlFcDCzTtWj0J9OfdNXJqcweUmz0uqQrP14wwOe6PnKgbc/PCfygwtsjGvio4G2HgCFnyM5bsCznHw8NAeOV3tvIJoVHoc7cPK20juZxzRORFDcAJI28x3YZ6NNiGb4jEovGxo4TI2vLdImCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i54KhuKP; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708446656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q36kWA/MC7EF1Sh3We0UtEcn1Ana4Gh6S3w6HUOZ5xw=;
	b=i54KhuKP0AuNirJ0AqIJGXRMIbcP+ZxJwNOenJcEtrLHcMEcOyccJ9w4qD1teOQNwhPjR2
	zq1poH3ELpJwXyyPVMs5m8G7vUjLw4Fhy81Cj+Mud9D69K7H7ZBoqE3Lfg3s4C5oiqZgpW
	uGQnio/fuyhObOC46oRKYCEGK1GrnA0=
Date: Wed, 21 Feb 2024 00:30:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-kernel@vger.kernel.org
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-2-oliver.upton@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20240216184153.2714504-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/2/17 02:41, Oliver Upton wrote:
> Using a linked-list for LPIs is less than ideal as it of course requires
> iterative searches to find a particular entry. An xarray is a better
> data structure for this use case, as it provides faster searches and can
> still handle a potentially sparse range of INTID allocations.
> 
> Start by storing LPIs in an xarray, punting usage of the xarray to a
> subsequent change.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

[..]

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index db2a95762b1b..c126014f8395 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -131,6 +131,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
>  		return;
>  
>  	list_del(&irq->lpi_list);
> +	xa_erase(&dist->lpi_xa, irq->intid);

We can get here *after* grabbing the vgic_cpu->ap_list_lock (e.g.,
vgic_flush_pending_lpis()/vgic_put_irq()).  And as according to vGIC's
"Locking order", we should disable interrupts before taking the xa_lock
in xa_erase() and we would otherwise see bad things like deadlock..

It's not a problem before patch #10, where we drop the lpi_list_lock and
start taking the xa_lock with interrupts enabled.  Consider switching to
use xa_erase_irq() instead?

>  	dist->lpi_list_count--;
>  
>  	kfree(irq);

Thanks,
Zenghui

