Return-Path: <kvm+bounces-30830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D4F9BDCFF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5D901C231C3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB98D1CB9E0;
	Wed,  6 Nov 2024 02:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQqiULWn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1818FC85
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859759; cv=none; b=mpaQwefg5S+okEfcurgwTfXMLELKj25tqSuX6e7fKI1GzuUPfqbTbR1QW6lDp8q+fh8u2e8rhvrTqLS0MVqSuodZvcwLx4nZPxqYupaoK6hMsCD/8z6w6B72zNi9wlTjpa7tkSTENTBhHeWBoOgxyfEl9bgLBpqiLxqaWZCUrdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859759; c=relaxed/simple;
	bh=/KCEcEIHXIG9K9E4TK1RWwzLaP/150mljJM4/TKE848=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjOTEEW/ZbIc1u07kVh0NoXBjjeMxOAvE0rU8J6vF8lyN40XsTPifek/6KQxFv32ZXEnrqxBvST9iBgmr63TT8zRZGb5tyrZnm/RKLiLpf0u+0H77xqWM+0vlM91vFYIQ18MchSwwjjWckNBAYzamkBoJK/sl6HDjs/op9flrp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQqiULWn; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730859758; x=1762395758;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/KCEcEIHXIG9K9E4TK1RWwzLaP/150mljJM4/TKE848=;
  b=IQqiULWn1DDHyy7t4SkNVxAE4lnYIGMC4JvJHCfAozs9IEBNMUk5iFHH
   6JByjDOBByqkMnvNAjuA6i+T2Hvmw/LoebZN0H2FBfgCojnj8UropFsIb
   mfTLVVs/T1H70fgiwacDlQcX3Jymak82kmc3GcT4YvEmEsLpnWFpA2v0n
   44x171OdSIIVpzoIYCl16F5mBBx77Q65sQKLRrHLedMD+HOkFklQ+A+2t
   zbF9XatuRhTKI1cJ1QbKtp/N1lFaQzoOcfOzQFfaAQuydhgUAjYVZ98Ep
   zwTTbdUpeZbKPFnQCZFYR3rhqmEvMn/NzjbdAe9UnDKbkh2IL58K3xRbD
   w==;
X-CSE-ConnectionGUID: ajOpvxtHTK6LGUTPlQx1Ow==
X-CSE-MsgGUID: 0Fn2vdYaRxiXltB6BvJW7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30859568"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="30859568"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:22:37 -0800
X-CSE-ConnectionGUID: ZMKbsAMBSOWwOHuYvFepng==
X-CSE-MsgGUID: ZhO/mQhGT9Wl8MpmIjIr+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84365673"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa006.jf.intel.com with ESMTP; 05 Nov 2024 18:22:33 -0800
Date: Wed, 6 Nov 2024 10:40:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v5 0/9] Introduce SMP Cache Topology
Message-ID: <ZyrXGPlVfAVUCfTO@intel.com>
References: <20241101083331.340178-1-zhao1.liu@intel.com>
 <1b00ec74-4dda-48d4-b74f-9ce45cf1a429@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b00ec74-4dda-48d4-b74f-9ce45cf1a429@linaro.org>

Hi Philippe,

On Tue, Nov 05, 2024 at 10:54:07PM +0000, Philippe Mathieu-Daudé wrote:
> Date: Tue, 5 Nov 2024 22:54:07 +0000
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: Re: [PATCH v5 0/9] Introduce SMP Cache Topology
> 
> Hi Zhao,
> 
> On 1/11/24 09:33, Zhao Liu wrote:
> > Hi Paolo,
> > 
> > This is my v5, if you think it's okay, could this feature get the final
> > merge? (Before the 9.2 cycle ends) :-)
> 
> 
> > ---
> > Zhao Liu (8):
> >    i386/cpu: Don't enumerate the "invalid" CPU topology level
> >    hw/core: Make CPU topology enumeration arch-agnostic
> >    qapi/qom: Define cache enumeration and properties for machine
> >    hw/core: Check smp cache topology support for machine
> >    hw/core: Add a helper to check the cache topology level
> 
> Since the first patches aim to be generic I took the liberty to
> queue them via the hw-misc tree. The rest really belongs to the
> x86 tree.

Thank you! I'm glad I could catch the last train for version 9.2.

> >    i386/cpu: Support thread and module level cache topology
> >    i386/cpu: Update cache topology with machine's configuration
> >    i386/pc: Support cache topology in -machine for PC machine
> > Alireza Sanaee (1):
> >    i386/cpu: add has_caches flag to check smp_cache configuration
> >

I'll continue to push the rest during the merge window of v10.0.

Thanks,
Zhao



