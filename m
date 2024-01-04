Return-Path: <kvm+bounces-5641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 318C082412A
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A87471F21855
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85812136F;
	Thu,  4 Jan 2024 11:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZjPha/bs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBD921362
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 11:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704369567; x=1735905567;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GRE6IaM0f2Jr3o9pMAP+z7N5qn5WTrzVjhf/a+zC5Bs=;
  b=ZjPha/bsDndlopP2RcVaXZuF09Wv5Y9f6jzEDKUKJ9vb8kGDgyXEexVd
   MKxMiy7z00tDPY+r9KY2utXOLIZHjKMRrb/UavvBlMTatfGo+h+jyIj25
   S6c5u1oPiSs6k1LYopPOC+CIW+Etjc9Hcmf6SULI66pZrqacuSD9emZSC
   qXJ7h7fIFu7mlV6YNmVMOL7wg9AGCe0H2TzM8UCtHbKhZGjBsVlh0I782
   SLhloq3jWXYDftlBVUKmYBj2vO7MwD6DuTaS2Ta3AvghX8AeMKQpaTjyk
   PBF0q3f2BheUNXhKB1R58MYdmC29P3LONjWTq5il8ME2CUTCS1xtLn1OP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="483386241"
X-IronPort-AV: E=Sophos;i="6.04,330,1695711600"; 
   d="scan'208";a="483386241"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 03:59:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="783853792"
X-IronPort-AV: E=Sophos;i="6.04,330,1695711600"; 
   d="scan'208";a="783853792"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 03:59:23 -0800
Date: Thu, 4 Jan 2024 19:56:20 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, eddie.dong@intel.com, xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com,
	chao.p.peng@intel.com
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZZac2AFdR9YTkhuZ@linux.bj.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYMWFhVQ7dCjYegQ@google.com>
 <ZYP0/nK/WJgzO1yP@yilunxu-OptiPlex-7050>
 <ZZSbLUGNNBDjDRMB@google.com>
 <CALMp9eTutnTxCjQjs-nxP=XC345vTmJJODr+PcSOeaQpBW0Skw@mail.gmail.com>
 <ZZWhuW_hfpwAAgzX@google.com>
 <ZZYbzzDxPI8gjPu8@chao-email>
 <CALMp9eSg6No9L40kmo7n9BGOz4v1ThA7-e4gD4sgj3KGBJEUzA@mail.gmail.com>
 <CALMp9eRS9o7YDDaOcjBB0QTeF_vRA2LMvQqc2Sb-7XhyDi=1LA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRS9o7YDDaOcjBB0QTeF_vRA2LMvQqc2Sb-7XhyDi=1LA@mail.gmail.com>

On Wed, Jan 03, 2024 at 08:34:16PM -0800, Jim Mattson wrote:
> On Wed, Jan 3, 2024 at 7:40 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Wed, Jan 3, 2024 at 6:45 PM Chao Gao <chao.gao@intel.com> wrote:
> > >
> > > On Wed, Jan 03, 2024 at 10:04:41AM -0800, Sean Christopherson wrote:
> > > >On Tue, Jan 02, 2024, Jim Mattson wrote:
> > > >> On Tue, Jan 2, 2024 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >> >
> > > >> > On Thu, Dec 21, 2023, Xu Yilun wrote:
> > > >> > > On Wed, Dec 20, 2023 at 08:28:06AM -0800, Sean Christopherson wrote:
> > > >> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > >> > > > > index c57e181bba21..72634d6b61b2 100644
> > > >> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > >> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > >> > > > > @@ -5177,6 +5177,13 @@ void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> > > >> > > > >   reset_guest_paging_metadata(vcpu, mmu);
> > > >> > > > >  }
> > > >> > > > >
> > > >> > > > > +/* guest-physical-address bits limited by TDP */
> > > >> > > > > +unsigned int kvm_mmu_tdp_maxphyaddr(void)
> > > >> > > > > +{
> > > >> > > > > + return max_tdp_level == 5 ? 57 : 48;
> > > >> > > >
> > > >> > > > Using "57" is kinda sorta wrong, e.g. the SDM says:
> > > >> > > >
> > > >> > > >   Bits 56:52 of each guest-physical address are necessarily zero because
> > > >> > > >   guest-physical addresses are architecturally limited to 52 bits.
> > > >> > > >
> > > >> > > > Rather than split hairs over something that doesn't matter, I think it makes sense
> > > >> > > > for the CPUID code to consume max_tdp_level directly (I forgot that max_tdp_level
> > > >> > > > is still accurate when tdp_root_level is non-zero).
> > > >> > >
> > > >> > > It is still accurate for now. Only AMD SVM sets tdp_root_level the same as
> > > >> > > max_tdp_level:
> > > >> > >
> > > >> > >       kvm_configure_mmu(npt_enabled, get_npt_level(),
> > > >> > >                         get_npt_level(), PG_LEVEL_1G);
> > > >> > >
> > > >> > > But I wanna doulbe confirm if directly using max_tdp_level is fully
> > > >> > > considered.  In your last proposal, it is:
> > > >> > >
> > > >> > >   u8 kvm_mmu_get_max_tdp_level(void)
> > > >> > >   {
> > > >> > >       return tdp_root_level ? tdp_root_level : max_tdp_level;
> > > >> > >   }
> > > >> > >
> > > >> > > and I think it makes more sense, because EPT setup follows the same
> > > >> > > rule.  If any future architechture sets tdp_root_level smaller than
> > > >> > > max_tdp_level, the issue will happen again.
> > > >> >
> > > >> > Setting tdp_root_level != max_tdp_level would be a blatant bug.  max_tdp_level
> > > >> > really means "max possible TDP level KVM can use".  If an exact TDP level is being
> > > >> > forced by tdp_root_level, then by definition it's also the max TDP level, because
> > > >> > it's the _only_ TDP level KVM supports.
> > > >>
> > > >> This is all just so broken and wrong. The only guest.MAXPHYADDR that
> > > >> can be supported under TDP is the host.MAXPHYADDR. If KVM claims to
> > > >> support a smaller guest.MAXPHYADDR, then KVM is obligated to intercept
> > > >> every #PF,
> > >
> > > in this case (i.e., to support 48-bit guest.MAXPHYADDR when CPU supports only
> > > 4-level EPT), KVM has no need to intercept #PF because accessing a GPA with
> > > RSVD bits 51-48 set leads to EPT violation.
> >
> > At the completion of the page table walk, if there is a permission
> > fault, the data address should not be accessed, so there should not be
> > an EPT violation. Remember Meltdown?
> >
> > > >> and to emulate the faulting instruction to see if the RSVD
> > > >> bit should be set in the error code. Hardware isn't going to do it.
> > >
> > > Note for EPT violation VM exits, the CPU stores the GPA that caused this exit
> > > in "guest-physical address" field of VMCS. so, it is not necessary to emulate
> > > the faulting instruction to determine if any RSVD bit is set.
> >
> > There should not be an EPT violation in the case discussed.
> 
> For intercepted #PF, we can use CR2 to determine the necessary page
> walk, and presumably the rest of the bits in the error code are
> already set, so emulation is not necessary.
> 
> However, emulation is necessary when synthesizing a #PF from an EPT
> violation, and bit 8 of the exit qualification is clear. See
> https://lore.kernel.org/kvm/4463f391-0a25-017e-f913-69c297e13c5e@redhat.com/.

Although not all memory-accessing instructions are emulated, it covers most common
cases and is always better than KVM hangs anyway. We may probably continue to
improve allow_smaller_maxphyaddr, but KVM should report the maximum physical width
it supports.

Thanks,
Tao

