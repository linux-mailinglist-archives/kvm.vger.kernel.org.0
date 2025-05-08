Return-Path: <kvm+bounces-45855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D1FAAFB46
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4935462F7B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A6E22B8D1;
	Thu,  8 May 2025 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVXPbwJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F25223DC4;
	Thu,  8 May 2025 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746710643; cv=none; b=Hgl4lC9KKVwlj0DehMc8IzNVT4PPBZnm1nBjcU1cyKQqY4nGQTpp+2fIL7vdispWZMP1W1kQObnMeWpIlO/23EAcZL/oItPWKVJFBJi451cNrXq6pLrh6XJM0oJIlemDsx98ylYKdXB0lPNmUpimQJWNAuIUWUA8463qXO9eBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746710643; c=relaxed/simple;
	bh=y7mvlA1Xnu4MwYJ+kc7kN5PCaE5XZ0KZBGzbXCjmpgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFOLd+XDFBUPZHeit0vHrdlbibGt8v0W8u3h2LW9aa1un8fDgFURYrLBmlypxVBxQbRpHWvMustmXH5V3IjIH3i3lz3TWfSymZzXrmFV7wunqrmhTMTUvjgk2n0onVuXyd3r+h0G7UaseCu3F6rxGlGjf4l9reaTqPrigJCIHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVXPbwJQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746710642; x=1778246642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y7mvlA1Xnu4MwYJ+kc7kN5PCaE5XZ0KZBGzbXCjmpgQ=;
  b=JVXPbwJQZK5ggOz4j3W+dsMzV0JDQdw8P9shEQtoWPYRIw7dKqdgZp04
   WK9c45aFilNhXFSK5mN31yROdzeine0hdtefaNbX0ympseL8RtPT+Y+Ei
   /HhJEsp7teGU8yjFcc0kYNXgz32MPVAle+hVAIkqLToVLat5/bkMFi/rd
   FXnZ8XfwOZ9SWH8Q74UsLWpHAa798bS8Va+DzSkZFOAQT38o7S0gEZy1+
   +Yp2EKYRiZoaGCUHigIhqbRwuwW2NARvBKDQMhAH08409kjYzI3bctC1s
   994iVHqvl/k/gfEpA7XRghaRScT7ov3iuZ9+1c6rZR/NUwwWqxRHMGpgU
   A==;
X-CSE-ConnectionGUID: neNpTWDvQme7q9lEVLNURA==
X-CSE-MsgGUID: QZm6Q3VgRV23kLSTwU7DRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="36122512"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="36122512"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 06:24:01 -0700
X-CSE-ConnectionGUID: XhjkS3UVRPGR+da8fUZqKA==
X-CSE-MsgGUID: tCGkOjPCQZCN+Uc8X3PJhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141058445"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa003.jf.intel.com with ESMTP; 08 May 2025 06:23:58 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 43B531D7; Thu, 08 May 2025 16:23:56 +0300 (EEST)
Date: Thu, 8 May 2025 16:23:56 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>

On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > The functions kvm_x86_ops::link_external_spt() and
> > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > covered by PAMT.
> > 
> > The new function kvm_x86_ops::phys_prepare() is called before
> > link_external_spt() and set_external_spte() to ensure that the memory is
> > ready to be assigned to the virtual machine. In the case of TDX, it
> > makes sure that the memory is covered by PAMT.
> > 
> > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > is available, allowing the implementation to allocate memory from a
> > per-VCPU pool.
> > 
> Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?

Because the memory pool we allocated from is per-vcpu and we lost access
to vcpu by then. And not all callers provide vcpu.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

