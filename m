Return-Path: <kvm+bounces-11993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 482B387ECCE
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F39C92810AB
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E4253385;
	Mon, 18 Mar 2024 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvHOQ2OW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D553372
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777379; cv=none; b=BhBDtqBGwYvU27XLsej7Xp3AYtNLQGeaA+DFBF82KBAlDIw4hIkEnxwF5XbkSY2msPVGl9+bAPf2xqRbT5k79lK+KlVodHu2D4+P7MUDIC8sICef2j2tgcERze/X/4cO4sa/d2sqT2W0WOR3HL2QPOZH8LrwJ0p9UOGELoJTsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777379; c=relaxed/simple;
	bh=PNgcgM18UXQqFybgzZBawDbnwBLbJ/N6Z/A0vIltoVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=eIOwWC4jPu6SgbTVieaBZHphZ2cU05ATKuOtuPUxBdibKZTD/vgiA35sEZpYfYtMd0UpjZSYl7LdgQ1CLtYz6cKLTWHZjOBfIeml7Yq2UEx0Edr48SYOHhREJ3ewtzZv8pAEEQpu7I50vzneyz9Z7e/TIiNoun3OnAlzkQdwXhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KvHOQ2OW; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6e691434251so570883a34.2
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 08:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710777376; x=1711382176; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDx8mBxXcp2d5aXtGauBK5z2vVssjhwuWERwFDCQrNM=;
        b=KvHOQ2OWcvjuLLg9d/XTZ94gCMXH7LQ/4VNaqwYt9G54vV1uB6CmCvx1KnDbOqr/Wq
         lOvnQn68Ajeq7PSD36QRuBaSMi/KM2LVd25EWZQbJx1QdhpmeJQPE5VTvqJEE8yds3Ew
         BEmKo1hYxYNpCN9wxWsVaVzKWGyI42LmhGZEAd8a/ac/pK/kyEiSQ+55qmD5a6NcSFPp
         uX0POs/rxkA/zkRQAGyZ4T6MKiMKAcEHkHJC2WXZYdWcAVqVZyGVSAOLE2b7rJjEfJ/4
         o4SHKYQLAwA2HH8RdqV5pZ7jGAIMwhldN808TAnqhtDFx5yM2+qcnXP66KdszVmWzPUZ
         5kSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710777376; x=1711382176;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xDx8mBxXcp2d5aXtGauBK5z2vVssjhwuWERwFDCQrNM=;
        b=SDa/bIYfuVrmYLkMPmKigcOzG2ueYCrmZcFtAVOAmE+eevzZMpadLtBBAIfJq1YnTg
         YS9auMTraY1awW4aRULmyFub4H/OqvXrdYu9J14iexUtD03Hm+XxUOHx03CIfRR7GuAi
         t2bHLSfSAPXQiigQo8WutoSgLwbymQctIPxYVWkqtI9TjCtIJ6Bvn5a/YpX7tFoKNT0A
         6yzXkG25v2O7MUPPpBeXZZ46Prr4qyB+guBZJA5HDVtJdsjmmhKjy+WajInpskH1nVpz
         1OL2tvRgknc7+3Sao6KZ8PUlCPZHigIKl3WY9sAc0U78pslcQH5NoXkMuMc1TYcmbPat
         Ge5w==
X-Gm-Message-State: AOJu0YzYee7LIN0dBaQH9tY485UhqAMyC23FQhaEEhawfJCrYII10Niw
	ZAPo7mC0aGzQ5UQGTSykFAIIrwoMiHt3P66KYKmk5DDzPm31DoFPYVUEjMtgP4w5YPOnO6aSuS1
	vBfjAdXaXlutMrRr/gMzDoiqJdDDj3IMStK99EQ==
X-Google-Smtp-Source: AGHT+IHF6lmaEr04N4gYLvghjhJCM3EXLv2I/6/RI20hIBReLNb10+XnrebK5C2XDe5DtctREkbx0pJambIzx12Zwz4=
X-Received: by 2002:a05:6870:2014:b0:221:a9ee:300f with SMTP id
 o20-20020a056870201400b00221a9ee300fmr14482977oab.54.1710777376068; Mon, 18
 Mar 2024 08:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
In-Reply-To: <1710566754-3532-1-git-send-email-zhanglikernel@gmail.com>
From: li zhang <zhanglikernel@gmail.com>
Date: Mon, 18 Mar 2024 23:56:05 +0800
Message-ID: <CAAa-AGnXP64=5=rRj5z0FnLkCjEXCcGvr75aHHDRZRRGSwVTSw@mail.gmail.com>
Subject: Re: [PATCH]virtio-pci: Check if is_avq is NULL
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add details about test cases

Create a guest named guest1 in KVM,
In the host machine, run the following command.
#create share-device.xml and write the following text (host)
qemu-img create -f qcow2 /root/share-device.qcow2 20G


#create share-device.xml with following message(hosts)
<disk type=3D'file' device=3D'disk'>
    <driver name=3D'qemu' type=3D'qcow2' cache=3D'writeback' io=3D'threads'=
/>
    <source file=3D'/root/share-device.qcow2'/>
    <target dev=3D'vdb' bus=3D'virtio'/>
</disk>


#attach device to guest1(hosts)
virsh attach-device guest1 share-device.xml --config --live

#detach device to guest1(hosts)
virsh detach-device guest1 share-device.xml --config --live

Before patch, guest1 crashed
[   64.432236] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[   64.432734] #PF: supervisor instruction fetch in kernel mode
[   64.433142] #PF: error_code(0x0010) - not-present page
[   64.433497] PGD 0 P4D 0
[   64.433686] Oops: 0010 [#1] PREEMPT SMP PTI
[   64.433977] CPU: 3 PID: 85 Comm: kworker/u16:1 Not tainted 6.8.0+ #3
[   64.434417] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   64.434818] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
[   64.435221] RIP: 0010:0x0
[   64.435427] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[   64.435916] RSP: 0018:ffffaf80003e3bd8 EFLAGS: 00010206
[   64.436260] RAX: 0000000000000000 RBX: ffff9dd8c26e4800 RCX: 00000000000=
00000
[   64.436662] RDX: 0000000080000000 RSI: 0000000000000000 RDI: ffff9dd8c26=
e4800
[   64.437061] RBP: ffff9dd8c4bdc900 R08: 0000000000000000 R09: 00000000000=
00000
[   64.437459] R10: 0000000000000020 R11: 000000000000000f R12: ffff9dd8c26=
e4b10
[   64.437860] R13: ffff9dd8c26e4b10 R14: ffff9dd8c26e4810 R15: 00000000000=
00000
[   64.438263] FS:  0000000000000000(0000) GS:ffff9dd9f7d80000(0000)
knlGS:0000000000000000
[   64.438706] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   64.439033] CR2: ffffffffffffffd6 CR3: 0000000103d96002 CR4: 00000000003=
706f0
[   64.439430] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   64.439825] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   64.440227] Call Trace:
[   64.440373]  <TASK>
[   64.440499]  ? __die_body+0x1b/0x60
[   64.440705]  ? page_fault_oops+0x158/0x4f0
[   64.440954]  ? __mod_zone_page_state+0x6e/0xb0
[   64.441236]  ? exc_page_fault+0x69/0x150
[   64.441455]  ? asm_exc_page_fault+0x22/0x30
[   64.441721]  vp_del_vqs+0x6b/0x280 [virtio_pci]
[   64.441977]  virtblk_remove+0x57/0x80 [virtio_blk]
[   64.442249]  virtio_dev_remove+0x3a/0x90 [virtio]
[   64.442516]  device_release_driver_internal+0xaa/0x140
[   64.442835]  bus_remove_device+0xbf/0x130
[   64.443062]  device_del+0x156/0x3a0
[   64.443265]  device_unregister+0x13/0x60
[   64.443497]  unregister_virtio_device+0x11/0x20 [virtio]
[   64.443806]  virtio_pci_remove+0x3d/0x80 [virtio_pci]
[   64.444112]  pci_device_remove+0x33/0xa0
[   64.444380]  device_release_driver_internal+0xaa/0x140
[   64.444676]  pci_stop_bus_device+0x6c/0x90
[   64.444914]  pci_stop_and_remove_bus_device+0xe/0x20
[   64.445192]  disable_slot+0x49/0x90
[   64.445421]  acpiphp_disable_and_eject_slot+0x15/0x90
[   64.445749]  acpiphp_hotplug_notify+0x14f/0x2a0
[   64.446017]  ? __pfx_acpiphp_hotplug_notify+0x10/0x10
[   64.446318]  acpi_device_hotplug+0xc1/0x4a0
[   64.446556]  acpi_hotplug_work_fn+0x1a/0x30
[   64.446795]  process_one_work+0x158/0x370
[   64.447023]  ? __pfx_worker_thread+0x10/0x10
[   64.447272]  process_scheduled_works+0x42/0x60
[   64.447527]  worker_thread+0x110/0x270
[   64.447739]  ? __pfx_worker_thread+0x10/0x10
[   64.447985]  kthread+0xeb/0x120
[   64.448174]  ? __pfx_kthread+0x10/0x10
[   64.448388]  ret_from_fork+0x2d/0x50
[   64.448595]  ? __pfx_kthread+0x10/0x10
[   64.448812]  ret_from_fork_asm+0x1a/0x30
[   64.449079]  </TASK>
[   64.449210] Modules linked in: ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat
ebtable_broute ip6table_nat ip6table_mangle ip6table_security
ip6table_raw iptable_nat nf_nat iptable_mangle iptable_security
iptable_raw nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink rfkill ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter sunrpc intel_rapl_msr intel_rapl_common
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3
aesni_intel crypto_simd virtio_rng cryptd virtio_balloon sg pcspkr
joydev floppy i2c_piix4 ip_tables xfs libcrc32c sr_mod cdrom
virtio_net net_failover ata_generic failover virtio_blk virtio_console
pata_acpi virtio_pci virtio ata_piix virtio_pci_legacy_dev
virtio_pci_modern_dev crc32c_intel libata serio_raw virtio_ring
dm_mirror dm_region_hash dm_log dm_mod fuse
[   64.453398] CR2: 0000000000000000
[   64.453587] ---[ end trace 0000000000000000 ]---
[   64.453869] RIP: 0010:0x0
[   64.454018] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[   64.454405] RSP: 0018:ffffaf80003e3bd8 EFLAGS: 00010206
[   64.454719] RAX: 0000000000000000 RBX: ffff9dd8c26e4800 RCX: 00000000000=
00000
[   64.455109] RDX: 0000000080000000 RSI: 0000000000000000 RDI: ffff9dd8c26=
e4800
[   64.455523] RBP: ffff9dd8c4bdc900 R08: 0000000000000000 R09: 00000000000=
00000
[   64.455938] R10: 0000000000000020 R11: 000000000000000f R12: ffff9dd8c26=
e4b10
[   64.456330] R13: ffff9dd8c26e4b10 R14: ffff9dd8c26e4810 R15: 00000000000=
00000
[   64.456753] FS:  0000000000000000(0000) GS:ffff9dd9f7d80000(0000)
knlGS:0000000000000000
[   64.457222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   64.457535] CR2: ffffffffffffffd6 CR3: 0000000103d96002 CR4: 00000000003=
706f0
[   64.457951] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   64.458340] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   64.458761] Kernel panic - not syncing: Fatal exception
[   64.459396] Kernel Offset: 0x22400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   64.459988] ---[ end Kernel panic - not syncing: Fatal exception ]---




But after applying the patch, everything seems to be normal.

Li Zhang <zhanglikernel@gmail.com> =E4=BA=8E2024=E5=B9=B43=E6=9C=8816=E6=97=
=A5=E5=91=A8=E5=85=AD 13:26=E5=86=99=E9=81=93=EF=BC=9A

>
> [bug]
> In the virtio_pci_common.c function vp_del_vqs, vp_dev->is_avq is involve=
d
> to determine whether it is admin virtqueue, but this function vp_dev->is_=
avq
>  may be empty. For installations, virtio_pci_legacy does not assign a val=
ue
>  to vp_dev->is_avq.
>
> [fix]
> Check whether it is vp_dev->is_avq before use.
>
> [test]
> Test with virsh Attach device
> Before this patch, the following command would crash the guest system
>
> After applying the patch, everything seems to be working fine.
>
> Signed-off-by: Li Zhang <zhanglikernel@gmail.com>
> ---
>  drivers/virtio/virtio_pci_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_p=
ci_common.c
> index b655fcc..3c18fc1 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -236,7 +236,7 @@ void vp_del_vqs(struct virtio_device *vdev)
>         int i;
>
>         list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> -               if (vp_dev->is_avq(vdev, vq->index))
> +               if (vp_dev->is_avq && vp_dev->is_avq(vdev, vq->index))
>                         continue;
>
>                 if (vp_dev->per_vq_vectors) {
> --
> 1.8.3.1
>

