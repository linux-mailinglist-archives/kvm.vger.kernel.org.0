Return-Path: <kvm+bounces-69318-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAr6BpiBeWmexQEAu9opvQ
	(envelope-from <kvm+bounces-69318-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:25:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C08A9CA4E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 421F43009397
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C3632ED2C;
	Wed, 28 Jan 2026 03:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XWnh0Sgv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971683218D8;
	Wed, 28 Jan 2026 03:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769570699; cv=none; b=E52VllrCW7gptG60b5JF3J61GDSYVEFng+a+xVZ4RPLy5XtyTqs4KhihVEpXMcizyPTEHnc3xqwHD0ev2kSoBSkd33isMlrXUbwXXqp9IrWCLl3zCi2uygTKJV0XzhsogLVdSuewyuhIqrdthe0m5cmSzK0NVfVdIG0eS1dgCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769570699; c=relaxed/simple;
	bh=UaU2wUKDMyehkRl6zgzDMweY+3gos4+RMGZ7pfmkZzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLp6Y1t797eUkBwbqUKoPgncsBDhTqWqM44g1CDiwA95L8z7d5R7eHvMvnGPWi4skUsHVG3bQMfZQUPjxgm3GIIMzCPeucNgnF+JYwOsCLBCT2BFVNVTcQ07muSzhBCcb9FiNUTy3PUs3IYGlHLVuYXLpCD9XdRB77Wd5cBYTWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XWnh0Sgv; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769570697; x=1801106697;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UaU2wUKDMyehkRl6zgzDMweY+3gos4+RMGZ7pfmkZzk=;
  b=XWnh0SgvXAEhcp8QAhwWzZjbe5OZYzEvMUkap0MpbGQIq2q3FxDsQ7Py
   0r9bgwq+CFfUkxvBjQ+7EcchkR9/PVj3NltjnCqElZUwKQPIW+AOIymwZ
   wE/CgQda4BA6w2tWCxEyycnvjp0N9rKyt+75reGdR9mY6JfZDG1J0ZN7e
   Ap4QkJlLoJqvJ3Trycp8GNwzGbfsPr/RMI3BHYemV2gcqqa6sRJ14/Mg5
   sSgMuHcbj+WynAPR6IA4MgZ29bXgmTU8XenItkM7lJxwH3qWt8KbqMLD0
   J93ldBrERL6GTcTvHSuTyBfV4BbfewpbRsUYCklRvC+LZrC3kCLCgyeSc
   w==;
X-CSE-ConnectionGUID: /hdVe7X2RhmALl5dSJH6DA==
X-CSE-MsgGUID: 4ZFQ4cfuQ32QTQucEvgdPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="74624265"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="74624265"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:24:56 -0800
X-CSE-ConnectionGUID: jjVdla45T7aEIAbI8c/FwA==
X-CSE-MsgGUID: 6oEjP+k+T2WHi3nX68Ifmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="207769469"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:24:50 -0800
Message-ID: <2db22e08-88cd-4873-9645-a2e17af29220@linux.intel.com>
Date: Wed, 28 Jan 2026 11:24:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] coco/tdx-host: Introduce a "tdx_host" device
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-5-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-69318-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C08A9CA4E
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
[...]
> diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
> index df1cfaf26c65..f7691f64fbe3 100644
> --- a/drivers/virt/coco/Kconfig
> +++ b/drivers/virt/coco/Kconfig
> @@ -17,5 +17,7 @@ source "drivers/virt/coco/arm-cca-guest/Kconfig"
>  source "drivers/virt/coco/guest/Kconfig"
>  endif
>  
> +source "drivers/virt/coco/tdx-host/Kconfig"
> +
>  config TSM
>  	bool
> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> index cb52021912b3..b323b0ae4f82 100644
> --- a/drivers/virt/coco/Makefile
> +++ b/drivers/virt/coco/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
>  obj-$(CONFIG_ARM_PKVM_GUEST)	+= pkvm-guest/
>  obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
>  obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
> +obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx-host/

IIUC, the folder name "tdx-host" here stands for TDX host services?
Should it use CONFIG_TDX_HOST_SERVICES here?

>  obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
>  obj-$(CONFIG_TSM) 		+= tsm-core.o
>  obj-$(CONFIG_TSM_GUEST)		+= guest/
> diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
> new file mode 100644
> index 000000000000..e58bad148a35
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-host/Kconfig
> @@ -0,0 +1,10 @@
> +config TDX_HOST_SERVICES
> +	tristate "TDX Host Services Driver"
> +	depends on INTEL_TDX_HOST
> +	default m
> +	help
> +	  Enable access to TDX host services like module update and
> +	  extensions (e.g. TDX Connect).
> +
> +	  Say y or m if enabling support for confidential virtual machine
> +	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
> diff --git a/drivers/virt/coco/tdx-host/Makefile b/drivers/virt/coco/tdx-host/Makefile
> new file mode 100644
> index 000000000000..e61e749a8dff
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-host/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_TDX_HOST_SERVICES) += tdx-host.o
> diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
> new file mode 100644
> index 000000000000..c77885392b09
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-host/tdx-host.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * TDX host user interface driver
> + *
> + * Copyright (C) 2025 Intel Corporation

Nit:
Update the year to 2026?



