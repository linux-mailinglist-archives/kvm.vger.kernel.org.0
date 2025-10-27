Return-Path: <kvm+bounces-61226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C290C1190A
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E458404353
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 21:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76CD1328627;
	Mon, 27 Oct 2025 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JVAjvaUW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6EE2BE04B;
	Mon, 27 Oct 2025 21:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761600656; cv=none; b=WkyU0BrrrpHVzSGimBmb7XanOTfXKVS2JMUhD8rCbOLWuaIDCLXOz49uy9XtFmS12XxFik3o7rBDEce8aqFfwH6jGg9iM7zOt5G/4TjcNJdvtNiymCzjlVcvh80B4UaEcl2sCPEUbu1cdDA6OmYRy+ktzmajDIkKabB3I2k+i4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761600656; c=relaxed/simple;
	bh=jf8NFkI4VzrONjOazGzrBo2ODf13jDO81hU78sG3J0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkotW/BIgWbR46+7gwUzkeaTMMkQKUKumFswZS0byZ66Uy1aNm1mdH443zzUOrx2hG+J4UUZNMQWiQgfLJtR6rlrkZPspt6yyyH1oPwG3CwBIbZZ16/b0jEXntZuCkz2yTcvjOnVlySUs2NSLypbS6THNSgzRiuAqj51R0DUKyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JVAjvaUW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761600655; x=1793136655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jf8NFkI4VzrONjOazGzrBo2ODf13jDO81hU78sG3J0Y=;
  b=JVAjvaUW44Ef4CtQ+A2jDTA+7b2gDlaldciYpySR9Qov7vD3+jLaqC4q
   zmaiU1WtvO0Y4uG/x+8L0/kogsF80eV9avcxtkfH38QKFNcddvq/mnXi6
   pR5V2WTxzMFSx7R0A+DN1tCvol7x9NcgTh412rywVxcAzC1e5zT744aqQ
   cQtJJSEw6T/NY3II3Oztri47V2xpUtkeTE2GbeL+wdmE3xfhK3mpYmFzU
   1p6X+jMhvIC7utWtju/0WVp4zzET301SJC/otWO109G4gLj/S9Jf3BjyR
   JrKR5ANXeT7YoOlshd5b5v0LYXNN0J4BVQgduQoHroJO4LU1LwWXmcFRP
   w==;
X-CSE-ConnectionGUID: GvXfeSy1Su+xBM5xlXUVUg==
X-CSE-MsgGUID: 73gfC6+qQhCGGVZertR+4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63786978"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="63786978"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:30:54 -0700
X-CSE-ConnectionGUID: phJ63yVRSj+Vk1hQxZrytA==
X-CSE-MsgGUID: 1hzZZUjLSv+LvrYyqc/reQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="216047010"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:30:54 -0700
Date: Mon, 27 Oct 2025 14:30:45 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v2 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
Message-ID: <20251027213045.m75mrlbfaf46nb2j@desk>
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
 <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com>

On Wed, Oct 15, 2025 at 06:52:11PM -0700, Pawan Gupta wrote:
> IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. But, a guest
> could still poison the branch history.
> 
> To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> the branch history between guest and userspace. Add cmdline option
> 'vmscape=on' that automatically selects the appropriate mitigation based
> on the CPU.

[...]

> diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
> index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..b7b9af1b641385b8283edf2449578ff65e5bd6df 100644
> --- a/arch/x86/include/asm/entry-common.h
> +++ b/arch/x86/include/asm/entry-common.h
> @@ -94,11 +94,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
>  	 */
>  	choose_random_kstack_offset(rdtsc());
>  
> -	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
> -	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
> -	    this_cpu_read(x86_ibpb_exit_to_user)) {
> -		indirect_branch_prediction_barrier();
> -		this_cpu_write(x86_ibpb_exit_to_user, false);
> +	if (unlikely(this_cpu_read(x86_pred_flush_pending))) {
> +		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
> +			indirect_branch_prediction_barrier();
> +		else if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))

I realize that IBPB and BHB clear doesn't have to be mutually exclusive.
IBPB does avoids the need to clear BHB because it flushes the indirect
branches and BHB isn't useful anymore. But, this code doesn't need to
prevent both from being executed. This should be enforced during mitigation
selection. Updating the patch to allow both here.

> +			clear_bhb_long_loop();
> +
> +		this_cpu_write(x86_pred_flush_pending, false);
>  	}
>  }

