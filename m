Return-Path: <kvm+bounces-7788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0271846688
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F91E1C26BA7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 03:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5041CEAEF;
	Fri,  2 Feb 2024 03:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7lP3i+S"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73320DF5D;
	Fri,  2 Feb 2024 03:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706844552; cv=none; b=jkKZkXg29zPdph6Dx8v/sC/xYAQ8Sm5Ddud/tf8C3EaajZMgIElUE8V6DyfR5ZrKcw+nofSefGzRcRxZYf2tHkupVBFGshwIfmgKAuyAtrY+Tt6TXeVt+S/fDcNgwlyVByEZfv+3kjQFMb4OnDGoL+ayP4pUuMASL48GrG0Y+O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706844552; c=relaxed/simple;
	bh=hrszDQjg1r99rOZvRO+CbHKbrtAj33R5nUJ/aP8OlAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xe40JYJirtlWmH7LvWLH0XWD81VhkNT2V3UUeU8iM4P0F9nKqwCCZkADQr71nLJqugsyvHIixHBqMZfT9o01tQ/zz127tQrSRtUeZSZRlaaUKoqgx+1wqPJtivESGgB8VQNCK2GeftiPSb8sgTjp19ROuAbk7+cL5sfyCTlqCx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7lP3i+S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E11C433C7;
	Fri,  2 Feb 2024 03:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706844551;
	bh=hrszDQjg1r99rOZvRO+CbHKbrtAj33R5nUJ/aP8OlAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7lP3i+S1HK19Szbki1gpNcjT56ZAc3eU1c3GK3xyLzWt5U7eFMUedktdxBnEFo35
	 qrCEVhbm5rO0QS38JimDBYic0HvMzS+XnXrMQuGfrWWFSeV/w2Zw7o3um3rCxDLmYx
	 EhrFnvUlOuHn79KhfqxaS3Y/dRsC36NFEkihtW+LBME0hvO/5N+3LpUIP1720keN6Q
	 EAwb+x8qyAef49fQ5fZWb67Bv6l+vEmJ+tjeDW+RPBBnCuOWcRHvp28cPkoG4MjuGs
	 +a/JN/1x9h8wY0IdiardxibIeTrtfu1FUJhfTiKsihgyiX7cBMIYxNI6uHSoKhy/UW
	 9hi/sHprptC8Q==
Date: Thu, 1 Feb 2024 19:29:09 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
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
	Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v6 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240202032909.exegdxpgyndlkn2n@treble>
References: <20240123-delay-verw-v6-0-a8206baca7d3@linux.intel.com>
 <20240123-delay-verw-v6-1-a8206baca7d3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240123-delay-verw-v6-1-a8206baca7d3@linux.intel.com>

On Tue, Jan 23, 2024 at 11:41:01PM -0800, Pawan Gupta wrote:
> index 4af140cf5719..79a7e81b9458 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -308,10 +308,10 @@
>  #define X86_FEATURE_SMBA		(11*32+21) /* "" Slow Memory Bandwidth Allocation */
>  #define X86_FEATURE_BMEC		(11*32+22) /* "" Bandwidth Monitoring Event Configuration */
>  #define X86_FEATURE_USER_SHSTK		(11*32+23) /* Shadow stack support for user mode applications */
> -
>  #define X86_FEATURE_SRSO		(11*32+24) /* "" AMD BTB untrain RETs */
>  #define X86_FEATURE_SRSO_ALIAS		(11*32+25) /* "" AMD BTB untrain RETs through aliasing */
>  #define X86_FEATURE_IBPB_ON_VMEXIT	(11*32+26) /* "" Issue an IBPB only on VMEXIT */
> +#define X86_FEATURE_CLEAR_CPU_BUF	(11*32+27) /* "" Clear CPU buffers using VERW */

This will need to be rebased.  And the "11*32" level is now full in
Linus' tree, so this will presumably need to go to a different "level".

-- 
Josh

