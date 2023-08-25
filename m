Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C891C787E94
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 05:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjHYD16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 23:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbjHYD1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 23:27:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF02E54;
        Thu, 24 Aug 2023 20:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692934067; x=1724470067;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jRT2h211DwuKWblgtoAe1325IrCALT7d/B8e2ciggbU=;
  b=SDlQ/ceXrBCm2Ky5E3XC920/xCKmK645JNuSdq1PnTXnS+z8/qlg7YhB
   3JghG8Kf4GUQlDxDDU+HGUHD3fQrcawvc39bcL1mzNChqS8qOmCv7q6+d
   BYhE3rRDhzxA4YJfa4H192TXa0D6JoFoJmogfpen1qBx2VNG0jFlem4Q3
   y18mJrf3p5kXb7O6pvhegV77V0FhH3lJjge2dMDESq1FoOflneOsY2Wfi
   Ff2OwAlgvuaXptowgxOluJ0ANV6fRzY6G2L50bXwb//zQzQWKg3Z2+e3F
   PPm8FJJ9gqxkdvieqmAuCPmEWYC21iiy2HYj88jEbE65iWfW21bXMYSWc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="354949251"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="354949251"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 20:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="772354524"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="772354524"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.81]) ([10.93.16.81])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 20:27:33 -0700
Message-ID: <2934e617-8f47-5f0e-878e-338067f1b096@intel.com>
Date:   Fri, 25 Aug 2023 11:27:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Hao Xiang <hao.xiang@linux.alibaba.com>,
        Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email>
 <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
 <ZOM/8IVsRf3esyQ1@chao-email>
 <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
 <ZOOMwvPd/Cz/cEmv@google.com>
 <498ee0c4-4736-68a7-7cbf-12e54f6a0d22@intel.com>
 <ZOYYFPrQSPUjS7kk@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOYYFPrQSPUjS7kk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/2023 10:31 PM, Sean Christopherson wrote:
> On Wed, Aug 23, 2023, Xiaoyao Li wrote:
>> On 8/22/2023 12:11 AM, Sean Christopherson wrote:
>>>> Set these msr bits (needed by turbostat on intel platform) in KVM by
>>>> default.  Of cource, QEMU can also set MSR value by need. It does not
>>>> conflict.
>>>
>>> It doesn't conflict per se, but it's still problematic.  By stuffing a default
>>> value, KVM _forces_ userspace to override the MSR to align with the topology and
>>> CPUID defined by userspace.
>>
>> I don't understand how this MSR is related to topology and CPUID?
> 
> Heh, looked at the SDM to double check myself, and the first hit when searching
> for MSR_PLATFORM_INFO says:
> 
>    When TSC scaling is enabled for a guest using Intel PT, the VMM should ensure
>    that the value of Maximum Non-Turbo Ratio[15:8] in MSR_PLATFORM_INFO (MSR 0CEH)
>    and the TSC/”core crystal clock” ratio (EBX/EAX) in CPUID leaf 15H are set in
>    a manner consistent with the resulting TSC rate that will be visible to the VM.

I see.

> As Chao pointed out, the MSR is technically per package, so a weird setup could
> have sockets with different frequencies, or enumerate a virtual topology to the
> guest with such a configuration.  

Every feature might get into trouble if not consistent across packages, 
no matter per-thread/per-core/per-package.

> I doubt/hope no one actually does something
> like that, but it's theoretically possible, and one of the many reasons why KVM
> needs to stay out of the way and let userspace define the vCPU model.

For this specific case, the max non-turbo frequency needs to be 
consistent with TSC frequency. Because KVM has default TSC frequency as 
host's tsc_khz, for correctness, it should have a default value to match 
with KVM's default TSC when userspace provide no explicit configuration.

But it's not the problem this patch targets. I'm OK to keep returning 0 
as-is until some bug reported due to the inconsistent between max 
non-turbo frequency and TSC frequency.

>>> And if userspace uses KVM's "default" CPUID, or lack thereof, using the
>>> underlying values from hardware are all but guaranteed to be wrong.
>>
>> Could you please elaborate?
> 
> I guess an empty CPUID would probably be ok?  If there's no CPUID.0x15, it can't
> be wrong.  It's largely a moot point though, I highly doubt anyone runs a "real"
> VM without populating _something_ in guest CPUID.

current QEMU doesn't configure CPUID leaf 0x15, nor does it configure 
MSR_PLATFORM_INFO[15:8]. I need to take time to dig how Linux gets the 
TSC frequency.

