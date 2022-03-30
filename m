Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F38A4ECA0D
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 18:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349064AbiC3Qyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 12:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347517AbiC3Qyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 12:54:36 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2FE294A2B
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 09:52:49 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id s11so18610872qtc.3
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XJOuIwKVKJoYxuu3h/fPqnOnXuAJfnfjZiDXXpn0snE=;
        b=W0nG8AGf+ASsomfq42TBWSEBx2Dz6O4Miy4mAlrPzEN13GB02uiM9eIQmcfsrRmKJy
         K14YOXl/gyqUhfC8SZpnIYmCSA2nUwyYmRIxeZ43f4Q+4MFmPt7QnfvxQAhpWg+TUOMv
         ac9Bc7b9HAra3K77FCcgbfXQDGQ9KzvaApqiyR5yX6BCD/PhgTvL9Nj/v92Zn4OcLP2W
         +DcbNv9CdksYxkikiGVKJ06/QIKYnvePM0ohzyyAa95b/BqQYHhZlEgWU7JoDJ4ZrtEw
         uZedmaUwRdAtByYuFrqllvZv3R4Asz0MmYMV19PihXeatj/WxYMr6eQ25lMpfxhMBEPR
         /yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XJOuIwKVKJoYxuu3h/fPqnOnXuAJfnfjZiDXXpn0snE=;
        b=5j6qcDupqmCI4Ubyhd3JvHlyzgZo1KtnJpJ1fdlOyjvfMS1sxZciaExTSLdjCr1KSf
         i5IlyZDBvxSiDdYKaCtaKRFH9kkfInIlGheGG/9DdE4soioNZ0nZEDNEo4sDdkmrpJoG
         a8mFop2yaa8dAvWpFfM639ZB2qjIOZ4eG2/0IQv8yclACD6zrzI9Q77f293OFgTv+Z12
         gEw3RQFeQNiqHb6jl9AwkgqhR3RycytTlxXQ+TbCwHy5xAGmNts9Y1MzAkuQMwHQ7Ypl
         wigIRadj9q6/X1DCo8+ybLtWWMSFwGS/zBzApnwfND9hywmoa6IBlweAMsivTavLPDWo
         TTVQ==
X-Gm-Message-State: AOAM5339FBhbJ4dsUGTtlox1V8V2UkY2TJ/8Pwu2nJZt4NYzWkd2c410
        FFk7qhBYxnwvHOjRCuK7T1WLOjaozpA4iLJTg93CD2ZgcsY=
X-Google-Smtp-Source: ABdhPJwTrFJQcKlABPDFC6SiWpCj+tgomGjgZ5zXjm8Ti9j9sbsIZeHmmhCLKE6Z1MO+rFlvQQBkuLfnHplv46iq6wo=
X-Received: by 2002:ac8:5aca:0:b0:2e1:e117:b2ff with SMTP id
 d10-20020ac85aca000000b002e1e117b2ffmr441196qtd.410.1648659168628; Wed, 30
 Mar 2022 09:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220330164306.2376085-1-pgonda@google.com>
In-Reply-To: <20220330164306.2376085-1-pgonda@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Wed, 30 Mar 2022 09:52:37 -0700
Message-ID: <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 9:43 AM Peter Gonda <pgonda@google.com> wrote:
>
> Add resched to avoid warning from sev_clflush_pages() with large number
> of pages.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> Here is a warning similar to what I've seen many times running large SEV
> VMs:
> [  357.714051] CPU 15: need_resched set for > 52000222 ns (52 ticks) with=
out schedule
> [  357.721623] WARNING: CPU: 15 PID: 35848 at kernel/sched/core.c:3733 sc=
heduler_tick+0x2f9/0x3f0
> [  357.730222] Modules linked in: kvm_amd uhaul vfat fat hdi2_standard_ft=
l hdi2_megablocks hdi2_pmc hdi2_pmc_eeprom hdi2 stg elephant_dev_num ccp i2=
c_mux_ltc4306 i2c_mux i2c_via_ipmi i2c_piix4 google_bmc_usb google_bmc_gpio=
i2c_mb_common google_bmc_mailbox cdc_acm xhci_pci xhci_hcd sha3_generic gq =
nv_p2p_glue accel_class
> [  357.758261] CPU: 15 PID: 35848 Comm: switchto-defaul Not tainted 4.15.=
0-smp-DEV #11
> [  357.765912] Hardware name: Google, Inc.                               =
                        Arcadia_IT_80/Arcadia_IT_80, BIOS 30.20.2-gce 11/05=
/2021
> [  357.779372] RIP: 0010:scheduler_tick+0x2f9/0x3f0
> [  357.783988] RSP: 0018:ffff98558d1c3dd8 EFLAGS: 00010046
> [  357.789207] RAX: 741f23206aa8dc00 RBX: 0000005349236a42 RCX: 000000000=
0000007
> [  357.796339] RDX: 0000000000000006 RSI: 0000000000000002 RDI: ffff98558=
d1d5a98
> [  357.803463] RBP: ffff98558d1c3ea0 R08: 0000000000100ceb R09: 000000000=
0000000
> [  357.810597] R10: ffff98558c958c00 R11: ffffffff94850740 R12: 000000000=
31975de
> [  357.817729] R13: 0000000000000000 R14: ffff98558d1e2640 R15: ffff98525=
739ea40
> [  357.824862] FS:  00007f87503eb700(0000) GS:ffff98558d1c0000(0000) knlG=
S:0000000000000000
> [  357.832948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  357.838695] CR2: 00005572fe74b080 CR3: 0000007bea706006 CR4: 000000000=
0360ef0
> [  357.845828] Call Trace:
> [  357.848277]  <IRQ>
> [  357.850294]  [<ffffffff94411420>] ? tick_setup_sched_timer+0x130/0x130
> [  357.856818]  [<ffffffff943ed60d>] ? rcu_sched_clock_irq+0x6ed/0x850
> [  357.863084]  [<ffffffff943fdf02>] ? __run_timers+0x42/0x260
> [  357.868654]  [<ffffffff94411420>] ? tick_setup_sched_timer+0x130/0x130
> [  357.875182]  [<ffffffff943fd35b>] update_process_times+0x7b/0x90
> [  357.881188]  [<ffffffff944114a2>] tick_sched_timer+0x82/0xd0
> [  357.886845]  [<ffffffff94400671>] __run_hrtimer+0x81/0x200
> [  357.892331]  [<ffffffff943ff222>] hrtimer_interrupt+0x192/0x450
> [  357.898252]  [<ffffffff950002fa>] ? __do_softirq+0x2fa/0x33e
> [  357.903911]  [<ffffffff94e02edc>] smp_apic_timer_interrupt+0xac/0x1d0
> [  357.910349]  [<ffffffff94e01ef6>] apic_timer_interrupt+0x86/0x90
> [  357.916347]  </IRQ>
> [  357.918452] RIP: 0010:clflush_cache_range+0x3f/0x50
> [  357.923324] RSP: 0018:ffff98529af89cc0 EFLAGS: 00000246 ORIG_RAX: ffff=
ffffffffff12
> [  357.930889] RAX: 0000000000000040 RBX: 0000000000038135 RCX: ffff98523=
3d36000
> [  357.938013] RDX: ffff985233d36000 RSI: 0000000000001000 RDI: ffff98523=
3d35000
> [  357.945145] RBP: ffff98529af89cc0 R08: 0000000000000001 R09: ffffb5753=
fb23000
> [  357.952271] R10: 000000000003fe00 R11: 0000000000000008 R12: 000000000=
0040000
> [  357.959401] R13: ffff98525739ea40 R14: ffffb5753fb22000 R15: ffff98532=
a58dd80
> [  357.966536]  [<ffffffffc07afd41>] svm_register_enc_region+0xd1/0x170 [=
kvm_amd]
> [  357.973758]  [<ffffffff94246e8c>] kvm_arch_vm_ioctl+0x84c/0xb00
> [  357.979677]  [<ffffffff9455980f>] ? handle_mm_fault+0x6ff/0x1370
> [  357.985683]  [<ffffffff9423412b>] kvm_vm_ioctl+0x69b/0x720
> [  357.991167]  [<ffffffff945dfd9d>] do_vfs_ioctl+0x47d/0x680
> [  357.996654]  [<ffffffff945e0188>] SyS_ioctl+0x68/0x90
> [  358.001706]  [<ffffffff942066f1>] do_syscall_64+0x71/0x110
> [  358.007192]  [<ffffffff94e00081>] entry_SYSCALL_64_after_hwframe+0x3d/=
0xa2
>
> Tested by running a large 256gib SEV VM several times, saw no warnings.
> Without the change warnings are seen.
>
> ---
>  arch/x86/kvm/svm/sev.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..c2fe89ecdb2d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[], u=
nsigned long npages)
>                 page_virtual =3D kmap_atomic(pages[i]);
>                 clflush_cache_range(page_virtual, PAGE_SIZE);
>                 kunmap_atomic(page_virtual);
> +               cond_resched();

If you add cond_resched() here, the frequency (once per 4K) might be
too high. You may want to do it once per X pages, where X could be
something like 1G/4K?

>         }
>  }
>
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
