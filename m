Return-Path: <kvm+bounces-69111-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBsoDKtId2ledwEAu9opvQ
	(envelope-from <kvm+bounces-69111-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:57:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6598762C
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:57:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 64B0B300B9D8
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B91E330B2C;
	Mon, 26 Jan 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZdXD+HLH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58C30E83F;
	Mon, 26 Jan 2026 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424762; cv=none; b=J3ivoIGF+ES3rCF7wsL1DbK8l+M7jIou6bKh/wCzKsVDDjIUDvuGnn3u4rSwyTE10K8fFlzz/aE31PfzcOGdYn1Wtz4lcb8SamI1QLvmKmwxkVyFcdBPtNj1zC2vs+4U++v89+cXWL+IM8LGEpMmc5J53imnjWRengsA66sCE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424762; c=relaxed/simple;
	bh=ijnodV8LAOxWL3In+5gpkwjsBhsNW/OSaWcj40K0cOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGMFiMchhpEW/7Ln+ss97pgBXPaZx2rgV1YfRJb5gFN3urwUAyng9ylL+4gdQKYsTBuIYlWZYNfcK4b6SH8+MRpSqSOdCQjptqX85rdHpExbAvFojEa9ysTjbhN8Aim3bc1H7CFCKDr3H2BSL0dfuCAqks9C7knw/Q/sDmfuPlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZdXD+HLH; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769424760; x=1800960760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ijnodV8LAOxWL3In+5gpkwjsBhsNW/OSaWcj40K0cOc=;
  b=ZdXD+HLH4EjicSYvTs19G6jQSpj5DbvwNEW4tOS81HycQrqiZx2H2a2b
   AgG+0Gj+LnKavqAmB1Yzy2ehJSfCwxSF8Ra066mkZ2pTqePfYd1xSFF36
   qh54c+sFWekVHfOgQaiBU1xLhNQgp1ObxDILBX51WmRkrgJTYaQX6Lfil
   Z9dSts2Coehor2VkFy3Ghw53A+owOFDPo+nsqSrIa44dj2FWgtxHbwlvf
   N6pupsyMV0jfF2O2bbYPVOI9Rh/LAEjqkMj5xqRGmS0MliCBKa4Y2dgge
   EOjvDpX0CruOmOtyvv0CjImY5fr19YSamsgl1K+ydo7ct/rxl5FrSxDSQ
   w==;
X-CSE-ConnectionGUID: zfsOoO0sSi6mNU4UeP7wfg==
X-CSE-MsgGUID: N62yYO2vTcWqy1hl57NSHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="88180350"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="88180350"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:52:39 -0800
X-CSE-ConnectionGUID: fDwZvh8rTRec/6DiFhbHnw==
X-CSE-MsgGUID: pHab7SjIQNyBxcS8GdG/rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="230600695"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:52:32 -0800
Date: Mon, 26 Jan 2026 12:52:29 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 19/26] x86/virt/seamldr: Install a new TDX Module
Message-ID: <aXdHbaVQAqIQyWpA@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-20-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-20-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69111-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 5E6598762C
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:27AM -0800, Chao Gao wrote:
> After shutting down the running TDX module, the next step is to install the
> new TDX Module supplied by userspace.

Maybe clarify the next step part a bit with something like "the next step
in upgrading the TDX module"?

Otherwise the description can  be a bit hard to follow if not seen in the
patch email thread context.

Other than that:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

