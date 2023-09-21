Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07ADF7A9FA3
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjIUUZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjIUUZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:25:28 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF049E8;
        Thu, 21 Sep 2023 13:06:37 -0700 (PDT)
Received: from [192.168.2.59] (109-252-153-31.dynamic.spd-mgts.ru [109.252.153.31])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 2A6DD66072A2;
        Thu, 21 Sep 2023 21:06:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1695326795;
        bh=HJZj4tL19myGpTxphjexxKcgBooAQOGMkPxijqRLW4k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VR42JGadjRAYiveQpgi1ROWyHZVJRToum30ci6EUeexG5WQPL75rWfp1AUwbguY1h
         4cX3JGs5B/KTytKRbeRMUJ0pOSjK6saByxaxd6vcPaQLLgMspuuqwawOyYQCm0CTQ7
         bg8wV6ylxVaUbuMQDOiQLUlPV2Qcu6V3U4AXV9d8ro5MgUbAlOIZpjH35xbIBd/UYr
         +1nSuzUPzFfveko6knVummHMJb3FeKg0HfIgsnz6aFSbt5Cvh8fZohJZ0CUOU8z6yj
         bl+Yoxt2AGI6YU7+Lk/1oquOvrp5FnMcal/AVr7AGNcs4ChI/spifJ81zaKrddT30L
         zqpXSpoUEro4A==
Message-ID: <2126e800-f9db-b3f8-3d1c-454b5b2c169e@collabora.com>
Date:   Thu, 21 Sep 2023 23:06:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
Content-Language: en-US
To:     David Stevens <stevensd@chromium.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230911021637.1941096-1-stevensd@google.com>
 <20230911021637.1941096-7-stevensd@google.com>
 <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com>
 <207c8e59-f92a-96c0-bc5e-39b73a840110@collabora.com>
 <CAD=HUj51M9Eh=5Q=XQjPJ7No4i-z0en-1L3s0G8_fBZp0+NUZw@mail.gmail.com>
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <CAD=HUj51M9Eh=5Q=XQjPJ7No4i-z0en-1L3s0G8_fBZp0+NUZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/23 05:59, David Stevens wrote:
> On Mon, Sep 18, 2023 at 8:19 PM Dmitry Osipenko
> <dmitry.osipenko@collabora.com> wrote:
>>
>> On 9/18/23 12:58, Dmitry Osipenko wrote:
>>> On 9/11/23 05:16, David Stevens wrote:
>>>> From: David Stevens <stevensd@chromium.org>
>>>>
>>>> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
>>>> to map memory into the guest that is backed by non-refcounted struct
>>>> pages - for example, the tail pages of higher order non-compound pages
>>>> allocated by the amdgpu driver via ttm_pool_alloc_page.
>>>>
>>>> The bulk of this change is tracking the is_refcounted_page flag so that
>>>> non-refcounted pages don't trigger page_count() == 0 warnings. This is
>>>> done by storing the flag in an unused bit in the sptes. There are no
>>>> bits available in PAE SPTEs, so non-refcounted pages can only be handled
>>>> on TDP and x86-64.
>>>>
>>>> Signed-off-by: David Stevens <stevensd@chromium.org>
>>>> ---
>>>>  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++----------
>>>>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
>>>>  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
>>>>  arch/x86/kvm/mmu/spte.c         |  4 ++-
>>>>  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
>>>>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
>>>>  include/linux/kvm_host.h        |  3 ++
>>>>  virt/kvm/kvm_main.c             |  6 ++--
>>>>  8 files changed, 76 insertions(+), 32 deletions(-)
>>>
>>> Could you please tell which kernel tree you used for the base of this
>>> series? This patch #6 doesn't apply cleanly to stable/mainline/next/kvm
>>>
>>> error: sha1 information is lacking or useless (arch/x86/kvm/mmu/mmu.c).
>>> error: could not build fake ancestor
>>
>> I applied the patch manually to v6.5.2 and tested Venus using Intel TGL iGPU, the intel driver is crashing:
>>
>>    BUG: kernel NULL pointer dereference, address: 0000000000000058
>>    #PF: supervisor read access in kernel mode
>>    #PF: error_code(0x0000) - not-present page
>>    PGD 0 P4D 0
>>    Oops: 0000 [#1] PREEMPT SMP
>>    CPU: 1 PID: 5926 Comm: qemu-system-x86 Not tainted 6.5.2+ #114
>>    Hardware name: LENOVO 20VE/LNVNB161216, BIOS F8CN43WW(V2.06) 08/12/2021
>>    RIP: 0010:gen8_ppgtt_insert+0x50b/0x8f0
>>    Code: 00 00 f7 c2 00 00 20 00 74 15 f7 c3 ff ff 1f 00 75 0d 41 81 fc ff ff 1f 00 0f 87 0e 02 00 00 48 8b 74 24 08 44 89 c0 45 85 ed <48> 8b 4e 58 48 8b 04 c1 0f 85 0b 02 00 00 81 e2 00 00 01 00 0f 84
>>    RSP: 0018:ffffafc085afb820 EFLAGS: 00010246
>>    RAX: 0000000000000000 RBX: 00000000e9604000 RCX: 000000000000001b
>>    RDX: 0000000000211000 RSI: 0000000000000000 RDI: ffff9513d44c1000
>>    RBP: ffff951106f8dfc0 R08: 0000000000000000 R09: 0000000000000003
>>    R10: 0000000000000fff R11: 00000000e9800000 R12: 00000000001fc000
>>    R13: 0000000000000000 R14: 0000000000001000 R15: 0000ffff00000000
>>    FS:  00007f2a5bcced80(0000) GS:ffff951a87a40000(0000) knlGS:0000000000000000
>>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>    CR2: 0000000000000058 CR3: 0000000116f16006 CR4: 0000000000772ee0
>>    PKRU: 55555554
>>    Call Trace:
>>     <TASK>
>>     ? __die+0x1f/0x60
>>     ? page_fault_oops+0x14d/0x420
>>     ? exc_page_fault+0x3d7/0x880
>>     ? lock_acquire+0xc9/0x290
>>     ? asm_exc_page_fault+0x22/0x30
>>     ? gen8_ppgtt_insert+0x50b/0x8f0
>>     ppgtt_bind_vma+0x4f/0x60
>>     fence_work+0x1b/0x70
>>     fence_notify+0x8f/0x130
>>     __i915_sw_fence_complete+0x58/0x230
>>     i915_vma_pin_ww+0x513/0xa80
>>     eb_validate_vmas+0x17e/0x9e0
>>     ? eb_pin_engine+0x2bb/0x340
>>     i915_gem_do_execbuffer+0xc85/0x2bf0
>>     ? __lock_acquire+0x3b6/0x21c0
>>     i915_gem_execbuffer2_ioctl+0xee/0x240
>>     ? i915_gem_do_execbuffer+0x2bf0/0x2bf0
>>     drm_ioctl_kernel+0x9d/0x140
>>     drm_ioctl+0x1dd/0x410
>>     ? i915_gem_do_execbuffer+0x2bf0/0x2bf0
>>     ? __fget_files+0xc5/0x170
>>     __x64_sys_ioctl+0x8c/0xc0
>>     do_syscall_64+0x34/0x80
>>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>    RIP: 0033:0x7f2a60b0c9df
>>
>>
>> $ ./scripts/faddr2line ./vmlinux gen8_ppgtt_insert+0x50b/0x8f0
>> gen8_ppgtt_insert+0x50b/0x8f0:
>> i915_pt_entry at drivers/gpu/drm/i915/gt/intel_gtt.h:557
>> (inlined by) gen8_ppgtt_insert_huge at drivers/gpu/drm/i915/gt/gen8_ppgtt.c:641
>> (inlined by) gen8_ppgtt_insert at drivers/gpu/drm/i915/gt/gen8_ppgtt.c:743
>>
>> It's likely should be the i915 driver issue that is crashes with the NULL deref, but the origin of the bug should be the kvm page fault handling.
>>
>> David, could you please tell what tests you've run and post a link to yours kernel tree? Maybe I made obscure mistake while applied the patch manually.
> 
> For tests, I ran the kvm selftests and then various ChromeOS
> virtualization tests. Two things to note about the ChromeOS
> virtualization tests are that they use crosvm instead of qemu, and
> they use virtio-gpu+virgl for graphics in the guest. I tested on an
> AMD device (since the goal of this series is to fix a compatibility
> issue with the amdgpu driver), and on a TGL device.
> 
> I don't have an easy way to share my kernel tree, but it's based on
> v6.5-r3. The series I sent out is rebased onto the kvm next branch,
> but there were only minor conflicts.

It's good that you mentioned crosvm because I only tested qemu.
Interestingly, the problem doesn't present using crosvm.

I made few more tests using these options:

  1. yours latest version of the patch based on v6.5.4
  2. yours latest version of the patch based on the kvm tree
  3. by forward-porting yours older version of the kvm patchset to v6.5
that works well based on v6.4 kernel

Neither of the options work with qemu and v6.5 kernel, but crosvm works.

At first I felt confident that it must be i915 bug of the v6.5 kernel.
But given that crosvm works, now I'm not sure.

Will try to bisect 6.5 kernel, at minimum the i915 driver changes.

-- 
Best regards,
Dmitry

