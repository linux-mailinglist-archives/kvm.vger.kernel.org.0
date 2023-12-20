Return-Path: <kvm+bounces-4874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB19F819626
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195131C2549B
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE145C9D;
	Wed, 20 Dec 2023 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2HXDFd/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4705245;
	Wed, 20 Dec 2023 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035272; x=1734571272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wFf9gNQ2+3Ut7ACKfwtV6t9BoflbnD6Be+0GLfLNHt4=;
  b=g2HXDFd/53YpaGdsXY39cJqQlUxrr3xNszPcYtd3QghJ+WBAKNw6+pgT
   Q1VrbjaxOeJ/lueDxQEKmpjqRgnxMDawsJi9jAOtEDwk9az2u7bJr833/
   751YFzGkJEOmXUGA17ooFA/vvwa5z16IZaDkJnT/lGJOY0kvcZnNaytDV
   co/2/dm/Xz1oEA5o8wMAHYZ8RR2k2VeBBmU0C9n0zqEHJwZ5YSX075f7l
   My0G4waQmNNyhU2+pf7sd0fPthhnKbGw6ZC2N50DVlgGFHIXZWYqzkje4
   y4Etwq8jhdFi9q5YQhj1qW8GTu5Ap+KDUowZftDbLrzkhAh6iKdPpBRka
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2964846"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="2964846"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:20:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="846539196"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="846539196"
Received: from ihur-mobl1.amr.corp.intel.com (HELO desk) ([10.209.1.244])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:20:55 -0800
Date: Tue, 19 Dec 2023 17:20:45 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH  v4 4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <20231220012045.f4i3kafpve4sleyq@desk>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-4-9a3622d4bcf7@linux.intel.com>
 <20231201195954.sr3nhvectmtkc47q@treble>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201195954.sr3nhvectmtkc47q@treble>

On Fri, Dec 01, 2023 at 11:59:54AM -0800, Josh Poimboeuf wrote:
> On Fri, Oct 27, 2023 at 07:38:59AM -0700, Pawan Gupta wrote:
> > The VERW mitigation at exit-to-user is enabled via a static branch
> > mds_user_clear. This static branch is never toggled after boot, and can
> > be safely replaced with an ALTERNATIVE() which is convenient to use in
> > asm.
> > 
> > Switch to ALTERNATIVE() to use the VERW mitigation late in exit-to-user
> > path. Also remove the now redundant VERW in exc_nmi() and
> > arch_exit_to_user_mode().
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  Documentation/arch/x86/mds.rst       | 38 +++++++++++++++++++++++++-----------
> >  arch/x86/include/asm/entry-common.h  |  1 -
> >  arch/x86/include/asm/nospec-branch.h | 12 ------------
> >  arch/x86/kernel/cpu/bugs.c           | 15 ++++++--------
> >  arch/x86/kernel/nmi.c                |  2 --
> >  arch/x86/kvm/vmx/vmx.c               |  2 +-
> >  6 files changed, 34 insertions(+), 36 deletions(-)
> > 
> > diff --git a/Documentation/arch/x86/mds.rst b/Documentation/arch/x86/mds.rst
> > index e73fdff62c0a..a5c5091b9ccd 100644
> > --- a/Documentation/arch/x86/mds.rst
> > +++ b/Documentation/arch/x86/mds.rst
> > @@ -95,6 +95,9 @@ The kernel provides a function to invoke the buffer clearing:
> >  
> >      mds_clear_cpu_buffers()
> >  
> > +Also macro CLEAR_CPU_BUFFERS is meant to be used in ASM late in exit-to-user
> > +path. This macro works for cases where GPRs can't be clobbered.
> 
> What does this last sentence mean?  Is it trying to say that the macro
> doesn't clobber registers (other than ZF)?

Yes. I will rephrase it to say that macro doesn't clobber registers
other than ZF.

