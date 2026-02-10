Return-Path: <kvm+bounces-70702-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEHrBgnRimluOAAAu9opvQ
	(envelope-from <kvm+bounces-70702-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:32:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB90117614
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 948973034E0F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 06:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6287921CFF6;
	Tue, 10 Feb 2026 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LEdZBmDt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B032D0FA
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770705116; cv=none; b=GPXFoLhJgtWgmw/jKhX+Y9EM0447xUYq7x9MZ7bfbYVcQcFDGc2WFUcpSd3UWZ7zMaG+okJrOSfvOZ1xS6JnwdnKFEHwr2vTBtFT0ETAWybQqyyTwGQOr01LSIami+j9zCxpgbOePUZf1DXIDLYe1HrdwwVVBfqXtikZ5abl4h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770705116; c=relaxed/simple;
	bh=Zdx+/cvtrP/lsP9PDOItO6z4pH8kkzotkx+YEp9BAc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPIswKv7hdtTwobBNBicbhmKnBYghsIkunfVyC6XAfTc79RmiLwKlqKTRTkWuoWwJeY9XZhsz1eKwo6Zuc3OtrRa5FxQKDD5wngmHOH2Kzh49+vHFUZoNehQqoUPwulgrygPwRCzIISr3wuFH0/P2j1CG9xawICt1a5Eyw4GXg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LEdZBmDt; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770705116; x=1802241116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zdx+/cvtrP/lsP9PDOItO6z4pH8kkzotkx+YEp9BAc8=;
  b=LEdZBmDt7rSn8A71ncXhSRJTkvMs8YRFQDcCmDhSuDtyIuEHpcXAq+Fk
   Nq3jco5KH+5PTNg7Ozp5hnOP/GTRFqwh/5lj8YaKGdV0Y9csqlkU5Jx8I
   hEmbgrEvdGm3XgNiG5tJi5AsHoow5lSsviFdOLnUVOYvLIW827lh2gZtF
   5zYiH1ESJJIaRsIHzofxLJpbZ0db9tMsXadf1eHDrTJZFO8WYDib5oVuP
   v9Y21B8s97hUKLoaYbT9rEE5ugnfrZStfB1eIdg8ttmavIEhAVwOHm3FW
   bK75tJPwCIQx36BfRxZ//YdCBt9YaGwxohiDy8/ZDklCeNeq4w3jDVeb1
   w==;
X-CSE-ConnectionGUID: XtDe9YkNSxuJjnDdYwRukw==
X-CSE-MsgGUID: d8n1TJMTRgqygUgePpb/FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71036204"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71036204"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 22:31:55 -0800
X-CSE-ConnectionGUID: WNZHrJrqQqq8+Hi7D3vshg==
X-CSE-MsgGUID: nn3Rj5dJR2iZSURgDcGRng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211031516"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 22:31:53 -0800
Message-ID: <e255735f-cadf-4611-8811-1444436d777a@linux.intel.com>
Date: Tue, 10 Feb 2026 14:31:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/11] target/i386: Disable unsupported BTS for guest
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-2-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260128231003.268981-2-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70702-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 8FB90117614
X-Rspamd-Action: no action


On 1/29/2026 7:09 AM, Zide Chen wrote:
> BTS (Branch Trace Store), enumerated by IA32_MISC_ENABLE.BTS_UNAVAILABLE
> (bit 11), is deprecated and has been superseded by LBR and Intel PT.
>
> KVM yields control of the above mentioned bit to userspace since KVM
> commit 9fc222967a39 ("KVM: x86: Give host userspace full control of
> MSR_IA32_MISC_ENABLES").
>
> However, QEMU does not set this bit, which allows guests to write the
> BTS and BTINT bits in IA32_DEBUGCTL.  Since KVM doesn't support BTS,
> this may lead to unexpected MSR access errors.
>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V2:
> - Address Dapeng's comments.
> - Remove mention of VMState version_id from the commit message.
>
>  target/i386/cpu.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2bbc977d9088..f02812bfd19f 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -474,8 +474,11 @@ typedef enum X86Seg {
>  
>  #define MSR_IA32_MISC_ENABLE            0x1a0
>  /* Indicates good rep/movs microcode on some processors: */
> -#define MSR_IA32_MISC_ENABLE_DEFAULT    1
> +#define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
> +#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
>  #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
> +#define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     |\
> +                                         MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>  
>  #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
>  #define MSR_MTRRphysMask(reg)           (0x200 + 2 * (reg) + 1)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



