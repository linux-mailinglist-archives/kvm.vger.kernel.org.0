Return-Path: <kvm+bounces-51958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6673DAFEC89
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6626644826
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7432E54D8;
	Wed,  9 Jul 2025 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rw+tz0Vo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDAD1C32FF;
	Wed,  9 Jul 2025 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072571; cv=none; b=RvFtG+kB7UNeaEUHhaCQlKJNbFNIPaceL3Ms0YCuRGBWmmew6evjAKGp4N3bMT6bkkaTCNhUARIVVze1qMBJ3v2RFZJvmtemyvRZ5tuUMGknsJTCZDctpJKeOm7tsgpf38Apt54G3R/G+2S7EpiLqvmZD13A1f5vh/FEF3iPOk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072571; c=relaxed/simple;
	bh=xSvl9CF1jwzTxynZwjFnyiil9ZqCw6GWmeWc8+RV6Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcEi8pl+7wgJKgvSxgF/o1ftjboo7HsMZSVqr/dpznPQTIDOZvjLPYnbVT/SzB6obfd6SISbMikIq9tWMjyauLfR0HLgWMeLASM9c9P0A6klJB8scUKXILtGk09WL0ybiHte0t3eaNfGBjhOjAicIn7NEbwtccmO1SE3VLRGIm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rw+tz0Vo; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752072570; x=1783608570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xSvl9CF1jwzTxynZwjFnyiil9ZqCw6GWmeWc8+RV6Ig=;
  b=Rw+tz0VoF7w4Qh63wXNnkdDB81T1tdU0DPgwWyEJHTSlxU1i4y62vpoO
   gc4UYWD2UR4RgGs3HVgqgx3H02bvuUWMttkkkZrKYnx20IGvmr0cdV4qO
   RvMw+O6m4mvR+3mc/keB505y3r90kUM7/tmGDVgBRMyWjqonEi5ndTpnD
   +TPoiCbeUNUDBJui+31U5+AKqn7MubUHDs+M3HG6rZQC17j1biAcGa5e+
   GzedySpYUJOU7PcUM/QAks1vT7WuUrO9pCD5CeRoxcgNCwoIGwJmR9PFE
   W+0eTpl6am1HrF9uNGFnfvWC72NcVH/48oqkfqXo+RienYSKFCBUcO/f9
   w==;
X-CSE-ConnectionGUID: T/vd+8vXS0i7RCZ0b9cofA==
X-CSE-MsgGUID: HxFgaz6CSieE9S29ZPrJbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="71782705"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="71782705"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 07:49:30 -0700
X-CSE-ConnectionGUID: b6ledUAKSMeLI8Nv3S2uKw==
X-CSE-MsgGUID: 9PZQ7DKfQwOwHS70iJ4o0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="156281138"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 09 Jul 2025 07:49:25 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 112C91B7; Wed, 09 Jul 2025 17:49:23 +0300 (EEST)
Date: Wed, 9 Jul 2025 17:49:23 +0300
From: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add KVM mail list to the TDX entry
Message-ID: <4w73ozniubjoqgd636q6lohdxvcg2ryp4tlje6cm66rxjadjlr@jwxtq4lez6dl>
References: <20250709141035.70299-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709141035.70299-1-xiaoyao.li@intel.com>

On Wed, Jul 09, 2025 at 10:10:35PM +0800, Xiaoyao Li wrote:
> KVM is the primary user of TDX within the kernel, and it is KVM that
> provides support for running TDX guests.
> 
> Add the KVM mailing list to the TDX entry so that KVM people can be
> informed of proposed changes and updates related to TDX.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

