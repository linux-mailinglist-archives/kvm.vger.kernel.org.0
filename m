Return-Path: <kvm+bounces-25651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5BB967EAC
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC2DD1C21868
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 05:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031991509AF;
	Mon,  2 Sep 2024 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JI/CA88d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC93E24B26;
	Mon,  2 Sep 2024 05:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725253520; cv=none; b=qNtqzgL14vNKQ8EZ4LeTFFyF1GLrZ/KnfNcxm6N8Liheh+BweYM7jSmesMGM0tlJrshjom/rFiIy5pPSqvycfyOIcNKs/PSRgmW1DKRf5dWSfb/AtjUDlNeGSB4Ppeo+23MofJ7g8+OWgIBM8OVX6qYtWjjQrWmBWsvnYwSpilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725253520; c=relaxed/simple;
	bh=B9tCdk5mdOIhjK5shthJXYwnLiBntGJXQsF4Ey7rqnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k54PbNFcQGNvzsXpthivdSKzGsEhZkARMv9JF7nQDkck1gU6ktVl4WYZI7TymWCiEePmMR5RC15srUun8Ng0cD7i9yNEXvMSnVOmemiK9Y9jzyMTP9niSXtxRsHX6VqZh3avGJ/YDqpXbBhIW5+lPekWQvxSQhW2YfJx7a11ntM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JI/CA88d; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725253519; x=1756789519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B9tCdk5mdOIhjK5shthJXYwnLiBntGJXQsF4Ey7rqnQ=;
  b=JI/CA88d7cAFoZihgsupGWRZp6GwUomEGQYiUfDzKUumNCFJ+D7vhHYT
   6T2twYS8ykOK9OCBcU4c+herdaFXNlJLGsOzZ4o8pW81SS1TsJNXAbi0Z
   XLAVlHZmK/taWU2ZtmJ8cyXf92uXpns9zRywv53TkHkX7CMNvgmUYxUAv
   pn3ewWvtpuG4xyxHxitDvbi80ueWqkFianH35gJFuaWvyVhG/3TktinXk
   uhiZJJ4prESeTnzZpimvqYul9SdWuAFdhCS3pwSi2lrz/dsRomXjyBdR6
   ahy8OwqRoW4mRpKCehdTTMUbeIrKhSP0RsFUPdmmb0gHTALCl2/mYLwO7
   g==;
X-CSE-ConnectionGUID: oElaa61IRbmPFJHj9rqa+g==
X-CSE-MsgGUID: cILXFjT8RseuYdaOAzmCRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23627039"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23627039"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2024 22:05:18 -0700
X-CSE-ConnectionGUID: 7pT7KDQbS5WjAIsN2mWapQ==
X-CSE-MsgGUID: jYZKwpsxSd6KjMLfPNEINQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="69380595"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.223])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2024 22:05:14 -0700
Date: Mon, 2 Sep 2024 08:05:08 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <ZtVHhC24JKnwNCIC@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
 <Zr21XioOyi0CZ+FV@yilunxu-OptiPlex-7050>
 <ZtFy8_etJ2tkQ8pm@tlindgre-MOBL1>
 <ZtUT7DzEgMeEMqqL@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtUT7DzEgMeEMqqL@yilunxu-OptiPlex-7050>

On Mon, Sep 02, 2024 at 09:25:00AM +0800, Xu Yilun wrote:
> > > > +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> > > > +{
> > > > +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> > > > +	struct kvm_tdx_capabilities __user *user_caps;
> > > > +	struct kvm_tdx_capabilities *caps = NULL;
> > > > +	int i, ret = 0;
> > > > +
> > > > +	/* flags is reserved for future use */
> > > > +	if (cmd->flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> > > > +	if (!caps)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	user_caps = u64_to_user_ptr(cmd->data);
> > > > +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> > > > +		ret = -EFAULT;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (caps->nr_cpuid_configs < td_conf->num_cpuid_config) {
> > > > +		ret = -E2BIG;
> > > 
> > > How about output the correct num_cpuid_config to userspace as a hint,
> > > to avoid user blindly retries.
> > 
> > Hmm do we want to add also positive numbers for errors for this function?
> 
> No. I think maybe update the user_caps->nr_cpuid_configs when returning
> -E2BIG. Similar to KVM_GET_MSR_INDEX_LIST.

OK thanks for clarifying, yes that sounds nice.

Regards,

Tony

