Return-Path: <kvm+bounces-25640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6690F967D55
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11F3F1F2176A
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2F018651;
	Mon,  2 Sep 2024 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kK5RdHjQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272EE63B9;
	Mon,  2 Sep 2024 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240456; cv=none; b=c3UIs8gTILh7+8POwfpNSCfDx/YRkFp7rRo+CWIlt31/VJYvp+ATPamw2d+CzJOJzo4xmY9yKoVOjh71FkNGaum5IMHhZBZgmN2R5PiZUsqR2Tc1KXmnoi5gQhgoVTWPf9dqrfoqJS+1NILHsluK4xoAV9cSYv0YqWuJOSGSuWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240456; c=relaxed/simple;
	bh=HeTAqEed+CsvSVxJIA6VToj4x6Lfo6eyxWgPYkYVyjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fI2hdwAsuc/cQm0foVe31kR6EW5Qqd9s+ux18YgqYihTZLGwuj1Wr4L2XdOhtvx/qHI6v86rfjmw/Iv4ZRh71K7NSZ2t1RqgXNBsnWgZmlvj9jkPXkJMIDAZAf9YY8+9SizsCfY/fftYcgAJD8zashO1yswkN0v9zg2Ye4hR20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kK5RdHjQ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725240454; x=1756776454;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HeTAqEed+CsvSVxJIA6VToj4x6Lfo6eyxWgPYkYVyjE=;
  b=kK5RdHjQjoeQf5T/pWHWTi08b3020X0QzZkVdCLsMwr+/jc84ImfRN5H
   BZ17xTWJ95AKlbnzG6j6I+zJWVheC/l7pTERJQBP1FmKr8XGCaGkBBH0k
   azMTNoZb6UPZNF2bNvwv9EXHnrUDtPVB3HpksnY8E/JZkaKjNL6ip14De
   zoqIZBZlliXdTsOXqHDq8jacg9pQg1BmRlnd4LxjPbv6ukVk1zH6BEvBS
   CeD2lTggiAMd0VJ9wG/wwvrDR70OiSffDh0rti7/JSC7ufr2IWvNFVyD9
   gnsVGqBhhMrW+tsaB3P8TV0K7ymocjWty/hsJ78cWHUDhqFFnloiD6oIp
   Q==;
X-CSE-ConnectionGUID: ul3sXAlNTEK1KL5jQymqyw==
X-CSE-MsgGUID: h7fRnn7vT4OT6mqSG+vYYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="34968091"
X-IronPort-AV: E=Sophos;i="6.10,194,1719903600"; 
   d="scan'208";a="34968091"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2024 18:27:34 -0700
X-CSE-ConnectionGUID: oHft2kWySemckoaLRRBfaA==
X-CSE-MsgGUID: /bXwErv0TwuRQZUYt4zDIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,194,1719903600"; 
   d="scan'208";a="87700571"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa002.fm.intel.com with ESMTP; 01 Sep 2024 18:27:31 -0700
Date: Mon, 2 Sep 2024 09:25:00 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <ZtUT7DzEgMeEMqqL@yilunxu-OptiPlex-7050>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
 <Zr21XioOyi0CZ+FV@yilunxu-OptiPlex-7050>
 <ZtFy8_etJ2tkQ8pm@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtFy8_etJ2tkQ8pm@tlindgre-MOBL1>

> > > +static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> > > +{
> > > +	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> > > +	struct kvm_tdx_capabilities __user *user_caps;
> > > +	struct kvm_tdx_capabilities *caps = NULL;
> > > +	int i, ret = 0;
> > > +
> > > +	/* flags is reserved for future use */
> > > +	if (cmd->flags)
> > > +		return -EINVAL;
> > > +
> > > +	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
> > > +	if (!caps)
> > > +		return -ENOMEM;
> > > +
> > > +	user_caps = u64_to_user_ptr(cmd->data);
> > > +	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
> > > +		ret = -EFAULT;
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (caps->nr_cpuid_configs < td_conf->num_cpuid_config) {
> > > +		ret = -E2BIG;
> > 
> > How about output the correct num_cpuid_config to userspace as a hint,
> > to avoid user blindly retries.
> 
> Hmm do we want to add also positive numbers for errors for this function?

No. I think maybe update the user_caps->nr_cpuid_configs when returning
-E2BIG. Similar to KVM_GET_MSR_INDEX_LIST.

Thanks,
Yilun

