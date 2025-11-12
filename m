Return-Path: <kvm+bounces-62918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A20D7C53E84
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8950A4EC419
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBD334B18C;
	Wed, 12 Nov 2025 18:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfIoQ7kD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283FA35CBB4;
	Wed, 12 Nov 2025 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971466; cv=none; b=DNDvB/47sJTra4LwQhzEjRJxHMBHykEu61SXqgdDsKYdrrkyEq/Cy+nE5grroZI04vP/8NMAkr1wsv3gmMkjzXjqd01BeTazLefKWg2RiJxHOv1+WM0rrzyfCNX6IRJQquq7LtjSglwAo4XKv5CRg5U9wMmRdrbixJRm1KO80RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971466; c=relaxed/simple;
	bh=XCsg6C+dT69tAsEDcbWjJ2ffwwjzqz/+aK3ZgSOq+L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+LrBsmja9IT4mBODsoOWUaENN3pmwWHJtETBB68n2DIgU5Bd5CW5vl6u41ZNeJ5cEOMoxNdUz26U5AbHMLdYlPMvprmAxF7I1r5UkzqSEN5mbmb1GYqIY2D7Hba7uV0uvPMFx9O3pnulocUC+BWqf6G1KVCqsgsQibAcP9kTpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfIoQ7kD; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762971464; x=1794507464;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XCsg6C+dT69tAsEDcbWjJ2ffwwjzqz/+aK3ZgSOq+L8=;
  b=gfIoQ7kD2vDAF/p2q/wpiZEuGQlzC523e5mrtGN2WL5LjdqyU4VCIWRM
   rZKniDzE9+/jRzJc4unOdLbFKgzMdM2WmXoOMG4OycgOZTO5iAqc80nhb
   BzC1AIdDt2e05h9KoU37uWnnKh9p+yB3x6SeoTqX6odwxCNT8U/HaYbip
   uciAeLHSgns+ngfyi7GnzmiZlHMtf6cifng0xE6bGhago7zEnfn3uYGuq
   Xh4yoff2Xa1LKfMRXTcG5N6gUmN8OiITVUahRLxoRiMYxA3YwcU69cu3M
   B67LtYpRgEe+k2QTI+TQGwlFdFgDF/iZfn74HIzBfm4yyAwWYnn9asyB+
   g==;
X-CSE-ConnectionGUID: jooDEBhRTGaUSal8jFN9Kw==
X-CSE-MsgGUID: YGJEta3uRiCFDB5K00ba1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76502324"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76502324"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:17:43 -0800
X-CSE-ConnectionGUID: 66y/mOWpTNKdWfaiVTgb3w==
X-CSE-MsgGUID: 6HPwPNgTRL2knMljzwebdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="193680598"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:17:43 -0800
Date: Wed, 12 Nov 2025 10:17:38 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251112181738.bm3voyeyjfnqkgnc@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <20251103181840.kx3egw5fwgzpksu4@desk>
 <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>

On Fri, Nov 07, 2025 at 08:05:34PM +0100, Borislav Petkov wrote:
> On Mon, Nov 03, 2025 at 10:18:40AM -0800, Pawan Gupta wrote:
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 08ed5a2e46a5..2be9be782013 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -321,9 +321,11 @@
> >  #endif
> >  .endm
> >  
> > +/* Primarily used in exit-to-userspace path */
> 
> What does "primarily" mean here?

> $ git grep -w CLEAR_CPU_BUFFERS
> 
> says *only* the kernel->user vector.

By the end of this series, yes. At this patch this is used in VMX also:

  arch/x86/kvm/vmx/vmenter.S:164:        CLEAR_CPU_BUFFERS

"Primarily" can be dropped by the patch that replaces it in SVM/VMX.

> >  #define CLEAR_CPU_BUFFERS \
> >  	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
> >  
> > +/* For use in KVM */
> 
> That's why the "VM_" prefix is there.
> 
> The comments in arch/x86/include/asm/cpufeatures.h actually already explain
> that, you could make them more explicit but let's not sprinkle comments
> willy-nilly.

As Sean pointed out, this goes away in later patches.

