Return-Path: <kvm+bounces-32914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4FF9E17A7
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0AA0285004
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9A81E04AD;
	Tue,  3 Dec 2024 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHmruFRv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00461E048F;
	Tue,  3 Dec 2024 09:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733218304; cv=none; b=cylgI681LsxK1LqwCoR/aj+s2F3Wllueb+Mya7RtOwCkEVaRTNE7AORSKGgvr/GhEGRG3T+Tv4gT1wqAqgwGUTNkGykq+blMVpinXSCKQ3gsF9AHqKbDDc/qZr2cv4u2ABJSNuRrkRCkjV4vfiT8ACbnYjajaihOh9ciU1d+UFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733218304; c=relaxed/simple;
	bh=glRCLc+cPx6hgmpW5eObPFWRRoryr9yupVVMR7eKhsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8sgT/aAJFG+2TnO1A5fe/R6EHSuMh4F1GvI+l+kDapwx/JRUvd1G3z2OBN9gYBsfCEESPxBPnJcQ6WYtTMUh96if6veqeVNHnB9q0tS1SJdSHb8YXD8ndWjTcF31dJCVrarsIPxF/D+jiZrkfwOFHblHryNHcCeVG6tt8SzASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHmruFRv; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-515318b24adso1347342e0c.2;
        Tue, 03 Dec 2024 01:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733218301; x=1733823101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HebhGXAydlfD2VfTz/JYtr/r1L/d/HBK2kw1Ghgfn8=;
        b=JHmruFRvFAwaxgJmYbId5m3/KPTVjvS6TDQEeiNcjssnHpJkE5gGzkgso/0BP8s9s2
         ECCmRrdDlI/50Ncw0LQHgQd7jkrtAWoScmoIW55t2BhlbQEHR22IOpNWwW3vRuEWwVy7
         vkiyaOQ4z86Y+9th6Y97SigCXt1oWdW0Tuwpzlbpr7Ife8LDXJOy5d6dvlZKR4alOQm4
         DFsCAKnyqRN6YXGoPyhgWiPIxt0G35gAhKEgyF+GDkjeCXW5CU+zMvW5NHW8J2GPKM4M
         Qw2M6v+PpNunxAFAt4e2qRt6Ldsq/JKEfSBnc3ipVLDBjqOq/+07OVJTshQB8Dz4KwK6
         IcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733218301; x=1733823101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HebhGXAydlfD2VfTz/JYtr/r1L/d/HBK2kw1Ghgfn8=;
        b=l9EQRzdwH6X5U5QLg+cieXm6bGj4sCaJSiXb1ada7y00T1awENyUyka4gaaSiZDDjL
         5TbrSGChzm1x8CRKVjgMKoqAhpTBaBbdoVnnuB65Gj9TSUzbO4oD1jh9gsA8huBRgVrG
         oI+HzDY3/z32YCYm0FNdVGF+TbfHvhYRoG2OLJas8SkYrSq6Djt93DolY2ER/N30BauJ
         v3MUPTB5XYQpQm+24YNN/nUAGQjPotpW/GjOjQaTrKAzPd3xotLlGuCnPS/IvN34x3Y+
         w9wjN2B45rCHPbX5qeT2CybzEpfoKHx2OfeSf7sezxCLsyFVeEnPHOf3wXlzwsbjW9gL
         CoVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl0uDLQErOA1AxnWhABgknODOxwcSynbIoHuz1KfVSpW8AftJJiHUGOycT6VDhV+Y/xvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0uoPswU99s81oG+M/Yw4MPcRCHrrw5ncsBIMXFpJTsmiTTK7R
	DeJ42yKb6r4hxU4dJmf6Z11iUb+ZuqwzAinjy41arIbS71jpLCZHWcfAr/fWcodKB+GVmqZYahn
	9r56IIQofiSlbTeRAC8neOKhS3yo=
X-Gm-Gg: ASbGncucNDAZ518yG3NzvFvi1UtSVoI63853y2vzmzzK/RwWlg6mhO+myO3PEPG70dz
	8G1zfVEmEiEPX2wR5JdsalMkvH8NOzcQi
X-Google-Smtp-Source: AGHT+IFCi/pLCqnLN6Jjn/yKWVwMrn+YKQezo6Ss+c6eBdS5BXGqRdHKRYY9DM3EeOQd3n9/eDjwq04kAPKZpF8rtaA=
X-Received: by 2002:a05:6122:35c3:b0:515:c854:d3dd with SMTP id
 71dfb90a1353d-515c854de17mr284073e0c.6.1733218301411; Tue, 03 Dec 2024
 01:31:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
 <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com> <5b2b0211-81d9-4ec9-98d5-b39a84581ac0@intel.com>
 <CALWNXx9gwDZASU6Hm68hz05P2EcB0BgqPnWKkUaAK_BNAqj8mg@mail.gmail.com> <6e49b1cb-08ab-4fb0-a89e-c78164309ef9@intel.com>
In-Reply-To: <6e49b1cb-08ab-4fb0-a89e-c78164309ef9@intel.com>
From: fengnan chang <fengnanchang@gmail.com>
Date: Tue, 3 Dec 2024 17:31:30 +0800
Message-ID: <CALWNXx96PkhiMdETE7RwYXQBf4o6qDrmQ8oEkhJFuzzqg23A4w@mail.gmail.com>
Subject: Re: Deadlock during PCIe hot remove and SPDK exit
To: Yi Liu <yi.l.liu@intel.com>
Cc: linux-pci@vger.kernel.org, lukas@wunner.de, kvm@vger.kernel.org, 
	alex.williamson@redhat.com, bhelgaas@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 1:31=E2=80=AFPM Yi Liu <yi.l.liu@intel.com> wrote:
>
> On 2024/12/2 11:25, fengnan chang wrote:
> > On Fri, Nov 29, 2024 at 4:00=E2=80=AFPM Yi Liu <yi.l.liu@intel.com> wro=
te:
> >>
> >> On 2024/11/28 11:50, fengnan chang wrote:
> >>>
> >>>
> >>>> 2024=E5=B9=B411=E6=9C=8827=E6=97=A5 14:56=EF=BC=8Cfengnan chang <fen=
gnanchang@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Dear PCI maintainers:
> >>>>     I'm having a deadlock issue, somewhat similar to a previous one =
https://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10@=
CS1PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM/#t=EF=BC=8C but my kernel (6.6.40=
) already included the fix f5eff55.
> >>
> >> The previous bug was solved by the below commit.
> >>
> >> commit f5eff5591b8f9c5effd25c92c758a127765f74c1
> >> Author: Lukas Wunner <lukas@wunner.de>
> >> Date:   Tue Apr 11 08:21:02 2023 +0200
> >>
> >>       PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lo=
ck
> >>
> >
> > Yes, my kernel version included this fix.
> >
> >>       In 2013, commits
> >>
> >>         2e35afaefe64 ("PCI: pciehp: Add reset_slot() method")
> >>         608c388122c7 ("PCI: Add slot reset option to pci_dev_reset()")
> >>
> >>       amended PCIe hotplug to mask Presence Detect Changed events duri=
ng a
> >>       Secondary Bus Reset.  The reset thus no longer causes gratuitous=
 slot
> >>       bringdown and bringup.
> >>
> >>       However the commits neglected to serialize reset with code paths=
 reading
> >>       slot registers.  For instance, a slot bringup due to an earlier =
hotplug
> >>       event may see the Presence Detect State bit cleared during a con=
current
> >>       Secondary Bus Reset.
> >>
> >>       In 2018, commit
> >>
> >>         5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")
> >>
> >>       retrofitted the missing locking.  It introduced a reset_lock whi=
ch
> >>       serializes a Secondary Bus Reset with other parts of pciehp.
> >>
> >>       Unfortunately the locking turns out to be overzealous:  reset_lo=
ck is
> >>       held for the entire enumeration and de-enumeration of hotplugged=
 devices,
> >>       including driver binding and unbinding.
> >>
> >>       Driver binding and unbinding acquires device_lock while the rese=
t_lock
> >>       of the ancestral hotplug port is held.  A concurrent Secondary B=
us Reset
> >>       acquires the ancestral reset_lock while already holding the devi=
ce_lock.
> >>       The asymmetric locking order in the two code paths can lead to A=
B-BA
> >>       deadlocks.
> >>
> >>       Michael Haeuptle reports such deadlocks on simultaneous hot-remo=
val and
> >>       vfio release (the latter implies a Secondary Bus Reset):
> >>
> >>         pciehp_ist()                                    # down_read(re=
set_lock)
> >>           pciehp_handle_presence_or_link_change()
> >>             pciehp_disable_slot()
> >>               __pciehp_disable_slot()
> >>                 remove_board()
> >>                   pciehp_unconfigure_device()
> >>                     pci_stop_and_remove_bus_device()
> >>                       pci_stop_bus_device()
> >>                         pci_stop_dev()
> >>                           device_release_driver()
> >>                             device_release_driver_internal()
> >>                               __device_driver_lock()    # device_lock(=
)
> >>
> >>         SYS_munmap()
> >>           vfio_device_fops_release()
> >>             vfio_device_group_close()
> >>               vfio_device_close()
> >>                 vfio_device_last_close()
> >>
> >>
> >>>>     Here is my test process, I=E2=80=99m running kernel with 6.6.40 =
and SPDK v22.05:
> >>>>     1. SPDK use vfio driver to takeover two nvme disks, running some=
 io in nvme.
> >>>>     2. pull out two nvme disks
> >>>>     3. Try to kill -9 SPDK process.
> >>>>     Then deadlock issue happened. For now I can 100% reproduce this =
problem. I=E2=80=99m not an export in PCI, but I did a brief analysis:
> >>>>     irq 149 thread take pci_rescan_remove_lock mutex lock, and wait =
for SPDK to release vfio.
> >>>>     irq 148 thread take reset_lock of ctrl A, and wait for psi_resca=
n_remove_lock
> >>>>     SPDK process try to release vfio driver, but wait for reset_lock=
 of ctrl A.
> >>>>
> >>>>
> >>>> irq/149-pciehp stack, cat /proc/514/stack,
> >>>> [<0>] pciehp_unconfigure_device+0x48/0x160 // wait for pci_rescan_re=
move_lock
> >>>> [<0>] pciehp_disable_slot+0x6b/0x130       // hold reset_lock of ctr=
l A
> >>>> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
> >>>> [<0>] pciehp_ist+0x236/0x260
> >>>> [<0>] irq_thread_fn+0x1b/0x60
> >>>> [<0>] irq_thread+0xed/0x190
> >>>> [<0>] kthread+0xe4/0x110
> >>>> [<0>] ret_from_fork+0x2d/0x50
> >>>> [<0>] ret_from_fork_asm+0x11/0x20
> >>>>
> >>>>
> >>>> irq/148-pciehp stack, cat /proc/513/stack
> >>>> [<0>] vfio_unregister_group_dev+0x97/0xe0 [vfio]     //wait for
> >>>
> >>> My mistake, this is wait for SPDK to release vfio device. This proble=
m can reproduce in 6.12.
> >>> Besides, My college give me an idea, we can make vfio_device_fops_rel=
ease be async, so when we close fd, it
> >>> won=E2=80=99t block, and when we close another fd, it will release  v=
fio device, this stack will not block too, then the deadlock disappears.
> >>>
> >>
> >> In the hotplug path, vfio needs to notify userspace to stop the usage =
of
> >> this device and release reference on the vfio_device. When the last
> >> refcount is released, the wait in the vfio_unregister_group_dev() will=
 be
> >> unblocked. It is the vfio_device_fops_release() either userspace exits=
 or
> >> userspace explicitly close the vfio device fd. Your below test patch m=
oves
> >> the majority of the vfio_device_fops_release() out of the existing pat=
h.
> >> I don't see a reason why it can work so far.
> >
> > Forgive my poor English. Let me explain in more detail.
> > irq 149 thread take pci_rescan_remove_lock mutex lock, take reset_lock
> > of ctrl B and release reset_lock of ctrl B. Then wait for SPDK to
> > release vfio refcount connected to ctrl B.
> > irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_remov=
e_lock.
>
> it's 148 which holds pci_rescan_remove_lock and wait for the last refcoun=
t
> of vfio_device.
>
> > SPDK process exit, and try to release vfio refcount connected to ctrl
> > A, but need to wait for reset_lock of ctrl A.  Since SPDK is blocked
> > here, it won=E2=80=99t release vfio refcount connected to ctrl B. So th=
e
> > deadlock is happening.
>
> but I got you now. So the SPDK process exit thread closes the vfio_device
> A and B sequentially. The vfio_device A file release is blocked by the 14=
9
> while 149 is blocked by the pci_rescan_remove_lock which is held by 148.
> 148 is waiting for the vfio_device B's refcount which is done in
> vfio_device B's file release.  The vfio_device B file release is not done
> because of the exit thread is dealing with vfio_device A. So this should =
be
> related to timing. Did you see any difference w.r.t. the order of pluggin=
g
> out the devices? Maybe you can try something different to double confirm
> it. e.g. plugging out the devices as the order of how they are listed in
> the QEMU cmdline.

Yes, if the order of plugging out the device changed, this problem
would also disappear.
But in the real world, we encounter problems because the ssd disk is
broken, so I couldn't
change the order.

>
> > After my patch. When SPDK exit it=E2=80=99s async to release vfio refco=
unt
> > connected to ctrl A, it still will block, but SPDK can still can
> > release vfio refcount connected to ctrl B. Since irq 149 release
> > reset_lock of ctrl B, it won=E2=80=99t Block. After release vfio refcou=
nt
> > connected to ctrl B, irq 149 can finish it=E2=80=99s work, and will rel=
ease
> > pci_rescan_remove_lock mutex lock, and then irq 148 can take
> > pci_rescan_remove_lock, then all is same as ctrl A.
> >
> >
> >>
> >> As the locking issue has been solved in the above commit, seems there =
is
> >> no deadlock with the reset_lock and device_lock. Can you confirm if th=
e
> >> scenario can be reproduced with one device? Also, even with two device=
s,
> >> does killing the process matters or not?
> >
> > This problem is not  a deadlock with the reset_lock and device_lock.
> > The scenario can=E2=80=99t be reproduced with one
> > device, only two devices can reproduce this problem. Kill the process
> > may not be important, but
> > the interrupt thread is blocked too, and all lspci commands will
> > block, this affects some monitoring
> > programs.
>
> yes, this issue is not related to no response from userspace.
>
>
> --
> Regards,
> Yi Liu

