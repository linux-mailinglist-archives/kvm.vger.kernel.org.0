Return-Path: <kvm+bounces-8638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9B8853DAE
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 22:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1F11B2BAA5
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 21:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F916311D;
	Tue, 13 Feb 2024 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GYGxW80H"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C121B63109
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707861157; cv=none; b=rikOxFoNa057aNXh7tis0b/r1MbbUUO3F5qC2UpFRvuhKCX54CdEQ+opSEaZCWDpirD154YSgdmFT6NpQx7rqVdCK1fJpYbaqy7cMgDfk1xZPuTMlrbjfuKRAN0FGFfMQy51GpsyKVMlBw0OGkiS9S4g8yTv4O7TpeRUTQkrBvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707861157; c=relaxed/simple;
	bh=fhShqoILCUk+2VsKNFG31/0McM3osyT1MIpcWS7u0lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVzUXd2u0Ed6erGIkDWBM1St6434c6tiMK6dpM64pMpM5hnBSeE0284OAPAwEN4D5d7y1xhxeVpvCfO1sBOLKi0OeI+wbcmivhOny3deZKayb8cWOGPS5sONSvogbAU8fvnoJCFiA7OSdplT6H9Ec3ali70v20PxdibvQtshaUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GYGxW80H; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Feb 2024 21:52:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707861152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qycvjDD+0X9R6EvP7TIAray+KO8uJwU/ICZWA0GAqCk=;
	b=GYGxW80Hs8t3lzO+RAjC5AP04+SzHPyZlUN7nOOEovnBK9FLaGHFjZiZQWxRzzt+x4tSxQ
	oS++jd2TVFAv18PtPrJRR6qEpBCzJcm0Bb9uE5CImm/79U0UxxiyisDpfqu59CSXssNtY2
	/pZyRmFGAwpIyLZUvQe/8Ih4XCijJlA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/23] KVM: arm64: vgic: Store LPIs in an xarray
Message-ID: <ZcvknAFyvCl6bRgd@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <20240213093250.3960069-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213093250.3960069-3-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 13, 2024 at 09:32:39AM +0000, Oliver Upton wrote:

[...]

> @@ -87,10 +93,20 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  		goto out_unlock;
>  	}
>  
> +	ret = xa_err(xa_store(&dist->lpi_xa, intid, irq, 0));
> +	if (ret) {
> +		xa_release(&dist->lpi_xa, intid);
> +		kfree(irq);
> +		goto out_unlock;
> +	}
> +
>  	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
>  	dist->lpi_list_count++;
>  
>  out_unlock:
> +	if (ret)
> +		return ERR_PTR(ret);
> +
>  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);

Hah, I need to get my head checked. This is *still* wrong!

---
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 0265cd1f2d6e..5579660abf7a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -104,11 +104,11 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	dist->lpi_list_count++;
 
 out_unlock:
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+
 	if (ret)
 		return ERR_PTR(ret);
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in

-- 
Thanks,
Oliver

