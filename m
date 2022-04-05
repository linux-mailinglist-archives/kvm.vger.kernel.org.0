Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C57D4F49A0
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443287AbiDEWUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573642AbiDET2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 15:28:22 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58F5BE9F6
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 12:26:22 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id k21so228340lfe.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aM/g1QWf5Ry19waQIN/yIeidX6+3IktjhZXbrkM4RkA=;
        b=VqGDk0cJy3VeD9YeUGkYiZjnNQkZlk/Mdl0vUqqTFICQid0WGPL+Av1QUqRMJhz3Ke
         WrYERt9bbKqaRmJWLGp+DBX+ozx2WIsDDOgkFrI0daBzk4PEMGo4qVcPq8l8U0s145vZ
         vBzjBwIR3Z43nEGj8amENjwPazeZzr5a7iNwQ9ylKV6qSev2vlvPWE2IFFchha3/nric
         89HS0Jw07JOwWXOvkQ+C9aGiS7y3U1hNOzwVyZEpKqj/3hwe5Ja/gGOAb+DKaMELoMNS
         IihVPlC3vtOWpd1N8AI6o+dwKHircdKjX5BtX/lT14fQCsCzaYapIIgcND7heWlJBP+U
         +nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aM/g1QWf5Ry19waQIN/yIeidX6+3IktjhZXbrkM4RkA=;
        b=O6yNstNieWYJMqavCRICp7tXXwWdxGVj/xF+AhdWL0EWX9lnSARtTHndbnCQXOJTpD
         +azFWZjgohci7NRJ3d7hRamzmEfIeeuIH6TQ7tqpBJXN9csIyX5bWk/n8LxcZjshggAW
         S0M20HshpFBjcPHQc05QWtw0Pea2PWOZ1J2qofGfhdKViRGSfCjmbTbFsj8/XvwoYIa2
         fS/Dqvy7gNkoo0LMIwOB3Et0YbbIPdB6lBLLuWS4jLZTx/oq0PpnKJe+1TYm+7t4DJ3T
         fr4DeG6dlxCX8ioUSk1iwi/6A9avM/nC1Y39k7+7blvh9UZEU4FL4ODU0+R1aJayimqJ
         Zmsg==
X-Gm-Message-State: AOAM532nvsZYm9sr9RdY5UoBh4c907pWX7THOevYQEpr68Fm1pLljy7R
        2YD469xoZqVu1IrfmKYJlPSxLltwPLEPmC8agwgK2Q==
X-Google-Smtp-Source: ABdhPJxuMetLuvdZqMK40/5W5YwyJzebZo0tDnZYg162KlZH94xPjpjAL4QaPZ0vTIDn+hejxD/o7qNaX1svStxVFmU=
X-Received: by 2002:a05:6512:12c6:b0:44a:650f:3b86 with SMTP id
 p6-20020a05651212c600b0044a650f3b86mr3771545lfg.79.1649186780874; Tue, 05 Apr
 2022 12:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220330164306.2376085-1-pgonda@google.com> <CAL715W+S-SJwXBhYO=_T-9uAPLt6cQ-Hn+_+ehefAh6+kQ_zOA@mail.gmail.com>
 <YkYdlfYM/FWlMqMg@google.com>
In-Reply-To: <YkYdlfYM/FWlMqMg@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 5 Apr 2022 13:26:09 -0600
Message-ID: <CAMkAt6p+u8ggkipnp1x=iv4xLD75b+eYEO3cCxP7f30PYPW0YQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Add cond_resched() to loop in sev_clflush_pages()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, kvm <kvm@vger.kernel.org>,
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

On Thu, Mar 31, 2022 at 3:31 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Wed, Mar 30, 2022, Mingwei Zhang wrote:
> > On Wed, Mar 30, 2022 at 9:43 AM Peter Gonda <pgonda@google.com> wrote:
> > >
> > > Add resched to avoid warning from sev_clflush_pages() with large numb=
er
> > > of pages.
> > >
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Cc: kvm@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > >
> > > ---
> > > Here is a warning similar to what I've seen many times running large =
SEV
> > > VMs:
> > > [  357.714051] CPU 15: need_resched set for > 52000222 ns (52 ticks) =
without schedule
> > > [  357.721623] WARNING: CPU: 15 PID: 35848 at kernel/sched/core.c:373=
3 scheduler_tick+0x2f9/0x3f0
> > > [  357.730222] Modules linked in: kvm_amd uhaul vfat fat hdi2_standar=
d_ftl hdi2_megablocks hdi2_pmc hdi2_pmc_eeprom hdi2 stg elephant_dev_num cc=
p i2c_mux_ltc4306 i2c_mux i2c_via_ipmi i2c_piix4 google_bmc_usb google_bmc_=
gpioi2c_mb_common google_bmc_mailbox cdc_acm xhci_pci xhci_hcd sha3_generic=
 gq nv_p2p_glue accel_class
> > > [  357.758261] CPU: 15 PID: 35848 Comm: switchto-defaul Not tainted 4=
.15.0-smp-DEV #11
> > > [  357.765912] Hardware name: Google, Inc.                           =
                            Arcadia_IT_80/Arcadia_IT_80, BIOS 30.20.2-gce 1=
1/05/2021
> > > [  357.779372] RIP: 0010:scheduler_tick+0x2f9/0x3f0
> > > [  357.783988] RSP: 0018:ffff98558d1c3dd8 EFLAGS: 00010046
> > > [  357.789207] RAX: 741f23206aa8dc00 RBX: 0000005349236a42 RCX: 00000=
00000000007
> > > [  357.796339] RDX: 0000000000000006 RSI: 0000000000000002 RDI: ffff9=
8558d1d5a98
> > > [  357.803463] RBP: ffff98558d1c3ea0 R08: 0000000000100ceb R09: 00000=
00000000000
> > > [  357.810597] R10: ffff98558c958c00 R11: ffffffff94850740 R12: 00000=
000031975de
> > > [  357.817729] R13: 0000000000000000 R14: ffff98558d1e2640 R15: ffff9=
8525739ea40
> > > [  357.824862] FS:  00007f87503eb700(0000) GS:ffff98558d1c0000(0000) =
knlGS:0000000000000000
> > > [  357.832948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  357.838695] CR2: 00005572fe74b080 CR3: 0000007bea706006 CR4: 00000=
00000360ef0
> > > [  357.845828] Call Trace:
> > > [  357.848277]  <IRQ>
> > > [  357.850294]  [<ffffffff94411420>] ? tick_setup_sched_timer+0x130/0=
x130
> > > [  357.856818]  [<ffffffff943ed60d>] ? rcu_sched_clock_irq+0x6ed/0x85=
0
> > > [  357.863084]  [<ffffffff943fdf02>] ? __run_timers+0x42/0x260
> > > [  357.868654]  [<ffffffff94411420>] ? tick_setup_sched_timer+0x130/0=
x130
> > > [  357.875182]  [<ffffffff943fd35b>] update_process_times+0x7b/0x90
> > > [  357.881188]  [<ffffffff944114a2>] tick_sched_timer+0x82/0xd0
> > > [  357.886845]  [<ffffffff94400671>] __run_hrtimer+0x81/0x200
> > > [  357.892331]  [<ffffffff943ff222>] hrtimer_interrupt+0x192/0x450
> > > [  357.898252]  [<ffffffff950002fa>] ? __do_softirq+0x2fa/0x33e
> > > [  357.903911]  [<ffffffff94e02edc>] smp_apic_timer_interrupt+0xac/0x=
1d0
> > > [  357.910349]  [<ffffffff94e01ef6>] apic_timer_interrupt+0x86/0x90
> > > [  357.916347]  </IRQ>
> > > [  357.918452] RIP: 0010:clflush_cache_range+0x3f/0x50
> > > [  357.923324] RSP: 0018:ffff98529af89cc0 EFLAGS: 00000246 ORIG_RAX: =
ffffffffffffff12
> > > [  357.930889] RAX: 0000000000000040 RBX: 0000000000038135 RCX: ffff9=
85233d36000
> > > [  357.938013] RDX: ffff985233d36000 RSI: 0000000000001000 RDI: ffff9=
85233d35000
> > > [  357.945145] RBP: ffff98529af89cc0 R08: 0000000000000001 R09: ffffb=
5753fb23000
> > > [  357.952271] R10: 000000000003fe00 R11: 0000000000000008 R12: 00000=
00000040000
> > > [  357.959401] R13: ffff98525739ea40 R14: ffffb5753fb22000 R15: ffff9=
8532a58dd80
> > > [  357.966536]  [<ffffffffc07afd41>] svm_register_enc_region+0xd1/0x1=
70 [kvm_amd]
> > > [  357.973758]  [<ffffffff94246e8c>] kvm_arch_vm_ioctl+0x84c/0xb00
> > > [  357.979677]  [<ffffffff9455980f>] ? handle_mm_fault+0x6ff/0x1370
> > > [  357.985683]  [<ffffffff9423412b>] kvm_vm_ioctl+0x69b/0x720
> > > [  357.991167]  [<ffffffff945dfd9d>] do_vfs_ioctl+0x47d/0x680
> > > [  357.996654]  [<ffffffff945e0188>] SyS_ioctl+0x68/0x90
> > > [  358.001706]  [<ffffffff942066f1>] do_syscall_64+0x71/0x110
> > > [  358.007192]  [<ffffffff94e00081>] entry_SYSCALL_64_after_hwframe+0=
x3d/0xa2
> > >
> > > Tested by running a large 256gib SEV VM several times, saw no warning=
s.
> > > Without the change warnings are seen.
>
> Clean up the splat (remove timestamps, everything with a ?, etc... I beli=
eve there
> is a kernel scripts/ to do this...) and throw it in the changelog.  Docum=
enting the
> exact problem is very helpful, e.g. future readers may wonder "what warni=
ng?".

Paolo has queued this I think, so I'll do this next time I am fixing a
warning.  Thanks Sean.

>
>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 75fa6dd268f0..c2fe89ecdb2d 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -465,6 +465,7 @@ static void sev_clflush_pages(struct page *pages[=
], unsigned long npages)
> > >                 page_virtual =3D kmap_atomic(pages[i]);
> > >                 clflush_cache_range(page_virtual, PAGE_SIZE);
> > >                 kunmap_atomic(page_virtual);
> > > +               cond_resched();
> >
> > If you add cond_resched() here, the frequency (once per 4K) might be
> > too high. You may want to do it once per X pages, where X could be
> > something like 1G/4K?
>
> No, every iteration is perfectly ok.  The "cond"itional part means that t=
his will
> reschedule if and only if it actually needs to be rescheduled, e.g. if th=
e task's
> timeslice as expired.  The check for a needed reschedule is cheap, using
> cond_resched() in tight-ish loops is ok and intended, e.g. KVM does a rec=
hed
> check prior to enterring the guest.
