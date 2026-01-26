Return-Path: <kvm+bounces-69117-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MAFCSlLd2msdwEAu9opvQ
	(envelope-from <kvm+bounces-69117-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:08:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2C36877F6
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52500303F06F
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FC8331A40;
	Mon, 26 Jan 2026 11:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixdnJZmR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD54C3002DC;
	Mon, 26 Jan 2026 11:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769425643; cv=none; b=T73jI6+6VUsy518zCbv0JxBpF3G7TDk+JI+ljRXKcYKLzdtlV4Q1m0QTFfJkmusfaNNd4RTf0/PUm48FYHkP7VDsAV5e8PjIueP5OKYazBtoeXBH2lLPJeOk+NH0biCp47KhwbWGolDhQ2GtB62KEeBUNz2oRCEel0sGLTH6GWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769425643; c=relaxed/simple;
	bh=13264qrMCQhOYJJ+Yi610FF7PBiCw3G7fVvwcjzIa1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVyjXmT4p93dINXN7eT5SB87xz2cvoc42pukZagVnrNALec3U5ZK6EIL489rDVObQccxk1BKqbNNO7EnUnmzInlnUeAFQMYNgYqMsrIVqNK+3HKo6uZIN9Z7a0wDNXlV6lloBAfHYbE/0EHbI8bP+6qiOiTd8L5o/p7lOjQsZz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixdnJZmR; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769425642; x=1800961642;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=13264qrMCQhOYJJ+Yi610FF7PBiCw3G7fVvwcjzIa1Y=;
  b=ixdnJZmRh6gRgXQ5/hGU2ozv5xliwNdQZ+u61sezCs0o3/KBYEEy9PEt
   0d6gCzyW1i0ERpQ9myafwQEwU+fd66QNk/kLc3JvFBEx3fwZCecO/mrOg
   H95GtaVxcYrKd/05QwTtzb5MshFdMHE3NQ/6tsxqlYUB1su83sogRYPRK
   grLg2rPafqnR5aNKmZzXEFOz4rgdNHOXZeakEco2AAy7Q2gxE4EchfzbY
   pIYYYlQhX1DucG1Z7cN3XnwtKJlAEdmImfOtIfSaZstwvGFX8TXWj49wy
   WQtvbrPdhMlb+tS3yJmFg5GWMmkpD9OsVp/EnJJ4Bz43uSVRoTg9k3EPP
   g==;
X-CSE-ConnectionGUID: xTbjUo4dRsK9QKwLBGD4yQ==
X-CSE-MsgGUID: iTg5OQ3BTP60NFTlWCtlOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70505057"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="70505057"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:07:21 -0800
X-CSE-ConnectionGUID: D41W+9cySa2zhutrrohEgw==
X-CSE-MsgGUID: hKAdt33ISCCHUCojOMLibw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="207711821"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:07:13 -0800
Date: Mon, 26 Jan 2026 13:07:10 +0200
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
Subject: Re: [PATCH v3 22/26] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Message-ID: <aXdK3pZJp4cEZeSl@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-23-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-23-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69117-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: C2C36877F6
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:30AM -0800, Chao Gao wrote:
> +int tdx_module_post_update(struct tdx_sys_info *info)
> +{
...
> +	/*
> +	 * Blindly refreshing the entire tdx_sysinfo could disrupt running
> +	 * software, as it may subtly rely on the previous state unless
> +	 * proven otherwise.
> +	 *
> +	 * Only refresh version information (including handoff version)
> +	 * that does not affect functionality, and ignore all other
> +	 * changes.
> +	 */
> +	tdx_sysinfo.version	= info->version;
> +	tdx_sysinfo.handoff	= info->handoff;
> +
> +	if (!memcmp(&tdx_sysinfo, info, sizeof(*info)))
> +		return 0;
> +
> +	pr_info("TDX module features have changed after updates, but might not take effect.\n");
> +	pr_info("Please consider updating your BIOS to install the TDX Module.\n");
> +	return 0;
> +}

To me it seems that a Linux a TDX module loader recommending a BIOS module
loader is not very user friendly :)

Anyways that more stuff for future so:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

