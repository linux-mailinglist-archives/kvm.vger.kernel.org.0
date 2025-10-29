Return-Path: <kvm+bounces-61435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67714C1D92C
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 23:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4623B2C74
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6B531B10F;
	Wed, 29 Oct 2025 22:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gv00wGDL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C196D2F99B8;
	Wed, 29 Oct 2025 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761776005; cv=none; b=SvyKuzrn+03d8S2FpFYxvqJbgY3+fZ2S25nf5973YCEfFlglQ+RVS9Zx86Yy8X3QlCEFEJQfGWlXRlmHTqHLpkgC1ZW323uJmwtvchJ6RWUT0gUr86bbTsLbmFDHIMazXcV+COchi7qx7g8JSBaRO4NFLNcrnnQgyGFb3biWApw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761776005; c=relaxed/simple;
	bh=jsSZeTCPBNkK9Hu5Z3S/rZjdNPkj8Zq1Kblcr1QvrJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EC+gF0QMeH5Vu3QnwVRYMufQ9x6FJZYuaFySQudi9yCjlWx8FlJYKtO5yiWXwPE9OvcFiO/v5XEY9Xc2LiDg5QKyx68fK0wA6e1wB5ADyTS0rj8KttgPRMiHtmNirk3JDkXCjD+W5wXcpcnOKgJ8KBxhoc6sRAH7xINZKFzNrps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gv00wGDL; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761776004; x=1793312004;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jsSZeTCPBNkK9Hu5Z3S/rZjdNPkj8Zq1Kblcr1QvrJs=;
  b=gv00wGDLMl5UP1EyFnqOMJdea03BQSr6UstfQP0bY/3HMOKvdAvwPpxf
   MggDxO9d8VK9+8ngHUQ2PF2//zbRVzcQ8BpIbPvpRp6dAXiNs6tvCbfEH
   kRrO4jUBwT1wFReB4VLhmFI+Up/cUD+XCNKyIq5QWtoA3tWf5ESlZKuzI
   yRO9ehGDMEHxWDAK7AbSug/iUhBcbnzEyBlJBtO9RTIjdxYxQLa1Ar7GQ
   eYntyaE1taT7tbSzWpIBhnn9xuLU8FDk1CyJwEipf0JklRfoHgllC9ztB
   Xpb1B2QcdbzxBRKteuYpU/OxVJDpryP7J4Wu7rDpdtMOV9PEhT2VmUjue
   A==;
X-CSE-ConnectionGUID: ywkw25sISXaIFE3YzAeIeQ==
X-CSE-MsgGUID: hbvItdWnTjyyokuUPUIxag==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="66526599"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="66526599"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 15:13:23 -0700
X-CSE-ConnectionGUID: uHerNb3CQ3qL1i/8dqgszw==
X-CSE-MsgGUID: /vnnliYDR9K6wnAwMrcXyQ==
X-ExtLoop1: 1
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 15:13:22 -0700
Date: Wed, 29 Oct 2025 15:13:16 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 1/3] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251029221316.clb4nadv4uac52es@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>

On Wed, Oct 29, 2025 at 02:26:28PM -0700, Pawan Gupta wrote:
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index bc255d709d8a16ae22b5bc401965d209a89a8692..0dd23beae207795484150698d1674dc4044cc520 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -161,7 +161,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
>  	/* Clobbers EFLAGS.ZF */
> -	CLEAR_CPU_BUFFERS
> +	VM_CLEAR_CPU_BUFFERS
> +.Lskip_clear_cpu_buffers:

Agh, this label belongs to patch 3/3.

>  	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
>  	jnc .Lvmlaunch

