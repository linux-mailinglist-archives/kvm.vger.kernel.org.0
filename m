Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2F644966
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbiLFQgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 11:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiLFQfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 11:35:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319653721F
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 08:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670344418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1KtHP/9WSizeWr0rWUsPX8FFRHCBerdm+mKlAW8so8E=;
        b=TKqT2AjY1PmQTMGwSUVrG3fRqKtc+Wo5DexTagXifB6+sHJ5CMfO+s3kZWmX98ItXaG0k1
        9QXh2shIBp1Ib+oSVd/UMmnv3LW1gtHvqc32ynYVgWT/uRc9ks+cm7dIK60YeulqH1ew3N
        jnsRc7lXmsuWZ6iw/YoabUb6d+7FeYQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-UqRNYkdOOLahtDzTx1tbsQ-1; Tue, 06 Dec 2022 11:33:37 -0500
X-MC-Unique: UqRNYkdOOLahtDzTx1tbsQ-1
Received: by mail-il1-f197.google.com with SMTP id i11-20020a056e02152b00b00303642498daso4460232ilu.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 08:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1KtHP/9WSizeWr0rWUsPX8FFRHCBerdm+mKlAW8so8E=;
        b=CNpIzQsZLR1/+iOm0AimtxX8XIlaoirdj7mUwWbLQE6oa2X4J+t7i3X7UnbhEdUQHY
         ml/7bJ7qlbEr52c9SFR1b8RmM69IhY5RSMo96vV8J2kh59Esfb+eg18/cLVN5/NwDjp2
         aFTkot3NrUmPQ4mdxhmj+ucZMoERzp/eC5cbCpYAu9Zh0c+Nwjw8i0zm0sQKEBI42sbR
         ykWyPRzl2qtHL4Huh/ruFqRF+mz2/zqyjM9vQYLH/b+0R9gtdA2iqHDPkO06xQDUB8RN
         e6qUvA5dMSE/5Vzr8I2KVCdKxVYZ3f4C6LaNu8whK3JaeD8F4+8EUFAcFmhU1MW2Yun9
         iK+Q==
X-Gm-Message-State: ANoB5pkYpHuSLkEuozbchlGyuKvni1EhKowqaFWCJzw23UUslm3bGuAg
        ArHAtPJexC0uQ0YjSzVkNVF+ugipNbTdVAkVLv7VPRM4doAivwvwpAr8fdleVTi5ukUZ8PUhRU1
        ik/JUfS6x8IMH
X-Received: by 2002:a02:a696:0:b0:363:3937:d400 with SMTP id j22-20020a02a696000000b003633937d400mr42108084jam.309.1670344415285;
        Tue, 06 Dec 2022 08:33:35 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6vmbRxWAyw7AgimFFNDG0pZucads31lnE0rmOWWjt+pVIiNqdQXEX9Sxgzg3muB1dLRnEfhg==
X-Received: by 2002:a02:a696:0:b0:363:3937:d400 with SMTP id j22-20020a02a696000000b003633937d400mr42108073jam.309.1670344414998;
        Tue, 06 Dec 2022 08:33:34 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 189-20020a0211c6000000b00385f2a30781sm6689006jaf.72.2022.12.06.08.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:33:34 -0800 (PST)
Date:   Tue, 6 Dec 2022 09:33:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Cc:     intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org
Subject: [Bug report] Null pointer dereference unbinding i915 with gvt
 enabled
Message-ID: <20221206093332.24af4779.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


I see this both on the vfio next branch and on the gvt-next branch of
https://github.com/intel/gvt-linux.  I boot my system with
i915.enable_gvt=1 and load the kvmgt module.  A vGPU device is
automatically created by mdevctl.  If I then bind vfio-pci directly to
the GPU using 'driverctl --nosave set-override 0000:00:02.0 vfio-pci', I
get the below oops.  Thanks,

Alex


Console: switching to colour dummy device 80x25
i915 0000:00:02.0: MDEV: Unregistering
intel_vgpu_mdev b1338b2d-a709-4c23-b766-cc436c36cdf0: Removing from iommu group 14
BUG: kernel NULL pointer dereference, address: 0000000000000150
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0 
Oops: 0000 [#1] PREEMPT SMP
CPU: 3 PID: 1046 Comm: driverctl Not tainted 6.1.0-rc2+ #6
Hardware name: HP HP ProDesk 600 G3 MT/829D, BIOS P02 Ver. 02.44 09/13/2022
RIP: 0010:__lock_acquire+0x5e2/0x1f90
Code: 87 ad 09 00 00 39 05 e1 1e cc 02 0f 82 f1 09 00 00 ba 01 00 00 00 48 83 c4 48 89 d0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 ff <48> 81 3f 60 9e c2 b6 45 0f 45 f8 83 fe 01 0f 87 55 fa ff ff 89 f0
RSP: 0018:ffff9f770274f948 EFLAGS: 00010046
RAX: 0000000000000003 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000150
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: ffff8895d1173300 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000150 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fc9b2ba0740(0000) GS:ffff889cdfcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000150 CR3: 000000010fd93005 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0xbf/0x2b0
 ? simple_recursive_removal+0xa5/0x2b0
 ? lock_release+0x13d/0x2d0
 down_write+0x2a/0xd0
 ? simple_recursive_removal+0xa5/0x2b0
 simple_recursive_removal+0xa5/0x2b0
 ? start_creating.part.0+0x110/0x110
 ? _raw_spin_unlock+0x29/0x40
 debugfs_remove+0x40/0x60
 intel_gvt_debugfs_remove_vgpu+0x15/0x30 [kvmgt]
 intel_gvt_destroy_vgpu+0x60/0x100 [kvmgt]
 intel_vgpu_release_dev+0xe/0x20 [kvmgt]
 device_release+0x30/0x80
 kobject_put+0x79/0x1b0
 device_release_driver_internal+0x1b8/0x230
 bus_remove_device+0xec/0x160
 device_del+0x189/0x400
 ? up_write+0x9c/0x1b0
 ? mdev_device_remove_common+0x60/0x60 [mdev]
 mdev_device_remove_common+0x22/0x60 [mdev]
 mdev_device_remove_cb+0x17/0x20 [mdev]
 device_for_each_child+0x56/0x80
 mdev_unregister_parent+0x5a/0x81 [mdev]
 intel_gvt_clean_device+0x2d/0xe0 [kvmgt]
 intel_gvt_driver_remove+0x2e/0xb0 [i915]
 i915_driver_remove+0xac/0x100 [i915]
 i915_pci_remove+0x1a/0x30 [i915]
 pci_device_remove+0x31/0xa0
 device_release_driver_internal+0x1b8/0x230
 unbind_store+0xd8/0x100
 kernfs_fop_write_iter+0x156/0x210
 vfs_write+0x236/0x4a0
 ksys_write+0x61/0xd0
 do_syscall_64+0x55/0x80
 ? find_held_lock+0x2b/0x80
 ? lock_release+0x13d/0x2d0
 ? up_read+0x17/0x20
 ? lock_is_held_type+0xe3/0x140
 ? asm_exc_page_fault+0x22/0x30
 ? lockdep_hardirqs_on+0x7d/0x100
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fc9b2c9e0c4
Code: 15 71 7d 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 80 3d 3d 05 0e 00 00 74 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24 18 48
RSP: 002b:00007ffec29c81c8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fc9b2c9e0c4
RDX: 000000000000000d RSI: 0000559f8b5f48a0 RDI: 0000000000000001
RBP: 0000559f8b5f48a0 R08: 0000559f8b5f3540 R09: 00007fc9b2d76d30
R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000000d
R13: 00007fc9b2d77780 R14: 000000000000000d R15: 00007fc9b2d72a00
 </TASK>
Modules linked in: sunrpc intel_rapl_msr intel_rapl_common intel_pmc_core_pltdrv intel_pmc_core intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel ee1004 igbvf rapl vfat fat intel_cstate intel_uncore pktcdvd i2c_i801 pcspkr wmi_bmof i2c_smbus acpi_pad vfio_pci vfio_pci_core vfio_virqfd zram fuse dm_multipath kvmgt mdev vfio_iommu_type1 vfio kvm irqbypass i915 nvme e1000e igb nvme_core crct10dif_pclmul crc32_pclmul crc32c_intel polyval_clmulni polyval_generic serio_raw ghash_clmulni_intel sha512_ssse3 dca drm_buddy intel_gtt video wmi drm_display_helper ttm
CR2: 0000000000000150
---[ end trace 0000000000000000 ]---

