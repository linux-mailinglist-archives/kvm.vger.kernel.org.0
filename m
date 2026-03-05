Return-Path: <kvm+bounces-72802-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBYsCJpMqWk14AAAu9opvQ
	(envelope-from <kvm+bounces-72802-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:27:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C81FB20E628
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 772023078157
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 09:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC1B378838;
	Thu,  5 Mar 2026 09:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDQp1cpH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3CABA3D;
	Thu,  5 Mar 2026 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772702705; cv=none; b=d1RGfOb/NJMKUvE+gzRs5pMX3m3He4JWTk2Y/P9GJkvSM13ss809JHyHrrirrQmx8Wf7vcZzMT8eU90ouoaOxV0Hpx+IO8X9kA/yb0MSwgl1GLobKFz2G3pih9/QvheMSwDvYHLdZrvat00x5OMblIIj3M8B6Tfspn80j6AJss0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772702705; c=relaxed/simple;
	bh=i7xx5fCE1pXU3hn232oNCbEw2z88WqGprgpNgwMewlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CazMMFEzCPmadIjKq9OjPaITlnNRrk9izqeln0dn/dYrK8PjYULdXgAb93XcVh3dt0oX9hl6fOpu7uSS+cug++yZfLZcJ6onJx3C4I3vM5YRB3yV8ajh6JmDCw102TdJQ5poJlaOxvA+7EQ394QddO0vsiS0Ca4YGOEhowz6jOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDQp1cpH; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772702704; x=1804238704;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i7xx5fCE1pXU3hn232oNCbEw2z88WqGprgpNgwMewlA=;
  b=gDQp1cpHSMRVb7bNYAt3/a5NPiSjPVweVe+elMlwldKFpy6Lgxf0XOzd
   M4Gm/mHx98t6NcM5jq8Q3pP2Lw6yl2ZhAmBomJqFLwt+WL88pPuQvsdBX
   Gl4Dh6VwFPrLQCEncGS70Qi7ZKMWRhdYSjAdyP/kMFC45RquEZAJpUHU8
   eFp3eTu4HSUYmiIEKxPMyBPHktXW+ZoVXKLOlYJ4hQekSz3XlfE1k+sCm
   UBqhuTYOyJpT4wmW9Ng9zpMN8jphhzXo3Ij6nWvPL4K2W5crZ+BEIf5xz
   Hpm6m6IAjvJz7wrvTMR35iCaM72I6gSDiUd2kSvrilzKiV5CinbfTyOsp
   A==;
X-CSE-ConnectionGUID: MtRnHNpnRPevu2emkU2qMQ==
X-CSE-MsgGUID: TKS0R3i3RZGBC/7Pp9MRQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61356592"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="61356592"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:24:47 -0800
X-CSE-ConnectionGUID: ZkbojYpZR2WP7PSbA3ShnQ==
X-CSE-MsgGUID: bQgJFqcLTXGbymInrDl0hw==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.1.83]) ([10.238.1.83])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:24:42 -0800
Message-ID: <7fbbea65-597b-4158-ac86-5dd3b7af067b@linux.intel.com>
Date: Thu, 5 Mar 2026 17:24:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/24] x86/virt/tdx: Move low level SEAMCALL helpers
 out of <asm/tdx.h>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 tony.lindgren@linux.intel.com, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-2-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260212143606.534586-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C81FB20E628
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-72802-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.intel.com:mid,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action



On 2/12/2026 10:35 PM, Chao Gao wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> TDX host core code implements three seamcall*() helpers to make SEAMCALL
> to the TDX module.  Currently, they are implemented in <asm/tdx.h> and
> are exposed to other kernel code which includes <asm/tdx.h>.
> 
> However, other than the TDX host core, seamcall*() are not expected to
> be used by other kernel code directly.  For instance, for all SEAMCALLs
> that are used by KVM, the TDX host core exports a wrapper function for
> each of them.
> 
> Move seamcall*() and related code out of <asm/tdx.h> and make them only
> visible to TDX host core.
> 
> Since TDX host core tdx.c is already very heavy, don't put low level
> seamcall*() code there but to a new dedicated "seamcall.h".  Also,

Nit:
seamcall.h is now seamcall_internal.h in this version.

> currently tdx.c has seamcall_prerr*() helpers which additionally print
> error message when calling seamcall*() fails.  Move them to "seamcall.h"

Ditto.

> as well.  In such way all low level SEAMCALL helpers are in a dedicated
> place, which is much more readable.

[...]

