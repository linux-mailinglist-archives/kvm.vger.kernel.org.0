Return-Path: <kvm+bounces-17110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B978C0D87
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 11:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96CE6B2241F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD1314A0B5;
	Thu,  9 May 2024 09:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMJayLk1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF31494D9
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 09:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715247251; cv=none; b=XC9u1qwAmyy9M8bcfOP784jzQvWojitEYcH4bOq9XPii7UuBnP7l7qSSMuzITY8H0/JNlWQbG+8FBITZd0w07yEHYegqO6Akw1LxOpxUfmVTULz9gfMfay5YgUQmA8Oqf6LSAez0l+2FKOtDZOtgKzN685LqwsmAXNhuPsU03Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715247251; c=relaxed/simple;
	bh=CFpl8Em0ezawD7OPr4h8KLp86UgnW759Zooxx+57uns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIUBsAbooTGR6hzVk6tB0WY8NBNdIG7wXAJsj9T7RQzgJCtTzDWizuvGfl8v8ri8HCYS3D71NLt4e410kjr5ynScgadUAHChPfih80OUJfD5fAH6NN3RqpRMe4FhWYBgfEtmyMlu1CkhSObAg1HfB04FsCA/I62p+kKluWEHueA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMJayLk1; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715247250; x=1746783250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CFpl8Em0ezawD7OPr4h8KLp86UgnW759Zooxx+57uns=;
  b=IMJayLk1AKiJ6BUUij+eGAiCzQ8hHVsKx+8f7OymWHoPIM+vUciYkGNk
   NyGhPAD5abvNDMn6/ndJuC8m7vddXpKxJDzHLfq4hTCyHBikI7z+u1my+
   VHShKATE+xX0IH+pyJQeEfwXWEI9xQHO5awkX6IpX2Az8lDUUHr/gSy0e
   /KTQzuTLzLDWqfdIy2nycGS9karDhpSTgRBR2PKzB3Abcd+5dKiPo4DB0
   yvi3WBWotZo0pnetS74AHzB+dOe9O0y+Dxvqh/sAEyq6OI7d1pLZgn6yt
   vlvwYjKg3eY6GltxcfkKfOMJoa0bakBJ6DS//MXo2NrkLMeCGue58aSC3
   g==;
X-CSE-ConnectionGUID: dpgxSKNlSNKZXyiD4t8djA==
X-CSE-MsgGUID: PIbviBBxSaagZuBAwLteXA==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11285814"
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="11285814"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 02:34:09 -0700
X-CSE-ConnectionGUID: 8fXg2g47S42AeS/M0WWZuA==
X-CSE-MsgGUID: 84H4yguURAKvB8A4Rf6kBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,147,1712646000"; 
   d="scan'208";a="33652836"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa005.fm.intel.com with ESMTP; 09 May 2024 02:34:06 -0700
Date: Thu, 9 May 2024 17:48:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Message-ID: <Zjyb43JqMZA+bO4r@intel.com>
References: <20240409024940.180107-1-shahuang@redhat.com>
 <Zh1j9b92UGPzr1-a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zh1j9b92UGPzr1-a@redhat.com>

Hi Daniel & Shaoqin,

Since x86 also needs to implement PMU filter feature, though it uses
the different KVM ioctl, we can still make the QEMU API as general as
possible.

To move forward with both ARM and x86, I'd like to discuss my API
thinking with you. ;-)

On Mon, Apr 15, 2024 at 06:29:25PM +0100, Daniel P. Berrangé wrote:
> Date: Mon, 15 Apr 2024 18:29:25 +0100
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v9] arm/kvm: Enable support for
>  KVM_ARM_VCPU_PMU_V3_FILTER
> 
> On Mon, Apr 08, 2024 at 10:49:40PM -0400, Shaoqin Huang wrote:
> > The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> > which PMU events are provided to the guest. Add a new option
> > `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> > Without the filter, all PMU events are exposed from host to guest by
> > default. The usage of the new sub-option can be found from the updated
> > document (docs/system/arm/cpu-features.rst).
> > 
> > Here is an example which shows how to use the PMU Event Filtering, when
> > we launch a guest by use kvm, add such command line:
> > 
> >   # qemu-system-aarch64 \
> >         -accel kvm \
> >         -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> I'm still against implementing this one-off custom parsed syntax
> for kvm-pmu-filter values. Once this syntax exists, we're locked
> into back-compatibility for multiple releases, and it will make
> a conversion to QAPI/JSON harder.

Daniel, I understand you mean the new specific string format makes
external API support more complicated, right?

What about the following options:

1. Firstly, add a feature flag option in "-cpu" to enable kvm_filter
feature for CPU:

-cpu host,kvm-pmu-filter

2. Then use "-object kvm-pmu-event" to configure PMU event properties.
Since x86's PMU filter has very complex encoding rules, we need the
following three variants (one for general case, the other two are x86
specific):

- General format:
  -object kvm-pmu-event,action=[allowed|denied],events=[event-list]

  e.g, as Shaoqin's example,
  -object kvm-pmu-event,action=allowed,events=0x11-0x11,0x23-0x23
  -object kvm-pmu-event,action=denied,events=0x23-0x3a

- x86 raw_event encoding format (for single raw format event encoding):
  -object kvm-pmu-event,action=[allowed|denied],mode=0,select="0x01",
          umask="0x3c",fixed-bitmap="0xffffffff"

- x86 masked_event encoding format (for mutiple masked event encoding):
  -object kvm-pmu-event,action=[allowed|denied],mode=masked,select="0x01",
          mask="0x3c",match="0x11",exclude=true|false

The whole API architecture looks more complex, but has the advantage of
being as general as possible and avoiding the introduction of new string
format parsing.

What do you think? Because the most important thing about this feature
is the API design, welcome your comments!

Regards,
Zhao



