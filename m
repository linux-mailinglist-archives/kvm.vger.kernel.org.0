Return-Path: <kvm+bounces-9955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E27867F7E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 478AC1C2B826
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2692C12F39A;
	Mon, 26 Feb 2024 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MdQH+B+Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E58012F362;
	Mon, 26 Feb 2024 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708970567; cv=none; b=U5SI+/iZYSahvDPWhiPPTuncjjRaS9U/3rCy2ZRror6E5SYxMfRXkFqn3wVNT8qiSbJoia6XQUlhb8shMkLKjOmWFGanlZcYk++LU9dWClZTkkfcPNogiIrFIWVKgTYU++Uv4HYwjT1OC5J96qF5W7VoGTyc6YUpwiFxdUI0Pdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708970567; c=relaxed/simple;
	bh=5UKky+Hm3LQkv7vqoNqO+TpAezTPnjT2mPmj06qXkbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=avGqxRf6mLJM1cB92Z7YJSeqKcNEjbbst6/VuTLwOjy0B9nYp3fTdBZsOeRBwCmNOvUvZadvF1OnECSP/k7Q1JfvebBkQY5XsXje4QJ8g8Y8MrWn+AQFmoMxoiap7Y+oHgPpKTbGfQnTfU58irPEszyiGgdZ1niErhSfH++CR/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MdQH+B+Q; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708970565; x=1740506565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5UKky+Hm3LQkv7vqoNqO+TpAezTPnjT2mPmj06qXkbM=;
  b=MdQH+B+QCKQtEjqTdWmwAV7tKD6Odm32XMUUJ/PwHOneUpBYiTKeS76r
   W7Gf8fkEV5A7r+R1VQND1G/f0RQoWtBmeqNs7cUiOnz2no0WfYU+nYhAp
   2aPH77G3OTA2GkUwh2pITttEVKuBcEYIfYxLPGAdC5qsG6FqCjvWXYMP9
   zd2ZHY2DJXIPth3gYN0qkl7OpPiGibnwBFUz7i7e7kIhlnC7mYt5k5u4T
   QTEFCgEcixGogU1gsKOryaQq8v7/T4qUyFWamj5b2QcIdz0/eMLeuMhX/
   GGacelmdhD0RGPIBo0qMS6lOLwNo0rRL60Ev7H2GZBSWZeDqoZ7KQUE9S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="13981118"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="13981118"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:02:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11530823"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:02:43 -0800
Date: Mon, 26 Feb 2024 10:02:43 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 040/121] KVM: x86/mmu: Disallow fast page fault on
 private GPA
Message-ID: <20240226180243.GD177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfYP4n12HOSx5XsibA==hmPCVe9hHZFTsJTTxBHA5pffwA@mail.gmail.com>
 <20240226175510.GC177224@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240226175510.GC177224@ls.amr.corp.intel.com>

On Mon, Feb 26, 2024 at 09:55:10AM -0800,
Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:

> On Mon, Feb 12, 2024 at 06:01:54PM +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > On Tue, Jan 23, 2024 at 12:55 AM <isaku.yamahata@intel.com> wrote:
> > >
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
> > > access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
> > > doesn't make sense.  Disallow fast page fault on private GPA.
> > >
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
> > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index b2924bd9b668..54d4c8f1ba68 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3339,8 +3339,16 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
> > >         return RET_PF_CONTINUE;
> > >  }
> > >
> > > -static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
> > > +static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
> > >  {
> > > +       /*
> > > +        * TDX private mapping doesn't support fast page fault because the EPT
> > > +        * entry is read/written with TDX SEAMCALLs instead of direct memory
> > > +        * access.
> > > +        */
> > > +       if (kvm_is_private_gpa(kvm, fault->addr))
> > > +               return false;
> > 
> > I think this does not apply to SNP? If so, it would be better to check
> > the SPTE against the shared-page mask inside the do...while loop.
> 
> No, this won't apply to SNP. Let me update the patch corresponding in v19.

shared-page mask is against GPA or faulting address. Not SPTE unlike SNP.
So it doesn't make sense to check inside the do..while loop.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

