Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A09073319B
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 14:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344052AbjFPMtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 08:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbjFPMta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 08:49:30 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ACF2948;
        Fri, 16 Jun 2023 05:49:28 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33cb82122c7so2536945ab.1;
        Fri, 16 Jun 2023 05:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686919767; x=1689511767;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnItvNM771AemuuivofKtG5KE98ERfScHn7bYJ0SFak=;
        b=i8VlqaijiOFq9GHYRwu4qdqgpAdvB2kwh2/oq/rBIiNqzo4Pj2i/d9EGsXuKtuzBXz
         FVr7tZKKZDN/BOQFY6g1D5zwvPrD6qPpuWqJ+HYa1l17OUVStj16qPdlTBIIMx6Nxict
         tzCuI7cxICKJssW/7j2pM9aR6NX8ViosD2ssxOLo9RHE4o8qICQ/spczd3X9dUMV9Kp9
         +WttRtYcwh92T4VNalBbdLWaFFslFiHtR1Lq5jpJM8blnKWOAWEU2hQ/YrrMWA2KqCFC
         HIhv0tDiEHU/D7TUJbuluK/nJjNoYirDOTk/pPEisl40wnWTxQ/I6I4zLG03CPTVMvxu
         8PDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686919768; x=1689511768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnItvNM771AemuuivofKtG5KE98ERfScHn7bYJ0SFak=;
        b=Y+ZP4e9b6cm0DXn35tkmqvCS0OEcNDTlvRYYHMb6kSkTnJMN4TvFlz7mkVE5/nLXW2
         MYp108ppba52uNfLCaB+u3uj21LXw6bzF0fT3tk9mz6JQJjN1lY2eU3rW3ji7XJ3Nc1/
         XiRjQsyPFE6dotrmKmxOJYnEAOjQgwDwO+tu1ipIfeKhBYdkuM7+eutEs8DIhNwYbz8H
         R17Yh20gCnqt5e8wXavP0GDQYI53v92a+Gydxla5dNiKAGd1Hth7vWkfEgief1Y8USwv
         7o6vVrKN0wAgXInb3CtIk4ml8/0QXW5K6etR34xYWzbRhYXR8FQ9IIZpklpzA/KRucU+
         EvVA==
X-Gm-Message-State: AC+VfDwGHNT3LFGOPLZ0TfviKIevKcKKFs4tGRuhyRQmU2KPQj9ud7GH
        4V48E5iTL7wFlbI31ksg9tVG1mdgqFw=
X-Google-Smtp-Source: ACHHUZ4YWSCL3tISSgyUIyvmgkonkY0mYQ7a9HflVuCeaud0B69gDuj1em1q5JfOfxmkeo+cyF9+bw==
X-Received: by 2002:a92:dd0f:0:b0:335:56cb:a3a with SMTP id n15-20020a92dd0f000000b0033556cb0a3amr1976150ilm.16.1686919767509;
        Fri, 16 Jun 2023 05:49:27 -0700 (PDT)
Received: from debian.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id t191-20020a6381c8000000b0054fe07d2f3dsm3733465pgd.11.2023.06.16.05.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 05:49:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 0F4DF8222705; Fri, 16 Jun 2023 19:49:08 +0700 (WIB)
Date:   Fri, 16 Jun 2023 19:49:08 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Hamza Mahfooz <someguy@effective-light.com>, kvm@vger.kernel.org
Cc:     regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: KVM page-fault on Kernel 6.3.8
Message-ID: <ZIxaRLIfCQ6IK8S1@debian.me>
References: <L2ZBWR.TERFR10NPZ281@effective-light.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oIpjvbCDgnczD2qR"
Content-Disposition: inline
In-Reply-To: <L2ZBWR.TERFR10NPZ281@effective-light.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oIpjvbCDgnczD2qR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 01:25:33AM -0400, Hamza Mahfooz wrote:
> I am seeing the following page-fault on the latest stable kernel:
>=20
> BUG: unable to handle page fault for address: ffffb4ff0cd20034
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 10002a067 P4D 10002a067 PUD 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 7 PID: 2675 Comm: CPU 7/KVM Not tainted 6.3.8-arch1-1 #1
> a1d299e746aebdb27c523dd3bd94aba6f54915c7
> Hardware name: ASUS System Product Name/ProArt X670E-CREATOR WIFI, BIOS 1=
303
> 04/27/2023
> RIP: 0010:try_grab_folio+0x14f/0x370
> Code: 83 f8 04 75 6f 44 89 ee 4c 89 e7 e8 6b bc 0b 00 84 c0 74 60 4c 8b 63
> 08 41 f6 c4 01 0f 85 b0 01 00 00 0f 1f 44 00 00 49 89 dc <41> 8b 44 24 34=
 85
> c0 0f 88 f8 00 00 00 41 8b 44 24 34 85 c0 74 58
> RSP: 0018:ffff9fa98504b948 EFLAGS: 00010086
> RAX: 0000000000000002 RBX: fffff4ff0cd21480 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000001 RDI: fffff4ff0cd21480
> RBP: 0000000000000000 R08: ffff8b2edb510980 R09: 00007f5624253000
> R10: 80000003348008e7 R11: 00007f5624253000 R12: ffffb4ff0cd20000
> R13: 0000000000000001 R14: 0000000000000003 R15: 0000000000000001
> FS: 00007f548a7fc6c0(0000) GS:ffff8b35f83c0000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffb4ff0cd20034 CR3: 0000000113e70000 CR4: 0000000000750ee0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? __die+0x23/0x70
> ? page_fault_oops+0x171/0x4e0
> ? exc_page_fault+0x172/0x180
> ? asm_exc_page_fault+0x26/0x30
> ? try_grab_folio+0x14f/0x370
> internal_get_user_pages_fast+0x883/0x1150
> __iov_iter_get_pages_alloc+0xdd/0x780
> ? kmem_cache_alloc+0x16f/0x330
> ? bio_associate_blkg_from_css+0xcd/0x340
> iov_iter_get_pages+0x1d/0x40
> bio_iov_iter_get_pages+0xa1/0x480
> __blkdev_direct_IO_async+0xc5/0x1b0
> blkdev_read_iter+0x127/0x1d0
> aio_read+0x132/0x210
> ? io_submit_one+0x46a/0x8b0
> io_submit_one+0x46a/0x8b0
> ? kvm_arch_vcpu_put+0x128/0x190 [kvm
> 711ceda1c40511ce22d1f99f4e9e574def76b25e]
> ? kvm_arch_vcpu_ioctl_run+0x579/0x1770 [kvm
> 711ceda1c40511ce22d1f99f4e9e574def76b25e]
> __x64_sys_io_submit+0xad/0x190
> do_syscall_64+0x5d/0x90
> ? __x64_sys_ioctl+0xac/0xd0
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? syscall_exit_to_user_mode+0x1b/0x40
> ? do_syscall_64+0x6c/0x90
> ? do_syscall_64+0x6c/0x90
> entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7f57ac0912ed
> Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff
> 73 01 c3 48 8b 0d 3b 7a 0d 00 f7 d8 64 89 01 48
> RSP: 002b:00007f5427ab97b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
> RAX: ffffffffffffffda RBX: 00007f548a7fc1d0 RCX: 00007f57ac0912ed
> RDX: 00007f5427ab9800 RSI: 0000000000000001 RDI: 00007f57a9d24000
> RBP: 00007f57a9d24000 R08: 0000000000000001 R09: 0000000000000001
> R10: 00007f54740044f0 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000004 R14: 00007f5427ab9800 R15: 000000000000000e
> </TASK>
> Modules linked in: hid_playstation led_class_multicolor ff_memless tun
> snd_seq_dummy snd_hrtimer snd_seq xt_CHECKSUM xt_MASQUERADE xt_conntrack
> ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat nft_chain_nat nf_nat
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables libcrc32c nfnetlink
> bridge stp llc vfat fat snd_hda_codec_realtek snd_hda_codec_generic mt792=
1e
> snd_hda_codec_hdmi mt7921_common snd_usb_audio intel_rapl_msr
> mt76_connac_lib snd_hda_intel intel_rapl_common snd_intel_dspcfg mt76
> snd_usbmidi_lib btusb snd_intel_sdw_acpi edac_mce_amd snd_rawmidi btrtl
> snd_hda_codec btbcm snd_seq_device btintel snd_hda_core kvm_amd mc snd_hw=
dep
> eeepc_wmi btmtk snd_pcm asus_wmi kvm mac80211 bluetooth ledtrig_audio
> atlantic snd_timer i8042 sparse_keymap libarc4 ecdh_generic rapl
> platform_profile serio intel_wmi_thunderbolt i2c_piix4 wmi_bmof pcspkr
> k10temp thunderbolt snd igc ucsi_acpi macsec soundcore cfg80211 typec_ucsi
> mousedev joydev typec roles rfkill gpio_amdpt acpi_cpufreq gpio_generic
> mac_hid dm_multipath
> crypto_user fuse loop bpf_preload ip_tables x_tables ext4 crc32c_generic
> crc16 mbcache jbd2 dm_crypt cbc encrypted_keys trusted asn1_encoder tee
> dm_mod hid_logitech_hidpp hid_logitech_dj usbhid amdgpu crct10dif_pclmul
> crc32_pclmul crc32c_intel polyval_clmulni polyval_generic i2c_algo_bit
> drm_ttm_helper gf128mul nvme ghash_clmulni_intel ttm sha512_ssse3 drm_bud=
dy
> aesni_intel gpu_sched crypto_simd nvme_core drm_display_helper cryptd ccp
> xhci_pci cec nvme_common xhci_pci_renesas video wmi vfio_pci vfio_pci_core
> irqbypass vfio_iommu_type1 vfio iommufd
> CR2: ffffb4ff0cd20034
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:try_grab_folio+0x14f/0x370
> Code: 83 f8 04 75 6f 44 89 ee 4c 89 e7 e8 6b bc 0b 00 84 c0 74 60 4c 8b 63
> 08 41 f6 c4 01 0f 85 b0 01 00 00 0f 1f 44 00 00 49 89 dc <41> 8b 44 24 34=
 85
> c0 0f 88 f8 00 00 00 41 8b 44 24 34 85 c0 74 58
> RSP: 0018:ffff9fa98504b948 EFLAGS: 00010086
> RAX: 0000000000000002 RBX: fffff4ff0cd21480 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000001 RDI: fffff4ff0cd21480
> RBP: 0000000000000000 R08: ffff8b2edb510980 R09: 00007f5624253000
> R10: 80000003348008e7 R11: 00007f5624253000 R12: ffffb4ff0cd20000
> R13: 0000000000000001 R14: 0000000000000003 R15: 0000000000000001
> FS: 00007f548a7fc6c0(0000) GS:ffff8b35f83c0000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffb4ff0cd20034 CR3: 0000000113e70000 CR4: 0000000000750ee0
> PKRU: 55555554
> note: CPU 7/KVM[2675] exited with irqs disabled
>=20
> It seems to appear randomly, so bisecting it would probably be
> difficult. Also, as far as I can tell it seems to be a recent
> regression (i.e. it was introduced in one of the 6.3.y releases).
>=20
>=20

So v6.2.y looks fine (doesn't have this regression)?

--=20
An old man doll... just what I always wanted! - Clara

--oIpjvbCDgnczD2qR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIxaQAAKCRD2uYlJVVFO
o67AAP9yePNIS+oUnlF8iOF2+EFNoNvcuJBbzt95i76ScqSzogEAlnM1EHWq4bEJ
KqGckZBKOfFQoDmAwiM0/1G9CIrt2Q4=
=krTZ
-----END PGP SIGNATURE-----

--oIpjvbCDgnczD2qR--
