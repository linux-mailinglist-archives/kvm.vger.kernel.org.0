Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7E67868D
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjAWTiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjAWTiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:38:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5830030E93
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674502644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9pA1c6BHta6GhQhYWCwS56HrqzzDOgQIQkJ2JIfcr3E=;
        b=B2VYoJoQrp29EAD20+M3maPY7UoYhUFxZFvjd1OfDgRQdjCy0T6mThbOskNQRv9C0u+bfT
        23lzZOppgsyrJWwoAMFVEqr6UWFE86ZDbHB9NJaxr5ARkg4TdQlruSM4FF42hoAVQXgELp
        mUvAzCkNeVUlPIw256XQIsQe3tGrOLs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-kkyq8MCqNPCaRCIPL7Kkdg-1; Mon, 23 Jan 2023 14:37:23 -0500
X-MC-Unique: kkyq8MCqNPCaRCIPL7Kkdg-1
Received: by mail-il1-f200.google.com with SMTP id y5-20020a056e021be500b0030bc4f23f0aso8990046ilv.3
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pA1c6BHta6GhQhYWCwS56HrqzzDOgQIQkJ2JIfcr3E=;
        b=5z75FrnnG/dimunIZqzZfmrZcZ5UTLCERxmgrOGCsvjLaNVqMf3VDXzKupkgIJdRAA
         hQKRfdkMy+7qcQNv3i5wMCuXxQ+ykAMZ4wBpMtJGMdM5H6RaeV5j6pe5kpQ5mvjCqbAy
         w2K60UQxOOWY0GIJAv0hk88XLJVUploJCtVWHPc4Ci6tITC0JZwbeTOcRE+NTgtZCyhR
         L9wTbInzbQmjVmxgx9t5Iu+fyYrXq7FeC8ulPnMGwHp/xLMgKyzAgpYDYYp2YIhz5LrJ
         dRq/wnvm32LOu5iqKMJ3WOPPhBud43qbZ++7Y+Ng5vtyGEq/aYE1sEmgVMmoNIl9dVHg
         Ut1A==
X-Gm-Message-State: AFqh2kqpaky9Z4fIaFJiq0TIKIvW25w9YBIp5llMhrdOrOSQ5nLp568p
        me9Ah+Vc453lZlyZmUdolcWgwcHVZfIKBPXWEOnOqWjgxhJ7R12CeKAnHfZI8qgN6z0SI+RDuRs
        MydvTF1Kboe1i
X-Received: by 2002:a6b:fb03:0:b0:704:946f:997d with SMTP id h3-20020a6bfb03000000b00704946f997dmr17540412iog.18.1674502642406;
        Mon, 23 Jan 2023 11:37:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsol3TX2ISJqmrrnZil390RqhKZ3lKcPTDiOu1/Emop+//xcAzmuoYYIz28xTsyM+VYKDHi3A==
X-Received: by 2002:a6b:fb03:0:b0:704:946f:997d with SMTP id h3-20020a6bfb03000000b00704946f997dmr17540396iog.18.1674502642196;
        Mon, 23 Jan 2023 11:37:22 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v26-20020a056602059a00b00704c3128817sm7121378iox.43.2023.01.23.11.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:37:21 -0800 (PST)
Date:   Mon, 23 Jan 2023 12:37:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace
 persistent allocations
Message-ID: <20230123123708.5ad03553.alex.williamson@redhat.com>
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Sun, 8 Jan 2023 17:44:21 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series changes the vfio and its sub drivers to use
> GFP_KERNEL_ACCOUNT for userspace persistent allocations.
> 
> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
> is untrusted allocation triggered from userspace and should be a subject
> of kmem accountingis, and as such it is controlled by the cgroup
> mechanism. [1]
> 
> As part of this change, we allow loading in mlx5 driver larger images
> than 512 MB by dropping the arbitrary hard-coded value that we have
> today and move to use the max device loading value which is for now 4GB.
> 
> In addition, the first patch from the series fixes a UBSAN note in mlx5
> that was reported once the kernel was compiled with this option.
> 
> [1] https://www.kernel.org/doc/html/latest/core-api/memory-allocation.html
> 
> Changes from V0: https://www.spinics.net/lists/kvm/msg299508.html
> Patch #2 - Fix MAX_LOAD_SIZE to use BIT_ULL instead of BIT as was
>            reported by the krobot test.
> 
> Yishai
> 
> Jason Gunthorpe (1):
>   vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
> 
> Yishai Hadas (5):
>   vfio/mlx5: Fix UBSAN note
>   vfio/mlx5: Allow loading of larger images than 512 MB
>   vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
>   vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations
>   vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations
> 
>  drivers/vfio/container.c                      |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c        |  4 ++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  4 ++--
>  drivers/vfio/pci/mlx5/cmd.c                   | 17 +++++++++--------
>  drivers/vfio/pci/mlx5/main.c                  | 19 ++++++++++---------
>  drivers/vfio/pci/vfio_pci_config.c            |  6 +++---
>  drivers/vfio/pci/vfio_pci_core.c              |  7 ++++---
>  drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c             | 10 ++++++----
>  drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c  |  2 +-
>  drivers/vfio/platform/vfio_platform_irq.c     |  8 ++++----
>  drivers/vfio/virqfd.c                         |  2 +-
>  14 files changed, 46 insertions(+), 41 deletions(-)
> 

Applied to vfio next branch for v6.3.  Thanks,

Alex

