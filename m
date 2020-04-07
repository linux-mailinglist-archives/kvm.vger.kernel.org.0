Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A501A0C64
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 13:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgDGLBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 07:01:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40444 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728129AbgDGLBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 07:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586257288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8h7WOmhqWbqsj2xXniOI5xjfIW2oGUv8L9dkNvwcCDM=;
        b=CN0nUyjctr3dwHZ1NLyOO2uA1sMspQyqDq1Sd2DlnYMd/YjpH300QFwDM71cmrwrJ1ItZ5
        DXNCKr9oi6MTnHK6y9WreMFKeSUc4/gABA/ZkI4r44rlXdEDCfhN88ik2EzO3SRFJ5JP2j
        EYmSzLa5u8AFN7xtcVnHhAOtED3ONtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-9ThSrBYlPeGPa8K6lERIRg-1; Tue, 07 Apr 2020 07:01:23 -0400
X-MC-Unique: 9ThSrBYlPeGPa8K6lERIRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1900B8017F3;
        Tue,  7 Apr 2020 11:01:22 +0000 (UTC)
Received: from localhost (ovpn-12-129.pek2.redhat.com [10.72.12.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33E0092F83;
        Tue,  7 Apr 2020 11:01:17 +0000 (UTC)
Date:   Tue, 7 Apr 2020 19:01:15 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
Message-ID: <20200407110115.GA14381@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321193751.24985-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/21/20 at 12:37pm, Sean Christopherson wrote:
> Patch 1 fixes a a theoretical bug where a crashdump NMI that arrives
> while KVM is messing with the percpu VMCS list would result in one or more
> VMCSes not being cleared, potentially causing memory corruption in the new
> kexec'd kernel.

I am wondering if this theoretical bug really exists. Now CKI of Redhat
reported crash dumping failed on below commit. I reserved a
intel machine and can reproduce it always. 

Commit: 5364abc57993 - Merge tag 'arc-5.7-rc1' of

From failure trace, it's the kvm vmx which caused this. I have reverted
them and the failure disappeared.

4f6ea0a87608 KVM: VMX: Gracefully handle faults on VMXON
d260f9ef50c7 KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
31603d4fc2bb KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support

The trace is here. 

[  132.476387] sysrq: Trigger a crash 
[  132.479829] Kernel panic - not syncing: sysrq triggered crash 
[  132.480817] CPU: 4 PID: 1975 Comm: runtest.sh Kdump: loaded Not tainted 5.6.0-5364abc.cki #1 
[  132.480817] Hardware name: Dell Inc. Precision R7610/, BIOS A08 11/21/2014 
[  132.480817] Call Trace: 
[  132.480817]  dump_stack+0x66/0x90 
[  132.480817]  panic+0x101/0x2e3 
[  132.480817]  ? printk+0x58/0x6f 
[  132.480817]  sysrq_handle_crash+0x11/0x20 
[  132.480817]  __handle_sysrq.cold+0x48/0x104 
[  132.480817]  write_sysrq_trigger+0x24/0x40 
[  132.480817]  proc_reg_write+0x3c/0x60 
[  132.480817]  vfs_write+0xb6/0x1a0 
[  132.480817]  ksys_write+0x5f/0xe0 
[  132.480817]  do_syscall_64+0x5b/0x1c0 
[  132.480817]  entry_SYSCALL_64_after_hwframe+0x44/0xa9 
[  132.480817] RIP: 0033:0x7f205575d4b7 
[  132.480817] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24 
[  132.480817] RSP: 002b:00007ffe6ab44a38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001 
[  132.480817] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f205575d4b7 
[  132.480817] RDX: 0000000000000002 RSI: 000055e2876e1da0 RDI: 0000000000000001 
[  132.480817] RBP: 000055e2876e1da0 R08: 000000000000000a R09: 0000000000000001 
[  132.480817] R10: 000055e2879bf930 R11: 0000000000000246 R12: 0000000000000002 
[  132.480817] R13: 00007f205582e500 R14: 0000000000000002 R15: 00007f205582e700 
[  132.480817] BUG: unable to handle page fault for address: ffffffffffffffc8 
[  132.480817] #PF: supervisor read access in kernel mode 
[  132.480817] #PF: error_code(0x0000) - not-present page 
[  132.480817] PGD 14460f067 P4D 14460f067 PUD 144611067 PMD 0  
[  132.480817] Oops: 0000 [#12] SMP PTI 
[  132.480817] CPU: 4 PID: 1975 Comm: runtest.sh Kdump: loaded Tainted: G      D           5.6.0-5364abc.cki #1 
[  132.480817] Hardware name: Dell Inc. Precision R7610/, BIOS A08 11/21/2014 
[  132.480817] RIP: 0010:crash_vmclear_local_loaded_vmcss+0x57/0xd0 [kvm_intel] 
[  132.480817] Code: c7 c5 40 e0 02 00 4a 8b 04 f5 80 69 42 85 48 8b 14 28 48 01 e8 48 39 c2 74 4d 4c 8d 6a c8 bb 00 00 00 80 49 c7 c4 00 00 00 80 <49> 8b 7d 00 48 89 fe 48 01 de 72 5c 4c 89 e0 48 2b 05 13 a8 88 c4 
[  132.480817] RSP: 0018:ffffa85d435dfcb0 EFLAGS: 00010007 
[  132.480817] RAX: ffff9c82ebb2e040 RBX: 0000000080000000 RCX: 000000000000080f 
[  132.480817] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 000000000000080f 
[  132.480817] RBP: 000000000002e040 R08: 000000717702c90c R09: 0000000000000004 
[  132.480817] R10: 0000000000000009 R11: 0000000000000000 R12: ffffffff80000000 
[  132.480817] R13: ffffffffffffffc8 R14: 0000000000000004 R15: 0000000000000000 
[  132.480817] FS:  00007f2055668740(0000) GS:ffff9c82ebb00000(0000) knlGS:0000000000000000 
[  132.480817] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  132.480817] CR2: ffffffffffffffc8 CR3: 0000000151904003 CR4: 00000000000606e0 
[  132.480817] Call Trace: 
[  132.480817]  native_machine_crash_shutdown+0x45/0x190 
[  132.480817]  __crash_kexec+0x61/0x130 
[  132.480817]  ? __crash_kexec+0x9a/0x130 
[  132.480817]  ? panic+0x11d/0x2e3 
[  132.480817]  ? printk+0x58/0x6f 
[  132.480817]  ? sysrq_handle_crash+0x11/0x20 
[  132.480817]  ? __handle_sysrq.cold+0x48/0x104 
[  132.480817]  ? write_sysrq_trigger+0x24/0x40 
[  132.480817]  ? proc_reg_write+0x3c/0x60 
[  132.480817]  ? vfs_write+0xb6/0x1a0 
[  132.480817]  ? ksys_write+0x5f/0xe0 
[  132.480817]  ? do_syscall_64+0x5b/0x1c0 
[  132.480817]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9 

> 
> Patch 2 is cleanup that's made possible by patch 1.
> 
> Patch 3 isn't directly related, but it conflicts with the crash cleanup
> changes, both from a code and a semantics perspective.  Without the crash
> cleanup, IMO hardware_enable() should do crash_disable_local_vmclear()
> if VMXON fails, i.e. clean up after itself.  But hardware_disable()
> doesn't even do crash_disable_local_vmclear() (which is what got me
> looking at that code in the first place).  Basing the VMXON change on top
> of the crash cleanup avoids the debate entirely.
> 
> v2:
>   - Inverted the code flow, i.e. move code from loaded_vmcs_init() to
>     __loaded_vmcs_clear().  Trying to share loaded_vmcs_init() with
>     alloc_loaded_vmcs() was taking more code than it saved. [Paolo]
> 
> 
> Gory details on the crashdump bug:
> 
> I verified my analysis of the NMI bug by simulating what would happen if
> an NMI arrived in the middle of list_add() and list_del().  The below
> output matches expectations, e.g. nothing hangs, the entry being added
> doesn't show up, and the entry being deleted _does_ show up.
> 
> [    8.205898] KVM: testing NMI in list_add()
> [    8.205898] KVM: testing NMI in list_del()
> [    8.205899] KVM: found e3
> [    8.205899] KVM: found e2
> [    8.205899] KVM: found e1
> [    8.205900] KVM: found e3
> [    8.205900] KVM: found e1
> 
> static void vmx_test_list(struct list_head *list, struct list_head *e1,
>                           struct list_head *e2, struct list_head *e3)
> {
>         struct list_head *tmp;
> 
>         list_for_each(tmp, list) {
>                 if (tmp == e1)
>                         pr_warn("KVM: found e1\n");
>                 else if (tmp == e2)
>                         pr_warn("KVM: found e2\n");
>                 else if (tmp == e3)
>                         pr_warn("KVM: found e3\n");
>                 else
>                         pr_warn("KVM: kaboom\n");
>         }
> }
> 
> static int __init vmx_init(void)
> {
>         LIST_HEAD(list);
>         LIST_HEAD(e1);
>         LIST_HEAD(e2);
>         LIST_HEAD(e3);
> 
>         pr_warn("KVM: testing NMI in list_add()\n");
> 
>         list.next->prev = &e1;
>         vmx_test_list(&list, &e1, &e2, &e3);
> 
>         e1.next = list.next;
>         vmx_test_list(&list, &e1, &e2, &e3);
> 
>         e1.prev = &list;
>         vmx_test_list(&list, &e1, &e2, &e3);
> 
>         INIT_LIST_HEAD(&list);
>         INIT_LIST_HEAD(&e1);
> 
>         list_add(&e1, &list);
>         list_add(&e2, &list);
>         list_add(&e3, &list);
> 
>         pr_warn("KVM: testing NMI in list_del()\n");
> 
>         e3.prev = &e1;
>         vmx_test_list(&list, &e1, &e2, &e3);
> 
>         list_del(&e2);
>         list.prev = &e1;
>         vmx_test_list(&list, &e1, &e2, &e3);
> }
> 
> Sean Christopherson (3):
>   KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
>   KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
>   KVM: VMX: Gracefully handle faults on VMXON
> 
>  arch/x86/kvm/vmx/vmx.c | 103 ++++++++++++++++-------------------------
>  arch/x86/kvm/vmx/vmx.h |   1 -
>  2 files changed, 40 insertions(+), 64 deletions(-)
> 
> -- 
> 2.24.1
> 

