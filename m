Return-Path: <kvm+bounces-73003-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KImbDZyfqmlLUgEAu9opvQ
	(envelope-from <kvm+bounces-73003-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:34:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D13B221E005
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 891A230F2019
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F412133858B;
	Fri,  6 Mar 2026 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UJc7vcN1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF7633B6EB;
	Fri,  6 Mar 2026 09:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789374; cv=none; b=HmsxKPmLWfreBKQSU6KQNJJatLrsCkRWW5Ji8Sn0rPkn6/gM90WtQRcCEdmSU6+GcQTnS7O3ZXQT+NEKM3HCSq0wO3xA3L0HXqnR1iJJ6b0DaOMisO0rKToh/rwhAP85F8hmEqY4kcyx8gSzIJQxB/sR3fulBDz7ATbHc/C4ZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789374; c=relaxed/simple;
	bh=0OeK1xoBa1DxJEcANYuVCZsFUuiXBKHgQAuKI/pJmYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j3L14ZrqZF2YI9yS/J6zbNxaptzDm6tjz2n3c4SP3elNdWBLVP/CgZEz5TqCVnXupOQoqLHfidC+FjBaGcUh57Gmvys6Jx17IDbkABHW/3Mz48RkzrbE0kihZ7J0+ihF/GlwugrefZAf8PVCdd0mGqh6fBqOP1C+P6NiM/kpSOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UJc7vcN1; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772789371; x=1804325371;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0OeK1xoBa1DxJEcANYuVCZsFUuiXBKHgQAuKI/pJmYk=;
  b=UJc7vcN1r3YADaq8+H7oSX44qGiPLiWX3XMfVtKAc6nGrq8IYerko+4u
   jJqrTBE26gUach34aQlEdmUeC4Ui13IsHm3itphKX6OlatLemVnKy4Iqz
   BhxLYo13NKvOZDR2wuePNGffCYxBjf3j/Y1sASnmub8cWOZVse6Q+KGNI
   k5nR4Ij0Bvk7ybuvC0wJgJEqgja45ZmCFlQOu1iK+8vNFiIqGGiv1u5q3
   X1OmD9ZEenHFSWT6z+PlBdGn4879ZDoXFS2461eT2sdpSkj8OOVFo//mY
   2jIqz3DsrpMj+M5N7F9swW9A6+9AGC6bqoDJ8TKzi7UDgNA8vowzNpcOS
   g==;
X-CSE-ConnectionGUID: tA9J5ADrThi65bPQDHky/g==
X-CSE-MsgGUID: N6L5qm8ZS8ql6nVl6Hw3jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="84528385"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="84528385"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:29:30 -0800
X-CSE-ConnectionGUID: KXi9/xecR22G/lz6UkdZzw==
X-CSE-MsgGUID: rhBRMKOyQIuJ9P9uXnoYnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="223649577"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.240.23]) ([10.124.240.23])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:29:24 -0800
Message-ID: <5b08961b-0faf-4e01-b0dd-f1f472697a18@linux.intel.com>
Date: Fri, 6 Mar 2026 17:29:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/24] coco/tdx-host: Expose P-SEAMLDR information via
 sysfs
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
 ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
 yilun.xu@linux.intel.com, sagis@google.com, vannapurve@google.com,
 paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
 seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
 dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
 tony.lindgren@linux.intel.com, Farrah Chen <farrah.chen@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-7-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260212143606.534586-7-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D13B221E005
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73003-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Action: no action



On 2/12/2026 10:35 PM, Chao Gao wrote:
> TDX Module updates require userspace to select the appropriate module
> to load. Expose necessary information to facilitate this decision. Two
> values are needed:
> 
> - P-SEAMLDR version: for compatibility checks between TDX Module and
> 		     P-SEAMLDR
> - num_remaining_updates: indicates how many updates can be performed
> 
> Expose them as tdx-host device attributes.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>


Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

Some nits below.

> ---
> v4:
>  - Make seamldr attribute permission "0400" [Dave]
>  - Don't include implementation details in OS ABI docs [Dave]
>  - Tag tdx_host_group as static [Kai]
> 
> v3:
>  - use #ifdef rather than .is_visible() to control P-SEAMLDR sysfs
>    visibility [Yilun]
> ---
>  .../ABI/testing/sysfs-devices-faux-tdx-host   | 23 +++++++
>  drivers/virt/coco/tdx-host/tdx-host.c         | 63 ++++++++++++++++++-
>  2 files changed, 85 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> index 901abbae2e61..88a9c0b2bdfe 100644
> --- a/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> +++ b/Documentation/ABI/testing/sysfs-devices-faux-tdx-host
> @@ -4,3 +4,26 @@ Description:	(RO) Report the version of the loaded TDX Module. The TDX Module
>  		version is formatted as x.y.z, where "x" is the major version,
>  		"y" is the minor version and "z" is the update version. Versions
>  		are used for bug reporting, TDX Module updates and etc.
> +
> +What:		/sys/devices/faux/tdx_host/seamldr/version
> +Contact:	linux-coco@lists.linux.dev
> +Description:	(RO) Report the version of the loaded SEAM loader. The SEAM
> +		loader version is formatted as x.y.z, where "x" is the major
> +		version, "y" is the minor version and "z" is the update version.
> +		Versions are used for bug reporting and compatibility checks.
> +
> +What:		/sys/devices/faux/tdx_host/seamldr/num_remaining_updates
> +Contact:	linux-coco@lists.linux.dev
> +Description:	(RO) Report the number of remaining updates. TDX maintains a
> +		log about each TDX Module which has been loaded. This log has
                                            ^
                                          that
> +		a finite size which limits the number of TDX Module updates
                             ^
                             ,
> +		which can be performed.
                  ^
                that
> +
> +		After each successful update, the number reduces by one. Once it
> +		reaches zero, further updates will fail until next reboot. The
> +		number is always zero if the P-SEAMLDR doesn't support updates.
> +
> +		See Intel® Trust Domain Extensions - SEAM Loader (SEAMLDR)
> +		Interface Specification, Revision 343755-003, Chapter 3.3
> +		"SEAMLDR_INFO" and Chapter 4.2 "SEAMLDR.INSTALL" for more
> +		information.
> diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
> index 0424933b2560..fd6ffb4f2ff1 100644
> --- a/drivers/virt/coco/tdx-host/tdx-host.c
> +++ b/drivers/virt/coco/tdx-host/tdx-host.c
> @@ -11,6 +11,7 @@
>  #include <linux/sysfs.h>
>  
>  #include <asm/cpu_device_id.h>
> +#include <asm/seamldr.h>
>  #include <asm/tdx.h>
>  
>  static const struct x86_cpu_id tdx_host_ids[] = {
> @@ -40,7 +41,67 @@ static struct attribute *tdx_host_attrs[] = {
>  	&dev_attr_version.attr,
>  	NULL,
>  };
> -ATTRIBUTE_GROUPS(tdx_host);
> +
> +static struct attribute_group tdx_host_group = {
> +	.attrs = tdx_host_attrs,
> +};
> +
> +static ssize_t seamldr_version_show(struct device *dev, struct device_attribute *attr,
> +				    char *buf)
> +{
> +	struct seamldr_info info;
> +	int ret;
> +
> +	ret = seamldr_get_info(&info);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u.%u.%02u\n", info.major_version,
> +					       info.minor_version,
> +					       info.update_version);
> +}
> +
> +static ssize_t num_remaining_updates_show(struct device *dev,
> +					  struct device_attribute *attr,
> +					  char *buf)
> +{
> +	struct seamldr_info info;
> +	int ret;
> +
> +	ret = seamldr_get_info(&info);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "%u\n", info.num_remaining_updates);
> +}
> +
> +/*
> + * Open-code DEVICE_ATTR_ADMIN_RO to specify a different 'show' function
> + * for P-SEAMLDR version as version_show() is used for TDX Module version.
> + *
> + * admin-only readable as reading these attributes calls into P-SEAMLDR,
      ^
      Admin-only
> + * which may have potential performance and system impact.
> + */
> +static struct device_attribute dev_attr_seamldr_version =
> +	__ATTR(version, 0400, seamldr_version_show, NULL);
> +static DEVICE_ATTR_ADMIN_RO(num_remaining_updates);
> +
> +static struct attribute *seamldr_attrs[] = {
> +	&dev_attr_seamldr_version.attr,
> +	&dev_attr_num_remaining_updates.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group seamldr_group = {
> +	.name = "seamldr",
> +	.attrs = seamldr_attrs,
> +};
> +
> +static const struct attribute_group *tdx_host_groups[] = {
> +	&tdx_host_group,
> +	&seamldr_group,
> +	NULL,
> +};
>  
>  static struct faux_device *fdev;
>  


