Return-Path: <kvm+bounces-52955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8A2B0B772
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 19:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05A8D1782D4
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 17:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD29221F06;
	Sun, 20 Jul 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/YCS9sr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1299F1CA81;
	Sun, 20 Jul 2025 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753033182; cv=none; b=TXWmt98yRfI7uZaAtksLYbE8bMbWTTpMfSMyMx6fSqBZ3zP7RBZ8KRBtAiBl61XGLPiWmOCYSX1mlgEjD1gWHnroJXLJGQq4KsB5tapm2zysdILAVmY6yFqRek5Od9e+hLA0ptpOGEKnLgte/kEgVCVSedIFamCJVoVxXmC9GLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753033182; c=relaxed/simple;
	bh=kHdJnWMZ/uSXE2znXW0wKKZ9+EwYpTW2ogmdFfsxD/s=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=p9T0Yr993B59SYgT1MKRvXg67qj10hSa1GnvOm3rbfjyDrSBtgkFWQM6boYDzMdj/dJTbkQuLRAxKOs9L5bWKIwaxagvN3dNGcL81Z6dz6YENbK75PX2KbhWULObeHQm/bmEKWTW9OSGxD2+Mfel5vy4myOPxW73BhqN/Sj+DSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/YCS9sr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86834C4CEE7;
	Sun, 20 Jul 2025 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753033181;
	bh=kHdJnWMZ/uSXE2znXW0wKKZ9+EwYpTW2ogmdFfsxD/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N/YCS9sr96beqAk3VqRCOHJ8lDgeb19X3LRh4clOUTA3bg1nh6Xglz5/7crHSwMLi
	 l2eTe5SBAHQjB6gFSyF15O7Frw9DibTEuLntVliH3m0ij0Q95OrlTL8KFlLCaxPDbH
	 yjhHylKFBaVnsdwLSmGWEYPwSfpkfURIF6qkvWtrSuw1K5/6ZT7+zOUDpOsvbws8Z6
	 ZvjhRVQ1R+lwn5AzCwQDPT9FxN/D+WmFHhXuHzvID79QwFG49jgRwBJfeeUZSH+Epv
	 a9ftMTp5KknEMwD0RjtYl/UMrMrTTgs56tQuST8fYIGevJSPXImkcRvGWUsbL/+cKg
	 BUEkgiBGmlGQA==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udY0h-00HONo-4C;
	Sun, 20 Jul 2025 18:39:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 20 Jul 2025 18:39:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Filter out HCR_EL2.VSE when running in
 hypervisor context
In-Reply-To: <20250720113334.218099-1-maz@kernel.org>
References: <20250720113334.218099-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <7e78eca5652baa9f0fefd4242066c966@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2025-07-20 12:33, Marc Zyngier wrote:
> HCR_EL2.VSE is delivering a virtual SError to the guest, and does not
> affect EL2 itself. However, when computing the host's HCR_EL2 value,
> we take the guest's view of HCR_EL2.VSE at face value, and apply it
> irrespective of the guest's exception level we are returning to.
> 
> The result is that a L1 hypervisor injecting a virtual SError to an L2
> by setting its HCR_EL2.VSE to 1 results in itself getting the SError
> as if it was a physical one if it traps for any reason before returning
> to L2.
> 
> Fix it by filtering HCR_EL2.VSE out when entering the L1 host context.
> 
> Fixes: 04ab519bb86df ("KVM: arm64: nv: Configure HCR_EL2 for FEAT_NV2")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c 
> b/arch/arm64/kvm/hyp/vhe/switch.c
> index 477f1580ffeaa..eddda649d9ee1 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -68,6 +68,9 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  		if (!vcpu_el2_e2h_is_set(vcpu))
>  			hcr |= HCR_NV1;
> 
> +		/* Virtual SErrors only apply to L2, not L1 */
> +		guest_hcr &= ~HCR_VSE;
> +
>  		write_sysreg_s(vcpu->arch.ctxt.vncr_array, SYS_VNCR_EL2);
>  	} else {
>  		host_data_clear_flag(VCPU_IN_HYP_CONTEXT);

Actually, a better fix would be just nuke any bit that doesn't affect
the HYP context. And that's almost all of them, bar the RES1 bits.

I'll repost something once I am done dealing with the rest of the RAS
enabling stuff.

         M.
-- 
Jazz is not dead. It just smells funny...

