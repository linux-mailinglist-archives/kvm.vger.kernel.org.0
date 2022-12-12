Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB21D649864
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 05:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiLLEfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 23:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiLLEfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 23:35:46 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D0DBC82
        for <kvm@vger.kernel.org>; Sun, 11 Dec 2022 20:35:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 36so452320pgp.10
        for <kvm@vger.kernel.org>; Sun, 11 Dec 2022 20:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ubgo7B2+sy1HQSSzjXtpMX+QA+9UIpAKmb6lUXH7fV4=;
        b=bUy4NC2EE9Hd0Yew69molOYgha4K8GdQtbN1gUbvTM20ZASrtm9he23PDxafSQn1x+
         2bE3mITxwOR1DYKsXCb2EEXL8uRIdOXM4byenmSFTnyMOAI2B1sA1SbcO0Hc89/+6Irk
         0/Vk0jLh7x5Ofxx2y3gdlWJl9xwzzw8g+ky4/EZFFs5R75HiDHJIMs5zbBv3kt2cc4FR
         Wb4SxnBwi41fqVjj8T7pXFoJhk+kZBfxCb42nEzuuJnD4D41rxsjl+SnE094kBNRuL0L
         gEx8COQygtP9TKGXV4UDGlRDf1U4KgkDbzPsmCOMS6Vix+rh5g4avZpnnWEtN85kCUGz
         JY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ubgo7B2+sy1HQSSzjXtpMX+QA+9UIpAKmb6lUXH7fV4=;
        b=xNNF/UlDiBQoHei+wkNPypyLP3LM3Ne4VsE0Zn0fo+76qiMwk2PylgebPVfI7p3cnZ
         +V4c3qyowl3Ss/cYWWRhaS9mLLZXKF9FSkyfOHjRVqrAV764WpCp2+XMfYzNJB6DokS1
         BYmyhJHVV+xXpDgssq+c3h8nmBpEtwxbAZIQLkTFf2PuIjYUuk7YkhqDkIfLL+D3s1St
         KL5bZLRTbIEHR3pcZGhyx+NJF5k4NOeChNr+kK1bK13WLf/eAlSmdEhcR6S+QG8wsxlA
         2V6BmKreWZi4oo9172teN+Tvfp2ixESN3RAZsK4ZB1R/g3aMWNELrdIKaxRbIdSOvgC8
         Fvvg==
X-Gm-Message-State: ANoB5pkiTeEpCcHA/JqViFvQf1bFcedpLxuCE/oBp/BAg+rLzhooxbZG
        9TaGpopb65JavNUf+31HRhX3wA==
X-Google-Smtp-Source: AA0mqf6SSBQtH/L98ZX2bU+pEyZfzgZyEAyYA4+rW1zsOXG/8HMJ847J4oQwQ5FWKdUkPo+LypdS4A==
X-Received: by 2002:a05:6a00:368f:b0:56c:375e:17e0 with SMTP id dw15-20020a056a00368f00b0056c375e17e0mr15821017pfb.8.1670819743492;
        Sun, 11 Dec 2022 20:35:43 -0800 (PST)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b00577adb71f92sm4671025pfb.219.2022.12.11.20.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 20:35:42 -0800 (PST)
Date:   Mon, 12 Dec 2022 04:35:39 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH v4 0/2] Deprecate BUG() in pte_list_remove() in
 shadow mmu
Message-ID: <Y5avm5VXpRt263wQ@google.com>
References: <20221129191237.31447-1-mizhang@google.com>
 <Y5Oob6mSJKGoDBnt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5Oob6mSJKGoDBnt@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022, David Matlack wrote:
> On Tue, Nov 29, 2022 at 07:12:35PM +0000, Mingwei Zhang wrote:
> > Deprecate BUG() in pte_list_remove() in shadow mmu to avoid crashing a
> > physical machine. There are several reasons and motivations to do so:
> > 
> > MMU bug is difficult to discover due to various racing conditions and
> > corner cases and thus it extremely hard to debug. The situation gets much
> > worse when it triggers the shutdown of a host. Host machine crash might
> > eliminates everything including the potential clues for debugging.
> > 
> > From cloud computing service perspective, BUG() or BUG_ON() is probably no
> > longer appropriate as the host reliability is top priority. Crashing the
> > physical machine is almost never a good option as it eliminates innocent
> > VMs and cause service outage in a larger scope. Even worse, if attacker can
> > reliably triggers this code by diverting the control flow or corrupting the
> > memory, then this becomes vm-of-death attack. This is a huge attack vector
> > to cloud providers, as the death of one single host machine is not the end
> > of the story. Without manual interferences, a failed cloud job may be
> > dispatched to other hosts and continue host crashes until all of them are
> > dead.
> 
> My only concern with using KVM_BUG() is whether the machine can keep
> running correctly after this warning has been hit. In other words, are
> we sure the damage is contained to just this VM?
> 
> If, for example, the KVM_BUG() was triggered by a use-after-free, then
> there might be corrupted memory floating around in the machine.
> 

David,

Your concern is quite reasonable. But given that both rmap and spte are
pointers/data structures managed by individual VMs, i.e., none of them
are global pointers, use-after-free is unlikely happening on cross-VM
cases. Even if there is, then shuting down those corrupted VMs is feasible
here, since pte_list_remove() basically does the checking.
> What are some instances where we've seen these BUG_ON()s get triggered?
> For those instances, would it actually be safe to just kill the current
> VM and keep the rest of the machine running?
> 
> > 
> > For the above reason, we propose the replacement of BUG() in
> > pte_list_remove() with KVM_BUG() to crash just the VM itself.
> 
> How did you test this series?

I used a simple test case to test the series:

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0f6455072055..d4b993b26b96 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -701,7 +701,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, *it.sptep, it.level);

-		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1) - 1;
 		if (it.level == fault->goal_level)
 			break;

On the testing machine, I launched a L1 VM and a L2 VM within it. The L2
will trigger the above bug in shadow MMU and I got the following error
in L0 kernel dmesg as shown below. L1 and L2 hangs with high CPU usage
for a while and after a couple of seconds, the L1 VM dies properly. The
machine is still alive and subsequent VM operations are all good
(launch/kill).

[ 1678.043378] ------------[ cut here ]------------
[ 1678.043381] gfn mismatch under direct page 1041bf (expected 10437e, got 1043be)
[ 1678.043386] WARNING: CPU: 4 PID: 23430 at arch/x86/kvm/mmu/mmu.c:737 kvm_mmu_page_set_translation+0x131/0x140
[ 1678.043395] Modules linked in: kvm_intel vfat fat i2c_mux_pca954x i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
[ 1678.043404] CPU: 4 PID: 23430 Comm: VCPU-7 Tainted: G S         O       6.1.0-smp-DEV #5
[ 1678.043406] Hardware name: Google LLC Indus/Indus_QC_02, BIOS 30.12.6 02/14/2022
[ 1678.043407] RIP: 0010:kvm_mmu_page_set_translation+0x131/0x140
[ 1678.043411] Code: 0f 44 e0 4c 8b 6b 28 48 89 df 44 89 f6 e8 b7 fb ff ff 48 c7 c7 1b 5a 2f 82 4c 89 e6 4c 89 ea 48 89 c1 4d 89 f8 e8 9f 39 0c 00 <0f> 0b eb ac 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
[ 1678.043413] RSP: 0018:ffff88811ba87918 EFLAGS: 00010246
[ 1678.043415] RAX: 1bdd851636664d00 RBX: ffff888118602e60 RCX: 0000000000000027
[ 1678.043416] RDX: 0000000000000002 RSI: c0000000ffff7fff RDI: ffff8897e0320488
[ 1678.043417] RBP: ffff88811ba87940 R08: 0000000000000000 R09: ffffffff82b2e6f0
[ 1678.043418] R10: 00000000ffff7fff R11: 0000000000000000 R12: ffffffff822e89da
[ 1678.043419] R13: 00000000001041bf R14: 00000000000001bf R15: 00000000001043be
[ 1678.043421] FS:  00007fee198ec700(0000) GS:ffff8897e0300000(0000) knlGS:0000000000000000
[ 1678.043422] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1678.043424] CR2: 0000000000000000 CR3: 0000001857c34005 CR4: 00000000003726e0
[ 1678.043425] Call Trace:
[ 1678.043426]  <TASK>
[ 1678.043428]  __rmap_add+0x8a/0x270
[ 1678.043432]  mmu_set_spte+0x250/0x340
[ 1678.043435]  ept_fetch+0x8ad/0xc00
[ 1678.043437]  ept_page_fault+0x265/0x2f0
[ 1678.043440]  kvm_mmu_page_fault+0xfa/0x2d0
[ 1678.043443]  handle_ept_violation+0x135/0x2e0 [kvm_intel]
[ 1678.043455]  ? handle_desc+0x20/0x20 [kvm_intel]
[ 1678.043462]  __vmx_handle_exit+0x1c3/0x480 [kvm_intel]
[ 1678.043468]  vmx_handle_exit+0x12/0x40 [kvm_intel]
[ 1678.043474]  vcpu_enter_guest+0xbb3/0xf80
[ 1678.043477]  ? complete_fast_pio_in+0xcc/0x160
[ 1678.043480]  kvm_arch_vcpu_ioctl_run+0x3b0/0x770
[ 1678.043481]  kvm_vcpu_ioctl+0x52d/0x610
[ 1678.043486]  ? kvm_on_user_return+0x46/0xd0
[ 1678.043489]  __se_sys_ioctl+0x77/0xc0
[ 1678.043492]  __x64_sys_ioctl+0x1d/0x20
[ 1678.043493]  do_syscall_64+0x3d/0x80
[ 1678.043497]  ? sysvec_apic_timer_interrupt+0x49/0x90
[ 1678.043499]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 1678.043501] RIP: 0033:0x7fee3ebf0347
[ 1678.043503] Code: 5d c3 cc 48 8b 05 f9 2f 07 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 cc cc cc cc cc cc cc cc cc cc b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 2f 07 00 f7 d8 64 89 01 48
[ 1678.043505] RSP: 002b:00007fee198e8998 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1678.043507] RAX: ffffffffffffffda RBX: 0000555308e7e4d0 RCX: 00007fee3ebf0347
[ 1678.043507] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 00000000000000b0
[ 1678.043508] RBP: 00007fee198e89c0 R08: 000055530943d920 R09: 00000000000003fa
[ 1678.043509] R10: 0000555307349b00 R11: 0000000000000246 R12: 00000000000000b0
[ 1678.043510] R13: 00005574c1a1de88 R14: 00007fee198e8a27 R15: 0000000000000000
[ 1678.043511]  </TASK>
[ 1678.043512] ---[ end trace 0000000000000000 ]---
[ 5313.657064] ------------[ cut here ]------------
[ 5313.657067] no rmap for 0000000071a2f138 (many->many)
[ 5313.657071] WARNING: CPU: 43 PID: 23398 at arch/x86/kvm/mmu/mmu.c:983 pte_list_remove+0x17a/0x190
[ 5313.657080] Modules linked in: kvm_intel vfat fat i2c_mux_pca954x i2c_mux spidev cdc_acm xhci_pci xhci_hcd sha3_generic gq(O)
[ 5313.657088] CPU: 43 PID: 23398 Comm: kvm-nx-lpage-re Tainted: G S      W  O       6.1.0-smp-DEV #5
[ 5313.657090] Hardware name: Google LLC Indus/Indus_QC_02, BIOS 30.12.6 02/14/2022
[ 5313.657092] RIP: 0010:pte_list_remove+0x17a/0x190
[ 5313.657095] Code: cf e4 01 01 48 c7 c7 4d 3c 32 82 e8 70 5e 0c 00 0f 0b e9 0a ff ff ff c6 05 d4 cf e4 01 01 48 c7 c7 9e de 33 82 e8 56 5e 0c 00 <0f> 0b 84 db 75 c8 e9 ec fe ff ff 66 66 2e 0f 1f 84 00 00 00 00 00
[ 5313.657097] RSP: 0018:ffff88986d5d3c30 EFLAGS: 00010246
[ 5313.657099] RAX: 1ebf71ba511d3100 RBX: 0000000000000000 RCX: 0000000000000027
[ 5313.657101] RDX: 0000000000000002 RSI: c0000000ffff7fff RDI: ffff88afdf3e0488
[ 5313.657102] RBP: ffff88986d5d3c40 R08: 0000000000000000 R09: ffffffff82b2e6f0
[ 5313.657104] R10: 00000000ffff7fff R11: 40000000ffff8a28 R12: 0000000000000000
[ 5313.657105] R13: ffff888118602000 R14: ffffc90020e1e000 R15: ffff88815df33030
[ 5313.657106] FS:  0000000000000000(0000) GS:ffff88afdf3c0000(0000) knlGS:0000000000000000
[ 5313.657107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5313.657109] CR2: 000017c92b50f1b8 CR3: 000000006f40a001 CR4: 00000000003726e0
[ 5313.657110] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5313.657111] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5313.657112] Call Trace:
[ 5313.657113]  <TASK>
[ 5313.657114]  drop_spte+0x175/0x180
[ 5313.657117]  mmu_page_zap_pte+0xfd/0x130
[ 5313.657119]  __kvm_mmu_prepare_zap_page+0x290/0x6e0
[ 5313.657122]  ? newidle_balance+0x228/0x3b0
[ 5313.657126]  kvm_nx_huge_page_recovery_worker+0x266/0x360
[ 5313.657129]  kvm_vm_worker_thread+0x93/0x150
[ 5313.657134]  ? kvm_mmu_post_init_vm+0x40/0x40
[ 5313.657136]  ? kvm_vm_create_worker_thread+0x120/0x120
[ 5313.657139]  kthread+0x10d/0x120
[ 5313.657141]  ? kthread_blkcg+0x30/0x30
[ 5313.657142]  ret_from_fork+0x1f/0x30
[ 5313.657156]  </TASK>
[ 5313.657156] ---[ end trace 0000000000000000 ]---
