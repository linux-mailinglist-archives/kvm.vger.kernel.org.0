Return-Path: <kvm+bounces-65773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B894CB626F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 15:11:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 06656309163E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 14:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E2F2D12EB;
	Thu, 11 Dec 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="ll9wZ33T"
X-Original-To: kvm@vger.kernel.org
Received: from out28-217.mail.aliyun.com (out28-217.mail.aliyun.com [115.124.28.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890472D061C;
	Thu, 11 Dec 2025 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765461933; cv=none; b=Ssmj8asC0vLITyqqihi8NA1waiN7Yi/mKFuknX2/5f3IXBt+mJP7tGzIdD7UUMYkkWA5TMtfKCd16Gxf2WpuNrHDO4TdmcotOBA2tVlvyZOTslNzH0NgQiJvEYAGBsUU1VEbCWSfnl+dmBS+2XitEICs0Q1ypNTsMjDayWiL1Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765461933; c=relaxed/simple;
	bh=PfYfVDzPPi4UnGqOlwmrwQmkzLla2ubzTQvOu1ujBus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXBjcxF2D8Gl8x5/y2LrrNvJ+7Rmf3v+qtKmtrj1ndzPW7I8bX7CRBQ4PXyS+jM24wIu9xiiVhze5BFvPTzl6/5UzPLeZItTyeucpprWcp3IH4HXeZpbPU4E4S19WVpDXzpT1ZQ1ppFzNW3eashsby5Z18Oe1W3Ip4X6WDrLkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=ll9wZ33T; arc=none smtp.client-ip=115.124.28.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1765461921; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=04h6smBR2W6oCHQiT13idcD8SQnByGv8Gha7SUmtjhQ=;
	b=ll9wZ33TqgQx1kJHxcoLbtxDU0sqpaMr/7+kbeYx3fY5KI3lWmh3j987YcP3wrbm3thoiwNgiejl2oiL37iIYI2UEKXWYYe6bNsNZ9oWCu3wR1Ro/a66VbdWAHUVDq9tQ6Wkrt1MHW4Znn+KGiKuimgDApyzMWVosjQgLfDJCmA=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fi5.6J-_1765461920 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 22:05:20 +0800
Date: Thu, 11 Dec 2025 22:05:20 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check
 into the kvm_inject_emulated_db()
Message-ID: <20251211140520.GC42509@k08j02272.eu95sqa>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
 <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
 <aTMdLPvT3gywUY6F@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTMdLPvT3gywUY6F@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Dec 05, 2025 at 09:58:04AM -0800, Sean Christopherson wrote:
> On Wed, Sep 10, 2025, Hou Wenlong wrote:
> > Use kvm_inject_emulated_db() in kvm_vcpu_do_singlestep() to consolidate
> > 'KVM_GUESTDBG_SINGLESTEP' check into kvm_inject_emulated_db() during
> > emulation.
> > 
> > No functional change intended.
> > 
> > Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/x86.c | 17 +++++------------
> >  1 file changed, 5 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5af652916a19..83960214d5d8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8632,7 +8632,10 @@ static int kvm_inject_emulated_db(struct kvm_vcpu *vcpu, unsigned long dr6)
> >  {
> >  	struct kvm_run *kvm_run = vcpu->run;
> >  
> > -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> > +	/* Data breakpoints are not supported in emulation for now. */
> > +	WARN_ON((dr6 & DR6_BS) && (dr6 & DR_TRAP_BITS));
> 
> If we keep this, it should be a WARN_ON_ONCE().  We've had at least one case where
> a sanity check in the emulator caused major problems because a WARN_ON() spammed
> the kernel log to the point where it overloaded things :-)
>
I'll drop it.

> But I think the WARN will be subject to false positives.  KVM doesn't emulate data
> #DBs, but it does emulate code #DBs, and fault-like code #DBs can be coincident
> with trap-like single-step #DBs.  Ah, but kvm_vcpu_check_code_breakpoint() doesn't
> account for RFLAGS.TF.  That should probably be addressed in this series, especially
> since it's consolidating KVM_GUESTDBG_SINGLESTEP handling.
Sorry, I didn't follow it, how fault-like code #DBs can be coincident
with trap-like single-step #DBs, could you provide an example?

Thanks!


