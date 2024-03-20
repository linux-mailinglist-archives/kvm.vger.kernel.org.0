Return-Path: <kvm+bounces-12211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CB1880AC1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 06:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7B1F1F2294D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 05:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429691947E;
	Wed, 20 Mar 2024 05:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1mTt/Lu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA548182A1;
	Wed, 20 Mar 2024 05:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710913274; cv=none; b=ll0+761D3IU4/K1hyIY4WJLRJ1vpzymoRVKDkluhNZDPhXEBQwrO7AN3jXmfih893MdEltc62gFLgHFanH3+bMtm1l5JzOXm7h6EEPKK2mf7G2chuOjQaVPpDsBUK1TZXnMdiJfRwsKg54jtPaOBgA5SrZFktXcejneEvpsOdPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710913274; c=relaxed/simple;
	bh=3GMZnY+JN53UzdMSGC6C8EOQ504dGXkGJ8WKcwuVtyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHxZgGn6uN0Ovuz7qZ4bmbJBM39xOOFlH8PEJAUkLlDGbKSfDwNF1UjRdxxRuJstycPkPZ6usutr7pTzhAau4WPK3fecmtjEhrokxUUK5NK+UE+C0YJ839/A8qC5AL+Y3q6CpQ1GTV/SdUccp1e9tH95G1jb1jIv7hhnJSwYJBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1mTt/Lu; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710913272; x=1742449272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3GMZnY+JN53UzdMSGC6C8EOQ504dGXkGJ8WKcwuVtyA=;
  b=m1mTt/Lu49v/M/LGblJTh25VuxN9o8LQjKDzMCt5CRxTz9rUORa0nQYK
   FrJVypfVLDymbMvRLy9qE8H2ghKklslrtsMnheVPFDv/8Wj1RoBk6CGHA
   HZirEK6eVQQF8rqCHNyV+/XNKOq/mXQm5t8HDNpFlfuCuf2N5CigJ62qV
   4+ABWX/74esN8m5QuKdMppL5y/r4/LgEk9FyIk+y0IrAJLWMiN/xWRBjC
   LRoEFKyp5bPp7ZA+C5ex5U6dkNvDOpaLs12LbFNm6XDavQCQpuekjG3po
   BPnJj30XMdrgyp95chcRMxsR+NF009jnJloPO4Th8fxBKJPXmMrtYDQNh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="23320806"
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="23320806"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 22:41:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,139,1708416000"; 
   d="scan'208";a="14067896"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 22:41:10 -0700
Date: Tue, 19 Mar 2024 22:41:09 -0700
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
Message-ID: <20240320054109.GE1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>
 <20240320000920.GD1994522@ls.amr.corp.intel.com>
 <97f8b63bd3a8e9a610c15ef3331b23375f4aeecf.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97f8b63bd3a8e9a610c15ef3331b23375f4aeecf.camel@intel.com>

On Wed, Mar 20, 2024 at 12:11:17AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-03-19 at 17:09 -0700, Isaku Yamahata wrote:
> > > The helper abstracts setting the arguments into the proper
> > > registers
> > > fields passed in, but doesn't abstract pulling the result out from
> > > the
> > > register fields. Then the caller has to manually extract them in
> > > this
> > > verbose way. Why not have the helper do both?
> > 
> > Yes. Let me update those arguments.
> 
> What were you thinking exactly, like?
> 
> tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
> 
> And for the other helpers?

I have the following four helpers.  Other helpers will have no out argument.

tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry, &level_state);
tdh_mem_range_block(kvm_tdx, gpa, tdx_level, &entry, &level_state);
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

