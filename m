Return-Path: <kvm+bounces-69102-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGwSI5A/d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69102-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:18:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC2186AB3
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F96E3043D6A
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D721033032B;
	Mon, 26 Jan 2026 10:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fm6f1hoR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78A32AAC7;
	Mon, 26 Jan 2026 10:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769422532; cv=none; b=BV8zkcei10czWVlmwbRvcjPNywDizwEYTkmsQ5+4USRET6TsBF8ckydVxRHceQ95qjuGA9oxk1VpsKvz8br92C+ODQKxbahWOgOJ5NkBDUR3IjNufXHuPDAZVdMbmHUM0RSHqmZIdAx3xN4UVUDUVn4extitcB8rYojOMro/4Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769422532; c=relaxed/simple;
	bh=f6T20ZOU+YDhMqx083e2K9TNnBu3UMc8djTcwgcbARw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzikgW3z+0doOmhCS+z36BBNG1j89yl79cn7AMwIavifHmL68B+foPPrcR/qC93rwhzSNWqmABfAJ8FSW8Sa46uIx7HyKV6Y8v1eSZ3+4goNsmZqYnE7i8Jpt23wleGnT8G75SXXPJJMTVY6XPcn3GEyX4Bi86iJ4kuYVX6hd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fm6f1hoR; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769422531; x=1800958531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f6T20ZOU+YDhMqx083e2K9TNnBu3UMc8djTcwgcbARw=;
  b=fm6f1hoR8O6tQNqqjqufPe+gHh28OLQFESFeoHbfkGzXIcf6V2bfDz1I
   R1o+Dw/V0bOCUMb4VzoVGk86vjrBQ/EOHozOlhMxwXwbcnEXlwKOI4yBq
   1L+XTd81UOVRnPcjhUXfA60JiX0JkYjc7ht2tfnaOWGF2QP9qzcnkOG78
   bkdtlrLdWyZ0tR+sVKXTvZUuJIiByYr61k9VYQ2qGRaq1TNX2g3ODEjv9
   /znsglDejtJ3dsyfOJ4SUcfxMsBjzgj9qKSSU6cczWWEYW6OBT6ub9X5j
   P3clt3deWxa1h+7Y9mRCYOKG2/jQkZYbA4ftkSXFaV84b1rmHDML8I50M
   Q==;
X-CSE-ConnectionGUID: Jpcsf0dHR4qSxYOnOarjSQ==
X-CSE-MsgGUID: OCL4R3dmRKqsl+aRFcYj9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="81230742"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="81230742"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:15:30 -0800
X-CSE-ConnectionGUID: pv39I91FSM+eqRwbVPQC9g==
X-CSE-MsgGUID: 0GtnUSPpQXypK5Yn9iLE5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207669946"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:15:23 -0800
Date: Mon, 26 Jan 2026 12:15:19 +0200
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
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aXc-t6n0zeQkLOWm@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-9-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69102-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,seamldr.info:url]
X-Rspamd-Queue-Id: 4CC2186AB3
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:16AM -0800, Chao Gao wrote:
> P-SEAMLDR returns its information e.g., version and supported features, in
> response to the SEAMLDR.INFO SEAMCALL.
> 
> This information is useful for userspace. For example, the admin can decide
> which TDX module versions are compatible with the P-SEAMLDR according to
> the P-SEAMLDR version.
> 
> Add and export seamldr_get_info() which retrieves P-SEAMLDR information by
> invoking SEAMLDR.INFO SEAMCALL in preparation for exposing P-SEAMLDR
> version and other necessary information to userspace.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

