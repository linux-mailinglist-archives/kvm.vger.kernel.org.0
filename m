Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2FD710F65
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 17:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241755AbjEYPWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 11:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241309AbjEYPWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 11:22:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2F4198
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685028088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0V518OsqUrGCxG2mh1VgKtRufND8RHTunMvUY4Z4UHo=;
        b=dmMngBNKxCgzqSWsYaElCS5kPy7IVbWoOOjFL0X1AkzI7uZy7xtHA2W4YAuAKbKsvXOE59
        FrG+8JUY1ZvbmfLjPXnmW7kn+m9Wd/Qglr1/rLbd5DsKgLxw3MswxLKrdMy2Qlah11fmRy
        eZQRb93JxAhRhoB7UG5wOJkhI66DbWI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-lqObaJp1N62fsAA3MJ_dMw-1; Thu, 25 May 2023 11:21:27 -0400
X-MC-Unique: lqObaJp1N62fsAA3MJ_dMw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-772d796bbe5so230256939f.2
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 08:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685028086; x=1687620086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0V518OsqUrGCxG2mh1VgKtRufND8RHTunMvUY4Z4UHo=;
        b=b00T1LhPueKOMjvnSiI1ocwB0S735/llSb8Ob2isoJdlbxh1dNv2+uhtPqNMSQibWy
         Ai0yEK8rkRAh+i4CNgiNmDWRVSr9sVi8ICnHEtqeoFkmOH+Ky/VCmhMPh5wP8iyigEFD
         zXL7K7OPterR2ooMZQMCM771BenhgYkpokXFaPNWQwcnfpvdNZh3bvmM5/FaoXQqkRAb
         P+xcTuciezRlK0cYDbir6rHlZIDKfeN3luB+gNbtUKKQv75q2l5zzvm4hu/xhpedyLRG
         MMQ6joqC410Ltmjf+SZkTTXpRN6HP3KNNu4JpydQKIp/+EomHQN3ETYOR+wKQZuzWUo2
         6e9g==
X-Gm-Message-State: AC+VfDyclmfRIaD7Q2ZtmfaU63QDN4LrDThdZFm7s9h0SGkcI/3l1kwX
        aeYgvEKdYuYsmvlmqwvot5Shlxx7AYNmSFzLQoC35P4bYH/aenP+2sGTUU24VYEs9/lueCWuWS0
        4DWYFiSqI5wjS
X-Received: by 2002:a05:6602:195:b0:76c:8877:861f with SMTP id m21-20020a056602019500b0076c8877861fmr12238225ioo.1.1685028086171;
        Thu, 25 May 2023 08:21:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Dvwin5vA64+Lt/6YHmWpeTY/wo7iHQfofVJf9Xm4liofqM3m0CvvT/D9oG9z9hJVh0cakng==
X-Received: by 2002:a05:6602:195:b0:76c:8877:861f with SMTP id m21-20020a056602019500b0076c8877861fmr12238202ioo.1.1685028085781;
        Thu, 25 May 2023 08:21:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cn15-20020a0566383a0f00b0041a9022c3dasm458603jab.118.2023.05.25.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:21:25 -0700 (PDT)
Date:   Thu, 25 May 2023 09:21:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com
Subject: Re: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230525092123.2a41c1e4.alex.williamson@redhat.com>
In-Reply-To: <ZGQfszAGGKhCp20q@nvidia.com>
References: <20230509040734.24392-1-ankita@nvidia.com>
        <20230516150914.26ae99c3.alex.williamson@redhat.com>
        <ZGQfszAGGKhCp20q@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 May 2023 21:28:35 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, May 16, 2023 at 03:09:14PM -0600, Alex Williamson wrote:
> 
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +config NVGPU_VFIO_PCI
> > > +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> > > +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > > +	select VFIO_PCI_CORE  
> > 
> > I think this should be a 'depends on' as well, that's what we have for
> > the other vfio-pci variant drivers.  
> 
> It should be removed completely, AFAICT:
> 
> config VFIO_PCI
>         tristate "Generic VFIO support for any PCI device"
>         select VFIO_PCI_CORE
> 
> Ensures it is turned on
> 
> if VFIO_PCI
> source "drivers/vfio/pci/mlx5/Kconfig"
> endif

The source command actually comes after the VFIO_PCI endif, the mlx5
Kconfig is sourced if PCI && MMU.

> Autoamtically injects a 'depends on VFIO_PCI' to all the enclosed
> kconfig statements (and puts them nicely in the menu)
> 
> So we have everything needed already
> 
> SELECT is the correct action since it doesn't have a config text.

In fact I think it's the current variant drivers that are incorrect to
make use of 'depends on', this makes those variant drivers implicitly
depend on VFIO_PCI, but it should instead be possible to build a kernel
that doesn't include vfio-pci but does include mlx5-vfio-pci, or other
vfio-pci variant drivers.  Currently if I disable VFIO_PCI I no longer
have the option to select either the mlx5 or hisi_acc drivers, they
actually depend only on VFIO_PCI_CORE, but currently only VFIO_PCI can
select VFIO_PCI_CORE.

I withdraw my objection to using select, the other variant drivers
should adopt select as well, imo.
 
> > Is our test for vm_end < vm_start in vfio-pci-core just paranoia?  I
> > don't see an equivalent here.  
> 
> Yes, mm core will not invoke the op with something incorrect.
>  
> > Can we also get a comment in the code outlining the various reasons
> > that this "BAR" doesn't need the disabled access protections that
> > vfio-pci-core implements?  For example outlining the behavior relative
> > to BAR access while the memory enable bit is disabled, the bus being in
> > reset, or the device being in a low-power state.  
> 
> The HW has some "isolation" feature that kicks in and safely
> disconnects the GPU from the CPU.
> 
> A lot of work has been done to make things like VFIO and KVM safe
> against machine checks/etc under basically all circumstances.

So a comment in the code to reflect that the hardware takes this into
account such that we don't need to worry about mmap access during bus
reset or otherwise disabled MMIO access of the PCI device would not be
unreasonable.  Thanks,

Alex

