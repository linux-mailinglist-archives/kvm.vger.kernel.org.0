Return-Path: <kvm+bounces-69112-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLu7FutId2l9dwEAu9opvQ
	(envelope-from <kvm+bounces-69112-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:58:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EF9987662
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EC61A3029485
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94B530DEDD;
	Mon, 26 Jan 2026 10:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5lxbDV3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F733321A0;
	Mon, 26 Jan 2026 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424791; cv=none; b=Ven7cPdIJEHGLUACQwzyj4AxXaWNLrGthPIVsNGJvS0TL93UrJE9ulRP6XPgOQq+eIcyI3qzdP6AOagkpn+LN3UnmvGzu9LCiwDhGlia/GRXIr1Sdxtfx1u8b33yKo5TqMVXymmeGynzo7II5t8G7esYaB5XlGEPRe4vWFwMTAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424791; c=relaxed/simple;
	bh=Q7v7k8qnwyLssYyE6bXhqsK9cTQ84Pp2u07KKebHmOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUDmbjMj1zm1dT7PK0rrIQi8RQfvSn2qVMPCs+oOrYT3fLdtUTS0SiCvOtcy6rmz8Fa6IRr/xyARjBrjRbUYzQ5eAa5uJjg3u4KBNY9LinBclwLoJXilpWQJQDwwBz8wRwaJEHlgRhOHkVwyj0zLAqq1bTcsImmPFqflH7J3yhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5lxbDV3; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769424790; x=1800960790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q7v7k8qnwyLssYyE6bXhqsK9cTQ84Pp2u07KKebHmOg=;
  b=e5lxbDV3B4ieuR+8UgC//yIK7LI+YBKy/OlccImELjCWZ5w1PWZsg2tt
   8O8aBAE/+7hiNSAud+4fCH6a1mBHpeinMKWJ1PcU/Z8XyjZquf45cPmc3
   FDv0tXibgkWTIFRL6/H45qAuKTP6+euec0VVILirsVchL6LslhRNTVHiV
   GLHW9IbUqJ1v7gYCCC6e3gCOUWamkBe90vMxuN82LKzfmSyzLAkyaVNoR
   DAGPNMFAehxFB0kNzFvFgssNTMhlaQVTtdctwBxl3AB/ZgQrKcsnSqjKw
   n3CUO6j85wQAnp+YglIhDt84Gk60WIxPE3LX1Vhx+QXeL/Ck5BmJqIb6v
   w==;
X-CSE-ConnectionGUID: t5ZiGLy7SUC0KIz5l5L98A==
X-CSE-MsgGUID: RmJbMmaVToGz6TRQMLJJFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="80899648"
X-IronPort-AV: E=Sophos;i="6.21,255,1763452800"; 
   d="scan'208";a="80899648"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:53:10 -0800
X-CSE-ConnectionGUID: JLhSzOkCQ2CTT9WtNUzNWg==
X-CSE-MsgGUID: IQefoW+3TxyDKH1bK8+ayg==
X-ExtLoop1: 1
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:53:03 -0800
Date: Mon, 26 Jan 2026 12:53:00 +0200
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
Subject: Re: [PATCH v3 20/26] x86/virt/seamldr: Do TDX per-CPU initialization
 after updates
Message-ID: <aXdHjFkITkAPXgMr@tlindgre-MOBL1>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69112-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 7EF9987662
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:28AM -0800, Chao Gao wrote:
> After installing the new TDX module, each CPU should be initialized
> again to make the CPU ready to run any other SEAMCALLs. So, call
> tdx_cpu_enable() on all CPUs.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

