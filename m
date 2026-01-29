Return-Path: <kvm+bounces-69519-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oBCiIMcSe2mlBAIAu9opvQ
	(envelope-from <kvm+bounces-69519-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:56:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E35EAD0BC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25966301184B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 07:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C2637B40B;
	Thu, 29 Jan 2026 07:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OpDU+gDu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4171280327;
	Thu, 29 Jan 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769673394; cv=none; b=pBSeDR6o1WJdcUDLqOMfPQLC63jKy9LlOXgWm2uimYKo4wiydzDZDNRVDi+VOlxXQz7CFgEDs1md9veQo5gBcCuIl9MpjbfyRYGWfSc2iEC9NoxSdPVOEgB46PRpXs8YsQEmqPxFcWkNKlJWpTIDzHSktqRdwsFBrkgFzhx9Lhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769673394; c=relaxed/simple;
	bh=fRx+DVEOsCHxYAEhnLXAhVsvKfUtgWF8M6SZ/P3cEVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3qkw5BaIf5VJCl6GW/rTaVfm2pc2BgH/Q3myAzlI8V2DOb538QJN0+iip2R89nuScndoJux1sFPJjJsShw7KBRTKavTZY15i7MNCGfTgI7athsrRdqrKpe3yiQn4z8OSQWfhuBuuTMxh+h3sWY9HcuiZGiyLm2akgyRFqXz/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OpDU+gDu; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769673393; x=1801209393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fRx+DVEOsCHxYAEhnLXAhVsvKfUtgWF8M6SZ/P3cEVg=;
  b=OpDU+gDuGFN/K3FYqVeRimCO0KX8w1hzDwmvEnVpJ9+C8j3Tobdf4H4T
   I7zaFx8zEfYXcLk7PCwQc+MLuzsUFRuirmjF82Lz7gfuaDqgwcLGcmREi
   WyM2UJTJQD9MWxgV3ssTdV36Reji0Ko3TEM+w3Wh+zRM+BMV5mvuOJfvn
   e3xemKosjcUSInNo490mGvpsB0l+4FR45+PzpgOSB7a6cia3nI4isKsMN
   vH7NpfGllRijGgmrbouVgYPcw+zbl77A3LBIIvtOGggrdwMwaFJeKMoLd
   8Uf5Sz204HlxIhcooMJk8LsL7aE3THoXMWp91Nzm6+iSS6AToqvPViAYT
   g==;
X-CSE-ConnectionGUID: DfbgH2qyQUi68wVWhls9aA==
X-CSE-MsgGUID: a/qsjVmsRtG6byYIERGA1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="70617327"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="70617327"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 23:56:33 -0800
X-CSE-ConnectionGUID: 3rx7ASu5TAuz/dFCjhoeaQ==
X-CSE-MsgGUID: S2s4I8SpTDeoyspM8saqTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="231424304"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa002.fm.intel.com with ESMTP; 28 Jan 2026 23:56:28 -0800
Date: Thu, 29 Jan 2026 15:38:15 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH v3 05/26] coco/tdx-host: Expose TDX Module version
Message-ID: <aXsOZ4UdLOS0xXeM@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-6-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-6-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69519-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2E35EAD0BC
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:13AM -0800, Chao Gao wrote:
> For TDX Module updates, userspace needs to select compatible update
> versions based on the current module version. This design delegates
> module selection complexity to userspace because TDX Module update
> policies are complex and version series are platform-specific.
> 
> For example, the 1.5.x series is for certain platform generations, while
> the 2.0.x series is intended for others. And TDX Module 1.5.x may be
> updated to 1.5.y but not to 1.5.y+1.
> 
> Expose the TDX Module version to userspace via sysfs to aid module
> selection. Since the TDX faux device will drive module updates, expose
> the version as its attribute.
> 
> This approach follows the pattern used by microcode updates and other
> CoCo implementations:
> 
> 1. AMD has a PCI device for the PSP for SEV which provides an existing
>    place to hang their equivalent metadata.
> 
> 2. ARM CCA will likely have a faux device (although it isn't obvious if
>    they have a need to export version information there) [1]
> 
> 3. Microcode revisions are exposed as CPU device attributes
> 
> One bonus of exposing TDX Module version via sysfs is: TDX Module
> version information remains available even after dmesg logs are cleared.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Link: https://lore.kernel.org/all/2025073035-bulginess-rematch-b92e@gregkh/ # [1]

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

