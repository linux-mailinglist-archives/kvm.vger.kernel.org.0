Return-Path: <kvm+bounces-12493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8210886FB4
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 16:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111611C21737
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 15:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B49B4E1C4;
	Fri, 22 Mar 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCVGPm17"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F08545BE4;
	Fri, 22 Mar 2024 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711120767; cv=none; b=GwkzQ5UPeEZicd7m6X9wfmNNSt99FY7p7NepJqO8e3xwCAh+rxAZBpbSIf6cPQ8w0viF0VvPl+d5VMkX7NUeaqs3EVolHksZnzNwGamfgQLw5da2SK5nIaGSg5OLU9IiczSsa1lFIoA4pVKRJlD3Mw8deWI49zfDes+PzO1zGqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711120767; c=relaxed/simple;
	bh=EmauFkFzSgc/qDZcww6tdS37MuHANiCdzNtCEy1AVn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5jlvprQKumPhA/Kgd+9efW5AElCAwFJnVG+AHGadPgNB15PcPHV6iIiZ8Vu8CCFzjOWPVo0iDxcfo6HB8HPvP1vuSQpwtEBlZyBTOWzpVr4R1YtV3NGEuq3fbTK9wreAlkqnD4j2uvZzHxUk5kb6Y7zk1OFPckioG2bE6y2OFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCVGPm17; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711120765; x=1742656765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=EmauFkFzSgc/qDZcww6tdS37MuHANiCdzNtCEy1AVn0=;
  b=FCVGPm17XL3MhKWPPtccQYru53bUjbRvZtUL1U+SeFthCgUOXwRvZoxs
   FuwEOkNRxAEPVzXAFz3AkqmnUVRF1C9o8E7EpJhdca1frjSrhNEbsMPWe
   ScXXEdbsQuoboMXIuSVkfW0E1AGdPbJwl/C7yy/eQi+drRC5BbXMW3eXe
   f4AQcz2w+iZjGzALl/wFmU3nKll3KXF1tr7ProzTDhllOHwNjCBCEJSYr
   wlDCwESaqagE5lQCglnkNSFAkimsCrOaO3KBQp9v8Uqu2LYvoySFrHovM
   kzCqX/bZAnAaxlSv+MWph01srOxvQJTaoEgHn2zbIA/kxvv7Njqw8a7x5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6359140"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="6359140"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 08:19:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="19636008"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 08:19:24 -0700
Date: Fri, 22 Mar 2024 08:19:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Message-ID: <20240322151923.GX1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
 <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
 <20240321212412.GR1994522@ls.amr.corp.intel.com>
 <Zf0wz82nQoL0VsAd@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zf0wz82nQoL0VsAd@chao-email>

On Fri, Mar 22, 2024 at 03:18:39PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Thu, Mar 21, 2024 at 02:24:12PM -0700, Isaku Yamahata wrote:
> >On Thu, Mar 21, 2024 at 12:11:11AM +0000,
> >"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> >
> >> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> >> > To handle private page tables, argument of is_private needs to be
> >> > passed
> >> > down.  Given that already page level is passed down, it would be
> >> > cumbersome
> >> > to add one more parameter about sp. Instead replace the level
> >> > argument with
> >> > union kvm_mmu_page_role.  Thus the number of argument won't be
> >> > increased
> >> > and more info about sp can be passed down.
> >> > 
> >> > For private sp, secure page table will be also allocated in addition
> >> > to
> >> > struct kvm_mmu_page and page table (spt member).  The allocation
> >> > functions
> >> > (tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know
> >> > if the
> >> > allocation is for the conventional page table or private page table. 
> >> > Pass
> >> > union kvm_mmu_role to those functions and initialize role member of
> >> > struct
> >> > kvm_mmu_page.
> >> 
> >> tdp_mmu_alloc_sp() is only called in two places. One for the root, and
> >> one for the mid-level tables.
> >> 
> >> In later patches when the kvm_mmu_alloc_private_spt() part is added,
> >> the root case doesn't need anything done. So the code has to take
> >> special care in tdp_mmu_alloc_sp() to avoid doing anything for the
> >> root.
> >> 
> >> It only needs to do the special private spt allocation in non-root
> >> case. If we open code that case, I think maybe we could drop this
> >> patch, like the below.
> >> 
> >> The benefits are to drop this patch (which looks to already be part of
> >> Paolo's series), and simplify "KVM: x86/mmu: Add a private pointer to
> >> struct kvm_mmu_page". I'm not sure though, what do you think? Only
> >> build tested.
> >
> >Makes sense.  Until v18, it had config to disable private mmu part at
> >compile time.  Those functions have #ifdef in mmu_internal.h.  v19
> >dropped the config for the feedback.
> >  https://lore.kernel.org/kvm/Zcrarct88veirZx7@google.com/
> >
> >After looking at mmu_internal.h, I think the following three function could be
> >open coded.
> >kvm_mmu_private_spt(), kvm_mmu_init_private_spt(), kvm_mmu_alloc_private_spt(),
> >and kvm_mmu_free_private_spt().
> 
> It took me a few minutes to figure out why the mirror root page doesn't need
> a private_spt.
> 
> Per TDX module spec:
> 
>   Secure EPT’s root page (EPML4 or EPML5, depending on whether the host VMM uses
>   4-level or 5-level EPT) does not need to be explicitly added. It is created
>   during TD initialization (TDH.MNG.INIT) and is stored as part of TDCS.
> 
> I suggest adding the above as a comment somewhere even if we decide to open-code
> kvm_mmu_alloc_private_spt().


058/130 has such comment.  The citation from the spec would be better.



> IMO, some TDX details bleed into KVM MMU regardless of whether we open-code
> kvm_mmu_alloc_private_spt() or not. This isn't good though I cannot think of
> a better solution.
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

