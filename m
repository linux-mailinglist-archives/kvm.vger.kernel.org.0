Return-Path: <kvm+bounces-12533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B67B8875A5
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6760B2307D
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922D382C63;
	Fri, 22 Mar 2024 23:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPSZZWTS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D0482895;
	Fri, 22 Mar 2024 23:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711149311; cv=none; b=GxvmegLjPSuYxyuxmM0eiTpuf6JeIFsAGuND/TTF3qqRoBVQZH7HNaH/92zSqFJxdSkJJeQCJVoBGOEFsiChlVKzh2L9BX00h3EWzMBFWu3Uhy63tj8+xDihmErmi9qbAkQSypw5tiZtVFRM03k3wzRMrLFIqFKxumf+nGYpxGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711149311; c=relaxed/simple;
	bh=8uUPqKEXFYILQlYlay9jYtVkLU/5jJhtNXyxet3+C4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oevuPDhKhsOZvKii9TMq62+Evi6V98KV+g2OWHowqoi1Bjy/KxszQr6nK4FXZMKdI4cGiXFdfPe8BUN/ozqwtkjJmvteBI1sRIzevPz807XuJi377Am7lwLxQvH9QdsGJBJRwOLdMBSU7zd7bzQNkFUwFjTC8tkpOospINVO0O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPSZZWTS; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711149311; x=1742685311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8uUPqKEXFYILQlYlay9jYtVkLU/5jJhtNXyxet3+C4c=;
  b=SPSZZWTSQPrd3OnSJLfgVgAOKoQ80lEe01fF7BQID1o7e4iYOQDIKVuR
   g8Km/ZlpAiC4j7hHCv6iMPxigfuyk34Yj6nk75mWwlvUzBjJQpo0rDQWZ
   VjBJKIywn7UQoviii1metN5oZKLqCN4em5K3dVgVFiir4wKc7RlYvAUsr
   4vNvVPT+webFwyOVdjQpyL1qmWsDuV72EDA6VFJYjr6/KCk638gfHRQxe
   V2WUC0pB2kNOU0vFiVL/mqNNUJkKx8eeA0QDsG9T+sSPRzf9RXG5L/KR5
   UtG4EKnlkmO4CkEV3uaNXBXjkZH147EfmmnYKoxt7WdmxIJDWwNVoaDi0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="10005170"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="10005170"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:15:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15038953"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:15:09 -0700
Date: Fri, 22 Mar 2024 16:15:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	"Li, Xiaoyao" <Xiaoyao.Li@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240322231509.GD1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <b7b919eb-81fd-4f27-86c1-6e160754608e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b7b919eb-81fd-4f27-86c1-6e160754608e@intel.com>

On Fri, Mar 22, 2024 at 10:57:53AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> > +/*
> > + * TDX SEAMCALL API function leaves
> > + */
> > +#define TDH_VP_ENTER			0
> > +#define TDH_MNG_ADDCX			1
> > +#define TDH_MEM_PAGE_ADD		2
> > +#define TDH_MEM_SEPT_ADD		3
> > +#define TDH_VP_ADDCX			4
> > +#define TDH_MEM_PAGE_RELOCATE		5
> 
> I don't think the "RELOCATE" is needed in this patchset?
> 
> > +#define TDH_MEM_PAGE_AUG		6
> > +#define TDH_MEM_RANGE_BLOCK		7
> > +#define TDH_MNG_KEY_CONFIG		8
> > +#define TDH_MNG_CREATE			9
> > +#define TDH_VP_CREATE			10
> > +#define TDH_MNG_RD			11
> > +#define TDH_MR_EXTEND			16
> > +#define TDH_MR_FINALIZE			17
> > +#define TDH_VP_FLUSH			18
> > +#define TDH_MNG_VPFLUSHDONE		19
> > +#define TDH_MNG_KEY_FREEID		20
> > +#define TDH_MNG_INIT			21
> > +#define TDH_VP_INIT			22
> > +#define TDH_MEM_SEPT_RD			25
> > +#define TDH_VP_RD			26
> > +#define TDH_MNG_KEY_RECLAIMID		27
> > +#define TDH_PHYMEM_PAGE_RECLAIM		28
> > +#define TDH_MEM_PAGE_REMOVE		29
> > +#define TDH_MEM_SEPT_REMOVE		30
> > +#define TDH_SYS_RD			34
> > +#define TDH_MEM_TRACK			38
> > +#define TDH_MEM_RANGE_UNBLOCK		39
> > +#define TDH_PHYMEM_CACHE_WB		40
> > +#define TDH_PHYMEM_PAGE_WBINVD		41
> > +#define TDH_VP_WR			43
> > +#define TDH_SYS_LP_SHUTDOWN		44
> 
> And LP_SHUTDOWN is certainly not needed.
> 
> Could you check whether there are others that are not needed?
> 
> Perhaps we should just include macros that got used, but anyway.

Ok, let's break this patch into other patches that uses the constants first.


> > +/*
> > + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> > + */
> 
> Why is this comment applied to TDX_MAX_VCPUS?
> 
> > +#define TDX_MAX_VCPUS	(~(u16)0)
> 
> And is (~(16)0) an architectural value defined by TDX spec, or just SW value
> that you just put here for convenience?
> 
> I mean, is it possible that different version of TDX module have different
> implementation of MAX_CPU, e.g., module 1.0 only supports X but module 1.5
> increases to Y where Y > X?

This is architectural because it the field width is 16 bits.  Each version
of TDX module may have their own limitation with metadata, MAX_VCPUS_PER_TD.


> Anyway, looks you can safely move this to the patch to enable CAP_MAX_CPU?

Yes.


> > +
> > +struct td_params {
> > +	u64 attributes;
> > +	u64 xfam;
> > +	u16 max_vcpus;
> > +	u8 reserved0[6];
> > +
> > +	u64 eptp_controls;
> > +	u64 exec_controls;
> > +	u16 tsc_frequency;
> > +	u8  reserved1[38];
> > +
> > +	u64 mrconfigid[6];
> > +	u64 mrowner[6];
> > +	u64 mrownerconfig[6];
> > +	u64 reserved2[4];
> > +
> > +	union {
> > +		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
> > +		u8 reserved3[768];
> 
> I am not sure you need the 'reseved3[768]', unless you need to make
> sieof(struct td_params) return 1024?

I'm trying to make it 1024 because the spec defines the struct size is 1024.
Maybe I can add BUILD_BUG_ON(sizeof(struct td_params) != 1024);


> > +#define TDX_MD_ELEMENT_SIZE_8BITS      0
> > +#define TDX_MD_ELEMENT_SIZE_16BITS     1
> > +#define TDX_MD_ELEMENT_SIZE_32BITS     2
> > +#define TDX_MD_ELEMENT_SIZE_64BITS     3
> > +
> > +union tdx_md_field_id {
> > +	struct {
> > +		u64 field                       : 24;
> > +		u64 reserved0                   : 8;
> > +		u64 element_size_code           : 2;
> > +		u64 last_element_in_field       : 4;
> > +		u64 reserved1                   : 3;
> > +		u64 inc_size                    : 1;
> > +		u64 write_mask_valid            : 1;
> > +		u64 context                     : 3;
> > +		u64 reserved2                   : 1;
> > +		u64 class                       : 6;
> > +		u64 reserved3                   : 1;
> > +		u64 non_arch                    : 1;
> > +	};
> > +	u64 raw;
> > +};
> 
> Could you clarify why we need such detailed definition?  For metadata
> element size you can use simple '&' and '<<' to get the result.

Now your TDX host patch has the definition in arch/x86/include/asm/tdx.h,
I'll eliminate this one here and use your definition.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

