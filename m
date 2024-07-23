Return-Path: <kvm+bounces-22087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9220939936
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 07:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FA2CB21FEF
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 05:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840C313C832;
	Tue, 23 Jul 2024 05:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mzdza595"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA16134B6
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 05:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721712987; cv=none; b=WJ/PHedg2ou802M0kQkzn0ODRpIiw/DktT+B7apQqGCrEaAMgi8wL9ka5YU7iVWRGyWY094F+4gua9R3XAaZSl0lm/hMc6b8JpC0khc3md6CpuVqMVbAmKPbPKOuoCiDYRDl5IV3gspd3VeGcieM4kJckaAjRksX03kCvDGGG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721712987; c=relaxed/simple;
	bh=Yv7QWl5KiOQ2ytrvPTyxY+6rm8poKp2aySleLBGCXC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kmG+qmVfnNhBPtSF7Q7B6oFPfVd+HeZ5fOmaPeJ11jkmsLzrfc508zKsB8P0X5ppASsvEOwqaEGETP1mP50OTbhzLLadEPvf0NhBYrWB5i4MtjcKw5h9ez9ecg80WaWW7ovOWFn0seMhgi/tN0gZ5H1gKwNpJ0t59FxbSFCS5Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mzdza595; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721712986; x=1753248986;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yv7QWl5KiOQ2ytrvPTyxY+6rm8poKp2aySleLBGCXC0=;
  b=Mzdza5952n9eNzoF9/ICoUhmWU/kfSCxMSNukIrXoiBnmu1y19lZt1mW
   Bb1vS1zhN67sGyyYu8ortdXUcNUSbmdMGNPYXn6cvHVZ1FNPt5xG72Yet
   lJZ/C9d2DC6M9qycX9Jr9++bfSu64TuQSxG2S36RXeS8AMVXqS7zD9V1s
   5Vb0OlO/8jQfE/kJY1i/CpxpKHo4/Zp+ouruG9KUeG76cKFiiGkfU0Yqo
   vJgL2GLzZSWt1IO5veur0Foxs60zdXEqgVp2+7re1m60oewjbQgtmWKu0
   rPLg18mqM0SW8E9RcFbDcYb20ANxNmZY/fXoQ0qXFiSQNcEhZkK90/b72
   A==;
X-CSE-ConnectionGUID: IJaFiE20RWuOvL4WlI48QQ==
X-CSE-MsgGUID: YMYG5imsQ7CHljdK47/Vfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="30738601"
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="30738601"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 22:36:23 -0700
X-CSE-ConnectionGUID: x5bM7NWzTXelasgvt55Ckg==
X-CSE-MsgGUID: dK+RGnoiQFKQycIih7GbgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="89575997"
Received: from unknown (HELO [10.238.3.39]) ([10.238.3.39])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 22:36:17 -0700
Message-ID: <38231df8-81d7-4dd6-9ef9-a72fda228176@linux.intel.com>
Date: Tue, 23 Jul 2024 13:36:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 3/5] i386/kvm: Support event with select&umask format in KVM
 PMU filter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 Eric Auger <eauger@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Mingwei Zhang <mizhang@google.com>, Jim Mattson <jmattson@google.com>
References: <20240710045117.3164577-1-zhao1.liu@intel.com>
 <20240710045117.3164577-4-zhao1.liu@intel.com>
 <f18ab76c-abbe-4599-9631-603853bcfa0b@linux.intel.com>
 <Zpomm3hLhSM5O6em@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zpomm3hLhSM5O6em@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/19/2024 4:40 PM, Zhao Liu wrote:
> Hi Dapeng,
>
> On Thu, Jul 18, 2024 at 01:28:25PM +0800, Mi, Dapeng wrote:
>
> [snip]
>
>>> +        case KVM_PMU_EVENT_FMT_X86_DEFAULT: {
>>> +            uint64_t select, umask;
>>> +
>>> +            ret = qemu_strtou64(str_event->u.x86_default.select, NULL,
>>> +                                0, &select);
>>> +            if (ret < 0) {
>>> +                error_setg(errp,
>>> +                           "Invalid %s PMU event (select: %s): %s. "
>>> +                           "The select must be a "
>>> +                           "12-bit unsigned number string.",
>>> +                           KVMPMUEventEncodeFmt_str(str_event->format),
>>> +                           str_event->u.x86_default.select,
>>> +                           strerror(-ret));
>>> +                g_free(event);
>>> +                goto fail;
>>> +            }
>>> +            if (select > UINT12_MAX) {
>>> +                error_setg(errp,
>>> +                           "Invalid %s PMU event (select: %s): "
>>> +                           "Numerical result out of range. "
>>> +                           "The select must be a "
>>> +                           "12-bit unsigned number string.",
>>> +                           KVMPMUEventEncodeFmt_str(str_event->format),
>>> +                           str_event->u.x86_default.select);
>>> +                g_free(event);
>>> +                goto fail;
>>> +            }
>>> +            event->u.x86_default.select = select;
>>> +
>>> +            ret = qemu_strtou64(str_event->u.x86_default.umask, NULL,
>>> +                                0, &umask);
>>> +            if (ret < 0) {
>>> +                error_setg(errp,
>>> +                           "Invalid %s PMU event (umask: %s): %s. "
>>> +                           "The umask must be a uint8 string.",
>>> +                           KVMPMUEventEncodeFmt_str(str_event->format),
>>> +                           str_event->u.x86_default.umask,
>>> +                           strerror(-ret));
>>> +                g_free(event);
>>> +                goto fail;
>>> +            }
>>> +            if (umask > UINT8_MAX) {
>> umask is extended to 16 bits from Perfmon v6+. Please notice we need to
>> upgrade this to 16 bits in the future. More details can be found here.
>> [PATCH V3 00/13] Support Lunar Lake and Arrow Lake core PMU - kan.liang
>> (kernel.org)
>> <https://lore.kernel.org/all/20240626143545.480761-1-kan.liang@linux.intel.com/>
> It's tricky...now I referred the RAW_EVENT format in tools/testing/
> selftests/kvm/include/x86_64/pmu.h, which is used in KVM PMU and is
> compatible with AMD and Intel.
>
> The current KVM PMU filter for raw code doesn't define the layout in
> the standard API like masked entries (KVM_PMU_ENCODE_MASKED_ENTRY), but
> actually uses the RAW_EVENT format. So I even plan to move RAW_EVENT
> macro into arch/x86/include/uapi/asm/kvm.h...
For the raw event format, I suppose user should know the event layout and
would directly input the raw event code, qemu may not concern this.


>
> For the changes you mentioned, I think it would be better for the raw
> code layout design not to break RAW_EVENT, so that AMD and Intel can
> equally use the same macro to encode. Is it possible for a unified
> layout macro?
>
> What about extending RAW_EVENT as the following example? I understand
> the umask2 is at bit 40-47.
>
> #define X86_PMU_RAW_EVENT(eventsel, umask) (((eventsel & 0xf00UL) << 24) | \
>                                             ((eventsel) & 0xff) | \
>                                             ((umask) & 0xff) << 8) | \
> 					    ((umask & 0xff00UL << 32)

It's always good if Intel and AMD can share same event layout, the extended
umask field occupies bits [40:47]. So I think we'd better follow this for
the RAW_EVENT as well.


>
> Thanks,
> Zhao
>

