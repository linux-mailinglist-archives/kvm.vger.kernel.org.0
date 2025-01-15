Return-Path: <kvm+bounces-35532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6992AA12396
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BCF8167CBB
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA0A21858C;
	Wed, 15 Jan 2025 12:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZugvwQkt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF68B2475CC
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 12:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736943152; cv=none; b=PfefStVMVpOx2/7HxWEBFTAqWgDXdGaLKpnlXyfAryMWdL1l2zOCFiPaR0JgfQ62nmgFJbcdWkntNFdjNMXB7IyTE+ZRM7rH+1KP3AYUyzuJkYfFDrNJCqRHwzZJUjHgt3gNM/X6I0+dREk5rtnqDmAweQIK2bSRXjeJpnW6gDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736943152; c=relaxed/simple;
	bh=mC1XC4djPCDE99XU+hCt7StagXy+WLInG1/ESF761V4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cs2Xf//eXb1c5vwN4MHGZ4TcJmsZB9sogCNRGadXkvdw9OdowfsHhm/EN4kDPq+xDwyeeSraR8bBf8BEXMLNYQxuztUXtKdx720e+AP9jL7D1Z3qR+apdgme3mBrcNhZna3WVIg7xqQB1yO21yPYqLZ5Hg21ZxWpekOSDO6WJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZugvwQkt; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736943151; x=1768479151;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mC1XC4djPCDE99XU+hCt7StagXy+WLInG1/ESF761V4=;
  b=ZugvwQktGn26fWipvqQXvLG/26o5z4V1CDTHfE7AGtO8Eia20IWxSviG
   TgT6W6lkccUE047CSguFc5KPPOOPP4wXyV6S52u77j+aVqMrUUsALL61T
   7QvgSkQfrv6Xsw/HQA2dttGiLy5ou+AToQhlv+7lGD9xXKcJ0fcGgtBSR
   AeBukGs09LqVQjvmIAgH9bJ/3cSC328miw937CsMEuZBmWjWrOrU0sztg
   n5BGMF03QNt5MTLPhezCGasMH2QQz5NpWf6Ragaa66NUVVtZaQ51i7mB2
   BAdYtuCSxVvq9ku0gUfRkDqaogHZQcSf5XqixI69hNJ4WnSxZIeuzMAu+
   A==;
X-CSE-ConnectionGUID: rl5jDpwDTtqdEAh0kFvc1w==
X-CSE-MsgGUID: rv/s8XYeSBiULTempATLuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="41037581"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="41037581"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 04:12:30 -0800
X-CSE-ConnectionGUID: s0GYpNuFTU6eWWueralUcQ==
X-CSE-MsgGUID: 5/95xIS+TsSjrweD/IvTGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="105078639"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 04:12:23 -0800
Date: Wed, 15 Jan 2025 14:12:20 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"riku.voipio@iki.fi" <riku.voipio@iki.fi>,
	"imammedo@redhat.com" <imammedo@redhat.com>,
	"Liu, Zhao1" <zhao1.liu@intel.com>,
	"marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
	"anisinha@redhat.com" <anisinha@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"armbru@redhat.com" <armbru@redhat.com>,
	"philmd@linaro.org" <philmd@linaro.org>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"eblake@redhat.com" <eblake@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"wangyanan55@huawei.com" <wangyanan55@huawei.com>,
	"berrange@redhat.com" <berrange@redhat.com>
Subject: Re: [PATCH v6 09/60] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <Z4emJKi8LBnYKUUw@tlindgre-MOBL1>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-10-xiaoyao.li@intel.com>
 <1235bac6ffe7be6662839adb2630c1a97d1cc4c5.camel@intel.com>
 <c0ef6c19-756e-43f3-8342-66b032238265@intel.com>
 <Zyr7FA10pmLhZBxL@tlindgre-MOBL1>
 <Z1scMzIdT2cI4F5T@iweiny-mobl>
 <Z2F3mBlIqbf9h4QM@tlindgre-MOBL1>
 <1b03e7a4-c398-4646-9182-e3757f65980e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b03e7a4-c398-4646-9182-e3757f65980e@intel.com>

On Tue, Jan 14, 2025 at 08:39:37PM +0800, Xiaoyao Li wrote:
> On 12/17/2024 9:10 PM, Tony Lindgren wrote:
> > Hmm I don't think we should loop forever anywhere, the retries needed should
> > be only a few. Or what do you have in mind?
> 
> "A few" seems not accurate. It depends on how heavy the RDRAND/RDSEED
> traffic from others are. IIRC, it gets > 10 0000 -EAGAIN before success when
> all the LPs in the system are doing RDRAND/RDSEED.

Oh OK :)

> Maybe a timeout? E.g., QEMU exits when it cannot move forward for a certain
> period.
> 
> However, I'm not sure what value is reasonable for the timeout.

Maybe some reasonable timeout could be multiplied by the number of CPUs
or LPs available on the system?

Regards,

Tony

