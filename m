Return-Path: <kvm+bounces-64714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D36BC8B8FF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:23:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C68CA3B4CDE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D84533FE34;
	Wed, 26 Nov 2025 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wo8/FkTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD7E314A82;
	Wed, 26 Nov 2025 19:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185017; cv=none; b=sy6eFVNFpwGjFoM4t3hSgefm9iFCObzzhJz6z8M1oCqxGESjSBOFlLuxMVkFAiPUeMgRSGlGz8aiuC5D0wIgy9I3AyhSrQGlwBJOn3ikLj+xsnLtLWowopCPdehmlxSuZ7IxBI0jJsHik31oraRMnj2/gXEYiXSuByT7q8lyzns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185017; c=relaxed/simple;
	bh=3Q9w0sIA8gEEJk9hlgzi1H2/rNq1oYnLzxXTwDrqOJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gV3oI/yBEOzxKOEYUF6QF6MGG4rYO8stOKIWBSKwWom6gSdLHH0nZp3nRFEQvwn90hwMbUvE/HLxCmMlPbWdLTFUSZ76n9A5xlroLBayhX6Ry3CexKKEVUulLPtngPgCyFEdbBbGotmsQhH/9sX3t4qDBjoM93mxMI5TUIAi268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wo8/FkTJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764185016; x=1795721016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Q9w0sIA8gEEJk9hlgzi1H2/rNq1oYnLzxXTwDrqOJw=;
  b=Wo8/FkTJQDhQSD7rATH2TZYYNd8PKfewVqZpCVqVlYH3N3qgQIO+T33g
   K75u+EoLhHSaKzJXh0f2PF/m38XrEDgh4+iC5RQ0ej6rO7ZyZomlKAZ/+
   9hIz5LNImqXokRjE6kwu4NVBALzrN5eCsnCJXwt80WWwDHJVYaUvSc3JB
   lAjqPsMggkqQau4V5s2AoQZ3gYaGAQNA1AstkVP9SCL4b06HekGtVLtAx
   mdL1tACtYhAdfvpW+DxZdDvkQ+ui3OUHTNGBJilvRWLBwZ1Pozr+uEftD
   fSAZYrk4dQ1M8HJ/jXNpccQXTQGYcSw4gtYQLLKtxlouockEE+mFbbFGW
   w==;
X-CSE-ConnectionGUID: BS666jLJQB+S4cxP5gUUEg==
X-CSE-MsgGUID: XghqogrXShix6+q3mJKLWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="88877087"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="88877087"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 11:23:35 -0800
X-CSE-ConnectionGUID: FyDoqD2uSymlZQOerWXn4w==
X-CSE-MsgGUID: S+0LMvxDRvGXNKL8+imG6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193479200"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 11:23:35 -0800
Date: Wed, 26 Nov 2025 11:23:27 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
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
Message-ID: <20251126192327.4rclrdguxeripnow@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>

On Fri, Nov 21, 2025 at 08:40:44AM -0800, Dave Hansen wrote:
> On 11/19/25 22:18, Pawan Gupta wrote:
> > -	CLEAR_BHB_LOOP_SEQ 5, 5
> > +	/* loop count differs based on CPU-gen, see Intel's BHI guidance */
> > +	ALTERNATIVE (CLEAR_BHB_LOOP_SEQ 5, 5),  \
> > +		    __stringify(CLEAR_BHB_LOOP_SEQ 12, 7), X86_FEATURE_BHI_CTRL
> 
> There are a million ways to skin this cat. But I'm not sure I really
> like the end result here. It seems a little overkill to use ALTERNATIVE
> to rewrite a whole sequence just to patch two constants in there.
> 
> What if the CLEAR_BHB_LOOP_SEQ just took its inner and outer loop counts
> as register arguments? Then this would look more like:
> 
> 	ALTERNATIVE "mov  $5, %rdi; mov $5, %rsi",
> 		    "mov $12, %rdi; mov $7, %rsi",
> 	...
> 
> 	CLEAR_BHB_LOOP_SEQ

Following this idea, loop count can be set via ALTERNATIVE within
clear_bhb_loop() itself. The outer count %ecx is already set outside the
loops. The only change to the sequence would be to also store inner count
in a register, and reload %eax from it.

---
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 886f86790b44..e4863d6d3217 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
-	movl	$5, %ecx
+
+	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
+	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx;",	\
+		    "movl $12, %ecx; movl $7, %edx;", X86_FEATURE_BHI_CTRL
+
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	%edx, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax

