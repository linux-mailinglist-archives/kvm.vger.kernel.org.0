Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30ACC713976
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 14:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjE1Mop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 08:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjE1Moo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 08:44:44 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF1DBC;
        Sun, 28 May 2023 05:44:40 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso1933044b3a.2;
        Sun, 28 May 2023 05:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685277880; x=1687869880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vdBiVqoVVm+jnimdyoFfVoBORYE0ntzEIfUVTH+f7xs=;
        b=Ei0d4QReYR/7syQBnO9+F7e5uKr3pBg92jdwv/XpixwH59/CJYue10r0vBKlkRd+jO
         G5NWzpkTpaQCbaNHmA8Y9anzHMB+x2iWndjU+xyF8jUmyYZ1VZx9++mC9E6dW3Z7Wush
         HP3/0DnS078KONr193Ik3ujVUjXGDal87GlnOLy8SKyGKDLlqtclflEBFPWE7JiJjflR
         3vn+lenXB3rhR1Lrse2WG16dZP45M9DVnMIx+xvtfteg0F+CBzIhKHuGrsj4zwAennYf
         KUo98DbLJQ/WUNjOho9ND0B92ASnaU8iE2fkSDWZTGQU8+s7273nXkSvyYvejwTPHlIB
         yItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685277880; x=1687869880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdBiVqoVVm+jnimdyoFfVoBORYE0ntzEIfUVTH+f7xs=;
        b=aYKJv6Fy/BXvDz9FEg/96vyqa5rIh+nby6LdLDXssVQtrXVDwLtz2/diA/4ogHB2XZ
         o234r9oDlfmwu5NioCKszGRnTpWWFPuuZl8kDhHQj/704ESTBKaCkR2dh3skcdstRNOs
         HXUi57nn6FIb1S+Lo/CmLk54jJC0/BnkXDtsBIv0ZwGGRYr4oc1a63bebjxED40kEd67
         NdCWE7BBEVMqtVnxlVYEOhR/yrEc9FHNJLZMndX7uVbtJEHrjXCH6vMAK6sVwBMnehSI
         5jQs0U3+LaanS3HAQU4rkjDMwKl9BBAVBNKiMnHiHE3aunYTLgjI2wNtqF9yeMTTzG52
         BSYw==
X-Gm-Message-State: AC+VfDzXkMUY9Ul3baJD70TqLe294J+YwNPVWdR8yBNMPS7r1yoqg2cW
        ocwzFPSDSjzfhGP/87Y3k2Q=
X-Google-Smtp-Source: ACHHUZ788sEwzqANJ/a40crm0YLJizUtTGq521AgVje/RRAmWETPweSJPj1+oEQ2nBIvEn2WUd9yCA==
X-Received: by 2002:a05:6a20:7d9a:b0:10d:1abb:e31 with SMTP id v26-20020a056a207d9a00b0010d1abb0e31mr6594862pzj.50.1685277879531;
        Sun, 28 May 2023 05:44:39 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id s132-20020a63778a000000b00502fd70b0bdsm5514967pgc.52.2023.05.28.05.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 05:44:39 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 50BC81069B8; Sun, 28 May 2023 19:44:35 +0700 (WIB)
Date:   Sun, 28 May 2023 19:44:34 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Fabio Coatti <fabio.coatti@gmail.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev, kvm@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: WARNING trace at kvm_nx_huge_page_recovery_worker on 6.3.4
Message-ID: <ZHNMsmpo2LWjnw1A@debian.me>
References: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FgXOz0BYZYXzwA2t"
Content-Disposition: inline
In-Reply-To: <CADpTngX9LESCdHVu_2mQkNGena_Ng2CphWNwsRGSMxzDsTjU2A@mail.gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--FgXOz0BYZYXzwA2t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 09:43:17AM +0200, Fabio Coatti wrote:
> Hi all,
> I'm using vanilla kernels on a gentoo-based laptop and since 6.3.2 I'm
> getting the kernel log  below when using kvm VM on my box.
> I know, kernel is tainted but avoiding to load nvidia driver could
> make things complicated on my side; if needed for debug I can try to
> avoid it.
>=20
> Not sure which other infos can be relevant in this context; if you
> need more details just let me know, happy to provide them.
>=20
> [Fri May 26 09:16:35 2023] ------------[ cut here ]------------
> [Fri May 26 09:16:35 2023] WARNING: CPU: 5 PID: 4684 at
> kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
> [Fri May 26 09:16:35 2023] Modules linked in: vhost_net vhost
> vhost_iotlb tap tun tls rfcomm snd_hrtimer snd_seq xt_CHECKSUM
> algif_skcipher xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4
> ip6table_mangle ip6table_nat ip6table_filter ip6_tables iptable_mangle
> iptable_nat nf_nat iptable_filter ip_tables bpfilter bridge stp llc
> rmi_smbus rmi_core bnep squashfs sch_fq_codel nvidia_drm(POE)
> intel_rapl_msr vboxnetadp(OE) vboxnetflt(OE) nvidia_modeset(POE)
> mei_pxp mei_hdcp rtsx_pci_sdmmc vboxdrv(OE) mmc_core intel_rapl_common
> intel_pmc_core_pltdrv intel_pmc_core snd_ctl_led intel_tcc_cooling
> snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal
> intel_powerclamp btusb btrtl snd_usb_audio btbcm btmtk kvm_intel
> btintel snd_hda_intel snd_intel_dspcfg snd_usbmidi_lib snd_hda_codec
> snd_rawmidi snd_hwdep bluetooth snd_hda_core snd_seq_device kvm
> snd_pcm thinkpad_acpi iwlmvm mousedev ledtrig_audio uvcvideo snd_timer
> ecdh_generic irqbypass crct10dif_pclmul crc32_pclmul polyval_clmulni
> snd think_lmi joydev mei_me ecc uvc
> [Fri May 26 09:16:35 2023]  polyval_generic rtsx_pci iwlwifi
> firmware_attributes_class psmouse wmi_bmof soundcore intel_pch_thermal
> mei platform_profile input_leds evdev nvidia(POE) coretemp hwmon
> akvcam(OE) videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videodev
> videobuf2_common mc loop nfsd auth_rpcgss nfs_acl efivarfs dmi_sysfs
> dm_zero dm_thin_pool dm_persistent_data dm_bio_prison dm_service_time
> dm_round_robin dm_queue_length dm_multipath dm_delay virtio_pci
> virtio_pci_legacy_dev virtio_pci_modern_dev virtio_blk virtio_console
> virtio_balloon vxlan ip6_udp_tunnel udp_tunnel macvlan virtio_net
> net_failover failover virtio_ring virtio fuse overlay nfs lockd grace
> sunrpc linear raid10 raid1 raid0 dm_raid raid456 async_raid6_recov
> async_memcpy async_pq async_xor async_tx md_mod dm_snapshot dm_bufio
> dm_crypt trusted asn1_encoder tpm rng_core dm_mirror dm_region_hash
> dm_log firewire_core crc_itu_t hid_apple usb_storage ehci_pci ehci_hcd
> sr_mod cdrom ahci libahci libata
> [Fri May 26 09:16:35 2023] CPU: 5 PID: 4684 Comm: kvm-nx-lpage-re
> Tainted: P     U     OE      6.3.4-cova #1
> [Fri May 26 09:16:35 2023] Hardware name: LENOVO
> 20EQS58500/20EQS58500, BIOS N1EET98W (1.71 ) 12/06/2022
> [Fri May 26 09:16:35 2023] RIP:
> 0010:kvm_nx_huge_page_recovery_worker+0x38c/0x3d0 [kvm]
> [Fri May 26 09:16:35 2023] Code: 48 8b 44 24 30 4c 39 e0 0f 85 1b fe
> ff ff 48 89 df e8 2e ab fb ff e9 23 fe ff ff 49 bc ff ff ff ff ff ff
> ff 7f e9 fb fc ff ff <0f> 0b e9 1b ff ff ff 48 8b 44 24 40 65 48 2b 04
> 25 28 00 00 00 75
> [Fri May 26 09:16:35 2023] RSP: 0018:ffff8e1a4403fe68 EFLAGS: 00010246
> [Fri May 26 09:16:35 2023] RAX: 0000000000000000 RBX: ffff8e1a42bbd000
> RCX: 0000000000000000
> [Fri May 26 09:16:35 2023] RDX: 0000000000000000 RSI: 0000000000000000
> RDI: 0000000000000000
> [Fri May 26 09:16:35 2023] RBP: ffff8b4e9a56d930 R08: 0000000000000000
> R09: ffff8b4e9a56d8a0
> [Fri May 26 09:16:35 2023] R10: 0000000000000000 R11: 0000000000000001
> R12: ffff8e1a4403fe98
> [Fri May 26 09:16:35 2023] R13: 0000000000000001 R14: ffff8b4d9c432e80
> R15: 0000000000000010
> [Fri May 26 09:16:35 2023] FS:  0000000000000000(0000)
> GS:ffff8b5cdf740000(0000) knlGS:0000000000000000
> [Fri May 26 09:16:35 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Fri May 26 09:16:35 2023] CR2: 00007efeac53d000 CR3: 0000000978c2c003
> CR4: 00000000003726e0
> [Fri May 26 09:16:35 2023] Call Trace:
> [Fri May 26 09:16:35 2023]  <TASK>
> [Fri May 26 09:16:35 2023]  ?
> __pfx_kvm_nx_huge_page_recovery_worker+0x10/0x10 [kvm]
> [Fri May 26 09:16:35 2023]  kvm_vm_worker_thread+0x106/0x1c0 [kvm]
> [Fri May 26 09:16:35 2023]  ? __pfx_kvm_vm_worker_thread+0x10/0x10 [kvm]
> [Fri May 26 09:16:35 2023]  kthread+0xd9/0x100
> [Fri May 26 09:16:35 2023]  ? __pfx_kthread+0x10/0x10
> [Fri May 26 09:16:35 2023]  ret_from_fork+0x2c/0x50
> [Fri May 26 09:16:35 2023]  </TASK>
> [Fri May 26 09:16:35 2023] ---[ end trace 0000000000000000 ]---

Thanks for the regression report. I'm adding it to regzbot:

#regzbot ^introduced: v6.3.1..v6.3.2
#regzbot title: WARNING trace at kvm_nx_huge_page_recovery_worker when open=
ing a new tab in Chrome

Fabio, can you also check the mainline (on guest)?

--=20
An old man doll... just what I always wanted! - Clara

--FgXOz0BYZYXzwA2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHNMrQAKCRD2uYlJVVFO
oxP3AQCPFX9pu/XgcJVkfOdY7LEnE4zs39RKAHpy8/DSJOcC8QEAv4DhntaLH1yu
TyYpM6RJKkjNjib0oEV1juumRo6l0gg=
=BCZz
-----END PGP SIGNATURE-----

--FgXOz0BYZYXzwA2t--
