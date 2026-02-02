Return-Path: <kvm+bounces-69810-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 3cPHNuhYgGns6wIAu9opvQ
	(envelope-from <kvm+bounces-69810-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:57:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AE2C9692
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:57:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88AA930182A2
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 07:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCB42C08AB;
	Mon,  2 Feb 2026 07:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3q8CHIw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9730B2BE7C3;
	Mon,  2 Feb 2026 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770018669; cv=none; b=gV5Gxrq6ADEqWksNGwJMH2AyJIo/+y3okLBFDEgtftDomHBijG10JNOJPHZoFXYmJYu5loChyVmLF4z3kj44uC1WinSW+S6v7LCQXtyShIsb/czs1jhqVBFRpd83vtIFBqXmQmqVEYXnS/fiJ4gQha8uRKvsDvhltcPv+yCjDOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770018669; c=relaxed/simple;
	bh=O0+prLIDP9EOVtAq7fhPLEt/qSodZ9oGj9fgL+MyYO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhW/cekpqLPZYRB3TbYDfLOOe0z0c5w8reCwpU7xGeGnolld8RAPJh/uQ3gVczIKawoydyhLt+Lg9u/2wGHAM05N5FkNM+qHm0qm/EMXFMcroSl7ryTLx7RX3x2j9HckEaEaSs5in4mDzHohjjal4UONsDqFXsNoqbUYEL21rjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3q8CHIw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770018669; x=1801554669;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O0+prLIDP9EOVtAq7fhPLEt/qSodZ9oGj9fgL+MyYO4=;
  b=I3q8CHIwbjl2MuCY5OmgcrrGbyk/tfHmEiI2TsTXJCJIClbUW72tg7l/
   c+8G3JqauslFSmTvr+FSFfJtkVa0ugwGKr0B+avP390NQuzqMCt++QTTF
   uYuL/CgV8TMRltujvwVkjDN5cJTVEVDrXJ8HvqSzrDXU4ObTgEnsOz2tC
   eScmVWLB91pmG5ou+0GDyOgRgjrYp4iE/dlHgO7JLuNhVdvDSQrh905kf
   p3mCfaOUqtO4GANFTDCDcS9o2bI/vCWEHLQ8Kov0zF6mzz6juCdCdQrnf
   VhmXCRIhj6STXlCisrbyalbqU2N51f+0LUYlJivTRUu0zndwevreu2xlt
   A==;
X-CSE-ConnectionGUID: euBubsM+Q2WdCtEWs4nGig==
X-CSE-MsgGUID: V2CtS1RBTkG09KnEGvA+Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81909844"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="81909844"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 23:50:48 -0800
X-CSE-ConnectionGUID: 0uhux7NhTw+tr/xgY1kJtQ==
X-CSE-MsgGUID: 7YPpESU2TTGCuSu4En8U4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="209523773"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 01 Feb 2026 23:50:42 -0800
Date: Mon, 2 Feb 2026 15:32:17 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 20/26] x86/virt/seamldr: Do TDX per-CPU initialization
 after updates
Message-ID: <aYBTAadWNyb8h06B@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-21-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-21-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69810-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 73AE2C9692
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:28AM -0800, Chao Gao wrote:
> After installing the new TDX module, each CPU should be initialized
> again to make the CPU ready to run any other SEAMCALLs. So, call
> tdx_cpu_enable() on all CPUs.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

