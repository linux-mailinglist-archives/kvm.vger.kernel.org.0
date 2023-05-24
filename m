Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AE270EB7C
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 04:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbjEXCpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 22:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjEXCou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 22:44:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD259E9
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 19:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684896243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ABJg3jXu2G9EQCuzxA7yWSMvgcd+rU/FTHUIfoh9wHQ=;
        b=dg1U3AcHoU9DDWNZcMuD2W12ejy5A4/9FVCBB8SSj+MSJ+UalDDqIr6zzjBslX15MLFLrR
        /9ZGqPwaX2ckWjNW//g/qXMJnTK5ksUO3Sg4ucUOxaQV6KxDYErKSbSOpkgd8no5SqvC9l
        Lart88Q77CjjG2cl3LQ6lZuYgYqvzxg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-NA3qD_tTNqCQC4FBTXSQiQ-1; Tue, 23 May 2023 22:44:01 -0400
X-MC-Unique: NA3qD_tTNqCQC4FBTXSQiQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f26157450aso144686e87.0
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 19:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684896240; x=1687488240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ABJg3jXu2G9EQCuzxA7yWSMvgcd+rU/FTHUIfoh9wHQ=;
        b=Oe0A/8lg+vJdDcFoKzrXlHXPOH95ehosKl3g+6t6MGFgtgp4OXIAkvHoGPuuAudpAF
         1DC8y6j03lpOMKr5TElpYsnyWPTE7wERSfSr2CEsgFcHzbpkOgoF//UhtbgxXjgc1WkO
         wIpfh1Ea25AE5LGj/f5HMbHKPe+NDy+v7I4hIdGcsJARNbUhQ7Djs8HNxh4OxEe2UKt2
         5dLl5llDIoE60yahX5/HK5DaHt0dchHkyjkH/8mY67nMU57GsEuZeWLiCBHD/R2vSUhD
         1Px6HF21BU1NrvBU0kFxqcM7F/+bZzSA02mmucoTMGEYww1YPGcdm5KN+uY6MavUXhPy
         pxNw==
X-Gm-Message-State: AC+VfDxt0U/zMrlbXxVNLAj/H4DaFr4FvFSLPy6XbNj95UyyXM0kYgJH
        +JM6To1UI14yGcHPKHl/7HT5gU+zoz5+AlQ2Y1WVtgYeCr8DIUSv0Z9MW/UDSxDIIYM+UdSYBiw
        V5AiSlm3qfiVcMrCIcBbY3Cio19wn
X-Received: by 2002:ac2:5dfc:0:b0:4f1:3b3e:2143 with SMTP id z28-20020ac25dfc000000b004f13b3e2143mr4910283lfq.38.1684896239975;
        Tue, 23 May 2023 19:43:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5G+I8tBySU/AhzxAjYKI/Ryl/z4NNqsbpYzaziVVpOFOgwre9Dlnx8lDNex0PB1WTEz1hSem7hlZhQkbD9Jqo=
X-Received: by 2002:ac2:5dfc:0:b0:4f1:3b3e:2143 with SMTP id
 z28-20020ac25dfc000000b004f13b3e2143mr4910273lfq.38.1684896239605; Tue, 23
 May 2023 19:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683740667.git.reinette.chatre@intel.com> <20230523164301.14620a69.alex.williamson@redhat.com>
In-Reply-To: <20230523164301.14620a69.alex.williamson@redhat.com>
From:   YangHang Liu <yanghliu@redhat.com>
Date:   Wed, 24 May 2023 10:43:48 +0800
Message-ID: <CAGYh1E8Yk-eVNOMQrx6SUgNou5fY6=jFzHR=rQ9diwXbJAaKVg@mail.gmail.com>
Subject: Re: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X interrupts
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, tglx@linutronix.de, darwi@linutronix.de,
        kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running regression tests in the following test matrix:

    i40e PF + INTx interrupt + RHEL9 guest -- PASS
    bnx2x PF + MSI-X + RHEL9 guest -- PASS
    iavf VF + MSI-X + Win2019 guest  -- PASS
    mlx5_core VF + MSI-X  + Win2022 guest -- PASS
    ixgbe PF + INTx + RHEL9 guest -- PASS
    i40e PF + MSIX + Win2019 guest -- PASS
    qede VF + MSIX + RHEL9 guest -- PASS

Tested-by: YangHang Liu <yanghliu@redhat.com>



On Wed, May 24, 2023 at 6:46=E2=80=AFAM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Thu, 11 May 2023 08:44:27 -0700
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>
> > Changes since V4:
> > - V4: https://lore.kernel.org/lkml/cover.1682615447.git.reinette.chatre=
@intel.com/
> > - Add Kevin's Reviewed-by tag as applicable.
> > - Treat non-existing INTx interrupt context as kernel bug with WARN. Th=
is
> >   exposed an issue in the scenario where INTx mask/unmask may occur wit=
hout
> >   INTx enabled. This is fixed by obtaining the interrupt context later
> >   (right before use) within impacted functions: vfio_pci_intx_mask() an=
d
> >   vfio_pci_intx_unmask_handler(). (Kevin)
> > - Treat pci_irq_vector() returning '0' for a MSI/MSI-X interrupt as a k=
ernel
> >   bug via a WARN instead of ignoring this value. (Kevin)
> > - Improve accuracy of comments. (Kevin)
> > - Please refer to individual patches for local changes.
> >
> > Changes since V3:
> > - V3: https://lore.kernel.org/lkml/cover.1681837892.git.reinette.chatre=
@intel.com/
> > - Be considerate about layout and size with changes to
> >   struct vfio_pci_core_device. Keep flags together and transition all t=
o
> >   use bitfields. (Alex and Jason)
> > - Do not free dynamically allocated interrupts on error path. (Alex)
> > - Please refer to individual patches for localized changes.
> >
> > Changes since V2:
> > - V2: https://lore.kernel.org/lkml/cover.1680038771.git.reinette.chatre=
@intel.com/
> > - During testing of V2 "kernel test robot" reported issues resulting fr=
om
> >   include/linux/pci.h missing a stub for pci_msix_can_alloc_dyn() when
> >   CONFIG_PCI_MSI=3Dn. A separate fix was sent to address this. The fix =
can
> >   be found in the kernel (since v6.3-rc7) as
> >   commit 195d8e5da3ac ("PCI/MSI: Provide missing stub for pci_msix_can_=
alloc_dyn()")
> > - Biggest change is the transition to "active contexts" for both MSI an=
d MSI-X.
> >   Interrupt contexts have always been allocated when the interrupts are
> >   allocated while they are only used while interrupts are
> >   enabled. In this series interrupt contexts are made dynamic, while do=
ing
> >   so their allocation is moved to match how they are used: allocated wh=
en
> >   interrupts are enabled. Whether a Linux interrupt number exists deter=
mines
> >   whether an interrupt can be enabled.
> >   Previous policy (up to V2) that an allocated interrupt has an interru=
pt
> >   context no longer applies. Instead, an interrupt context has a
> >   handler/trigger, aka "active contexts". (Alex)
> > - Re-ordered patches in support of "active contexts".
> > - Only free interrupts on MSI-X teardown and otherwise use the
> >   allocated interrupts as a cache. (Alex)
> > - Using unsigned int for the vector broke the unwind loop within
> >   vfio_msi_set_block(). (Alex)
> > - Introduce new "has_dyn_msix" property of virtual device instead of
> >   querying support every time. (Alex)
> > - Some smaller changes, please refer to individual patches.
> >
> > Changes since RFC V1:
> > - RFC V1: https://lore.kernel.org/lkml/cover.1678911529.git.reinette.ch=
atre@intel.com/
> > - Improved changelogs.
> > - Simplify interface so that vfio_irq_ctx_alloc_single() returns pointe=
r to
> >   allocated context. (Alex)
> > - Remove vfio_irq_ctx_range_allocated() and associated attempts to main=
tain
> >   invalid error path behavior. (Alex and Kevin)
> > - Add pointer to interrupt context as function parameter to
> >   vfio_irq_ctx_free(). (Alex)
> > - Ensure variables are initialized. (Dan Carpenter)
> > - Only support dynamic allocation if device supports it. (Alex)
> >
> > Qemu allocates interrupts incrementally at the time the guest unmasks a=
n
> > interrupt, for example each time a Linux guest runs request_irq().
> >
> > Dynamic allocation of MSI-X interrupts was not possible until v6.2 [1].
> > This prompted Qemu to, when allocating a new interrupt, first release a=
ll
> > previously allocated interrupts (including disable of MSI-X) followed
> > by re-allocation of all interrupts that includes the new interrupt.
> > Please see [2] for a detailed discussion about this issue.
> >
> > Releasing and re-allocating interrupts may be acceptable if all
> > interrupts are unmasked during device initialization. If unmasking of
> > interrupts occur during runtime this may result in lost interrupts.
> > For example, consider an accelerator device with multiple work queues,
> > each work queue having a dedicated interrupt. A work queue can be
> > enabled at any time with its associated interrupt unmasked while other
> > work queues are already active. Having all interrupts released and MSI-=
X
> > disabled to enable the new work queue will impact active work queues.
> >
> > This series builds on the recent interrupt sub-system core changes
> > that added support for dynamic MSI-X allocation after initial MSI-X
> > enabling.
> >
> > Add support for dynamic MSI-X allocation to vfio-pci. A flag
> > indicating lack of support for dynamic allocation already exist:
> > VFIO_IRQ_INFO_NORESIZE and has always been set for MSI and MSI-X. With
> > support for dynamic MSI-X the flag is cleared for MSI-X when supported,
> > enabling Qemu to modify its behavior.
> >
> > Any feedback is appreciated
> >
> > Reinette
> >
> > [1] commit 34026364df8e ("PCI/MSI: Provide post-enable dynamic allocati=
on interfaces for MSI-X")
> > [2] https://lore.kernel.org/kvm/MWHPR11MB188603D0D809C1079F5817DC8C099@=
MWHPR11MB1886.namprd11.prod.outlook.com/#t
> >
> > Reinette Chatre (11):
> >   vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
> >   vfio/pci: Remove negative check on unsigned vector
> >   vfio/pci: Prepare for dynamic interrupt context storage
> >   vfio/pci: Move to single error path
> >   vfio/pci: Use xarray for interrupt context storage
> >   vfio/pci: Remove interrupt context counter
> >   vfio/pci: Update stale comment
> >   vfio/pci: Use bitfield for struct vfio_pci_core_device flags
> >   vfio/pci: Probe and store ability to support dynamic MSI-X
> >   vfio/pci: Support dynamic MSI-X
> >   vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X
> >
> >  drivers/vfio/pci/vfio_pci_core.c  |   8 +-
> >  drivers/vfio/pci/vfio_pci_intrs.c | 305 ++++++++++++++++++++----------
> >  include/linux/vfio_pci_core.h     |  26 +--
> >  include/uapi/linux/vfio.h         |   3 +
> >  4 files changed, 229 insertions(+), 113 deletions(-)
> >
> >
> > base-commit: 457391b0380335d5e9a5babdec90ac53928b23b4
>
> Applied to vfio next branch for v6.5.  Thanks!
>
> Alex
>

