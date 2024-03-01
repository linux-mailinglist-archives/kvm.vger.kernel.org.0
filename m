Return-Path: <kvm+bounces-10584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5D886DB5C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F81E1C22843
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 06:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5CE5F546;
	Fri,  1 Mar 2024 06:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M5Wn+Xrs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB7F5BACB
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 06:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709273624; cv=none; b=i4mHqFHtdzePkVEmi2V91WeXT62Z1AiA5VPJc8McviW+Qj4RAwWlQ5LeWDrvfvVzAmpIwyQsYJYktpbyjNuK0fbSHo0LAKs/5YqAinBgtjiDnA3zICGrXHugVBrYH8IpEH9CxBqxv/AhjQAO6NplzldX0/BgEtK3V6m2csLRjaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709273624; c=relaxed/simple;
	bh=ABzgXBkkjDlPMcqWgp0yAfaZ1RTYJeUZYbJyt6Q83cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hA/R4SkOs+t3+dR6icStHVm1DHnzfzESlhf1xhveUY8DpebokD/krMYerzm1h6RD2W9XuDCDMlMt0oYxiDd3zKVY9mnEsZR7yO3pCILdV+h/aI7Bz1K05dIKvff0I8DDK/RNpzpmwLTfht4LLU/q+R2eMw9+LhEz2jg7p76uIaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M5Wn+Xrs; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709273623; x=1740809623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ABzgXBkkjDlPMcqWgp0yAfaZ1RTYJeUZYbJyt6Q83cs=;
  b=M5Wn+XrsbD2/A7OvommyRIgUnSmuzoBp6Ov2oMS2sIq1dlGkg5kmfLQL
   5wG6/yG2aU7GdQhssr5Q5AXOnrgpLYOveFpWR1sF5lrqj43g4/Wnh6WeO
   bSuiQb9so2JXWeoWmiqrUE3uiYfqUogLBm61n3frdQ999n81rcKMahVse
   8Zkvko8jL7NhcDVG5P5p3hu75HIA/q7/kzMRhlyY5e+0aDNV/XDFRTViq
   tDFs0Fsjo3SM74nL7+OZtLXMUKpxiMzY8+Ij07mq1taa7FX+pAad/Jb1L
   KQw+XcAyzzg/OLG+mSdbgqkQpHgKCmTXaD9JfQIghJVEIwRD9iJCbUEcM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14363535"
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="14363535"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 22:13:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,195,1705392000"; 
   d="scan'208";a="12770279"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 29 Feb 2024 22:13:37 -0800
Date: Fri, 1 Mar 2024 14:27:21 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 18/21] hw/i386/pc: Support smp.modules for x86 PC
 machine
Message-ID: <ZeF1SR55ellwNyji@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-19-zhao1.liu@linux.intel.com>
 <3ab53ea9-be77-4ee7-9247-d89c0ec62346@amd.com>
 <ZeAzB/ISM+g/XGa3@intel.com>
 <a67f6856-e5d5-4fb4-a94d-7748979bbbe9@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a67f6856-e5d5-4fb4-a94d-7748979bbbe9@amd.com>

> >> You have added drawers, books here. Were they missing before?
> >>
> > 
> > ...so yes, I think those 2 parameters are missed at this place.
> 
> ok. If there is another revision then add a line about this change in the
> commit message. Otherwise it is fine.
> 
> Reviewed-by: Babu Moger <babu.moger@amd.com>
>

Sure! Thank you.

-Zhao


