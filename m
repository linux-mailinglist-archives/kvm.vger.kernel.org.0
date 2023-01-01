Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80E165A9AD
	for <lists+kvm@lfdr.de>; Sun,  1 Jan 2023 12:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjAALJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Jan 2023 06:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAALJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Jan 2023 06:09:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB7610F7
        for <kvm@vger.kernel.org>; Sun,  1 Jan 2023 03:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672571293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fBBKzqii62ZjxIZ4kMasNOVjJLy5rfIiuLe5QumouC4=;
        b=RolpFh6oaN+oHcH2faPU4JYqqzCvqSIxbxj/Xh6GvQ9MO6CJINx3PEEMYBq0AYQW/3TwOY
        QVSTgRC1d6GVLU5llSQcKlq5lUkYpb62wTD4GxeG/vmUuT86xPOQLOnO1n0a7D1UqEQblu
        3n4AJRTTYYbc8SGhj3SPV/r3vgabh58=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-306-N94mb2r8OT2IfZAZ9rFgwQ-1; Sun, 01 Jan 2023 06:08:12 -0500
X-MC-Unique: N94mb2r8OT2IfZAZ9rFgwQ-1
Received: by mail-wm1-f69.google.com with SMTP id c23-20020a7bc857000000b003d97c8d4935so9389892wml.8
        for <kvm@vger.kernel.org>; Sun, 01 Jan 2023 03:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fBBKzqii62ZjxIZ4kMasNOVjJLy5rfIiuLe5QumouC4=;
        b=Y2pdv44zQxjwrcI1rFVrSWe6BvFPmIDW5FWPKxv/w/VGRuDgeECipAL0HJ6w4ClvUV
         9wQv0gZnwgKqqp67W2e9lO1GiVW8gmBKRovV1MDd6a5ZSH4581peJ0se7C/oYAZZduUh
         WJ9Sy74ajEDfVzQBKCsbJlpUW6ZM55aP2A5bXWVTbnBzb++zq4N27oRN/0f0OryU/4F+
         O6G09Kr9NfCj7jLu/qkGKERVMdJMXIHLAwW3II8g9UtjHJzzbHT7SKf7XKfDGqwXNT0N
         ViYeJ6WAJXRQOTMVMH7M3o1BOxOqK6i7yhgHZvZvxEzhzlN+tNkT5OdanTkc5s59SFjj
         XTuA==
X-Gm-Message-State: AFqh2krG0QP5aj3mrTA7b+9hLj5T82TXXXnd6uzvjIrKvQyzY93zzvRL
        UCGQna+LNM98qKUDM7hBbN/aVPlvUID8Op3b9yvKKS5ych//eVOBM6XoHbqBA3At7uPS57FG3Qx
        IBUr2mDaj9rjU
X-Received: by 2002:a05:600c:41c2:b0:3d3:5565:3617 with SMTP id t2-20020a05600c41c200b003d355653617mr30193549wmh.24.1672571291059;
        Sun, 01 Jan 2023 03:08:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv3H1oBhA10tTYm0SEh9kpFSr3kuZ1y9+L8b22gb0VvrfW/7eer/yg4p3C3Kirc5w3npOjo+A==
X-Received: by 2002:a05:600c:41c2:b0:3d3:5565:3617 with SMTP id t2-20020a05600c41c200b003d355653617mr30193528wmh.24.1672571290802;
        Sun, 01 Jan 2023 03:08:10 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id q2-20020a1cf302000000b003d1cc0464a2sm34525487wmq.8.2023.01.01.03.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 03:08:10 -0800 (PST)
Message-ID: <451187de09e9a80f73a0588da65d55d4a8da6552.camel@redhat.com>
Subject: Re: supervisor write access in kernel mode in
 __pv_queued_spin_unlock_slowpath
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Date:   Sun, 01 Jan 2023 13:08:07 +0200
In-Reply-To: <Y7E4OZUmvI97tTw7@hyeyoo>
References: <202212312021.bc1efe86-oliver.sang@intel.com>
         <Y7EtNNzfxuiX/VEg@hyeyoo> <Y7E4OZUmvI97tTw7@hyeyoo>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2023-01-01 at 16:37 +0900, Hyeonggon Yoo wrote:
> On Sun, Jan 01, 2023 at 03:50:28PM +0900, Hyeonggon Yoo wrote:
> > On Sat, Dec 31, 2022 at 11:26:25PM +0800, kernel test robot wrote:
> > > Greeting,
> > > 
> > > FYI, we noticed kernel_BUG_at_include/linux/mm.h due to commit (built with gcc-11):
> > > 
> > > commit: 0af8489b0216fa1dd83e264bef8063f2632633d7 ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > [test failed on linux-next/master c76083fac3bae1a87ae3d005b5cb1cbc761e31d5]
> > > 
> > > in testcase: rcutorture
> > > version: 
> > > with following parameters:
> > > 
> > > 	runtime: 300s
> > > 	test: default
> > > 	torture_type: tasks-tracing
> > > 
> > > test-description: rcutorture is rcutorture kernel module load/unload test.
> > > test-url: https://www.kernel.org/doc/Documentation/RCU/torture.txt
> > > 
> > > 
> > > on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > > 
> > > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > > 
> > > 
> > > If you fix the issue, kindly add following tag
> > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > Link: https://lore.kernel.org/oe-lkp/202212312021.bc1efe86-oliver.sang@intel.com
> > 
> > <snip>
> > 
> > > 
> > > To reproduce:
> > > 
> > >         # build kernel
> > > 	cd linux
> > > 	cp config-6.1.0-rc2-00014-g0af8489b0216 .config
> > > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
> > > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
> > > 	cd <mod-install-dir>
> > > 	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> > > 
> > > 
> > >         git clone https://github.com/intel/lkp-tests.git
> > >         cd lkp-tests
> > >         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
> > > 
> > >         # if come across any failure that blocks the test,
> > >         # please remove ~/.lkp and /lkp dir to run from a clean state.
> > 
> > I was unable to reproduce in the same way as described above
> > because some files referenced in job-script couldn't be downloaded from
> > download.01.org/0day :(
> > 
> > So I just built rcutorture module as builtin
> > and I got weird spinlock bug on commit: 0af8489b0216
> > ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")
> 
> (+Cc KVM/Paravirt experts)
> 
> > full dmesg added as attachment
> > 
> > [ 1387.564837][   T57] BUG: unable to handle page fault for address: c108f5f4
> > [ 1387.566649][   T57] #PF: supervisor write access in kernel mode
> > [ 1387.567965][   T57] #PF: error_code(0x0003) - permissions violation
> > [ 1387.569439][   T57] *pde = 010001e1 
> > [ 1387.570276][   T57] Oops: 0003 [#1] SMP
> > [ 1387.571149][   T57] CPU: 2 PID: 57 Comm: rcu_torture_rea Tainted: G S                 6.1.0-rc2-00010-g0af8489b0216 #2130 63d19ac2b985fca570c354d8750f489755de37ed
> > [ 1387.574673][   T57] EIP: kvm_kick_cpu+0x54/0x90
> > [ 1387.575802][   T57] Code: 2f c5 01 8b 04 9d e0 d4 4e c4 83 15 14 7b 2f c5 00 83 05 08 6d 2f c5 01 0f b7 0c 30 b8 05 00 00 00 83 15 0c 6d 2f c5 00 31 db <0f> 01 c1 83 05 10 6d 2f c5 01 8b 5d f8 8b 75 fc 83 15 14 6d 2f c5

																				^^^^^^
Yes this is the unfamous hypercall patching bug....

> > 

So what is happening is that Intel and AMD has a *slightly* different instruction reserved for hypercalls
(paravirt calls from guest to host hypervisor).

KVM developers made a mistake to be 'nice' to the guests and if the guest uses the wrong hypercall instruction
the KVM attempts to rewrite it with the right instruction.

That can fail, because to avoid security issues, KVM uses the exact same security context as the instruction itself
(it is as if the instruction was defined such as it overwrote itself)
This means that is the guest memory is marked read-only in the guest paging, then the write will fail and #PF
will happen on the wrong hypercall instruction.

Here we have the Intel's instruction (VMCALL, 0f 01 C1), and the host machine is likely AMD which uses VMMCALL instruction
which is (0F 01 D9)


Now any recent Linux guest is supposed to use a right instruction using the alternatives mechanism, but it can if
the hypervisor passes 'non native' vendor id, like GenunineIntel on AMD machine.

In my testing using named CPU models like you do '-cpu SandyBridge' still passes through host vendor ID (that is the guest
will see Intel's cpu but with vendor='AutheticAMD') but nobody confirmed me that this is a bug or a feature and I am not
sure if older qemu versions also did this.


Assuming that your host machine is AMD,
your best bet to check if my theory is right is to boot the guest without triggering the bug, 
and check in /proc/cpuinfo if the vendor string is 'GenuineIntel'


Best regards,
	Maxim Levitsky


[ 1387.580456][   T57] EAX: 00000005 EBX: 00000000 ECX: 00000003 EDX: c108f5a0
> > [ 1387.582071][   T57] ESI: c5153580 EDI: 00000046 EBP: c69cddf8 ESP: c69cddf0
> > [ 1387.583775][   T57] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010046
> > [ 1387.585643][   T57] CR0: 80050033 CR2: c108f5f4 CR3: 0776b000 CR4: 00350e90
> > [ 1387.587492][   T57] Call Trace:
> > [ 1387.588365][   T57]  __pv_queued_spin_unlock_slowpath+0x66/0x110
> > [ 1387.589898][   T57]  __pv_queued_spin_unlock+0x4b/0x60
> > [ 1387.591040][   T57]  __raw_callee_save___pv_queued_spin_unlock+0x9/0x10
> > [ 1387.592771][   T57]  do_raw_spin_unlock+0x49/0xa0
> > [ 1387.593805][   T57]  _raw_spin_unlock_irqrestore+0x53/0xd0
> > [ 1387.594927][   T57]  swake_up_one+0x4f/0x70
> > [ 1387.595739][   T57]  __rcu_report_exp_rnp+0x26b/0x470
> > [ 1387.596730][   T57]  rcu_report_exp_cpu_mult+0x82/0x2f0
> > [ 1387.597770][   T57]  rcu_qs+0xac/0x160
> > [ 1387.598503][   T57]  rcu_note_context_switch+0x31/0x1e0
> > [ 1387.599460][   T57]  __schedule+0xc5/0x770
> > [ 1387.600195][   T57]  __cond_resched+0x7a/0x100
> > [ 1387.600996][   T57]  stutter_wait+0x9e/0x2c0
> > [ 1387.601956][   T57]  rcu_torture_reader+0x162/0x3e0
> > [ 1387.603048][   T57]  ? rcu_torture_reader+0x3e0/0x3e0
> > [ 1387.604269][   T57]  ? __kthread_parkme+0xab/0xf0
> > [ 1387.605420][   T57]  kthread+0x167/0x1d0
> > [ 1387.606383][   T57]  ? rcu_torture_read_exit_child+0xa0/0xa0
> > [ 1387.607516][   T57]  ? kthread_exit+0x50/0x50
> > [ 1387.608517][   T57]  ret_from_fork+0x19/0x24
> > [ 1387.609548][   T57] Modules linked in:
> > [ 1387.610187][   T57] CR2: 00000000c108f5f4
> > [ 1387.610873][   T57] ---[ end trace 0000000000000000 ]---
> > [ 1387.611829][   T57] EIP: kvm_kick_cpu+0x54/0x90
> > [ 1387.612653][   T57] Code: 2f c5 01 8b 04 9d e0 d4 4e c4 83 15 14 7b 2f c5 00 83 05 08 6d 2f c5 01 0f b7 0c 30 b8 05 00 00 00 83 15 0c 6d 2f c5 00 31 db <0f> 01 c1 83 05 10 6d 2f c5 01 8b 5d f8 8b 75 fc 83 15 14 6d 2f c5
> > [ 1387.616715][   T57] EAX: 00000005 EBX: 00000000 ECX: 00000003 EDX: c108f5a0
> > [ 1387.618242][   T57] ESI: c5153580 EDI: 00000046 EBP: c69cddf8 ESP: c69cddf0
> > [ 1387.619912][   T57] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010046
> > [ 1387.621666][   T57] CR0: 80050033 CR2: c108f5f4 CR3: 0776b000 CR4: 00350e90
> > [ 1387.623128][   T57] Kernel panic - not syncing: Fatal exception
> > [ 1389.285045][   T57] Shutting down cpus with NMI
> > [ 1389.297949][   T57] Kernel Offset: disabled
> > [ 1389.299174][   T57] ---[ end Kernel panic - not syncing: Fatal exception ]---


