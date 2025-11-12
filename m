Return-Path: <kvm+bounces-62825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B43C501CB
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 01:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 767B01896F08
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 00:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3D844C63;
	Wed, 12 Nov 2025 00:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fz3Bxz7+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24FC12B93;
	Wed, 12 Nov 2025 00:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906119; cv=none; b=QTNlANSC0zOl5VoJ4YW/6gcH0+qYGHMOq+MQS7gu9D12lptjyGqR8CCpHHBr+TRfOhYGnfI1/Iylp/cGT2QAp0Xm1Xi8pLYOMuM6iPKHgiIGQtS6sdsGBhY34xpC4CM+VbpI3axjAFWtYaf5wi9jO3C5haMSjrxloWLQz1Y1Os8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906119; c=relaxed/simple;
	bh=x2q3/YmBP7+xUvA10uWwMegTPDYA5rCthXeXB7vi3nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vq5qAxpV+lmQ6T4t5AAusUxgrsNTxLpWJDIJiQHYpRr5ILKIT3vNMftMckH4O6ucObPKgX2EOHZixgaU0NwjyBlPQWbmQLX2knhPvJj2Z6ZBjla4KcRNeSSPv0a3rSJhhIKhDzUvIK4usLpNARTilPjYpcz2aJraXdQJmRRVc+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fz3Bxz7+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE0BC4CEFB;
	Wed, 12 Nov 2025 00:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762906119;
	bh=x2q3/YmBP7+xUvA10uWwMegTPDYA5rCthXeXB7vi3nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fz3Bxz7+XSxc+KAFCkBAmJ2wjFOBYwh4qNy5j4kmuZf1aSEkIp14TOXMKs2X31cSj
	 VyS691SEYvi+9eU7J7hRPcd86VVMci8puqDKKh6UEfyl1mgPXFCIFQiR465L5W9vKH
	 hw9+Yl8jKzZAuz/Qb1HG9iCFfsYp8tt2zCcQfi+QoBXp68+L08gyr5S4x4vUsqW3Sn
	 JFuq1ylEOVbm1GRB7GEPaRNqcBsIMr49W8wGAQzqlzo7In5aGMUybaLqdi2kSiFBUp
	 AcKEZsZjF4CQF8N3Kc+1OGhmj/U3nSeRimD8JDZCFqYyYjnBomwooybDfGmLIsq67v
	 8azQGBxmu+TbA==
Date: Tue, 11 Nov 2025 16:08:37 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 20/45] KVM: arm64: Revamp vgic maintenance interrupt
 configuration
Message-ID: <aRPQBQVPLVXGOxU-@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-21-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109171619.1507205-21-maz@kernel.org>

On Sun, Nov 09, 2025 at 05:15:54PM +0000, Marc Zyngier wrote:
> +static void summarize_ap_list(struct kvm_vcpu *vcpu,
> +			      struct ap_list_summary *als)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_irq *irq;
> -	int count = 0;
> -
> -	*multi_sgi = false;
>  
>  	lockdep_assert_held(&vgic_cpu->ap_list_lock);
>  
> -	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> -		int w;
> +	*als = (typeof(*als)){};
>  
> -		raw_spin_lock(&irq->irq_lock);
> -		/* GICv2 SGIs can count for more than one... */
> -		w = vgic_irq_get_lr_count(irq);
> -		raw_spin_unlock(&irq->irq_lock);
> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> +		scoped_guard(raw_spinlock, &irq->irq_lock) {
> +			if (vgic_target_oracle(irq) != vcpu)
> +				continue;

From our conversation about this sort of thing a few weeks ago, wont
this 'continue' interact pooly with the for loop that scoped_guard()
expands to?

Consistent with the other checks against the destination oracle you'll
probably want a branch hint too.

Thanks,
Oliver

