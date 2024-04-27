Return-Path: <kvm+bounces-16099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF6B8B446B
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 07:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24373282F95
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 05:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2A340853;
	Sat, 27 Apr 2024 05:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WsULUO2u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F292381C7;
	Sat, 27 Apr 2024 05:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714196333; cv=none; b=tapBpXwNDoQZ5s8nG16Q/wIYOSlnVtfDT4qq/RUaRhc7teBYjNyv7OWXPOdRw/wUUo8l2Ubh5GkG7crdBS4gCuDcMda+TDoW8XJzANQHdF2gUiVveRmv+Ljxe25B5IoVSm48RlWM7UdI0X1XfTi8U3jzHB4pVGIlUbIH/bDmWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714196333; c=relaxed/simple;
	bh=K4EbgByRT7TtstqD4HXOVYBvbr60newEfJFOinghURg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PH3XwcG5QFw08RegimstVu8lgBsrzompxOGpNaT9PWYCS/N/v9UwYREQyVixLDX0qg3x1hJEQt0dPCO+fw7pKcIhYOHKyUNwjOyK5ZygBWrCTFcoFzwjP1m2awkUVlSu+6Ol7Dc5jHXYklQRXfwmfS47oBrjm/RIbBslEgA+/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WsULUO2u; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714196331; x=1745732331;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K4EbgByRT7TtstqD4HXOVYBvbr60newEfJFOinghURg=;
  b=WsULUO2u9s6Xa1/9ZIYCeVyeZGeWzGYFd7FTqSREUsBUkyq4VHqdlenE
   vKzB0EfHhJ/BFye6kh/Q1VCVT0m2RYYDA23t9TeUkVgR2yR0oy4mK4fI+
   p5B3Kp0+/5anBdtrUlnFGuLzDO4C4rUBe4XzaNkB5tjWbCqgWaRROKTAS
   4mKq/p7j/bb6zXg+49qyjMcZtgzajp2DZkZrgFyFZLscbV655wQAEK/jG
   Fyy+CeBOsnNpLyNlvLCW8zwgzMB7JCW90ObeDnNkD2pJy9eXJRDYtc1WE
   CwPWtgy+L7hV2KtZn/yj+oepjwMJFiegDD2o3mXIhyr4Lj2IwI8adkKSY
   Q==;
X-CSE-ConnectionGUID: bemiSHTFSsuIXRdzsYhDRw==
X-CSE-MsgGUID: 0MuWYMa2QNSUuMiDdzICEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="32437623"
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="32437623"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 22:38:51 -0700
X-CSE-ConnectionGUID: 0FfLCUrISlq89yEGnkD66w==
X-CSE-MsgGUID: 6Edd325aRAGxni0rsDbMoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="56530661"
Received: from akalapal-mobl.amr.corp.intel.com (HELO [10.124.149.167]) ([10.124.149.167])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 22:38:50 -0700
Message-ID: <002340b7-86e2-4be3-8468-71d59233c32e@intel.com>
Date: Fri, 26 Apr 2024 22:38:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
 pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
 seanjc@google.com, vannapurve@google.com, jmattson@google.com,
 mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com,
 rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <f5a80896-e1aa-4f23-a739-5835f7430f78@intel.com>
 <12445519-efd9-42e9-a226-60cfa9d2a880@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <12445519-efd9-42e9-a226-60cfa9d2a880@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/26/2024 4:26 PM, Reinette Chatre wrote:
> Hi Zide,
> 
> On 4/26/2024 4:06 PM, Chen, Zide wrote:
>>
>>
>> On 4/25/2024 3:07 PM, Reinette Chatre wrote:
>>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>> new file mode 100644
>>> index 000000000000..5100b28228af
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>> @@ -0,0 +1,166 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Test configure of APIC bus frequency.
>>> + *
>>> + * Copyright (c) 2024 Intel Corporation
>>> + *
>>> + * To verify if the APIC bus frequency can be configured this test starts
>>
>> Nit: some typos here?
> 
> Apologies but this is not obvious to me. Could you please help
> by pointing out all those typos to me?

Do you think it's more readable to add a ","?

- * To verify if the APIC bus frequency can be configured this test starts
+ * To verify if the APIC bus frequency can be configured, this test starts
  * by setting the TSC frequency in KVM, and then:

