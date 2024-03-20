Return-Path: <kvm+bounces-12194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47108880864
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7133F1C222BB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC1C80C;
	Wed, 20 Mar 2024 00:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCMNkQpv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440AA384;
	Wed, 20 Mar 2024 00:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893364; cv=none; b=EEtWUCTAyc6B9NLi+mmMHQVmD+777Kd9jnas1aAdoAs7zQ4Toi5VNFKgK1+GeA3L9sTub2fX9ZFpLj5NlDT6/RJUDdPCDR280eNA5Mzd+Wq8lXr0SPBT0VKot6NkG1jN9JQOtspTmAEJ1FnGW43eBrAyzu5ixsyg8ks0h1E4MgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893364; c=relaxed/simple;
	bh=cqIKOCS6NHMHFtZBMJGesvWB2DBmBKZXSGnmxpHs/DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2ELBSPmAruwGHoqLLjG7sQAbK5gpNmcUGsT2KXuepJxw2QojloWqznmVgYwiN5F3+b1wD0wqXHtSgYQfqdIajiOGlmNyJnfLYmtQwtvzTPnxI6KX6cd69pqAjfM2/JmTuNONrq+mYIBaolbhtBvf0YyR5Ql49Waqq7t/20X6b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCMNkQpv; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710893363; x=1742429363;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cqIKOCS6NHMHFtZBMJGesvWB2DBmBKZXSGnmxpHs/DE=;
  b=gCMNkQpvji7CPPonJZkkKSRn6r3ByOsuAGhvLHVJMxLsT1yr9n0BfIhs
   tyjpZhi57j7UOa1ZN1rro8lafVFGkf2hNzIMPbozs81laUHQur6n/tbep
   1n8ryUjaACiNKPMTAsGSIN/m1JDJ2z0C7fLYE5My+KtOsgiyW+YEuC2AG
   4b30SCbHs73zl/NS7S6IZAXalmFUuRCv0eZLupPmu9K4sRyLv8vwGEOEw
   xnx3P+wiV9AezkMNdnTdKOkjZMsxhXMQplShSxSPiOXLgNBNWt0CvnDRv
   5qo4SZLstsJD8CDaQhv6ij5Hb/8N/kJ/3+jazUuBCeGJy0cKa+LGI2kJq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="9595122"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="9595122"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:09:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="45068186"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:09:20 -0700
Date: Tue, 19 Mar 2024 17:09:20 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yao, Yuan" <yuan.yao@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240320000920.GD1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>

On Tue, Mar 19, 2024 at 11:24:37PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > +
> > +static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level,
> > hpa_t page,
> > +                                  struct tdx_module_args *out)
> > +{
> > +       struct tdx_module_args in = {
> > +               .rcx = gpa | level,
> > +               .rdx = tdr,
> > +               .r8 = page,
> > +       };
> > +
> > +       clflush_cache_range(__va(page), PAGE_SIZE);
> > +       return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
> > +}
> 
> The caller of this later in the series looks like this:
> 
> 	err = tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &out);
> 	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> 		return -EAGAIN;
> 	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT |
> TDX_OPERAND_ID_RCX))) {
> 		union tdx_sept_entry entry = {
> 			.raw = out.rcx,
> 		};
> 		union tdx_sept_level_state level_state = {
> 			.raw = out.rdx,
> 		};
> 
> 		/* someone updated the entry with same value. */
> 		if (level_state.level == tdx_level &&
> 		    level_state.state == TDX_SEPT_PRESENT &&
> 		    !entry.leaf && entry.pfn == (hpa >> PAGE_SHIFT))
> 			return -EAGAIN;
> 	}
> 
> The helper abstracts setting the arguments into the proper registers
> fields passed in, but doesn't abstract pulling the result out from the
> register fields. Then the caller has to manually extract them in this
> verbose way. Why not have the helper do both?

Yes. Let me update those arguments.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

