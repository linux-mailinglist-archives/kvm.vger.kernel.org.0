Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7807B6DDDA0
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjDKOWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDKOWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:22:14 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D7569E;
        Tue, 11 Apr 2023 07:22:14 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 470262174E58;
        Tue, 11 Apr 2023 07:22:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 470262174E58
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681222933;
        bh=9f8MMAF+5nW8ggEdvvifzFTTUP6zaiECoccXN8eh5Uo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Poj+4wi3KaDcVfDdah1YnqjfdC5XU/aW78RDB+DFGVCsO8nZAtr+cQTBqc/STdT7o
         p6dhgtr4zdWAe3CF8yZg6zCPRtbwMcqoiKQd/pXemgBQ8IWM/5QMa+2UyEB9w/ZrMx
         U+ltYikZ/zAx5XE4zVu5QmN13AVpgMQ1pZtFYrj8=
Message-ID: <ecd3d8de-859b-e5dd-c3bf-ea9c3c0aac60@linux.microsoft.com>
Date:   Tue, 11 Apr 2023 16:22:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <ZAd2MRNLw1JAXmOf@google.com>
 <959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com>
 <ZDSa9Bbqvh0btgQo@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZDSa9Bbqvh0btgQo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-20.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/11/2023 1:25 AM, Sean Christopherson wrote:
> On Wed, Apr 05, 2023, Jeremi Piotrowski wrote:
>> On 3/7/2023 6:36 PM, Sean Christopherson wrote:
>>> Thinking about this more, I would rather revert commit 1e0c7d40758b ("KVM: SVM:
>>> hyper-v: Remote TLB flush for SVM") or fix the thing properly straitaway.  KVM
>>> doesn't magically handle the flushes correctly for the shadow/legacy MMU, KVM just
>>> happens to get lucky and not run afoul of the underlying bugs.  The revert appears
>>> to be reasonably straightforward (see bottom).
>>
>> Hi Sean,
>>
>> I'm back, and I don't have good news. The fix for the missing hyperv TLB flushes has
>> landed in Linus' tree and I now had the chance to test things outside Azure, in WSL on my
>> AMD laptop.
>>
>> There is some seriously weird interaction going on between TDP MMU and Hyper-V, with
>> or without enlightened TLB. My laptop has 16 vCPUs, so the WSL VM also has 16 vCPUs.
>> I have hardcoded the kernel to disable enlightened TLB (so we know that is not interfering).
>> I'm running a Flatcar Linux VM inside the WSL VM using legacy BIOS, a single CPU
>> and 4GB of RAM.
>>
>> If I run with `kvm.tdp_mmu=0`, I can boot and shutdown my VM consistently in 20 seconds.
>>
>> If I run with TDP MMU, the VM boot stalls for seconds at a time in various spots
>> (loading grub, decompressing kernel, during kernel boot), the boot output feels like
>> it's happening in slow motion. The fastest I see it finish the same cycle is 2 minutes,
>> I have also seen it take 4 minutes, sometimes even not finish at all. Same everything,
>> the only difference is the value of `kvm.tdp_mmu`.
> 
> When a stall occurs, can you tell where the time is lost?  E.g. is the CPU stuck
> in L0, L1, or L2?  L2 being a single vCPU rules out quite a few scenarios, e.g.
> lock contention and whatnot.

It shows up as around 90% L2 time, 10% L1 time. I don't have great visibility into L0 time
right now, I'm trying to find someone who might be able to help with that.

> 
> If you can run perf in WSL, that might be the easiest way to suss out what's going
> on.

I can run perf, what trace would help?

> 
>> So I would like to revisit disabling tdp_mmu on hyperv altogether for the time being but it
>> should probably be with the following condition:
>>
>>   tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && !hypervisor_is_type(X86_HYPER_MS_HYPERV)
>>
>> Do you have an environment where you would be able to reproduce this? A Windows server perhaps
>> or an AMD laptop?
> 
> Hrm, not easily, no.  Can you try two things?
> 
>   1. Linus' tree on Intel hardware
This shows the same problematic behavior (tested commit 0d3eb744aed40ffce820cded61d7eac515199165).

>   2. kvm-x86/next[*] on Intel hardware

Same here (tested kvm-x86-next-2023.04.10)

> 
> Don't bother with #2 if #1 (Linus' tree) does NOT suffer the same stalls as AMD.
> #2 is interesting iff Intel is also affected as kvm-x86/next has an optimization
> for CR0.WP toggling, which was the achilles heel of the TDP MMU.  If Intel isn't
> affected, then something other than CR0.WP is to blame.
> 
> I fully expect both experiments to show the same behavior as AMD, but if for some
> reason they don't, the results should help narrow the search.

The results are the same for both branches, and it does look like this affects AMD and
Intel equally.

So seeing as this will likely take a while to figure out (and I know I won't be able to
spend too many cycles on this in the next few weeks), what do you think of a patch to
disable tdp_mmu in this configuration (for the time being?).

Something else I've been wondering: in a KVM-on-KVM setup, is tdp_mmu used in both L0
and L1 hypervisors right now?

> 
> [*] https://github.com/kvm-x86/linux/tree/next

