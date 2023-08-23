Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC61785094
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 08:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjHWGZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 02:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjHWGZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 02:25:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A7CE51;
        Tue, 22 Aug 2023 23:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692771899; x=1724307899;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=slejTqpOWghte6frBzPjO8NSTtKM/rpyG5Defl6tOVY=;
  b=BkCe4lyT2k9+DTEBHaS9ACCLz1ad+ES7x4uMSVLpiuGlxmVthtJU1YqO
   RlmwO5apRm5/wBWuazsLrnr3pHarkny3m/yVWp6xFtjmZ+VkVHuSkXRXd
   wzY+WVekkBZpQfHDip0Y0qyZvJ8g0eVUElynBvqlzv9fvLCB9rxvusnaZ
   feuWar+Gb7WkdCf8MN31SupsG3OoeA5g/M2NO10q07z5V1At+js3EUeQw
   vZsWWI55X7ktWveg7nThzYgB2UojGumS0ZcERounNReUomeIcvskJ5lGW
   qu1Zt/aGZExp2Gm29E0W9z3XTAGmKLk9wRVfY3OrPV9FXYMBmvcyFmo3R
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="359062876"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="359062876"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 23:24:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="739642598"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="739642598"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 23:24:54 -0700
Message-ID: <498ee0c4-4736-68a7-7cbf-12e54f6a0d22@intel.com>
Date:   Wed, 23 Aug 2023 14:24:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email>
 <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
 <ZOM/8IVsRf3esyQ1@chao-email>
 <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
 <ZOOMwvPd/Cz/cEmv@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZOOMwvPd/Cz/cEmv@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/22/2023 12:11 AM, Sean Christopherson wrote:
> +Aaron
> 
> When resending a patch, e.g. to change To: or Cc:, tag it RESEND.  I got three
> copies of this...
> 
> On Mon, Aug 21, 2023, Hao Xiang wrote:
>>
>>
>> On 2023/8/21 18:44, Chao Gao wrote:
>>> On Mon, Aug 21, 2023 at 05:11:16PM +0800, Hao Xiang wrote:
>>>> For reason that,
>>>>
>>>> The turbo frequency info depends on specific machine type. And the msr value
>>>> of MSR_PLATFORM_INFO may be diferent on diffrent generation machine.
>>>>
>>>> Get following msr bits (needed by turbostat on intel platform) by rdmsr
>>>> MSR_PLATFORM_INFO directly in KVM is more reasonable. And set these msr bits
>>>> as vcpu->arch.msr_platform_info default value.
>>>> -bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
>>>> -bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
>>>
>>> I don't get why QEMU cannot do this with the existing interface, e.g.,
>>> KVM_SET_MSRS.
>>>
>>> will the MSR value be migrated during VM migration?
>>>
>>> looks we are in a dilemma. on one side, if the value is migrated, the value can
>>> become inconsisntent with hardware value. On the other side, changing the ratio
>>> bits at runtime isn't the architectural behavior.
>>>
>>> And the MSR is per-socket. In theory, a system can have two sockets with
>>> different values of the MSR. what if a vCPU is created on a socket and then
>>> later runs on the other socket?
>>>
>>
>> Set these msr bits (needed by turbostat on intel platform) in KVM by
>> default.
>> Of cource, QEMU can also set MSR value by need. It does not conflict.
> 
> It doesn't conflict per se, but it's still problematic.  By stuffing a default
> value, KVM _forces_ userspace to override the MSR to align with the topology and
> CPUID defined by userspace.  

I don't understand how this MSR is related to topology and CPUID?

> And if userspace uses KVM's "default" CPUID, or lack
> thereof, using the underlying values from hardware are all but guaranteed to be
> wrong.

Could you please elaborate?

> The existing code that sets MSR_PLATFORM_INFO_CPUID_FAULT really should not exist,
> i.e. KVM shouldn't shouldn't assume userspace wants to expose CPUID faulting to
> the guest.  That particular one probably isn't worth trying to retroactively fix.
> 
> Ditto for setting MSR_IA32_ARCH_CAPABILITIES; KVM is overstepping, but doing so
> likely doesn't cause problems.
> 
> MSR_IA32_PERF_CAPABILITIES is a different story.  Setting a non-zero default value
> is blatantly wrong, as KVM will advertise vPMU features even if userspace doesn't
> advertise.  Aaron is planning on sending a patch for this one (I'm hoping we can
> get away with retroactively dropping the code without having to add a quirk).
> 
> *If* we need KVM to expose the ratios to userspace, then the correct way to do so
> is handle turbo and efficiency ratio information is to by implementing support in
> kvm_get_msr_feature(), i.e. KVM_GET_MSRS on /dev/kvm.  Emphasis on "if", because
> I would prefer to do nothing in KVM if that information is already surfaced to
> userspace through other mechanisms in the kernel.

