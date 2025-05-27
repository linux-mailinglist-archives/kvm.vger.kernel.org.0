Return-Path: <kvm+bounces-47763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1B3AC4981
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C11DA17722A
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3321F09B2;
	Tue, 27 May 2025 07:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/inhhNH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6AB1FCF41
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 07:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748331997; cv=none; b=bIJWtrVBN+uHJKDpvV+sjEXXSnNp8vf1AOAmekhYtOfvjjGNkP3nfX4Lyyg4MpmTBpMu4Hgw5UOZnGj9mr1VxZssD8aUrZpgletsg3cDdXPHgCbAvEVsAvEhnDXIbVjL7uCL92QglNZ8RTHZEM6B/siBD0um9KuLNghIht0Yz3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748331997; c=relaxed/simple;
	bh=cEjFSRnWVOH0cGVQ0RLmdZ0wEGxA0UKaZ7R4hsYDsYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bU4Shy3TRerSp/DMtPRm0P4N3ug9SNdpq0K3mluiK/rXZlv0jgjsN+mlqZ3+GO/E1XSGr2DJUppB1pxmkMzCjiijzwF0KV6G78s6dsiHOTJgrsNix3XoNQGeax0WYy9yegKm1mT5oASOIZVhnpYek2s5Ii3p7J6HMhtckpTWkVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/inhhNH; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748331996; x=1779867996;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cEjFSRnWVOH0cGVQ0RLmdZ0wEGxA0UKaZ7R4hsYDsYY=;
  b=I/inhhNHqGDHdYVDYyKHVfN4zP4juXcOmOHE9GLv7LsA+mqUXWJZjVhl
   QlIBIyyz98VZc9HpvlbLV62mNhSoZzqY/Ix1/hUthG9EXRgAKicgYNReB
   ywl47Mk0cr7dQ5uooRR8DevsBT2xk3/TbVKKyled0YkG+vkc1Zs3aGL1l
   FriGztNsIaeGuoHDqqBLHr9Th6bd7pSJdsK43LzssP3WuVQlDQZfpZSoa
   Y1jf3Dy2DDzgPsVr+eEQPQey1Zw+Q9DEQBH4L+YRhTeYPCPsVKBwOFS7N
   Fc9JhmUphfyo64VzePfq2JWqur8Tjr/EGsAH+bvOHse5re3pCq82PZhPn
   Q==;
X-CSE-ConnectionGUID: 6+XMPK0pTuaNGp5jbbd0tw==
X-CSE-MsgGUID: gowm0R4QTLijGOQbbcJA+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50364150"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="50364150"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 00:46:35 -0700
X-CSE-ConnectionGUID: MF9XvEomSWiJ9jyiC06rHg==
X-CSE-MsgGUID: 7UbHPX81RV+hsSUWwlGklw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="147967249"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 00:46:32 -0700
Message-ID: <814eb9a8-3628-4151-81d4-63ac6c445f81@intel.com>
Date: Tue, 27 May 2025 15:46:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/55] QEMU TDX support
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Zhao Liu <zhao1.liu@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
 <e994b189-d155-44d0-ae7d-78e72f3ae0de@redhat.com>
 <792cbff4-6d25-4f39-8a18-3f7affdfe5cd@intel.com>
 <87a56ywucx.fsf@pond.sub.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87a56ywucx.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/2025 12:27 PM, Markus Armbruster wrote:
> Xiaoyao Li<xiaoyao.li@intel.com> writes:
> 
>> On 5/27/2025 12:12 AM, Paolo Bonzini wrote:
>>> On 5/8/25 16:59, Xiaoyao Li wrote:
>>>> This is the v9 series of TDX QEMU enabling. The series is also available
>>>> at github:
>>>> https://github.com/intel-staging/qemu-tdx/tree/tdx-qemu-upstream-v9
>>>>
>>>> Note, this series has a dependency on
>>>> https://lore.kernel.org/qemu-devel/20241217123932.948789-1-xiaoyao.li@intel.com/
>>>>
>>>> =============
>>>> Changes in v9
>>>>
>>>> Comparing to v8, no big change in v9.
>>>>
>>>> V9 mainly collects Reviewed-by tags from Daniel and Zhao Liu (Thanks to
>>>> their review!) and v9 does some small change according to the review
>>>> feedback of them. Please see the individual patch for the detailed
>>>> change history.
>>> Queued, thanks for your patience - this was a huge effort.
> Started late fall 2023?  That's perseverance!

The RFC v1 was posted Feb 2021 actually.

https://lore.kernel.org/qemu-devel/cover.1613188118.git.isaku.yamahata@intel.com/

