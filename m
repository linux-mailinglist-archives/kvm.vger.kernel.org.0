Return-Path: <kvm+bounces-16367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6EA8B8F78
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D94571F228D8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B89147C74;
	Wed,  1 May 2024 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScH5W0CZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127512FF8E;
	Wed,  1 May 2024 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714587566; cv=none; b=W3dTQHv3PhjB/yGyRQBefSIHQl9sr978PnnjuVI1OfFAp1Z4c5gX2dqnvQHttZxMJLSne5nXwW6BeRiywq5BE2WUcDRAtjXgQODnOBlccenaGj1Ppz8lEnN/BzwilFybtcFi7qLn4Xni1WcUu9z1oxBbT163FOoqixzhaZK7IUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714587566; c=relaxed/simple;
	bh=CFUjGYaNq+y5z8sBCGxb8U8rFBq/uzzIgZF13psjZQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkNowV+8YFsvls4Ze+0PEcdqTP74WY+m94AmEGrQUbpz1kfvKzsURIYAZyydzU6B4URbzukF0XhEH6ssQkdZzAcsR5/c/eEE1TTA3Tt5Z5N6q6PLEytAzx+HwP7eEv4Kn3nrDejbQyMf9keeXN4qP5Gt9cIhEJ01JGCgK0kfw7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScH5W0CZ; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714587564; x=1746123564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CFUjGYaNq+y5z8sBCGxb8U8rFBq/uzzIgZF13psjZQM=;
  b=ScH5W0CZPMhCcOuXGczHOZY+KedWUZJdk/xr2dBuwZOnNbcSBca4gdve
   QZNwdrx5veIEUykXDZz02ix3LnKh4fpB08Dv6cwmxoQSOdbba625y+XRB
   AkQAivOt/Q2EqIkRg+D/1ow8jXYMfOabaH27iaHAegCja2hKDee9IPRfM
   uRGijfeWR4otWhtCotlr5j5QcN+pGiMiQC5GJT7KwOm2pdnD4h7WsYfIq
   E0Qt9yifBtiWkcjZuW4xOmLommbU5CpEWbi36O5wzWCOW8k5DLmrWfycU
   EvlRNXDJbPxOD3GdW69orPkoFbMtSzislQoH2R0UndgF04N7MSvsXua3I
   w==;
X-CSE-ConnectionGUID: 3R9XZ3JJQPiN+XQp35DrQg==
X-CSE-MsgGUID: QXy8MFIIRI+UGikZQUjkPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="21746892"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="21746892"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 11:19:24 -0700
X-CSE-ConnectionGUID: 34bM8+z0QvOjPVeRPibpJw==
X-CSE-MsgGUID: 1h5LinuQQcyCwTuqC9iM5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26736476"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 11:19:21 -0700
Date: Wed, 1 May 2024 11:19:21 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Message-ID: <20240501181921.GB13783@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
 <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
 <20240501155620.GA13783@ls.amr.corp.intel.com>
 <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>

On Wed, May 01, 2024 at 09:54:07AM -0700,
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Isaku,
> 
> On 5/1/2024 8:56 AM, Isaku Yamahata wrote:
> > On Tue, Apr 30, 2024 at 01:47:07PM -0700,
> > Reinette Chatre <reinette.chatre@intel.com> wrote:
> >> On 4/3/2024 11:42 AM, Isaku Yamahata wrote:
> >>> On Mon, Apr 01, 2024 at 12:10:58PM +0800,
> >>> Chao Gao <chao.gao@intel.com> wrote:
> >>>
> >>>>> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >>>>> +{
> >>>>> +	unsigned long exit_qual;
> >>>>> +
> >>>>> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
> >>>>> +		/*
> >>>>> +		 * Always treat SEPT violations as write faults.  Ignore the
> >>>>> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
> >>>>> +		 * TD private pages are always RWX in the SEPT tables,
> >>>>> +		 * i.e. they're always mapped writable.  Just as importantly,
> >>>>> +		 * treating SEPT violations as write faults is necessary to
> >>>>> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
> >>>>> +		 * due to aliasing a single HPA to multiple GPAs.
> >>>>> +		 */
> >>>>> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
> >>>>> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
> >>>>> +	} else {
> >>>>> +		exit_qual = tdexit_exit_qual(vcpu);
> >>>>> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
> >>>>
> >>>> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
> >>>> #PF. I think you can add a comment for this.
> >>>
> >>> Yes.
> >>>
> >>>
> >>>> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.
> >>>
> >>> Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
> >>> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.
> >>>
> >>
> >> Is below what you have in mind?
> > 
> > Yes. data[0] should be the raw value of exit reason if possible.
> > data[2] should be exit_qual.  Hmm, I don't find document on data[] for
> 
> Did you perhaps intend to write "data[1] should be exit_qual" or would you
> like to see ndata = 3? I followed existing usages, for example [1] and [2],
> that have ndata = 2 with "data[1] = vcpu->arch.last_vmentry_cpu".
> 
> > KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON.
> > Qemu doesn't assumt ndata = 2. Just report all data within ndata.
> 
> I am not sure I interpreted your response correctly so I share one possible
> snippet below as I interpret it. Could you please check where I misinterpreted
> you? I could also make ndata = 3 to break the existing custom and add
> "data[2] = vcpu->arch.last_vmentry_cpu" to match existing pattern. What do you
> think?
> 
Sorry, I wasn't clear enough. I meant
  ndata = 3;
  data[0] = exit_reason.full;
  data[1] = vcpu->arch.last_vmentry_cpu;
  data[2] = exit_qual;

Because I hesitate to change the meaning of data[1] from other usage, I
appended exit_qual as data[2].

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

