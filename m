Return-Path: <kvm+bounces-69299-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id X2HPOVpmeWmGwwEAu9opvQ
	(envelope-from <kvm+bounces-69299-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:28:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB4A9BE95
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2BC26300C03C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B024E2367CF;
	Wed, 28 Jan 2026 01:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZzmEMqLt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E51E98EF;
	Wed, 28 Jan 2026 01:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769563735; cv=none; b=Fk9niQoXJm0Otj7Wad6/kLaPGDLXyICUzuQxszChkIlHdXb8VuLO35OOnk59xsj7pPE+RmhLPwd2eZFm2rJRSVSJnsL9tfdayfbXPwhvGazdj7CEEnYo8I8HBGsbb+OCE1YjiTb2AfleL0Hx83Oh9l3E7xI8mlFyGY1NnOBs/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769563735; c=relaxed/simple;
	bh=4PS/2I4zxqlYCU5FIN14VbPjuGcAz/bqB5Zhvwewq7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UVeGWWzXhJ9Pc0JA+jykijajrAF1f01suK4Sd1Pm1ZNkhHJU7jFDD1xHI04ifd8JXTrnZWs/0NONO93VUdJsi5lYrD77WJ1mgX4SGVjpYIoILYTH+LsFIJ8enp1FMVPJJqeoiZLMwLs9bLXiDwfildVbCByO0EMqhIYD+7szwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZzmEMqLt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769563733; x=1801099733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4PS/2I4zxqlYCU5FIN14VbPjuGcAz/bqB5Zhvwewq7I=;
  b=ZzmEMqLtdXq2xr04dfff6tZumhdZQH7WZdll+dzyw6xaC+E5payv4Ovp
   HKkONDCKd/Vp+Itwc2Rla879lxOcA7CKUy5l6NVz6q8ve3/qS2YgSdCov
   oqmqVHiduN3DJk6Lf/ZYqgzMc6cJ+hP485xWewJI1VIJ4AG2fZ8ldkUvW
   pIGeJIfjCuVVNU9DOndrLJx9TWV0lP8FxdJ14RLj/yT+5IVi69SuN4EhM
   nGnMWz2Spzd5cnspYpjX0q/OXbwRQI2x4WDXRBdn3/SUj2YbcKdf+9c/a
   siJPxfgB8fPdeHXA1y3aqQbZt9z+tOV3t2roCo/PXvwk3hbj1WuhEfDuo
   A==;
X-CSE-ConnectionGUID: tBjJ53pqRNqPk/OY1ws9Jg==
X-CSE-MsgGUID: H+1q+fY4TdmcNvTw1KiYHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70826382"
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="70826382"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 17:28:52 -0800
X-CSE-ConnectionGUID: U+GINjxRRGyeq6iPvmbzFA==
X-CSE-MsgGUID: 2ROBTmqzQjSuVnmCSNirFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,257,1763452800"; 
   d="scan'208";a="208023658"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 17:28:47 -0800
Message-ID: <c71bac0e-0695-4aa3-bcfd-a369819a1539@linux.intel.com>
Date: Wed, 28 Jan 2026 09:28:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/26] x86/virt/tdx: Print SEAMCALL leaf numbers in
 decimal
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-2-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260123145645.90444-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,linux.intel.com:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69299-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: CBB4A9BE95
X-Rspamd-Action: no action



On 1/23/2026 10:55 PM, Chao Gao wrote:
> Both TDX spec and kernel defines SEAMCALL leaf numbers as decimal. Printing
> them in hex makes no sense. Correct it.
> 
> Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Zhenzhong Duan <zhenzhong.duan@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> v2:
>  - print leaf numbers with %llu
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 5ce4ebe99774..dbc7cb08ca53 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -63,7 +63,7 @@ typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
>  
>  static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
>  {
> -	pr_err("SEAMCALL (0x%016llx) failed: 0x%016llx\n", fn, err);
> +	pr_err("SEAMCALL (%llu) failed: 0x%016llx\n", fn, err);
>  }
>  
>  static inline void seamcall_err_ret(u64 fn, u64 err,


