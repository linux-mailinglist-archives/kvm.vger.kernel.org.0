Return-Path: <kvm+bounces-19712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0404909326
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 22:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A58EC1F23BAD
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253BE1A01B6;
	Fri, 14 Jun 2024 20:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MgG14NrV"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EAE16D4D5
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 20:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718395613; cv=none; b=iO3CE8lFpSKBMGSy5Dfn/2GAyvIACZ/tJg5a33N7dLFTFg5uCT9ht18VikAW88ZsRFaM2kVeJbupt+vik1CpDG/xU4TAlq6mxjbKQqtH3UW5pj6g7oYZ7QyjVcG4UapCDATqpgxG5uiROK0MXg0MBZPG2O8aKZ1z/e37IVcyPRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718395613; c=relaxed/simple;
	bh=fHT+mvpZyNYtfRAmvwVtbsv48ZDUcasSZ243A7w5E9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLlxFK45gpKOCwIo6bFpaSAUgYBVChOJ6pD7eaguLS7OTDhTscM9qiWrm66NDzhVVTG0S4aovYlzc4JDts8AGs3VTQj/lQNrIPe+1k9NNcCyRsN7nBkoMMo7TPhE3Qpx1pjIad1WkzGweWKY7LENEzcs5CKtbrb3jkG1j0//hCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MgG14NrV; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718395608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wRCBzoKitu7R8WzPS6XSmQokXRgP3Oseo1hUL0yrJXM=;
	b=MgG14NrVXtRa217e5lweWqgVQps5JZo31w1/IGcVEJD0rA8tMlnfs4glwW+wnu8CgKEu5U
	nERLCX8RY4tphYgf6nOiyDZ0xkWnqtYEnlrhYJNl3reIfyzbLGB2Rnk1QKt19Co+aFUm8M
	v5gBa1pKyR8Rl8XKs+JqkP3FyJdcDTY=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
Date: Fri, 14 Jun 2024 20:06:43 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 03/15] KVM: arm64: nv: Handle CPACR_EL1 traps
Message-ID: <Zmyi0-JIy2956RnF@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
 <20240613201756.3258227-4-oliver.upton@linux.dev>
 <86plsjk6dl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86plsjk6dl.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 14, 2024 at 02:20:54PM +0100, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 21:17:44 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > From: Marc Zyngier <maz@kernel.org>
> > 
> > Handle CPACR_EL1 accesses when running a VHE guest. In order to
> > limit the cost of the emulation, implement it ass a shallow exit.
> > 
> > In the other cases:
> > 
> > - this is a nVHE L1 which will write to memory, and we don't trap
> > 
> > - this is a L2 guest:
> > 
> >   * the L1 has CPTR_EL2.TCPAC==0, and the L2 has direct register
> >    access
> > 
> >   * the L1 has CPTR_EL2.TCPAC==1, and the L2 will trap, but the
> >     handling is defered to the general handling for forwarding
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/vhe/switch.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > index d7af5f46f22a..fed36457fef9 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -262,10 +262,40 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  	return true;
> >  }
> >  
> > +static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +	u64 esr = kvm_vcpu_get_esr(vcpu);
> > +	int rt;
> > +
> > +	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
> > +		return false;
> > +
> > +	rt = kvm_vcpu_sys_get_rt(vcpu);
> > +
> > +	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ) {
> > +		vcpu_set_reg(vcpu, rt, __vcpu_sys_reg(vcpu, CPTR_EL2));
> > +	} else {
> > +		vcpu_write_sys_reg(vcpu, vcpu_get_reg(vcpu, rt), CPTR_EL2);
> > +		__activate_cptr_traps(vcpu);
> 
> This doesn't bisect, as this helper is only introduced in patch #10.
> You probably want to keep it towards the end of the series.

Ah, derp, I wanted to use the kvm_hyp_handle_sysreg_vhe() you introduced
for the subsequent patch. I'll just move them both.

-- 
Thanks,
Oliver

