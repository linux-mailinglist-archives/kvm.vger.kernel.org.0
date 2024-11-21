Return-Path: <kvm+bounces-32230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E91339D45A6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 03:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F19282B08
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 02:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DE461FCE;
	Thu, 21 Nov 2024 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kS7eZ2bu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C436C23099B;
	Thu, 21 Nov 2024 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732154658; cv=none; b=i0JJNw10awClmbCbty0+pBnLMgouTUQgt052es2aM+AroWxwjStfBd+Q90W9ilO3g6D2iwK/EMkDs0ohPuFm6XFnFC06kB2rQQvakrhheZVnavacPIplpeYjuEQRULuQ753GSyU5V5cqwE3PVNYp4eeEHdq2WiEXBjgmL/JvzRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732154658; c=relaxed/simple;
	bh=gaY+7MMaStKxAc7LQysU+I6URZtFT90Q+c0EkfrlZtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ac5hbIZISs/cqwWj1PDvkGLNfVIeRHfbbi4BD9HgrV+sduUxluKQDhhgPhLA5QJbxTmalK3M9jeix5BSzu4Duz5S3jcb8qBmSQRhGgUmHa4p0O8F/wRf2gcRb+tJbvKuIt4X0suU2PPC2ctzkKUGwmquZY7qyo4udaPqaNiMhiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kS7eZ2bu; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732154657; x=1763690657;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gaY+7MMaStKxAc7LQysU+I6URZtFT90Q+c0EkfrlZtY=;
  b=kS7eZ2bujgnTvJHuI1LRCNGJ1iled1Zm1pL+oE/H/kbb8KGMgpwkPraQ
   b3jZjGq6tAYigxaEfVq2oRA2RDUl0+5yreM9K0N1sEszQyVO0wexNIdJi
   xa4dVrrdXk1r5ZDBW0VW3EqtnlisHedhgv5XdCNbSCBhImwY2xBj1v/xl
   Tu2ntWIeg1yyLwd8w7GOPWST4hnWe278IaK3TeCnqno1OoaSBQ3t65X+Z
   1QIf4THypG7BTz3TMO4oe/wPKcPTvP2ZggmVszuVkThVwTdT/TEciBPjL
   hzmaab0OcFmDsZ79Ph23Ssp/cEjZM6oQhjTexszS9K22LjFRu9L5SyGdt
   g==;
X-CSE-ConnectionGUID: FoNE+hWyRDeweYmQGHcu/Q==
X-CSE-MsgGUID: 0SfD2k+9SHOpKoUmGxRo2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32300328"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32300328"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:04:17 -0800
X-CSE-ConnectionGUID: ZJqjdDMURyeYuNkMdDuQ1g==
X-CSE-MsgGUID: rVjyDnkCS82O1uZHlahx0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="90902823"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 18:04:11 -0800
Message-ID: <e5a6692c-9219-4cfb-961c-eb2209bc9ec9@linux.intel.com>
Date: Thu, 21 Nov 2024 10:04:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 40/58] KVM: x86/pmu: Grab x86 core PMU for
 passthrough PMU VM
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-41-mizhang@google.com> <Zz4uhmuPcZl9vJVr@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4uhmuPcZl9vJVr@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 2:46 AM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
>>
>> When passthrough PMU is enabled by kvm and perf, KVM call
>> perf_get_mediated_pmu() to exclusive own x86 core PMU at VM creation, KVM
>> call perf_put_mediated_pmu() to return x86 core PMU to host perf at VM
>> destroy.
>>
>> When perf_get_mediated_pmu() fail, the host has system wide perf events
>> without exclude_guest = 1 which must be disabled to enable VM with
>> passthrough PMU.
> I still much prefer my idea of making the mediated PMU opt-in.  I haven't seen
> any argument against that approach.
>
> https://lore.kernel.org/all/ZiFGRFb45oZrmqnJ@google.com

Yeah, I agree this look a more flexible method and it gives the VMM right
to control if the mediated vPMU should be enabled instead of static enabling.

The original issue is that this requires VMM to be involved and not all VMM
call the ioctl KVM_CAP_PMU_CAPABILITY, like qemu.

But I see there is already a patch
(https://lore.kernel.org/qemu-devel/20241104094119.4131-3-dongli.zhang@oracle.com/)
which tries to add KVM_CAP_PMU_CAPABILITY support in Qemu although it's not
complete (only disable, but no enable)

Yeah, we would follow this suggestion and make the mediated vPMU opt-in. If
need, we would add corresponding changes for Qemu as well.



