Return-Path: <kvm+bounces-22207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E809893BAE3
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 04:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 418A5282BA8
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 02:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1BD10A2A;
	Thu, 25 Jul 2024 02:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CtJymMUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2D263D0
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 02:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721875076; cv=none; b=SbfA9KcPUflKFpDXxP+wRp8KBun3JSO+RY5NwmhxUGFv1TMH2KAoZREIkFQzqkcaSvloFdRlSFKSM+uQBHHpmHQrjFc2nL0y8NLNQrk9NpRAwKxJNVeYOmgf0LiChbAlQiLIJed40aop+diACd+ju82cymGon8FBcO/ep/9ppSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721875076; c=relaxed/simple;
	bh=rcLlgfmpf8Ql97d7x31xNql3lDDEZ8UD+1Vkc/OSsDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOOC2WUdbR7x+ciV2gED9jEoQLAkS3yQdRYPWyyr3Inan0NKwbv78R9jQSHJyspp44ttRIgnDYyWRtYI2clmq1CSYIZ7bACxUW2Gwfa2WnjY5oaE3xsJ58IZqr775vXsL1JOsOVo0FHGQvgDg/NG/Q7W7a62xqoVilS7O+F30Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CtJymMUW; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721875075; x=1753411075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rcLlgfmpf8Ql97d7x31xNql3lDDEZ8UD+1Vkc/OSsDc=;
  b=CtJymMUWpoL32mxHKSmodqJid4rgBoUD1PfZZrvnCIAoFrUWOLFhR0h5
   1P2EY57LjA/J01CXqC0GaVfJphQMXR8Swry8o6co9T478jBGuEuEDcS3c
   wHAUZoQ/g0DG2vva+moG9mK3HLTFzoA1/KVr9N7hRz8KRqYy2gVfyLCF3
   /vNsmR9jxQuRMe6noNCUwj8nkQEbBqIM8z5sSokQVTb+F6nACHor8cEGx
   vvQKqbiWqNLGLIqwBwdL11jTqVnjUqE4ZU4SCck+r3Gc+EFkgIWLjdQy/
   cPOLTieVUCw8+phdOavxau74erX7B8sisMReca38AnjSlQovWtgW9Gxx8
   w==;
X-CSE-ConnectionGUID: BMR9wjWqSm6/qLHvkLvYlw==
X-CSE-MsgGUID: KA1syPenRHSI40Ex/vnI1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19726814"
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="19726814"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 19:37:54 -0700
X-CSE-ConnectionGUID: NGnjczZSTJ+19i/ohm2OSw==
X-CSE-MsgGUID: u/sodxa3RdG7hClKvXeq2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,234,1716274800"; 
   d="scan'208";a="57344874"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 19:37:52 -0700
Date: Thu, 25 Jul 2024 10:32:53 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
	xiaoyao.li@intel.com
Subject: Re: [PATCH] KVM: x86: Reset RSP before exiting to userspace when
 emulating POPA
Message-ID: <ZqG5VaFKdP+G3/vg@linux.bj.intel.com>
References: <20240724044529.3837492-1-tao1.su@linux.intel.com>
 <ZqEPrE429UQi9duo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqEPrE429UQi9duo@google.com>

On Wed, Jul 24, 2024 at 08:33:48AM -0700, Sean Christopherson wrote:
> On Wed, Jul 24, 2024, Tao Su wrote:
> > When emulating POPA and exiting to userspace for MMIO, reset modified RSP
> > as emulation context may not be reset. POPA may generate more multiple
> > reads, i.e. multiple POPs from the stack, but if stack points to MMIO,
> > KVM needs to emulate multiple MMIO reads.
> > 
> > When one MMIO done, POPA may be re-emulated with EMULTYPE_NO_DECODE set,
> > i.e. ctxt will not be reset, but RSP is modified by previous emulation of
> > current POPA instruction, which eventually leads to emulation error.
> > 
> > The commit 0dc902267cb3 ("KVM: x86: Suppress pending MMIO write exits if
> > emulator detects exception") provides a detailed analysis of how KVM
> > emulates multiple MMIO reads, and its correctness can be verified in the
> > POPA instruction with this patch.
> 
> I don't see how this can work.  If POPA is reading from MMIO, it will need to
> do 8 distinct emulated MMIO accesses.  Unwinding to the original RSP will allow
> the first MMIO (store to EDI) to succeed, but then the second MMIO (store to ESI)
> will exit back to userspace.  And the second restart will load EDI with the
> result of the MMIO, not ESI.  It will also re-trigger the second MMIO indefinitely.
> 

This can work like commit 0dc902267cb3 description. Since there is a buffer
(ctxt->mem_read), KVM can safely restart the instruction from the beginning.

After the first MMIO (store to EDI) done, vcpu->mmio_read_completed is set and
POPA is re-emulated with EMULTYPE_NO_DECODE. When re-emulating, KVM will try
first MMIO (store to EDI) _again_, but KVM will not exit to userspace in
emulator_read_write() because vcpu->mmio_read_completed is set and then adjust
mc->end in read_emulated().

For the second MMIO (store to ESI), it will exit to userspace and re-emulate.
When re-emulating, KVM can directly read EDI from the buffer (mc->data) and try
second MMIO (store to ESI) _again_, but KVM will not exit to userspace in
emulator_read_write() because vcpu->mmio_read_completed is set and then adjust
mc->end in read_emulated().

For the third MMIO (store to EBP) ...

> To make this work, KVM would need to allow precisely resuming execution where
> it left off.  We can't use MMIO fragments, because unlike MMIO accesses that
> split pages, each memory load is an individual access.
> 

Since all MMIO reads are saved to the buffer (mc->data) and the index (mc->end)
is adjusted by every re-emulation, KVM already supports multiple MMIO reads.

> I don't see any reason to try to make this work.  It's a ridiculously convoluted
> scenario that, AFAIK, has no real world application.
> 

I agree POPA+MMIO is rare but supporting it to be same as hardware is cheap. We
can also use POPA to validate the multiple MMIO reads which has a complex flow (
actually, that's why I tried POPA in kvm-unit-test and then find this issue).

> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > ---
> > For testing, we can add POPA to the emulator case in kvm-unit-test.
> > ---
> >  arch/x86/kvm/emulate.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index e72aed25d721..3746fef6ca60 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -1999,6 +1999,7 @@ static int em_pushf(struct x86_emulate_ctxt *ctxt)
> >  
> >  static int em_popa(struct x86_emulate_ctxt *ctxt)
> >  {
> > +	unsigned long old_esp = reg_read(ctxt, VCPU_REGS_RSP);
> >  	int rc = X86EMUL_CONTINUE;
> >  	int reg = VCPU_REGS_RDI;
> >  	u32 val = 0;
> > @@ -2010,8 +2011,11 @@ static int em_popa(struct x86_emulate_ctxt *ctxt)
> >  		}
> >  
> >  		rc = emulate_pop(ctxt, &val, ctxt->op_bytes);
> > -		if (rc != X86EMUL_CONTINUE)
> > +		if (rc != X86EMUL_CONTINUE) {
> > +			assign_register(reg_rmw(ctxt, VCPU_REGS_RSP),
> > +					old_esp, ctxt->op_bytes);
> >  			break;
> > +		}
> >  		assign_register(reg_rmw(ctxt, reg), val, ctxt->op_bytes);
> >  		--reg;
> >  	}
> > 
> > base-commit: 786c8248dbd33a5a7a07f7c6e55a7bfc68d2ca48
> > -- 
> > 2.34.1
> > 

