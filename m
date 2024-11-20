Return-Path: <kvm+bounces-32117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D84E19D32C3
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:47:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B0FBB22F3F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 03:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B542C14B06A;
	Wed, 20 Nov 2024 03:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EGNd4uFL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C91923CB;
	Wed, 20 Nov 2024 03:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732074434; cv=none; b=k9ptjO+77kmpynFn9Endg3bi3O1tSBTO/0QmqNZRvEDbjtfae66RwX1wKE1o5RcZGJPbYHTKVDw+NgsrQT9Pqi2tCxm/lyvlFz3A/Nelk13NH92HI4jiDlGnOEQCjzKBs+yH7XBRw8lpggiYOYIvSnicHbxHVlD15+T+Vdpbd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732074434; c=relaxed/simple;
	bh=qp7oiJVWePocJ8ehFvr5nyYc9+knRNZXVCM4f4tX6Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXzptaQKN1vFnKrvt9E5YjV/HqvTw6k9CTPQ460iInoUE9AsTVCen9qnHL1G+Rysdr+ghQQLH74Ha/Qwg9ICW7qTFxJc+Sclf5U04k3DOsXVcv3VGNz+iAVfukKkWur6bjx2U4XcywwW1D0lJgeE9HuzTDq67Ufqe8+/z6HV5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EGNd4uFL; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732074433; x=1763610433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qp7oiJVWePocJ8ehFvr5nyYc9+knRNZXVCM4f4tX6Es=;
  b=EGNd4uFL9WTRmb6Cm/Mv3O+AmBnqKX28YoZanUOaryx3yq5Xp/x8errd
   qwgDkv/GLkiTKHukqC+NOK9Z6qD/+likLh1yyiuwcPYw5qMEKq9Ytg2XO
   +hyzB7n6NkqHLyIeqlUVcbT7F9VNKodocj8N+73MAXO4klFHCgeoVYgFg
   qlP3yi41DT8t6bk0uHL/kjB91tGdN3NC2sYhnSIm1kh/H0eKBKt8U3jBp
   +shfM0XZjSkH3+p2+nJhs+gkKz1MDs9ZCKWrndSbxyo1CuAdaAQs1EZwC
   zSmb5dzwpEAX11UJw+/mcShwdRAl6yZx91SDub+cr4EcFadXZ4/C1PmfE
   w==;
X-CSE-ConnectionGUID: LwIxxuSmQ1C4VvGF+Mn2fg==
X-CSE-MsgGUID: lpUgG5q1QzmTFRLls6o+Qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="36023233"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="36023233"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:47:12 -0800
X-CSE-ConnectionGUID: ReiTJJn8RKSgk/FWNNDP2Q==
X-CSE-MsgGUID: zikWLQy0T0KBG/th0XRuFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="89931950"
Received: from unknown (HELO [10.238.2.170]) ([10.238.2.170])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 19:47:08 -0800
Message-ID: <2ec98cd1-e96e-4f17-a615-a5eac54a7004@linux.intel.com>
Date: Wed, 20 Nov 2024 11:47:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 19/58] KVM: x86/pmu: Plumb through pass-through PMU
 to vcpu for Intel CPUs
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
 <20240801045907.4010984-20-mizhang@google.com> <ZzymmUKlPk7gHtup@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZzymmUKlPk7gHtup@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/19/2024 10:54 PM, Sean Christopherson wrote:
> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>> Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
>> vcpu created. Note that enabling PMU is decided by VMM when it sets the
>> CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
>> in intel_pmu_refresh().
> Why?  As with the per-VM snapshot, I see zero reason for this to exist, it's
> simply:
>
>   kvm->arch.enable_pmu && enable_mediated_pmu && pmu->version;
>
> And in literally every correct usage of pmu->passthrough, kvm->arch.enable_pmu
> and pmu->version have been checked (though implicitly), i.e. KVM can check
> enable_mediated_pmu and nothing else.

Ok, too many passthrough_pmu flags indeed confuse readers. Besides these
dependencies, mediated vPMU also depends on lapic_in_kernel(). We need to
set enable_mediated_pmu to false as well if lapic_in_kernel() returns false.




