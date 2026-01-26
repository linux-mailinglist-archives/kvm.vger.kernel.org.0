Return-Path: <kvm+bounces-69104-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNwtJ/Q/d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69104-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:20:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BE386B93
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 11:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47BAB3028659
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C864432ED58;
	Mon, 26 Jan 2026 10:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nFC4bfDC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDBC304BBF;
	Mon, 26 Jan 2026 10:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769422655; cv=none; b=GPZfrpb+9nCcYiE5YLwaMvSMX4n2Wcc6QBK1xPmqg2ZNjSgs5tbS6NWOfVD/0BflPs3Z8QMAizUxun7orzAa7/vYvlTNf4k3B9JbYeHLNJlfWX048wH9t4YtGxXvuzmcZO6StqLoPWqljWMGMuLiwM5LX7ztRbTqkR0CXHsjG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769422655; c=relaxed/simple;
	bh=AhOYWD5QBcrxtWUNqsr1A0ii5M16SEcVS2QcGpxGSE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDXEg8uUFGDepRLGlFrim4QgrSONRE6yjkX7gPI7LjkODY0CnYtFAARX90XY1EB6+HW66ma2AIIEgcqda9BKwxdTK8sLCAlR1pTfVWO5UfWClFd/Wpj7RR6j6mLUsPys/El45QixtJC/IEWLyYXx+TIrdv02KHPNw8sRslqn54U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nFC4bfDC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769422653; x=1800958653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AhOYWD5QBcrxtWUNqsr1A0ii5M16SEcVS2QcGpxGSE4=;
  b=nFC4bfDCFCd9d0Ktkv1rHTjUi1IcmclTTzmRAIXAsIhUd8z1q8f87dMC
   PfcXieR02fZ1ozGvI1wneB4lCpi25LDsksLq+IRILtve+JxhLoHAE8KC1
   sRrGlRZJnhDFKB+Dh/+elMu1GptCtf1FXpVwUs6lih3r48cmX2hFTIebJ
   KSjpstn1iDii7ugM6kySJTcJRhikA3ysYf1rAq/9TBFgMoO2LWMLo5m/w
   xOlHRw5mn1ZCMa0kVKjhiNlG54CV22WxkaCSQAJ5xkb5T4qT3a33Ho8Ac
   G5Csb6O45WSnlCQksrTMhOXjHgi9X4IKrNwFcIed+ZXCVQN8ELi+O+Wxw
   A==;
X-CSE-ConnectionGUID: NXjy4UEGSdK5Wms6UpNwRA==
X-CSE-MsgGUID: PLyrnrLvSjiGduZ6FLrQZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="74464791"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="74464791"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:17:33 -0800
X-CSE-ConnectionGUID: cJENuSa3RJypC6yzaU0amw==
X-CSE-MsgGUID: O1GnH9JVSXWOhv6AOx6fiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="207701936"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 02:17:25 -0800
Date: Mon, 26 Jan 2026 12:17:21 +0200
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
Subject: Re: [PATCH v3 12/26] x86/virt/seamldr: Verify availability of slots
 for TDX Module updates
Message-ID: <aXc_MVuOKbrKoBH8@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-13-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-13-chao.gao@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69104-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 25BE386B93
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:20AM -0800, Chao Gao wrote:
> The CPU keeps track of TCB versions for each TDX Module that has been
> loaded. Since this tracking database has finite capacity, there's a maximum
> number of module updates that can be performed. After each successful
> update, the number reduces by one. Once it reaches zero, further updates
> will fail until next reboot.
> 
> Before updating the TDX Module, ensure that the limit on TDX Module updates
> has not been exceeded to prevent update failures in a later phase where TDs
> have to be killed.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

