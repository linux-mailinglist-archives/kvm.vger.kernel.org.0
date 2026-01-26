Return-Path: <kvm+bounces-69095-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Dt6Heg7d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69095-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:03:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1638786617
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:03:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE624303B4E8
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE1332E72B;
	Mon, 26 Jan 2026 10:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CyU93w6J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965F519C566;
	Mon, 26 Jan 2026 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421653; cv=none; b=tFY2nxxH3Eldjwb5ds8kURzYXSyJw4VV6IJMtYq/4xvZKRCZUD3+0uvobOGVQ5Xx14/z4ww1/WHf6SKoGxIHMpLUD2JZ7JzIqJm0qIP7ZN/UYA2/GmVgDEOaizowWtW1k+WZoiaRshbmj+OChG2YtPqfb1Shgoylcns+cLGsa6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421653; c=relaxed/simple;
	bh=ndnaYHCyI4TxVcS4C8DczPPOEinTpAP1hbX/1JqkMhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4SQtJpQiI2582YGZXg2K6Wq72+HTnx75vTWdnnMZyIrSPkIHqvxmY7RTbyqbD9fxkisr6Qx6bOtnhPDGXCXzWnr6SSDWW2L3gmUOf47BDB+pYT1XMd7QqadSWB4QpEuLdrjt7oeHzSsqxrcHPDjZjicU1IOp/fmPiTeW2FchkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CyU93w6J; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421653; x=1800957653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ndnaYHCyI4TxVcS4C8DczPPOEinTpAP1hbX/1JqkMhc=;
  b=CyU93w6JtRI8+TBX1QdxvBFW5bnqHpSqtsBocgwsPGxlyjuDZoWUECvy
   VuT75/A+VLaBJIHNGGqi+wdXcfxLxbDF+vqcxRwxLYU2bh+DWjOYbUb3E
   VBGGJ/1U1/63HRcmP3ksLRBeZDVNY2ndSeWnjXqSY2dZLuXz9ZCtUBF9d
   wB5SUh9UGDS8UXnCFXR0ylVGY1wo7eXVYRXdGRtaCNc/Mu2UV4uw+TO1J
   5uy17KSS4/C9vsh52W89qignrh23B4HqyHCmWvsPrvTFE/XbpRtWhdn47
   liyV31aAbtwqLC+4SU3cJj7zvndN734GGNizugF6SNm98ORi+geFoaH0y
   Q==;
X-CSE-ConnectionGUID: k8I64hlvSUW/UICOb95Faw==
X-CSE-MsgGUID: +Bxht+9LQSSS0uLup6E4uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70500399"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="70500399"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:00:52 -0800
X-CSE-ConnectionGUID: ciSC7b/KSU28GcYumNlyaw==
X-CSE-MsgGUID: GoGPMc5ATme69a122gF5nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="211733464"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:00:44 -0800
Date: Mon, 26 Jan 2026 12:00:40 +0200
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
Subject: Re: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI
 for TDX Module updates
Message-ID: <aXc7SFuuwa1Sqth6@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-11-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-11-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69095-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 1638786617
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:18AM -0800, Chao Gao wrote:
> The firmware upload framework provides a standard mechanism for firmware
> updates by allowing device drivers to expose sysfs interfaces for
> user-initiated updates.
> 
> Register with this framework to expose sysfs interfaces for TDX Module
> updates and implement operations to process data blobs supplied by
> userspace.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

