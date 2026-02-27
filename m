Return-Path: <kvm+bounces-72124-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0M+KG50UoWnoqAQAu9opvQ
	(envelope-from <kvm+bounces-72124-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 04:50:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6AC1B265D
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 04:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C076C303D5DF
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 03:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF4953396E6;
	Fri, 27 Feb 2026 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b5cMLeKB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE403382E6;
	Fri, 27 Feb 2026 03:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772164239; cv=none; b=E/I9WLNpiArAoz/K6UPZCX3jNZyqPbuDOMGK0nkLITioJAOL2mbR/9U3T7ipVXbu2qE7eQyR88ShmdHqJ4xAjES2twjp48wvtzs49wWYu8uWbeEp8j7j3PHcRvtL0U4QYp6w+lb7z6raqvLOGQ3AGbVy43PtW+soZqVgMvHh6/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772164239; c=relaxed/simple;
	bh=Fp3Af9sC3U/2ejHXeORnJoS925f6JSqgvZ0AyURYhck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwkXcSfsRLeMeeMqrHygXi+QbnW+L3P3z6TmS8Dde8S2PoIqx/qJpv1Soff/kU4R9fGkMWPiQShoCB6mVXlYWaCq/xqaHKUC8g3SN+YcyIq+J1sObsabmgPfXYnekJmlTTkY4InrcsmzOV2fxQeU8ZcWGXOQeQH8tgQgJ4tjJPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b5cMLeKB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772164238; x=1803700238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fp3Af9sC3U/2ejHXeORnJoS925f6JSqgvZ0AyURYhck=;
  b=b5cMLeKBrudLrClH7pt/LkhQIMk5Aw4DSpJX4D3tFiyAPmSCwu28HIcS
   O3l7vF0N+xKEqbG/pDS/CtPePAW5lZTHKA88qnibHHXNCfGnkO5j/u+lE
   PrpNBW0doYYARSMOZukVdyK+5Txe2B9EXxYjDPz/Ck6aBeUUzlCWwLhEW
   wWDpWYVtvhTqAL3N+1uMABWdg7C879Sbxbl/AGGWZtM4pdaGGDxW3tmos
   JpaKQyWYHEJIMs1pdaYrRo2NMUWbx+wOAbML+vMvpqZyle1Ea3c3lcVNv
   QecXm1nRJdF71faurcduuKy0fVf7zSbEVBBZvmlK0bTtHn4zvxrE/uGT3
   A==;
X-CSE-ConnectionGUID: eO1y/V2FT1CJu0zNxU52RQ==
X-CSE-MsgGUID: iIAoSyjWTReTocaddWlMmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="83574403"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="83574403"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 19:50:37 -0800
X-CSE-ConnectionGUID: BhfJntGqTVmGurXBbTRGEQ==
X-CSE-MsgGUID: 6NkLl7A1SauITZsPHxHccQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="214671628"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 26 Feb 2026 19:50:32 -0800
Date: Fri, 27 Feb 2026 11:30:56 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com, tony.lindgren@linux.intel.com,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 07/24] coco/tdx-host: Implement firmware upload sysfs
 ABI for TDX Module updates
Message-ID: <aaEP8CbLCc69U45Z@yilunxu-OptiPlex-7050>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-8-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212143606.534586-8-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72124-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RBL_SEM_FAIL(0.00)[172.232.135.74:query timed out];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: 5B6AC1B265D
X-Rspamd-Action: no action

> v3:
>  - clear "cancel_request" in the "prepare" phase [Binbin]
>  - Don't fail the whole tdx-host device if seamldr_init() met an error
>  [Yilun]

Sorry I didn't continue the discussion in that thread, but I meant to
just skip -EOPNOTSUPP, but not hide real problems.

Not sure if it makes sense to other people, if yes, some changes below:

...

> +static void seamldr_init(struct device *dev)
> +{
> +	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!tdx_sysinfo))
> +		return;
                return -ENXIO;

> +
> +	if (!tdx_supports_runtime_update(tdx_sysinfo)) {
> +		pr_info("Current TDX Module cannot be updated. Consider BIOS updates\n");
> +		return;
                return -EOPNOTSUPP;

> +	}
> +
> +	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "tdx_module",
> +					   &tdx_fw_ops, NULL);
> +	ret = PTR_ERR_OR_ZERO(tdx_fwl);
> +	if (ret)
> +		pr_err("failed to register module uploader %d\n", ret);

        return ret;
> +}

...

> +
> +static int tdx_host_probe(struct faux_device *fdev)
> +{
> +	/*
> +	 * P-SEAMLDR capabilities are optional. Don't fail the entire
> +	 * device probe if initialization fails.

I think no need the comments, all features are optional unless
explicitly required. So only exceptions need comments. Instead the code
may explain better.

> +	 */
> +	seamldr_init(&fdev->dev);

	ret = seamldr_init(&fdev->dev);
	if (ret && ret != -EOPNOTSUPP)
		return ret;

I imagine TDX Connect could follow the same pattern right below.

> +
> +	return 0;
> +}

