Return-Path: <kvm+bounces-69121-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qCT/LtFPd2n0dwEAu9opvQ
	(envelope-from <kvm+bounces-69121-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:28:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3649F87A53
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2338E3013A71
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F39332ECB;
	Mon, 26 Jan 2026 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hkKOtzru"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBE62BEC2B;
	Mon, 26 Jan 2026 11:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769426893; cv=none; b=eRYW0Z6dJaeVAN7ddpUSSpn4Gdu0FXLJHXtMn159lcso2FwEr0tLkkJkIDxwzaEN0CrQnE8Ap/yXvbcIF4X+c9apSZKVjb2fRwVF6yJxwGytZtZYvtnqP4Zuu8RXw3SFMqFShEu05/q+epivdx42Zt0W0lEDjK3l62UE0YZLxpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769426893; c=relaxed/simple;
	bh=k3XR1MT5Vahum7lTIJiF6OhzMhBXDH+X36hEo9UNNiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5sEz50EDu1PKPcc817zcj7Nk1twom3jKRIpIZ+uc4PSzcRvOlJnoM7xZksuNKcV6OijavP6GQGQGWBUTqAhPmTKXCVPOKNQub2hS3yG5h7yscvQprmSlBpML+n+m+5lWqsFIjP2Ye1wJWTkhKkRax4hcXYCpza71ix8RQeZgVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hkKOtzru; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769426891; x=1800962891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k3XR1MT5Vahum7lTIJiF6OhzMhBXDH+X36hEo9UNNiA=;
  b=hkKOtzrugiGFrUmvbN36BmHIpPITtdv+337eJpy60kZEUm9bsC/lxy/W
   dC3OCCH/JeWA9WCu4eLSn6dCwRrNpkrXK1vUbmpPiVt+HyAFtlvq7RTMe
   ji0tsu1D8rTkzfGrAQUgA7GQ71y1wRw5B966ZGs8py1uwthbhKuzJiO3o
   xz98rZMTlJJOn6yhVZjLtz1NNo+l8s4ItsEOnaRdxG5ZBO8NOYOoNEPO7
   02/fPEEBTCmdR9r1iYyZ3vaBHntc0LLnxhi/P9CipLMnjtHPJBU4RfJzw
   IJ4z+SM7m0pMRSk8OqCtb/UomlRz4AtzJY0Cnl4aOs/b2Wg6xSpRfgKYg
   g==;
X-CSE-ConnectionGUID: z7cyAr9GSryWZHSP/aKwKA==
X-CSE-MsgGUID: fOP39w+5S/aJnp2VJziRmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="58176432"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="58176432"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:28:10 -0800
X-CSE-ConnectionGUID: QxIAn7LDS+SbVBcYWTrFaA==
X-CSE-MsgGUID: JdqJE326RReXEfKaccWuWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="207258561"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 03:28:04 -0800
Date: Mon, 26 Jan 2026 13:28:01 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH v3 26/26] coco/tdx-host: Set and document TDX Module
 update expectations
Message-ID: <aXdPwRtsj1Qj9VLi@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-27-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-27-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69121-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3649F87A53
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:34AM -0800, Chao Gao wrote:
> In rare cases, TDX Module updates may cause TD management operations to
> fail if they occur during phases of the TD lifecycle that are sensitive
> to update compatibility.
> 
> But not all combinations of P-SEAMLDR, kernel, and TDX Module have the
> capability to detect and prevent said incompatibilities. Completely
> disabling TDX Module updates on platforms without the capability would
> be overkill, as these incompatibility cases are rare and can be
> addressed by userspace through coordinated scheduling of updates and TD
> management operations.
> 
> To set clear expectations for TDX Module updates, expose the capability
> to detect and prevent these incompatibility cases via sysfs and
> document the compatibility criteria and indications when those criteria
> are violated.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

