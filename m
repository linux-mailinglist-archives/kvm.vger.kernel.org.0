Return-Path: <kvm+bounces-32806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814A49DF98E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 04:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D9DE16333C
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 03:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1301494CC;
	Mon,  2 Dec 2024 03:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LHXYQJgU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED01E1C22;
	Mon,  2 Dec 2024 03:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733109915; cv=none; b=oe9wiM8y5N/juLTvugOyHh4CsB4nm/ri4cAGFXdhqjXg8qcXfrnjMTCC5pKKMal9EELAu7VviKQ1R7UvbWo8mWNkpHrKkAObpBAnKE77kTKWbO4w+cmdCp4iLP+bS8vk4Ah/2skzB3Ww/aUdRY+6ePSE9qWiwiX2BuBT/u/BsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733109915; c=relaxed/simple;
	bh=0ZZbsGfWkdmN+s0AheLNIZ/wSh0dWapMIYWxUrncf9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HtF0uV43uR49Yk1Y17OXIEMxhVfcMBpU41S1macRAt+8xgC7NyisymP9VCIPqAcz3w8MhMYH2aXPfz8NHFNMJdR42Mx9YwHZP/wvqi2w+/ySKcAosbuHdjpY192irhDsBGurJGPiD0mAnThWy/DFvgN9uLIGSXWdoDjBxI2eetE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LHXYQJgU; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-51530758f9eso979107e0c.1;
        Sun, 01 Dec 2024 19:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733109912; x=1733714712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xF0DjLqaRK8x5woguY+vaE7sUtnvbTARYIZ9unigqKk=;
        b=LHXYQJgU0Otv8g/xzxEIekfFZnn8224marpvNqQ8qDBIHjAaDm5iUUGflvNvCrnjIV
         tfqBFE5I+bzUQRA+fGgA3C/vUlBcL48erD2G4drlOcHliwwjtv9j0/Z2GbGx9iEIIoLT
         rIvmo/h+h8q2cb8nJLTe7HK/P8Vzti3yKD4Ta1yD47GViNK/fFahIhzroGKZTiytUvxf
         eUtBSOCetGjm1QhJVkgNZPs8IkSHVr8qcV9D6OIupkDnj5fApWRqA50Y2xeBID9naA2I
         4xfKMDlckX+xU0Hqv8V/PSCMdnD0FQS2AOZ30EDcTQKb0GFgz+a+Q9vCsCofGZ1+0YPg
         vRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733109912; x=1733714712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xF0DjLqaRK8x5woguY+vaE7sUtnvbTARYIZ9unigqKk=;
        b=l92eprvow1q23Be9mMGCrurLi7yV0M6s0ThTTEk9PHkOHDPc0PGziQXyIozhTJ3B0d
         ZTWFaEgWSFgaK6q3vLm5TM8spEse96kV5W24RT9c9fCtY6FdMgzd5lpg+XoURI/DqWdL
         uCQAdfjCuOR0fyFpRfxTBz24KR9BT6tMzkEMU0WzllSg0uSoouEpAPh0o5HRREkE+2V/
         +xWxOGEi8WY24gvyDPb0q7KBVX1j5aAittE41PW8yFsMJamXBGNJLqjZgPiUMUXMYM5C
         6X7M3qnVI2MSaTRtNiyJnk5D09+RIIF1AJysICGE6ZWVaEEGkzDo30sXs/5eRcO6c7bw
         V9IA==
X-Forwarded-Encrypted: i=1; AJvYcCXgYylINpYCuPGMPguJXFHu5BxW/1ERgxBJU5sjB/neLs9mtg5HLgihvmDMa/XPTk2hJA0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1vOiVWR5flyURkbrgFZZdMqElU3J5t0KI0ycemERZ4ZgPOQSO
	ZBnCUxnGVK60QCyaRgiykjudL1X0oFcfg316YJj1oMBZKN3y1BGbd/aRjsGkwlkOMZxAfz3/7HY
	NJqDc09td3nFEAmYo0Lwos6c0PUU=
X-Gm-Gg: ASbGnctFCJlxn0IVYskn2rfiTPD1NLEA3+oe5utOU+0KENecxUtyALZukKtF79Uru8l
	xhYxeSRC8FTKF1PtT/RcvvG61/gTxuLbH
X-Google-Smtp-Source: AGHT+IH3qArPqUWJuv2DHafN5aOu/3lVLQQCtiq0Bbf02rHcGM2hpsM0f/Utvsj5siKFO+vcnETb9PrFugDGXbrEtSU=
X-Received: by 2002:a05:6122:2a01:b0:515:4ff7:355a with SMTP id
 71dfb90a1353d-51556aea04fmr24470295e0c.11.1733109912131; Sun, 01 Dec 2024
 19:25:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <D0B37524-9444-423B-9E48-406CF9A29A6A@gmail.com>
 <A8CD6F73-CDBC-45D1-A8DF-CB583962DB8C@gmail.com> <5b2b0211-81d9-4ec9-98d5-b39a84581ac0@intel.com>
In-Reply-To: <5b2b0211-81d9-4ec9-98d5-b39a84581ac0@intel.com>
From: fengnan chang <fengnanchang@gmail.com>
Date: Mon, 2 Dec 2024 11:25:01 +0800
Message-ID: <CALWNXx9gwDZASU6Hm68hz05P2EcB0BgqPnWKkUaAK_BNAqj8mg@mail.gmail.com>
Subject: Re: Deadlock during PCIe hot remove and SPDK exit
To: Yi Liu <yi.l.liu@intel.com>
Cc: linux-pci@vger.kernel.org, lukas@wunner.de, kvm@vger.kernel.org, 
	alex.williamson@redhat.com, bhelgaas@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2024 at 4:00=E2=80=AFPM Yi Liu <yi.l.liu@intel.com> wrote:
>
> On 2024/11/28 11:50, fengnan chang wrote:
> >
> >
> >> 2024=E5=B9=B411=E6=9C=8827=E6=97=A5 14:56=EF=BC=8Cfengnan chang <fengn=
anchang@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> Dear PCI maintainers:
> >>    I'm having a deadlock issue, somewhat similar to a previous one htt=
ps://lore.kernel.org/linux-pci/CS1PR8401MB0728FC6FDAB8A35C22BD90EC95F10@CS1=
PR8401MB0728.NAMPRD84.PROD.OUTLOOK.COM/#t=EF=BC=8C but my kernel (6.6.40) a=
lready included the fix f5eff55.
>
> The previous bug was solved by the below commit.
>
> commit f5eff5591b8f9c5effd25c92c758a127765f74c1
> Author: Lukas Wunner <lukas@wunner.de>
> Date:   Tue Apr 11 08:21:02 2023 +0200
>
>      PCI: pciehp: Fix AB-BA deadlock between reset_lock and device_lock
>

Yes, my kernel version included this fix.

>      In 2013, commits
>
>        2e35afaefe64 ("PCI: pciehp: Add reset_slot() method")
>        608c388122c7 ("PCI: Add slot reset option to pci_dev_reset()")
>
>      amended PCIe hotplug to mask Presence Detect Changed events during a
>      Secondary Bus Reset.  The reset thus no longer causes gratuitous slo=
t
>      bringdown and bringup.
>
>      However the commits neglected to serialize reset with code paths rea=
ding
>      slot registers.  For instance, a slot bringup due to an earlier hotp=
lug
>      event may see the Presence Detect State bit cleared during a concurr=
ent
>      Secondary Bus Reset.
>
>      In 2018, commit
>
>        5b3f7b7d062b ("PCI: pciehp: Avoid slot access during reset")
>
>      retrofitted the missing locking.  It introduced a reset_lock which
>      serializes a Secondary Bus Reset with other parts of pciehp.
>
>      Unfortunately the locking turns out to be overzealous:  reset_lock i=
s
>      held for the entire enumeration and de-enumeration of hotplugged dev=
ices,
>      including driver binding and unbinding.
>
>      Driver binding and unbinding acquires device_lock while the reset_lo=
ck
>      of the ancestral hotplug port is held.  A concurrent Secondary Bus R=
eset
>      acquires the ancestral reset_lock while already holding the device_l=
ock.
>      The asymmetric locking order in the two code paths can lead to AB-BA
>      deadlocks.
>
>      Michael Haeuptle reports such deadlocks on simultaneous hot-removal =
and
>      vfio release (the latter implies a Secondary Bus Reset):
>
>        pciehp_ist()                                    # down_read(reset_=
lock)
>          pciehp_handle_presence_or_link_change()
>            pciehp_disable_slot()
>              __pciehp_disable_slot()
>                remove_board()
>                  pciehp_unconfigure_device()
>                    pci_stop_and_remove_bus_device()
>                      pci_stop_bus_device()
>                        pci_stop_dev()
>                          device_release_driver()
>                            device_release_driver_internal()
>                              __device_driver_lock()    # device_lock()
>
>        SYS_munmap()
>          vfio_device_fops_release()
>            vfio_device_group_close()
>              vfio_device_close()
>                vfio_device_last_close()
>
>
> >>    Here is my test process, I=E2=80=99m running kernel with 6.6.40 and=
 SPDK v22.05:
> >>    1. SPDK use vfio driver to takeover two nvme disks, running some io=
 in nvme.
> >>    2. pull out two nvme disks
> >>    3. Try to kill -9 SPDK process.
> >>    Then deadlock issue happened. For now I can 100% reproduce this pro=
blem. I=E2=80=99m not an export in PCI, but I did a brief analysis:
> >>    irq 149 thread take pci_rescan_remove_lock mutex lock, and wait for=
 SPDK to release vfio.
> >>    irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_r=
emove_lock
> >>    SPDK process try to release vfio driver, but wait for reset_lock of=
 ctrl A.
> >>
> >>
> >> irq/149-pciehp stack, cat /proc/514/stack,
> >> [<0>] pciehp_unconfigure_device+0x48/0x160 // wait for pci_rescan_remo=
ve_lock
> >> [<0>] pciehp_disable_slot+0x6b/0x130       // hold reset_lock of ctrl =
A
> >> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
> >> [<0>] pciehp_ist+0x236/0x260
> >> [<0>] irq_thread_fn+0x1b/0x60
> >> [<0>] irq_thread+0xed/0x190
> >> [<0>] kthread+0xe4/0x110
> >> [<0>] ret_from_fork+0x2d/0x50
> >> [<0>] ret_from_fork_asm+0x11/0x20
> >>
> >>
> >> irq/148-pciehp stack, cat /proc/513/stack
> >> [<0>] vfio_unregister_group_dev+0x97/0xe0 [vfio]     //wait for
> >
> > My mistake, this is wait for SPDK to release vfio device. This problem =
can reproduce in 6.12.
> > Besides, My college give me an idea, we can make vfio_device_fops_relea=
se be async, so when we close fd, it
> > won=E2=80=99t block, and when we close another fd, it will release  vfi=
o device, this stack will not block too, then the deadlock disappears.
> >
>
> In the hotplug path, vfio needs to notify userspace to stop the usage of
> this device and release reference on the vfio_device. When the last
> refcount is released, the wait in the vfio_unregister_group_dev() will be
> unblocked. It is the vfio_device_fops_release() either userspace exits or
> userspace explicitly close the vfio device fd. Your below test patch move=
s
> the majority of the vfio_device_fops_release() out of the existing path.
> I don't see a reason why it can work so far.

Forgive my poor English. Let me explain in more detail.
irq 149 thread take pci_rescan_remove_lock mutex lock, take reset_lock
of ctrl B and release reset_lock of ctrl B. Then wait for SPDK to
release vfio refcount connected to ctrl B.
irq 148 thread take reset_lock of ctrl A, and wait for psi_rescan_remove_lo=
ck.
SPDK process exit, and try to release vfio refcount connected to ctrl
A, but need to wait for reset_lock of ctrl A.  Since SPDK is blocked
here, it won=E2=80=99t release vfio refcount connected to ctrl B. So the
deadlock is happening.
After my patch. When SPDK exit it=E2=80=99s async to release vfio refcount
connected to ctrl A, it still will block, but SPDK can still can
release vfio refcount connected to ctrl B. Since irq 149 release
reset_lock of ctrl B, it won=E2=80=99t Block. After release vfio refcount
connected to ctrl B, irq 149 can finish it=E2=80=99s work, and will release
pci_rescan_remove_lock mutex lock, and then irq 148 can take
pci_rescan_remove_lock, then all is same as ctrl A.


>
> As the locking issue has been solved in the above commit, seems there is
> no deadlock with the reset_lock and device_lock. Can you confirm if the
> scenario can be reproduced with one device? Also, even with two devices,
> does killing the process matters or not?

This problem is not  a deadlock with the reset_lock and device_lock.
The scenario can=E2=80=99t be reproduced with one
device, only two devices can reproduce this problem. Kill the process
may not be important, but
the interrupt thread is blocked too, and all lspci commands will
block, this affects some monitoring
programs.


>
> > Here is my test patch, cc some vfio guys:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 50128da18bca..4ebe154a4ae5 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -19,6 +19,7 @@ struct vfio_container;
> >   struct vfio_device_file {
> >          struct vfio_device *device;
> >          struct vfio_group *group;
> > +       struct work_struct      release_work;
> >
> >          u8 access_granted;
> >          u32 devid; /* only valid when iommufd is valid */
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a5a62d9d963f..47e3e3f73d70 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -487,6 +487,22 @@ static bool vfio_assert_device_open(struct vfio_de=
vice *device)
> >          return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
> >   }
> >
> > +static void vfio_fops_release_work(struct work_struct *work)
> > +{
> > +       struct vfio_device_file *df =3D
> > +               container_of(work, struct vfio_device_file, release_wor=
k);
> > +       struct vfio_device *device =3D df->device;
> > +
> > +       if (df->group)
> > +               vfio_df_group_close(df);
> > +       else
> > +               vfio_df_unbind_iommufd(df);
> > +
> > +       vfio_device_put_registration(device);
> > +
> > +       kfree(df);
> > +}
> > +
> >   struct vfio_device_file *
> >   vfio_allocate_device_file(struct vfio_device *device)
> >   {
> > @@ -497,6 +513,7 @@ vfio_allocate_device_file(struct vfio_device *devic=
e)
> >                  return ERR_PTR(-ENOMEM);
> >
> >          df->device =3D device;
> > +       INIT_WORK(&df->release_work, vfio_fops_release_work);
> >          spin_lock_init(&df->kvm_ref_lock);
> >
> >          return df;
> > @@ -628,16 +645,8 @@ static inline void vfio_device_pm_runtime_put(stru=
ct vfio_device *device)
> >   static int vfio_device_fops_release(struct inode *inode, struct file =
*filep)
> >   {
> >          struct vfio_device_file *df =3D filep->private_data;
> > -       struct vfio_device *device =3D df->device;
> >
> > -       if (df->group)
> > -               vfio_df_group_close(df);
> > -       else
> > -               vfio_df_unbind_iommufd(df);
> > -
> > -       vfio_device_put_registration(device);
> > -
> > -       kfree(df);
> > +       schedule_work(&df->release_work);
> >
> >          return 0;
> >   }
> >
> >
> >> [<0>] vfio_pci_core_unregister_device+0x19/0x80 [vfio_pci_core]
> >> [<0>] vfio_pci_remove+0x15/0x20 [vfio_pci]
> >> [<0>] pci_device_remove+0x39/0xb0
> >> [<0>] device_release_driver_internal+0xad/0x120
> >> [<0>] pci_stop_bus_device+0x5d/0x80
> >> [<0>] pci_stop_and_remove_bus_device+0xe/0x20
> >> [<0>] pciehp_unconfigure_device+0x91/0x160   //hold pci_rescan_remove_=
lock, release reset_lock of ctrl B
> >> [<0>] pciehp_disable_slot+0x6b/0x130
> >> [<0>] pciehp_handle_presence_or_link_change+0x7d/0x4d0
> >> [<0>] pciehp_ist+0x236/0x260             //hold reset_lock of ctrl B
> >> [<0>] irq_thread_fn+0x1b/0x60
> >> [<0>] irq_thread+0xed/0x190
> >> [<0>] kthread+0xe4/0x110
> >> [<0>] ret_from_fork+0x2d/0x50
> >> [<0>] ret_from_fork_asm+0x11/0x20
> >>
> >>
> >> SPDK stack, cat /proc/166634/task/167181/stack
> >> [<0>] down_write_nested+0x1b7/0x1c0            //wait for reset_lock o=
f ctrl A.
> >> [<0>] pciehp_reset_slot+0x58/0x160
> >> [<0>] pci_reset_hotplug_slot+0x3b/0x60
> >> [<0>] pci_reset_bus_function+0x3b/0xb0
> >> [<0>] __pci_reset_function_locked+0x3e/0x60
> >> [<0>] vfio_pci_core_disable+0x3ce/0x400 [vfio_pci_core]
> >> [<0>] vfio_pci_core_close_device+0x67/0xc0 [vfio_pci_core]
> >> [<0>] vfio_df_close+0x79/0xd0 [vfio]
> >> [<0>] vfio_df_group_close+0x36/0x70 [vfio]
> >> [<0>] vfio_device_fops_release+0x20/0x40 [vfio]
> >> [<0>] __fput+0xec/0x290
> >> [<0>] task_work_run+0x61/0x90
> >> [<0>] do_exit+0x39c/0xc40
> >> [<0>] do_group_exit+0x33/0xa0
> >> [<0>] get_signal+0xd84/0xd90
> >> [<0>] arch_do_signal_or_restart+0x2a/0x260
> >> [<0>] exit_to_user_mode_prepare+0x1c7/0x240
> >> [<0>] syscall_exit_to_user_mode+0x2a/0x60
> >> [<0>] do_syscall_64+0x3e/0x90
> >>
> >
> >
>
> --
> Regards,
> Yi Liu

