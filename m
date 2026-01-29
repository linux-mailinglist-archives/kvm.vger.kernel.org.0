Return-Path: <kvm+bounces-69503-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJW8DhLRemkq+wEAu9opvQ
	(envelope-from <kvm+bounces-69503-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:16:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9EC9AB60B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 04:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C1223012CAD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E747C352953;
	Thu, 29 Jan 2026 03:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C9eFqQ1X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9416289367;
	Thu, 29 Jan 2026 03:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769656589; cv=none; b=KG344BialWf8Eg2ZgXwcAjXNeGfr787qMPm+S1SeRjMqw+AvLMUuAfnhBwKmS+QFeMjo7jbHKBRb19IqcvQy35HnluuMRxMk7JC11yTDgAYcW6VezF+PNT5RfXoNrr0U2FtRlxO6TQc3isBOUCzUTtZDuE0BljyPy5MsVEo2L0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769656589; c=relaxed/simple;
	bh=5bwTs7I4hxKfdDGhFHtvecCsXQ8GSwTQ6aFb9+vT/1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EffiSb/1fxUOKvbqaFGTF1KGfGmZytcHHg5J/OwleEildptPsF4mKst7OG+p8E9QRKokF3siMo6sFmFFFAW4+tuo2l0ez2snxuHbuujUkT5MXh6AR4dG1IJL7KfBFYXmpF7H1m1foBNvt2dCYwVfOoRRFKNUG47WAP1oNqBrHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C9eFqQ1X; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769656588; x=1801192588;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5bwTs7I4hxKfdDGhFHtvecCsXQ8GSwTQ6aFb9+vT/1I=;
  b=C9eFqQ1XSDC3m2qjpBTJ60MhpEFg79bwT9YSVamtmLssKhZ6Pn6wWHBw
   pdn91flSIVAbWdqBrlAsmUP7wFudqfxlOGZzvDr09NtAjIlcWwCy3dAuo
   46KFek3E/njuc9PCjBlI03qXasAUn/P6uMPwZBAADMToajAoowlufMb4R
   vM8HgSTo4DPP+WYmp2mrRcGLvgSPpYmzMWVRJ/zAWU9C4orGjdBdZUCVo
   GjAL0flj6yuG4hxV/WX2Ypz1H4Y/HjprLzuRi3ZT0npBGZ6QO1BfYjJK6
   OH8+0ALB5P1LhR9Rzq28yhWYstvGSEa27yuOuPFWwe1ECRkc4P3h8P3vk
   A==;
X-CSE-ConnectionGUID: ZmyI8/saS7mnUEuSAD/B2g==
X-CSE-MsgGUID: jpLmE43sSSyfJ+E+iEwuBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="58463608"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="58463608"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 19:16:27 -0800
X-CSE-ConnectionGUID: SOXEZ3DcRCav76sGhjpPMw==
X-CSE-MsgGUID: 5G/insOhTUWPVPUCDsjvGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="212952323"
Received: from unknown (HELO [10.238.3.203]) ([10.238.3.203])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 19:16:25 -0800
Message-ID: <19ecf8b2-6818-4272-b87f-290439355795@intel.com>
Date: Thu, 29 Jan 2026 11:16:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS
 config mismatch
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260128014310.3255561-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69503-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: A9EC9AB60B
X-Rspamd-Action: no action

On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> When kvm-intel.ko refuses to load due to a mismatched VMCS config, print
> all mismatching offsets+values to make it easier to debug goofs during
> development, and it to make it at least feasible to triage failures that
                    ^
typo "it"?

> occur during production.  E.g. if a physical core is flaky or is running
> with the "wrong" microcode patch loaded, then a CPU can get a legitimate
> mismatch even without KVM bugs.
> 
> Print the mismatches as 32-bit values as a compromise between hand coding
> every field (to provide precise information) and printing individual bytes
> (requires more effort to deduce the mismatch bit(s)).  All fields in the
> VMCS config are either 32-bit or 64-bit values, i.e. in many cases,
> printing 32-bit values will be 100% precise, and in the others it's close
> enough, especially when considering that MSR values are split into EDX:EAX
> anyways.
> 
> E.g. on mismatch CET entry/exit controls, KVM will print:
> 
>    kvm_intel: VMCS config on CPU 0 doesn't match reference config:
>      Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
>      Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000
> 
> Opportunistically tweak the wording on the initial error message to say
> "mismatch" instead of "inconsistent", as the VMCS config itself isn't
> inconsistent, and the wording conflates the cross-CPU compatibility check
> with the error_on_inconsistent_vmcs_config knob that treats inconsistent
> VMCS configurations as errors (e.g. if a CPU supports CET entry controls
> but no CET exit controls).
> 
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 93ec1e6181e4..11bb4b933227 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2962,8 +2962,23 @@ int vmx_check_processor_compat(void)
>   	}
>   	if (nested)
>   		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
> +
>   	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config))) {
> -		pr_err("Inconsistent VMCS config on CPU %d\n", cpu);
> +		u32 *gold = (void *)&vmcs_config;
> +		u32 *mine = (void *)&vmcs_conf;
> +		int i;
> +
> +		BUILD_BUG_ON(sizeof(struct vmcs_config) % sizeof(u32));
> +
> +		pr_err("VMCS config on CPU %d doesn't match reference config:", cpu);
> +		for (i = 0; i < sizeof(struct vmcs_config) / sizeof(u32); i++) {
> +			if (gold[i] == mine[i])
> +				continue;
> +
> +			pr_cont("\n  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x",
> +				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
> +		}
> +		pr_cont("\n");
>   		return -EIO;
>   	}
>   	return 0;


