Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBF046E295
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 07:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhLIGib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 01:38:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhLIGib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 01:38:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639031697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAU6XM/5sfb4CFHRfz4saGiWORFSzRN4hzYWrV4v2/8=;
        b=C04ZD18bsyo/B+CTY24I336T+xRcDjWIQ+gARR6S9sRP/tT97gBFpoQ7nXxxVyV7chvvk8
        FMwJxFkDrZUi3+SIkjSZ4b3ebE9H2MoJClqFX2s4Z/i/x1dvhJERxpAOgixIHLawv9xw72
        vE0JCG+s6azDx6ytYI5bBkfqxJZfP+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-feJooAldO5mMHl8upYj3QQ-1; Thu, 09 Dec 2021 01:34:52 -0500
X-MC-Unique: feJooAldO5mMHl8upYj3QQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F14E5802928;
        Thu,  9 Dec 2021 06:34:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0667E19C59;
        Thu,  9 Dec 2021 06:34:47 +0000 (UTC)
Message-ID: <9672bb87b3090bc5534c4255315f62441ff04af7.camel@redhat.com>
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 08:34:46 +0200
In-Reply-To: <YbFDMjUdVltTSeHr@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
         <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
         <YbFDMjUdVltTSeHr@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-08 at 23:43 +0000, Sean Christopherson wrote:
> On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> > >   KVM: SVM: Remove unnecessary APICv/AVIC update in vCPU unblocking path
> 
> ...
> 
> > Probably just luck (can't reproduce this anymore) but
> > while running some kvm unit tests with this patch series (and few my patches
> > for AVIC co-existance which shouldn't affect this) I got this
> > 
> > (warning about is_running already set)
> 
> My best guess would be the above commit that dropped the handling in the unblock
> path, but I haven't been able to concoct a scenario where avic_physical_id_cache
> can get out of sync with respect to kvm_vcpu_apicv_active().

Same here. It seems like the unit test is beeing killed by a timeout signal, I tried
to reproduce that this way but no luck so far.

Best regards,
	Maxim Levitsky

> 
> > Dec 08 22:53:26 amdlaptop kernel: ------------[ cut here ]------------
> > Dec 08 22:53:26 amdlaptop kernel: WARNING: CPU: 3 PID: 72804 at arch/x86/kvm/svm/avic.c:1045 avic_vcpu_load+0xe3/0x100 [kvm_amd]
> > Dec 08 22:53:26 amdlaptop kernel: Modules linked in: kvm_amd(O) ccp rng_core kvm(O) irqbypass xt_conntrack ip6table_filter ip6_tables snd_soc_dmic snd_acp3x_>
> > Dec 08 22:53:26 amdlaptop kernel:  r8169 realtek 8250_pci usbmon nbd fuse autofs4 [last unloaded: rng_core]
> > Dec 08 22:53:26 amdlaptop kernel: CPU: 3 PID: 72804 Comm: qemu-system-i38 Tainted: G           O      5.16.0-rc4.unstable #6
> > Dec 08 22:53:26 amdlaptop kernel: Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
> > Dec 08 22:53:26 amdlaptop kernel: RIP: 0010:avic_vcpu_load+0xe3/0x100 [kvm_amd]
> > Dec 08 22:53:26 amdlaptop kernel: Code: 0d 9f e0 85 c0 74 e8 4c 89 f6 4c 89 ff e8 a5 99 f4 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 5b 41 5c 41 5d 41 5e 41 >
> > Dec 08 22:53:26 amdlaptop kernel: RSP: 0018:ffffc9000b17bba8 EFLAGS: 00010247
> > Dec 08 22:53:26 amdlaptop kernel: RAX: 6f63203a756d6571 RBX: ffff888106194740 RCX: ffff88812e7ac000
> > Dec 08 22:53:26 amdlaptop kernel: RDX: ffff8883ff6c0000 RSI: 0000000000000003 RDI: 0000000000000003
> > Dec 08 22:53:26 amdlaptop kernel: RBP: ffffc9000b17bbd0 R08: ffff888106194740 R09: 0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
> > Dec 08 22:53:26 amdlaptop kernel: R13: 0000000000000003 R14: ffff88810023b060 R15: dead000000000100
> > Dec 08 22:53:26 amdlaptop kernel: FS:  0000000000000000(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Dec 08 22:53:26 amdlaptop kernel: CR2: 00005587e812f958 CR3: 0000000105f31000 CR4: 0000000000350ee0
> > Dec 08 22:53:26 amdlaptop kernel: DR0: 00000000004008da DR1: 0000000000000000 DR2: 0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Dec 08 22:53:26 amdlaptop kernel: Call Trace:
> > Dec 08 22:53:26 amdlaptop kernel:  <TASK>
> > Dec 08 22:53:26 amdlaptop kernel:  svm_vcpu_load+0x56/0x60 [kvm_amd]
> > Dec 08 22:53:26 amdlaptop kernel:  kvm_arch_vcpu_load+0x32/0x210 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  vcpu_load+0x34/0x40 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  kvm_arch_destroy_vm+0xd4/0x1c0 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  kvm_destroy_vm+0x163/0x250 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  kvm_put_kvm+0x26/0x40 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  kvm_vm_release+0x22/0x30 [kvm]
> > Dec 08 22:53:26 amdlaptop kernel:  __fput+0x94/0x250
> > Dec 08 22:53:26 amdlaptop kernel:  ____fput+0xe/0x10
> > Dec 08 22:53:26 amdlaptop kernel:  task_work_run+0x63/0xa0
> > Dec 08 22:53:26 amdlaptop kernel:  do_exit+0x358/0xa30
> > Dec 08 22:53:26 amdlaptop kernel:  do_group_exit+0x3b/0xa0
> > Dec 08 22:53:26 amdlaptop kernel:  get_signal+0x15b/0x880
> > Dec 08 22:53:26 amdlaptop kernel:  ? _copy_to_user+0x20/0x30
> > Dec 08 22:53:26 amdlaptop kernel:  ? put_timespec64+0x3d/0x60
> > Dec 08 22:53:26 amdlaptop kernel:  arch_do_signal_or_restart+0x106/0x740
> > Dec 08 22:53:26 amdlaptop kernel:  ? hrtimer_nanosleep+0x9f/0x120
> > Dec 08 22:53:26 amdlaptop kernel:  ? __hrtimer_init+0xd0/0xd0
> > Dec 08 22:53:26 amdlaptop kernel:  exit_to_user_mode_prepare+0x112/0x1f0
> > Dec 08 22:53:26 amdlaptop kernel:  syscall_exit_to_user_mode+0x17/0x40
> > Dec 08 22:53:26 amdlaptop kernel:  do_syscall_64+0x42/0x80
> > Dec 08 22:53:26 amdlaptop kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > Dec 08 22:53:26 amdlaptop kernel: RIP: 0033:0x7f537abb13b5
> > Dec 08 22:53:26 amdlaptop kernel: Code: Unable to access opcode bytes at RIP 0x7f537abb138b.
> > Dec 08 22:53:26 amdlaptop kernel: RSP: 002b:00007f5376a39680 EFLAGS: 00000293 ORIG_RAX: 00000000000000e6
> > Dec 08 22:53:26 amdlaptop kernel: RAX: fffffffffffffdfc RBX: 00007f5376a396d0 RCX: 00007f537abb13b5
> > Dec 08 22:53:26 amdlaptop kernel: RDX: 00007f5376a396d0 RSI: 0000000000000000 RDI: 0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel: RBP: 00007f5376a396c0 R08: 0000000000000000 R09: 0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel: R10: 00007f5376a396c0 R11: 0000000000000293 R12: 00007f5376a3b640
> > Dec 08 22:53:26 amdlaptop kernel: R13: 0000000000000002 R14: 00007f537ab66880 R15: 0000000000000000
> > Dec 08 22:53:26 amdlaptop kernel:  </TASK>
> > Dec 08 22:53:26 amdlaptop kernel: ---[ end trace 676058aaf29d0267 ]---
> > 
> > 
> > I'll post my patches tomorrow, after some more testing.
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 


