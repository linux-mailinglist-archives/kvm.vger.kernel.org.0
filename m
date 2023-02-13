Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E969520F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjBMUmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 15:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBMUmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 15:42:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318ED15C8D;
        Mon, 13 Feb 2023 12:42:21 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676320939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kod532Kzy81F3WX9JaQvMDl3mXZS1ubjRDWA/ArYp8o=;
        b=Plv8KLQzWy5a52dChtlhVxRyP+ggM9C5YROAhSpnDEF0Hd9DEk5aDnirV5UtAW0H76ywkT
        B6AaSd0vkCu6C+Gl8rG/IYgPjA0963SfVwsc9mPX42FRBNY7w6AV1awl2xrEvAXZYh4MBP
        2PYkaWkH+9s6Me4bj9K7Rk41AU+7toGtxCdJ0ZoGSYawenqvN1aPZI3OZr+/t5sCT1JuRA
        UULDWNBo7FKDEQgqVck6wUd07svfikT6Ejr93uTp5sWQW5MBDp8Dra/xKslZNgFKBBL/vM
        oTNmzbgTtyZEcjJoDe93hzcpz6waLfNwlMrO7jTFxepEc8vwWYOOOYad++QcDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676320939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kod532Kzy81F3WX9JaQvMDl3mXZS1ubjRDWA/ArYp8o=;
        b=UYJc4sju02dHBn72mHpDWitves66/xVXuG1xVRgb9sMcBiPShYI6v6+bXuAnWL96rPvP88
        CSN3dve+zS65rDAg==
To:     Usama Arif <usama.arif@bytedance.com>,
        David Woodhouse <dwmw2@infradead.org>, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [External] Re: [PATCH v8 8/9] x86/mtrr: Avoid repeated save of
 MTRRs on boot-time CPU bringup
In-Reply-To: <04d98646-7c2e-9a62-1340-2d8efe69a121@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-9-usama.arif@bytedance.com> <87mt5m1yiz.ffs@tglx>
 <9b6bca9c-7189-a2d5-8c0a-f55c24f54b62@bytedance.com> <878rh61jqx.ffs@tglx>
 <6fc16f3048719058bccce9d488bcb75252f49031.camel@infradead.org>
 <04d98646-7c2e-9a62-1340-2d8efe69a121@bytedance.com>
Date:   Mon, 13 Feb 2023 21:42:18 +0100
Message-ID: <87y1p1s3f9.ffs@tglx>
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

On Mon, Feb 13 2023 at 15:19, Usama Arif wrote:
> On 10/02/2023 08:55, David Woodhouse wrote:
>> On Fri, 2023-02-10 at 00:50 +0100, Thomas Gleixner wrote:
>>> I knew that already :) But seriously:
>>>
>>> If the MTRRs are changed post boot then the cached values want to be
>>> updated too.
>> 
> I had previously only done smpboot time measurements for the whole 
> patchset, but I tested the patchset without this commit and it doesn't 
> make a difference to smpboot time as its negligable work to read those 
> MTRR MSRs into mtrr_state.fixed_ranges.
> This commit is also independent of parallel smp bringup, similar to 
> reusing timer calibration so I think it could be considered as a 
> separate patchset if needed. I will post the next revision without this 
> commit, but here is my view on MTRR save/restore (which shouldn't matter 
> for the next revision...).

Correct. It's an orthogonal problem and not a prerequisite for the
initial parallel bringup.

> If the MTRR changes on a running system, there might be a bug during 
> hotplug in the original code that handles MTRR? which is also carried 
> over in this patch.
>  From what I can see, MTRR is only saved+restored during initial boot, 
> hotplugging CPU and __save/__restore_processor_state() (used in creating 
> image for hibernation, suspend, kexec...). So if for e.g. in a running 
> system (that has not hibernated, suspended, kexeced), if MTRR for CPU0 
> (first_cpu) changed post-boot and CPU3 is hotplugged, only MTRR for CPU3 
> is updated and CPU0 and CPU3 will hold the same value, while the rest of 
> the CPUs will have the older first-boot value? This behavior will happen 
> with or without this patch. I think this is what Thomas is referring to 
> above when he says that the cached values want to be updated? But the 
> issue is present in the original code as well.

No. Changing a MTTR is done via stop_machine() on all online CPUs in
parallel. So there is no bug.

But its stupid that an update to a MTRR is not updating the cached
value, which results in this sillyness of reading back the real values
into the cache on CPU hotplug in order to set them up correctly on the
upcoming CPU.

So the real improvement would be to:

  1) Cache the MTRRs on the boot CPU once during early boot

  2) When MTRRs are changed then update the cache too

That ensures that the MTRR cache is always up to date and can be
utilized on CPU hotplug.

The 'if (state < RUNNING)' thing is just a sloppy hack which tries to
save a few cycles at boot.

Thanks,

        tglx
