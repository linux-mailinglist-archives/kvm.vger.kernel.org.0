Return-Path: <kvm+bounces-69097-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KP/4Frw8d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69097-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:06:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E7186698
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 337AE301AA6A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D75932E729;
	Mon, 26 Jan 2026 10:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ayYCFTCG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2960313550;
	Mon, 26 Jan 2026 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421742; cv=none; b=tsrkeLZJLCWq6liLe+N1sMG7p6ww8laAmO9TOPGxv7g5Vi4n9LnVuIGQo6ALPWyn2nm7UjMZfINQNNxvHWJRtzYXbo7xBPx0Y4goEQJnKFGzd0o4lUz6elssMWGpYnwHMt0KH8MNATlSotQF5CL3LxwGHLPu5wtgO86Cn2ztErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421742; c=relaxed/simple;
	bh=wCnUpBD6UHOquyVRWIUEon70kOrWeqJRLV7w/fMtX3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji6kFAW1MNKahO6UBOxy5LRlovTBVFlpGJ2CtkTsYS50o7+quCg9t67N42Q/zbnJ3pZu9I0N2lEJNM+89s+4TVGEwq/fybq/TV9xM5NRR/iVB3h1gaxEwlU85nqMyVC0rGSsuIKZfhuKg3MeO84ZDmSbhwBCNI3ag+XuNC8//9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ayYCFTCG; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421742; x=1800957742;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wCnUpBD6UHOquyVRWIUEon70kOrWeqJRLV7w/fMtX3Q=;
  b=ayYCFTCGTs3YdKBh6GmsYqiyiN6WPLrbAbuZGoT4N7e8qsbKLHbeI9+p
   r5QYxyIZfhHXF9JaAaT2Z0gpzYYFA6fSfb0+nPMzIkmgjswJWqVfavTkZ
   n03mks5daAy1XelnUfoG4pRjhRrKHWLVH1kcKKfa0fPQsMu3dGUT6aXH5
   p0q0Nsepp2HgWMENM6f1+y/Ldi81j9JCtfSD0DE9QcRClYY5jXQJLjpEW
   CCoTQ9O52xK7WAlSyPeSQ+MoNGXHI71M8N8He803wZ5EQ2AG70ecE9+qT
   wJVWi4YE1AX/O0DI+wloh42+O2qYqBV8Ac0cXBq3VxjHWEPDAtds6CQHL
   g==;
X-CSE-ConnectionGUID: sKc6yEKLSsanpbnx6vyBJA==
X-CSE-MsgGUID: nX4+ejb/QGqDGYSwyLo5fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70500581"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="70500581"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:02:19 -0800
X-CSE-ConnectionGUID: MdRXogEXREuECtNDX+g+vg==
X-CSE-MsgGUID: FyQWIZOBT8CF3GQbsg1ivA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="211733713"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:02:10 -0800
Date: Mon, 26 Jan 2026 12:02:06 +0200
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
Subject: Re: [PATCH v3 02/26] x86/virt/tdx: Use %# prefix for hex values in
 SEAMCALL error messages
Message-ID: <aXc7nuw7gokj6zvY@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-3-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-3-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69097-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 07E7186698
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:10AM -0800, Chao Gao wrote:
> "%#" format specifier automatically adds the "0x" prefix and has one less
> character than "0x%".
> 
> For conciseness, replace "0x%" with "%#" when printing hexadecimal values
> in SEAMCALL error messages.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

