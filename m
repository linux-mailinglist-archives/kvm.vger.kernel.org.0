Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2938B51148C
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 11:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiD0Jy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 05:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiD0Jy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 05:54:56 -0400
Received: from out0-153.mail.aliyun.com (out0-153.mail.aliyun.com [140.205.0.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F0A3D1BDA
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 02:49:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.NZBEx3Y_1651051620;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NZBEx3Y_1651051620)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Apr 2022 17:27:01 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     seanjc@google.com
Cc:     "SU Hang" <darcy.sh@antgroup.com>, <drjones@redhat.com>,
        <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: replace `int 0x20` with `syscall`
Date:   Wed, 27 Apr 2022 17:27:00 +0800
Message-Id: <20220427092700.98464-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <YmbFN6yKwnLDRdr8@google.com>
References: <YmbFN6yKwnLDRdr8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Why?
We are implementing a para-virtualization hypervisor, which doesn't allow guest
to trigger soft interrupt > 0x20(but `int 0x80` works fine), so I want to
replace `int 0x20` with a more common `syscall`.


> it's do_ring3() should really be rolled into this framework.
Yes, it is worth working on it, I'll do it in my part-time.


> no existing test verifies that KVM injects #UD on SYSCALL without EFER.SCE
> set, though it would be nice to add one.
I am also interested in it, maybe do it later.


> > + wrmsr(MSR_STAR, ((u64)(USER_CS32 << 16) | KERNEL_CS) << 32);
> It doesn't matter at this time because this framework doesn't ses SYSRET, but
> this should be USER_CS or USER_CS64.
Oops, intel SDM vol.3 <chap 5.8.8> says:
"""
When SYSRET transfers control to 64-bit mode user code using REX.W, the
processor gets the privilege level 3 target code segment, instruction pointer,
          stack segment, and flags as follows:
    • Target code segment — Reads a non-NULL selector from IA32_STAR[63:48] + 16.
    • Stack segment — IA32_STAR[63:48] + 8.
"""

Since the value of USER_CS is 0x4b in 64 bit mode, SS register points to 0x53 =
0x4b + 8, (offset is 0x50) But `gdt + offset(0x50)` hasn't been setup(so does DS
register).
> refs: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/lib/x86/desc.c#L34
> refs: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/x86/syscall.c#L68

Linux also does so, the reason is to reuse user segment descriptor in both 32/64 bit.
> refs1: https://github.com/torvalds/linux/blob/46cf2c613f4b10eb12f749207b0fd2c1bfae3088/arch/x86/kernel/cpu/common.c#L1942
> refs2: https://github.com/torvalds/linux/blob/46cf2c613f4b10eb12f749207b0fd2c1bfae3088/arch/x86/include/asm/segment.h#L211
> refs3: https://github.com/torvalds/linux/blob/46cf2c613f4b10eb12f749207b0fd2c1bfae3088/arch/x86/kernel/cpu/common.c#L216

> And a concrete reason not to apply this patch: it causes the nVMX #AC test to fail:
It's awkward, some KUT test cases results diffs on my different machines, which
makes me don't know which result I could trust, so I only pay attention to the
test cases that I care about. I'll keep an eye on the rest cases in the
future.
