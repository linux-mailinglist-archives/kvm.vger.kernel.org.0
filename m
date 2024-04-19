Return-Path: <kvm+bounces-15355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B89BB8AB4C2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:07:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76DD5284495
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EE713C904;
	Fri, 19 Apr 2024 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="So5/mnn/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEAA130AC4;
	Fri, 19 Apr 2024 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550017; cv=none; b=jkGLdJuYpSMQ1iP+qmiYMmixscb8bzg4oteK7HTKqVj+tP4uG+Wqkcv3ITbxhqpHTLGjqK646iIEiCAkGynQEXCgN6xlrbDdVWVTByaQPrvVNPHKzClPS3qL/dCUXpYrZrOReDKcUj8TSnJpUO8Ya0w+Nb5uLmhqANfwCkXmTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550017; c=relaxed/simple;
	bh=KBWynCOp+Lgo8lSzeWtOi/RDySkBp8Ds0Fms1GnjVzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViuwLa0fgC+wdV7D/5rYLKQtexkuysj9NnTUMtHwu03zvPjDB2TfWqLkWrCZwSqCLzkzne/LAaXbww2MgGJu/vDYMWBZbUHG1nLLK+yN+J85r+2qObl6pw/efZdeduCSimHKSblT7TP+Z4MG1hUXqZ0agoki+r27jW/mDRJXHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=So5/mnn/; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713550016; x=1745086016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KBWynCOp+Lgo8lSzeWtOi/RDySkBp8Ds0Fms1GnjVzo=;
  b=So5/mnn/bfQVRa2gPuo535Li7ae7ZTjLcCT6l4uVGTE2JaIUvtGuolFN
   oKWAcTL8xr17JW+xafppCEp/Jn5+FeiFhlo6l106zkRnnqRGTHv/ogk5X
   LL9b9PHTgTMzUJbAlmTHFxaCJp36absq3Z5dWgGEAqPRheHw/Fu49k+zO
   YVV/8oXU1X8aOpRH6y4EBaRotA40p/m8/r3rhi0E5v1M6tQ2rwB24AZ0Y
   m5c1y2yab8Wotr4UkiUKANbiQ7JUSTLU3Wf9ON5h4dJfV60sitRSOQ5J9
   as/OQhLoBrzVyyD2mmmxGM91dISIendTXEyZG22JNWzfNsEqTQsycPURX
   A==;
X-CSE-ConnectionGUID: 87KgzCmEShSQhmKCU2p4LA==
X-CSE-MsgGUID: VaDLHjNBRzC16MbcNLK5Lw==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="26616070"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="26616070"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:06:55 -0700
X-CSE-ConnectionGUID: vxB+HwJ9Txy7kiYpLjlR2g==
X-CSE-MsgGUID: I9BjS0j3RxaFTrpB7D34Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="23388464"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 11:06:54 -0700
Date: Fri, 19 Apr 2024 11:06:53 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 117/130] KVM: TDX: Silently ignore INIT/SIPI
Message-ID: <20240419180653.GE3596705@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
 <7c71c294-8ce4-4f13-b827-d16a8811739a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c71c294-8ce4-4f13-b827-d16a8811739a@linux.intel.com>

On Fri, Apr 19, 2024 at 04:31:54PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
> > Instead it defines the different protocols to boot application processors.
> > Ignore INIT and SIPI events for the TDX guest.
> > 
> > There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
> > error to guest TDs somehow.  Given that TDX guest is paravirtualized to
> > boot AP, the option 1 is chosen for simplicity.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> [...]
> > +
> > +static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> > +{
> > +	if (is_td_vcpu(vcpu)) {
> > +		/* TDX doesn't support INIT.  Ignore INIT event */
> > +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> Why change the mp_state to KVM_MP_STATE_RUNNABLE here?
> 
> And I am not sure whether we can say the INIT event is ignored since
> mp_state could be modified.

We should drop the line.  Now it's not necessary and KVM_TDX_INIT_VCPU change
it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

