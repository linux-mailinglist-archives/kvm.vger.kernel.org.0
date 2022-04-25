Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80FA50E159
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 15:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiDYNTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 09:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDYNTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 09:19:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A191F17E0A;
        Mon, 25 Apr 2022 06:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650892559; x=1682428559;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zYnxt+dOMmGR9ixG9CjwBptYMb5IpG26lgSZqv0tNlM=;
  b=aHww7+9ty9Cdx+Mb3xk4CvVtIXsANaKQGowAFgmnKXidGIgtrDFrIUUH
   x5G29vfc9XdGygMZlw0gq7/irUqGiEeBMtd0Hqc+pz7jdQ1NETj+p9Gt/
   A2oxGTzGs42KLi4mB09zB/aLspg1FStfSH7T8kXkIsfKffIP+LNcJzqzi
   YKGkGTT49MF1h5Ux40TLAHF1rJXvR5mfBk88Lldv5M6P91l4W9+qdncSE
   dEHUe7TeSioxEjrs23c5Y+k1Cx0mkR2zjIj+bvYKxdnnpLovrI+VhCMVG
   /yO6yF9beDc8O9Oh8pfoQtoZj5PezB5B8mWI9xav2ax1ywuKbMNe+rK7i
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="265044384"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="265044384"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 06:15:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="579279569"
Received: from pvagawan-mobl1.amr.corp.intel.com (HELO [10.0.2.15]) ([10.252.47.228])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 06:15:52 -0700
Message-ID: <ff1e190a-95e6-e2a6-dc01-a46f7ffd2162@intel.com>
Date:   Mon, 25 Apr 2022 16:15:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sdeep@vmware.com" <sdeep@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Andrew.Cooper3@citrix.com" <Andrew.Cooper3@citrix.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
 <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
 <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
 <6f07a7d4e1ad4440bf6c502c8cb6c2ed@intel.com>
 <c3e1842b-79c3-634a-3121-938b5160ca4c@intel.com>
 <50fd2671-6070-0eba-ea68-9df9b79ccac3@intel.com> <87ilqx33vk.ffs@tglx>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <87ilqx33vk.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/04/22 12:32, Thomas Gleixner wrote:
> On Mon, Apr 25 2022 at 08:30, Adrian Hunter wrote:
>> On 14/03/22 13:50, Adrian Hunter wrote:
>>>> TSC offsetting may also be a problem. The VMCS TSC offset must be discoverable by the
>>>> guest. This can be done via TSC_ADJUST MSR. The offset in the VMCS and the guest
>>>> TSC_ADJUST MSR must always be equivalent, i.e. a write to TSC_ADJUST in the guest
>>>> must be reflected in the VMCS and any changes to the offset in the VMCS must be
>>>> reflected in the TSC_ADJUST MSR. Otherwise a para-virtualized method must
>>>> be invented to communicate an arbitrary VMCS TSC offset to the guest.
>>>>
>>>
>>> In my view it is reasonable for perf to support TSC as a perf clock in any case
>>> because:
>>> 	a) it allows users to work entirely with TSC if they wish
>>> 	b) other kernel performance / debug facilities like ftrace already support TSC
>>> 	c) the patches to add TSC support are relatively small and straight-forward
>>>
>>> May we have support for TSC as a perf event clock?
>>
>> Any update on this?
> 
> If TSC is reliable on the host, then there is absolutely no reason not
> to use it in the guest all over the place. And that is independent of
> exposing ART to the guest.
> 
> So why do we need extra solutions for PT and perf, ftrace and whatever?
> 
> Can we just fix the underlying problem and make the hypervisor tell the
> guest that TSC is stable, reliable and good to use?
> 
> Then everything else just falls into place and using TSC is a
> substantial performance gain in general. Just look at the VDSO
> implementation of __arch_get_hw_counter() -> vread_pvclock():
> 
> Instead of just reading the TSC, this needs to take a nested seqcount,
> read TSC and do yet another mult/shift, which makes clock_gettime() ~20%
> slower than necessary.
> 
> It's hillarious, that we still cling to this pvclock abomination, while
> we happily expose TSC deadline timer to the guest. TSC virt scaling was
> implemented in hardware for a reason.

So you are talking about changing VMX TCS Offset on every VM-Entry to try to hide
the time jumps when the VM is scheduled out?  Or neglect that and just let the time
jumps happen?

If changing VMX TCS Offset, how can TSC be kept consistent between each VCPU i.e.
wouldn't that mean each VCPU has to have the same VMX TSC Offset?
