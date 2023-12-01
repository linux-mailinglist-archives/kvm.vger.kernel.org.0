Return-Path: <kvm+bounces-3166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6EE8013DF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33B03281CFD
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 754AA54BED;
	Fri,  1 Dec 2023 20:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBUFM1U3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760DD54BD7;
	Fri,  1 Dec 2023 20:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE5EC433C7;
	Fri,  1 Dec 2023 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701460995;
	bh=zlGJvgaDfOaydmVhAssBO1Q2xtvGzqBX82vPMeow6H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kBUFM1U32mC5a5kuNSctBT/Fei8oX4ETaFZtXddMPB++K5JXpgPLe/pJmjPb6seMc
	 LLxZ7zrTSEOFyYMDddaolGtJTT6BWMxR8MEtaIjW89DIZ/nl7F4kWfcABWasD/X6Uu
	 RwJXWG5HphFmZXVTwMZQMLnJswrQI4jFBKkbwH64zOgUU1b/R/sUdgRDfwIglc3A1u
	 /asI/HVmSEXQPIO0P7T8f2aCUej/5vQRM2qitHnCTk9KdHn8NE4aRHQwt61i1qdIfa
	 GPVQzyWlFAWE83+BsHHiaWNaDYjK0qFsGyJMuztArG9nvN2VTEp4A9TFcgKPDCBU/A
	 K6w/DEyCt32og==
Date: Fri, 1 Dec 2023 12:02:47 -0800
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
Subject: Re: [PATCH  v4 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231201200247.vui6enzdj5nzctf4@treble>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027-delay-verw-v4-6-9a3622d4bcf7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-6-9a3622d4bcf7@linux.intel.com>

On Fri, Oct 27, 2023 at 07:39:12AM -0700, Pawan Gupta wrote:
> -	vmx_disable_fb_clear(vmx);
> +	/*
> +	 * Optimize the latency of VERW in guests for MMIO mitigation. Skip
> +	 * the optimization when MDS mitigation(later in asm) is enabled.
> +	 */
> +	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> +		vmx_disable_fb_clear(vmx);
>  
>  	if (vcpu->arch.cr2 != native_read_cr2())
>  		native_write_cr2(vcpu->arch.cr2);
> @@ -7248,7 +7256,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  
>  	vmx->idt_vectoring_info = 0;
>  
> -	vmx_enable_fb_clear(vmx);
> +	if (!cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> +		vmx_enable_fb_clear(vmx);
>  

It may be cleaner to instead check X86_FEATURE_CLEAR_CPU_BUF when
setting vmx->disable_fb_clear in the first place, in
vmx_update_fb_clear_dis().

-- 
Josh

