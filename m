Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254596AD2FB
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 00:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCFXrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 18:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFXrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 18:47:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C477E521C9
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 15:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678146371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJJ/SPwRxfJctF2aTdUZ7XudcJ8pB5qw99SDvRIMbf8=;
        b=IzqffoWbDyVFl5q4lIJhuEf93R9XQOYkwHVcBGf6CYgqBFbu4ixUnGBx0ia3hMXsJBq0ka
        Z+Jamzwt3OjDMddbfUuekroIAqW+n5kMurMkQG9R+h9fVZ75N87kvSahCDIHCPM1PyM6Ut
        w6SVAA/2eE5CrjQ0sRIbMxWZ2xhYETY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-Enr7yulpO3GFuDaSB6eksQ-1; Mon, 06 Mar 2023 18:46:10 -0500
X-MC-Unique: Enr7yulpO3GFuDaSB6eksQ-1
Received: by mail-il1-f197.google.com with SMTP id z8-20020a92cd08000000b00317b27a795aso6116652iln.0
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 15:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678146369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wJJ/SPwRxfJctF2aTdUZ7XudcJ8pB5qw99SDvRIMbf8=;
        b=5j+D7JhHfSxHUoGeNo4+mhQHICeDnx+rgcYpvU1q+kcK/2/WYbMwg75OAt09tmbYVw
         nxDEDdRV4l5ryBn/s6koTxXN41JY9OT5QmeDpRjlg0oKafqOZseAM5jw6MAljHfiyow7
         +pOXg5piYxGtN3dzNKgtszoWGfaqCocEExW6cePBDvmLdPN9icu04XXXb0IsfydrG6Q9
         e9SbV7XwEScPl3qI2OpTkJs39o1wfRfGXAqBqa8Hw65mpvtaTSSJpD5FJh0iai5mf9zJ
         ZC+SGj6JrU0xLQkmvEngU6J22d3My/ZS202WjeDXUyOyiMUxRW5bT1UNzuDQaLtXrMmH
         QbAg==
X-Gm-Message-State: AO0yUKUTuhts1g51uaPWathS/Tg0yvigyqqH9ZBoRzv+g7IN7wpQ61Tz
        HB+A8XsX1viFuTO0Jah9Trkazfizgs8Br/nJLcCvsXsnCi03MVBqLB368ohOLFH8vwBkyj7SuXP
        OBC/2qRI5goPnb5k16wP/
X-Received: by 2002:a05:6e02:1d05:b0:317:97ab:e5d1 with SMTP id i5-20020a056e021d0500b0031797abe5d1mr11906020ila.12.1678146369675;
        Mon, 06 Mar 2023 15:46:09 -0800 (PST)
X-Google-Smtp-Source: AK7set94N5VJMPCYD2NcAdIOMsENYGwUy/huUKdq/gUq6blF75kCFaPgAlIPt5CkJ0wV+aRjWL2gbA==
X-Received: by 2002:a05:6e02:1d05:b0:317:97ab:e5d1 with SMTP id i5-20020a056e021d0500b0031797abe5d1mr11906013ila.12.1678146369475;
        Mon, 06 Mar 2023 15:46:09 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k20-20020a5d91d4000000b0074c80aa17f0sm3700936ior.0.2023.03.06.15.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 15:46:09 -0800 (PST)
Date:   Mon, 6 Mar 2023 16:46:07 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Timothy Pearson <tpearson@raptorengineering.com>
Cc:     kvm <kvm@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
Message-ID: <20230306164607.1455ee81.alex.williamson@redhat.com>
In-Reply-To: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
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

On Mon, 6 Mar 2023 11:29:53 -0600 (CST)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> This patch series reenables VFIO support on POWER systems.  It
> is based on Alexey Kardashevskiys's patch series, rebased and
> successfully tested under QEMU with a Marvell PCIe SATA controller
> on a POWER9 Blackbird host.
> 
> Alexey Kardashevskiy (3):
>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>   powerpc/pci_64: Init pcibios subsys a bit later
>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>     domains
> 
> Timothy Pearson (1):
>   Add myself to MAINTAINERS for Power VFIO support
> 
>  MAINTAINERS                               |   5 +
>  arch/powerpc/include/asm/iommu.h          |   6 +-
>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>  arch/powerpc/kernel/pci_64.c              |   2 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
>  arch/powerpc/platforms/pseries/setup.c    |   3 +
>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>  10 files changed, 338 insertions(+), 94 deletions(-)
> 

For vfio and MAINTAINERS portions,

Acked-by: Alex Williamson <alex.williamson@redhat.com>

I'll note though that spapr_tce_take_ownership() looks like it copied a
bug from the old tce_iommu_take_ownership() where tbl and tbl->it_map
are tested before calling iommu_take_ownership() but not in the unwind
loop, ie. tables we might have skipped on setup are unconditionally
released on unwind.  Thanks,

Alex

