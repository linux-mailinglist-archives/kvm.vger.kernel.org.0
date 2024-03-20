Return-Path: <kvm+bounces-12325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D12A2881883
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CF52284B06
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B1E85941;
	Wed, 20 Mar 2024 20:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UMNUcAHv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7759029CE8;
	Wed, 20 Mar 2024 20:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710966055; cv=none; b=c24GmtpdsxsucYNBzkJAFmDpWcGHgSBZET2L0hneM578mMeIw9E0Zy/Q6CWap2mBgE9/DPWrfC8XAjalP+A7UBK+sZxtndPHZD1A9GY9z3TVDODO0n7U/TZpy6LmB2MtVbPtU5/mNRv4Bt1v9NhMRls+1CTawWmwk9DqeGc17iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710966055; c=relaxed/simple;
	bh=6KLApuHLnnboa7nGw7DTgDv4GVeg3my1JXPtaub9h/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ni6TxU9NrhF+y2AnulspKBfrBhGd+cZosgg//AiULX9irbqrdLF8juClYALIY2IgkNvhKWmRH/J6WoLg+HNrRK+wGzAxaDp6qG6NRt9InaiKUNDsk5rBXW5wfmSo7hRSi2lQvmBC1E5Kl8zOSQIdqonnRxh6l8da/x16HynYKpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UMNUcAHv; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710966054; x=1742502054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6KLApuHLnnboa7nGw7DTgDv4GVeg3my1JXPtaub9h/w=;
  b=UMNUcAHvAYbJNgH3hVlSvJRZ4Sx+JDrAuBhQxS45QU1xATXPPPipTM5j
   N/9Uy3LgIvv9WCIhSFj5UZYZyVTxBEMqcP5EindvHkmrxLo6mEoWl+VqP
   90fTVrKcGBtS+GahobvyxA3WpHKry0xBxDJRQc4x44v8HUttHECk7Yeqz
   xhzhO0ICBQ7gCHDIPMbITfkLzCRXsJRFO72SIE7N2kjs4RahL/JBVteZO
   q8yVUQTsedQ8SO7PiGv9VpYVNy+YBgzJ6ofdGOgQSXKjPKLr3/bRVbA+X
   PWfCvbEnfSuhNSEX1Embd2M2oYzwFeFCef2oYsLAfSR+vJCtea5aeZMG6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6037911"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6037911"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:20:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="18998840"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:20:41 -0700
Date: Wed, 20 Mar 2024 13:20:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240320202040.GH1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>
 <20240320000920.GD1994522@ls.amr.corp.intel.com>
 <97f8b63bd3a8e9a610c15ef3331b23375f4aeecf.camel@intel.com>
 <20240320054109.GE1994522@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320054109.GE1994522@ls.amr.corp.intel.com>

On Tue, Mar 19, 2024 at 10:41:09PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> On Wed, Mar 20, 2024 at 12:11:17AM +0000,
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> 
> > On Tue, 2024-03-19 at 17:09 -0700, Isaku Yamahata wrote:
> > > > The helper abstracts setting the arguments into the proper
> > > > registers
> > > > fields passed in, but doesn't abstract pulling the result out from
> > > > the
> > > > register fields. Then the caller has to manually extract them in
> > > > this
> > > > verbose way. Why not have the helper do both?
> > > 
> > > Yes. Let me update those arguments.
> > 
> > What were you thinking exactly, like?
> > 
> > tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
> > 
> > And for the other helpers?
> 
> I have the following four helpers.  Other helpers will have no out argument.
> 
> tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
> tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
> tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry, &level_state);
> tdh_mem_range_block(kvm_tdx, gpa, tdx_level, &entry, &level_state);

By updating the code, I found that tdh_mem_range_block() doesn't need out
variables. and tdh_vp_rd() needs output.
tdh_mem_range_block() doesn't need the out.

u64 tdh_vp_rd(struct vcpu_tdx *tdx, u64 field, u64 *value)
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

