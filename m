Return-Path: <kvm+bounces-63390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE70C64F7D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:50:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0528E4EE215
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 15:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A5E299931;
	Mon, 17 Nov 2025 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Un7Gp+qc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC1228D8F4
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763394541; cv=none; b=DmhZZdMHrH/2OhHE1QObUP123SaOnUPMNkbEw7H8jFtpt29IFTcKf3ptNHqWON8TyuvyBAXrbG+/WG+6L6Z6w7Iqu7tlZkw81XqUQfb0fVDoPmGMXzR6g+Jz5o+s+hNZW/MJ0SxeU7wtiUrDVKOfv4DWlfL1Cp/yZ9mePQlKLJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763394541; c=relaxed/simple;
	bh=dW17Xtf60yMPT5ps4T8sOTJvB9Wdvt1Dcr9Gkv/rbrI=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=TbY1XGSuFmsVKNN54lfVuLU2pJ74HAs3tQqfB/TSbbzTHq/WsYsrYZbgoh1zXHLij9fUlPoMz42Eb3557CTsmOU4i9lKLDneKYns4LR/c/cQYQQJkey/gnP6u/cl31yQFZIU+Z/TQVRSXU5qaVjmAl9pHsFSW+y6aN+lvYEp158=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Un7Gp+qc; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37a2dced861so49924641fa.1
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 07:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763394538; x=1763999338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LGblZlAzPFW/2WQFRjSDWi5Fba28kD07gZJ1IX2a3nA=;
        b=Un7Gp+qclTuRZv7ffd9KVRG0N07pMeLxqFb3tdXaAzhmZ4RFxGI/HnESxhKvsuvQYB
         YjoN/gU6n8aobsy7pbc2oX+C5sil5VqcUL8iuybnkcG8amQz9mnsPp3qygqoOPM5XBx/
         svro+HtVAWKrpdmrz8DA14zQpi8Oo0bzsgA94dBkYDEoULrssCy64KymCM9rNkZyeXef
         PY3Y4l347ivLqrPz7LnpHpN9HgeKNhNcXS4oirsMnn+TnfpzlKOye3i85FwsotL1XXtt
         JlnsGaoWW30c6RPGxOaz26v4Cc7IeCNh7PJvbmOfY6JovuxphT2CTevzV3nDGel5CMba
         UMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763394538; x=1763999338;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGblZlAzPFW/2WQFRjSDWi5Fba28kD07gZJ1IX2a3nA=;
        b=RRZAiWjbEC59o8879sBVda9uim3bo9LKrM1u40mMWYPqakpvlz9THPeffPbfaJUfCY
         InZaIllZhxd8+h6iwH6OqScF/zy4o7JxekkIg4tKRxAJRs6uoSzn9WzEHiM26Z4uUzmR
         LPp/1LcwmoToW9RkHpEj8KlFTpA/QweSSMsghxYYQ1G6W+iNRvzA/RbAIeX8/FZWTqo3
         RkoMkMFt27xKXWStKtW6lkBnxwwpggPHt+buZVs/uL7O2QOAVZKUGTL+8YX74oFPermH
         ze6b4kJV8LgstB3+n3aPGQPLsoz1pz2JCq4KGKceHmVCaZYxzzXX54+ZGAQbdFRd71Oc
         JhXw==
X-Forwarded-Encrypted: i=1; AJvYcCW+4/gCTtLC8zprj1Bhu7Q/Gb+GiefuPQ3RfUKCGfVc89D9uzjphaccJQztGHrfOOShlZI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzExri/w+iZAptmE8XZXU1roG9mo2bHmr9sG+mAhyt9b+Yunf2J
	/NS17G0kK46SLCUA0YXDRDHwH5WuBuUkRM602JpCBShEb2QX6q+7KfPe
X-Gm-Gg: ASbGncs0NOZskhQePssrPjEOCEhYXYSS3zcYMDz1VM5vyVqcxPz9IDUjJ1OhmkLHlSV
	pMpuAfF3b8CNbXWhHd8GKpwJh6faSX60GfoiRoRV94nAHrmbzKzlIfntwh7298sRU3oFKo5PjeP
	pTj/s90X75fcFkTpiBBAU+4PAUi3OZDrZdf7bfUa9gUn7zh9jKuUb4I12p+lOeDQ/kuNG0Og6oJ
	TlnylVzODWYkaxOMl/HBA8ymyPbPnx05UQWFY0PstQbt4Mv+vlF8ESZEh5ZOJPBPcAMV0gjjshN
	DhIveI7kt5pfDR4NPX/YaQxiQgH2ctvK1kYwlCv0fVHfgg5XZiFsI45RtGN7/9ump4uZZGNBpPF
	ICzHiHAY6tRTMdLPTfOoFbHoQp7GxhsQMYzS2Gz/oNIKQJdhGNiYp85UTlWnFYRkKpSPhFAaqOr
	zv4gmgz081E0a9cYM2MO6gwac=
X-Google-Smtp-Source: AGHT+IF1rpPVTmlQvY0tbCs1bx4/RNae4dLLTTWFHwfN3jpYicr+8cuN8Uv57cOfRwrbAVJg0vGaGg==
X-Received: by 2002:a05:651c:310:b0:37b:986a:fc1 with SMTP id 38308e7fff4ca-37b9b16d83amr29417181fa.22.1763394537247;
        Mon, 17 Nov 2025 07:48:57 -0800 (PST)
Received: from lilem.mirepesht ([89.40.241.109])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37b9cee2beesm29047651fa.43.2025.11.17.07.48.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 17 Nov 2025 07:48:56 -0800 (PST)
From: Ali Gholami Rudi <aligrudi@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Eugenio P=?UTF-8?B?w6k=?=rez" <eperezma@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Kernel Crashes When Using VHOST/VIRTIO
Message-ID: <20251711154506@laper.mirepesht>
Date: Mon, 17 Nov 2025 15:45:06 -0000
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi,

The problem happens if a Qemu VM using vhost/virtio receives packets at
a very high rate.  After Qemu's quit command or when the VM is rebooted,
the kernel panics.  The problem is easy to reproduce; we tried different
kernel versions, including 6.1.158 and the mainline, with the same result.
We also reproduced the problem with both Mellanox ConnectX-6 and Intel
XL710 NICs.  The VM is run in Debian 12 using Qemu-7.2.19, on a machine
with AMD Ryzen 9 processor and 192GB of memory.

I have to note that while Qemu's quit command triggers the problem,
if Qemu is killed with SIGTERM, nothing happens.  Kernel's call trace
is included at the end of this email.

Thanks,
Ali

------------[ cut here ]------------
kernel BUG at mm/slub.c:419!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 119 PID: 0 Comm: swapper/119 Not tainted 6.1.0-30-amd64 #1  Debian 6.1.124-1
Hardware name: Supermicro AS -1023US-TR4/H11DSU-iN, BIOS 2.5 10/25/2022
RIP: 0010:__slab_free+0x118/0x2d0
Code: 74 35 49 8b 06 48 89 4c 24 20 48 c1 e8 36 4c 8b a4 c3 d8 00 00 00 4c 89 e7 e8 e4 e3 71 00 48 8b 4c 24 20 48 89 44 24 18 eb 8f <0f> 0b f7 43 08 00 0d 21 00 75 cd eb c6 80 4c 24 53 80 e9 75 ff ff
RSP: 0018:ffffbbfedab8c8c8 EFLAGS: 00010246
RAX: ffff96e7c0c89070 RBX: ffff962c5000e700 RCX: 0000000080400026
RDX: ffffbbfedab8c8f0 RSI: fffffb5d6f032200 RDI: ffffbbfedab8c930
RBP: ffff96e7c0c89000 R08: 0000000000000001 R09: ffffffffc0ecafe5
R10: 000000000000037c R11: 0000000000000370 R12: 0000000000000000
R13: ffff96e7c0c89000 R14: fffffb5d6f032200 R15: ffff96e7c0c89000
FS:  0000000000000000(0000) GS:ffff97284e7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffd109bccb7010 CR3: 0000000fce206000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 ? __die_body.cold+0x1a/0x1f
 ? die+0x2a/0x50
 ? do_trap+0xc5/0x110
 ? __slab_free+0x118/0x2d0
 ? do_error_trap+0x6a/0x90
 ? __slab_free+0x118/0x2d0
 ? exc_invalid_op+0x4c/0x60
 ? __slab_free+0x118/0x2d0
 ? asm_exc_invalid_op+0x16/0x20
 ? tun_net_xmit+0x2c5/0x4f0 [tun]
 ? __slab_free+0x118/0x2d0
 ? __slab_free+0xbf/0x2d0
 tun_net_xmit+0x2c5/0x4f0 [tun]
 dev_hard_start_xmit+0x63/0x1d0
 sch_direct_xmit+0xa0/0x370
 __qdisc_run+0x145/0x590
 __dev_queue_xmit+0x7e9/0xd90
 ? srso_return_thunk+0x5/0x10
 br_dev_queue_push_xmit+0xb7/0x1d0 [bridge]
 br_handle_frame_finish+0x365/0x5b0 [bridge]
 ? srso_return_thunk+0x5/0x10
 ? nft_do_chain_netdev+0x15f/0x2f0 [nf_tables]
 ? srso_return_thunk+0x5/0x10
 br_handle_frame+0x2a6/0x3c0 [bridge]
 ? br_handle_frame_finish+0x5b0/0x5b0 [bridge]
 __netif_receive_skb_core.constprop.0+0x263/0xef0
 ? srso_return_thunk+0x5/0x10
 ? asm_sysvec_call_function_single+0x16/0x20
 __netif_receive_skb_list_core+0x13a/0x2c0
 ? srso_return_thunk+0x5/0x10
 netif_receive_skb_list_internal+0x1cd/0x300
 ? dev_gro_receive+0x3b1/0x730
 napi_complete_done+0x6d/0x1a0
 i40e_napi_poll+0xe27/0x1330 [i40e]
 __napi_poll+0x2b/0x160
 net_rx_action+0x2a0/0x350
 ? srso_return_thunk+0x5/0x10
 handle_softirqs+0xd7/0x280
 ? handle_edge_irq+0x87/0x220
 __irq_exit_rcu+0xac/0xe0
 common_interrupt+0x82/0xa0
 </IRQ>
 <TASK>
 asm_common_interrupt+0x22/0x40
RIP: 0010:finish_task_switch.isra.0+0x96/0x2d0
Code: 45 34 00 00 00 00 0f 1f 44 00 00 49 8b 9c 24 20 0a 00 00 48 85 db 0f 85 aa 00 00 00 4c 89 e7 e8 b0 a5 96 00 fb 0f 1f 44 00 00 <65> 48 8b 04 25 80 fb 01 00 eb 42 4d 85 f6 74 21 65 48 8b 04 25 80
RSP: 0018:ffffbbfed0adfe50 EFLAGS: 00000282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffff962c5ccc1980 RDI: ffff97284e7f1a40
RBP: ffffbbfed0adfe78 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000fffffffb R11: 0000000000000000 R12: ffff97284e7f1a40
R13: ffff95424d908000 R14: 0000000000000000 R15: 0000000000000001
 __schedule+0x355/0x9e0
 schedule_idle+0x26/0x40
 do_idle+0x172/0x2a0
 cpu_startup_entry+0x26/0x30
 start_secondary+0x12a/0x150
 secondary_startup_64_no_verify+0xe5/0xeb
 </TASK>
Modules linked in: nfsd nfs_acl nbd act_police cls_matchall sch_ingress vhost_net vhost vhost_iotlb tap sch_tbf tun nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_limit nft_meta_bridge nf_tables nfnetlink rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs bridge stp llc bonding msr cpufreq_powersave cpufreq_ondemand cpufreq_userspace cpufreq_conservative tls intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd kvm_amd kvm irqbypass ghash_clmulni_intel sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 aesni_intel ipmi_ssif crypto_simd cryptd rapl pcspkr sunrpc binfmt_misc nls_ascii ast nls_cp437 drm_vram_helper vfat drm_ttm_helper fat ttm drm_kms_helper sr_mod cdrom acpi_ipmi sp5100_tco ccp sg watchdog k10temp ipmi_si ipmi_devintf ipmi_msghandler evdev joydev acpi_cpufreq button drm fuse loop efi_pstore dm_mod configfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 efivarfs raid456 async_raid6_recov async_memcpy async_pq async_xor
 async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear raid10 hid_generic usbhid uas md_mod hid usb_storage crc32_pclmul crc32c_intel nvme nvme_core ahci xhci_pci libahci t10_pi xhci_hcd crc64_rocksoft libata crc64 igb crc_t10dif i40e usbcore scsi_mod crct10dif_generic i2c_algo_bit crct10dif_pclmul crct10dif_common dca scsi_common i2c_piix4 usb_common
---[ end trace 0000000000000000 ]---
RIP: 0010:__slab_free+0x118/0x2d0
Code: 74 35 49 8b 06 48 89 4c 24 20 48 c1 e8 36 4c 8b a4 c3 d8 00 00 00 4c 89 e7 e8 e4 e3 71 00 48 8b 4c 24 20 48 89 44 24 18 eb 8f <0f> 0b f7 43 08 00 0d 21 00 75 cd eb c6 80 4c 24 53 80 e9 75 ff ff
RSP: 0018:ffffbbfedab8c8c8 EFLAGS: 00010246
RAX: ffff96e7c0c89070 RBX: ffff962c5000e700 RCX: 0000000080400026
RDX: ffffbbfedab8c8f0 RSI: fffffb5d6f032200 RDI: ffffbbfedab8c930
RBP: ffff96e7c0c89000 R08: 0000000000000001 R09: ffffffffc0ecafe5
R10: 000000000000037c R11: 0000000000000370 R12: 0000000000000000
R13: ffff96e7c0c89000 R14: fffffb5d6f032200 R15: ffff96e7c0c89000
FS:  0000000000000000(0000) GS:ffff97284e7c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffd109bccb7010 CR3: 0000000fce206000 CR4: 0000000000350ee0
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: 0x22a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


