Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC55103B2
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiDZQmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353055AbiDZQmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:42:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CCBB22BC3
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650991144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KExBUzk6NwGpAls1HsucPC2P/J8Pl6+PQyMQiIic8gA=;
        b=F95flKb/DqlMYe9dPygGg998DTs9AulR+Pb/W08KT9aKrElCLftXcvRXcQvBaYVKcraflE
        DvLFKLyoRkHalKephXccbmbXcZvxSNPWPvyIiSguX+l64crZwKnnmA35v6+wbokP2yBDot
        X0XlhcRmw8NdqIuGq36YaLXm4LOyWE4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-JBL-6HPfPDejVw5p9lMjRg-1; Tue, 26 Apr 2022 12:39:02 -0400
X-MC-Unique: JBL-6HPfPDejVw5p9lMjRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 761A18038E3;
        Tue, 26 Apr 2022 16:39:02 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC507404E4AC;
        Tue, 26 Apr 2022 16:39:01 +0000 (UTC)
Message-ID: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
Subject: Another nice lockdep print in nested SVM code
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Tue, 26 Apr 2022 19:39:00 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just for reference, noticed today:

[ 1355.788381] ------------[ cut here ]------------
[ 1355.788820] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000cce298a6>] kvm_vcpu_block+0x54/0xa0 [kvm]
[ 1355.789843] WARNING: CPU: 0 PID: 8927 at kernel/sched/core.c:9662 __might_sleep+0x68/0x70
[ 1355.790573] Modules linked in: kvm_amd(O) ccp kvm(O) irqbypass tun xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT uinput snd_seq_dummy snd_hrtimer ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core rng_core snd_seq snd_seq_device input_leds snd_pcm joydev snd_timer snd lpc_ich mfd_core virtio_input efi_pstore pcspkr rtc_cmos button sch_fq_codel ext4 mbcache jbd2 hid_generic usbhid hid virtio_gpu virtio_dma_buf drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops virtio_blk virtio_net drm net_failover virtio_console failover i2c_core crc32_pclmul crc32c_intel xhci_pci xhci_hcd virtio_pci virtio virtio_pci_legacy_dev virtio_pci_modern_dev virtio_ring dm_mirror dm_region_hash dm_log fuse ipv6 autofs4 [last unloaded: ccp]
[ 1355.797870] CPU: 0 PID: 8927 Comm: CPU 0/KVM Tainted: G        W  O      5.18.0-rc4.unstable #5
[ 1355.798637] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[ 1355.799295] RIP: 0010:__might_sleep+0x68/0x70
[ 1355.799730] Code: e8 1d fe ff ff 41 5c 41 5d 5d c3 c6 05 5c b3 4c 01 01 90 48 8b 90 80 14 00 00 48 c7 c7 a8 4e 2c 82 48 89 d1 e8 b4 f8 8a 00 90 <0f> 0b 90 90 eb c8 66 90 0f 1f 44 00 00 55 48 89 e5 41 56 41 be 08
[ 1355.801313] RSP: 0018:ffffc90002183be8 EFLAGS: 00010282
[ 1355.801783] RAX: 0000000000000000 RBX: ffffc90002183c40 RCX: 0000000000000000
[ 1355.802402] RDX: ffff88846ce2c1c0 RSI: ffff88846ce1f7a0 RDI: ffff88846ce1f7a0
[ 1355.803046] RBP: ffffc90002183bf8 R08: ffff88847df6efe8 R09: 0000000000013ffb
[ 1355.803690] R10: 0000000000000553 R11: ffff88847df0f000 R12: ffffffffa0921898
[ 1355.804294] R13: 00000000000000a1 R14: 00000000003e0688 R15: ffffea0000000000
[ 1355.804901] FS:  00007f630ffff640(0000) GS:ffff88846ce00000(0000) knlGS:0000000000000000
[ 1355.805641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1355.806145] CR2: 0000000000000000 CR3: 000000011dc16000 CR4: 0000000000350ef0
[ 1355.806759] Call Trace:
[ 1355.806971]  <TASK>
[ 1355.807187]  kvm_vcpu_map+0x159/0x190 [kvm]
[ 1355.807628]  nested_svm_vmexit+0x4c/0x7f0 [kvm_amd]
[ 1355.808036]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
[ 1355.808450]  svm_check_nested_events+0x97/0x390 [kvm_amd]
[ 1355.808920]  kvm_check_nested_events+0x1c/0x40 [kvm]
[ 1355.809396]  kvm_arch_vcpu_runnable+0x4e/0x190 [kvm]
[ 1355.809892]  kvm_vcpu_check_block+0x4f/0x100 [kvm]
[ 1355.810349]  ? kvm_vcpu_check_block+0x5/0x100 [kvm]
[ 1355.810806]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
[ 1355.811259]  kvm_vcpu_block+0x6b/0xa0 [kvm]
[ 1355.811666]  kvm_vcpu_halt+0x3f/0x490 [kvm]
[ 1355.812049]  kvm_arch_vcpu_ioctl_run+0xb0b/0x1d00 [kvm]
[ 1355.812539]  ? rcu_read_lock_sched_held+0x16/0x80
[ 1355.813013]  ? lock_release+0x1c4/0x270
[ 1355.813365]  ? __wake_up_common+0x8d/0x180
[ 1355.813743]  ? _raw_spin_unlock_irq+0x28/0x40
[ 1355.814139]  kvm_vcpu_ioctl+0x289/0x750 [kvm]
[ 1355.814537]  ? kvm_vcpu_ioctl+0x289/0x750 [kvm]
[ 1355.814963]  ? lock_release+0x1c4/0x270
[ 1355.815321]  ? __fget_files+0xe1/0x1a0
[ 1355.815690]  __x64_sys_ioctl+0x8e/0xc0
[ 1355.816019]  do_syscall_64+0x36/0x80
[ 1355.816336]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1355.816776] RIP: 0033:0x7f632cc340ab
[ 1355.817109] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 9d bd 0c 00 f7 d8 64 89 01 48
[ 1355.818713] RSP: 002b:00007f630fffd5c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 1355.819381] RAX: ffffffffffffffda RBX: 0000560c199db3e0 RCX: 00007f632cc340ab
[ 1355.820006] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000024
[ 1355.820610] RBP: 00007f630fffd6c0 R08: 0000560c18a71e60 R09: 000000000000ffff
[ 1355.821238] R10: 0000560c185cac1a R11: 0000000000000246 R12: 00007fff68dfeb0e
[ 1355.821866] R13: 00007fff68dfeb0f R14: 0000000000000000 R15: 00007f630ffff640
[ 1355.822490]  </TASK>
[ 1355.822690] irq event stamp: 0
[ 1355.823011] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 1355.823817] hardirqs last disabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
[ 1355.824820] softirqs last  enabled at (0): [<ffffffff811339cb>] copy_process+0x94b/0x1ec0
[ 1355.825856] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 1355.826633] ---[ end trace 0000000000000000 ]---


I never liked the fact that we map the vmcb12 on vmexit, we should keep it mapped from nested vmentry to nested vmexit.
I can make a patch for this.

Also injecting #GP if either of the maps fail is no doubt wrong - something I know for a while but never got to fix it.

Best regards,
	Maxim Levitsky

