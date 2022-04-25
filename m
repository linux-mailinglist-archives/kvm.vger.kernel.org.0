Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9CF50E677
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 19:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243727AbiDYRJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 13:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243722AbiDYRJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 13:09:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7948038DA1;
        Mon, 25 Apr 2022 10:06:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1650906359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZUDdu1OQnuiL9GvFQHLzieqdApEYcfcerAmFX1ae7Fo=;
        b=kOy/628PH7EV8vd8Bt7kZYGVV4HH2pzB4IOTaqLluAxvnHwNnpQgoIs22zk31UBsLyiO+g
        pawUq2PFZuAhwQYxXo2cs7jipQTA4E3eFOYp8u3t/RoivhkrCf5YorU/t3tH5W4NX/IpTm
        TKM/NYt8SjOfKI3TzCEp1ds+AU0Iw8xTIbAI4UfR0iawo9YEe4k+ML9D4Z8QR+Ylv2KQM2
        o5tkv5qW+yvlsjcCEu/7ahiIBuqOyLV83Mxe1aXMquFFyuYKauKIey7Gb0RkvSeywP3pZD
        6+F5lyl9VUiubCZbFwfoOUZ/ZEpARHDC4VKKOw6F/pPiB10jkkCjW4jC2oyG5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1650906359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZUDdu1OQnuiL9GvFQHLzieqdApEYcfcerAmFX1ae7Fo=;
        b=rWgCcD6eod8vPhzNBba08C1rj2XHbFC5P7XdDbrtkk5CwN0PDscGntrk8gXPB4CyWzdoyQ
        YnRFHLfe4Mhyn7AQ==
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
In-Reply-To: <ff1e190a-95e6-e2a6-dc01-a46f7ffd2162@intel.com>
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
 <ff1e190a-95e6-e2a6-dc01-a46f7ffd2162@intel.com>
Date:   Mon, 25 Apr 2022 19:05:58 +0200
Message-ID: <87fsm114ax.ffs@tglx>
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

On Mon, Apr 25 2022 at 16:15, Adrian Hunter wrote:
> On 25/04/22 12:32, Thomas Gleixner wrote:
>> It's hillarious, that we still cling to this pvclock abomination, while
>> we happily expose TSC deadline timer to the guest. TSC virt scaling was
>> implemented in hardware for a reason.
>
> So you are talking about changing VMX TCS Offset on every VM-Entry to try to hide
> the time jumps when the VM is scheduled out?  Or neglect that and just let the time
> jumps happen?
>
> If changing VMX TCS Offset, how can TSC be kept consistent between each VCPU i.e.
> wouldn't that mean each VCPU has to have the same VMX TSC Offset?

Obviously so. That's the only thing which makes sense, no?

Thanks,

        tglx
