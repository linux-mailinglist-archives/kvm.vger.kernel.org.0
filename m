Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E786AD39C
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 02:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCGBAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 20:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGBAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 20:00:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843C6366A7
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 16:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678150785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1butyJsvNx4YJ9aTrzHZe+e8dMXHZLy0RXs3Qcm93D8=;
        b=KfwFZEzt8pZoPVjqpNfh680j3ZCkvsZKgDCFvRu20JYFIxHPXERZ8LqnBJlv0qHC/Y8aZZ
        S1HxhPHcqjyew/3kRHRumUr2GrugrYhOScMFtqwRutTA5e2QyUqNh7gGDruf0FTVPjq+Io
        fxrCqeYQ1PgUV8MP4X9zlp/an8Qiv64=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-V2Lq3s7TMMKoxktDGmQyTA-1; Mon, 06 Mar 2023 19:59:44 -0500
X-MC-Unique: V2Lq3s7TMMKoxktDGmQyTA-1
Received: by mail-il1-f199.google.com with SMTP id i7-20020a056e021b0700b0031dc4cdc47cso3832678ilv.23
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 16:59:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678150783;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1butyJsvNx4YJ9aTrzHZe+e8dMXHZLy0RXs3Qcm93D8=;
        b=umlMje9biFPSjJ8+jPfFzAgB9Pcne1V5uHMTSyr7oeWrA7BTBiUHNi5vlnVFb3oeqN
         jZM33PETBbE+lyNHSwgENcNXnzme5qLF2RWRoFvmBbxcAbdgpYdzP5YVifYN7sbw8AcK
         Cux5sy/kUp4U5jYoXAwDi6KV5KD1ltQB58BAl2TcqEJP4by5yEV58Sw2pExu2UA+VvUf
         7HRVQtr23bGr5DsDl3xYeYgBXUqJ987yJ8w0LPlC4IdOyG2urAhnByn5DsdvtxQC/9e/
         PxeV+XDoYqxofuTn0dYigyoO0Nf7FlDJLrbzFDMw9TH+BMmcWDqd89EJlvtp+ZPjT8rX
         +LKw==
X-Gm-Message-State: AO0yUKWxGSPCIsmkEvmUCvdSIGBuXQBAb5/YNPnSDIXdxbCJxDq+76dl
        fQZBBYxc5GxPYumwgU0ee2zwgjVLLYg/Rh75I4CVcJHC/NlinfRIchg8vMrSQcMTFmr8cVBy1GU
        RwvCxhLU51eBOHzXgJvYU
X-Received: by 2002:a05:6e02:1bab:b0:302:a58f:38ab with SMTP id n11-20020a056e021bab00b00302a58f38abmr9629297ili.0.1678150783456;
        Mon, 06 Mar 2023 16:59:43 -0800 (PST)
X-Google-Smtp-Source: AK7set9E202+BpRrrc/VXxnbDo2DKaUh4BY1R7k7N5AcOmllutHuvV3fBkUhGWPtLN+RPuE41J41aA==
X-Received: by 2002:a05:6e02:1bab:b0:302:a58f:38ab with SMTP id n11-20020a056e021bab00b00302a58f38abmr9629289ili.0.1678150783220;
        Mon, 06 Mar 2023 16:59:43 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q23-20020a02c8d7000000b003a60da2bf58sm3589389jao.39.2023.03.06.16.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 16:59:42 -0800 (PST)
Date:   Mon, 6 Mar 2023 17:59:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Timothy Pearson <tpearson@raptorengineering.com>
Cc:     kvm <kvm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
Message-ID: <20230306175941.1b69bb14.alex.williamson@redhat.com>
In-Reply-To: <1817332573.17073558.1678149322645.JavaMail.zimbra@raptorengineeringinc.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
        <20230306164607.1455ee81.alex.williamson@redhat.com>
        <1817332573.17073558.1678149322645.JavaMail.zimbra@raptorengineeringinc.com>
Organization: Red Hat
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

On Mon, 6 Mar 2023 18:35:22 -0600 (CST)
Timothy Pearson <tpearson@raptorengineering.com> wrote:

> ----- Original Message -----
> > From: "Alex Williamson" <alex.williamson@redhat.com>
> > To: "Timothy Pearson" <tpearson@raptorengineering.com>
> > Cc: "kvm" <kvm@vger.kernel.org>, "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>
> > Sent: Monday, March 6, 2023 5:46:07 PM
> > Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems  
> 
> > On Mon, 6 Mar 2023 11:29:53 -0600 (CST)
> > Timothy Pearson <tpearson@raptorengineering.com> wrote:
> >   
> >> This patch series reenables VFIO support on POWER systems.  It
> >> is based on Alexey Kardashevskiys's patch series, rebased and
> >> successfully tested under QEMU with a Marvell PCIe SATA controller
> >> on a POWER9 Blackbird host.
> >> 
> >> Alexey Kardashevskiy (3):
> >>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
> >>   powerpc/pci_64: Init pcibios subsys a bit later
> >>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
> >>     domains
> >> 
> >> Timothy Pearson (1):
> >>   Add myself to MAINTAINERS for Power VFIO support
> >> 
> >>  MAINTAINERS                               |   5 +
> >>  arch/powerpc/include/asm/iommu.h          |   6 +-
> >>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
> >>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
> >>  arch/powerpc/kernel/pci_64.c              |   2 +-
> >>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
> >>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
> >>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
> >>  arch/powerpc/platforms/pseries/setup.c    |   3 +
> >>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
> >>  10 files changed, 338 insertions(+), 94 deletions(-)
> >>   
> > 
> > For vfio and MAINTAINERS portions,
> > 
> > Acked-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > I'll note though that spapr_tce_take_ownership() looks like it copied a
> > bug from the old tce_iommu_take_ownership() where tbl and tbl->it_map
> > are tested before calling iommu_take_ownership() but not in the unwind
> > loop, ie. tables we might have skipped on setup are unconditionally
> > released on unwind.  Thanks,
> > 
> > Alex  
> 
> Thanks for that.  I'll put together a patch to get rid of that
> potential bug that can be applied after this series is merged, unless
> you'd rather I resubmit a v3 with the issue fixed?

Follow-up fix is fine by me.  Thanks,

Alex

