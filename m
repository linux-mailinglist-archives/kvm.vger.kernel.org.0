Return-Path: <kvm+bounces-70826-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HEWL2YejGn2hAAAu9opvQ
	(envelope-from <kvm+bounces-70826-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:15:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22EE812192B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 07:15:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 67BA33012CBA
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 06:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A3234C9AD;
	Wed, 11 Feb 2026 06:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3HC6cMA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D070130F924
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 06:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770790494; cv=none; b=BiXRgrqyhMjtkCyuIFpt2EZC8rv5bdvTgSdGFOmUuO6Iev5YP9uiPd789alm9l2QF7YF/7UNYvmEjlzE5hNCrg4zrOvIE2kHmpKXsNamJnukfE8md8+rkFEhUMIKQLwrVn6FppJTqVuM6vBVl7r4A1cGqQnfnRsD1oRbLjMvrWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770790494; c=relaxed/simple;
	bh=rP5llVY+IJ2BiSdns8crbNzy366rp4QhMGd+dzV2WHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rGCtSod4CbTZCmJljzrbfTCLVvdExZgoLfNv3zwwEX6uQOW+hLnhvP4kzFwkuZyvUq4D6UawAKDKUESxPX6fLaaaQAmi0JBrIEcoP1/ueUDaGHEo/aoaLz66tNvYPZtYhxu4iI1aiMUB1t/oP0yr4/rF65PVHBVaB+NSHUI4xm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3HC6cMA; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770790493; x=1802326493;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rP5llVY+IJ2BiSdns8crbNzy366rp4QhMGd+dzV2WHQ=;
  b=a3HC6cMAabnYqWT53fG+zGd5ugbfZ2TkCsJr1ovOln9rZ3qT0fl25DOS
   ZF1K2ZyjI9pb7ZEZG+5+vKOTzNDjTx1pztDgDurdmOrQx3u0SnwJmR9cF
   RxK/PxGqjxXYJN7xXi7QXpPTtonS+GABKU2aUsp8ze6rR9CgYe+LdrcYa
   zRzSJw8i6gNTggbLVnXhvCyX4F/wsoWtZooXmRb2qnsLB8vBD63nHjRIZ
   QWU74kpPfoFm0PmgeBobpAINcLwy2yNMwPdJ5TlYgnFuZGHaaOMbY/cf9
   ZeUFEI3qghqtcCq3S9Zfba0tYr/zjpNO++syB8m8SEARVnquYUYhg0pPT
   Q==;
X-CSE-ConnectionGUID: MLiHCcs4RYq+ZT/WHpma1A==
X-CSE-MsgGUID: /WZDJ1vqQAqP97uYYppBhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="97387989"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="97387989"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 22:14:52 -0800
X-CSE-ConnectionGUID: 4GJdpKNRRdS4hQ6jszuq4g==
X-CSE-MsgGUID: hN7ZDFQGQtuhhY1HequhuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="249784774"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 22:14:50 -0800
Message-ID: <7803017e-aefa-421a-92a1-3b5820beba53@intel.com>
Date: Wed, 11 Feb 2026 14:14:46 +0800
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
Cc: Dongli Zhang <dongli.zhang@oracle.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-2-zide.chen@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260128231003.268981-2-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70826-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 22EE812192B
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

Since the patch is handling BTS,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


Besides, I'm curious about the (legacy) PEBS enable.

Before KVM commit 9fc222967a39, BTS_UNAVAIL and PEBS_UNAVAIL in 
MISC_ENABLES are maintained by KVM and userspace cannot change them. KVM 
keeps MISC_ENABLES.PEBS_UNAVAIL set when

   !(vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT)

After KVM commit 9fc222967a39, it's userspace's responsibility to set 
correct value for MSR_IA32_MISC_EANBLES. So, if PEBS is not exposed to 
guest, QEMU should set MISC_ENABLE_PEBS_UNAVAIL. But I don't see such 
logic in QEMU. (Maybe the later patch in this series will handle it, let 
me keep reading.)

> ---
> V2:
> - Address Dapeng's comments.
> - Remove mention of VMState version_id from the commit message.
> 
>   target/i386/cpu.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2bbc977d9088..f02812bfd19f 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -474,8 +474,11 @@ typedef enum X86Seg {
>   
>   #define MSR_IA32_MISC_ENABLE            0x1a0
>   /* Indicates good rep/movs microcode on some processors: */
> -#define MSR_IA32_MISC_ENABLE_DEFAULT    1
> +#define MSR_IA32_MISC_ENABLE_FASTSTRING    (1ULL << 0)
> +#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL   (1ULL << 11)
>   #define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
> +#define MSR_IA32_MISC_ENABLE_DEFAULT    (MSR_IA32_MISC_ENABLE_FASTSTRING     |\

Nit, we usually add a space before "\"

> +                                         MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>   
>   #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
>   #define MSR_MTRRphysMask(reg)           (0x200 + 2 * (reg) + 1)


