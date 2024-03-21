Return-Path: <kvm+bounces-12437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0B28862CA
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02D891F212B2
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0C613666A;
	Thu, 21 Mar 2024 21:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PS+GeD6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49C4133998;
	Thu, 21 Mar 2024 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711058399; cv=none; b=kYCo30pOj+ftBdy9yP3aJy5/nw3wMzDCo+aFDl+nfbXX7Pp4Nc6gkfxPgvzD4x3hz5TbnQnCg6Au3cyY2+fFrlCLbzeCwXN/feeOjbp9i9r++pTEuhsV5Gq/LTP1LGkUZo+BUtc2sUWjmQAMGpXSqCpQNnwNJLnv0j9WayBehxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711058399; c=relaxed/simple;
	bh=lcQ5MuMgTWIwGQDRcTtRCXnB2iq3G/thV1UuRGB+LLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnx3NP7l4raGTFpbvp7rqkjNoi/lrcAYZlLHbyYrprvKp/CbpJSMea3DZ4VcdfY5u5WauHzSJCcRY6YGKUUFD8Euo1G7KWZVH1cQaBsmd0sMW/HVRAMPSHPir7xDfXcY//FKwG9DiTjr613f5JanUfT0uyWP9dzv9tafY8+SIr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PS+GeD6Z; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711058397; x=1742594397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lcQ5MuMgTWIwGQDRcTtRCXnB2iq3G/thV1UuRGB+LLk=;
  b=PS+GeD6ZWaxFDxElonmlAuPwRU3pGqt+pfqmHy6uLdVdtL0z32gK/tka
   joJf8LW2xZoWJBXv/bAB2szqBF+cxoDLErP76Fll12jup8Fzmw1WIMhrj
   LCpFX2SW/l+0lTJ9kFsBIb1pldGDBaLlpswYDYdEX6/lu9gsMT6uA/Bz0
   nijn1STVYPq1IWvp2s2+PwZB0sl5Gct9moVmvmDoJGeJjjOEFJQWQhIaC
   EUUwQCdF8sFl1PHiRtYFIlI+/97apc9UdjlxM49aa/KcQuyEZYPc4tCEv
   tuqBHfZ8X+yPCSJ/b7SJVNQFGyJkYBlzXqkh8MdJem+RWRsDtLvjuw1xq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="17233534"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="17233534"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:59:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="15068356"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:59:57 -0700
Date: Thu, 21 Mar 2024 14:59:55 -0700
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
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 057/130] KVM: x86/mmu: Add a new is_private member
 for union kvm_mmu_page_role
Message-ID: <20240321215955.GS1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <3692118f525c21cbe3670e1c20b1bbbf3be2b4ba.1708933498.git.isaku.yamahata@intel.com>
 <875eb07773836bf1d5668a4f28a696869e3291c2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <875eb07773836bf1d5668a4f28a696869e3291c2.camel@intel.com>

On Thu, Mar 21, 2024 at 12:18:47AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Because TDX support introduces private mapping, add a new member in
> > union
> > kvm_mmu_page_role with access functions to check the member.
> 
> I guess we should have a role bit for private like in this patch, but
> just barely. AFAICT we have a gfn and struct kvm in every place where
> it is checked (assuming my proposal in patch 56 holds water). So we
> could have
> bool is_private = !(gfn & kvm_gfn_shared_mask(kvm));

Yes, we can use such combination. or !!sp->private_spt or something.
Originally we didn't use role.is_private and passed around private parameter.


> But there are extra bits available in the role, so we can skip the
> extra step. Can you think of any more reasons? I want to try to write a
> log for this one. It's very short.

There are several places to compare role and shared<->private.  For example,
kvm_tdp_mmu_alloc_root(). role.is_private simplifies such comparison.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

