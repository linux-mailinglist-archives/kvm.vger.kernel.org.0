Return-Path: <kvm+bounces-69096-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UH+lF6o7d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69096-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:02:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01491865DC
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BF83E3003D07
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F88732FA0D;
	Mon, 26 Jan 2026 10:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yr3y4YyI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAD732ED2D;
	Mon, 26 Jan 2026 10:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421711; cv=none; b=bF5xLbeubR/aUMCuvTO9d+W3izrJCNzFLpI1A6biwJH6XBe18of5chFi3XLZ//qfQLnTAANC7+rtpJYcOaHd3DFL0nkcGfPONrwXY0uvknevY0+aEryFyoK6hd5U1UAq9TsiV36DM2U7UgBdH/mgRSeRYNHZxX8wyMj2JPe8+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421711; c=relaxed/simple;
	bh=bOCd0ZHllasfPj/ztR5bLnC7yLyDKWN+0vftUX4v5RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjDZlV84541vNhDiZwG7KOly8v6AQJWcubg9ndMAdazAVSXjSXBRPj/EatC8bfsd2/yHi6DbArtMpHjaiW+ImZzO79mRkU+0+wpq0J5J1SYjRcrdg/bIs4yH/DOv8DK5SADrElHRncEy5dBTJ031X22pQGPBzDYPcIlCVd92OVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yr3y4YyI; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421711; x=1800957711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bOCd0ZHllasfPj/ztR5bLnC7yLyDKWN+0vftUX4v5RU=;
  b=Yr3y4YyIPPwxy+TXbxqSMzjw8mc4yonxmvfwArVQv+L2uM5Nchjxo3EU
   4cSVwpJL2NAsTwkCF4K39T6tbNnpKwKml/drhRtT0/pUinqw3wlKqu51c
   cHbHGzd6SbZQ8qH8me8aLM5zdl/ynXH5iNnOeNg4FUvzsbWggWE4FHr4U
   KoVMpfkz367Xd5NBjF1LCREpToIQWfldGJW0H0nMh1gEwGueEoYWNcFHc
   D5ZgqpHd+cofzybFMGGGiT2X3LDvtTd71PHmrf7egizkQBqSUuv2vs9UQ
   APA88KajWTc5goFrT3ODy2JLSLuNjFnhXGlYg7ShLRZyXVjcLsrwJT9bV
   A==;
X-CSE-ConnectionGUID: 9GiTSFgNQHmTRGVSKu8SZA==
X-CSE-MsgGUID: RyWKb5abQHmQ8IEPqoWyMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="81706692"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="81706692"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:01:50 -0800
X-CSE-ConnectionGUID: RXkXX/pfSveQb4SpZDVfqw==
X-CSE-MsgGUID: +Z4N4Jq3Qu2mOZ0v2IDneg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="206874940"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:01:40 -0800
Date: Mon, 26 Jan 2026 12:01:37 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 01/26] x86/virt/tdx: Print SEAMCALL leaf numbers in
 decimal
Message-ID: <aXc7gZ__XJ5o0JDz@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-2-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-2-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69096-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 01491865DC
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:09AM -0800, Chao Gao wrote:
> Both TDX spec and kernel defines SEAMCALL leaf numbers as decimal. Printing
> them in hex makes no sense. Correct it.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

