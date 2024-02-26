Return-Path: <kvm+bounces-9987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 095938680D4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67EB21F23865
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383DF12F5A0;
	Mon, 26 Feb 2024 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i/rGofxx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BEE12DDAB;
	Mon, 26 Feb 2024 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975301; cv=none; b=ct4uIiPheXS8KGgKSMKX2IyQbBPDnUPE9gC/ZALzfEk8t7OzuFdkpNwtiinY86itYTnFoNkaMOlpV/PcgJPj1eLB99QAsdBmNFwYfKPR121yg5cjfWEs3zYgsQwX0U+Hpgnua+hGfX6rxQ9vmH/JlBfa/ICu1Hs9IoQW7n1LYsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975301; c=relaxed/simple;
	bh=BhwZDP9hYJk+cNxTWcvUP6DCeBXECSJ839dFR9fsm+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzxshBbMM0hq51+KA84EWMx0JADYz/+OGTgFjnvRbi2UyGiQ2fQAdFJ+fK6egkTXT3Buiw+0zSYrP02FhPXb0BB/q1E+8ap+Eg7DYUnfnnBH/n0K+7q829ZJLcTjtAgDxISo+f2QnE/WSG1jsQP+BrIkqi1N1Cp/A/MPyu4EHXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i/rGofxx; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708975301; x=1740511301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BhwZDP9hYJk+cNxTWcvUP6DCeBXECSJ839dFR9fsm+0=;
  b=i/rGofxxyW+jvY6VwQ0y6CB7GqSvxPRHSMZVWACITy0axE9FT49LDAJo
   D1pDibMZgSKDu/xLqcgB0X5V73B/9okNyWLXjlP5D0vh7fWzSQfw0f/8a
   iXG462b/nloL7zMJ6k6RyT6dgUsVQBfF1IcYA8U0V78NqdnOiyN3LXw+U
   KQW8i5xIh5kCL+6qs7h/QuOuIo4Xcru5/3RdJQ6wl3RULAvjMMIFOx8Wq
   qnfE+xW4agRlp7aL0qGII/ncP/mrtYTfkpfKIUc1Dc/an8/L9Gh3BSZJf
   D0XgX0iwU5aOXpynrGqmLUvbkqzGJEvAk2iVpE/hlRekwo++Rq16kTRDN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="25752823"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="25752823"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:21:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11448181"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 11:21:38 -0800
Date: Mon, 26 Feb 2024 11:21:37 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 060/121] KVM: TDX: TDP MMU TDX support
Message-ID: <20240226192137.GP177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <a47c5a9442130f45fc09c1d4ae0e4352054be636.1705965635.git.isaku.yamahata@intel.com>
 <9da45a6a-a40b-4768-90d0-d7de674baec1@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9da45a6a-a40b-4768-90d0-d7de674baec1@linux.intel.com>

On Tue, Jan 30, 2024 at 11:31:22PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +
> > +/*
> > + * TLB shoot down procedure:
> > + * There is a global epoch counter and each vcpu has local epoch counter.
> > + * - TDH.MEM.RANGE.BLOCK(TDR. level, range) on one vcpu
> > + *   This blocks the subsequenct creation of TLB translation on that range.
> > + *   This corresponds to clear the present bit(all RXW) in EPT entry
> > + * - TDH.MEM.TRACK(TDR): advances the epoch counter which is global.
> > + * - IPI to remote vcpus
> > + * - TDExit and re-entry with TDH.VP.ENTER on remote vcpus
> > + * - On re-entry, TDX module compares the local epoch counter with the global
> > + *   epoch counter.  If the local epoch counter is older than the global epoch
> > + *   counter, update the local epoch counter and flushes TLB.
> > + */
> > +static void tdx_track(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	u64 err;
> > +
> > +	KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm);
> > +	/* If TD isn't finalized, it's before any vcpu running. */
> > +	if (unlikely(!is_td_finalized(kvm_tdx)))
> > +		return;
> > +
> > +	/*
> > +	 * tdx_flush_tlb() waits for this function to issue TDH.MEM.TRACK() by
> > +	 * the counter.  The counter is used instead of bool because multiple
> > +	 * TDH_MEM_TRACK() can be issued concurrently by multiple vcpus.
> > +	 */
> > +	atomic_inc(&kvm_tdx->tdh_mem_track);
> > +	/*
> > +	 * KVM_REQ_TLB_FLUSH waits for the empty IPI handler, ack_flush(), with
> > +	 * KVM_REQUEST_WAIT.
> > +	 */
> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH);
> > +
> > +	do {
> > +		/*
> > +		 * kvm_flush_remote_tlbs() doesn't allow to return error and
> > +		 * retry.
> > +		 */
> > +		err = tdh_mem_track(kvm_tdx->tdr_pa);
> > +	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
> 
> Why the sequence of the code is different from the description of the
> function.
> In the description, do the TDH.MEM.TRACK before IPIs.
> But in the code, do TDH.MEM.TRACK after IPIs?

It's intentional to handle IPI in parallel as we already introduced
tdh_mem_track.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

