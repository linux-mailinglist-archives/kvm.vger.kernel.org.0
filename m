Return-Path: <kvm+bounces-21813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1AB793479A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 07:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301CF1F22A93
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 05:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C01C4501A;
	Thu, 18 Jul 2024 05:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTItYn1l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABEC40856
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721280479; cv=none; b=XZ4OyOrrfuVGBHuPQYtps97G1t5w710Zak3ECNpU8I7SxsBEh+/6ARpYNrAqq6pbUwPn5tQ1fMClvg8emBPaQERD5dLdkCCnUdwPsDtvhss8im2EW1v2HYI6xeUx52WLEjHcZ+RvcZ7GkhQ0X1GYMmWSRWfGgzOogXlsB4IuCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721280479; c=relaxed/simple;
	bh=fKvaxuJ//hWg3zHTHWMN5cYxRmmbHxClJ8soYQl/J7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ARqlTA2E1+2Vjl3HZ2aHNLj+Xxz21lC4uF3gUlRLhCYqfO1Z9as4BKwLwY0x6VXDBAdFDUmpTSB6c/1Fs+Kb6kVxZio4Saxn1zFm8c5qZGg83YC77M8c/AF9rr42IliB2maqWjOqAeIbmFi8rXC6ywKadHs6+5LTmS5EJdDUs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTItYn1l; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721280477; x=1752816477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fKvaxuJ//hWg3zHTHWMN5cYxRmmbHxClJ8soYQl/J7g=;
  b=WTItYn1lociNaaws/B/gDMDXUAkKBoGKCt38PivWk/hbpxIA2l0qwPQn
   cc+54Zh1yFrBO5ayH+dizCnTZhuEDsj1m4Bj9I9Qb4a1pqpApKeTEoj9A
   9mZksdYZOrSm6+LQ+nOIiQWkZx7VPcGaE228ejXmOAXUDz34Qo1lqWZHi
   0iWGOvzsZiMrvKpBalVGDQkKpshXzZx6J/rMOvgj9+x/vvOtE+xPnyDBl
   II8XTdooOaHUma4HgD3RsmK6OKidrPuL08G7qJCtltERd8QgALa0P1ire
   fxaTdLhk2IGpZ8cQ6ygx8KNgz8jhvHQ6IYZUo30TH2ZSMu/6TK7e44LXI
   g==;
X-CSE-ConnectionGUID: iRBNwRVbS6awu2NDNamYcg==
X-CSE-MsgGUID: JzUDRLF/SbyR1/ZJ+tYOCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="18671260"
X-IronPort-AV: E=Sophos;i="6.09,216,1716274800"; 
   d="scan'208";a="18671260"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 22:27:56 -0700
X-CSE-ConnectionGUID: kb13SDT1TdexH1fKmETPBw==
X-CSE-MsgGUID: zSJ6MeJ0S+mpvolVUsRJVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,216,1716274800"; 
   d="scan'208";a="55777816"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.1]) ([10.124.225.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 22:27:51 -0700
Message-ID: <738c5474-a568-4a48-8c8e-b0f11b17a187@linux.intel.com>
Date: Thu, 18 Jul 2024 13:27:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/5] accel/kvm: Support KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Mingwei Zhang <mizhang@google.com>, Jim Mattson <jmattson@google.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20240710045117.3164577-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/10/2024 12:51 PM, Zhao Liu wrote:
> Hi QEMU maintainers, arm and PMU folks,
>
> I picked up Shaoqing's previous work [1] on the KVM PMU filter for arm,
> and now is trying to support this feature for x86 with a JSON-compatible
> API.
>
> While arm and x86 use different KVM ioctls to configure the PMU filter,
> considering they all have similar inputs (PMU event + action), it is
> still possible to abstract a generic, cross-architecture kvm-pmu-filter
> object and provide users with a sufficiently generic or near-consistent
> QAPI interface.
>
> That's what I did in this series, a new kvm-pmu-filter object, with the
> API like:
>
> -object '{"qom-type":"kvm-pmu-filter","id":"f0","events":[{"action":"allow","format":"raw","code":"0xc4"}]}'

I'm not sure why the action is defined to event scope instead of the entire
filter scope. At least for x86 arch, the action is defined to filter scope
in KVM. Do other archs support event scope's action? If the action can be
defined to filter scope, the code could be simplified much.


>
> For i386, this object is inserted into kvm accelerator and is extended
> to support fixed-counter and more formats ("x86-default" and
> "x86-masked-entry"):
>
> -accel kvm,pmu-filter=f0 \
> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","x86-fixed-counter":{"action":"allow","bitmap":"0x0"},"events":[{"action":"allow","format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"action":"allow","format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
>
> This object can still be added as the property to the arch CPU if it is
> desired as a per CPU feature (as Shaoqin did for arm before).
>
> Welcome your feedback and comments!
>
>
> Introduction
> ============
>
>
> Formats supported in kvm-pmu-filter
> -----------------------------------
>
> This series supports 3 formats:
>
> * raw format (general format).
>
>   This format indicates the code that has been encoded to be able to
>   index the PMU events, and which can be delivered directly to the KVM
>   ioctl. For arm, this means the event code, and for i386, this means
>   the raw event with the layout like:
>
>       select high bit | umask | select low bits
>
> * x86-default format (i386 specific)
>
>   x86 commonly uses select&umask to identify PMU events, and this format
>   is used to support the select&umask. Then QEMU will encode select and
>   umask into a raw format code.
>
> * x86-masked-entry (i386 specific)
>
>   This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.
>
>
> Hexadecimal value string
> ------------------------
>
> In practice, the values associated with PMU events (code for arm, select&
> umask for x86) are often expressed in hexadecimal. Further, from linux
> perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
> arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
> s390 uses decimal value.
>
> Therefore, it is necessary to support hexadecimal in order to honor PMU
> conventions.
>
> However, unfortunately, standard JSON (RFC 8259) does not support
> hexadecimal numbers. So I can only consider using the numeric string in
> the QAPI and then parsing it to a number.
>
> To achieve this, I defined two versions of PMU-related structures in
> kvm.json:
>  * a native version that accepts numeric values, which is used for
>    QEMU's internal code processing,
>
>  * and a variant version that accepts numeric string, which is used to
>    receive user input.
>
> kvm-pmu-filter object will take care of converting the string version
> of the event/counter information into the numeric version.
>
> The related implementation can be found in patch 1.
>
>
> CPU property v.s. KVM property
> ------------------------------
>
> In Shaoqin's previous implementation [1], KVM PMU filter is made as a
> arm CPU property. This is because arm uses a per CPU ioctl
> (KVM_SET_DEVICE_ATTR) to configure KVM PMU filter.
>
> However, for x86, the dependent ioctl (KVM_SET_PMU_EVENT_FILTER) is per
> VM. In the meantime, considering that for hybrid architecture, maybe in
> the future there will be a new per vCPU ioctl, or there will be
> practices to support filter fixed counter by configuring CPUIDs.
>
> Based on the above thoughts, for x86, it is not appropriate to make the
> current per-VM ioctl-based PMU filter a CPU property. Instead, I make it
> a kvm property and configure it via "-accel kvm,pmu-filter=obj_id".
>
> So in summary, it is feasible to use the KVM PMU filter as either a CPU
> or a KVM property, depending on whether it is used as a CPU feature or a
> VM feature.
>
> The kvm-pmu-filter object, as an abstraction, is general enough to
> support filter configurations for different scopes (per-CPU or per-VM).

Per my understanding, the cpus sharing same uarch should share same perf
events filter. Not sure if there is real requirement to support different
filters on the CPUs with same arch.


>
>
> [1]: https://lore.kernel.org/qemu-devel/20240409024940.180107-1-shahuang@redhat.com/
>
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (5):
>   qapi/qom: Introduce kvm-pmu-filter object
>   i386/kvm: Support initial KVM PMU filter
>   i386/kvm: Support event with select&umask format in KVM PMU filter
>   i386/kvm: Support event with masked entry format in KVM PMU filter
>   i386/kvm: Support fixed counter in KVM PMU filter
>
>  MAINTAINERS                |   1 +
>  accel/kvm/kvm-pmu.c        | 367 +++++++++++++++++++++++++++++++++++++
>  accel/kvm/meson.build      |   1 +
>  include/sysemu/kvm-pmu.h   |  43 +++++
>  include/sysemu/kvm_int.h   |   2 +
>  qapi/kvm.json              | 255 ++++++++++++++++++++++++++
>  qapi/meson.build           |   1 +
>  qapi/qapi-schema.json      |   1 +
>  qapi/qom.json              |   3 +
>  target/i386/kvm/kvm.c      | 211 +++++++++++++++++++++
>  target/i386/kvm/kvm_i386.h |   1 +
>  11 files changed, 886 insertions(+)
>  create mode 100644 accel/kvm/kvm-pmu.c
>  create mode 100644 include/sysemu/kvm-pmu.h
>  create mode 100644 qapi/kvm.json
>

