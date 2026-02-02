Return-Path: <kvm+bounces-69789-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KmgFqn0f2ks0wIAu9opvQ
	(envelope-from <kvm+bounces-69789-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 01:49:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF63C7A74
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 01:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 143CD3000528
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 00:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8811D130E;
	Mon,  2 Feb 2026 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GiAotrbG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D60C3EBF37;
	Mon,  2 Feb 2026 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769993371; cv=none; b=hYogpQXnqa3+r00c7Fg1eHzksKz3qf4UDrDHit6Dj0GrKyJJtjUMkQXgDPoGfF01mz0VNgWcfRyANsHgmMKzaAvaCk/43oGO3PJdvEgRciAq7n6+CCqGP+YWvUt70rx1645Qesh+O1hr9jxMT+LBdLznKb8N/ivTWDwqkJsHKxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769993371; c=relaxed/simple;
	bh=JhC6LNziwCFg66YLFP/4Ogb08Rc5d3eEth2dQQMxPjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKosy1983YAxSzIXDuep8WvzNsvoasORuoYb61GAsPgfq6RY5lRjuvEHikXAnbGcxj8kiVc3EZ9f7rVCEbMUOeeZc3tMXoqv9sRWQw8Jcga2cUpP4EziWJ9nyxC3SU/ZVBjO5ahcdRzgEcfK1AXRkVrupQI9GooXLXLz5v8OkY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GiAotrbG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769993370; x=1801529370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JhC6LNziwCFg66YLFP/4Ogb08Rc5d3eEth2dQQMxPjI=;
  b=GiAotrbGjkEQlEnObDfUiR7SlEN5dw+QJQtHnDel97HF0i9b1h4fyoON
   E4rIFVrASOw++vsgbFKY213mxE4bMhemuOclPFTqCBQLG4MWCv5F3yzi4
   Emo3JAhox4omR67DpmERGRlvVv97Glc91VWIqfWvxU/Ti6PV2qoU7Ce70
   sdLCpF298EVJ2zOye+WxSsVZk8hOCMptjn+eFKw/nGYauICPQJiJQ6xqh
   LIt8NRBqSCwJDI94NyRfjMlUNH3ej0COTKjZOGIRzzeOrZs+Wm+nqMqP3
   Un9OmVqlDzVj2/R99wv4RzRfeVcfFld7c6q3E+Nhj5gsGRJmiShAttvwZ
   w==;
X-CSE-ConnectionGUID: cBrK1TYoQDiQlKiDr6E5kw==
X-CSE-MsgGUID: JDMV47YDSRm0eWcUZ1kZCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81468211"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="81468211"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 16:49:30 -0800
X-CSE-ConnectionGUID: W8r68uMDTxC0oT70NcUwQg==
X-CSE-MsgGUID: uz/TrB9qSOmgShff/13+YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="246982169"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 01 Feb 2026 16:49:25 -0800
Date: Mon, 2 Feb 2026 08:31:01 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 11/26] x86/virt/seamldr: Block TDX Module updates if
 any CPU is offline
Message-ID: <aX/wRfzxTNj8Au/V@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-12-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-12-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69789-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: BAF63C7A74
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:19AM -0800, Chao Gao wrote:
> P-SEAMLDR requires every CPU to call the SEAMLDR.INSTALL SEAMCALL during
> updates.  So, every CPU should be online.
> 
> Check if all CPUs are online and abort the update if any CPU is offline at
> the very beginning. Without this check, P-SEAMLDR will report failure at a
> later phase where the old TDX module is gone and TDs have to be killed.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

