Return-Path: <kvm+bounces-9312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AFD85E073
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6162BB24090
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877617FBD2;
	Wed, 21 Feb 2024 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXXCCTgZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4819E79DD7
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708527827; cv=none; b=gA3ZmprreR4gDCMwgbtM0qWDgqHwFyQL6yx+x84bmsU1InWkVCxXHB+F41Td+/p6av1ycwz6Jy2Y5Punv5Dcz6YgriUOhsM9WYAD0rScgsQ3RgQga7WbKorpKFjyPvPN58NFLUt4lOMQ3t3hIYraWp5kYcp71dBjKRcY7SuyKwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708527827; c=relaxed/simple;
	bh=icf79m790ezLNPPZJLTw/l5EOQt2t+L55q4q0lXCEZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPf7kCou/MaqY3mbuXsbbP9euKOjgxsBHKv7E4hM6s2X4Bguj0F5RD97dBIKu0jBkitL4H31KkcwLuO79lOFtrKbjDM1bbavPaGQKYjs13hqrYxYdTUOEvlrJDAIVK/B/lqA9QvFSYtlWgbtCTDChtbfK3uGoOzO5jUYuNWyZw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXXCCTgZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708527826; x=1740063826;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=icf79m790ezLNPPZJLTw/l5EOQt2t+L55q4q0lXCEZI=;
  b=NXXCCTgZbOqmdiNf5hfAeNhuKiq5IXVoDxihxZqnfA4pVYKwl5eDK4Mb
   LbT6WdnE3Tb48dC49HW06dNRyDu4rKiccgUGM3xaTD/f7EKJ3q3oi+gHP
   KK518P2Wa6f3z8cfNQYvRsm31yfdshBdNyww3PEL8jvHM/3nrvsu0TfBe
   b4Qt9zvhLmJ6TdjY9v0794lr6G5ZhgsOC4hyhI0PmAseQjDz6DmF+5uDK
   xjuwMjR367jOZN0HvQeb5CWNO9EuffOZ5MLQriDUEGXQ0JYD8THr29psb
   URbK+s1aYHWwAg2bIBTGDFp/rn3RvaXP/Dx0bIgEcSDF/UKNPJ7AwUwt2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="28131340"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="28131340"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 07:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="827362818"
X-IronPort-AV: E=Sophos;i="6.06,175,1705392000"; 
   d="scan'208";a="827362818"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orsmga001.jf.intel.com with ESMTP; 21 Feb 2024 07:03:31 -0800
Date: Wed, 21 Feb 2024 23:17:11 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
Message-ID: <ZdYT94zKGTgG/ipH@intel.com>
References: <20240220092504.726064-1-zhao1.liu@linux.intel.com>
 <20240220092504.726064-5-zhao1.liu@linux.intel.com>
 <871q9656jm.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871q9656jm.fsf@pond.sub.org>

On Wed, Feb 21, 2024 at 01:46:21PM +0100, Markus Armbruster wrote:
> Date: Wed, 21 Feb 2024 13:46:21 +0100
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [RFC 4/8] hw/core: Add cache topology options in -smp
> 
> Zhao Liu <zhao1.liu@linux.intel.com> writes:
> 
> > From: Zhao Liu <zhao1.liu@intel.com>
> >
> > Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> > -smp to define the cache topology for SMP system.
> >
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/machine.json b/qapi/machine.json
> > index d0e7f1f615f3..0a923ac38803 100644
> > --- a/qapi/machine.json
> > +++ b/qapi/machine.json
> > @@ -1650,6 +1650,14 @@
> >  #
> >  # @threads: number of threads per core
> >  #
> > +# @l1d-cache: topology hierarchy of L1 data cache (since 9.0)
> > +#
> > +# @l1i-cache: topology hierarchy of L1 instruction cache (since 9.0)
> > +#
> > +# @l2-cache: topology hierarchy of L2 unified cache (since 9.0)
> > +#
> > +# @l3-cache: topology hierarchy of L3 unified cache (since 9.0)
> > +#
> 
> Too terse, just like my review ;-P

;-) Yes, I'll add more information to improve the readability of the
code and comments.

Thanks,
Zhao

> 
> >  # Since: 6.1
> >  ##
> >  { 'struct': 'SMPConfiguration', 'data': {
> > @@ -1662,7 +1670,11 @@
> >       '*modules': 'int',
> >       '*cores': 'int',
> >       '*threads': 'int',
> > -     '*maxcpus': 'int' } }
> > +     '*maxcpus': 'int',
> > +     '*l1d-cache': 'str',
> > +     '*l1i-cache': 'str',
> > +     '*l2-cache': 'str',
> > +     '*l3-cache': 'str' } }
> >  
> >  ##
> >  # @x-query-irq:
> 
> [...]
> 

