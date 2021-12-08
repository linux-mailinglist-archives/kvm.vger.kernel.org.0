Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964AD46DF07
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 00:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbhLHXin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 18:38:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233080AbhLHXim (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 18:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639006509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QCIRswZfzawSxZHbNlAOKKNkmydvwBq+fvNbXg86K+U=;
        b=NYwkozXYjHg9yaM5xa7hEpvIOeLhmCcu7ueQuq+xSq35MvECO7fWrbT97I9BqHE5K+txlC
        Rphb94xp06HEj1jWVlS+hAo66Tw0+IcYFV1S1RxAqv34xLLOm0Vhhq8O2by6N+rnthbbrs
        +AGD1xVQwlEmu3OHyFODpOYwRM86mcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-WGv3cWcWM_KSTUfatYcPsA-1; Wed, 08 Dec 2021 18:35:06 -0500
X-MC-Unique: WGv3cWcWM_KSTUfatYcPsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5022C1023F4D;
        Wed,  8 Dec 2021 23:35:05 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE5F85D6CF;
        Wed,  8 Dec 2021 23:34:37 +0000 (UTC)
Message-ID: <6f0dc26c78c151814317d95d4918ffddabdd2df1.camel@redhat.com>
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 01:34:36 +0200
In-Reply-To: <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
         <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
         <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 01:16 +0200, Maxim Levitsky wrote:
> On Thu, 2021-12-09 at 01:00 +0200, Maxim Levitsky wrote:
> > On Wed, 2021-12-08 at 01:52 +0000, Sean Christopherson wrote:
> > > Overhaul and cleanup APIC virtualization (Posted Interrupts on Intel VMX,
> > > AVIC on AMD SVM) to streamline things as much as possible, remove a bunch
> > > of cruft, and document the lurking gotchas along the way.
> > > 
> > > Patch 01 is a fix from Paolo that's already been merged but hasn't made
> > > its way to kvm/queue.  It's included here to avoid a number of conflicts.
> > > 
> > > Based on kvm/queue, commit 1cf84614b04a ("KVM: x86: Exit to ...")
> > > 
> > > v3:
> > >  - Rebase to kvm/queue (and drop non-x86 patches as they've been queued). 
> > >  - Redo AVIC patches, sadly the vcpu_(un)blocking() hooks need to stay.
> > >  - Add a patch to fix a missing (docuentation-only) barrier in nested
> > >    posted interrupt delivery. [Paolo]
> > >  - Collect reviews.
> > > 
> > > v2:
> > >  - https://lore.kernel.org/all/20211009021236.4122790-1-seanjc@google.com/
> > >  - Collect reviews. [Christian, David]
> > >  - Add patch to move arm64 WFI functionality out of hooks. [Marc]
> > >  - Add RISC-V to the fun.
> > >  - Add all the APICv fun.
> > > 
> > > v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com
> > > 
> > > Paolo Bonzini (1):
> > >   KVM: fix avic_set_running for preemptable kernels
> > > 
> > > Sean Christopherson (25):
> > >   KVM: nVMX: Ensure vCPU honors event request if posting nested IRQ
> > >     fails
> > >   KVM: VMX: Clean up PI pre/post-block WARNs
> > >   KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
> > >   KVM: Drop unused kvm_vcpu.pre_pcpu field
> > >   KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
> > >   KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
> > >   KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
> > >   KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
> > >   KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
> > >   KVM: SVM: Don't bother checking for "running" AVIC when kicking for
> > >     IPIs
> > >   KVM: SVM: Remove unnecessary APICv/AVIC update in vCPU unblocking path
> > >   KVM: SVM: Use kvm_vcpu_is_blocking() in AVIC load to handle preemption
> > >   KVM: SVM: Skip AVIC and IRTE updates when loading blocking vCPU
> > >   iommu/amd: KVM: SVM: Use pCPU to infer IsRun state for IRTE
> > >   KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
> > >   KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
> > >     vCPU
> > >   KVM: VMX: Pass desired vector instead of bool for triggering posted
> > >     IRQ
> > >   KVM: VMX: Fold fallback path into triggering posted IRQ helper
> > >   KVM: VMX: Don't do full kick when handling posted interrupt wakeup
> > >   KVM: SVM: Drop AVIC's intermediate avic_set_running() helper
> > >   KVM: SVM: Move svm_hardware_setup() and its helpers below svm_x86_ops
> > >   KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled
> > >   KVM: x86: Skip APICv update if APICv is disable at the module level
> > >   KVM: x86: Drop NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
> > >   KVM: x86: Unexport __kvm_request_apicv_update()
> > > 
> > >  arch/x86/include/asm/kvm-x86-ops.h |   2 -
> > >  arch/x86/include/asm/kvm_host.h    |  12 -
> > >  arch/x86/kvm/hyperv.c              |   3 +
> > >  arch/x86/kvm/lapic.c               |   2 -
> > >  arch/x86/kvm/svm/avic.c            | 116 ++++---
> > >  arch/x86/kvm/svm/svm.c             | 479 ++++++++++++++---------------
> > >  arch/x86/kvm/svm/svm.h             |  16 +-
> > >  arch/x86/kvm/vmx/posted_intr.c     | 234 +++++++-------
> > >  arch/x86/kvm/vmx/posted_intr.h     |   8 +-
> > >  arch/x86/kvm/vmx/vmx.c             |  66 ++--
> > >  arch/x86/kvm/vmx/vmx.h             |   3 +
> > >  arch/x86/kvm/x86.c                 |  41 ++-
> > >  drivers/iommu/amd/iommu.c          |   6 +-
> > >  include/linux/amd-iommu.h          |   6 +-
> > >  include/linux/kvm_host.h           |   3 -
> > >  virt/kvm/kvm_main.c                |   3 -
> > >  16 files changed, 510 insertions(+), 490 deletions(-)
> > > 
> > 
> > Probably just luck (can't reproduce this anymore) but
> > while running some kvm unit tests with this patch series (and few my patches
> > for AVIC co-existance which shouldn't affect this) I got this
> > 
> > (warning about is_running already set)
> > 
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
> 
> Also got this while trying a VM with passed through device:
> 
> [mlevitsk@amdlaptop ~]$[   34.926140] usb 5-3: reset full-speed USB device number 3 using xhci_hcd
> [   42.583661] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
> [  363.562173] VFIO - User Level meta-driver version: 0.3
> [  365.160357] vfio-pci 0000:03:00.0: vfio_ecap_init: hiding ecap 0x1e@0x154
> [  384.138110] BUG: kernel NULL pointer dereference, address: 0000000000000021
> [  384.154039] #PF: supervisor read access in kernel mode
> [  384.165645] #PF: error_code(0x0000) - not-present page
> [  384.177254] PGD 16da9d067 P4D 16da9d067 PUD 13ad1a067 PMD 0 
> [  384.190036] Oops: 0000 [#1] SMP
> [  384.197117] CPU: 3 PID: 14403 Comm: CPU 3/KVM Tainted: G           O      5.16.0-rc4.unstable #6
> [  384.216978] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
> [  384.235258] RIP: 0010:amd_iommu_update_ga+0x32/0x160
> [  384.246469] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 83 3d 04 75 2a 01 02 0f 85 bd 00 00 00 <4c> 8b 62 20 48 8b 4a 18 4d 85 e4 0f 84 ca 00 00 00
> 48 85 c9 0f 84
> [  384.288932] RSP: 0018:ffffc9000036fca0 EFLAGS: 00010046
> [  384.300727] RAX: 0000000000000000 RBX: ffff88810b68ab60 RCX: ffff8881667a6018
> [  384.316850] RDX: 0000000000000001 RSI: ffff888107476b00 RDI: 0000000000000003
> [  384.332973] RBP: ffffc9000036fcf0 R08: 0000000000000010 R09: 0000000000000010
> [  384.349096] R10: 0000000000000bb8 R11: ffffffff82a0fe80 R12: 0000000000000003
> [  384.365219] R13: ffff88836b98ea68 R14: 0000000000000202 R15: ffff88836b98ea78
> [  384.381338] FS:  00007f18d9ffb640(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
> [  384.399622] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  384.412597] CR2: 0000000000000021 CR3: 00000001617c3000 CR4: 0000000000350ee0
> [  384.428717] Call Trace:
> [  384.434224]  <TASK>
> [  384.438951]  ? svm_set_msr+0x349/0x740 [kvm_amd]
> [  384.449374]  avic_vcpu_load+0xbc/0x100 [kvm_amd]
> [  384.459795]  svm_vcpu_unblocking+0x2d/0x40 [kvm_amd]
> [  384.471011]  kvm_vcpu_block+0x71/0x90 [kvm]
> [  384.480479]  kvm_vcpu_halt+0x3b/0x390 [kvm]
> [  384.489950]  kvm_arch_vcpu_ioctl_run+0xa81/0x17f0 [kvm]
> [  384.501781]  kvm_vcpu_ioctl+0x284/0x6c0 [kvm]
> [  384.511640]  ? vfio_pci_rw+0x6b/0xa0 [vfio_pci_core]
> [  384.522856]  ? vfio_pci_core_write+0x1c/0x20 [vfio_pci_core]
> [  384.535642]  ? vfio_device_fops_write+0x1f/0x30 [vfio]
> [  384.547243]  __x64_sys_ioctl+0x8e/0xc0
> [  384.555701]  do_syscall_64+0x35/0x80
> [  384.563765]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  384.575170] RIP: 0033:0x7f18f4c4b39b
> [  384.583241] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d 2a 0f 00 f7
> d8 64 89 01 48
> [  384.625709] RSP: 002b:00007f18d9ff95c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [  384.639715] [drm] Fence fallback timer expired on ring gfx
> [  384.642816] RAX: ffffffffffffffda RBX: 00000000017aef60 RCX: 00007f18f4c4b39b
> [  384.642817] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000026
> [  384.687520] RBP: 00007f18d9ff96c0 R08: 0000000000daf570 R09: 000000000000ffff
> [  384.703646] R10: 0000070000000082 R11: 0000000000000246 R12: 00007f18d9ffb640
> [  384.719765] R13: 0000000000000000 R14: 00007f18f4bd1880 R15: 0000000000000000
> [  384.735896]  </TASK>
> [  384.740812] Modules linked in: vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio xt_conntrack ip6table_filter ip6_tables snd_ctl_led snd_hda_codec_realtek snd_hda_codec_generic
> snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg snd_usb_audio snd_acp3x_pdm_dma snd_soc_dmic snd_acp3x_rn tps6598x snd_hda_codec snd_usbmidi_lib kvm_amd(O) btusb iwlmvm regmap_i2c snd_hda_core btrtl
> snd_soc_core wmi_bmof snd_hwdep tpm_crb kvm(O) btbcm irqbypass snd_rawmidi ftdi_sio btintel pcspkr psmouse snd_rn_pci_acp3x bfq k10temp i2c_piix4 thinkpad_acpi snd_pcm i2c_multi_instantiate iwlwifi
> tpm_tis tpm_tis_core wmi platform_profile rtc_cmos i2c_designware_platform i2c_designware_core vendor_reset(O) dm_crypt hid_generic usbhid mmc_block amdgpu drm_ttm_helper ttm gpu_sched i2c_algo_bit
> drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea xhci_pci nvme rtsx_pci_sdmmc ucsi_acpi typec_ucsi mmc_core atkbd ccp rtsx_pci libps2 drm nvme_core
> mfd_core sp5100_tco
> [  384.740851]  rng_core xhci_hcd drm_panel_orientation_quirks t10_pi typec i8042 pinctrl_amd r8169 realtek 8250_pci usbmon nbd fuse autofs4
> [  384.965149] CR2: 0000000000000021
> [  384.972622] ---[ end trace 23949f0862c2ac65 ]---
> [  384.983042] RIP: 0010:amd_iommu_update_ga+0x32/0x160
> [  384.994255] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 83 3d 04 75 2a 01 02 0f 85 bd 00 00 00 <4c> 8b 62 20 48 8b 4a 18 4d 85 e4 0f 84 ca 00 00 00
> 48 85 c9 0f 84
> [  385.036720] RSP: 0018:ffffc9000036fca0 EFLAGS: 00010046
> [  385.048518] RAX: 0000000000000000 RBX: ffff88810b68ab60 RCX: ffff8881667a6018
> [  385.064646] RDX: 0000000000000001 RSI: ffff888107476b00 RDI: 0000000000000003
> [  385.080765] RBP: ffffc9000036fcf0 R08: 0000000000000010 R09: 0000000000000010
> [  385.096886] R10: 0000000000000bb8 R11: ffffffff82a0fe80 R12: 0000000000000003
> [  385.113004] R13: ffff88836b98ea68 R14: 0000000000000202 R15: ffff88836b98ea78
> [  385.129128] FS:  00007f18d9ffb640(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
> [  385.147407] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  385.160385] CR2: 0000000000000021 CR3: 00000001617c3000 CR4: 0000000000350ee0
> [  385.172739] [drm] Fence fallback timer expired on ring sdma0
> 
> Oh, well tomorrow I'll see what I can do with  these.

Host crash while running 32 bit VM and another 32 bit VM nested in it:


[  751.182290] BUG: kernel NULL pointer dereference, address: 0000000000000025
[  751.198234] #PF: supervisor read access in kernel mode
[  751.209982] #PF: error_code(0x0000) - not-present page
[  751.221733] PGD 3720f9067 P4D 3720f9067 PUD 3720f8067 PMD 0 
[  751.234682] Oops: 0000 [#1] SMP
[  751.241857] CPU: 8 PID: 54050 Comm: CPU 8/KVM Tainted: G           O      5.16.0-rc4.unstable #6
[  751.261960] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
[  751.280475] RIP: 0010:is_page_fault_stale.isra.0+0x2a/0xa0 [kvm]
[  751.294246] Code: 0f 1f 44 00 00 55 48 8b 46 38 41 b8 01 00 00 00 48 be 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06 48 89 e5 48 8b 44 30 28 <f6> 40 25 08 75 25 80 78 20 00 74 24 48 83 7a 20 00
74 31 48 83 bf
[  751.337236] RSP: 0018:ffffc900020afa90 EFLAGS: 00010216
[  751.349186] RAX: 0000000000000000 RBX: ffffc900020afc88 RCX: 00000000000000a9
[  751.365517] RDX: ffffc900020afc88 RSI: ffffea0000000000 RDI: ffffc90001fe9000
[  751.381851] RBP: ffffc900020afa90 R08: 0000000000000001 R09: ffffc900020afcb8
[  751.398173] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000000a9
[  751.414496] R13: ffffc90001fe9000 R14: ffff888176048000 R15: 0000000000000000
[  751.430820] FS:  00007fd5f1dfb640(0000) GS:ffff8883ff800000(0000) knlGS:0000000000000000
[  751.449349] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  751.462484] CR2: 0000000000000025 CR3: 00000003720fc000 CR4: 0000000000350ee0
[  751.478800] Call Trace:
[  751.484381]  <TASK>
[  751.489165]  paging64_page_fault+0x20d/0x990 [kvm]
[  751.500141]  ? emulator_read_write+0xda/0x1a0 [kvm]
[  751.511320]  ? linearize.isra.0+0x82/0x280 [kvm]
[  751.521898]  ? emulator_write_emulated+0x15/0x20 [kvm]
[  751.533673]  ? segmented_write.isra.0+0x5b/0x80 [kvm]
[  751.545249]  ? kvm_mmu_free_roots+0x80/0x170 [kvm]
[  751.556225]  kvm_mmu_page_fault+0x108/0x7f0 [kvm]
[  751.567002]  ? kvm_vcpu_read_guest+0xb8/0x120 [kvm]
[  751.578176]  ? kvm_mmu_get_page+0x253/0x5d0 [kvm]
[  751.588951]  ? kvm_mmu_sync_roots+0x188/0x1d0 [kvm]
[  751.600134]  npf_interception+0x47/0xa0 [kvm_amd]
[  751.610886]  svm_invoke_exit_handler+0x9d/0xe0 [kvm_amd]
[  751.623034]  handle_exit+0xb8/0x210 [kvm_amd]
[  751.632993]  kvm_arch_vcpu_ioctl_run+0xdac/0x17f0 [kvm]
[  751.644970]  ? kvm_vm_ioctl_irq_line+0x27/0x40 [kvm]
[  751.656344]  ? _copy_to_user+0x20/0x30
[  751.664914]  ? kvm_vm_ioctl+0x279/0xdb0 [kvm]
[  751.674894]  kvm_vcpu_ioctl+0x284/0x6c0 [kvm]
[  751.684876]  __x64_sys_ioctl+0x8e/0xc0
[  751.693444]  do_syscall_64+0x35/0x80
[  751.701617]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  751.713171] RIP: 0033:0x7fd7d47c839b
[  751.721347] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d 2a 0f 00 f7
d8 64 89 01 48
[  751.764347] RSP: 002b:00007fd5f1df95c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  751.781674] RAX: ffffffffffffffda RBX: 0000000003002350 RCX: 00007fd7d47c839b
[  751.798000] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000002a
[  751.814326] RBP: 00007fd5f1df96c0 R08: 0000000000daf570 R09: 00000000000000ff
[  751.830648] R10: 000000000082a1bb R11: 0000000000000246 R12: 00007fd5f1dfb640
[  751.846977] R13: 0000000000000000 R14: 00007fd7d474e880 R15: 0000000000000000
[  751.863310]  </TASK>
[  751.868292] Modules linked in: tun xt_conntrack ip6table_filter ip6_tables snd_ctl_led snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg snd_usb_audio
snd_usbmidi_lib snd_hda_codec btusb kvm_amd(O) snd_acp3x_pdm_dma snd_soc_dmic snd_acp3x_rn iwlmvm btrtl tps6598x snd_hwdep btbcm regmap_i2c snd_soc_core wmi_bmof kvm(O) snd_hda_core irqbypass pcspkr
psmouse ftdi_sio tpm_crb k10temp snd_rawmidi btintel i2c_multi_instantiate i2c_piix4 snd_rn_pci_acp3x iwlwifi bfq snd_pcm tpm_tis thinkpad_acpi tpm_tis_core wmi platform_profile rtc_cmos
i2c_designware_platform i2c_designware_core vendor_reset(O) dm_crypt hid_generic usbhid mmc_block amdgpu drm_ttm_helper ttm gpu_sched i2c_algo_bit drm_kms_helper cfbfillrect syscopyarea cfbimgblt
sysfillrect rtsx_pci_sdmmc sysimgblt fb_sys_fops cfbcopyarea mmc_core xhci_pci ccp atkbd rtsx_pci nvme libps2 drm ucsi_acpi rng_core mfd_core xhci_hcd drm_panel_orientation_quirks sp5100_tco
typec_ucsi nvme_core typec t10_pi
[  751.868330]  i8042 pinctrl_amd r8169 realtek 8250_pci usbmon nbd fuse autofs4
[  752.084873] CR2: 0000000000000025
[  752.092439] ---[ end trace cf646c318ffb08e5 ]---
[  752.102994] RIP: 0010:is_page_fault_stale.isra.0+0x2a/0xa0 [kvm]
[  752.116760] Code: 0f 1f 44 00 00 55 48 8b 46 38 41 b8 01 00 00 00 48 be 00 00 00 00 00 ea ff ff 48 c1 e8 0c 48 c1 e0 06 48 89 e5 48 8b 44 30 28 <f6> 40 25 08 75 25 80 78 20 00 74 24 48 83 7a 20 00
74 31 48 83 bf
[  752.159774] RSP: 0018:ffffc900020afa90 EFLAGS: 00010216
[  752.171722] RAX: 0000000000000000 RBX: ffffc900020afc88 RCX: 00000000000000a9
[  752.188053] RDX: ffffc900020afc88 RSI: ffffea0000000000 RDI: ffffc90001fe9000
[  752.204382] RBP: ffffc900020afa90 R08: 0000000000000001 R09: ffffc900020afcb8
[  752.2

Oh well, not related to the patch series but just that I don't forget.
I need to do some throughfull testing on all the VMs I use.

Best regards,
	Maxim Levitsky


> 
> Best regards,
> 	Maxim Levitsky
> > I'll post my patches tomorrow, after some more testing.
> > 
> > Best regards,
> > 	Maxim Levitsky


