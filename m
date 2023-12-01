Return-Path: <kvm+bounces-3161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47864801399
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0305D2811F8
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 19:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD3451C21;
	Fri,  1 Dec 2023 19:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjxDnlKv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58564A9A6;
	Fri,  1 Dec 2023 19:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483F9C433C9;
	Fri,  1 Dec 2023 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701459468;
	bh=KdVQmlMNK9VXP9HFIu2QT1p2mdpD1OBOQPPhAz2pg08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JjxDnlKvyDQpbAfh092/uwT5swfIUKguaSbKYeBy4d0GaR7Uk+qzliJlFl6Uvcyb6
	 +wYbjoLol29F9Y0kPWPuLg96ugn+JPoP5vWwCKDD5d4cFb9F3Wf/QyDOTrpXWTUHon
	 KSS9c28X3t2GEApXRs2hWu2gxOClE9+1zWdCoFZIAi+irbqDG1J3cI4Npay6FkxsI2
	 hW8hCKDYZJI7INF8VoVWCHZC4fnitrSdBXNBJ/Ot+Iq92FY/ZWZs1cEVw1SEzujK3J
	 iOi7/r2EwPADi4tMKzmw38/SVNCPZw0smjnvBIAfoGe826M373VnC94tQ0i2NsmraA
	 ++A/5J3ovt5/Q==
Date: Fri, 1 Dec 2023 11:36:57 -0800
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v4 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231201193657.mvzslo4nlcbuv2q4@treble>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-1-9a3622d4bcf7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-1-9a3622d4bcf7@linux.intel.com>

On Fri, Oct 27, 2023 at 07:38:40AM -0700, Pawan Gupta wrote:
> +.pushsection .entry.text, "ax"
> +
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> +	UNWIND_HINT_UNDEFINED
> +	ANNOTATE_NOENDBR
> +	.word __KERNEL_DS
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_END(mds_verw_sel);
> +/* For KVM */
> +EXPORT_SYMBOL_GPL(mds_verw_sel);
> +
> +.popsection

This is data, so why is it "CODE" in .entry.text?

-- 
Josh

