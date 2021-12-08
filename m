Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3046DEF2
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 00:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbhLHXUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 18:20:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237936AbhLHXUM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 18:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639005399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWx2WQTbqyvchP5pfzRDJiOTf6rHPwBLTZr865Av86M=;
        b=KjNPSFths+D41tTxqSgcE7Uli+d6Yv56QrofguskqadfqUM4eHsnImW+tnezFHSLfTJ7EF
        T8n3gMFA9bkwzDpYQjwFqPJHuQ08fkCb0OlJahdxGXkp4E4n7w8+xjScCBxolbHNZPkeHa
        1KXcbtfnehzMzKqr5LX2bBKXVky3ELw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-glJL0ZgaN7OHWEdBDgBxeQ-1; Wed, 08 Dec 2021 18:16:36 -0500
X-MC-Unique: glJL0ZgaN7OHWEdBDgBxeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FA611006ABF;
        Wed,  8 Dec 2021 23:16:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1686060657;
        Wed,  8 Dec 2021 23:16:30 +0000 (UTC)
Message-ID: <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
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
Date:   Thu, 09 Dec 2021 01:16:29 +0200
In-Reply-To: <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
References: <20211208015236.1616697-1-seanjc@google.com>
         <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 01:00 +0200, Maxim Levitsky wrote:
> On Wed, 2021-12-08 at 01:52 +0000, Sean Christopherson wrote:
> > Overhaul and cleanup APIC virtualization (Posted Interrupts on Intel VMX,
> > AVIC on AMD SVM) to streamline things as much as possible, remove a bunch
> > of cruft, and document the lurking gotchas along the way.
> > 
> > Patch 01 is a fix from Paolo that's already been merged but hasn't made
> > its way to kvm/queue.  It's included here to avoid a number of conflicts.
> > 
> > Based on kvm/queue, commit 1cf84614b04a ("KVM: x86: Exit to ...")
> > 
> > v3:
> >  - Rebase to kvm/queue (and drop non-x86 patches as they've been queued). 
> >  - Redo AVIC patches, sadly the vcpu_(un)blocking() hooks need to stay.
> >  - Add a patch to fix a missing (docuentation-only) barrier in nested
> >    posted interrupt delivery. [Paolo]
> >  - Collect reviews.
> > 
> > v2:
> >  - https://lore.kernel.org/all/20211009021236.4122790-1-seanjc@google.com/
> >  - Collect reviews. [Christian, David]
> >  - Add patch to move arm64 WFI functionality out of hooks. [Marc]
> >  - Add RISC-V to the fun.
> >  - Add all the APICv fun.
> > 
> > v1: https://lkml.kernel.org/r/20210925005528.1145584-1-seanjc@google.com
> > 
> > Paolo Bonzini (1):
> >   KVM: fix avic_set_running for preemptable kernels
> > 
> > Sean Christopherson (25):
> >   KVM: nVMX: Ensure vCPU honors event request if posting nested IRQ
> >     fails
> >   KVM: VMX: Clean up PI pre/post-block WARNs
> >   KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
> >   KVM: Drop unused kvm_vcpu.pre_pcpu field
> >   KVM: Move x86 VMX's posted interrupt list_head to vcpu_vmx
> >   KVM: VMX: Move preemption timer <=> hrtimer dance to common x86
> >   KVM: x86: Unexport LAPIC's switch_to_{hv,sw}_timer() helpers
> >   KVM: x86: Remove defunct pre_block/post_block kvm_x86_ops hooks
> >   KVM: SVM: Signal AVIC doorbell iff vCPU is in guest mode
> >   KVM: SVM: Don't bother checking for "running" AVIC when kicking for
> >     IPIs
> >   KVM: SVM: Remove unnecessary APICv/AVIC update in vCPU unblocking path
> >   KVM: SVM: Use kvm_vcpu_is_blocking() in AVIC load to handle preemption
> >   KVM: SVM: Skip AVIC and IRTE updates when loading blocking vCPU
> >   iommu/amd: KVM: SVM: Use pCPU to infer IsRun state for IRTE
> >   KVM: VMX: Don't do full kick when triggering posted interrupt "fails"
> >   KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this
> >     vCPU
> >   KVM: VMX: Pass desired vector instead of bool for triggering posted
> >     IRQ
> >   KVM: VMX: Fold fallback path into triggering posted IRQ helper
> >   KVM: VMX: Don't do full kick when handling posted interrupt wakeup
> >   KVM: SVM: Drop AVIC's intermediate avic_set_running() helper
> >   KVM: SVM: Move svm_hardware_setup() and its helpers below svm_x86_ops
> >   KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled
> >   KVM: x86: Skip APICv update if APICv is disable at the module level
> >   KVM: x86: Drop NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
> >   KVM: x86: Unexport __kvm_request_apicv_update()
> > 
> >  arch/x86/include/asm/kvm-x86-ops.h |   2 -
> >  arch/x86/include/asm/kvm_host.h    |  12 -
> >  arch/x86/kvm/hyperv.c              |   3 +
> >  arch/x86/kvm/lapic.c               |   2 -
> >  arch/x86/kvm/svm/avic.c            | 116 ++++---
> >  arch/x86/kvm/svm/svm.c             | 479 ++++++++++++++---------------
> >  arch/x86/kvm/svm/svm.h             |  16 +-
> >  arch/x86/kvm/vmx/posted_intr.c     | 234 +++++++-------
> >  arch/x86/kvm/vmx/posted_intr.h     |   8 +-
> >  arch/x86/kvm/vmx/vmx.c             |  66 ++--
> >  arch/x86/kvm/vmx/vmx.h             |   3 +
> >  arch/x86/kvm/x86.c                 |  41 ++-
> >  drivers/iommu/amd/iommu.c          |   6 +-
> >  include/linux/amd-iommu.h          |   6 +-
> >  include/linux/kvm_host.h           |   3 -
> >  virt/kvm/kvm_main.c                |   3 -
> >  16 files changed, 510 insertions(+), 490 deletions(-)
> > 
> 
> Probably just luck (can't reproduce this anymore) but
> while running some kvm unit tests with this patch series (and few my patches
> for AVIC co-existance which shouldn't affect this) I got this
> 
> (warning about is_running already set)
> 
> Dec 08 22:53:26 amdlaptop kernel: ------------[ cut here ]------------
> Dec 08 22:53:26 amdlaptop kernel: WARNING: CPU: 3 PID: 72804 at arch/x86/kvm/svm/avic.c:1045 avic_vcpu_load+0xe3/0x100 [kvm_amd]
> Dec 08 22:53:26 amdlaptop kernel: Modules linked in: kvm_amd(O) ccp rng_core kvm(O) irqbypass xt_conntrack ip6table_filter ip6_tables snd_soc_dmic snd_acp3x_>
> Dec 08 22:53:26 amdlaptop kernel:  r8169 realtek 8250_pci usbmon nbd fuse autofs4 [last unloaded: rng_core]
> Dec 08 22:53:26 amdlaptop kernel: CPU: 3 PID: 72804 Comm: qemu-system-i38 Tainted: G           O      5.16.0-rc4.unstable #6
> Dec 08 22:53:26 amdlaptop kernel: Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
> Dec 08 22:53:26 amdlaptop kernel: RIP: 0010:avic_vcpu_load+0xe3/0x100 [kvm_amd]
> Dec 08 22:53:26 amdlaptop kernel: Code: 0d 9f e0 85 c0 74 e8 4c 89 f6 4c 89 ff e8 a5 99 f4 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 5b 41 5c 41 5d 41 5e 41 >
> Dec 08 22:53:26 amdlaptop kernel: RSP: 0018:ffffc9000b17bba8 EFLAGS: 00010247
> Dec 08 22:53:26 amdlaptop kernel: RAX: 6f63203a756d6571 RBX: ffff888106194740 RCX: ffff88812e7ac000
> Dec 08 22:53:26 amdlaptop kernel: RDX: ffff8883ff6c0000 RSI: 0000000000000003 RDI: 0000000000000003
> Dec 08 22:53:26 amdlaptop kernel: RBP: ffffc9000b17bbd0 R08: ffff888106194740 R09: 0000000000000000
> Dec 08 22:53:26 amdlaptop kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
> Dec 08 22:53:26 amdlaptop kernel: R13: 0000000000000003 R14: ffff88810023b060 R15: dead000000000100
> Dec 08 22:53:26 amdlaptop kernel: FS:  0000000000000000(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
> Dec 08 22:53:26 amdlaptop kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Dec 08 22:53:26 amdlaptop kernel: CR2: 00005587e812f958 CR3: 0000000105f31000 CR4: 0000000000350ee0
> Dec 08 22:53:26 amdlaptop kernel: DR0: 00000000004008da DR1: 0000000000000000 DR2: 0000000000000000
> Dec 08 22:53:26 amdlaptop kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Dec 08 22:53:26 amdlaptop kernel: Call Trace:
> Dec 08 22:53:26 amdlaptop kernel:  <TASK>
> Dec 08 22:53:26 amdlaptop kernel:  svm_vcpu_load+0x56/0x60 [kvm_amd]
> Dec 08 22:53:26 amdlaptop kernel:  kvm_arch_vcpu_load+0x32/0x210 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  vcpu_load+0x34/0x40 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  kvm_arch_destroy_vm+0xd4/0x1c0 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  kvm_destroy_vm+0x163/0x250 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  kvm_put_kvm+0x26/0x40 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  kvm_vm_release+0x22/0x30 [kvm]
> Dec 08 22:53:26 amdlaptop kernel:  __fput+0x94/0x250
> Dec 08 22:53:26 amdlaptop kernel:  ____fput+0xe/0x10
> Dec 08 22:53:26 amdlaptop kernel:  task_work_run+0x63/0xa0
> Dec 08 22:53:26 amdlaptop kernel:  do_exit+0x358/0xa30
> Dec 08 22:53:26 amdlaptop kernel:  do_group_exit+0x3b/0xa0
> Dec 08 22:53:26 amdlaptop kernel:  get_signal+0x15b/0x880
> Dec 08 22:53:26 amdlaptop kernel:  ? _copy_to_user+0x20/0x30
> Dec 08 22:53:26 amdlaptop kernel:  ? put_timespec64+0x3d/0x60
> Dec 08 22:53:26 amdlaptop kernel:  arch_do_signal_or_restart+0x106/0x740
> Dec 08 22:53:26 amdlaptop kernel:  ? hrtimer_nanosleep+0x9f/0x120
> Dec 08 22:53:26 amdlaptop kernel:  ? __hrtimer_init+0xd0/0xd0
> Dec 08 22:53:26 amdlaptop kernel:  exit_to_user_mode_prepare+0x112/0x1f0
> Dec 08 22:53:26 amdlaptop kernel:  syscall_exit_to_user_mode+0x17/0x40
> Dec 08 22:53:26 amdlaptop kernel:  do_syscall_64+0x42/0x80
> Dec 08 22:53:26 amdlaptop kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> Dec 08 22:53:26 amdlaptop kernel: RIP: 0033:0x7f537abb13b5
> Dec 08 22:53:26 amdlaptop kernel: Code: Unable to access opcode bytes at RIP 0x7f537abb138b.
> Dec 08 22:53:26 amdlaptop kernel: RSP: 002b:00007f5376a39680 EFLAGS: 00000293 ORIG_RAX: 00000000000000e6
> Dec 08 22:53:26 amdlaptop kernel: RAX: fffffffffffffdfc RBX: 00007f5376a396d0 RCX: 00007f537abb13b5
> Dec 08 22:53:26 amdlaptop kernel: RDX: 00007f5376a396d0 RSI: 0000000000000000 RDI: 0000000000000000
> Dec 08 22:53:26 amdlaptop kernel: RBP: 00007f5376a396c0 R08: 0000000000000000 R09: 0000000000000000
> Dec 08 22:53:26 amdlaptop kernel: R10: 00007f5376a396c0 R11: 0000000000000293 R12: 00007f5376a3b640
> Dec 08 22:53:26 amdlaptop kernel: R13: 0000000000000002 R14: 00007f537ab66880 R15: 0000000000000000
> Dec 08 22:53:26 amdlaptop kernel:  </TASK>
> Dec 08 22:53:26 amdlaptop kernel: ---[ end trace 676058aaf29d0267 ]---


Also got this while trying a VM with passed through device:

[mlevitsk@amdlaptop ~]$[   34.926140] usb 5-3: reset full-speed USB device number 3 using xhci_hcd
[   42.583661] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  363.562173] VFIO - User Level meta-driver version: 0.3
[  365.160357] vfio-pci 0000:03:00.0: vfio_ecap_init: hiding ecap 0x1e@0x154
[  384.138110] BUG: kernel NULL pointer dereference, address: 0000000000000021
[  384.154039] #PF: supervisor read access in kernel mode
[  384.165645] #PF: error_code(0x0000) - not-present page
[  384.177254] PGD 16da9d067 P4D 16da9d067 PUD 13ad1a067 PMD 0 
[  384.190036] Oops: 0000 [#1] SMP
[  384.197117] CPU: 3 PID: 14403 Comm: CPU 3/KVM Tainted: G           O      5.16.0-rc4.unstable #6
[  384.216978] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
[  384.235258] RIP: 0010:amd_iommu_update_ga+0x32/0x160
[  384.246469] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 83 3d 04 75 2a 01 02 0f 85 bd 00 00 00 <4c> 8b 62 20 48 8b 4a 18 4d 85 e4 0f 84 ca 00 00 00
48 85 c9 0f 84
[  384.288932] RSP: 0018:ffffc9000036fca0 EFLAGS: 00010046
[  384.300727] RAX: 0000000000000000 RBX: ffff88810b68ab60 RCX: ffff8881667a6018
[  384.316850] RDX: 0000000000000001 RSI: ffff888107476b00 RDI: 0000000000000003
[  384.332973] RBP: ffffc9000036fcf0 R08: 0000000000000010 R09: 0000000000000010
[  384.349096] R10: 0000000000000bb8 R11: ffffffff82a0fe80 R12: 0000000000000003
[  384.365219] R13: ffff88836b98ea68 R14: 0000000000000202 R15: ffff88836b98ea78
[  384.381338] FS:  00007f18d9ffb640(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
[  384.399622] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  384.412597] CR2: 0000000000000021 CR3: 00000001617c3000 CR4: 0000000000350ee0
[  384.428717] Call Trace:
[  384.434224]  <TASK>
[  384.438951]  ? svm_set_msr+0x349/0x740 [kvm_amd]
[  384.449374]  avic_vcpu_load+0xbc/0x100 [kvm_amd]
[  384.459795]  svm_vcpu_unblocking+0x2d/0x40 [kvm_amd]
[  384.471011]  kvm_vcpu_block+0x71/0x90 [kvm]
[  384.480479]  kvm_vcpu_halt+0x3b/0x390 [kvm]
[  384.489950]  kvm_arch_vcpu_ioctl_run+0xa81/0x17f0 [kvm]
[  384.501781]  kvm_vcpu_ioctl+0x284/0x6c0 [kvm]
[  384.511640]  ? vfio_pci_rw+0x6b/0xa0 [vfio_pci_core]
[  384.522856]  ? vfio_pci_core_write+0x1c/0x20 [vfio_pci_core]
[  384.535642]  ? vfio_device_fops_write+0x1f/0x30 [vfio]
[  384.547243]  __x64_sys_ioctl+0x8e/0xc0
[  384.555701]  do_syscall_64+0x35/0x80
[  384.563765]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  384.575170] RIP: 0033:0x7f18f4c4b39b
[  384.583241] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5d 2a 0f 00 f7
d8 64 89 01 48
[  384.625709] RSP: 002b:00007f18d9ff95c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  384.639715] [drm] Fence fallback timer expired on ring gfx
[  384.642816] RAX: ffffffffffffffda RBX: 00000000017aef60 RCX: 00007f18f4c4b39b
[  384.642817] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000026
[  384.687520] RBP: 00007f18d9ff96c0 R08: 0000000000daf570 R09: 000000000000ffff
[  384.703646] R10: 0000070000000082 R11: 0000000000000246 R12: 00007f18d9ffb640
[  384.719765] R13: 0000000000000000 R14: 00007f18f4bd1880 R15: 0000000000000000
[  384.735896]  </TASK>
[  384.740812] Modules linked in: vfio_pci vfio_pci_core vfio_virqfd vfio_iommu_type1 vfio xt_conntrack ip6table_filter ip6_tables snd_ctl_led snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_codec_hdmi snd_hda_intel snd_intel_dspcfg snd_usb_audio snd_acp3x_pdm_dma snd_soc_dmic snd_acp3x_rn tps6598x snd_hda_codec snd_usbmidi_lib kvm_amd(O) btusb iwlmvm regmap_i2c snd_hda_core btrtl
snd_soc_core wmi_bmof snd_hwdep tpm_crb kvm(O) btbcm irqbypass snd_rawmidi ftdi_sio btintel pcspkr psmouse snd_rn_pci_acp3x bfq k10temp i2c_piix4 thinkpad_acpi snd_pcm i2c_multi_instantiate iwlwifi
tpm_tis tpm_tis_core wmi platform_profile rtc_cmos i2c_designware_platform i2c_designware_core vendor_reset(O) dm_crypt hid_generic usbhid mmc_block amdgpu drm_ttm_helper ttm gpu_sched i2c_algo_bit
drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea xhci_pci nvme rtsx_pci_sdmmc ucsi_acpi typec_ucsi mmc_core atkbd ccp rtsx_pci libps2 drm nvme_core
mfd_core sp5100_tco
[  384.740851]  rng_core xhci_hcd drm_panel_orientation_quirks t10_pi typec i8042 pinctrl_amd r8169 realtek 8250_pci usbmon nbd fuse autofs4
[  384.965149] CR2: 0000000000000021
[  384.972622] ---[ end trace 23949f0862c2ac65 ]---
[  384.983042] RIP: 0010:amd_iommu_update_ga+0x32/0x160
[  384.994255] Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 83 3d 04 75 2a 01 02 0f 85 bd 00 00 00 <4c> 8b 62 20 48 8b 4a 18 4d 85 e4 0f 84 ca 00 00 00
48 85 c9 0f 84
[  385.036720] RSP: 0018:ffffc9000036fca0 EFLAGS: 00010046
[  385.048518] RAX: 0000000000000000 RBX: ffff88810b68ab60 RCX: ffff8881667a6018
[  385.064646] RDX: 0000000000000001 RSI: ffff888107476b00 RDI: 0000000000000003
[  385.080765] RBP: ffffc9000036fcf0 R08: 0000000000000010 R09: 0000000000000010
[  385.096886] R10: 0000000000000bb8 R11: ffffffff82a0fe80 R12: 0000000000000003
[  385.113004] R13: ffff88836b98ea68 R14: 0000000000000202 R15: ffff88836b98ea78
[  385.129128] FS:  00007f18d9ffb640(0000) GS:ffff8883ff6c0000(0000) knlGS:0000000000000000
[  385.147407] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  385.160385] CR2: 0000000000000021 CR3: 00000001617c3000 CR4: 0000000000350ee0
[  385.172739] [drm] Fence fallback timer expired on ring sdma0
> 


Oh, well tomorrow I'll see what I can do with  these.

Best regards,
	Maxim Levitsky
> 
> I'll post my patches tomorrow, after some more testing.
> 
> Best regards,
> 	Maxim Levitsky


