Return-Path: <kvm+bounces-72768-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id FUD6B2zRqGmnxgAAu9opvQ
	(envelope-from <kvm+bounces-72768-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:42:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F142F20989F
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2117E303EDAB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 00:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCF91EDA2C;
	Thu,  5 Mar 2026 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STyrwXgp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58A633688E;
	Thu,  5 Mar 2026 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772671330; cv=none; b=Dz9LvQZAyNtjmvCI9EYyZlkcK1mBv/NpeEtRmilGIOTo/C0uXwNwPFPQIS4w1WCj6GPKlIZJo810lCJIQERj04LJueVdRB1/bkLPjYcYilFkeF94EbwyJ0eP0f8NLoxsJbGvT9VbHAHpilwaZ8wrNY71F52EbEAOCcmJKgYMcqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772671330; c=relaxed/simple;
	bh=yVoZtEPfb24KS1foR1wBRzFDD9qc01mhq71L1wGUa4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMv6ZlahUvLsUlHI/YAnEkRkDfVo2Tx1O++JOCs22AwScEllCv2YPaVQcQU7ZIYTMl68YRRvnpzNt4cw0b1IFEqtG8NJ74jCPULAzZ+9QAE0qv34DaWNKNc2Es15XOI0lDArtyQldBOoJDn9M8hDGXGcQJ+JxmPlQnz4ytha3bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STyrwXgp; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772671329; x=1804207329;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yVoZtEPfb24KS1foR1wBRzFDD9qc01mhq71L1wGUa4Y=;
  b=STyrwXgpTeSuR/uIwizI37dSgLF19HtPGXIC9JZsekLm8BEYFWhI6dPb
   dDWeFKmZxGgZZUpg8PJHdTQ4NApMqAoP8tNIdlxzqN2SyjwMMtk3Le6Rn
   xsonSfJEHjIad8DHw8jS+UtTUr+1M1wYE7lWO3aFTX/PaYGmi2o5M6Gmt
   JW93T9Mprms3JhLSoHi7gUYnKciKCRnv4j/U9Gg8IjeLCGmNvnhmyvvSQ
   6ceyn61UN+0h9Qg4uX4xi1PpA1cTP00G8FuXas3WhlrNyrAjApa1bZYdp
   qjTHGpEii2Ir4G9OTEEOoISFABIlcjEy73Y/G9ulagbjUgF2tNl2FrweH
   w==;
X-CSE-ConnectionGUID: hWiY8n8wQBKfN8yfwzlCPA==
X-CSE-MsgGUID: 2dNxZ2WeQNmr9OxS/vXKbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84459648"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="84459648"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:42:08 -0800
X-CSE-ConnectionGUID: RUEoSl+VQr6zNluigEJkVg==
X-CSE-MsgGUID: TMJ2IvSuQjiDKwZfbUEMuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="256391298"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:42:08 -0800
Date: Wed, 4 Mar 2026 16:41:48 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
Message-ID: <20260305004139.5mhzyyywqb34kf6q@desk>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
 <20260124193418.GGaXUeulAxLp1QwVpM@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124193418.GGaXUeulAxLp1QwVpM@fat_crate.local>
X-Rspamd-Queue-Id: F142F20989F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72768-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pawan.kumar.gupta@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

First of all, apologies for not responding to this and many other emails I
still need to read. (For the past few months I was off-work and have been
dealing with a personal emergency. Now thats over, I am catching up with
the pending stuff.)

On Sat, Jan 24, 2026 at 08:34:18PM +0100, Borislav Petkov wrote:
> On Mon, Dec 01, 2025 at 10:19:14PM -0800, Pawan Gupta wrote:
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b11e25e2fbcc77489d 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
> >  	ANNOTATE_NOENDBR
> >  	push	%rbp
> >  	mov	%rsp, %rbp
> > -	movl	$5, %ecx
> > +
> > +	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> > +	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> > +		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL
> 
> Why isn't this written like this:
> 
> in C:
> 
> clear_bhb_loop:
> 
> 	if (cpu_feature_enabled(X86_FEATURE_BHI_CTRL))
> 		__clear_bhb_loop(12, 7);
> 	else
> 		__clear_bhb_loop(5, 5);
> 
> and then the __-version is asm and it gets those two arguments from %rdi, and
> %rsi instead of more hard-coded, error-prone registers diddling alternative
> gunk?

This would require CLEAR_BRANCH_HISTORY to move the hard-coded arguments to
the register, which isn't looking pretty:

.macro CLEAR_BRANCH_HISTORY
	ALTERNATIVE "movq $5,  %rdi; movq $5, %rsi",		\
		    "movq $12, %rdi; movq $7, %rsi", X86_FEATURE_BHI_CTRL

	ALTERNATIVE "", "call clear_bhb_loop; lfence", X86_FEATURE_CLEAR_BHB_LOOP
.endm

I don't think we can avoid the register diddling one way or the other. Also
it is best if the loop count stays within clear_bhb_loop(), so that atleast
the callsites can stay clean and don't have to worry about the magic number
arguments.

