Return-Path: <kvm+bounces-69118-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YH/7KZBMd2msdwEAu9opvQ
	(envelope-from <kvm+bounces-69118-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:14:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C9D8789B
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1E7003004612
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A479A3321D7;
	Mon, 26 Jan 2026 11:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3PJatvc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C6132E137;
	Mon, 26 Jan 2026 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769426058; cv=none; b=FgipbShdcx4s3iVdCdknKZSYwohnZE7OVKgVDPHIEZh/Z1wqiZR5P8uDw/Y1exBdZZ5cIu5x1OY8U+dnxPDrjmR00ZDAd7NEUHR8dw9kp49Mv6suMJJzoQWvgs6SVHcNBQaatwr+uREuH/m3Qa1GqwxhGnD10krjMbE6o6NgxCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769426058; c=relaxed/simple;
	bh=2KvsABCVidNUiCIvpimircyvbgQJu/c+OPtijk7JUhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzJ7PCLjLEuu6vvpCTUU5JQ6n+uozk/1/P4xgCJqZiqiSElMKbF2RWTgR8ga3OaIqERoDkI/S1j/kYkRzofke8qTY6wKUpP6cMjpS4scEG/yWrI4ILnzlu+Q5EGK0GcuOHp9uDshysWawKIVGAh8qy8XG0IQAnR1ITBMGaXwGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3PJatvc; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769426058; x=1800962058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2KvsABCVidNUiCIvpimircyvbgQJu/c+OPtijk7JUhg=;
  b=N3PJatvchInb5JF7w7isktQ4FyHdUYubmaYt9MBGOc25ieV1dJq4OYGf
   Akq+G7fBIwl+5651J6YhotMSpz9mdu66IhSGG4cUW8YcQpOmkG6qvIQtk
   VobYB5/aH/LG86Yk1ON+kgdtVwKyOi/uxvZLJ5E0GeY2XMKQ8Y7L1x2x9
   mYbCtQA3MKtBoC6Dt77qFMHZBofPWfcyT+D0dAkzB2z0JwlWsWpMNOHbf
   5LczM+igeORsL7hb5X18ew1FTd+KVHpK3jKMxyfJhyI56UsSrFeEaM79a
   afQQZjLwaqp73bNheHlFMii3PMzBipL1rwh6EKw8+kSkhNX6TuTRrL5sq
   Q==;
X-CSE-ConnectionGUID: R2K76vjYSSqZQUNfBDqGdA==
X-CSE-MsgGUID: aCCazxLCRHaMsuh9L7ooKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="69624744"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="69624744"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:14:17 -0800
X-CSE-ConnectionGUID: eEwpCwmhR8Op3adN4iK8UQ==
X-CSE-MsgGUID: uWQg3BXUQiqCgTPx7KKaGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="208083134"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:14:10 -0800
Date: Mon, 26 Jan 2026 13:14:07 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 23/26] x86/virt/tdx: Enable TDX Module runtime updates
Message-ID: <aXdMfzIxF6KR7VCe@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-24-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-24-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69118-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 77C9D8789B
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:31AM -0800, Chao Gao wrote:
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -32,6 +32,9 @@
>  #define TDX_SUCCESS		0ULL
>  #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
>  
> +/* Bit definitions of TDX_FEATURES0 metadata field */
> +#define TDX_FEATURES0_TD_PRESERVING	BIT(1)
> +#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
>  #ifndef __ASSEMBLER__
>  
>  #include <uapi/asm/mce.h>

How about let's put these defines into arch/x86/include/asm/shared/tdx.h
instead? And use BIT_ULL?

This would allow cleaning up arch/x86/kvm/vmx/tdx.c in a follow-up patch
for MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM to use TDX_FEATURES0_TOPOLOGY_ENUM
BIT_ULL(20).

Of course it can be done later on too, so:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

