Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741CA2EC238
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbhAFR3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbhAFR3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:29:16 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C462C061357
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 09:28:30 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id u12so3949017ilv.3
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 09:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xR+4O50UDJNm/XJBKoh3oTAGqN+hJaOIGSAOziTMSnQ=;
        b=bdneCK7G0e63rpLUxsV991naj35SjcFybHyAx8EaAol+tW8pU/uc9+QsjRrDBe9127
         VAdvzDDzMFVDzw8v7zE6ePp+DxKrDWWSK2NZQJ3sEqF450Etl8F2FeeFRUcu7HHmP9Dj
         +oxe5gsXOp3ljFPk4C5pgjXscQtlL0frhxxUnzTEgg2ZrPdDYl5gzGmVsQJKfqIXEed0
         z/5gdRdSrSXjNr20jEEPCYOIF/TL4GJBnbqKDpDWfYPfrwjLRKpEJxHjHS83ZZjniVFu
         gWo6XSQo3sQ0NBD1G3t1QgVlFfzRb1jQIuMMPSR4dczVR1wRG+uNMuqptB0wkGV/Npzx
         wDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xR+4O50UDJNm/XJBKoh3oTAGqN+hJaOIGSAOziTMSnQ=;
        b=fhZ3WMI/6UzgIunmwL2R9grxhDouPpliXVqWt1Uax9q0kw4evJLyJf8knlldqQt4C0
         19NuRP8aO4o5VYklGozAggJGtyeIqKHU6a3H8Pkf0E5rF/n3eLgwfBxu04mX1Cjar0wJ
         5GHzmRCYCIURhG6vdosfMGUXc73tp6KdzGgzRLrt4sPuj/Jn4RmDZ7af6b1t1dzp11j/
         mddE/pi00aYVddhUw9g4r5g94sKVqKhl4Wfiq8JmpYd6WlDiuvU682z4voNsLCj4ZsKj
         /kfFq8rcdjv/KG1CxWKZpTWuRgQTITI8wqiFX7Y+wSlcWd7r4qfwFDjZLIwm3RLeWUP9
         CnSg==
X-Gm-Message-State: AOAM530DT0EtECPbzpMwbUf6KibihTHU2WHcOR9q6Uc/O5/4ZfI9HXrn
        7jfat++83lyGZks7IR1o+eMKz6RfHPXHzxl3MUK3Vw==
X-Google-Smtp-Source: ABdhPJx+cLty5FdbYCBehESOCHAWaxKTZ3NFL9yoI1E6Ofs6cdus5wqiVr06Lpcm/7uU0q+TO5q73nwcaVYVGstd35M=
X-Received: by 2002:a05:6e02:f93:: with SMTP id v19mr5023995ilo.154.1609954109147;
 Wed, 06 Jan 2021 09:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20210105233136.2140335-1-bgardon@google.com> <20210105233136.2140335-2-bgardon@google.com>
 <CANgfPd8TXa3GG4mQ7MD0wBrUOTdRDeR0z50uDmbcR88rQMn5FQ@mail.gmail.com> <e94e674e-1775-3c67-97f0-8c61e1add554@oracle.com>
In-Reply-To: <e94e674e-1775-3c67-97f0-8c61e1add554@oracle.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 6 Jan 2021 09:28:18 -0800
Message-ID: <CANgfPd-QPUwigK5um8DWQ5Y_M+JGRie_N_vkYtZdNE1WQbn3mA@mail.gmail.com>
Subject: Re: [PATCH 2/3] kvm: x86/mmu: Ensure TDP MMU roots are freed after yield
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Leo Hou <leohou1402@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 6, 2021 at 1:26 AM Maciej S. Szmigiero
<maciej.szmigiero@oracle.com> wrote:
>
> Thanks for looking at it Ben.
>
> On 06.01.2021 00:38, Ben Gardon wrote:
> (..)
> >
> > +Sean Christopherson, for whom I used a stale email address.
> > .
> > I tested this series by running kvm-unit-tests on an Intel Skylake
> > machine. It did not introduce any new failures. I also ran the
> > set_memory_region_test
>
> It's "memslot_move_test" that is crashing the kernel - a memslot
> move test based on "set_memory_region_test".

I apologize if I'm being very dense, but I can't find this test
anywhere. Is this something you have in-house but haven't upstreamed
or just the test_move_memory_region(); testcase from
set_memory_region_test? I have a similar memslot-moving-stress-test in
the pipeline I need to send out, but I didn't think such a test
existed yet and my test hadn't caught this issue.

>
> >, but was unable to reproduce Maciej's problem.
> > Maciej, if you'd be willing to confirm this series solves the problem
> > you observed, or provide more details on the setup in which you
> > observed it, I'd appreciate it.
> >
>
> I've applied your patches and now are getting a slightly
> different backtrace for the same test:
> [  534.768212] general protection fault, probably for non-canonical addre=
ss 0xdead000000000100: 0000 [#1] SMP PTI
> [  534.887969] CPU: 97 PID: 4651 Comm: memslot_move_te Not tainted 5.11.0=
-rc2+ #81
> [  534.975465] Hardware name: Oracle Corporation ORACLE SERVER X7-2c/SERV=
ER MODULE ASSY, , BIOS 46070300 12/20/2019
> [  535.097288] RIP: 0010:kvm_tdp_mmu_zap_gfn_range+0x70/0xb0 [kvm]
> [  535.168199] Code: b8 01 00 00 00 4c 89 f1 41 89 45 50 4c 89 ee 48 89 d=
f e8 a3 f3 ff ff 41 09 c4 41 83 6d 50 01 74 13 4d 8b 6d 00 4d 39 fd 74 1e <=
41> 8b 45 50 85 c0 75 c6 0f 0b 4c 89 ee 48 89 df e8 0b fc ff ff 4d
> [  535.393005] RSP: 0018:ffffbded19083b90 EFLAGS: 00010297
> [  535.455533] RAX: 0000000000000001 RBX: ffffbded1a27d000 RCX: 000000008=
030000e
> [  535.540945] RDX: 000000008030000f RSI: ffffffffc0ad5453 RDI: ffff9cd72=
a00d300
> [  535.626358] RBP: ffffbded19083bc0 R08: 0000000000000001 R09: ffffffffc=
0ad5400
> [  535.711769] R10: ffff9d370acf31b8 R11: 0000000000000001 R12: 000000000=
0000001
> [  535.797181] R13: dead000000000100 R14: 0000000400000000 R15: ffffbded1=
a292418
> [  535.882590] FS:  00007ff50312e740(0000) GS:ffff9d947fb40000(0000) knlG=
S:0000000000000000
> [  535.979443] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  536.048211] CR2: 0000000001e02fe0 CR3: 00000060a78e8003 CR4: 000000000=
07726e0
> [  536.133628] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  536.219043] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  536.304452] PKRU: 55555554
> [  536.336813] Call Trace:
> [  536.366057]  kvm_tdp_mmu_zap_all+0x26/0x40 [kvm]
> [  536.421357]  kvm_mmu_zap_all_fast+0x167/0x180 [kvm]
> [  536.479767]  kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10 [kvm]
> [  536.554817]  kvm_page_track_flush_slot+0x5a/0x90 [kvm]
> [  536.616344]  kvm_arch_flush_shadow_memslot+0xe/0x10 [kvm]
> [  536.680986]  kvm_set_memslot+0x18f/0x690 [kvm]
> [  536.734186]  __kvm_set_memory_region+0x41f/0x580 [kvm]
> [  536.795705]  kvm_set_memory_region+0x2b/0x40 [kvm]
> [  536.853062]  kvm_vm_ioctl+0x216/0x1060 [kvm]
> [  536.904182]  ? irqtime_account_irq+0x40/0xc0
> [  536.955270]  ? irq_exit_rcu+0x55/0xf0
> [  536.999079]  ? sysvec_apic_timer_interrupt+0x45/0x90
> [  537.058485]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  537.122058]  ? __audit_syscall_entry+0xdd/0x130
> [  537.176267]  __x64_sys_ioctl+0x92/0xd0
> [  537.221114]  do_syscall_64+0x37/0x50
> [  537.263878]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  537.324324] RIP: 0033:0x7ff502a27307
> [  537.367882] Code: 44 00 00 48 8b 05 69 1b 2d 00 64 c7 00 26 00 00 00 4=
8 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 1b 2d 00 f7 d8 64 89 01 48
> [  537.594221] RSP: 002b:00007fffde6b2d38 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [  537.685616] RAX: ffffffffffffffda RBX: 0000000001de8000 RCX: 00007ff50=
2a27307
> [  537.771797] RDX: 0000000001e02fe0 RSI: 000000004020ae46 RDI: 000000000=
0000004
> [  537.857967] RBP: 00000000000001fc R08: 00007fffde74b090 R09: 000000000=
005af86
> [  537.944110] R10: 000000000005af86 R11: 0000000000000246 R12: 000000005=
0000000
> [  538.030236] R13: 0000000000000000 R14: 0000000000000000 R15: 000000000=
00001fb
> [  538.116345] Modules linked in: kvm_intel kvm xt_comment xt_owner ip6t_=
rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack =
ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_security i=
p6table_raw iptable_nat nf_nat iptable_mangle iptable_security iptable_raw =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set ebtable_filter ebtables i=
p6table_filter ip6_tables iptable_filter rpcrdma ib_isert iscsi_target_mod =
ib_iser ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm=
 ib_umad iw_cxgb4 rdma_cm iw_cm ib_cm intel_rapl_msr intel_rapl_common skx_=
edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp mgag200 =
drm_kms_helper iTCO_wdt bnxt_re cec iTCO_vendor_support drm ib_uverbs sysco=
pyarea sysfillrect ib_core sg irqbypass sysimgblt pcspkr ioatdma i2c_i801 f=
b_sys_fops joydev lpc_ich intel_pch_thermal i2c_smbus i2c_algo_bit dca ip_t=
ables vfat fat xfs sd_mod t10_pi be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls c=
xgb3i cxgb3 mdio libcxgbi
> [  538.116423]  libcxgb qla4xxx iscsi_boot_sysfs crct10dif_pclmul crc32_p=
clmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper bnxt_e=
n wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod iscsi_tcp libiscsi_tcp =
libiscsi scsi_transport_iscsi [last unloaded: kvm]
> [  539.450863] ---[ end trace 7c17f445a2093145 ]---
> [  539.623473] RIP: 0010:kvm_tdp_mmu_zap_gfn_range+0x70/0xb0 [kvm]
> [  539.695136] Code: b8 01 00 00 00 4c 89 f1 41 89 45 50 4c 89 ee 48 89 d=
f e8 a3 f3 ff ff 41 09 c4 41 83 6d 50 01 74 13 4d 8b 6d 00 4d 39 fd 74 1e <=
41> 8b 45 50 85 c0 75 c6 0f 0b 4c 89 ee 48 89 df e8 0b fc ff ff 4d
> [  539.921479] RSP: 0018:ffffbded19083b90 EFLAGS: 00010297
> [  539.984788] RAX: 0000000000000001 RBX: ffffbded1a27d000 RCX: 000000008=
030000e
> [  540.070982] RDX: 000000008030000f RSI: ffffffffc0ad5453 RDI: ffff9cd72=
a00d300
> [  540.157173] RBP: ffffbded19083bc0 R08: 0000000000000001 R09: ffffffffc=
0ad5400
> [  540.243372] R10: ffff9d370acf31b8 R11: 0000000000000001 R12: 000000000=
0000001
> [  540.329567] R13: dead000000000100 R14: 0000000400000000 R15: ffffbded1=
a292418
> [  540.415772] FS:  00007ff50312e740(0000) GS:ffff9d947fb40000(0000) knlG=
S:0000000000000000
> [  540.513427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  540.583005] CR2: 0000000001e02fe0 CR3: 00000060a78e8003 CR4: 000000000=
07726e0
> [  540.669228] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  540.755448] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  540.841659] PKRU: 55555554
> [  540.874826] Kernel panic - not syncing: Fatal exception
> [  540.938269] Kernel Offset: 0xe200000 from 0xffffffff81000000 (relocati=
on range: 0xffffffff80000000-0xffffffffbfffffff)
> [  542.097054] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> The code that is crashing is:
> # arch/x86/kvm/mmu/mmu_internal.h:100:  BUG_ON(!sp->root_count);
>          movl    80(%r13), %eax  # MEM[(int *)__mptr_14 + 80B], _17 <- he=
re
>          testl   %eax, %eax      # _17
>          jne     .L421   #,
>
> So it looks like it now crashes in the same BUG_ON() but when trying to
> deference the "dead" sp pointer instead.

Hmm thanks for testing the patches, I'll take another try at
reproducing the issue and amend the commits.

>
> It's bad that you can't reproduce the issue, however, as this would
> probably make the root causing process much more effective.
> Are you testing on bare metal like me or while running nested?

I'm running on bare metal too.

>
> My test machine has Xeon Platinum 8167M CPU, so it's a Skylake, too.
> It has 754G RAM + 8G swap, running just the test program.
>
> I've uploaded the kernel that I've used for testing here:
> https://github.com/maciejsszmigiero/linux/tree/tdp_mmu_bug
>
> It is basically a 5.11.0-rc2 kernel with
> "KVM: x86/mmu: Bug fixes and cleanups in get_mmio_spte()" series and
> your fixes applied on top of it.
>
> In addition to that, I've updated
> https://gist.github.com/maciejsszmigiero/890218151c242d99f63ea0825334c6c0
> with the kernel .config file that was used.
>
> The compiler that I've used to compile the test kernel was:
> "gcc version 8.3.1 20190311 (Red Hat 8.3.1-3.2.0.1)"

Thank you for the details, hopefully those can shed some light on why
I wasn't able to reproduce the issue.

>
> Thanks,
> Maciej
