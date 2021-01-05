Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3952EB0DB
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 18:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbhAERCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 12:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbhAERC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 12:02:29 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F83C061793
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 09:01:49 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y5so4454iow.5
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 09:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sf4YpKTj/HMrZ5s5TxhMokVL1pjpg+DMaLsX0y0lU84=;
        b=LjKqHaBiOayO/Tk0Zxk5fwBdIHJQPARgBM2ug7sivYkTHgJOt3HjtSudBJo+4dSz39
         smUZSzDTI/pVfKPjUSorcA/iJ7efUibFZPpOn6VIPmVtBsws0cjCOIOdheTFIhMqkCbV
         k0s+mpoH0Ggb5whUz6QcZ+E0vDRPTjtbCc8TU0qKPdLF+auhC7um8SxhDkkSyuacOSBu
         /MxjG+rWQhNBFuU+2LAtnr+ANF5FFgrn0MbK1huaE8JFG8gV05nsedgFE+EKgekLLlO9
         C2FyOK5PSBd4V1vuVe2wVClqyHIsbrdXkD9Ck+G+em6DmN4g8M0ODZyPm24KBEt4Sso8
         AUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sf4YpKTj/HMrZ5s5TxhMokVL1pjpg+DMaLsX0y0lU84=;
        b=mFenVgRyOB6qbUYibQYdBlf7P8mgS1WU/qI4hQBd4RsawcvDIBEBEBFbfaVvTYDMDU
         B7MyktP/x/1tPxk14aOTjzAIwiTo3bStIsUqDhJLNsPTw0s8CQ8Ka4qLgy+PW6jKTvy8
         v49MsbtD2JhPYVzeaLZwqHTHj7RN+I3/3eKEvKKVXOibjqYvl2nZMAWe0KPK7k/cVHfe
         rDuO09qbJHTZVHYex2EGG9mv5H3zARiR6RtkYx+vlVvZVY8tDDWACVIJzL9FpAfA6fzJ
         e99xmAmXICo/I7qjZfZocPbL5oxQuB7pWLgrZ1RrCc7yM7yxyKFpg+pvNfzqmGSzf/aK
         X/Kg==
X-Gm-Message-State: AOAM530H6USRxNrUFMlxUQkAL0eFCYa0mFtsxzXZi4/R+OaMu6fCkWmp
        +nA5cK3wTxz9uRnogn4j76AWWpsn1Zz6Kq6fdjWCVg==
X-Google-Smtp-Source: ABdhPJxJyF+4S94nRtPBym4/Q0pwgE+3GP9xY0xlmvykqnG2bNRPzrJFH2D0f2MYL4qHT2ezCf9pqRW+rEXiU0TSuMc=
X-Received: by 2002:a6b:6b18:: with SMTP id g24mr36792ioc.189.1609866108265;
 Tue, 05 Jan 2021 09:01:48 -0800 (PST)
MIME-Version: 1.0
References: <4bf6fcae-20e7-3eae-83ec-51fb52110487@oracle.com> <8A352C2E-E7D2-4873-807F-635A595DCAEF@gmail.com>
In-Reply-To: <8A352C2E-E7D2-4873-807F-635A595DCAEF@gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 5 Jan 2021 09:01:37 -0800
Message-ID: <CANgfPd_cbBxWHmPsw0x5NfKrMXzij3YAAiaq665zxn5nnraPGg@mail.gmail.com>
Subject: Re: reproducible BUG() in kvm_mmu_get_root() in TDP MMU
To:     leohou1402 <leohou1402@gmail.com>
Cc:     "maciej.szmigiero@oracle.com" <maciej.szmigiero@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cannonmatthews@google.com" <cannonmatthews@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "pshier@google.com" <pshier@google.com>,
        "pfeiner@google.com" <pfeiner@google.com>,
        "junaids@google.com" <junaids@google.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "yulei.kernel@gmail.com" <yulei.kernel@gmail.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 4, 2021 at 6:37 PM leohou1402 <leohou1402@gmail.com> wrote:
>
>  On 1/5/2021 07:09=EF=BC=8CMaciej S. Szmigiero<maciej.szmigiero@oracle.co=
m> wrote=EF=BC=9A
>
> > Hi,
>
> > I am hitting a reproducible BUG() with KVM TDP MMU.
>
> > The reproducer based on set_memory_region_test.c from KVM selftests
> > is available here:
> > https://gist.github.com/maciejsszmigiero/890218151c242d99f63ea0825334c6=
c0
>
> > The test simply moves a memslot a bit back and forth on the host
> > while the guest is concurrently writing around the area being
> > moved.
>
> > The code runs fine on the default KVM MMU but triggers a BUG() when
> > TDP MMU is enabled by adding "tdp_mmu=3D1" kvm module parameter.
>
> > The backtrace is:
> > [ 1308.455120] kernel BUG at arch/x86/kvm/mmu/mmu_internal.h:100!
> > [ 1308.524951] invalid opcode: 0000 [#1] SMP PTI
> > [ 1308.577080] CPU: 92 PID: 18675 Comm: memslot_move_te Not tainted 5.1=
1.0-rc2+ #80
> > [ 1308.665617] Hardware name: Oracle Corporation ORACLE SERVER X7-2c/SE=
RVER MODULE ASSY, , BIOS 46070300 12/20/2019
> > [ 1308.787438] RIP: 0010:kvm_tdp_mmu_get_vcpu_root_hpa+0x10c/0x120 [kvm=
]
> > [ 1308.864587] Code: db 74 1c b8 00 00 00 80 48 03 43 40 72 1e 48 c7 c2=
 00 00 00 80 48 2b 15 92 0a 1d d3 48 01 d0 5b 41 5c 41 5d 41 5e 41 5f 5d c3=
 <0f> 0b > 48 8b 15 eb e8 3c d3 eb e7 66 0f 1f 84 00 00 00 00 00 0f 1f
> > [ 1309.089393] RSP: 0018:ffffa65affa73d10 EFLAGS: 00010246
> > [ 1309.151922] RAX: 0000000000000000 RBX: ffff9b46829bac78 RCX: 0000000=
000000000
> > [ 1309.237334] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa65=
ada1bd000
> > [ 1309.322744] RBP: ffffa65affa73d38 R08: 0000000000000000 R09: ffff9b4=
54e443200
> > [ 1309.408156] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000=
000001794
> > [ 1309.493567] R13: ffffa65ada1bd000 R14: ffff9b454e443040 R15: ffffa65=
ada1d2418
> > [ 1309.578977] FS:  00007fdb0430b700(0000) GS:ffff9ba3bfa00000(0000) kn=
lGS:0000000000000000
> > [ 1309.675833] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1309.744605] CR2: 0000000000000000 CR3: 0000006090046006 CR4: 0000000=
0007726e0
> > [ 1309.830018] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [ 1309.915428] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [ 1310.000837] PKRU: 55555554
> > [ 1310.033199] Call Trace:
> > [ 1310.062445]  kvm_mmu_load+0x29e/0x480 [kvm]
> > [ 1310.112542]  vcpu_enter_guest+0x112d/0x15b0 [kvm]
> > [ 1310.168865]  ? vmx_vcpu_load+0x2e/0x40 [kvm_intel]
> > [ 1310.226201]  kvm_arch_vcpu_ioctl_run+0xf9/0x580 [kvm]
> > [ 1310.286685]  kvm_vcpu_ioctl+0x247/0x600 [kvm]
> > [ 1310.338838]  ? tick_program_event+0x44/0x70
> > [ 1310.388888]  ? __audit_syscall_entry+0xdd/0x130
> > [ 1310.443101]  __x64_sys_ioctl+0x92/0xd0
> > [ 1310.487946]  do_syscall_64+0x37/0x50
> > [ 1310.530711]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [ 1310.591158] RIP: 0033:0x7fdb44a06307
> > [ 1310.633925] Code: 44 00 00 48 8b 05 69 1b 2d 00 64 c7 00 26 00 00 00=
 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05=
 <48> 3d 01 f0 > ff ff 73 01 c3 48 8b 0d 39 1b 2d 00 f7 d8 64 89 01 48
> > [ 1310.858726] RSP: 002b:00007fdb0430ae78 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000010
> > [ 1310.949338] RAX: ffffffffffffffda RBX: 00000000019662f0 RCX: 00007fd=
b44a06307
> > [ 1311.034747] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000=
000000007
> > [ 1311.120159] RBP: 0000000001965000 R08: 000000000040b2ff R09: 0000000=
000000000
> > [ 1311.205567] R10: 00007fdb0430a2a0 R11: 0000000000000246 R12: 0000000=
000000000
> > [ 1311.291738] R13: 0000000001965000 R14: 0000000000000000 R15: 00007fd=
b0430b700
> > [ 1311.377873] Modules linked in: kvm_intel kvm xt_comment xt_owner ip6=
t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrac=
k ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_security=
 ip6table_raw iptable_nat nf_nat iptable_mangle iptable_security iptable_ra=
w nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set ebtable_filter ebtables=
 ip6table_filter ip6_tables iptable_filter rpcrdma ib_isert iscsi_target_mo=
d ib_iser ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_u=
cm ib_umad iw_cxgb4 rdma_cm iw_cm ib_cm intel_rapl_msr intel_rapl_common sk=
x_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp bnxt_r=
e ib_uverbs mgag200 ib_core drm_kms_helper cec drm iTCO_wdt iTCO_vendor_sup=
port sg irqbypass pcspkr syscopyarea sysfillrect sysimgblt i2c_i801 ioatdma=
 fb_sys_fops joydev i2c_algo_bit i2c_smbus lpc_ich intel_pch_thermal dca ip=
_tables vfat fat xfs sd_mod t10_pi be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls=
 cxgb3i cxgb3 mdio libcxgbi
> > [ 1311.377953]  libcxgb qla4xxx iscsi_boot_sysfs crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper bnxt=
_en wmi sunrpc dm_mirror dm_region_hash dm_log dm_mod iscsi_tcp libiscsi_tc=
p libiscsi scsi_transport_iscsi [last unloaded: kvm]
> > [ 1312.712917] ---[ end trace 4716cc8fd037784d ]---
> > [ 1312.884672] RIP: 0010:kvm_tdp_mmu_get_vcpu_root_hpa+0x10c/0x120 [kvm=
]
> > [ 1312.962622] Code: db 74 1c b8 00 00 00 80 48 03 43 40 72 1e 48 c7 c2=
 00 00 00 80 48 2b 15 92 0a 1d d3 48 01 d0 5b 41 5c 41 5d 41 5e 41 5f 5d c3=
 <0f> 0b 48 8b 15 eb e8 3c d3 eb e7 66 0f 1f 84 00 00 00 00 00 0f 1f
> > [ 1313.189000] RSP: 0018:ffffa65affa73d10 EFLAGS: 00010246
> > [ 1313.252321] RAX: 0000000000000000 RBX: ffff9b46829bac78 RCX: 0000000=
000000000
> > [ 1313.338522] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa65=
ada1bd000
> > [ 1313.424727] RBP: ffffa65affa73d38 R08: 0000000000000000 R09: ffff9b4=
54e443200
> > [ 1313.510932] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000=
000001794
> > [ 1313.597140] R13: ffffa65ada1bd000 R14: ffff9b454e443040 R15: ffffa65=
ada1d2418
> > [ 1313.683343] FS:  00007fdb0430b700(0000) GS:ffff9ba3bfa00000(0000) kn=
lGS:0000000000000000
> > [ 1313.780987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1313.850556] CR2: 0000000000000000 CR3: 0000006090046006 CR4: 0000000=
0007726e0
> > [ 1313.936759] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> > [ 1314.022964] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> > [ 1314.109171] PKRU: 55555554
> > [ 1314.142325] Kernel panic - not syncing: Fatal exception
> > [ 1314.205755] Kernel Offset: 0x11a00000 from 0xffffffff81000000 (reloc=
ation range: 0xffffffff80000000-0xffffffffbfffffff)
> > [ 1315.367254] ---[ end Kernel panic - not syncing: Fatal exception ]--=
-
>
> > It looks like there might be an inbalance of kvm_mmu_get_root()
> > and kvm_mmu_put_root() somewhere but I couldn't really nail it down.
>
> > I've tried with and without "KVM: x86/mmu: Bug fixes and cleanups in
> > get_mmio_spte()" series applied, doesn't make any difference.
>
> > Thanks,
> > Maciej
>
> Hi, Maciej,
>
> I think you should post the environment of your hardware and software sys=
tem, such as which distribution hostOS is, kernel version, CPU model, etc .
>
> Leo Hou

Thanks for reporting this Maciej. I'll look into it this week. As Leo
Hou said, it would be helpful to know more about the environment you
ran this test on. Your theory about a get / put roots imbalance seems
like a good explanation. I'll see if I can find such an imbalance.
Ben
