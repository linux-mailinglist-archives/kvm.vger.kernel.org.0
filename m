Return-Path: <kvm+bounces-18246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A16D8D29BA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3E471F264E9
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 00:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB02015A866;
	Wed, 29 May 2024 00:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3dmuWbH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FAB15A4BD;
	Wed, 29 May 2024 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716944343; cv=none; b=TQNk0x3oti0KhNxoIpWjbtnjGex+pFM8dOU4OyrY/jzlzJHRrEFIKBJphwnxjtZWnAXOkW5LQAYFImkXQQBrd0yCb/yj5m95X4V9K4a+cxFJClHQ+NQt6X0XIljHyeLJMSLNp3sZr3HohoEsH3xKNyAEjkqXZUft3a0SVDaOFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716944343; c=relaxed/simple;
	bh=3Ty4QTH6X5IlJLLsEFw32bNZu0wvz5vyuFHdX8FdW5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WslJ+v2zxTL/uE2dv775ZlZfzTsGgEIA/Vyu6NLrOU4E5MSs5cE6MWrl79g0d9+mmQ4HWUmb3gHldH8ftYn2wmNMH3aXOllYU+aQ4PtAXRv2GbZktGavc1NIDW/yrV2wGI2MdZPPDn5SoeV+Iy3jiPuyyuVrJ/BTymu8bLWYeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3dmuWbH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716944341; x=1748480341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Ty4QTH6X5IlJLLsEFw32bNZu0wvz5vyuFHdX8FdW5w=;
  b=h3dmuWbHZ9YcQR6ZSyg1Hb5wdYOFAmg8pkyNoP9YtXGW/3Df/vfRti92
   YwfBOsZZFhM+9qbybgtrZm1SSez/jawd5h7v+epX23szUxtu5cEMer2nk
   hVdXUOi0A/wcqywvAHkiKVPDyJQ3+9DpOV6A3ZKQWJgfnClOHBH2EkbKc
   ABa1Qqa0ZZJPFbTAmYDAj0JA1RImLihLTu40aVFO92rWmXAnqUlxOk61n
   3fcvoAMvr4Jp9afGNLm1/cr7d7epsO3Z6axmsEfDmBWIs+PPW9JGUHv2T
   DuRJm8KWQo1V7rURlgtzO2hWCEWhHztcFxju+6os2OvrfKbkM6ZP2QOCk
   A==;
X-CSE-ConnectionGUID: LkJNLMF9RCek4AptrCNaJQ==
X-CSE-MsgGUID: xPls7k4NQ8+E/PgHuRKRaA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30849020"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="30849020"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 17:59:01 -0700
X-CSE-ConnectionGUID: 0s9Xz4a+QfSplTqWh6DakQ==
X-CSE-MsgGUID: ZVbuj7t5T7+UMbstDMRo2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="40080450"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 17:59:00 -0700
Date: Tue, 28 May 2024 17:58:59 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Fengwei Yin <fengwei.yin@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <20240529005859.GB386318@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
 <ZgTgOVNmyVVgfvFM@chao-email>
 <ZlL2m3PKnYqc3uHr@chenyu5-mobl2>
 <20240529005519.GA386318@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240529005519.GA386318@ls.amr.corp.intel.com>

On Tue, May 28, 2024 at 05:55:19PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Sun, May 26, 2024 at 04:45:15PM +0800,
> Chen Yu <yu.c.chen@intel.com> wrote:
> 
> > On 2024-03-28 at 11:12:57 +0800, Chao Gao wrote:
> > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > >+static int vt_flush_remote_tlbs(struct kvm *kvm);
> > > >+#endif
> > > >+
> > > > static __init int vt_hardware_setup(void)
> > > > {
> > > > 	int ret;
> > > >@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
> > > > 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> > > > 	}
> > > > 
> > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > >+	/*
> > > >+	 * TDX KVM overrides flush_remote_tlbs method and assumes
> > > >+	 * flush_remote_tlbs_range = NULL that falls back to
> > > >+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> > > >+	 */
> > > >+	if (vt_x86_ops.flush_remote_tlbs ||
> > > >+	    vt_x86_ops.flush_remote_tlbs_range) {
> > > >+		enable_tdx = false;
> > > >+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> > > >+	}
> > > >+#endif
> > > >+
> > > > 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > > > 	if (enable_tdx)
> > > > 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > > > 					   sizeof(struct kvm_tdx));
> > > > 
> > > >+#if IS_ENABLED(CONFIG_HYPERV)
> > > >+	if (enable_tdx)
> > > >+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
> > > 
> > > Is this hook necessary/beneficial to TDX?
> > >
> > 
> > I think so.
> > 
> > We happended to encounter the following error and breaks the boot up:
> > "SEAMCALL (0x000000000000000f) failed: 0xc0000b0800000001"
> > 0xc0000b0800000001 indicates the TDX_TLB_TRACKING_NOT_DONE, and it is caused
> > by page demotion but not yet doing a tlb shotdown by tlb track.
> > 
> > 
> > It was found on my system the CONFIG_HYPERV is not set, and it makes
> > kvm_arch_flush_remote_tlbs() not invoking tdx_track() before the
> > tdh_mem_page_demote(), which caused the problem.
> > 
> > > if no, we can leave .flush_remote_tlbs as NULL. if yes, we should do:
> > > 
> > > struct kvm_x86_ops {
> > > ...
> > > #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(TDX...)
> > > 	int  (*flush_remote_tlbs)(struct kvm *kvm);
> > > 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
> > > 					gfn_t nr_pages);
> > > #endif
> > 
> > If the flush_remote_tlbs implementation are both available in HYPERV and TDX,
> > does it make sense to remove the config checks? I thought when commit 0277022a77a5
> > was introduced, the only user of flush_remote_tlbs() is hyperv, and now
> > there is TDX.
> 
> You don't like IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_TDX_HOST) in many
> places?  Then, we can do something like the followings.  Although It would be
> a bit ugly than the commit of 0277022a77a5, it's better to keep the intention
> of it.
> 

Ah, we have already __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE. We can use it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

