Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6254A2029D5
	for <lists+kvm@lfdr.de>; Sun, 21 Jun 2020 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgFUJdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jun 2020 05:33:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729573AbgFUJdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jun 2020 05:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592732015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OBpir7iL+7XcZZbz4W1dd7vvt+8CbRIoSw21etJ1Zh8=;
        b=AU9cdrxeEmetnFc2BsY5q9zeubkXzTGcKkmBGZlJEpqntbP9VUxUgiR68aDON8kMpDk4+C
        +i6/lxxmlhIyoyH1Er6KDo5HMutlsWFGZv5oYIb4Auu8qX8dcpqa1gbi7yGO8vofSvjZYX
        1Ge9RNKP1Q68gE256vs4KxIDGUshM4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-KhM0XZwUPOe95Z8sJiTNNg-1; Sun, 21 Jun 2020 05:33:33 -0400
X-MC-Unique: KhM0XZwUPOe95Z8sJiTNNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E56880572C;
        Sun, 21 Jun 2020 09:33:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 940D919C66;
        Sun, 21 Jun 2020 09:33:31 +0000 (UTC)
Message-ID: <520c57f9836d53e08cb72c88d8d6b22e38f8c926.camel@redhat.com>
Subject: KVM/RCU related warning on latest mainline kernel
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Sun, 21 Jun 2020 12:33:30 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I started to see this warning recently:


[  474.827893] ------------[ cut here ]------------
[  474.827894] WARNING: CPU: 28 PID: 3984 at kernel/rcu/tree.c:453 rcu_is_cpu_rrupt_from_idle+0x29/0x40
[  474.827894] Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio xfs rfcomm xt_MASQUERADE xt_conntrack ipt_REJECT iptable_mangle iptable_nat nf_nat ebtable_filter ebtables ip6table_filter
ip6_tables tun bridge pmbus pmbus_core cmac ee1004 jc42 bnep sunrpc vfat fat dm_mirror dm_region_hash dm_log iwlmvm wmi_bmof mac80211 libarc4 uvcvideo iwlwifi videobuf2_vmalloc btusb videobuf2_memops
kvm_amd snd_usb_audio videobuf2_v4l2 videobuf2_common snd_hda_codec_hdmi btrtl kvm btbcm btintel snd_usbmidi_lib snd_hda_intel videodev input_leds joydev snd_rawmidi snd_intel_dspcfg bluetooth mc
snd_hda_codec cfg80211 snd_hwdep xpad ff_memless thunderbolt snd_seq snd_hda_core irqbypass ecdh_generic i2c_nvidia_gpu efi_pstore ecc pcspkr snd_seq_device rfkill snd_pcm bfq snd_timer i2c_piix4 snd
zenpower rtc_cmos tpm_crb tpm_tis tpm_tis_core wmi tpm button binfmt_misc dm_crypt sd_mod uas usb_storage hid_generic usbhid hid ext4 mbcache jbd2 amdgpu gpu_sched ttm ahci drm_kms_helper syscopyarea
libahci
[  474.827913]  sysfillrect crc32_pclmul sysimgblt crc32c_intel fb_sys_fops igb ccp libata xhci_pci cec i2c_algo_bit rng_core nvme xhci_hcd nvme_core drm t10_pi nbd usbmon it87 hwmon_vid fuse i2c_dev
i2c_core ipv6 autofs4 [last unloaded: nvidia]
[  474.827918] CPU: 28 PID: 3984 Comm: CPU 0/KVM Tainted: P           O      5.8.0-rc1.stable #118
[  474.827919] Hardware name: Gigabyte Technology Co., Ltd. TRX40 DESIGNARE/TRX40 DESIGNARE, BIOS F4c 03/05/2020
[  474.827919] RIP: 0010:rcu_is_cpu_rrupt_from_idle+0x29/0x40
[  474.827920] Code: 00 0f 1f 44 00 00 31 c0 65 48 8b 15 21 1e ea 7e 48 83 fa 01 7f 27 48 85 d2 75 11 65 48 8b 04 25 00 25 01 00 f6 40 24 02 75 02 <0f> 0b 65 48 8b 05 f5 1d ea 7e 48 85 c0 0f 94 c0 0f
b6 c0 c3 0f 1f
[  474.827920] RSP: 0018:ffffc900009d0e80 EFLAGS: 00010046
[  474.827921] RAX: ffff889775e6d580 RBX: ffffc9000476fce8 RCX: 0000000000000001
[  474.827921] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  474.827922] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000006e802f88c2
[  474.827922] R10: 0000000000000000 R11: 0000000000000000 R12: 0000006e802f8b10
[  474.827923] R13: ffff889fbe719280 R14: ffff889fbe719378 R15: ffff889fbe7197e0
[  474.827923] FS:  0000000000000000(0008) GS:ffff889fbe700000(0008) knlGS:0000000000000000
[  474.827924] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  474.827924] CR2: 0000000000000000 CR3: 000000176872a000 CR4: 0000000000340ea0
[  474.827924] Call Trace:
[  474.827924]  <IRQ>
[  474.827925]  rcu_sched_clock_irq+0x49/0x500
[  474.827925]  update_process_times+0x24/0x50
[  474.827925]  tick_sched_handle.isra.0+0x1f/0x60
[  474.827926]  tick_sched_timer+0x3b/0x80
[  474.827926]  ? tick_sched_handle.isra.0+0x60/0x60
[  474.827926]  __hrtimer_run_queues+0xf3/0x260
[  474.827927]  hrtimer_interrupt+0x10e/0x240
[  474.827927]  __sysvec_apic_timer_interrupt+0x51/0xe0
[  474.827927]  asm_call_on_stack+0xf/0x20
[  474.827928]  </IRQ>
[  474.827928]  sysvec_apic_timer_interrupt+0x6c/0x80
[  474.827928]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  474.827929] RIP: 0010:kvm_arch_vcpu_ioctl_run+0xdca/0x1c80 [kvm]
[  474.827930] Code: f0 41 c7 45 30 00 00 00 00 49 89 85 e8 19 00 00 4c 89 ef ff 15 cf 41 07 00 65 4c 89 2d 07 b6 b4 5d fb 49 83 85 c8 00 00 00 01 <fa> 65 48 c7 05 f1 b5 b4 5d 00 00 00 00 e9 cc 00 00
00 e9 a5 00 00
[  474.827930] RSP: 0018:ffffc9000476fd90 EFLAGS: 00000212
[  474.827931] RAX: 00000004eca3dfff RBX: 0000000000000000 RCX: 000000007b29b4fe
[  474.827931] RDX: 0000000100000000 RSI: fffffe40717a2b01 RDI: ffff889f9f460000
[  474.827931] RBP: ffffc9000476fe60 R08: 0000000000000000 R09: 0000000000000000
[  474.827932] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  474.827932] R13: ffff889f9f460000 R14: 8000000000000000 R15: ffffc900047161d0
[  474.827932]  kvm_vcpu_ioctl+0x211/0x5b0 [kvm]
[  474.827933]  ? mprotect_fixup+0x1cf/0x2f0
[  474.827933]  ksys_ioctl+0x84/0xc0
[  474.827933]  __x64_sys_ioctl+0x16/0x20
[  474.827934]  do_syscall_64+0x41/0xc0
[  474.827934]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  474.827934] RIP: 0033:0x7f39ad07435b
[  474.827934] Code: Bad RIP value.
[  474.827935] RSP: 002b:00007f39a89c8728 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  474.827936] RAX: ffffffffffffffda RBX: 0000561ae9351460 RCX: 00007f39ad07435b
[  474.827936] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000016
[  474.827936] RBP: 00007f39a89c8820 R08: 0000561ae71e2d10 R09: 00000000000000ff
[  474.827937] R10: 0000561ae6b3dc87 R11: 0000000000000246 R12: 00007ffc5436744e
[  474.827937] R13: 00007ffc5436744f R14: 00007ffc54367510 R15: 00007f39a89c8a40
[  474.827938] ---[ end trace d3c2fb0a7a2c2d8d ]---


kvm_arch_vcpu_ioctl_run+0xdca corresponds to native_irq_enable()
that is done after vmexit to handle pending interrupts)

   0x0000000000023b80 <+3504>:	mov    %r13,%rdi
   0x0000000000023b83 <+3507>:	callq  *0x0(%rip)        # 0x23b89 <kvm_arch_vcpu_ioctl_run+3513>

arch/x86/kvm/x86.h:
341		__this_cpu_write(current_vcpu, vcpu);
   0x0000000000023b89 <+3513>:	mov    %r13,%gs:0x0(%rip)        # 0x23b91 <kvm_arch_vcpu_ioctl_run+3521>

./arch/x86/include/asm/irqflags.h:
94		native_irq_enable();
   0x0000000000023b91 <+3521>:	sti    

arch/x86/kvm/x86.c:
8561		++vcpu->stat.exits;
   0x0000000000023b92 <+3522>:	addq   $0x1,0xc8(%r13)

./arch/x86/include/asm/irqflags.h:
89		native_irq_disable();
   0x0000000000023b9a <+3530>:	cli


I haven't yet studied RCU area to know if this warning is correct,
but something to note is that VMX code handles pending interrupt by
querying the VMCS for the interrupt vector and actually 
simulating the interrupt by jumping to the interrupt vector,
so maybe this is how this warning got missed in testing
( I use AMD's SVM )

I am using 'isolcpus=domain,managed_irq,28-31,60-63 nohz_full=28-31,60-63'
Also worth noting is that I use -overcommit cpu_pm=on qemu command line for the guest to let
it run all the time on the isolated cores.

I can bisect/debug this futher if you think that this is worth it.

Best regards,
	Maxim Levitsky

