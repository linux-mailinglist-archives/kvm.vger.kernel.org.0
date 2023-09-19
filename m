Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4C7A579B
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 04:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjISC7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 22:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjISC7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 22:59:24 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D5B95
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 19:59:19 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-5008d16cc36so8540874e87.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 19:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1695092357; x=1695697157; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNGWNN/ATRw4P/f9tgfQnGw5a01oPlZp0FFvjCAOyvA=;
        b=hlYbUTwWV1cvXX2RgvDBLGod8rMl9L9Ddh4RndQdT7quvOaOg4I4S1PgrYvBVJMthC
         SLfQrb2DgTW1P4+Ejw4exZUfPmyW8gb1K6k5WFQ0m/45pvMwXFGf1EjflYfnp8UcwW+f
         CdwDbNb17PvEjqYzrs9LzPrZ7Gkn8jIUDd0S0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695092357; x=1695697157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nNGWNN/ATRw4P/f9tgfQnGw5a01oPlZp0FFvjCAOyvA=;
        b=tj9Sasjq0JnCUSSHZUKzPP3/J/dhl+t/1/qaq8Lyj/Qtr7LTkxEW6ZiS3AT7k106Tm
         d2Xsus3xS13zXtZWjJ+sZcI0Jhn0F84froILJGy0DZTdFjW3hw0aMq94xQ2wuhUMqrS0
         SNq7UFrF91DnJNtTYvJY0/JvqbriHnLUaxiOdFsUTqACdScJFQ1n7s8xr7Nf98tZVz4Z
         QPHOMkyfy64A49NQJnx56s4VeOm861O3uMKCsAHSpxDI/PCk5euLOjD3bzhW1cDH2dex
         /w9gmvA6NgiEEWNiTAUfvLCd5CIj2Uj0qDdmyOYbC3wsRlQLrWPuBwgnu3ruqek9ZxTN
         tBzA==
X-Gm-Message-State: AOJu0YwNH8Y6fAD5JcnGmhRTKOzEAr6iQ51dplTolYUfzUuVrybOaZzt
        f1dSDUsk7Jnwa87nnLq+aYeCY78Vf9wO6trAZAUh6Q==
X-Google-Smtp-Source: AGHT+IGd/5P0BVGrgR2KT5TUob9plCgOghbXldX0sYOpwKWnUfpBt1lb7zXMDhvOSZn62uTU04NBHWYzq1EOUJhuHx4=
X-Received: by 2002:a05:6512:ea9:b0:503:c51:74df with SMTP id
 bi41-20020a0565120ea900b005030c5174dfmr6415241lfb.48.1695092357319; Mon, 18
 Sep 2023 19:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-7-stevensd@google.com>
 <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com> <207c8e59-f92a-96c0-bc5e-39b73a840110@collabora.com>
In-Reply-To: <207c8e59-f92a-96c0-bc5e-39b73a840110@collabora.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 19 Sep 2023 11:59:05 +0900
Message-ID: <CAD=HUj51M9Eh=5Q=XQjPJ7No4i-z0en-1L3s0G8_fBZp0+NUZw@mail.gmail.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
To:     Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 8:19=E2=80=AFPM Dmitry Osipenko
<dmitry.osipenko@collabora.com> wrote:
>
> On 9/18/23 12:58, Dmitry Osipenko wrote:
> > On 9/11/23 05:16, David Stevens wrote:
> >> From: David Stevens <stevensd@chromium.org>
> >>
> >> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> >> to map memory into the guest that is backed by non-refcounted struct
> >> pages - for example, the tail pages of higher order non-compound pages
> >> allocated by the amdgpu driver via ttm_pool_alloc_page.
> >>
> >> The bulk of this change is tracking the is_refcounted_page flag so tha=
t
> >> non-refcounted pages don't trigger page_count() =3D=3D 0 warnings. Thi=
s is
> >> done by storing the flag in an unused bit in the sptes. There are no
> >> bits available in PAE SPTEs, so non-refcounted pages can only be handl=
ed
> >> on TDP and x86-64.
> >>
> >> Signed-off-by: David Stevens <stevensd@chromium.org>
> >> ---
> >>  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++---------=
-
> >>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
> >>  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
> >>  arch/x86/kvm/mmu/spte.c         |  4 ++-
> >>  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
> >>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
> >>  include/linux/kvm_host.h        |  3 ++
> >>  virt/kvm/kvm_main.c             |  6 ++--
> >>  8 files changed, 76 insertions(+), 32 deletions(-)
> >
> > Could you please tell which kernel tree you used for the base of this
> > series? This patch #6 doesn't apply cleanly to stable/mainline/next/kvm
> >
> > error: sha1 information is lacking or useless (arch/x86/kvm/mmu/mmu.c).
> > error: could not build fake ancestor
>
> I applied the patch manually to v6.5.2 and tested Venus using Intel TGL i=
GPU, the intel driver is crashing:
>
>    BUG: kernel NULL pointer dereference, address: 0000000000000058
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP
>    CPU: 1 PID: 5926 Comm: qemu-system-x86 Not tainted 6.5.2+ #114
>    Hardware name: LENOVO 20VE/LNVNB161216, BIOS F8CN43WW(V2.06) 08/12/202=
1
>    RIP: 0010:gen8_ppgtt_insert+0x50b/0x8f0
>    Code: 00 00 f7 c2 00 00 20 00 74 15 f7 c3 ff ff 1f 00 75 0d 41 81 fc f=
f ff 1f 00 0f 87 0e 02 00 00 48 8b 74 24 08 44 89 c0 45 85 ed <48> 8b 4e 58=
 48 8b 04 c1 0f 85 0b 02 00 00 81 e2 00 00 01 00 0f 84
>    RSP: 0018:ffffafc085afb820 EFLAGS: 00010246
>    RAX: 0000000000000000 RBX: 00000000e9604000 RCX: 000000000000001b
>    RDX: 0000000000211000 RSI: 0000000000000000 RDI: ffff9513d44c1000
>    RBP: ffff951106f8dfc0 R08: 0000000000000000 R09: 0000000000000003
>    R10: 0000000000000fff R11: 00000000e9800000 R12: 00000000001fc000
>    R13: 0000000000000000 R14: 0000000000001000 R15: 0000ffff00000000
>    FS:  00007f2a5bcced80(0000) GS:ffff951a87a40000(0000) knlGS:0000000000=
000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 0000000000000058 CR3: 0000000116f16006 CR4: 0000000000772ee0
>    PKRU: 55555554
>    Call Trace:
>     <TASK>
>     ? __die+0x1f/0x60
>     ? page_fault_oops+0x14d/0x420
>     ? exc_page_fault+0x3d7/0x880
>     ? lock_acquire+0xc9/0x290
>     ? asm_exc_page_fault+0x22/0x30
>     ? gen8_ppgtt_insert+0x50b/0x8f0
>     ppgtt_bind_vma+0x4f/0x60
>     fence_work+0x1b/0x70
>     fence_notify+0x8f/0x130
>     __i915_sw_fence_complete+0x58/0x230
>     i915_vma_pin_ww+0x513/0xa80
>     eb_validate_vmas+0x17e/0x9e0
>     ? eb_pin_engine+0x2bb/0x340
>     i915_gem_do_execbuffer+0xc85/0x2bf0
>     ? __lock_acquire+0x3b6/0x21c0
>     i915_gem_execbuffer2_ioctl+0xee/0x240
>     ? i915_gem_do_execbuffer+0x2bf0/0x2bf0
>     drm_ioctl_kernel+0x9d/0x140
>     drm_ioctl+0x1dd/0x410
>     ? i915_gem_do_execbuffer+0x2bf0/0x2bf0
>     ? __fget_files+0xc5/0x170
>     __x64_sys_ioctl+0x8c/0xc0
>     do_syscall_64+0x34/0x80
>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>    RIP: 0033:0x7f2a60b0c9df
>
>
> $ ./scripts/faddr2line ./vmlinux gen8_ppgtt_insert+0x50b/0x8f0
> gen8_ppgtt_insert+0x50b/0x8f0:
> i915_pt_entry at drivers/gpu/drm/i915/gt/intel_gtt.h:557
> (inlined by) gen8_ppgtt_insert_huge at drivers/gpu/drm/i915/gt/gen8_ppgtt=
.c:641
> (inlined by) gen8_ppgtt_insert at drivers/gpu/drm/i915/gt/gen8_ppgtt.c:74=
3
>
> It's likely should be the i915 driver issue that is crashes with the NULL=
 deref, but the origin of the bug should be the kvm page fault handling.
>
> David, could you please tell what tests you've run and post a link to you=
rs kernel tree? Maybe I made obscure mistake while applied the patch manual=
ly.

For tests, I ran the kvm selftests and then various ChromeOS
virtualization tests. Two things to note about the ChromeOS
virtualization tests are that they use crosvm instead of qemu, and
they use virtio-gpu+virgl for graphics in the guest. I tested on an
AMD device (since the goal of this series is to fix a compatibility
issue with the amdgpu driver), and on a TGL device.

I don't have an easy way to share my kernel tree, but it's based on
v6.5-r3. The series I sent out is rebased onto the kvm next branch,
but there were only minor conflicts.

-David
