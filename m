Return-Path: <kvm+bounces-9960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA710868009
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 801061F2B25E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB2F12F39B;
	Mon, 26 Feb 2024 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AuN+tr5W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340A612E1D5;
	Mon, 26 Feb 2024 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973337; cv=none; b=NzZHN+FzIxjNlnI28w96jk5QBcx0Fo1qbuOnuaK+75bLxS6bBKRzFw/veac+r6BkvHB7iDr6hWUJa+WcQ3t/ynx8h/v2ZeWntyeHdodDapDZJrJZCW8/2yj/55d01dGYJZLvDaNAdcMzPjIuj/8zdVib+TKt8+3KmIwSpiouKLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973337; c=relaxed/simple;
	bh=2iE21yaZVBmLCRtP2HeDQyOQN7fV3k0xIAcmqO7xdDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkYMKRZ8uPSU/Ji3pdGy460mld0gmkSrAIzTdk1/nD8SgbqIeKm36u8cvK2ARq4KsTj6sDhVdhOG8X73zf/7O6OPpIQg5YMCLaccx1pqyXRFnVdpOsXAq8IMLymPPJApE8Lsfbdblpvg19VotB210HWGhvxdCgfvBa7oIi/oJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AuN+tr5W; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973335; x=1740509335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2iE21yaZVBmLCRtP2HeDQyOQN7fV3k0xIAcmqO7xdDs=;
  b=AuN+tr5WwH5fWOyUjCoNmo7fLn0QjYQMKcVLhr6opS1SAe2U4X7EcWv8
   PbeRkPzFGeRRhytr+TzGiQKkUyL/deiivuQ2Z6GzDnTenRkukQftKz6RD
   Mu375kd/pRNGTexa/FUB7T9Qk6Xq0pZ6IukIzkfSFiS+u7nYCVgNhfZ1U
   +GKm/wh0XWeR6EOe8J7f2i9/dZVkCeSwvFVH88x99t/9GojT6AwV7hsxx
   HrVRKSrTMrgYsoV1q2dZE4f70fgWjygnYFMAo5MNyMxVSWsztx3lFXKBX
   dlfOxLQtw6MBW1mVdRNl2HgMwG+Ma7rTJ+BfUHfgoKowKNg6D90K6WeaB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="28723355"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="28723355"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:48:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7188026"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:48:54 -0800
Date: Mon, 26 Feb 2024 10:48:52 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 007/121] KVM: VMX: Reorder vmx initialization with
 kvm vendor initialization
Message-ID: <20240226184852.GH177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <411a0b38c1a6f420a88b51cabf16ee871d6ca80d.1705965634.git.isaku.yamahata@intel.com>
 <413fd812-a6e6-4aff-860a-fd8cf4654157@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <413fd812-a6e6-4aff-860a-fd8cf4654157@intel.com>

On Thu, Feb 01, 2024 at 05:34:44PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18cecf12c7c8..443db8ec5cd5 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -171,7 +171,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
> >   static int __init vt_init(void)
> >   {
> >   	unsigned int vcpu_size, vcpu_align;
> > -	int cpu, r;
> > +	int r;
> >   	if (!kvm_is_vmx_supported())
> >   		return -EOPNOTSUPP;
> > @@ -182,18 +182,14 @@ static int __init vt_init(void)
> >   	 */
> >   	hv_init_evmcs();
> > -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> > -	for_each_possible_cpu(cpu)
> > -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > -
> > -	r = kvm_x86_vendor_init(&vt_init_ops);
> > -	if (r)
> > -		return r;
> > -
> >   	r = vmx_init();
> >   	if (r)
> >   		goto err_vmx_init;
> > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > +	if (r)
> > +		goto err_vendor_init;
> > +
> 
> we cannot simply change the calling order of vmx_init() and
> kvm_x86_vendor_init(). There is dependency between them.
> 
> e.g.,
> 
> kvm_x86_vendor_init()
>   -> ops->hardware_setup()
> 	-> vmx_hardware_setup()
> 
> will update 'enable_ept' based on hardware capability (e.g., if the hardware
> support EPT or not), while 'enable_ept' is used in vmx_init().

I gave up this clean up to drop this patch with v19.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

