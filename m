Return-Path: <kvm+bounces-69056-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJiENH/FdWksIgEAu9opvQ
	(envelope-from <kvm+bounces-69056-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:25:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F157FFA0
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B7EB30086FF
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 07:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BEF2D781B;
	Sun, 25 Jan 2026 07:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MI9qfpfR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86673EBF02;
	Sun, 25 Jan 2026 07:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769325936; cv=none; b=DKVw03cKUaq3BsfkRb99Yj03ZklSy769YvMO7XvRZwS0HeGZbCqnH/a2T41gOH6oYzibdwn1c865hsS2rTubHXmOf5qrK0mabION4FYXNd4kMNQL+6KnzzTGstD6h0Idn4R/2f4Ga/CROv00fBqwD6gMbm7gp4zAG9ptOEvy+Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769325936; c=relaxed/simple;
	bh=UeqZaPacbBiLN6/QCJWKI3nT4CbD1MdBgoyPgiithzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br8TgaRjTLKeDh/BJLsBv00DB86tfFp3TRFB6huV4a5E/lYlga1QFIeZY7QXut/xOiYjrQkgdTXCtETjXm2Yf8+8fBNAHKSziB285Y4o/QdRJXMDSQ3uiWSDBlSYJ2ZOsFTntVExn9bUFzv0AqWPtkIvLtKuo9A9vi8wewTB2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MI9qfpfR; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769325934; x=1800861934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UeqZaPacbBiLN6/QCJWKI3nT4CbD1MdBgoyPgiithzE=;
  b=MI9qfpfRWgzHHSlzKagWyk87BH0ANFBfh6fPOPwSS2QjCSuFXVrsrKRJ
   YRB9uLDM7/bovOus1gZ/jKNo9Zq1dl25ZOLEFAD794LKncCjz6pOz0Tk3
   n/XD1QJBazRGyQAOaHvywInwgnQPoSbKGn9+ws4kcCIH7p5I/PNL4rM1w
   6nRXbdsbUqQTXYpwrZASMhQZnP3yMMTmxMMFV8SYDeTnY7uPRpFEY/Xtd
   w8J/BDnIlzuNFGD7brPve6Eh4Tx8+dXGNhuPrbGB5+4vmIIm+QoLVETkf
   2oMpgIQAd82jtf0fsqc/E2CevjultIApxRqvaxlRInkvhPvDBxPWN4cPw
   Q==;
X-CSE-ConnectionGUID: cGKk0/wLRBCDbO4tE1hNTg==
X-CSE-MsgGUID: RgpV11TIQFCXvt8at+IqGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="70497334"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="70497334"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 23:25:34 -0800
X-CSE-ConnectionGUID: FfAeQEwsQ66HYg1q/+rMrg==
X-CSE-MsgGUID: U6xvTIYWQ6uFsgXZimpItQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="211905597"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 24 Jan 2026 23:25:30 -0800
Date: Sun, 25 Jan 2026 15:51:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1
 to userspace
Message-ID: <aXXLZ9nCzTmeaSS0@intel.com>
References: <20251120050720.931449-1-zhao1.liu@intel.com>
 <20251120050720.931449-3-zhao1.liu@intel.com>
 <aXO1_kmDSu_H1BoL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXO1_kmDSu_H1BoL@google.com>
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
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69056-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhao1.liu@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 78F157FFA0
X-Rspamd-Action: no action

> Unless someone feels *very* strongly about the "mirror" terminology, I'm going to
> use ALIAS instead of MIRROR when applying, to match KVM's existing terminology for
> the 8000_0001.EDX => 1.EDX aliases.
> 
> /*
>  * Intel-defined sub-features, CPUID level 0x0000001E:1 (EAX).  Note, several
>  * of the bits are aliases to features of the same name that are enumerated via
>  * various CPUID.0x7 sub-leafs.
>  */
> #define X86_FEATURE_AMX_INT8_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 0)
> #define X86_FEATURE_AMX_BF16_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 1)
> #define X86_FEATURE_AMX_COMPLEX_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 2)
> #define X86_FEATURE_AMX_FP16_ALIAS	KVM_X86_FEATURE(CPUID_1E_1_EAX, 3)

LGTM, yes, ALIAS sounds better than MIRROR.

Thanks,
Zhao



