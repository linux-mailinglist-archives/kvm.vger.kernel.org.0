Return-Path: <kvm+bounces-69120-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ONjDIX5Pd2n0dwEAu9opvQ
	(envelope-from <kvm+bounces-69120-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:26:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A6887A25
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55C723043BEC
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDB3332ED1;
	Mon, 26 Jan 2026 11:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLWFDvCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D52E33290B;
	Mon, 26 Jan 2026 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769426626; cv=none; b=OsP4sSRw47ne82S5JsM54KxtXAx0ZIJUI8NuHdhhct7nrKKexLgDyu1pTcVPOzFJR4/gLwjzBYuS+pvr7bpmIEnRSzNmqvHgB47Vx5kmw8R9/L9TvERUBowg1KFhiJ7/9PP2PqQak+ouSJX0+YeyJ46cBycujxga2woUjyvfvag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769426626; c=relaxed/simple;
	bh=y6PyvejjwSHp9VlYpUYAzRrqv8mXYtVgIAU6C9381yU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=toS9zsEwxMkmWall2qpqCxRgabZ4m678SqGQ0+j4l7TdWJuOXSEVLEnYs6wWnMjC4ykAu83QMoaMWtywaoCYaVHsJRMa4eekt0XyHCIwpVP/ea2Nn7+aJGTMVEBB5By1U2vg+RnNtaP6a/TmD2MBizwrg4PMAKnpESdNblot7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLWFDvCS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769426626; x=1800962626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y6PyvejjwSHp9VlYpUYAzRrqv8mXYtVgIAU6C9381yU=;
  b=CLWFDvCSXvXrzDVdGor75bgvgCwWf4rcCPS/JEGmbwn/5bob5sFhTZwu
   fqNs12Niy5SBXMLLHwPxCDaeiCaIP2+tbOI7ZdvyRUpDvsfrYeb5OMgdC
   g2qyfPCtLyofQGSAch5S22f7zIoDx7xmQShrHoiiBM6kw+fZYjZkEDfp0
   PN2YLOUlqlbynwzEq0MOKnaRtkR0oCuR4fCI6gxsx6UN6R+/yzsjsDLQ3
   IR2ZUPUNCadLWWu8TZnCb5rlCdQyhiFQJMu2FIpwzXyetEi/vg4NnQpWi
   hB4mEWp/b3B2rvGOSkWu6KqHwl1ef5t96WRfRWF37lRfr9nsXFXrW68lS
   A==;
X-CSE-ConnectionGUID: rc+Fe9tJTBGMrkDYgGYvxQ==
X-CSE-MsgGUID: KzRCC8YdQKG1IvBGM37uUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="69625133"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="69625133"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:23:45 -0800
X-CSE-ConnectionGUID: VXV4wnSJSPmKmgG3cqjoPQ==
X-CSE-MsgGUID: VwWEqut1RVmWtpLIJ/uM0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="208084654"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:23:38 -0800
Date: Mon, 26 Jan 2026 13:23:35 +0200
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
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 25/26] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Message-ID: <aXdOt8Vo5zM18gdR@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-26-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-26-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69120-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 33A6887A25
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:33AM -0800, Chao Gao wrote:
> TDX Module updates may cause TD management operations to fail if they
> occur during phases of the TD lifecycle that are sensitive to update
> compatibility.
> 
> Currently, there are two update-sensitive scenarios:
>  - TD build, where TD Measurement Register (TDMR) accumulates over multiple
>    TDH.MEM.PAGE.ADD, TDH.MR.EXTEND and TDH.MR.FINALIZE calls.
> 
>  - TD migration, where an intermediate crypto state is saved if a state
>    migration function (TDH.EXPORT.STATE.* or TDH.IMPORT.STATE.*) is
>    interrupted and restored when the function is resumed.
> 
> For example, if an update races with TD build operations, the TD
> Measurement Register will become incorrect, causing the TD to fail
> attestation.
> 
> The TDX Module offers two solutions:
> 
> 1. Avoid updates during update-sensitive times
> 
>    The host VMM can instruct TDH.SYS.SHUTDOWN to fail if any of the TDs
>    are currently in any update-sensitive cases.
> 
> 2. Detect incompatibility after updates
> 
>    On TDH.SYS.UPDATE, the host VMM can configure the TDX Module to detect
>    actual incompatibility cases. The TDX Module will then return a special
>    error to signal the incompatibility, allowing the host VMM to restart
>    the update-sensitive operations.
> 
> Implement option #1 to fail updates if the feature is available. Also,
> distinguish this update failure from other failures by returning -EBUSY,
> which will be converted to a firmware update error code indicating that the
> firmware is busy.

Looks good to me:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

