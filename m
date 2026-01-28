Return-Path: <kvm+bounces-69326-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CP0CL6aleWlMyQEAu9opvQ
	(envelope-from <kvm+bounces-69326-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:59:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA599D4B7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86C5F3015456
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 05:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36111318ED9;
	Wed, 28 Jan 2026 05:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZjnP0Vq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C3A2DAFD7;
	Wed, 28 Jan 2026 05:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769579929; cv=none; b=ZOJ+DOKBOAEZkA3qz5QEB0YEoJtipq267d4RAlzic9z7XRZ7LUMCvqPkSY6jPhgil8VHB8Gara5xhEcL0CXqv/yYe013ruDfUuRpf3muhPt4Bm3DXFm6jdjdqF33VxAJbfJckuXXaoA9RCk7jYlfg5hVf+U7LdGNLDjs3UlUAoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769579929; c=relaxed/simple;
	bh=zBb4U0tNNmA+z5EumiDAuX1Xnb3QN8zl4hX05VllGpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzOW1wSy9JK8q6/bNt6ao93PE0FHEEtuTnSJwb/2Vd9BP9y3tHwyZ2HZpR3+mKslcrK+NuGTVSZifEGaPFbtmEjCJUbSQlfbrtgplWx5QqGbjH6lWvJz1hADj1Lyuw0da/9I7/+V95MQHM1c31V9rRHxGVBtUJRfjKKg9zOnMY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZjnP0Vq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769579928; x=1801115928;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zBb4U0tNNmA+z5EumiDAuX1Xnb3QN8zl4hX05VllGpk=;
  b=EZjnP0Vq2Ph0SjJdbAt7sckfiF6tfLvD2ljcMXmHNf7wugyjx6LAb891
   GQ/q2ALtTCO3y/v59WiYr1v2/wJtmzG6tyvW+XwrGDQf/6rqVrAtkYL/N
   zw5tSP/oBXmXwH5jPBmoeU42L2U8tXMMmVyGpd0cnjQHd7P8juvwdjaGq
   b0gcrQWxX+7NNCX10/hCWRNo4D9xaJ1Vp9BRfgpZmMfFSGhK7xMH2Os8R
   iO6ywN17CX4Ab2dFs+EHTJuPiAgpma2Qn6YvkQlPiPCn8CGekh3sgtB1c
   +uI6Q+PrdB2Y2JpotUKdatF+KnwgqaAu4SHlzEoLINWU8rptCDYzU+3l/
   Q==;
X-CSE-ConnectionGUID: 8IbM5IWVTrK5oyujrqm+uA==
X-CSE-MsgGUID: YvcwSGh9RlCD+icRjNagyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81894641"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81894641"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 21:58:47 -0800
X-CSE-ConnectionGUID: 28klSJNHQCWazPMmd1Abdw==
X-CSE-MsgGUID: VcMR7A9YQ+a5WXjVWnSBVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212276513"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 21:58:40 -0800
Message-ID: <988f0c43-3335-4673-b0a3-ef587a1f904d@linux.intel.com>
Date: Wed, 28 Jan 2026 13:58:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-7-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-7-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-69326-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6AA599D4B7
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
> P-SEAMLDR is another component alongside the TDX module within the
> protected SEAM range. P-SEAMLDR can update the TDX module at runtime.
> Software can talk with P-SEAMLDR via SEAMCALLs with the bit 63 of RAX
> (leaf number) set to 1 (a.k.a P-SEAMLDR SEAMCALLs).
> 
> P-SEAMLDR SEAMCALLs differ from SEAMCALLs of the TDX module in terms of
> error codes and the handling of the current VMCS.
> 
> In preparation for adding support for P-SEAMLDR SEAMCALLs, do the two
> following changes to SEAMCALL low-level helpers:
> 
> 1) Tweak sc_retry() to retry on "lack of entropy" errors reported by
>    P-SEAMLDR because it uses a different error code.
> 
> 2) Add seamldr_err() to log error messages on P-SEAMLDR SEAMCALL failures.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

