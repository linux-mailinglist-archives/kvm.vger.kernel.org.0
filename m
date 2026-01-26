Return-Path: <kvm+bounces-69094-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBxoBU87d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69094-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:00:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D3E86559
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ABECC302D095
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C2732AAC6;
	Mon, 26 Jan 2026 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjiGVA04"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D7D32D44E;
	Mon, 26 Jan 2026 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421427; cv=none; b=WRVaa+S4ARpAyixfRIQLCxZ7VHrDZ4ciDADOG+kKxU+7ZjpqMUKYhUx4on36cNJdlxHBfHoadn1ze/lXgzRIN7LE3zatQX4zR61pwmBNNQAQAlEedsqIqdG7FjsJzlR95yc82SObwENc19J0azzSr2onbpZKpWSxtK+lIn2k9c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421427; c=relaxed/simple;
	bh=6L2WsHp5StbLTHRapsIb/r2sE+yIgZ58XjuLHYlApdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsgAJ9ovz5RYE5R57dk0XOoTgGje441qEMY/74+ayFLJNaY5BV15hML32mZhLRSAzajW5siWsXRZGOLf9avAqCsZfjnlNClMvdi6aM5F5M4GC7enAPnUebCwNPIUmUGX2vuNTT6KfnVRb0mWH1Tfg4y0yaOFQma+oYBrYdSQLmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjiGVA04; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421426; x=1800957426;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6L2WsHp5StbLTHRapsIb/r2sE+yIgZ58XjuLHYlApdY=;
  b=hjiGVA04bPiT21iA9qoAqKVqBv10HHev7gu78iafPE2md1Hvj+SEifZN
   M6H7FWWbuBqq7B4fny5m9nGV3oVSlX0HB4d7YF6ap7FY3juWiwHyhe8xO
   xdCHebx44kzY5oBY/A8ZExOOAZinqOzz0/cr0M8XBMeuvHNGGXUbnDQz5
   A4ejARamvy+8CgC2d1iaXuk4zszGiwBQum5UBkSEG4CgpcXenqa2rt1ry
   c7/u5tCnCzLVVgtKKUuA7J+tgJjLcOQKvOVEJHvuW2tVOjFKAG7YoxmIs
   X954igc1uimWjSK/Vme1hgjRJzw9bXy/SjTNreMG2A6JJwYvWgQK4txdQ
   w==;
X-CSE-ConnectionGUID: 0lb6wnXuTRm0/fCrG0dRSQ==
X-CSE-MsgGUID: BAxfsLTPS7K8r98N1YivlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70564502"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="70564502"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:57:06 -0800
X-CSE-ConnectionGUID: IdaeJ4u2SXOYgVjZbUbQHA==
X-CSE-MsgGUID: tRjcD5NDSZ6dKkHhOQY2UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207991970"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:57:00 -0800
Date: Mon, 26 Jan 2026 11:56:56 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 09/26] coco/tdx-host: Expose P-SEAMLDR information via
 sysfs
Message-ID: <aXc6aClCmDbe8TN9@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-10-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-10-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69094-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
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
X-Rspamd-Queue-Id: A9D3E86559
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:17AM -0800, Chao Gao wrote:
> TDX Module updates require userspace to select the appropriate module
> to load. Expose necessary information to facilitate this decision. Two
> values are needed:
> 
> - P-SEAMLDR version: for compatibility checks between TDX Module and
> 		     P-SEAMLDR

This is great to have:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

