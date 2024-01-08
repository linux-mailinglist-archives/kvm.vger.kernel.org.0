Return-Path: <kvm+bounces-5827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA9E827058
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 092612840A6
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904EE4594F;
	Mon,  8 Jan 2024 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EVAFovLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770945964
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704721884; x=1736257884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Z4Gtzuif9lWXPqU56KFCl5X72p0G5Nk3K5ZTFgY4V98=;
  b=EVAFovLdEWag2nVxo7PgRfx+0gD6pVEADt9AtMhjCkulB1FA+39vOT/f
   v/LjfyRuFXYBjQrk+j+HIQqy1g9nFmFyULFcfuzboncFLpUad+rgZuvxI
   sbKYxxspLFAzVZg88vGW+r2tLJXS0ZMGhXl2k2OWwnAMMe8uFbLx5f84L
   paLroQfZIj0oY19K351sMw2yS7SxeiojkOLc27d0s1GCvRsJP9HjnOLhe
   z6UfKahI55iec/h40e2r9cy5OVrELThCQIV4vDIHtNLFD/UIf4TWWtUYO
   nRbDBvHh773poEWvL80XRzLquTEZHCmkeY52auXcFNhP1JbsvXdHGDuMp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="388335750"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="388335750"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 05:51:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10947"; a="774504548"
X-IronPort-AV: E=Sophos;i="6.04,341,1695711600"; 
   d="scan'208";a="774504548"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2024 05:51:20 -0800
Date: Mon, 8 Jan 2024 21:48:17 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	eddie.dong@intel.com, chao.gao@intel.com, xiaoyao.li@intel.com,
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com,
	chao.p.peng@intel.com
Subject: Re: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be
 translated by EPT
Message-ID: <ZZv9ISKuJs66ZCbz@linux.bj.intel.com>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-3-tao1.su@linux.intel.com>
 <CALMp9eT=s7eifhmJZ4uQNTABQi+r9-JyjjUVt-Rj-B=y0+mbPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT=s7eifhmJZ4uQNTABQi+r9-JyjjUVt-Rj-B=y0+mbPA@mail.gmail.com>

On Wed, Dec 20, 2023 at 05:42:56AM -0800, Jim Mattson wrote:
> On Mon, Dec 18, 2023 at 6:08 AM Tao Su <tao1.su@linux.intel.com> wrote:
> >
> > With 4-level EPT, bits 51:48 of the guest physical address must all
> > be zero; otherwise, an EPT violation always occurs, which is an unexpected
> > VM exit in KVM currently.
> >
> > Even though KVM advertises the max physical bits to guest, guest may
> > ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
> > Rejecting invalid guest physical bits on KVM side is a choice, but it will
> > break current KVM ABI, e.g., current QEMU ignores the physical bits
> > advertised by KVM and uses host physical bits as guest physical bits by
> > default when using '-cpu host', although we would like to send a patch to
> > QEMU, it will still cause backward compatibility issues.
> >
> > For GPA that can't be translated by EPT but within host.MAXPHYADDR,
> > emulation should be the best choice since KVM will inject #PF for the
> > invalid GPA in guest's perspective and try to emulate the instructions
> > which minimizes the impact on guests as much as possible.
> >
> > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > Tested-by: Yi Lai <yi1.lai@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index be20a60047b1..a8aa2cfa2f5d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5774,6 +5774,13 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
> >
> >         vcpu->arch.exit_qualification = exit_qualification;
> >
> > +       /*
> > +        * Emulate the instruction when accessing a GPA which is set any bits
> > +        * beyond guest-physical bits that EPT can translate.
> > +        */
> > +       if (unlikely(gpa & rsvd_bits(kvm_mmu_tdp_maxphyaddr(), 63)))
> > +               return kvm_emulate_instruction(vcpu, 0);
> > +
> 
> This doesn't really work, since the KVM instruction emulator is
> woefully incomplete. To make this work, first you have to teach the
> KVM instruction emulator how to emulate *all* memory-accessing
> instructions.

Please forget allow_smaller_maxphyaddr and #PF for a while.

I agree KVM instruction emulator is incomplete. However, hardware can’t
execute instructions with GPA>48-bit and exits to KVM, KVM just repeatedly
builds SPTE, I.e., current KVM is buggy.

In this case, emulation may be a choice, I.e., KVM can emulate most common
instructions which reflects KVM's best efforts to maintain an environment for
continued execution. Even if some instructions can’t be emulated, it can
terminate the guest and will not make KVM silently hang there.

Thanks,
Tao

> 
> >         /*
> >          * Check that the GPA doesn't exceed physical memory limits, as that is
> >          * a guest page fault.  We have to emulate the instruction here, because
> > --
> > 2.34.1
> >
> >

