Return-Path: <kvm+bounces-10671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FED986E7F8
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11156B2B088
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E2720DC5;
	Fri,  1 Mar 2024 18:07:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941E01798F
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709316464; cv=none; b=Y6urLr7AqHFaFzGAZP5uGEexL+UmHJJFx/sKJR9ESwhCbTRQEl4Sw/0Q69D0kOGKuDQ/rp16cGfVpvZh3oL8f5VEoSJa030Oob++VCrHZ/QmF2mnh+V9/KTRnE8LpGwiPIYstJH0ky0qBOp1q2FraGQmp6vP55eoCcW3886ynow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709316464; c=relaxed/simple;
	bh=Z63IiJv21DENT76EbANxmcLyjY/8ddYAZ+IREQ5jdaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EG/+jWxu044Y0/xL9hIGKTp09CiayWioj09F95TOYT62fcThpjmeS75Q8G5vmZshnb9By0mnW/GJKPkPu1bIm7UK6Zn6LC0iIitz3L8iQhPDcc8sF/XakioKnGi6vCoRqVO0ZI1SdlnNm9zfqhF/teoYCJm5QUggJNqmL0DhAAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1984C1FB;
	Fri,  1 Mar 2024 10:08:19 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77E353F6C4;
	Fri,  1 Mar 2024 10:07:39 -0800 (PST)
Date: Fri, 1 Mar 2024 18:07:34 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 07/13] KVM: arm64: nv: Honor HFGITR_EL2.ERET being set
Message-ID: <20240301180734.GA3958355@e124191.cambridge.arm.com>
References: <20240226100601.2379693-1-maz@kernel.org>
 <20240226100601.2379693-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226100601.2379693-8-maz@kernel.org>

Got a question about this one,

On Mon, Feb 26, 2024 at 10:05:55AM +0000, Marc Zyngier wrote:
> If the L1 hypervisor decides to trap ERETs while running L2,
> make sure we don't try to emulate it, just like we wouldn't
> if it had its NV bit set.
> 
> The exception will be reinjected from the core handler.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index eaf242b8e0cf..3ea9bdf6b555 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -220,7 +220,8 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * Unless the trap has to be forwarded further down the line,
>  	 * of course...
>  	 */
> -	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
> +	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
> +	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
>  		return false;
>  
>  	spsr = read_sysreg_el1(SYS_SPSR);

Are we missing a forward_traps() call in kvm_emulated_nested_eret() for the
HFGITR case?

Trying to follow the code path here, and I'm unsure of where else the
HFIGTR_EL2_ERET trap would be forwarded:

kvm_arm_vcpu_enter_exit ->
	ERET executes in guest
	fixup_guest_exit ->
		kvm_hyp_handle_eret (returns false)

handle_exit ->
	kvm_handle_eret ->
		kvm_emulated_nested_eret
			if HCR_NV
				forward traps
			else
				emulate ERET


And if the answer is that it is being reinjected somewhere, putting that
function name in the commit instead of 'core handler' would help with
understanding!

I need to find the time to get an NV setup set-up, so I can do some experiments
myself.

Thanks,
Joey

