Return-Path: <kvm+bounces-3167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3440C8013E4
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C491C209BE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B79A56468;
	Fri,  1 Dec 2023 20:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJ1WjZYZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A856748;
	Fri,  1 Dec 2023 20:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6952FC433C8;
	Fri,  1 Dec 2023 20:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701461112;
	bh=VZNoAqDPTg8yDoctRcEB3F3opYWUlSBiujMwK2WyTQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJ1WjZYZ+qso1UgSidqe3y+J/eJKvHShQw2R3MIzQEk70r87eQP1DebG3EQAiSLIj
	 IUqhHtHkfHjsuBzdihsJ/ioN6yOXRd3wk9v9HE6RTary1ugjedS5FIL4PVk+6wU/ez
	 g9DPCfWdfABoNpMiyisxXIZsO0px3oHHZYB77AAaBAGg1g+WXNqe/+ZY/8Xs6oj+ud
	 LBLNz8APsX4gnPGHkBG46TW0JkbA7erLdKsm+gCXkSOaxRnSHnSGmTAZx6/Eo8gWe0
	 0lOj7Mfj5wmuVLHJTKpo4wPE5uVmAJClr6yxMBQ67sBDQKBPKWsKgwaxLyKpz+g8rk
	 EBv4asusLbiFg==
Date: Fri, 1 Dec 2023 12:04:42 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
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
Message-ID: <20231201200442.lvyep5uqc6oa7kwj@treble>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-1-9a3622d4bcf7@linux.intel.com>
 <20231201193657.mvzslo4nlcbuv2q4@treble>
 <c61402de-c61e-4d7f-a2b1-3eaa13e4ef33@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c61402de-c61e-4d7f-a2b1-3eaa13e4ef33@citrix.com>

On Fri, Dec 01, 2023 at 07:39:05PM +0000, Andrew Cooper wrote:
> On 01/12/2023 7:36 pm, Josh Poimboeuf wrote:
> > On Fri, Oct 27, 2023 at 07:38:40AM -0700, Pawan Gupta wrote:
> >> +.pushsection .entry.text, "ax"
> >> +
> >> +.align L1_CACHE_BYTES, 0xcc
> >> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> >> +	UNWIND_HINT_UNDEFINED
> >> +	ANNOTATE_NOENDBR
> >> +	.word __KERNEL_DS
> >> +.align L1_CACHE_BYTES, 0xcc
> >> +SYM_CODE_END(mds_verw_sel);
> >> +/* For KVM */
> >> +EXPORT_SYMBOL_GPL(mds_verw_sel);
> >> +
> >> +.popsection
> > This is data, so why is it "CODE" in .entry.text?
> 
> Because KPTI.

Urgh... Pawan please add a comment.

-- 
Josh

