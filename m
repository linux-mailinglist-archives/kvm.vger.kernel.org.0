Return-Path: <kvm+bounces-51503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0105AF7E22
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 18:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8568C1BC6FED
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889AA259CBD;
	Thu,  3 Jul 2025 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eEwGZ9Mq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF511C3F02;
	Thu,  3 Jul 2025 16:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751561056; cv=none; b=BmJICxdPBMkr3JR+pr3gP6yDJbSPJ4Po5M1l36+ogHt0F5p9OSdB9elJDmBWI6He55zi+OA5v4ey/g/Y0aJBKdCJvQnvQ7SwQexCXqqd1FN+XDfIo2sIMJYPdNJY/Pt/JPdd2/gr/+9P5D/gSlNufIFIISlq+0pIK3qIfLsquoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751561056; c=relaxed/simple;
	bh=PNjX+fpkp28FhAD79i8bZwdzbY+NJ72f5dGHxy39K4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BB6xY/Whc693S1tJSYkyXUurvWRfth98LEFRJvyDdOSz6nxq6v4LbGz7KjD8gnwKiJ+KxU3mb9uqqqdEPCgGVjqKPbGCPFRvQ60TutBzRlgtjl/IwTsKKbDDVioMmYMB8PqRdPQOTmdRGJAdBcRQtWvO6mhouLYlvno8iTHqKL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eEwGZ9Mq; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751561051; x=1783097051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PNjX+fpkp28FhAD79i8bZwdzbY+NJ72f5dGHxy39K4k=;
  b=eEwGZ9MqhbjEq+3gT8DKfUVfEgiy3iEFFA4ETuW8Fn0476shuX8I3AAI
   7fltUurKpH3V9cq+L/32Mcg7Rr4rPpvpayedhZ0f+y/Eh7g7q3oIz7PgT
   ZoCmBHwX7vajrgZx5BS9tdpNWiHAaTz2aAvt69QWflOD3NX3Sn5ol6RB9
   YDxkSeaQ9/MKqP3Le18yuG+O2Qwt1YDfL1i/MALb4Vc5U0uSZspYMnFwr
   pxkihZnLTAvMoO/AQo/L2tFPEI7Py/xIMlllhvV4EDxikFgBgJXG4I/lj
   ulWeQ0bn4lfPSvBRgksaQQ8j75+NMXXYojbZzgKA6uJwTxiUeunde2Aor
   Q==;
X-CSE-ConnectionGUID: 2ZRBEZjtRkKxHwzcjcfxRw==
X-CSE-MsgGUID: 9LJZ36v6R+K7rAPOfO8GLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="54037332"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="54037332"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 09:44:10 -0700
X-CSE-ConnectionGUID: qbmY6nzaTNaYsIIIy1zrdw==
X-CSE-MsgGUID: nXMo9tIWT9mw0ysVs9EL7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="178076794"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 03 Jul 2025 09:44:05 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 5E3111E0; Thu, 03 Jul 2025 19:44:04 +0300 (EEST)
Date: Thu, 3 Jul 2025 19:44:04 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, 
	seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>, 
	Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
Message-ID: <epi5mdxrpbehehtmjqcsajfrsqin7uttqak3lvoi6ct47kfk2x@i5rnjnaewgr7>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703153712.155600-3-adrian.hunter@intel.com>

On Thu, Jul 03, 2025 at 06:37:12PM +0300, Adrian Hunter wrote:
> Avoid clearing reclaimed TDX private pages unless the platform is affected
> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
> time on unaffected systems.
> 
> Background
> 
> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
> 
>    - Clears the TD Owner bit (which identifies TDX private memory) and
>      integrity metadata without triggering integrity violations.
>    - Clears poison from cache lines without consuming it, avoiding MCEs on
>      access (refer TDX Module Base spec. 16.5. Handling Machine Check
>      Events during Guest TD Operation).
> 
> The TDX module also uses MOVDIR64B to initialize private pages before use.
> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
> However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
> 
> In contrast, when private pages are reclaimed, the TDX Module handles
> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
> 
> Problem
> 
> Clearing all private pages during VM shutdown is costly. For guests
> with a large amount of memory it can take minutes.
> 
> Solution
> 
> TDX Module Base Architecture spec. documents that private pages reclaimed
> from a TD should be initialized using MOVDIR64B, in order to avoid
> integrity violation or TD bit mismatch detection when later being read
> using a shared HKID, refer April 2025 spec. "Page Initialization" in
> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
> Initialization by the Host VMM"
> 
> That is an overstatement and will be clarified in coming versions of the
> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
> Mode" in the same spec, there is no issue accessing such reclaimed pages
> using a shared key that does not have integrity enabled. Linux always uses
> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
> description in "Intel Architecture Memory Encryption Technologies" spec
> version 1.6 April 2025. So there is no need to clear pages to avoid
> integrity violations.
> 
> There remains a risk of poison consumption. However, in the context of
> TDX, it is expected that there would be a machine check associated with the
> original poisoning. On some platforms that results in a panic. However
> platforms may support "SEAM_NR" Machine Check capability, in which case
> Linux machine check handler marks the page as poisoned, which prevents it
> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
> Implement recovery for errors in TDX/SEAM non-root mode")
> 
> Improvement
> 
> By skipping the clearing step on unaffected platforms, shutdown time
> can improve by up to 40%.
> 
> On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
> clearing because these platforms may trigger poison on partial writes to
> previously-private pages, even with KeyID 0, refer commit 1e536e1068970
> ("x86/cpu: Detect TDX partial write machine check erratum")
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

