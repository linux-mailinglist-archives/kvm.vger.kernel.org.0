Return-Path: <kvm+bounces-72126-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id URFPG/4joWkyqgQAu9opvQ
	(envelope-from <kvm+bounces-72126-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 05:56:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 239F01B2C23
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 05:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6ACBF30774F7
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 04:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5233936213D;
	Fri, 27 Feb 2026 04:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gQHObmNa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E9362123;
	Fri, 27 Feb 2026 04:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772168184; cv=none; b=tXBSRbfXFHhHNrQKTQha1DNW6IjGdA/QXmYnlGyfyVIiRsnw8JSPsg5Tj3OPhqfGeh4OZ8c0x2vJ9ci5DI9JkcbwVsHWn0TNsRmEiuuIAk+4Ldoszu9ike1ZaWaR3n2x8xfR2scuCZah/Ubfbc4D33VdmLuCNx32vOBs4Ru09vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772168184; c=relaxed/simple;
	bh=nDeaw38rPshT03jjkT3uQl/RqQdQkYbrxWEtJ1hFdCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMAlsO8OGQGpr5qoa2LcUccz6bp7CuvQLgOYCQYeng9FuFCRDfFLqBWBaIOe2f+0FNn6iiu3Rw0uPjN3zFNQ+MCmw6ixSBjtPRFWMaPscWAtM8MCGuVeZmd5w7g3HczYE+ofocyq+r6zGGcegS1iQRjxaJjp0WLV0Me3chzdwGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gQHObmNa; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772168183; x=1803704183;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nDeaw38rPshT03jjkT3uQl/RqQdQkYbrxWEtJ1hFdCg=;
  b=gQHObmNaTm4UKp8OgCxJLQpIP2+xh01he6xdaYiosHDpLh+lu3QzUvVc
   hCy7fsERDYwPSP9EUNDkdNdY9zaM5SQQtGBLXNmabXkQcN5aB2ydFGyxB
   GdVHkwsAPmryu02dN1zQGLtevHyaAgpfLsv6F4qSdmz5Xvgw5f5Ceo62Q
   TGjpT0+/ky+CaBbfhkSyNL1x+Y02o0n98AVty2EZkVVB+P0Sc08EBdOzE
   r99lJStrUTUfaUoNU3XO1xti34u9ge80WmuC7PGpyEBSxmVyXIrDeE9NV
   8AYpWTBJFQ6lq36PjJxM8YHxIRDVMfoyObfhCNFccYEXTC+PKSp9yT1g7
   w==;
X-CSE-ConnectionGUID: ghPkxYpPR069ZEg9yC2zWA==
X-CSE-MsgGUID: BFF1P5CpSx28qhA/Fa740g==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73352075"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="73352075"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 20:56:23 -0800
X-CSE-ConnectionGUID: tcggdKxdQ7K4+emj77fcQQ==
X-CSE-MsgGUID: xhtfEnvlR4+ufl+nCKapxg==
X-ExtLoop1: 1
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa003.fm.intel.com with ESMTP; 26 Feb 2026 20:56:17 -0800
Date: Fri, 27 Feb 2026 12:36:41 +0800
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
Message-ID: <aaEfWZ8cO+NvNAOI@yilunxu-OptiPlex-7050>
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
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72126-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[25];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 239F01B2C23
X-Rspamd-Action: no action

> +static void seamldr_init(struct device *dev)
> +{
> +	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!tdx_sysinfo))
> +		return;
> +
> +	if (!tdx_supports_runtime_update(tdx_sysinfo)) {
> +		pr_info("Current TDX Module cannot be updated. Consider BIOS updates\n");
> +		return;
> +	}
> +
> +	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "tdx_module",
> +					   &tdx_fw_ops, NULL);
> +	ret = PTR_ERR_OR_ZERO(tdx_fwl);
> +	if (ret)
> +		pr_err("failed to register module uploader %d\n", ret);
> +}
> +
> +static void seamldr_deinit(void)
> +{
> +	if (tdx_fwl)
> +		firmware_upload_unregister(tdx_fwl);
> +}

You could use devm_add_action_or_reset() in seamldr_init():

 1. to delete tdx_host_remove().
 2. to delete the global tdx_fwl;

> +
> +static int tdx_host_probe(struct faux_device *fdev)
> +{
> +	/*
> +	 * P-SEAMLDR capabilities are optional. Don't fail the entire
> +	 * device probe if initialization fails.
> +	 */
> +	seamldr_init(&fdev->dev);
> +
> +	return 0;
> +}
> +
> +static void tdx_host_remove(struct faux_device *fdev)
> +{
> +	seamldr_deinit();
> +}

