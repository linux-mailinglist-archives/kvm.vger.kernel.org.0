Return-Path: <kvm+bounces-25464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A85096584A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18AA82817B3
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B2015CD4D;
	Fri, 30 Aug 2024 07:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AWrdZfOV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF54F1509A0;
	Fri, 30 Aug 2024 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002494; cv=none; b=rZt5LUCLxHri7Cp+P+IoMCgAEVAObw2OAR+HCQ7Mpio3b1MaKxbH/VpecZoyGWtMPyfQ/FcbkVg4Ljkgs23HSkxKoGfDZ8OCAcC7Dfk622Kc7KEz9SZOPxLP+D0TZYle90jh6CmJHY+CwtA5Psuu05v6mrGQH8e6M393TvYaK5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002494; c=relaxed/simple;
	bh=FgWa3xuFBZIE8BaH1K88EEiex3imBuvR4h9fRGT+/Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRtc0aRJ7wXwlM+EmgQDV3bs7XQMPeaeorj6lAviDWq5SQFxhD8B9bUlvyLKp+hzpAwCCZYOW4O7LgEBYFNTl0cnrL8zv4DiG/qu/6QcGdejdBOJMujmEjkhfeXnlObOH7A31rBGw+5BFOv/JKC7GoQmaZ8AfzoYBob7NMqHCg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AWrdZfOV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725002493; x=1756538493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FgWa3xuFBZIE8BaH1K88EEiex3imBuvR4h9fRGT+/Fo=;
  b=AWrdZfOVq0PgCN38ChDKaKe81lxtZgo2V8vU4EZEJEFWfbPDq7zo0Gx6
   0zsnzCFa+wdQhICBz8fCzJrFPDtb75qJC4hiPAG+ahqPLCNbFWuWAl5Ch
   3i5idUyVuvWWe3tqO0/gNLOeq+rgYWdI2AsXfUvNhuvQV9/rHqrK96vnD
   ZgjvL+XXaPLVEO29tic3Zn0BsujPeUDVC6HgwPx3Htkf2FuAXESoS63Jl
   BZmtp+AaRCP9eOC6gIsIjdDtHobKmpN+bfmaVx6SjMvu+jIQ6tE23AqF/
   rJFAaHNkpFGfHcnGWpGsGgu1nEbnCGl+NjBNsUb2rlPARrbMnJExuvM47
   w==;
X-CSE-ConnectionGUID: /YG2cg+vSrmUnGQhOW9SDg==
X-CSE-MsgGUID: KirhShEaRRGc20MpOlviKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23787744"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23787744"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:21:32 -0700
X-CSE-ConnectionGUID: C4U2RfBpSiCNz8mB1MsxOQ==
X-CSE-MsgGUID: GCX5Jn/EQzSL7PNXvjzhkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63780727"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:21:28 -0700
Date: Fri, 30 Aug 2024 10:21:23 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <ZtFy8_etJ2tkQ8pm@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
 <Zr21XioOyi0CZ+FV@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr21XioOyi0CZ+FV@yilunxu-OptiPlex-7050>

On Thu, Aug 15, 2024 at 03:59:26PM +0800, Xu Yilun wrote:
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3,6 +3,7 @@
> >  #include <asm/tdx.h>
> >  #include "capabilities.h"
> >  #include "x86_ops.h"
> > +#include "mmu.h"
> 
> Is the header file still needed?

It's needed for kvm_gfn_direct_bits(), but should have been added in a
later patch.

> > +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> > +{
> > +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> > +	struct kvm_tdx_capabilities __user *user_caps;
> > +	struct kvm_tdx_capabilities *caps = NULL;
> > +	int i, ret = 0;
> > +
> > +	/* flags is reserved for future use */
> > +	if (cmd->flags)
> > +		return -EINVAL;
> > +
> > +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> > +	if (!caps)
> > +		return -ENOMEM;
> > +
> > +	user_caps = u64_to_user_ptr(cmd->data);
> > +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> > +		ret = -EFAULT;
> > +		goto out;
> > +	}
> > +
> > +	if (caps->nr_cpuid_configs < td_conf->num_cpuid_config) {
> > +		ret = -E2BIG;
> 
> How about output the correct num_cpuid_config to userspace as a hint,
> to avoid user blindly retries.

Hmm do we want to add also positive numbers for errors for this function?

> > +	for (i = 0; i < td_conf->num_cpuid_config; i++) {
> > +		struct kvm_tdx_cpuid_config cpuid_config = {
> > +			.leaf = (u32)td_conf->cpuid_config_leaves[i],
> > +			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
> > +			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
> > +			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
> > +			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
> > +			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
> > +		};
> > +
> > +		if (copy_to_user(&(user_caps->cpuid_configs[i]), &cpuid_config,
>                                   ^                           ^
> 
> I think the brackets could be removed.
> 
> > +					sizeof(struct kvm_tdx_cpuid_config))) {
> 
> sizeof(cpuid_config) could be better.

Looks like these both already changed in a later patch
"KVM: TDX: Report kvm_tdx_caps in KVM_TDX_CAPABILITIES".

Regards,

Tony

