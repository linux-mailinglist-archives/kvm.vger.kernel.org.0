Return-Path: <kvm+bounces-69727-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA+sMo2/fGlVOgIAu9opvQ
	(envelope-from <kvm+bounces-69727-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:26:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A31CBB96C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FC25303351A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCAD319855;
	Fri, 30 Jan 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bOZX1Rdw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDB130EF9B;
	Fri, 30 Jan 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769783141; cv=none; b=a8GnEI8u1p6oJZaS0MYrfCa06x5fcSzltBpBHqfbO9Yx0eb7Jpr7vh9rJ5z+JtdR1aDyK70lCrhFDMro4m0OkwyxsxxdwXJmLSwixfvJNu2HBGWMxgc7897B6nBbbixrNTk4spFeECrJUYFakCHLonRBCSdzLhMLp4izPHXBvl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769783141; c=relaxed/simple;
	bh=wlIEF5Jo3bz9SPk/4gkEUeNy6rbBrlP5v2SRrMJhK1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dsb2aFO2GxOfOwX7mFOvUELJ3pkQSg87aU1LOnqXh6vUYUU3o7ArEhmXqLYlraHkLLLIqTGFMVUiWrDBXiP8Lrw6oNgWbTiAKjCy/u0wvRk92vRObbT0RcDZWGG6IpcPIfQonpNz05FTjHlM8nJXPGcTXgFf26QsgUyM5WBFiLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bOZX1Rdw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769783138; x=1801319138;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wlIEF5Jo3bz9SPk/4gkEUeNy6rbBrlP5v2SRrMJhK1g=;
  b=bOZX1RdweEby068EBnvqN5SwoWm39hRLuxxLXWdDXcd+MaXW8y/69L1+
   FeFYON5OJkyME5vr8wLNWPKkxWa8rZIG1z/pArUuKjLu3NzNsunSf9FsA
   oTERo5i6HeVQ1DH0WpMo9+uFS17ZKt78svbJQGLT6mHNI4X+f/7el1mfH
   MXx+31S6lxYEWwkG9aTPygJbofg0ol8VoI8z4cGg9FvkS+PZgIu0WyGxy
   wegPs4yQbN0msgyg5xmIYTu6tycnUYDt4DdRsDxi3GFCxJYoeZ6BM5mEr
   WoH3mfNDlUqo8YzXTWQo5lmYiaiyIUb94KbmhGPZDoNBOD1EhkkhtxhhM
   Q==;
X-CSE-ConnectionGUID: c2gkfwVEQDioeRjycswYxw==
X-CSE-MsgGUID: HvIILaEhRUawWsTIE6Vr1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82458399"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="82458399"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 06:25:37 -0800
X-CSE-ConnectionGUID: JrY8CnCkSFqu0MIvcbv6hg==
X-CSE-MsgGUID: P0tzny3USouHXQWhjxOdAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="213396410"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 30 Jan 2026 06:25:34 -0800
Date: Fri, 30 Jan 2026 22:07:17 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI
 for TDX Module updates
Message-ID: <aXy7FTKDBfZ4jXt1@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-11-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-11-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69727-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5A31CBB96C
X-Rspamd-Action: no action

> +static enum fw_upload_err tdx_fw_write(struct fw_upload *fwl, const u8 *data,
> +				       u32 offset, u32 size, u32 *written)
> +{
> +	struct tdx_fw_upload_status *status = fwl->dd_handle;
> +	int ret;
> +
> +	if (status->cancel_request) {
> +		status->cancel_request = false;
> +		return FW_UPLOAD_ERR_CANCELED;

We don't allow partial write, we stop_machine while writing, so we
cannot possibly cancel the update in progress, so we only check the
cancel_request once before first write. That means cancel is useless for
our case. Is it better we delete all the cancel logic &
struct tdx_fw_upload_status?

> +	}
> +
> +	/*
> +	 * tdx_fw_write() always processes all data on the first call with
> +	 * offset == 0. Since it never returns partial success (it either
> +	 * succeeds completely or fails), there is no subsequent call with
> +	 * non-zero offsets.
> +	 */
> +	WARN_ON_ONCE(offset);
> +	ret = seamldr_install_module(data, size);

...

> +static void tdx_fw_cancel(struct fw_upload *fwl)
> +{

Unfortunately fw_upload core doesn't allow .cancel unimplemented, leave
it as a dummy stub is OK, since this callback just request cancel,
doesn't care whether the cancel succeeds or fails in the end.

If you agree, add some comments in this function.

> +}
> +
> +static const struct fw_upload_ops tdx_fw_ops = {
> +	.prepare = tdx_fw_prepare,
> +	.write = tdx_fw_write,
> +	.poll_complete = tdx_fw_poll_complete,
> +	.cancel = tdx_fw_cancel,
> +};
> +
> +static void seamldr_init(struct device *dev)
> +{
> +	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!tdx_sysinfo))
> +		return;

We already does tdx_get_sysinfo() on module_init, is it better we have
a global tdx_sysinfo pointer in this driver, so that we don't have to
retrieve it again and again.

