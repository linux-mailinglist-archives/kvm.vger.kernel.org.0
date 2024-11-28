Return-Path: <kvm+bounces-32722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3089DB1FD
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42983167868
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E2613777F;
	Thu, 28 Nov 2024 03:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhfTZfPU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A672563;
	Thu, 28 Nov 2024 03:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732765826; cv=none; b=p3tveOIk77lILPpr8JaNm4tIC9PxsqRupnS5T3oFt89B1paiPy/15UC59itxz+GwsIYprtuHlReG1VeQ4ngk9Zi9sKVVeVJmtfwF0Q023J28/XtamvJjTQ7UL9+51fQKABn/xpjSH5kiQMPYLj5SBe2O7no5JOVvNyWtWhFOsoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732765826; c=relaxed/simple;
	bh=MAZ6oOubkeV8uKVIpru62NzGiVZa1Sxs6POJhtfJ5DM=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=FCd81oiGFdyGPua3IuD8ILjjH94ZW/HgKeFSkeDThrJXMPFWGvUYdsfejSXEJZr041U9sekhQNi9nrEuwgeXujccIEauc2adZH4EZj8xJ373W17U0tMBGl4WWOn2bgX6ALbZJlFwJTSwraZ5/G0Y6MW23YPAG2wb/TyuYdTlZBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhfTZfPU; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ea8d322297so343495a91.1;
        Wed, 27 Nov 2024 19:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732765823; x=1733370623; darn=vger.kernel.org;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=31vcA6wmjeIUrXVPA5rqvupaZPVLDuXO8+n6eLn4gus=;
        b=LhfTZfPU7a4NPewaTBan7p+8Kg2Aco3Qj6AI/Jr1FoconcRHlx8X3/lr6xKeJCiMiu
         s8H03h2440UXvmZNAxuGBCiCCt/+f8VerZS8CWLEbQbZY7aaSwxfLgIkxe1V1Okq+MiR
         JbRP6PU/t6qIsPf7eMcv6sM0kgOzzsXiyuvJdec2Ud7LNLQDTa6GA76AYu687IDeTSPC
         RqU0KM+aJ2LnGAn7+ENqgwHbsRdJhd2t44ytq+n7IcsCc2Seb2FkfWjxehmVDbhkjuV7
         d/1RDcbVQ42UzuC9mJ9eMGTinKPjtpyehFD/G1UdEVIxapaUCH+XNEWU1qQz7GpXBldI
         kTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732765823; x=1733370623;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31vcA6wmjeIUrXVPA5rqvupaZPVLDuXO8+n6eLn4gus=;
        b=IeWkvD1GTazaRZ+gB45OTpOH3wAg6k1ZRC1Ut8igfJrgyAoxu3JpDY5+AEjsxRGVVf
         vWDItFKIe2BD/CMrFZy9sP4E24FAX/RhcV6ymRKSt4kvrDLwaiXjB633SJeFAvq2bt0s
         jlZZl0RAI3CLxdZc6czIzTqlknbW5K7ll5sAgq+nsnOWYueiDtk/GLklG5UE30fjowSE
         vlEwXi7ZrekUn7eyFfHLE4diapNNfixNvz0hjfj4CV156GGWwqf15P0YmsxaEEB0DMP2
         wOXHfgxYwk2lZqcYwN8vowOZet9Hbev//KEeGb0RXaiLAZLT9gYuXVJhQXzeDwgfU9hr
         ZJIg==
X-Forwarded-Encrypted: i=1; AJvYcCXYPe9IUOebw/fnaOBfHzMjZYyiPZsPi/IbJBoNaAVYn/0gnJoBvoZ0XijSij32rBAcDWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCLJlGjpgxbdOG71gGBI3iwyKfFk5YELjsVxuHLHRmRy32cwKO
	9Xqc4r3WYKY7KGhiHdmyeqXllCVZJuRs7rjnaPEMkNkLUhDgiZhqKbDLTGjkNBQ=
X-Gm-Gg: ASbGncua6hJvW5akeZcb1V/XRdE09Crae/gSARLhC9nZ6tWGwT3+9kfwl8gp3u3fdHC
	gjS3rgZWYZlM8NVRtheTFmMMgOFwQgX0a/qeXU2VoB/D2YuKVZ2PLHTlN6rXhKo20G9JUVpnrQK
	1VD6BmGv3Fk6t8rgBWDpPpHyTkXaUPbg7mSE5b+vgdh9RvZeoLbICxSKIrCBylaFlrYSC2rTBh7
	2atpHz5//CYVrlCh7jCIjy+LQWY58BjYM0o2nCrMRqRHLP/r1jsTrYXOxA0GfbB2tEeYFvK
X-Google-Smtp-Source: AGHT+IHeHxSGw1aZ1aF6BT8+jqAGy02BbRUO9psMgvM8ZIkaqPEuk656dDTSMArtlS0+FidJKCr8mg==
X-Received: by 2002:a17:90b:1850:b0:2ea:3ab5:cb9d with SMTP id 98e67ed59e1d1-2ee08e9928amr7472257a91.8.1732765823394;
        Wed, 27 Nov 2024 19:50:23 -0800 (PST)
Received: from smtpclient.apple ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee2aff1f3fsm402698a91.10.2024.11.27.19.50.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2024 19:50:23 -0800 (PST)
From: fengnan chang <fengnanchang@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: Deadlock during PCIe hot remove and SPDK exit
Date: Thu, 28 Nov 2024 11:50:09 +0800
References: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
To: linux-pci@vger.kernel.org,
 lukas@wunner.de,
 kvm@vger.kernel.org,
 alex.williamson@redhat.com,
 bhelgaas@google.com
In-Reply-To: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
Message-Id: <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com>
X-Mailer: Apple Mail (2.3774.200.91.1.1)



> 2024=E5=B9=B411=E6=9C=8827=E6=97=A5 14:56=EF=BC=8Cfengnan chang =
<fengnanchang@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Dear PCI maintainers:
>   I'm having a deadlock issue, somewhat similar to a previous one =
https://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10=
@CS1PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM/#t=EF=BC=8C but my kernel =
(6.6.40) already included the fix f5eff55.=20
>   Here is my test process, I=E2=80=99m running kernel with 6.6.40 and =
SPDK v22.05:
>   1. SPDK use vfio driver to takeover two nvme disks, running some io =
in nvme.
>   2. pull out two nvme disks
>   3. Try to kill -9 SPDK process.
>   Then deadlock issue happened. For now I can 100% reproduce this =
problem. I=E2=80=99m not an export in PCI, but I did a brief analysis:
>   irq 149 thread take pci_rescan_remove_lock mutex lock, and wait for =
SPDK to release vfio.
>   irq 148 thread take reset_lock of ctrl A, and wait for =
psi_rescan_remove_lock
>   SPDK process try to release vfio driver, but wait for reset_lock of =
ctrl A.
>=20
>=20
> irq/149-pciehp stack, cat /proc/514/stack,=20
> [<0>] pciehp_unconfigure_device+0x48/0x160 // wait for =
pci_rescan_remove_lock
> [<0>] pciehp_disable_slot+0x6b/0x130       // hold reset_lock of ctrl =
A
> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
> [<0>] pciehp_ist+0x236/0x260
> [<0>] irq_thread_fn+0x1b/0x60
> [<0>] irq_thread+0xed/0x190
> [<0>] kthread+0xe4/0x110
> [<0>] ret_from_fork+0x2d/0x50
> [<0>] ret_from_fork_asm+0x11/0x20
>=20
>=20
> irq/148-pciehp stack, cat /proc/513/stack
> [<0>] vfio_unregister_group_dev+0x97/0xe0 [vfio]     //wait for

My mistake, this is wait for SPDK to release vfio device. This problem =
can reproduce in 6.12.
Besides, My college give me an idea, we can make =
vfio_device_fops_release be async, so when we close fd, it
won=E2=80=99t block, and when we close another fd, it will release  vfio =
device, this stack will not block too, then the deadlock disappears.

Here is my test patch, cc some vfio guys:
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bca..4ebe154a4ae5 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -19,6 +19,7 @@ struct vfio_container;
 struct vfio_device_file {
        struct vfio_device *device;
        struct vfio_group *group;
+       struct work_struct      release_work;

        u8 access_granted;
        u32 devid; /* only valid when iommufd is valid */
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a5a62d9d963f..47e3e3f73d70 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -487,6 +487,22 @@ static bool vfio_assert_device_open(struct =
vfio_device *device)
        return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }

+static void vfio_fops_release_work(struct work_struct *work)
+{
+       struct vfio_device_file *df =3D
+               container_of(work, struct vfio_device_file, =
release_work);
+       struct vfio_device *device =3D df->device;
+
+       if (df->group)
+               vfio_df_group_close(df);
+       else
+               vfio_df_unbind_iommufd(df);
+
+       vfio_device_put_registration(device);
+
+       kfree(df);
+}
+
 struct vfio_device_file *
 vfio_allocate_device_file(struct vfio_device *device)
 {
@@ -497,6 +513,7 @@ vfio_allocate_device_file(struct vfio_device =
*device)
                return ERR_PTR(-ENOMEM);

        df->device =3D device;
+       INIT_WORK(&df->release_work, vfio_fops_release_work);
        spin_lock_init(&df->kvm_ref_lock);

        return df;
@@ -628,16 +645,8 @@ static inline void =
vfio_device_pm_runtime_put(struct vfio_device *device)
 static int vfio_device_fops_release(struct inode *inode, struct file =
*filep)
 {
        struct vfio_device_file *df =3D filep->private_data;
-       struct vfio_device *device =3D df->device;

-       if (df->group)
-               vfio_df_group_close(df);
-       else
-               vfio_df_unbind_iommufd(df);
-
-       vfio_device_put_registration(device);
-
-       kfree(df);
+       schedule_work(&df->release_work);

        return 0;
 }


> [<0>] vfio_pci_core_unregister_device+0x19/0x80 [vfio_pci_core]
> [<0>] vfio_pci_remove+0x15/0x20 [vfio_pci]
> [<0>] pci_device_remove+0x39/0xb0
> [<0>] device_release_driver_internal+0xad/0x120
> [<0>] pci_stop_bus_device+0x5d/0x80
> [<0>] pci_stop_and_remove_bus_device+0xe/0x20
> [<0>] pciehp_unconfigure_device+0x91/0x160   //hold =
pci_rescan_remove_lock, release reset_lock of ctrl B=20
> [<0>] pciehp_disable_slot+0x6b/0x130
> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
> [<0>] pciehp_ist+0x236/0x260             //hold reset_lock of ctrl B=20=

> [<0>] irq_thread_fn+0x1b/0x60
> [<0>] irq_thread+0xed/0x190
> [<0>] kthread+0xe4/0x110
> [<0>] ret_from_fork+0x2d/0x50
> [<0>] ret_from_fork_asm+0x11/0x20
>=20
>=20
> SPDK stack, cat /proc/166634/task/167181/stack
> [<0>] down_write_nested+0x1b7/0x1c0            //wait for reset_lock =
of ctrl A.
> [<0>] pciehp_reset_slot+0x58/0x160
> [<0>] pci_reset_hotplug_slot+0x3b/0x60
> [<0>] pci_reset_bus_function+0x3b/0xb0
> [<0>] __pci_reset_function_locked+0x3e/0x60
> [<0>] vfio_pci_core_disable+0x3ce/0x400 [vfio_pci_core]
> [<0>] vfio_pci_core_close_device+0x67/0xc0 [vfio_pci_core]
> [<0>] vfio_df_close+0x79/0xd0 [vfio]
> [<0>] vfio_df_group_close+0x36/0x70 [vfio]
> [<0>] vfio_device_fops_release+0x20/0x40 [vfio]
> [<0>] __fput+0xec/0x290
> [<0>] task_work_run+0x61/0x90
> [<0>] do_exit+0x39c/0xc40
> [<0>] do_group_exit+0x33/0xa0
> [<0>] get_signal+0xd84/0xd90
> [<0>] arch_do_signal_or_restart+0x2a/0x260
> [<0>] exit_to_user_mode_prepare+0x1c7/0x240
> [<0>] syscall_exit_to_user_mode+0x2a/0x60
> [<0>] do_syscall_64+0x3e/0x90
>=20


