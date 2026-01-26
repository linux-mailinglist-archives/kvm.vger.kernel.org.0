Return-Path: <kvm+bounces-69091-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBdVC/k5d2mMdQEAu9opvQ
	(envelope-from <kvm+bounces-69091-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:55:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4408386422
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 10:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5995300A597
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569DD313543;
	Mon, 26 Jan 2026 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MeNJtM+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2412C08D5;
	Mon, 26 Jan 2026 09:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769421167; cv=none; b=o5N1xujPVXztPSNv8+nIY+a7w9GO56xG3EtLQRsr6n7lNk3y3FG/R6SqWv/qZG0E/u9iWLOX+KgwlofckkbfrKTYFi2CV+y9CxgnMgC4mu5u9mK73jWJKP7c7UrAz/7iWZcGTkQ07JW9J+z94JyBlwkzrlxw5du+/uMMFsEiZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769421167; c=relaxed/simple;
	bh=pVJehkH9/43QzdkU5u6k81DY5tuaV50zxb51megh7nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAAXbkR15+fKMq7PHQUyCRCkuDMh7s7n0tK2Xjbmc9/gV/zyHkYnLlUXAHagl4aSbg+qzls1/1E1yGEV9UzWuNK0OhzxZGNdcGIQ4+64SEPHgmWYAwB/19gXHnLflNDdTznWcFG7uEypWfljKUDunbGzMASqJcoPL7pi+KtRj9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MeNJtM+Z; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769421166; x=1800957166;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pVJehkH9/43QzdkU5u6k81DY5tuaV50zxb51megh7nc=;
  b=MeNJtM+Z5gcNe8qAlzgJqNWqJxbM0TYF6m/EsF4sWCuZzuQLqh0c9LVh
   nmrV/eLAv6zW4UJ0HoCYg2sQvRfgOneb9Y9TdsT+FBGN88P5fL4n52VZN
   K66TKs/CjV/SiCK5OvPDvU6UiG3ohkvY2fsLIqDcQvgXUNc3JuQVmqAbm
   fgFbnUHwCZnhYz1224/6s5+P4pya/8o5niCa+QDqK3xMZ37MZ0h4OLiFM
   QtcI2xIzFheOZL7PGJpZ4XPTNWKRTIvZSkABATK9Ii1KVSTLREz7uc+6u
   8s5KQrgwzp8kVYYEwCXAEDJA2uHGzJvlgc8mTPKWnRQcHgWD+TUzn8j9D
   A==;
X-CSE-ConnectionGUID: nH40dAKmRUavArVMVgIpBg==
X-CSE-MsgGUID: GMTauI+WTNKJcMNIINnwYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11682"; a="70496159"
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="70496159"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:52:46 -0800
X-CSE-ConnectionGUID: 3nESwMw8Roybw+WW9iaXpA==
X-CSE-MsgGUID: i0RBb9FyQDenmJKpX4uG0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,254,1763452800"; 
   d="scan'208";a="238309231"
Received: from krybak-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.55])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 01:52:38 -0800
Date: Mon, 26 Jan 2026 11:52:35 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 04/26] coco/tdx-host: Introduce a "tdx_host" device
Message-ID: <aXc5Y_VAuGQWsWZX@tlindgre-MOBL1>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-5-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-5-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69091-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 4408386422
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 06:55:12AM -0800, Chao Gao wrote:
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-host/tdx-host.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * TDX host user interface driver
> + *
> + * Copyright (C) 2025 Intel Corporation
> + */

Just a nit, the year has changed so could be updated.

Good to see the TDX host device get added:

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

