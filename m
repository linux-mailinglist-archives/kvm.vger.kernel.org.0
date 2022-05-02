Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F73516CA2
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 10:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383877AbiEBI76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 04:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383958AbiEBI7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 04:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 333A058381
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 01:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651481782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kj+GEtdJ9Hb/CAj8K0MrJugmWC+ygQpyXt/+m5YTgQo=;
        b=S20EBCUP1BcN3gJhggtw0OV4gnrSuIBm8vFNWUvFyDq6c8AyVVN6u530Al012TiVkNs3ju
        QkdWReo1GfzmwU85/sgO4onLaOF+mH//l782kMS+JsB0HALuecXepvACVqaEtC46/xv5PF
        qpYEmna3s96oV8QcrLXGWdWlQ+FQ1oc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-fRHSA39wPBufAVbrsxoWtg-1; Mon, 02 May 2022 04:56:19 -0400
X-MC-Unique: fRHSA39wPBufAVbrsxoWtg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E35EB85A5BE;
        Mon,  2 May 2022 08:56:18 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64B34401D52;
        Mon,  2 May 2022 08:56:16 +0000 (UTC)
Message-ID: <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Date:   Mon, 02 May 2022 11:56:15 +0300
In-Reply-To: <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
References: <20220428233416.2446833-1-seanjc@google.com>
         <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
         <Ymv1I5ixX1+k8Nst@google.com>
         <20e1e7b1-ece7-e9e7-9085-999f7a916ac2@redhat.com>
         <Ymv5TR76RNvFBQhz@google.com>
         <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
         <YmwL87h6klEC4UKV@google.com>
         <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
         <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
         <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-02 at 10:59 +0300, Maxim Levitsky wrote:
> On Sun, 2022-05-01 at 17:32 +0300, Maxim Levitsky wrote:
> > On Sun, 2022-05-01 at 17:28 +0300, Maxim Levitsky wrote:
> > > On Fri, 2022-04-29 at 16:01 +0000, Sean Christopherson wrote:
> > > > On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> > > > > On 4/29/22 16:42, Sean Christopherson wrote:
> > > > > > On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> > > > > > > On 4/29/22 16:24, Sean Christopherson wrote:
> > > > > > > > I don't love the divergent memslot behavior, but it's technically correct, so I
> > > > > > > > can't really argue.  Do we want to "officially" document the memslot behavior?
> > > > > > > > 
> > > > > > > 
> > > > > > > I don't know what you mean by officially document,
> > > > > > 
> > > > > > Something in kvm/api.rst under KVM_SET_USER_MEMORY_REGION.
> > > > > 
> > > > > Not sure if the API documentation is the best place because userspace does
> > > > > not know whether shadow paging is on (except indirectly through other
> > > > > capabilities, perhaps)?
> > > > 
> > > > Hrm, true, it's not like the userspace VMM can rewrite itself at runtime.
> > > > 
> > > > > It could even be programmatic, such as returning 52 for CPUID[0x80000008].
> > > > > A nested KVM on L1 would not be able to use the #PF(RSVD) trick to detect
> > > > > MMIO faults.  That's not a big price to pay, however I'm not sure it's a
> > > > > good idea in general...
> > > > 
> > > > Agreed, messing with CPUID is likely to end in tears.
> > > > 
> > > 
> > > Also I can reproduce it all the way to 5.14 kernel (last kernel I have installed in this VM).
> > > 
> > > I tested kvm/queue as of today, sadly I still see the warning.
> > 
> > Due to a race, the above statements are out of order ;-)
> 
> So futher investigation shows that the trigger for this *is* cpu_pm=on :(
> 
> So this is enough to trigger the warning when run in the guest:
> 
> qemu-system-x86_64  -nodefaults  -vnc none -serial stdio -machine accel=kvm -kernel x86/dummy.flat -machine kernel-irqchip=on -smp 8 -m 1g -cpu host -overcommit cpu-pm=on
> 
> 
> '-smp 8' is needed, and the more vCPUs the more often the warning appears.
> 
> 
> Due to non atomic memslot update bug, I use patched qemu version, with an attached hack,
> to pause/resume vcpus around the memslot update it does, but even without this hack,
> you can just ctrl+c the test after it gets the KVM internal error, and 
> then tdp mmu memory leak warning shows up (not always but very often).
> 
> 
> Oh, and if I run the above command on the bare metal, it  never terminates. Must be due to preemption,
> qemu shows beeing stuck in kvm_vcpu_block. AVIC disabled, kvm/queue.
> Bugs, bugs, and features :)

All right, at least that was because I removed the '-device isa-debug-exit,iobase=0xf4,iosize=0x4',
which is apparently used by KVM unit tests to signal exit from the VM.

Best regards,
	Maxim Levitsky

> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > [mlevitsk@fedora34 ~]$[   35.205241] ------------[ cut here ]------------
> > > [   35.207156] WARNING: CPU: 6 PID: 3236 at arch/x86/kvm/mmu/tdp_mmu.c:46 kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
> > > [   35.211468] Modules linked in: uinput snd_seq_dummy snd_hrtimer xt_MASQUERADE xt_conntrack ipt_REJECT ip6table_filter ip6_tables iptable_mangle iptable_nat nf_nat bridge rpcsec_gss_krb5 auth_rpcgss
> > > nfsv4 dns_resolver nfs lockd grace fscache netfs rfkill sunrpc vfat fat snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec kvm_amd snd_hwdep ccp snd_hda_core rng_core snd_seq kvm
> > > snd_seq_device snd_pcm joydev irqbypass snd_timer input_leds snd lpc_ich virtio_input mfd_core pcspkr efi_pstore rtc_cmos button ext4 mbcache jbd2 hid_generic usbhid hid virtio_gpu virtio_dma_buf
> > > drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec virtio_net net_failover drm virtio_console failover i2c_core virtio_blk crc32_pclmul xhci_pci crc32c_intel xhci_hcd virtio_pci
> > > virtio_pci_modern_dev virtio_ring virtio dm_mirror dm_region_hash dm_log fuse ipv6 autofs4
> > > [   35.248745] CPU: 6 PID: 3236 Comm: CPU 2/KVM Not tainted 5.14.0.stable #90
> > > [   35.251559] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> > > [   35.255011] RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x47/0x50 [kvm]
> > > [   35.257531] Code: 48 89 e5 48 39 c2 75 21 48 8b 87 b0 91 00 00 48 81 c7 b0 91 00 00 48 39 f8 75 08 e8 b3 7c cd e0 5d c3 c3 90 0f 0b 90 eb f2 90 <0f> 0b 90 eb d9 0f 1f 40 00 0f 1f 44 00 00 55 b8 ff
> > > ff ff ff 48 89
> > > [   35.265355] RSP: 0018:ffffc90001f6fc28 EFLAGS: 00010283
> > > [   35.267659] RAX: ffffc90001f5a1c0 RBX: 0000000000000008 RCX: 0000000000000000
> > > [   35.270823] RDX: ffff888114168958 RSI: ffff888115636ac0 RDI: ffffc90001f51000
> > > [   35.273769] RBP: ffffc90001f6fc28 R08: 0000000000004802 R09: 0000000000000000
> > > [   35.276595] R10: 00000000000001cd R11: 0000000000000018 R12: ffffc90001f51000
> > > [   35.279470] R13: ffffc90001f51998 R14: ffff8881001d3060 R15: dead000000000100
> > > [   35.282314] FS:  0000000000000000(0000) GS:ffff88846ef80000(0000) knlGS:0000000000000000
> > > [   35.285594] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   35.287943] CR2: 0000000000000000 CR3: 0000000002a0b000 CR4: 0000000000350ee0
> > > [   35.290979] Call Trace:
> > > [   35.292082]  kvm_mmu_uninit_vm+0x22/0x30 [kvm]
> > > [   35.293909]  kvm_arch_destroy_vm+0x18f/0x200 [kvm]
> > > [   35.295884]  kvm_destroy_vm+0x164/0x250 [kvm]
> > > [   35.297680]  kvm_put_kvm+0x26/0x40 [kvm]
> > > [   35.299309]  kvm_vm_release+0x22/0x30 [kvm]
> > > [   35.301088]  __fput+0x94/0x240
> > > [   35.302338]  ____fput+0xe/0x10
> > > [   35.303599]  task_work_run+0x63/0xa0
> > > [   35.305083]  do_exit+0x353/0x9d0
> > > [   35.306470]  do_group_exit+0x3b/0xa0
> > > [   35.307882]  get_signal+0x163/0x850
> > > [   35.309403]  arch_do_signal_or_restart+0xf3/0x7c0
> > > [   35.311390]  exit_to_user_mode_prepare+0x112/0x1f0
> > > [   35.313374]  syscall_exit_to_user_mode+0x18/0x40
> > > [   35.315244]  do_syscall_64+0x44/0xb0
> > > [   35.316819]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [   35.318874] RIP: 0033:0x7f51e5f8b0ab
> > > [   35.320395] Code: Unable to access opcode bytes at RIP 0x7f51e5f8b081.
> > > [   35.322985] RSP: 002b:00007f50dbdfd5c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > [   35.326015] RAX: fffffffffffffffc RBX: 000055df487dd0a0 RCX: 00007f51e5f8b0ab
> > > [   35.328914] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000e
> > > [   35.332162] RBP: 00007f50dbdfd6c0 R08: 000055df46521e60 R09: 00007ffcd47ed080
> > > [   35.335172] R10: 00007ffcd47ed090 R11: 0000000000000246 R12: 00007ffcd4653f2e
> > > [   35.338302] R13: 00007ffcd4653f2f R14: 0000000000000000 R15: 00007f50dbdff640
> > > [   35.341320] ---[ end trace fa01d10f9909874f ]---
> > > 
> > > 
> > > Oh, well, I will now switch to vanilla L0 kernel, just in case, and see where to go from this point.
> > > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 


