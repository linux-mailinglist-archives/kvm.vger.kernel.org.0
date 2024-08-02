Return-Path: <kvm+bounces-23021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08170945B63
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 935331F2306B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F0C1DAC7D;
	Fri,  2 Aug 2024 09:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZiRCD6JJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E73399F
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 09:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722592085; cv=none; b=IMWtWQfApiLb5ssrIsTJaLpzRqBpj3ocCIgqlqKsjPBtP8ApfIjaw/Pw1firLDm9sN20VdSFiYlgNoDutBLy/WEKH06aRtyE3L5DgUto7Sct+xmASH7xmMqFXCYKwrUKgQr5XQdElQuoZlxTxtVquJQxQVD7vibx6ANfIyd/jTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722592085; c=relaxed/simple;
	bh=kqQcjt8ahHm0LUdDkgUTxKLsmqLB40UCsPTMULgSq+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPQf75iFZgdLc1q56B6S18a8+TCdLRPS6DHJAo7AuhTP2kFjzV4vt5ZSvQa2QAxXNmepJQyKG/adcC5f6K10QdQVhQTmMqshcXh2ijubjfnMn9l/fc7GALu25ESDJpMcjkn8sA0K03CsuQTODJPOBJzX5WZNZUYpnwrE6nHmGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZiRCD6JJ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722592084; x=1754128084;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kqQcjt8ahHm0LUdDkgUTxKLsmqLB40UCsPTMULgSq+s=;
  b=ZiRCD6JJiQMKr9Ls+S61sK2XJp8E2980KaCpjX7+0y28NhaMI/NVY4dh
   nyKAfgyrzx5Hi6GzKv31At19uAf/dw38+Agg+FgRh/oKECWoibOQRjeCi
   m8NTNdL9GnAhFQCT46Pxaq9QMYaNP6G9EHIIUtr/4Zgl6L2ulbOBdAn5/
   PppNBz6R3BPeOOeom+1kiSQdchBbJeaHpbmsJ2cG7kkTOFqQ8fxXWxyMq
   gbHFdtRzE1/40JGiU7zq/8OFyYU1Mf2q5g0238T8/oGstB79ByCBEYG+q
   /TkgcBrTHsdgURyDoPsgEqplgQ4CN5azJcmNthC8wLymFCbNVJf/M9VfD
   g==;
X-CSE-ConnectionGUID: TJYyxOtEQQWZsB2IYl/d0g==
X-CSE-MsgGUID: Wnae1djDT5yMXB+UR2S+6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11151"; a="20774534"
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="20774534"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 02:48:03 -0700
X-CSE-ConnectionGUID: Kgw64EYBRCWfML41yTcO+w==
X-CSE-MsgGUID: BweuvkbuTiWba31HNNVsCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,257,1716274800"; 
   d="scan'208";a="55267892"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 02 Aug 2024 02:47:58 -0700
Date: Fri, 2 Aug 2024 18:03:45 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>, Yuan Yao <yuan.yao@intel.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <ZqyvAWQdmW41D5H1@intel.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <b10545d1-8e81-44f0-8e13-eee393ea4d1b@redhat.com>
 <ZqyovJZkOjm6HZFv@intel.com>
 <45e9258c-b370-4b5c-884b-80a21f69cee8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45e9258c-b370-4b5c-884b-80a21f69cee8@redhat.com>

On Fri, Aug 02, 2024 at 05:41:57PM +0800, Shaoqin Huang wrote:
> Date: Fri, 2 Aug 2024 17:41:57 +0800
> From: Shaoqin Huang <shahuang@redhat.com>
> Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
> 
> Hi Zhao,
> 
> On 8/2/24 17:37, Zhao Liu wrote:
> > Hello Shaoqin,
> > 
> > On Fri, Aug 02, 2024 at 05:01:47PM +0800, Shaoqin Huang wrote:
> > > Date: Fri, 2 Aug 2024 17:01:47 +0800
> > > From: Shaoqin Huang <shahuang@redhat.com>
> > > Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
> > > 
> > > Hi Zhao,
> > > 
> > > On 7/10/24 12:51, Zhao Liu wrote:
> > > > Hi QEMU maintainers, arm and PMU folks,
> > > > 
> > > > I picked up Shaoqing's previous work [1] on the KVM PMU filter for arm,
> > > > and now is trying to support this feature for x86 with a JSON-compatible
> > > > API.
> > > > 
> > > > While arm and x86 use different KVM ioctls to configure the PMU filter,
> > > > considering they all have similar inputs (PMU event + action), it is
> > > > still possible to abstract a generic, cross-architecture kvm-pmu-filter
> > > > object and provide users with a sufficiently generic or near-consistent
> > > > QAPI interface.
> > > > 
> > > > That's what I did in this series, a new kvm-pmu-filter object, with the
> > > > API like:
> > > > 
> > > > -object '{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0xc4"}]}'
> > > > 
> > > > For i386, this object is inserted into kvm accelerator and is extended
> > > > to support fixed-counter and more formats ("x86-default" and
> > > > "x86-masked-entry"):
> > > > 
> > > > -accel kvm,pmu-filter=f0 \
> > > > -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
> > > 
> > > What if I want to create the PMU Filter on ARM to deny the event range
> > > [0x5,0x10], and allow deny event 0x13, how should I write the json?
> > > 
> > 
> > Cuurently this doesn't support the event range (since the raw format of
> > x86 event cannot be said to be continuous).
> > 
> > So with the basic support, we need to configure events one by one:
> > 
> > -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0x5"},{"action":"allow","format":"raw","select":"0x6"},{"action":"allow","format":"raw","code":"0x7"},{"action":"allow","format":"raw","code":"0x8"},{"action":"allow","format":"raw","code":"0x9"},{"action":"allow","format":"raw","code":"0x10"},{"action":"deny","format":"raw","code":"0x13"}]}'
> > 
> > This one looks a lot more complicated, but in the future, arm could
> > further support event-range (maybe implement event-range via mask), but
> > I think this could be arch-specific format since not all architectures'
> > events are continuous.
> > 
> > Additional, I'm a bit confused by your example, and I hope you can help
> > me understand that: when configuring 0x5~0x10 to be allow, isn't it true
> > that all other events are denied by default, so denying 0x13 again is a
> > redundant operation? What is the default action for all other events
> > except 0x5~0x10 and 0x13?
> > 
> > If we specify action as allow for 0x5~0x10 and deny for the rest by
> > default, then there is no need to set an action for each event but only
> > a global one (as suggested by Dapeng), so the above command line can be
> > simplified as:
> > 
> > -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0x5"},{"format":"raw","select":"0x6"},{"format":"raw","code":"0x7"},{"format":"raw","code":"0x8"},{"format":"raw","code":"0x9"},{"format":"raw","code":"0x10"}]}'
> > 
> 
> Yes you are right. On Arm when you first set the PMU Filter, if the first
> filter is allow, then all other event will be denied by default. The reverse
> is also the same, if the first filter is deny, then all other event will be
> allowed by default.
> 
> On ARM the PMU Filter is much more simper than x86 I think. We only need to
> care about the special event with allow or deny action.
> 
> If we don't support event range filter, I think that's fine. This can be
> added in the future.

This is good news for me, I can implement global action in the next
version and iterate further! Thank you for your confirmation!

Regards,
Zhao


