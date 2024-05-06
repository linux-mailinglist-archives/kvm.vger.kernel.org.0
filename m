Return-Path: <kvm+bounces-16684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E80098BC906
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 615DF1F22563
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F541422B9;
	Mon,  6 May 2024 08:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B4MGLNUu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7FE1411D5;
	Mon,  6 May 2024 08:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714982470; cv=none; b=fElVB14ZrzxRO5JvSwr8s2j7bTZRm2iK/hcx4gatsCIOTowO88wV9ej179nkqJwHDzhFzTrgOFqm9m36eGT9Fcecxbw1z7PUfOrk4Plsy5ORduVsNla6aoM0yIzvKqY/m/TGmieqEHUvXuxlw6e/+JmXCSJL7TZ/FTpR01cawyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714982470; c=relaxed/simple;
	bh=tJlhUqY9HNh4A9j9IQsCn5qCsKSbKibMtM86koTCU5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C1msYwg3WoG71fBUs0Pq+Eq71/e05vO2OBeqzK/frHFDrz5eSC7Bmj5/uExaOacVqx6dR+eIjmi814RhXZnKqfnnyglzhJ3UfQFiF/lxuphqAMpFW4NRWKCK6Slgu9kQkSvJq4sJn3Zf0yeTdPcFyLgqrm9FoVp8UhRLC74Yc1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B4MGLNUu; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714982467; x=1746518467;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tJlhUqY9HNh4A9j9IQsCn5qCsKSbKibMtM86koTCU5w=;
  b=B4MGLNUubw01yAdCWX8PjRxu6PSAMIpB1j8rGMGtYzhyUcN8IOEBRg60
   u3MBxefc38g+EI+11ewXp2ekEApkQ/6keK/v/Pkx1pGIZR20kyI95jXDK
   PIYhwidRKpw6ZP8y1pY9UgRcbH7bseXKhd3FEVHMbZ6Ydlgf5vBYsxrJp
   8pVOjks0U9ZspUkD5C9Ql9kl2LKaoSDU6b++0khOsxxqwKkf/hA6TgrZn
   7ReBEzsqxyzLQpSsRGxbT31LV33hkx805fXqHZZ6vgPruumLW0hTqRafX
   ACwjGtdsvopF2ihrqKVHTXdco/EnNd50imUn80cIurXumayHxaihuMNuu
   A==;
X-CSE-ConnectionGUID: t18nPXGmROGWwbU6ygTa4A==
X-CSE-MsgGUID: DQR6IWfcQUSx2Ot9iY/KZQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="21271278"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="21271278"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:01:07 -0700
X-CSE-ConnectionGUID: YawVlKF3S8WjTefksynJ1Q==
X-CSE-MsgGUID: uN2dD36QSBi93A6GsgvVpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32756703"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:01:04 -0700
Message-ID: <82bf53e7-7969-48b6-b954-0eea303c8b39@linux.intel.com>
Date: Mon, 6 May 2024 16:01:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] vPMU code refines
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang
 <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Dapeng Mi <dapeng1.mi@intel.com>
References: <20240430005239.13527-1-dapeng1.mi@linux.intel.com>
 <CAL715WK9+aXa53DXM3TP2POwAtA2o40wpojfum+SezdxoOsj1A@mail.gmail.com>
 <22b52180-27a2-4df8-a949-401f73440641@linux.intel.com>
 <CAL715W+JTyba76u5BdqHi2u7iBObbBp8cEr42oqm6HWthb_4pg@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715W+JTyba76u5BdqHi2u7iBObbBp8cEr42oqm6HWthb_4pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/6/2024 1:35 PM, Mingwei Zhang wrote:
> On Sun, May 5, 2024 at 6:37 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
>>
>> On 5/1/2024 2:15 AM, Mingwei Zhang wrote:
>>> On Mon, Apr 29, 2024 at 5:45 PM Dapeng Mi <dapeng1.mi@linux.intel.com> wrote:
>>>> This small patchset refines the ambiguous naming in kvm_pmu structure
>>>> and use macros instead of magic numbers to manipulate FIXED_CTR_CTRL MSR
>>>> to increase readability.
>>>>
>>>> No logic change is introduced in this patchset.
>>>>
>>>> Dapeng Mi (2):
>>>>   KVM: x86/pmu: Change ambiguous _mask suffix to _rsvd in kvm_pmu
>>> So, it looks like the 1st patch is also in the upcoming RFCv2 for
>>> mediated passthrough vPMU. I will remove that from my list then.
>> Mingwei, we'd better keep this patch in RFCv2 until the this patchset is
>> merged, then we don't rebase it again when this patch is merged. Thanks.
>>
> yeah. too late. I don't want to have a duplicate patch in LKML. On the
> other hand, you could have waited a little bit before sending this
> one. Next time, coordinate with us before sending.

This patch has nothing to do with the mediated vPMU patchset in theory and
can be merged earlier than the mediated vPMU patcheset which may need a
long time to review and discuss. I hope this patch can be merged ASAP and
so readers won't be mislead by the ambiguous suffix.


>
> Thanks.
> -Mingwei
>>> Thanks. Regards
>>> -Mingwei
>>>
>>>>   KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
>>>>
>>>>  arch/x86/include/asm/kvm_host.h | 10 ++++-----
>>>>  arch/x86/kvm/pmu.c              | 26 ++++++++++++------------
>>>>  arch/x86/kvm/pmu.h              |  8 +++++---
>>>>  arch/x86/kvm/svm/pmu.c          |  4 ++--
>>>>  arch/x86/kvm/vmx/pmu_intel.c    | 36 +++++++++++++++++++--------------
>>>>  5 files changed, 46 insertions(+), 38 deletions(-)
>>>>
>>>>
>>>> base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148
>>>> --
>>>> 2.40.1
>>>>

