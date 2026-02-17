Return-Path: <kvm+bounces-71145-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEp1Is0alGn//wEAu9opvQ
	(envelope-from <kvm+bounces-71145-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 08:37:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DA6149378
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 08:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BC07301E973
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 07:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C64D2D061C;
	Tue, 17 Feb 2026 07:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y7Vx1oyi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4F417993;
	Tue, 17 Feb 2026 07:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771313841; cv=none; b=oAxVSThr7SPto93ikB3tySreEAEqhul/p3+yDYs6ttunzgSbu6wRw6NOiW/3ri3POjtD1s3CDyYsnlNikOk/cBYirveNURVZ/JwpDwir11H03e8vWF4HDGFyoMkHqWxGo5K843RHl+s9QJQyo65BEpv5h4laqB9qgSJlGVFLvWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771313841; c=relaxed/simple;
	bh=XSWmQ5Q2T83opbinLmZ8f9am/l/FKUxJwfKSpZTC5NU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+4d9yii/+80GLzniTVTA/YA0miA6HhJOHMl6nUpiQmeAm9HzXsVzdAJ3WAZGldakM+UYr7YgtmtwPdkUYe/3dZC3GemaaaqxfMVH+JDyD2A4JhNqTluVW5AD3Wz3BdINzhdvbGooodoFvpdVN6oQXjYsS0xRZ/CTp+T4TrD9lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y7Vx1oyi; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771313840; x=1802849840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XSWmQ5Q2T83opbinLmZ8f9am/l/FKUxJwfKSpZTC5NU=;
  b=Y7Vx1oyigFAaRgx+oEfXpn14jK5eKciPt9xCIk4hZtJ/ztUULyx3cbWS
   XTZ0VwbNKdNzlqYPu2+NUJk8ihjD4x3Cykf2orIEjjRp+MycxS63W1reh
   D+222sR71e0cZrFhTF8McLULjbMuIXuhTl676POxyOJzR9P46TWW1VoTr
   oNkwyIpCrJi7O99yFTtm2MRzzY+1ZKmmi5BnlcdlBxtiivRwNFkm8EUx8
   lqpwK/5wyKoUYlh52rO2tHOisMe8b44toe2qdLstSqFmEVpyHVefKKOxE
   9I6ZBeVg+9zG2N1kRXPQaQ3KZaZy/IXLmNLaklanC56aJwaI+jPGpAPSv
   A==;
X-CSE-ConnectionGUID: NRR6z/8uQna+MUHVuBOoSw==
X-CSE-MsgGUID: gd8Rb3lmQQCElrwVTlbC5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="71401330"
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="71401330"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 23:37:19 -0800
X-CSE-ConnectionGUID: LdqnNc1GRH+1x84n5vz4Ig==
X-CSE-MsgGUID: VWF8P4W1TpSoYC5SMN2w4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,295,1763452800"; 
   d="scan'208";a="218342646"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.246.23])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 23:37:14 -0800
Date: Tue, 17 Feb 2026 09:37:11 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <aZQapxvo1zijUl0L@tlindgre-MOBL1>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117022311.2443900-7-yilun.xu@linux.intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71145-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.lindgren@linux.intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E8DA6149378
X-Rspamd-Action: no action

On Mon, Nov 17, 2025 at 10:22:50AM +0800, Xu Yilun wrote:
> @@ -296,6 +297,257 @@ static __init int build_tdx_memlist(struct list_head *tmb_list)
>  	return ret;
>  }
>  
> +#define TDX_PAGE_ARRAY_MAX_NENTS	(PAGE_SIZE / sizeof(u64))
...

> +/*
> + * For holding less than TDX_PAGE_ARRAY_MAX_NENTS (512) pages.

The comment should be "For holding at most TDX_PAGE_ARRAY_MAX_NENTS.."

> + * If more pages are required, use tdx_page_array_alloc() and
> + * tdx_page_array_fill_root() to build tdx_page_array chunk by chunk.
> + */
> +struct tdx_page_array *tdx_page_array_create(unsigned int nr_pages)
> +{
> +	int filled;
> +
> +	if (nr_pages > TDX_PAGE_ARRAY_MAX_NENTS)
> +		return NULL;

To match this check.

> +	struct tdx_page_array *array __free(tdx_page_array_free) =
> +		tdx_page_array_alloc(nr_pages);
> +	if (!array)
> +		return NULL;
> +
> +	filled = tdx_page_array_fill_root(array, 0);
> +	if (filled != nr_pages)
> +		return NULL;
> +
> +	return no_free_ptr(array);
> +}
> +EXPORT_SYMBOL_GPL(tdx_page_array_create);

Regards,

Tony

