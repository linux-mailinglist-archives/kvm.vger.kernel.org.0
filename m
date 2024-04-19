Return-Path: <kvm+bounces-15353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8648AB472
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 19:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 161BA2823C2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0D813AD26;
	Fri, 19 Apr 2024 17:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMZYa9Pg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C91F130E20;
	Fri, 19 Apr 2024 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713548068; cv=none; b=PvLpYgIICihX43C1Cpnh7Z/QudNWz25WQplJZnQ7FU5ZtRffCs+CRo9JJrfq34L2XNce4tYXOopuPYJ9pL5I2mBXYk2cVcPjqUEq4cPH/KgHB9RRDc6vlKoZ2EFvj14zi7DeSaXCzoSxxZansl7CCuKKrrE2MVJG5TBYzQESynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713548068; c=relaxed/simple;
	bh=Pe1ZKKnNudhhgDI84XpQ7anUsn7IK3kIHRWQPBlfbiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdT7ZhZD5XTp7+kk66umcAMyl0+aSJWa5+ANQEsftcQqa+vo3t5E/I1Qy5HUGJ+K9ZafSq2yG3Ro6/QbaYD+Y6WAtNQNDFqylUGsL4RW7dYBepafzpHUjah6j0cMRQ+hticuDJZsseyyisqP1rjLGVmnCvXN3+RLhncY4fDH0IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XMZYa9Pg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713548066; x=1745084066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Pe1ZKKnNudhhgDI84XpQ7anUsn7IK3kIHRWQPBlfbiM=;
  b=XMZYa9PgLT7zC4/dkHsq7a7Rt0GFGH7gkdFEwp5ESTEmDzAMYda7ZgIK
   s0HHWraeRAIGSt2QmrMmf1NTGAhv7WoJtfHav9XEljcNvvZRYJ/mlDlpl
   TcAGjHQYQRZemPy6m1/lvLRptF85ZCmbBp3/OnhYwzWYk9Mq2oiOxcZlh
   yrlLhzyEViw42i6F2FqooBnD/AZIfUe5tzdfb2MjLv1pLkjs8kbb6LFJp
   iAE1PTLpSoZC1ruttHtRUPIQI5MwwATwjeHWMYicjXNcy3rwTI3OdPNWX
   N8UJllZV5QGmHIcgk2U9s1opX1DPLInpgV6F1zQWVFHiOIcf5H47zN6zV
   w==;
X-CSE-ConnectionGUID: ManEEgC3Qxep1kMmeyz+Iw==
X-CSE-MsgGUID: VzrbyPe9Qq6ChgD43X3kTg==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="9020030"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="9020030"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 10:34:25 -0700
X-CSE-ConnectionGUID: UKg/7ZoXQCCKwkptQA5GHQ==
X-CSE-MsgGUID: A50yJyRuSbynlR5KRXMpcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="54326663"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 10:34:24 -0700
Date: Fri, 19 Apr 2024 10:34:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Message-ID: <20240419173423.GD3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <e2400cf8-ee36-4e7f-ba1f-bb0c740b045c@linux.intel.com>
 <dac4aa8c-94d1-475e-ae97-20229bd9ade2@linux.intel.com>
 <20240418212214.GB3596705@ls.amr.corp.intel.com>
 <f83f6923-7aa2-4a10-8e83-3fa77400c446@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f83f6923-7aa2-4a10-8e83-3fa77400c446@linux.intel.com>

On Fri, Apr 19, 2024 at 09:42:48AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/19/2024 5:22 AM, Isaku Yamahata wrote:
> > On Thu, Apr 18, 2024 at 07:04:11PM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > 
> > > On 4/18/2024 5:29 PM, Binbin Wu wrote:
> > > > > +
> > > > > +static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +    struct kvm_memory_slot *slot;
> > > > > +    int size, write, r;
> > > > > +    unsigned long val;
> > > > > +    gpa_t gpa;
> > > > > +
> > > > > +    KVM_BUG_ON(vcpu->mmio_needed, vcpu->kvm);
> > > > > +
> > > > > +    size = tdvmcall_a0_read(vcpu);
> > > > > +    write = tdvmcall_a1_read(vcpu);
> > > > > +    gpa = tdvmcall_a2_read(vcpu);
> > > > > +    val = write ? tdvmcall_a3_read(vcpu) : 0;
> > > > > +
> > > > > +    if (size != 1 && size != 2 && size != 4 && size != 8)
> > > > > +        goto error;
> > > > > +    if (write != 0 && write != 1)
> > > > > +        goto error;
> > > > > +
> > > > > +    /* Strip the shared bit, allow MMIO with and without it set. */
> > > > Based on the discussion
> > > > https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com/
> > > > Do we still allow the MMIO without shared bit?
> > That's independent.  The part is how to work around guest accesses the
> > MMIO region with private GPA.  This part is,  the guest issues
> > TDG.VP.VMCALL<MMMIO> and KVM masks out the shared bit to make it friendly
> > to the user space VMM.
> It's similar.
> The tdvmcall from the guest for mmio can also be private GPA, which is not
> reasonable, right?
> According to the comment, kvm doens't care about if the TD guest issue the
> tdvmcall with private GPA or shared GPA.

I checked the GHCI spec. It clearly states this hypercall is for shared GPA.
We should return error for private GPA.

  This TDG.VP.VMCALL is used to help request the VMM perform
  emulated-MMIO-access operation. The VMM may emulate MMIO space in shared-GPA
  space. The VMM can induce a #VE on these shared-GPA accesses by mapping shared
  GPAs with the suppress-VE bit cleared in the EPT Entries corresponding to
  these mappings

So we'll have something as follows. Compile only tested.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3bf0d6e3cd21..0f696f3fbd86 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1281,24 +1281,34 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
        if (write != 0 && write != 1)
                goto error;
 
-       /* Strip the shared bit, allow MMIO with and without it set. */
+       /*
+        * MMIO with TDG.VP.VMCALL<MMIO> allows only shared GPA because
+        * private GPA is for device assignment.
+        */
+       if (kvm_is_private_gpa(gpa))
+               goto error;
+
+       /*
+        * Strip the shared bit because device emulator is assigned to GPA
+        * without shared bit.  We'd like the existing code untouched.
+        */
        gpa = gpa & ~gfn_to_gpa(kvm_gfn_shared_mask(vcpu->kvm));
 
-       if (size > 8u || ((gpa + size - 1) ^ gpa) & PAGE_MASK)
+       /* Disallow MMIO crossing page boundary for simplicity. */
+       if (((gpa + size - 1) ^ gpa) & PAGE_MASK)
                goto error;
 
        slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
        if (slot && !(slot->flags & KVM_MEMSLOT_INVALID))
                goto error;
 
-       if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
-               trace_kvm_fast_mmio(gpa);
-               return 1;
-       }
-
-       if (write)
+       if (write) {
+               if (!kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
+                       trace_kvm_fast_mmio(gpa);
+                       return 1;
+               }
                r = tdx_mmio_write(vcpu, gpa, size, val);
-       else
+       } else
                r = tdx_mmio_read(vcpu, gpa, size);
        if (!r) {
                /* Kernel completed device emulation. */


-- 
Isaku Yamahata <isaku.yamahata@intel.com>

