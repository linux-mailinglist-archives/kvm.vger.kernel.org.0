Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047BC75A4F5
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 06:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjGTEFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 00:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjGTEE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 00:04:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A1F2103
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 21:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689825898; x=1721361898;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hnwbZw3Bs1x81EISe4qtfBvR6DcvI37Rl4Rju9n74PQ=;
  b=A3m0OMAK836yULU/bQA6ElBOgmta6bOtian0sYcub3YNLHDS9SUldnot
   10SSDn0Co7zFLhNwHme48NINBdgVp7RecLZ1itD2BOZiIaKk2gpOs0cp5
   hxhTR6FqboPqWZDBFoW2/FgzYCUER8s4Yy9WsaB9D4hcHKMd1POLMQI86
   xK37SVwOzxoyf3NoRcIfKN/vVgcvEGX2Ri/FoVtuO7CSL7YejtcbQOzcN
   6w/hKZ/yqeF+vGnWs8GoLCzRgGnV5GtTy9r4qbS9QbMZ+jy0JUBZr+Ece
   XMid/PjAc4efW90kV2cWudNCmMGy31tVnGKO03Cjq1dd+c6IrY63FpDCY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="364084928"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="364084928"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 21:04:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="848285009"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="848285009"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 21:04:56 -0700
Message-ID: <5f519f61-f80d-700f-099a-6f34de3522cf@intel.com>
Date:   Thu, 20 Jul 2023 12:04:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZLiUrP9ZFMr/Wf4/@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/2023 9:58 AM, Chao Gao wrote:
> On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
>> On 7/20/2023 2:08 AM, Jim Mattson wrote:
>>> Normally, we would restrict guest MSR writes based on guest CPU
>>> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
>>> the case.
> 
> This issue isn't specific to the two MSRs. Any MSRs that are not
> intercepted and with some reserved bits for future extenstions may run
> into this issue. Right? 

The luck is KVM defines a list of MSRs that can be passthrough for vmx:

static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS]  = {
	MSR_IA32_SPEC_CTRL,
	MSR_IA32_PRED_CMD,
	MSR_IA32_FLUSH_CMD,
	MSR_IA32_TSC,
#ifdef CONFIG_X86_64
	MSR_FS_BASE,
	MSR_GS_BASE,
	MSR_KERNEL_GS_BASE,
	MSR_IA32_XFD,
	MSR_IA32_XFD_ERR,
#endif
	MSR_IA32_SYSENTER_CS,
	MSR_IA32_SYSENTER_ESP,
	MSR_IA32_SYSENTER_EIP,
	MSR_CORE_C1_RES,
	MSR_CORE_C3_RESIDENCY,
	MSR_CORE_C6_RESIDENCY,
	MSR_CORE_C7_RESIDENCY,
};

and only a few of them has reserved bits. It's feasible to fix them.

> IMO, it is a conflict of interests between
> disabling MSR write intercept for less VM-exits and host's control over
> the value written to the MSR by guest.
> 
> We may need something like CR0/CR4 masks and read shadows for all MSRs
> to address this fundamental issue.

It looks unacceptable for HW vendor. There are so many MSRs.

>>>
>>> For the first non-zero write to IA32_SPEC_CTRL, we check to see that
>>> the host supports the value written. We don't care whether or not the
>>> guest supports the value written (as long as it supports the MSR).
>>> After the first non-zero write, we stop intercepting writes to
>>> IA32_SPEC_CTRL, so the guest can write any value supported by the
>>> hardware. This could be problematic in heterogeneous migration pools.
>>> For instance, a VM that starts on a Cascade Lake host may set
>>> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
>>> CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
>>> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
>>> IA32_SPEC_CTRL to its current value, because Skylake doesn't support
>>> PSFD.
> 
> It is a guest fault. Can we modify guest kernel in this case?

I don't think it's a guest fault. Guest can do whatever it wants and KVM 
cannot expect guest's behavior.

>>>
>>> We disable write intercepts IA32_PRED_CMD as long as the guest
>>> supports the MSR. That's fine for now, since only one bit of PRED_CMD
>>> has been defined. Hence, guest support and host support are
>>> equivalent...today. But, are we really comfortable with letting the
>>> guest set any IA32_PRED_CMD bit that may be defined in the future?
>>>
>>> The same question applies to IA32_SPEC_CTRL. Are we comfortable with
>>> letting the guest write to any bit that may be defined in the future?
>>
>> My point is we need to fix it, though Chao has different point that sometimes
>> performance may be more important[*]
>>
>> [*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/
> 
> Maybe KVM can provide options to QEMU. e.g., we can define a KVM quirk.
> Disabling the quirk means always intercept IA32_SPEC_CTRL MSR writes.
> 
>>
>>> At least the AMD approach with V_SPEC_CTRL prevents the guest from
>>> clearing any bits set by the host, but on Intel, it's a total
>>> free-for-all. What happens when a new bit is defined that absolutely
>>> must be set to 1 all of the time?
> 
> I suppose there is no such bit now. For SPR and future CPUs, "virtualize
> IA32_SPEC_CTRL" VMX feature can lock some bits to 0 or 1 regardless of
> the value written by guests.

