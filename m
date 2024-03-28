Return-Path: <kvm+bounces-12955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C3588F613
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:55:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F98B29785B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6EF37714;
	Thu, 28 Mar 2024 03:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BP9MJb+0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A583612C;
	Thu, 28 Mar 2024 03:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711598140; cv=none; b=S0aPknb66aCTLZjd7EECHySR1XPkQb9R/a8G9wBTsorLVpMhdfZhh+kDCwjxBA3YN8VT9SMGgst2Biy8gDjzRwbgu/ArmRexstoYHKH5wzQZa58MeDksbN9NkP2c40BcafQCjVqpgXvsZAvgsQO+IxIMMQnuMJ4Oy4U++4grfcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711598140; c=relaxed/simple;
	bh=psUKbddsJmKuRN0FxEaMP6+4Pw98qpDcMTXQZ/jyzjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvi1YJYe2HJhwyd2CYxuxZAPBlOcrgu1jo2cbxz5t3dJUaYx6n/5rT2KXnqOekLNxHv04J9mlvlzyFMUrxczFZNTdw+eOhoJ+UtRqlFIj8wM5CBLpK0cJ3Q4uGJMbQ1zoi5hDHx+M20s0hqE7FV6l/vHA/984gkfiVgKhj/mfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BP9MJb+0; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711598139; x=1743134139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=psUKbddsJmKuRN0FxEaMP6+4Pw98qpDcMTXQZ/jyzjU=;
  b=BP9MJb+0qDIsDdy2IFPgGTCifXLoK1KL1rjAghKSnAHgbTlBJJsZX8lc
   emgCoF6ugmFZMvkLuX5O1uGDI50XrW0tVIgKiAB//EpubUSKmUvY61xFC
   MeD00QDiokcPHxZDb+ZCc6ZJXdEU51es9nMmdJTkA9fJffcjd5x+o9aQ2
   sUdWVjbSIbopXSNrkUL7J/CUN8AK45WwVc1O39zgugJDcMGwkuRE6wJrB
   oNtDvHoHgoopnUm9joE/rMPnWWq/vwiaEqi9YflnSOrks8gp1u3NAv5BJ
   LeAj12YtdL8rwyOiJos9AqJ2u8J71rP2aC7z5i5XCyjNJ+qM4CzEMawie
   Q==;
X-CSE-ConnectionGUID: jTcjWVpuStOwHbTTUNTTTg==
X-CSE-MsgGUID: L728brDDQIuk3HS+QmG1nQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6863664"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6863664"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:55:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16912482"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:55:38 -0700
Date: Wed, 27 Mar 2024 20:55:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Message-ID: <20240328035537.GN2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
 <ZgTgOVNmyVVgfvFM@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgTgOVNmyVVgfvFM@chao-email>

On Thu, Mar 28, 2024 at 11:12:57AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+static int vt_flush_remote_tlbs(struct kvm *kvm);
> >+#endif
> >+
> > static __init int vt_hardware_setup(void)
> > {
> > 	int ret;
> >@@ -49,11 +53,29 @@ static __init int vt_hardware_setup(void)
> > 		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
> > 	}
> > 
> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+	/*
> >+	 * TDX KVM overrides flush_remote_tlbs method and assumes
> >+	 * flush_remote_tlbs_range = NULL that falls back to
> >+	 * flush_remote_tlbs.  Disable TDX if there are conflicts.
> >+	 */
> >+	if (vt_x86_ops.flush_remote_tlbs ||
> >+	    vt_x86_ops.flush_remote_tlbs_range) {
> >+		enable_tdx = false;
> >+		pr_warn_ratelimited("TDX requires baremetal. Not Supported on VMM guest.\n");
> >+	}
> >+#endif
> >+
> > 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > 	if (enable_tdx)
> > 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> > 					   sizeof(struct kvm_tdx));
> > 
> >+#if IS_ENABLED(CONFIG_HYPERV)
> >+	if (enable_tdx)
> >+		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
> 
> Is this hook necessary/beneficial to TDX?
> 
> if no, we can leave .flush_remote_tlbs as NULL. if yes, we should do:
> 
> struct kvm_x86_ops {
> ...
> #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(TDX...)
> 	int  (*flush_remote_tlbs)(struct kvm *kvm);
> 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
> 					gfn_t nr_pages);
> #endif

Will fix it. I made mistake when I rebased it. Now those hooks are only for
CONFIG_HPYERV.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

