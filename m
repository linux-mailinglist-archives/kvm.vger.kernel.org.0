Return-Path: <kvm+bounces-11804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED09E87C137
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A70A1C212B6
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F737352C;
	Thu, 14 Mar 2024 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnHhI9cm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99B73181;
	Thu, 14 Mar 2024 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433636; cv=none; b=AFz5dRF28CoRuqFAGcoTb1oLwMut8O+XnHgL/zvp03DR04On0uLCJGTgbpMA2TMCZ5XbOuuiISNIJLb4o2RI1YTkLc4Dr6UZfC2ch5oZhU2Dkd+v/QDlMu0OW4i0iItKXhAmYY4NKBYgUc/8IqRnZnzaeuX9QBqTlfrSlQwm3L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433636; c=relaxed/simple;
	bh=YpfZ0LjRR83dRF+eHwxHgnO/MhB/Otx/i8hyxDgocTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mndxgYoRa3Ltkcxv2iEMM7wFfCso0UoPyqWbkcK03nRj4PeElEU0Hmc4q2zfW8HHNrbuyHSyS33Qabvget2WyRY0N7D/szfPET4FC7g55S4gdpaGJ5J7U/QT9It65KL4JD+fvYrC3OofNkus77MwDQdu5K3IIpF6Qd6TbNMAUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnHhI9cm; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710433634; x=1741969634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YpfZ0LjRR83dRF+eHwxHgnO/MhB/Otx/i8hyxDgocTc=;
  b=dnHhI9cmigc2T/YHBVuWnwrqJxottsoBoNqdk/2S5U6wwulMRtibIl0n
   3DBhabv+SE0nkcae4bcQiPMFspQUjt3fsf4ukN3opWvq1uVkoTKrudnOn
   JhNMbDMgwsOTU4pV4DcLe4V3XsatsAxxgc33R03giAxfWleS73MRxKHHx
   5LnI6ZqFWGsSQvlJN0SoiEP7cswZeUz1oupCQSS88hDfJwweWYFtv2uBT
   NXB62Vac7uySGF2nL2AdSZJ79SVnf63JAvM0DTzpcfMco1FU8lPemgWDW
   hO+uEuG3nbN79NN6X1Drdgnrql86fsUoNceQM+tO5hhxt2/vZbZ3BiEp5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="27736526"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="27736526"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:27:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="12418727"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:27:13 -0700
Date: Thu, 14 Mar 2024 09:27:12 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20240314162712.GO935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>

On Thu, Mar 14, 2024 at 10:05:35AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18cecf12c7c8..18aef6e23aab 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -6,6 +6,22 @@
> >   #include "nested.h"
> >   #include "pmu.h"
> > +static bool enable_tdx __ro_after_init;
> > +module_param_named(tdx, enable_tdx, bool, 0444);
> > +
> > +static __init int vt_hardware_setup(void)
> > +{
> > +	int ret;
> > +
> > +	ret = vmx_hardware_setup();
> > +	if (ret)
> > +		return ret;
> > +
> > +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > +
> > +	return 0;
> > +}
> > +
> >   #define VMX_REQUIRED_APICV_INHIBITS				\
> >   	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
> >   	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> > @@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >   	.hardware_unsetup = vmx_hardware_unsetup,
> > +	/* TDX cpu enablement is done by tdx_hardware_setup(). */
> 
> How about if there are some LPs that are offline.
> In tdx_hardware_setup(), only online LPs are initialed for TDX, right?

Correct.


> Then when an offline LP becoming online, it doesn't have a chance to call
> tdx_cpu_enable()?

KVM registers kvm_online/offline_cpu() @ kvm_main.c as cpu hotplug callbacks.
Eventually x86 kvm hardware_enable() is called on online/offline event.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

