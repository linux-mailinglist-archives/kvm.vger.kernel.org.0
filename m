Return-Path: <kvm+bounces-46702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0B3AB8BCD
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D664E505E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED48D21CA02;
	Thu, 15 May 2025 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjCkJAuI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11D921B910;
	Thu, 15 May 2025 16:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747324955; cv=none; b=DVkoW3jhA5loFqSrn1AFRfB71OCQ5miwlMSojbwCAbd2GfWICYuwLUgzo1bVSeWWLA/aSbxuQikCw4r66Qx33ve0cr+OjfBnxOTm3j59rMz2hhAJ2mteR2TF2C/E2uP0LAtI5JQC07GDfrcgtN0b2AyOi5k2+7lz6LP2dAsPXyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747324955; c=relaxed/simple;
	bh=NeQa9Q9Kb72fLgS+DYOFNrIRrqBf+Ez+boe81RNR0rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqV7SWdbMsI0HwsBxLvy8qAHABB1WIAvW6vKipC7m8EtVQqgACVKSX/g74SEJebnx4Rr50v662gvVvj4eIQheJWcgfl/HlTm6w2J/taHtunYm1r11P6jU56D4mCNO4CoeD0XgJnCJg+UBuTeZU7LnXexMi+3b7kHBx+cR0s+srg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjCkJAuI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747324953; x=1778860953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NeQa9Q9Kb72fLgS+DYOFNrIRrqBf+Ez+boe81RNR0rc=;
  b=gjCkJAuIB+JmvpXD0MjsKhWz9z+yqwatxicb3NSCbcvWBe+gx48oNEKP
   bjaS9+Jn0olyTRslYk1eKo6oGCVlbV/OQwpHPONgIlk/o05iqbYLmZuWt
   SMPilipIUr7T5m3TZRPWC1VCTlGG2/hy4SLhjbasXM4NzpUEG45VfIa/M
   QNECL4ptVkRpqtb2mEQvdq9Ku2ECqA3875k3SgjuNBDp8C4TxS/v0rwHt
   sAa9ALZYUdgm+69GE3eYaQE2WpCm+xwgWvcqcoYNv4ZUgdZnhX7wGPqUR
   BeblG/94qC/aqKs4pWAa4Oh774yt/JTgE3enPnBKLP+B5H0/qGhinsy5e
   g==;
X-CSE-ConnectionGUID: fsTQjMk+TfKfANrAWpfPKQ==
X-CSE-MsgGUID: ZDbLF9ImQMyo2Y9+BKrKDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="53072359"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="53072359"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 09:02:32 -0700
X-CSE-ConnectionGUID: GciQCzw6TrmO1GCnPjcRlA==
X-CSE-MsgGUID: 4mEPT2KeTGyV6y82RJ5X4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="161709439"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 15 May 2025 09:02:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id BD22623F; Thu, 15 May 2025 19:02:27 +0300 (EEST)
Date: Thu, 15 May 2025 19:02:27 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, kai.huang@intel.com, 
	yan.y.zhao@intel.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] TDX: Enable Dynamic PAMT
Message-ID: <hwxaujzu4jz5v4gztv2afbfzrqhldh3aq42jbpi2owussor46y@v2vfzrybtdnx>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <aCSddrn7D4J-9iUU@google.com>
 <pla54zy4z27df57uxmzuog26mddiezbwsyrurnjxivdkg5dibx@574tcxdgjru2>
 <e1e2eddf-7706-4e5f-8e4a-ef2dc331e873@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1e2eddf-7706-4e5f-8e4a-ef2dc331e873@intel.com>

On Thu, May 15, 2025 at 08:03:28AM -0700, Dave Hansen wrote:
> On 5/15/25 07:22, Kirill A. Shutemov wrote:
> > VMM is responsible for allocating and freeing PAMT_4K. There's a pair of
> > new SEAMCALLs for it: TDH.PHYMEM.PAMT.ADD and TDH.PHYMEM.PAMT.REMOVE. They
> > add/remove PAMT memory in form of page pair. There's no requirement for
> > these pages to be contiguous.
> 
> BTW, that second sentence is a little goofy. Is it talking about
> ADD/REMOVE being a matched pair? Or that there needs to be 8k of
> metadata storage provided to each ADD/REMOVE call?

Both :P

Pair of SEAMCALLs operate on pairs of pages.

> One thing I've noticed in writing changelogs and so forth is that
> repetition can hurt understanding if the concepts aren't the same. Like
> saying there is a "pair" of calls and a "pair" of pages when the fact
> that both are pairs is a coincidence rather than an intentional and
> important part of the design.

Yeah, I see it.

I will try to avoid to "pair" for SEAMCALLs in Dynamic PAMT context.
Maybe it will clear up the confusion.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

