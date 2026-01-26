Return-Path: <kvm+bounces-69092-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDHSN0Q6d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69092-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:56:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C83B86489
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FB5630146B4
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C3532E137;
	Mon, 26 Jan 2026 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yks+jC87"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E132D451;
	Mon, 26 Jan 2026 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421290; cv=none; b=jjV4qntv87QHEeiMIlFH4wjMRBcWBQlATw9FgnTaWbhm/BgT/GRDSo11b2JsIokAyS51tcnsZ8KCernR5XHHy9W19+1zOBXyqDhnMM20NJEbZwV2UObICTTY3ee8xLyV0G1Q6BOaSDGrDFAKHY+K4R60eNt4rCCbHFZAsZN4hoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421290; c=relaxed/simple;
	bh=o6Hruu+ogQ5UDJ1LHLBq1ySmAXYRdDLRmYYrK0njAdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soCzbcjaqYpmsOU6hH2HAmjMEZynOQ2y2vODdLcvUEbFG7GI8tTYZnf2YxHm/J1ZL0ohPnHWws+TuU22dlZVOurQmRE+hpnTDafowEEkoNLAdCvdjCe2SHD6YdxHLkQkifVpBFh4PZeCIFnr0MwsIYoqdiMx5+KNfK9A9pqSAB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yks+jC87; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421289; x=1800957289;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o6Hruu+ogQ5UDJ1LHLBq1ySmAXYRdDLRmYYrK0njAdY=;
  b=Yks+jC87JMUPdwiS3GUzVWb/YeYf8+ngzaHa+YJX1dmstZ/lJv/gT8LT
   yReQT0KH35KGvMNhlrwhKhHlVYM6BamUbRRLBBM+QoRv4bmdFBlPL5g5F
   FQrhPPt7bB4cdgkMXi4EiYK2YYz7hg6ZRdXNIgPjHdzwTaWA2J90uDhj9
   3X7NhZT8BfvqKWwdCWaWFLbGZYBPMsxWOWtnzWyVtCKV5eubyh9fmZX6L
   rf0DEw/CAExerNpDatWA2fk67Vt3po9YWEs4QJRlrUlNMooAuNg6LYrKp
   fSMFdUAUzi48uyUxM4DJp6PQY4xtnXPrvCIozEdOBdNdSMxKVBSJ38eHS
   A==;
X-CSE-ConnectionGUID: pjR4qZlTRcCZkzvqN3SP8w==
X-CSE-MsgGUID: JfbC6i+9SJWMtI0xPdUwKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="81705991"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="81705991"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:54:48 -0800
X-CSE-ConnectionGUID: tWOIZW50TYKNQ9Ps41KLHw==
X-CSE-MsgGUID: veIrccK8S4O5MOLDRF85BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="230590499"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:54:41 -0800
Date: Mon, 26 Jan 2026 11:54:38 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH v3 05/26] coco/tdx-host: Expose TDX Module version
Message-ID: <aXc53nHzCAyu3lZt@tlindgre-MOBL1>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69092-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 9C83B86489
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:13AM -0800, Chao Gao wrote:
> Expose the TDX Module version to userspace via sysfs to aid module
> selection. Since the TDX faux device will drive module updates, expose
> the version as its attribute.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

