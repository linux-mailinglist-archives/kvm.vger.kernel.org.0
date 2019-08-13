Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7DB8C41F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfHMWKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 18:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfHMWKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 18:10:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FB44806A2;
        Tue, 13 Aug 2019 22:10:16 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEF7F82E52;
        Tue, 13 Aug 2019 22:10:15 +0000 (UTC)
Date:   Tue, 13 Aug 2019 16:10:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813161015.22395e91@x1.home>
In-Reply-To: <f8119b68-bf75-9e01-e799-0c1cf965ba83@redhat.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
        <20190205210137.1377-11-sean.j.christopherson@intel.com>
        <20190813100458.70b7d82d@x1.home>
        <20190813170440.GC13991@linux.intel.com>
        <20190813115737.5db7d815@x1.home>
        <20190813133316.6fc6f257@x1.home>
        <20190813201914.GI13991@linux.intel.com>
        <cd9e5c9d-a321-b2f3-608d-0b8f74a5075f@redhat.com>
        <20190813151417.2cf979ca@x1.home>
        <f8119b68-bf75-9e01-e799-0c1cf965ba83@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 13 Aug 2019 22:10:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Aug 2019 23:15:38 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 13/08/19 23:14, Alex Williamson wrote:
> >> Do we even need the call to slot_handle_all_level?  The rmap update
> >> should be done already by kvm_mmu_prepare_zap_page (via
> >> kvm_mmu_page_unlink_children -> mmu_page_zap_pte -> drop_spte).
> >>
> >> Alex, can you replace it with just "flush = false;"?  
> > Replace the continue w/ flush = false?  I'm not clear on this
> > suggestion.  Thanks,  
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24843cf49579..382b3ee303e3 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5664,7 +5668,7 @@ kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm
>  	if (list_empty(&kvm->arch.active_mmu_pages))
>  		goto out_unlock;
> 
> -	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, false);
> +	flush = false;
> 
>  	for (i = 0; i < slot->npages; i++) {
>  		gfn = slot->base_gfn + i;
> 

Things are not happy with that, it managed to crash the host:

[  871.244789] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  871.258680] #PF: supervisor read access in kernel mode
[  871.268939] #PF: error_code(0x0000) - not-present page
[  871.279202] PGD 0 P4D 0 
[  871.284264] Oops: 0000 [#1] SMP PTI
[  871.291232] CPU: 3 PID: 1954 Comm: CPU 0/KVM Not tainted 5.3.0-rc4+ #4
[  871.304264] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[  871.322523] RIP: 0010:gfn_to_rmap+0xd9/0x120 [kvm]
[  871.332085] Code: c7 48 8d 0c 80 48 8d 04 48 4d 8d 14 c0 49 8b 02 48 39 c6 72 15 49 03 42 08 48 39 c6 73 0c 41 89 b9 08 b4 00 00 49 8b 3a eb 0b <48> 8b 3c 25 00 00 00 00 45 31 d2 0f b6 42 24 83 e0 0f 83 e8 01 8d
[  871.369560] RSP: 0018:ffffc10300a0bb18 EFLAGS: 00010202
[  871.379995] RAX: 00000000000c1040 RBX: ffffc103007cd000 RCX: 0000000000000014
[  871.394243] RDX: ffff9b3bbff18130 RSI: 00000000000c1080 RDI: 0000000000000004
[  871.408491] RBP: ffff9b3bced15400 R08: ffff9b3b94a90008 R09: ffff9b3b94a90000
[  871.422739] R10: ffff9b3b94a90168 R11: 0000000000000004 R12: ffff9b3bbff18130
[  871.436986] R13: ffffc103007cd000 R14: 0000000000000000 R15: 00000000000c1000
[  871.451234] FS:  00007fc27b37d700(0000) GS:ffff9b3f9f4c0000(0000) knlGS:0000000000000000
[  871.467390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  871.478865] CR2: 0000000000000000 CR3: 000000003bb2a004 CR4: 00000000001626e0
[  871.493113] Call Trace:
[  871.498012]  drop_spte+0x77/0xa0 [kvm]
[  871.505500]  mmu_page_zap_pte+0xac/0xe0 [kvm]
[  871.514200]  __kvm_mmu_prepare_zap_page+0x69/0x350 [kvm]
[  871.524809]  kvm_mmu_invalidate_zap_pages_in_memslot+0xb7/0x130 [kvm]
[  871.537670]  kvm_page_track_flush_slot+0x55/0x80 [kvm]
[  871.547928]  __kvm_set_memory_region+0x821/0xaa0 [kvm]
[  871.558191]  kvm_set_memory_region+0x26/0x40 [kvm]
[  871.567759]  kvm_vm_ioctl+0x59a/0x940 [kvm]
[  871.576106]  ? __seccomp_filter+0x7a/0x680
[  871.584287]  do_vfs_ioctl+0xa4/0x630
[  871.591430]  ? security_file_ioctl+0x32/0x50
[  871.599954]  ksys_ioctl+0x60/0x90
[  871.606575]  __x64_sys_ioctl+0x16/0x20
[  871.614066]  do_syscall_64+0x5f/0x1a0
[  871.621379]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

It also failed with the 1 vcpu test.  Thanks,

Alex
