Return-Path: <kvm+bounces-68684-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AN8TCOmJcGkEYQAAu9opvQ
	(envelope-from <kvm+bounces-68684-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:10:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A60B053449
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:10:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 870FC7C31F3
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 08:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61165378D95;
	Wed, 21 Jan 2026 08:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jVbpAcY0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1788D31D72B;
	Wed, 21 Jan 2026 08:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768982734; cv=none; b=H2ikQiFPcabom/t4A6P2tDbvHk2Ml7c/35xmtV0DUgf5OfQGZ+iZiN6FYNBcvknfBSeeLHMtSXGAb8+juMypbH0t992psovr0wi/EYDULUFsTLrpHqwdGcfAZd0W0kqoIotMlnTbIn+90n/EewYMhQd35wo5KelDm8rkxboeatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768982734; c=relaxed/simple;
	bh=DhXKa/LMmAdSo9DaM1cqM29GrLsrtd9UzaAIy3S7jj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFuRnhpOKKZUMV0zfMBNvskrJn3LQr0S5fhiN44+1kaLdo2TqZS1OgUKRFcw1vloJMjyvtAhAv+kVPDtwnKiaVeAwsyGO15hiEJFM46r0s0GAf+HfbKu90mjd4S9mkvheftnxmrGh1TlWW+sIM/TWk387OwsVGqd8A89sx/6ZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jVbpAcY0; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768982730; x=1800518730;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DhXKa/LMmAdSo9DaM1cqM29GrLsrtd9UzaAIy3S7jj0=;
  b=jVbpAcY00u8e4K8+6s/EA0OGR/J40LwE3eUWWxsRUG0LxikCA4lax3ZL
   uoDSvjRQMoVKx8GvFD+zr793fGZzDpRGGxAYuqWI9UFmDHsoZEcxmTFiz
   tCZQIpKJaw1rIktJfzbIkSGJa/GCcKlhANyKw5/XV2sJSRZZMInd8HgkS
   GzYUNtV+ulWBm41re7ESBeTYSfzKBqaqiX3Kx4cJkDhkoKSWU+BzRnmjn
   9U/pYdU5ogw0RUC74NEZw6vP6sDBpkvxPHJik31iPS2+b3lusZcizNlna
   7VsKtrkwSlNM293P0bTrk0rrgVhzVdQddFdHxU2J9jsek9MoOlFseTidg
   w==;
X-CSE-ConnectionGUID: d2orIwqbSyOVJ4bY9sLk7A==
X-CSE-MsgGUID: A1FgYVklS6mlMkZf2j3x0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81584675"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81584675"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 00:05:20 -0800
X-CSE-ConnectionGUID: tS5VIxpfS/CNojwk4hEkxw==
X-CSE-MsgGUID: 7peeTE5RQt6BdvZyfYjhRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206619382"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 00:05:16 -0800
Message-ID: <9a628729-1b4f-4982-a3e6-b9269c91b3c2@linux.intel.com>
Date: Wed, 21 Jan 2026 16:05:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/22] KVM: x86: Add a helper to detect if FRED is
 enabled for a vCPU
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-12-xin@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251026201911.505204-12-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68684-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:email,intel.com:email,intel.com:dkim,linux.intel.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: A60B053449
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 

Not sure if it's OK with empty change log even though the patch is simple and
the title has already described it.

> Signed-off-by: Xin Li <xin3.li@intel.com>
> [ Sean: removed the "kvm_" prefix from the function name ]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
> 
> Change in v5:
> * Add TB from Xuelian Guo.
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 8ddb01191d6f..3c8dbb77d7d4 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -205,6 +205,21 @@ static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
>  	return !!kvm_read_cr4_bits(vcpu, cr4_bit);
>  }
>  
> +/*
> + * It's enough to check just CR4.FRED (X86_CR4_FRED) to tell if
> + * a vCPU is running with FRED enabled, because:
> + * 1) CR4.FRED can be set to 1 only _after_ IA32_EFER.LMA = 1.
> + * 2) To leave IA-32e mode, CR4.FRED must be cleared first.
> + */
> +static inline bool is_fred_enabled(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_X86_64
> +	return kvm_is_cr4_bit_set(vcpu, X86_CR4_FRED);
> +#else
> +	return false;
> +#endif
> +}
> +
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))


