Return-Path: <kvm+bounces-3165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6CE98013D1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DD90B212CC
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276E752F83;
	Fri,  1 Dec 2023 20:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNPWC/g0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC55A20B05;
	Fri,  1 Dec 2023 20:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5042AC433C8;
	Fri,  1 Dec 2023 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701460856;
	bh=IT7yyK2lIBKnfcOQs1byPql0uqwNmalDnLqIwsW1VZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fNPWC/g0a2x2cmuUHv1mcctnA+KRhgd9p3y7l11tr/iMr9fHvbQmGdDAPGs/jBW3e
	 530pOyTqaWrhQf8yGhGd4F42a+0XOxsg5GcCntPFajZbuaumj792bydrBtBr8nepZE
	 vasZlw/KSLZs2v7F2Co9V/rhqlGoCLT1ixGg30992DzMr4WAaUWoXWfX1DPvC9900h
	 ds+5HasFsw0cILwlbw0SOvFzuFPCHPzAhhqJzdZaDgZmkyLzdvOfUYVeeZI5AZQ5qo
	 2CZRh1FWiqD0QgXUYu6yjSeF9hePz4ANF0XrwvzDmWpKdbjcU73s7Tl0xJikEijj6Q
	 x63GZHSbidejw==
Date: Fri, 1 Dec 2023 11:59:54 -0800
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH  v4 4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <20231201195954.sr3nhvectmtkc47q@treble>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-4-9a3622d4bcf7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-4-9a3622d4bcf7@linux.intel.com>

On Fri, Oct 27, 2023 at 07:38:59AM -0700, Pawan Gupta wrote:
> The VERW mitigation at exit-to-user is enabled via a static branch
> mds_user_clear. This static branch is never toggled after boot, and can
> be safely replaced with an ALTERNATIVE() which is convenient to use in
> asm.
> 
> Switch to ALTERNATIVE() to use the VERW mitigation late in exit-to-user
> path. Also remove the now redundant VERW in exc_nmi() and
> arch_exit_to_user_mode().
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  Documentation/arch/x86/mds.rst       | 38 +++++++++++++++++++++++++-----------
>  arch/x86/include/asm/entry-common.h  |  1 -
>  arch/x86/include/asm/nospec-branch.h | 12 ------------
>  arch/x86/kernel/cpu/bugs.c           | 15 ++++++--------
>  arch/x86/kernel/nmi.c                |  2 --
>  arch/x86/kvm/vmx/vmx.c               |  2 +-
>  6 files changed, 34 insertions(+), 36 deletions(-)
> 
> diff --git a/Documentation/arch/x86/mds.rst b/Documentation/arch/x86/mds.rst
> index e73fdff62c0a..a5c5091b9ccd 100644
> --- a/Documentation/arch/x86/mds.rst
> +++ b/Documentation/arch/x86/mds.rst
> @@ -95,6 +95,9 @@ The kernel provides a function to invoke the buffer clearing:
>  
>      mds_clear_cpu_buffers()
>  
> +Also macro CLEAR_CPU_BUFFERS is meant to be used in ASM late in exit-to-user
> +path. This macro works for cases where GPRs can't be clobbered.

What does this last sentence mean?  Is it trying to say that the macro
doesn't clobber registers (other than ZF)?

-- 
Josh

