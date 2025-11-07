Return-Path: <kvm+bounces-62253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D611FC3E23C
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 02:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B9EF34E911C
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 01:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BC12F6905;
	Fri,  7 Nov 2025 01:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi5srRG6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBDC1D61BC;
	Fri,  7 Nov 2025 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762479304; cv=none; b=AYfeM771aEX3OKA2K57WxIAHXuH1IAP/d3Qzl0j7IV0kTgO7tCopiurcJPHlc3t+Jnw9PInIGuUaiBQiL1b31UQKBTUEN3FbUrmdiOlUFdf+BLjQr7gPsTjr8UQ6tIxM/d1L1US+2wtv2Y98QXFQpiKtyGwaCS9MUai+fAGgLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762479304; c=relaxed/simple;
	bh=RhgYGJJVIlLV+16NDohuEfj0KiMHJzVZLFlNY7wo5fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cb9paKIeSvAhzeMao0DyiFtfK7r1zl5KYqChxepvvbF5AgF0n2BgL8CZ6Z0R+FOUITmrYYZszNqytEz3U+1HCYaKL4fBAncqymzvKS00qJx+GQcsVwcuAw3iVtm+QtD/BJxjrwijqKS7Fu1YsnPJBSbA/+uDxSEcWTYeEdBf8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gi5srRG6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DACEC116C6;
	Fri,  7 Nov 2025 01:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762479300;
	bh=RhgYGJJVIlLV+16NDohuEfj0KiMHJzVZLFlNY7wo5fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gi5srRG6NAm/xmowx3UzYgAKwRzlNNeYH3VC1F54sacFcNA6ZBwf3WlTC6Dnr+JgX
	 rnKb0LawA9+d/53TLRRfHmf7SlJvZ+4lFppGlBsauI3AOnpK6fjpX44DwNotLNUINC
	 0ND4UneIcQnZUgzO7Rc8MtTBnNkoI7wMCbaSlfM3NJXnaSU4FII/8AmTpyapKJer6+
	 L0+U4p8/Je6J5AH8ktKlfz62c+oNRpbjdo3tcCW4yU+IstiKkT1aSAm5f6lbT063Pd
	 afCaPLn+ZpuSKSHEX/h/aX5MUvER0N3J5tBlO9kXeQfMZPGsCwBNs2QBrPG0onen/M
	 7bN8YthuG0ZSg==
Date: Thu, 6 Nov 2025 17:34:59 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Fix handling of ID_PFR1_EL1.GIC
Message-ID: <aQ1Mw-DRgBwutLG1@kernel.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>

On Thu, Oct 30, 2025 at 12:27:04PM +0000, Marc Zyngier wrote:
> Peter reported[0] that restoring a GICv2 VM fails badly, and correctly
> points out that ID_PFR1_EL1.GIC isn't writable, while its 64bit
> equivalent is. I broke that in 6.12.
> 
> The other thing is that fixing the ID regs at runtime isn't great.
> specially when we could adjust them at the point where the GIC gets
> created.
> 
> This small series aims at fixing these issues. I've only tagged the
> first one as a stable candidate. With these fixes, I can happily
> save/restore a GICv2 VM (both 32 and 64bit) on my trusty Synquacer.

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

