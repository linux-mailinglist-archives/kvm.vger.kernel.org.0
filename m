Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFA111CD
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 05:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfEBDKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 23:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfEBDKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 23:10:55 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 653D82085A;
        Thu,  2 May 2019 03:10:53 +0000 (UTC)
Date:   Wed, 1 May 2019 23:10:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, kvm@vger.kernel.org,
        adrian.hunter@intel.com, davem@davemloft.net, dedekind1@gmail.com,
        jbaron@redhat.com, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        luto@kernel.org, mingo@kernel.org, peterz@infradead.org,
        richard@nod.at, riel@surriel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Subject: Re: BUG: soft lockup in kvm_vm_ioctl
Message-ID: <20190501231051.50eeccd6@oasis.local.home>
In-Reply-To: <20190502023426.GA804@sol.localdomain>
References: <000000000000fb78720587d46fe9@google.com>
        <20190502023426.GA804@sol.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 May 2019 19:34:27 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> > Call Trace:
> >  smp_call_function_many+0x750/0x8c0 kernel/smp.c:434
> >  smp_call_function+0x42/0x90 kernel/smp.c:492
> >  on_each_cpu+0x31/0x200 kernel/smp.c:602
> >  text_poke_bp+0x107/0x19b arch/x86/kernel/alternative.c:821
> >  __jump_label_transform+0x263/0x330 arch/x86/kernel/jump_label.c:91
> >  arch_jump_label_transform+0x2b/0x40 arch/x86/kernel/jump_label.c:99
> >  __jump_label_update+0x16a/0x210 kernel/jump_label.c:389
> >  jump_label_update kernel/jump_label.c:752 [inline]
> >  jump_label_update+0x1ce/0x3d0 kernel/jump_label.c:731
> >  static_key_slow_inc_cpuslocked+0x1c1/0x250 kernel/jump_label.c:129
> >  static_key_slow_inc+0x1b/0x30 kernel/jump_label.c:144
> >  kvm_arch_vcpu_init+0x6b7/0x870 arch/x86/kvm/x86.c:9068
> >  kvm_vcpu_init+0x272/0x370 arch/x86/kvm/../../../virt/kvm/kvm_main.c:320
> >  vmx_create_vcpu+0x191/0x2540 arch/x86/kvm/vmx/vmx.c:6577
> >  kvm_arch_vcpu_create+0x80/0x120 arch/x86/kvm/x86.c:8755
> >  kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:2569
> > [inline]
> >  kvm_vm_ioctl+0x5ce/0x19c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3105
> >  vfs_ioctl fs/ioctl.c:46 [inline]
> >  file_ioctl fs/ioctl.c:509 [inline]
> >  do_vfs_ioctl+0xd6e/0x1390 fs/ioctl.c:696
> >  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> >  __do_sys_ioctl fs/ioctl.c:720 [inline]
> >  __se_sys_ioctl fs/ioctl.c:718 [inline]
> >  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> >  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe

> 
> I'm also curious how syzbot found the list of people to send this to, as it
> seems very random.  This should obviously have gone to the kvm mailing list, but
> it wasn't sent there; I had to manually add it.

My guess is that it went down the call stack, and picked those that
deal with the functions that are listed at the deepest part of the
stack. kvm doesn't appear for 12 functions up from the crash. It
probably stopped its search before that.

-- Steve
