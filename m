Return-Path: <kvm+bounces-12907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB82788F23F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 352171F272A4
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 22:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED92E15443F;
	Wed, 27 Mar 2024 22:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVgMZSPb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D10C15219B;
	Wed, 27 Mar 2024 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711580220; cv=none; b=iRLBAhayXbnnDx5whRkNhsijBp2t9f7Py+JdPEH5yhPXL1Ihh6ppcAZmMHM1xxUdpWOIRfLi+HLZETVXf8g7RQMqR0Gkwh4DkzVxHbOXBwFyOIrqJGM/LPj+Xb4rhl1H5c4etpkEpSUKbuHOrS+MohKmA1Uwl1+qMiLkQULKERE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711580220; c=relaxed/simple;
	bh=/WsGRor0OcIsp5twq3DCqyZDYfUawzcDpORqySW5HmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tl7UAlYLttComqwwtB3X+KLm6KiTmQXvfYkZPRpMQGGlVFT2ENPOXfzw8ChPdvfeF67pw8XRITUEQ21lWuOvn9cxG/QKdhqfUuSc3YCTS583wbxLajdEzpkUsmZXVBLrdXedN4lqkqO93KzMrrx3B+9r2bkV5e0WcvJZVUqrTUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVgMZSPb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711580219; x=1743116219;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/WsGRor0OcIsp5twq3DCqyZDYfUawzcDpORqySW5HmA=;
  b=LVgMZSPbAN6AyEYdupw5c1D4LgSVjIgCvMtzQ4W94q/4NdHqMSwmGoVf
   YSQkxKmvqbngcTh+w+UE2FNo5ksLyoN4zB2NvOojSpQdkOyitlgIfe2Ve
   GLAbT1fkyFLHYI4FJgH7rAVzSU3pYV6aYuj8DyUB6CVZTzzbISuO01Pw9
   EEu7VxtdOpHRJqjUzuZe/TRpSoozXn9c2ueZGp4yh+pSgj6UW34Uhn2cr
   vF9LnEyZgxy1IzH7Z29bcwLvZQQVHZ1DE+2lbV48fun2RU2o5o9uKPOj/
   h3/IRJ1TBObpAtrz4Qmrz+UyJH6C2vm1V/katakx0lqqdcXnMlLwrtEee
   g==;
X-CSE-ConnectionGUID: grbU7zUGRre0mD/XMJ3rGw==
X-CSE-MsgGUID: iNaUGVOFQbOtwhDJw4Bo+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6575146"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6575146"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 15:56:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16285299"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 15:56:57 -0700
Date: Wed, 27 Mar 2024 15:56:57 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 044/130] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <20240327225657.GG2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
 <3f4f164a6375c8ada364dd2a83562a506019db86.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f4f164a6375c8ada364dd2a83562a506019db86.camel@intel.com>

On Wed, Mar 27, 2024 at 12:27:03AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > +/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
> > +static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > +{
> > +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +       struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +       unsigned long *tdvpx_pa = NULL;
> > +       unsigned long tdvpr_pa;
> 
> 
> I think we could drop theselocal variables and just use tdx->tdvpr_pa and tdx->tdvpx_pa. Then we
> don't have to have the assignments later.

Yes, let me clean it up. The old version acquired spin lock in the middle. Now
we don't have it.


> > +       unsigned long va;
> > +       int ret, i;
> > +       u64 err;
> > +
> > +       if (is_td_vcpu_created(tdx))
> > +               return -EINVAL;
> > +
> > +       /*
> > +        * vcpu_free method frees allocated pages.  Avoid partial setup so
> > +        * that the method can't handle it.
> > +        */
> > +       va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +       if (!va)
> > +               return -ENOMEM;
> > +       tdvpr_pa = __pa(va);
> > +
> > +       tdvpx_pa = kcalloc(tdx_info->nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
> > +                          GFP_KERNEL_ACCOUNT);
> > +       if (!tdvpx_pa) {
> > +               ret = -ENOMEM;
> > +               goto free_tdvpr;
> > +       }
> > +       for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> > +               va = __get_free_page(GFP_KERNEL_ACCOUNT);
> > +               if (!va) {
> > +                       ret = -ENOMEM;
> > +                       goto free_tdvpx;
> > +               }
> > +               tdvpx_pa[i] = __pa(va);
> > +       }
> > +
> > +       err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
> > +       if (KVM_BUG_ON(err, vcpu->kvm)) {
> > +               ret = -EIO;
> > +               pr_tdx_error(TDH_VP_CREATE, err, NULL);
> > +               goto free_tdvpx;
> > +       }
> > +       tdx->tdvpr_pa = tdvpr_pa;
> > +
> > +       tdx->tdvpx_pa = tdvpx_pa;
> 
> Or alternatively let's move these to right before they are used. (in the current branch 
> 
> > +       for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
> > +               err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
> > +               if (KVM_BUG_ON(err, vcpu->kvm)) {
> > +                       pr_tdx_error(TDH_VP_ADDCX, err, NULL);
> > +                       for (; i < tdx_info->nr_tdvpx_pages; i++) {
> > +                               free_page((unsigned long)__va(tdvpx_pa[i]));
> > +                               tdvpx_pa[i] = 0;
> > +                       }
> > +                       /* vcpu_free method frees TDVPX and TDR donated to TDX */
> > +                       return -EIO;
> > +               }
> > +       }
> > 
> > 
> In the current branch tdh_vp_init() takes struct vcpu_tdx, so they would be moved right here.
> 
> What do you think?

Yes, I should revise the error recovery path.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

