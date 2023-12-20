Return-Path: <kvm+bounces-4873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC954819621
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6970928787D
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFF1171DC;
	Wed, 20 Dec 2023 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EtaezQAv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EB7168A4;
	Wed, 20 Dec 2023 01:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703034954; x=1734570954;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HLyVwqO30briaKAvjBVfYYf6El0zpVQ8PfDWrML2yQc=;
  b=EtaezQAvR3uiFmKKbTWDWJyQ2GIdPKMyGR9IeNBJm1cTY/AZB/W8ZeEa
   FMSTTdwDzeZkA/xgEVolEccDVXkO0Eol6MaSkqmlIHd6e9nRpw0VKPZjw
   86aU2Y6x+Q3wEzzkLNNDoReNxrK0YWCi9Ro4lY6IuOAraCcUmMK4viSV+
   kBlL18yq9i83JQDiyk7G8LzOmXbZKBeTBAuEizMG1cmwfxlBcBHy89/un
   jQsJNkPN+P9rebmcl4oSJO9NGjUbHd2tqRPRUTTarBWgoKVs+vOd4f8Y/
   mzkmLqgTMxjMK0N09rNxsat2P5XJn04vX/499wKtvrOu2wKUeE5QtCTSY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="394628811"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="394628811"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:15:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="919798002"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="919798002"
Received: from ihur-mobl1.amr.corp.intel.com (HELO desk) ([10.209.1.244])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:15:50 -0800
Date: Tue, 19 Dec 2023 17:15:35 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH v4 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231220011535.cw3smza3kb5resji@desk>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-1-9a3622d4bcf7@linux.intel.com>
 <20231201193657.mvzslo4nlcbuv2q4@treble>
 <c61402de-c61e-4d7f-a2b1-3eaa13e4ef33@citrix.com>
 <20231201200442.lvyep5uqc6oa7kwj@treble>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201200442.lvyep5uqc6oa7kwj@treble>

On Fri, Dec 01, 2023 at 12:04:42PM -0800, Josh Poimboeuf wrote:
> On Fri, Dec 01, 2023 at 07:39:05PM +0000, Andrew Cooper wrote:
> > On 01/12/2023 7:36 pm, Josh Poimboeuf wrote:
> > > On Fri, Oct 27, 2023 at 07:38:40AM -0700, Pawan Gupta wrote:
> > >> +.pushsection .entry.text, "ax"
> > >> +
> > >> +.align L1_CACHE_BYTES, 0xcc
> > >> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> > >> +	UNWIND_HINT_UNDEFINED
> > >> +	ANNOTATE_NOENDBR
> > >> +	.word __KERNEL_DS
> > >> +.align L1_CACHE_BYTES, 0xcc
> > >> +SYM_CODE_END(mds_verw_sel);
> > >> +/* For KVM */
> > >> +EXPORT_SYMBOL_GPL(mds_verw_sel);
> > >> +
> > >> +.popsection
> > > This is data, so why is it "CODE" in .entry.text?
> > 
> > Because KPTI.
> 
> Urgh... Pawan please add a comment.

Yes, this place needs a comment, will add.

