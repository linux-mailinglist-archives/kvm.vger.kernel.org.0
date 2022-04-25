Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7550DCCB
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbiDYJjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241541AbiDYJiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:38:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6B27CE6;
        Mon, 25 Apr 2022 02:32:18 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650879136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GuS0+eUzG5BtLo3Moko/17XZLrJRu9fvWmqLPOFEyN8=;
        b=vHXQxaUeaHvw4Xiz9T9MB1+1qh9heHJPy5Tp0CxvFSUhFNU5qp75M1qmmCTZjp7fcr03Mc
        DjknOq742hHhWHCgVaUqMV5QYSrIp6361DJQhPOALiJckLkC991h1Mr+42ApMWH56Vfh0F
        7mJgACdr44D8eYg66nI9zAzAHbIRuN0HHI7/UlQdX3VS2B+Oxyebso3Qtgag9Mt6iViyab
        tDG0GB7ENzwrMSP5r4Wy5a7tNw9Jkkj9NVzO1e9h5xHJNjukYDva81fOLEsZmohq7W4tqx
        xUNit134OoWKy6uGvAEiiM4f36FVlZMnbhZSJ7iGgnU26PD+j+n99dbSgNUjng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650879136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GuS0+eUzG5BtLo3Moko/17XZLrJRu9fvWmqLPOFEyN8=;
        b=kUMwfiHvNx/7GQIpsSk2x/vGiCdnpXgig/ECozp+dMy2shcP4mvjucEJMnNWIM28e3948x
        PtvRHTt5Spu12GCw==
To:     Adrian Hunter <adrian.hunter@intel.com>,
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
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds
 as a perf event clock
In-Reply-To: <50fd2671-6070-0eba-ea68-9df9b79ccac3@intel.com>
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
 <50fd2671-6070-0eba-ea68-9df9b79ccac3@intel.com>
Date:   Mon, 25 Apr 2022 11:32:15 +0200
Message-ID: <87ilqx33vk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 25 2022 at 08:30, Adrian Hunter wrote:
> On 14/03/22 13:50, Adrian Hunter wrote:
>>> TSC offsetting may also be a problem. The VMCS TSC offset must be discoverable by the
>>> guest. This can be done via TSC_ADJUST MSR. The offset in the VMCS and the guest
>>> TSC_ADJUST MSR must always be equivalent, i.e. a write to TSC_ADJUST in the guest
>>> must be reflected in the VMCS and any changes to the offset in the VMCS must be
>>> reflected in the TSC_ADJUST MSR. Otherwise a para-virtualized method must
>>> be invented to communicate an arbitrary VMCS TSC offset to the guest.
>>>
>> 
>> In my view it is reasonable for perf to support TSC as a perf clock in any case
>> because:
>> 	a) it allows users to work entirely with TSC if they wish
>> 	b) other kernel performance / debug facilities like ftrace already support TSC
>> 	c) the patches to add TSC support are relatively small and straight-forward
>> 
>> May we have support for TSC as a perf event clock?
>
> Any update on this?

If TSC is reliable on the host, then there is absolutely no reason not
to use it in the guest all over the place. And that is independent of
exposing ART to the guest.

So why do we need extra solutions for PT and perf, ftrace and whatever?

Can we just fix the underlying problem and make the hypervisor tell the
guest that TSC is stable, reliable and good to use?

Then everything else just falls into place and using TSC is a
substantial performance gain in general. Just look at the VDSO
implementation of __arch_get_hw_counter() -> vread_pvclock():

Instead of just reading the TSC, this needs to take a nested seqcount,
read TSC and do yet another mult/shift, which makes clock_gettime() ~20%
slower than necessary.

It's hillarious, that we still cling to this pvclock abomination, while
we happily expose TSC deadline timer to the guest. TSC virt scaling was
implemented in hardware for a reason.

Thanks,

        tglx
