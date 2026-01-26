Return-Path: <kvm+bounces-69108-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yI4MMzNFd2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69108-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:42:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7850187260
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AEAD0302D082
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F02532E724;
	Mon, 26 Jan 2026 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G8TX+pIj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D48E19C566;
	Mon, 26 Jan 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424132; cv=none; b=ZMEeH85/0FXUkeEUPDbYBalzbO7xvuWqDQlzQ6Onc/0H9SZbtd0R8sxap5zkafmN6wT1btYvTWEJSU4zWavMBMJ6wNBBnJBHVW5SYzq7I4N5h1LweWeiFf7vO0R88rBjzdELgBVp2tOGVLDbOkb6wIhwsWxz38+rx8P4gdUrmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424132; c=relaxed/simple;
	bh=Sqda4WcgVYeoXlyqk1sjfMryqHnxe7/HsO4wgJuPIoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kly5vGxIYRCISkoE07U0iazWI3Pe3c21b3g4msiGQTgw2VrgNWr4yby+AUs2dxZ9lVC1pLni62N8T6nKjNBUtHLofGXVEdGCBvwdYN7SmI9aAkMLurCBgViN4n1WDb2eelBL+yN9YNoF1GbJADeSRv/jlNQM2f68txqLjM8xs8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G8TX+pIj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769424131; x=1800960131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Sqda4WcgVYeoXlyqk1sjfMryqHnxe7/HsO4wgJuPIoE=;
  b=G8TX+pIji62jg7xIaG9ztWYUZwFoRFHycMqJW+9zJgJZTCqcWZfrNgMh
   Ti7PPXEdLiud32vnBWzbsIx/2tQLOr3S0XS7nJScR3pOKGkj+jHUkCyxj
   LQImjsPrphQ+kvOvQNYVS+gkiZP4/QlLeWeMJmFSQZvsr2msO5ASxO9LW
   pRs2ZME3KkSHjZfY054JF670hllz6lakiNCcDiN2yqS3LjovQiXc6CK5d
   JhMUOvTWm7ZLFEm6k+B58FF4sD0nT5YmgH/Yc/vqjXoq8PDImp278sgog
   WuRFMV9jY3rzMsf5ur3SRrswL6usTS5Z//dMvHrh3u0P1WTx1b0Ipf817
   w==;
X-CSE-ConnectionGUID: ha7j6UnETDSdD/BKO0tOmw==
X-CSE-MsgGUID: PaMeF2d9T2ybdwdF1IaAbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70654707"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="70654707"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:42:10 -0800
X-CSE-ConnectionGUID: cWLhThS4SNua6Tv7jFiq9w==
X-CSE-MsgGUID: 1NsHtn2iTOiTvVA2oMaTqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="212507611"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:42:03 -0800
Date: Mon, 26 Jan 2026 12:42:00 +0200
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
Subject: Re: [PATCH v3 16/26] x86/virt/seamldr: Shut down the current TDX
 module
Message-ID: <aXdE-BjIHZ9aYC6a@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-17-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-17-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69108-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 7850187260
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:24AM -0800, Chao Gao wrote:
> TDX Module updates request shutting down the existing TDX module.
> During this shutdown, the module generates hand-off data, which captures
> the module's states essential for preserving running TDs. The new TDX
> Module can utilize this hand-off data to establish its states.
> 
> Invoke the TDH_SYS_SHUTDOWN SEAMCALL on one CPU to perform the shutdown.
> This SEAMCALL requires a hand-off module version. Use the module's own
> hand-off version, as it is the highest version the module can produce and
> is more likely to be compatible with new modules as new modules likely have
> higher hand-off version.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

