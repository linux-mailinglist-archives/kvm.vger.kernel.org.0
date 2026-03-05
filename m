Return-Path: <kvm+bounces-72803-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MgOKkBMqWk14AAAu9opvQ
	(envelope-from <kvm+bounces-72803-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:26:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B3E20E5D2
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 10:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2F07930489AF
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 09:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21866378D76;
	Thu,  5 Mar 2026 09:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DIpp2n5T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E13783D7;
	Thu,  5 Mar 2026 09:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772702754; cv=none; b=LbQU29Y914giLuqtwbx9/tXdIeUtzdHbp+bHbPC+F98H/Uxjj4oO73GyDCaS4jQKcjN6GYshL23pa8eu/q9tXh3zvzceMeRWsrWkIjo5D11E/YuLU0biG294ttIIvX5L+9eJgmrQtfEkrOzLmiw5uuOcVLLZvc7lMhSsSu5BhOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772702754; c=relaxed/simple;
	bh=RewwuBMyHSoanSb1wPB65peRwv/naRzYe7csL5PLp2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWE5g9y8kmrMTFbVaG4mp9E2dO5jeFNSB8Z8up3+1IQTIin/0CMal9BYDfTbD5E0PiLBS5JELwvUbr4AJQh3yVz07LMXp7SXNwluRUjY2Ofob5ZttGBfpqpM3ci5nwHNg3TeHwRXprVcy/7mqPRhU1+oqh/EpJYi5ikSBtPqduY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DIpp2n5T; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772702752; x=1804238752;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RewwuBMyHSoanSb1wPB65peRwv/naRzYe7csL5PLp2g=;
  b=DIpp2n5TLnbY9mteC3EQCYp3VgzaWySztbLZK82nlh64pVcxtWcKjMzQ
   ZJo+m1w8+buPVZI+ojCaG7KBSWu+/94akuJOeNJf6Ydsf0GjlI9sneguU
   EZ6uBWb11eXZE1eFtc97cm2PXf4OWzFPZzlY5JzbRx+rUdJQQfiHqoAzL
   ywybM/1FWM3epyKaGpyC4yK3TpQqg0MCG7ClTz2pHdBkiDJXccoUUyb5X
   drkcRkBMl+hkqzRNkoMKPdyu3xgd+PvtNNgcN4gTRQheFYuj9DaOyOO4E
   SG6P6EbNhNGSuMrBdv3qd0Cj48r8k0+PtEgq1zr3rt4f7itMIT292plvv
   w==;
X-CSE-ConnectionGUID: 04BC/d4BRLSTga3xLjCs3Q==
X-CSE-MsgGUID: 9Q4f1x9YQCC5FCpphwgBbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61356782"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="61356782"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:25:51 -0800
X-CSE-ConnectionGUID: Wb1x7m8KSICcQk8+XuBnmQ==
X-CSE-MsgGUID: Se73oGxgSgGnDHb2Yb/uaA==
X-ExtLoop1: 1
Received: from unknown (HELO [10.238.1.83]) ([10.238.1.83])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:25:45 -0800
Message-ID: <1be33429-25ee-4e99-b795-18f77f6cbc34@linux.intel.com>
Date: Thu, 5 Mar 2026 17:25:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 tony.lindgren@linux.intel.com, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-3-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260212143606.534586-3-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45B3E20E5D2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	TAGGED_FROM(0.00)[bounces-72803-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email]
X-Rspamd-Action: no action



On 2/12/2026 10:35 PM, Chao Gao wrote:
> TDX depends on a platform firmware module that is invoked via instructions
> similar to vmenter (i.e. enter into a new privileged "root-mode" context to
> manage private memory and private device mechanisms). It is a software
> construct that depends on the CPU vmxon state to enable invocation of
> TDX-module ABIs. Unlike other Trusted Execution Environment (TEE) platform> implementations that employ a firmware module running on a PCI device with
> an MMIO mailbox for communication, TDX has no hardware device to point to
> as the TEE Secure Manager (TSM).
> 
> Create a virtual device not only to align with other implementations but
> also to make it easier to
> 
>  - expose metadata (e.g., TDX module version, seamldr version etc) to
>    the userspace as device attributes
> 
>  - implement firmware uploader APIs which are tied to a device. This is
>    needed to support TDX module runtime updates
> 
>  - enable TDX Connect which will share a common infrastructure with other
>    platform implementations. In the TDX Connect context, every
>    architecture has a TSM, represented by a PCIe or virtual device. The
>    new "tdx_host" device will serve the TSM role.
> 
> A faux device is used as for TDX because the TDX module is singular within
> the system and lacks associated platform resources. Using a faux device
> eliminates the need to create a stub bus.
> 
> The call to tdx_get_sysinfo() ensures that the TDX Module is ready to

Nit:
There are "TDX module", "TDX-module" and "TDX Module" in the cover letter.
Better to align the style.

> provide services.
> 

[...]

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
> +	  support (CONFIG_INTEL_TDX_HOST). 

Nit:
A slight repetition: support for ... support.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> The module is called tdx_host.ko

[...]


