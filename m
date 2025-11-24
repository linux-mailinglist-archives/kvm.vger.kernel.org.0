Return-Path: <kvm+bounces-64425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CCBC824BA
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7739A4E88AE
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99C32D7DC2;
	Mon, 24 Nov 2025 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SuyeGANW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC8D2D5A13;
	Mon, 24 Nov 2025 19:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764012124; cv=none; b=HEvCTs1l93F2vj2Kg2tucdrIR7d+3UQpUbp3ZmWA+qOThTomaEc0xdL/eoQzt6rXlqS7h1gOKNcLsdP4WFUdhY1KobudgTCY4YN/QlXyURk5LXVvDmONZsCYQ87AteC4nUMsgZMNCGC9Gg5+C15S0mQl/Ha0rLqGKu3qt/n5cdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764012124; c=relaxed/simple;
	bh=5F8I78c4dMWy87gyhRtrLhwbyw2z/EYqj83XYCZJ6ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLAQot2YWPV8KE7WZIOJbk9Agv1o6Kt/a0ICPLYlDbtGMFj82WnMkmCdHdm/yOsohO9ktdGeWvN0qSW12FWyZEatTDPhBE3fKvpzHkqMkgHZleX87JUGuL4Q7c3MBKCNE0TM/S6tOZfivEbqbJMaHk0t3403ZsrqfmxVWrMOZA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SuyeGANW; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764012122; x=1795548122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5F8I78c4dMWy87gyhRtrLhwbyw2z/EYqj83XYCZJ6ps=;
  b=SuyeGANWAyur939x/lXaMTFRzik2b4bL35ZXvYh8ipvnSx4MuVVuxq2D
   RzcpSNglxcxHpUrQNukIuGB+0qSKG7OEQo1lkXj3IFS5J1Qoas9+Ayzan
   OlCIz2dDBnUv2DudZGjonSVV83BFRf/jZwEjMUAAoiIcJEC3uwkOC4y3L
   MfiaQpbwFg+5dMr7MRzoIQMy/f/2L29vtxLBi6vQjQqwLKNz42yAhleCp
   gBZtjrwIl8GAtm1yUeYJd6dD3PINr5Q7Q3St4GMSLoKVjXIvn9ZKumWIm
   BIGDmLQUlD4vY0A5N19m/5oAE5H2y9RcPoVuPKPEkJVX4Quz5KlBd/0L1
   g==;
X-CSE-ConnectionGUID: HGtPI0cCTcKZTag+ZXvxOg==
X-CSE-MsgGUID: IAgKBU7QQ0er7hsudK1aEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="53585237"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="53585237"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:22:01 -0800
X-CSE-ConnectionGUID: kACtIo6WRtWEmkqkMPSzMA==
X-CSE-MsgGUID: llz2HcCjR8KgBzy9yMAoVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192228088"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 11:22:01 -0800
Date: Mon, 24 Nov 2025 11:21:56 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251124192156.jo3rpewj3pa7x4i2@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
 <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
 <20251121181632.czfwnfzkkebvgbye@desk>
 <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
 <20251121212627.6vweba7aehs4cc3h@desk>
 <3db1228d-66af-4f2b-8fc3-506203dddf83@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3db1228d-66af-4f2b-8fc3-506203dddf83@intel.com>

On Fri, Nov 21, 2025 at 01:36:37PM -0800, Dave Hansen wrote:
> On 11/21/25 13:26, Pawan Gupta wrote:
> > On Fri, Nov 21, 2025 at 10:42:24AM -0800, Dave Hansen wrote:
> >> On 11/21/25 10:16, Pawan Gupta wrote:
> ...>>> Also I was preferring constants because load values from global
> variables
> >>> may also be subject to speculation. Although any speculation should be
> >>> corrected before an indirect branch is executed because of the LFENCE after
> >>> the sequence.
> >>
> >> I guess that's a theoretical problem, but it's not a practical one.
> > 
> > Probably yes. But, load from memory would certainly be slower compared to
> > immediates.
> 
> Yeah, but it's literally two bytes of data that can almost certainly be
> shoved in a cacheline that's also being read on kernel entry. I suspect
> it would be hard to show a delta between a memory load and an immediate.
> 
> I'd love to see some actual data.

You were right, the perf-tool profiling and the Unixbench results show no
meaningful difference between the two approaches. I was irrationally biased
towards immediates. Making the loop count as global.

