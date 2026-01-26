Return-Path: <kvm+bounces-69105-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOi1LG9Bd2nLdgEAu9opvQ
	(envelope-from <kvm+bounces-69105-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:26:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1543386E13
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 136983058382
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB441330330;
	Mon, 26 Jan 2026 10:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ju4XvNK/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80E3330327;
	Mon, 26 Jan 2026 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769423019; cv=none; b=DKtolAwZi+jEGeQJYeCcp0+Q0UvBhda98oEFk36oaClPfekwpCcrSYC7Qs75lgx3UNouy3onC79ZNGFhFjd4Kb9b/nf/EQu3noTQnouGjP9eCuLjA+zQiEPcUqnoGq3gH9H1ZyOhSVL1K4wtP9B0OMxEzDt2/eFpzmNjA/ZBHGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769423019; c=relaxed/simple;
	bh=ncnEaKhx5TLp80nfEy8lZHAwERjJau4WaxgsBdTZyOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUOxrFXQu1rZ9EYD9KKktwB/lMu+vy4j0MfJEKnseWqD/+3pDtamcEW02rrSOxCTf3El9iBHAWp4/AILaSN2Q2zTPe8fZxLcbjblvKj1mfLmGv++9m0fLPFA3nFY30GjshDBx/r99SqQRvqBVvgblLfA0F5tPCjo19TCXTbpkE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ju4XvNK/; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769423018; x=1800959018;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ncnEaKhx5TLp80nfEy8lZHAwERjJau4WaxgsBdTZyOY=;
  b=ju4XvNK/7jewrL3kdnmdNZYif1KtxiVq/lGf8lZg344yRMYLBbPKL0ug
   wKdL0KFIqQ4LBIDTwijz9ew+Q1VeEIMkGnLa1xrCxe1+qSVYr6e9dB/Hh
   PvI/nlIxQaFeNexDFIxAJ7KKUlpP0F64YdWwuM0o2TgUisr/Dseco7FTx
   2sXAahvGJkiLAso+6bOJPqA6kdzLRLKsGwG/5Rb4i4Exc/a6hu5X2mKPy
   d/xnsK7tH0dQkcsxt+XlKN9paW7Rc5cBZapU6K7Tsg0xXE+smOmS9sp65
   Jq/9eNK86Bfz64E0N8rAqVy+JWkghbyJeRT6IL832+0XGAuPaZIx4klkN
   w==;
X-CSE-ConnectionGUID: xMZcjufPQ0e5E4uBCdQvlA==
X-CSE-MsgGUID: 9hXJJOQLR5qiBvLxT9e1dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="69793949"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="69793949"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:23:37 -0800
X-CSE-ConnectionGUID: ZbPIuE7bRPGKhKRNepNULw==
X-CSE-MsgGUID: fBmSQocTSEms2fXJDJhfnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207894704"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:23:30 -0800
Date: Mon, 26 Jan 2026 12:23:27 +0200
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
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aXdAnwYuKP-7pSM2@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-14-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-14-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69105-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1543386E13
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:21AM -0800, Chao Gao wrote:
> A module update request is a struct used to describe information about
> the TDX module to install. It is part of the P-SEAMLDR <-> kernel ABI
> and is accepted by the SEAMLDR_INSTALL SEAMCALL.
> 
> The request includes pointers to pages that contain the module binary, a
> pointer to a sigstruct file, and an update scenario.
> 
> Define the request struct according to the P-SEAMLDR spec [1], and parse
> the bitstream from userspace to populate that struct for later module
> updates.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

