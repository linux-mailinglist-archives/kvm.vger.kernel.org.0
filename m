Return-Path: <kvm+bounces-69119-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKcPGPNMd2ngdwEAu9opvQ
	(envelope-from <kvm+bounces-69119-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:16:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C206D878CE
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B95DC300614A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E172F999F;
	Mon, 26 Jan 2026 11:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhFvW4rV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7E62045AD;
	Mon, 26 Jan 2026 11:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769426159; cv=none; b=HGaClg8TjwgZv5Wnq1W1cWCuu/UtnsS7rRi9OImTwUmlcRtbcfiUi5Cs2sE0DPioP+M4VegeW77NY2MF0kNDyp5tsR+jOv+PKQEzIZlDb4r+kqRT7fRIx7nW0HZezy/ASBINTbBE1YyZ59d+383KGpbirqCoNSbz82Vk0dFX9tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769426159; c=relaxed/simple;
	bh=w+vROFuzEgBwPcRTQuuQ9o5RwPtsD43ByelrWXs4jUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3AsYiMA8llFdnT0VRVVWoc4CF0/tg/ExgmXjtjnibE+ihwt3B7jP7oJlbhV9o4wLvsKla0mZY8cf2xPrg5/zrYNA5s9FiKKL/EC39EL41X5O+11d6MJYRJST4nJRsTx+7D84+7oB3oi8f2nnyNVx+4Ri8N1TP2HH/HLM5ROtC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhFvW4rV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769426159; x=1800962159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w+vROFuzEgBwPcRTQuuQ9o5RwPtsD43ByelrWXs4jUA=;
  b=FhFvW4rVS2PMwMJn3luZt5wj/HdRBRW6JQlVO/gI27l4E2wIVu7Ku/Ad
   vnto9nLhv1loLnXIuJjTWQl6ow9nmz7KHOA2vwmPnd+ADUGrEAeswqUGJ
   bOHyi+CWXVh25xVR3LRMRmNWhfw3vf2DKcv+3P6Oa6PkOfxMoJ7rDW7Q5
   RTlRJCwyq+QGwtd3sJNzwDJcpk60wOLfwB+vl7ZJwBcSHu6shbWQ/K1+I
   Af80/crd1ri0eAU41KNwGla3VLRtEV/G0Z+6T3bYeXTdrwuzvAbw5GYrT
   TThVKGSP0Zzhg074BC7RY6whKBc/VyzRtwr3yfbX+PI5UZW6woeVPWmNx
   g==;
X-CSE-ConnectionGUID: NIbnWE5+QkaG/+BTh4RPIg==
X-CSE-MsgGUID: UBhF0LvVTKKvQL2y1c3nUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70568817"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="70568817"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:15:58 -0800
X-CSE-ConnectionGUID: Nr8rf39ARrKORhiYcZFC0w==
X-CSE-MsgGUID: hgPfC5RxSeKczPthrdiEBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="207542029"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:15:50 -0800
Date: Mon, 26 Jan 2026 13:15:47 +0200
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
Subject: Re: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Message-ID: <aXdM411oUrKUYf4n@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-25-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-25-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69119-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: C206D878CE
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:32AM -0800, Chao Gao wrote:
> Currently, each TDX Module has a 4KB sigstruct that is passed to the
> P-SEAMLDR during module updates to authenticate the TDX Module binary.
> 
> Future TDX Module versions will pack additional information into the
> sigstruct, which will exceed the current 4KB size limit.
> 
> To accommodate this, the sigstruct is being extended to support up to
> 16KB. Update seamldr_params and tdx-blob structures to handle the larger
> sigstruct size.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

