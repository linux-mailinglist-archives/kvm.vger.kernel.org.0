Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E369446B598
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 09:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhLGIYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 03:24:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhLGIYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 03:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638865268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVt80OLLqyDLKlOzN/rfCCQXvXMRis170dBXGGpPZsQ=;
        b=ZWPrlsbjTxwR9p8Vmpq/FGuVrrt/jXRoWhVoT40ntGex4PFTnLgHlUF4+n3rctkQ5lal0K
        ssiRglPaEriusz9aTQUWilrTtulTXnYwBLzZVh0qvvVnqi2lsxrkTnd3LjMz3vlmxPO6bt
        OGQrMgO8gDEut1f6WyhVwQjMYY7Z85U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-iikRPffrNsGR4o7bdUOr3A-1; Tue, 07 Dec 2021 03:21:04 -0500
X-MC-Unique: iikRPffrNsGR4o7bdUOr3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14AA010199B9;
        Tue,  7 Dec 2021 08:20:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0B735D6CF;
        Tue,  7 Dec 2021 08:20:38 +0000 (UTC)
Message-ID: <35c1f907338fdc418a64c685d5a0a44669774627.camel@redhat.com>
Subject: Re: [syzbot] WARNING in nested_vmx_vmexit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com,
        syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, wanpengli@tencent.com, x86@kernel.org
Date:   Tue, 07 Dec 2021 10:20:37 +0200
In-Reply-To: <87k0gh675j.fsf@redhat.com>
References: <00000000000051f90e05d2664f1d@google.com>
         <87bl1u6qku.fsf@redhat.com> <Ya40sXNcLzBUlpdW@google.com>
         <87k0gh675j.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-12-06 at 17:16 +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Dec 06, 2021, Vitaly Kuznetsov wrote:
> > > syzbot <syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com> writes:
> > > 
> > > > Hello,
> > > > 
> > > > syzbot found the following issue on:
> > > > 
> > > > HEAD commit:    5f58da2befa5 Merge tag 'drm-fixes-2021-12-03-1' of git://a..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=14927309b00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=e9ea28d2c3c2c389
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f1d2136db9c80d4733e8
> > > > compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> > > > 
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > > 
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
> > > > 
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 0 PID: 21158 at arch/x86/kvm/vmx/nested.c:4548 nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
> > > > Modules linked in:
> > > > CPU: 0 PID: 21158 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
> > > 
> > > The comment above this WARN_ON_ONCE() says:
> > > 
> > > 4541)              /*
> > > 4542)               * The only expected VM-instruction error is "VM entry with
> > > 4543)               * invalid control field(s)." Anything else indicates a
> > > 4544)               * problem with L0.  And we should never get here with a
> > > 4545)               * VMFail of any type if early consistency checks are enabled.
> > > 4546)               */
> > > 4547)              WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
> > > 4548)                           VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> > > 
> > > which I think should still be valid and so the problem needs to be
> > > looked at L0 (GCE infrastructure). Sean, Jim, your call :-)
> > 
> > The assertion itself is still valid, but look at the call stack.  This is firing
> > when KVM tears down the VM, i.e. vmx->fail is likely stale.
> 
> Oh, I see, true that!
> 
> >  I'll bet dollars to
> > donuts that commit c8607e4a086f ("KVM: x86: nVMX: don't fail nested VM entry on
> > invalid guest state if !from_vmentry") is to blame.  L1 is running with
> > unrestricted_guest=Y, so the only way vmx->emulation_required should become true
> > is if L2 is active and is not an unrestricted guest.
> > 
> > I objected to the patch[*], but looking back at the dates, it appears that I did
> > so after the patch was queued and my comments were never addressed.  
> > I'll see if I can reproduce this with a selftest.  The fix is likely just:
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index dc4909b67c5c..927a7c43b73b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6665,10 +6665,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >          * consistency check VM-Exit due to invalid guest state and bail.
> >          */
> >         if (unlikely(vmx->emulation_required)) {
> > -
> > -               /* We don't emulate invalid state of a nested guest */
> > -               vmx->fail = is_guest_mode(vcpu);
> > -
> >                 vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> >                 vmx->exit_reason.failed_vmentry = 1;
> >                 kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> > 
> > [*] https://lore.kernel.org/all/YWDWPbgJik5spT1D@google.com/
> > 
> 
> Let's also summon Max to the discussion to get his thoughts.

I'll take a look at that soon. Need to page in the reason why
this has to be done.


I remember that we have wierd case of L1 beeing in invalid state,
because some of the SMM's invalid state is leaking to L1 after a migration,
and otherwise L1 while nested has to be in valid state:

L1 really can't be in invalid state while in VMXON (even if it could theoretically,
no way it can reach that point - I need to refresh my VMX knowelege to be sure about it), 
and L2 has to have valid state since that is the defintion of VMX
- if L2 were in invalid state, then L1 would have to emualte L2 and not use VMX.

I'll take a more detailed look soon at this.

Best regards,
	Maxim Levitsky

> 
> > > >  <TASK>
> > > >  vmx_leave_nested arch/x86/kvm/vmx/nested.c:6220 [inline]
> > > >  nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
> > > >  vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
> > > >  kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10989
> > > >  kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
> > > >  kvm_free_vcpus arch/x86/kvm/x86.c:11426 [inline]
> > > >  kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11545
> > > >  kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
> > > >  kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
> > > >  kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3489
> > > >  __fput+0x3fc/0x870 fs/file_table.c:280
> > > >  task_work_run+0x146/0x1c0 kernel/task_work.c:164
> > > >  exit_task_work include/linux/task_work.h:32 [inline]
> > > >  do_exit+0x705/0x24f0 kernel/exit.c:832
> > > >  do_group_exit+0x168/0x2d0 kernel/exit.c:929
> > > >  get_signal+0x1740/0x2120 kernel/signal.c:2852
> > > >  arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
> > > >  handle_signal_work kernel/entry/common.c:148 [inline]
> > > >  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
> > > >  exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
> > > >  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
> > > >  syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
> > > >  do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > RIP: 0033:0x7f3388806b19
> > > > Code: Unable to access opcode bytes at RIP 0x7f3388806aef.
> > > > RSP: 002b:00007f338773a218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> > > > RAX: fffffffffffffe00 RBX: 00007f338891a0e8 RCX: 00007f3388806b19
> > > > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f338891a0e8
> > > > RBP: 00007f338891a0e0 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007f338891a0ec
> > > > R13: 00007fffbe0e838f R14: 00007f338773a300 R15: 0000000000022000
> > > >  </TASK>


