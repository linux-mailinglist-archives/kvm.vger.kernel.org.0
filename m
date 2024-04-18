Return-Path: <kvm+bounces-15172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD448AA4AC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A416E2834C5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A978194C93;
	Thu, 18 Apr 2024 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+ZJgfL0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F2A2F30;
	Thu, 18 Apr 2024 21:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713475337; cv=none; b=c30ckrA7roSsvY80g6/0qz0PadTQb/KW3Sjt4W4sjNGlEREdVHenFi3ZdxtkFYQ+g/TWjMfUSMLwdUhDou7vi78cY8yVP24kEUZjuTfRHz4gT9RTFyeIrbFiFJ0WR6eG0pmRBcId9d8W1pFRY0fy7xTmpdgp0NogXPNluRU4jNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713475337; c=relaxed/simple;
	bh=VFN2UbjzpadcvZYY4LyNiJYrkqJG11SUN8RUZKGSbaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNN3aTrxP9rCzraNgNCkzlvaJ4a2E3+aSV0HtadzEBcdqfJHrSyHUBmeHuUi7dv9AT/YBqHQkUfbaAayFnD4Jmsz9HwxkV3e7nrIPF4EUfOMPLbDVmFupUnb7l53GKCsCOmmH2mbbuxSNzz71TLtRTlf8paZJ10bObpa6veUjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+ZJgfL0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713475335; x=1745011335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=VFN2UbjzpadcvZYY4LyNiJYrkqJG11SUN8RUZKGSbaI=;
  b=Q+ZJgfL0HIp+U0jnBCpwa9lvxErWsAcwBi85ULO33kcmONaFeVDV6aZ0
   EOPoWiESBcjHBf2g81cWOWC1KZjEsr7rIWRuDHnJYAAI8k2u4NfseX5+D
   YbahjJnf6AbzIcfIZ74yjQGMMm81TY5LRzLq7xrNXLukfOPCUHEecHSaV
   3ofViLX7atAwaiDuM9DM/+apUE8/i4/1RCJf+UslwEhTi0fitCAN9N//l
   sVAUREM9z9tHnzpy+3todJyEwzunWjTtD1i0RPaFU1oUPmXQInbB4IeMG
   hmoamlqRemcUbaxqqobCmCsaFDwdHRldmmPxLaWzqzPeYRlmjbjLklBAL
   w==;
X-CSE-ConnectionGUID: ++++MyzIQXm1oN3s3oIP7A==
X-CSE-MsgGUID: n4ky594ETsSzaugrW/H9Fg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8977557"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8977557"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 14:22:14 -0700
X-CSE-ConnectionGUID: D493oXOXS16rIv+LTkyr5Q==
X-CSE-MsgGUID: emMOEW+CQ7i/QqFu4kkA3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="60546252"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 14:22:14 -0700
Date: Thu, 18 Apr 2024 14:22:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Message-ID: <20240418212214.GB3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
 <dac4aa8c-94d1-475e-ae97-20229bd9ade2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dac4aa8c-94d1-475e-ae97-20229bd9ade2@linux.intel.com>

On Thu, Apr 18, 2024 at 07:04:11PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/18/2024 5:29 PM, Binbin Wu wrote:
> > 
> > > +
> > > +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> > > +{
> > > +    struct kvm_memory_slot *slot;
> > > +    int size, write, r;
> > > +    unsigned long val;
> > > +    gpa_t gpa;
> > > +
> > > +    KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
> > > +
> > > +    size = tdvmcall_a0_read(vcpu);
> > > +    write = tdvmcall_a1_read(vcpu);
> > > +    gpa = tdvmcall_a2_read(vcpu);
> > > +    val = write ? tdvmcall_a3_read(vcpu) : 0;
> > > +
> > > +    if (size != 1 && size != 2 && size != 4 && size != 8)
> > > +        goto error;
> > > +    if (write != 0 && write != 1)
> > > +        goto error;
> > > +
> > > +    /* Strip the shared bit, allow MMIO with and without it set. */
> > Based on the discussion
> > https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
> > Do we still allow the MMIO without shared bit?

That's independent.  The part is how to work around guest accesses the
MMIO region with private GPA.  This part is,  the guest issues
TDG.VP.VMCALL<MMMIO> and KVM masks out the shared bit to make it friendly
to the user space VMM.



> > > +    gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
> > > +
> > > +    if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
> > "size > 8u" can be removed, since based on the check of size above, it
> > can't be greater than 8.

Yes, will remove the check.


> > > +        goto error;
> > > +
> > > +    slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> > > +    if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
> > > +        goto error;
> > > +
> > > +    if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> > Should this be checked for write first?
> > 
> > I check the handle_ept_misconfig() in VMX, it doesn't check write first
> > neither.
> > 
> > Functionally, it should be OK since guest will not read the address
> > range of fast mmio.
> > So the read case will be filtered out by ioeventfd_write().
> > But it has take a long way to get to ioeventfd_write().
> > Isn't it more efficient to check write first?
> 
> I got the reason why in handle_ept_misconfig(), it tries to do fast mmio
> write without checking.
> It was intended to make fast mmio faster.
> And for ept misconfig case, it's not easy to get the info of read/write.
> 
> But in this patch, we have already have read/write info, so maybe we can add
> the check for write before fast mmio?

Yes, let's add it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

