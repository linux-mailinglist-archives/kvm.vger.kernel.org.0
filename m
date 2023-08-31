Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B53578F279
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 20:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345932AbjHaSWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 14:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346889AbjHaSWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 14:22:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDF6E61
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693506115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kDd6agFPPBZ563tT5sO0tAnh1fA6v2usb5U/Ua+TJqU=;
        b=MLzT2lKF9dlG5mDqUs+P+QmurC7IL94GzPxuU1JJUuHN1JL9831HSOBEGitXfNSDy7MbBE
        nHxVCFdOEbyPXp7WgOOpwwlheP1YyHogWU5Rchvmr3PoR1Ahu4qgCfAM5NsMX7juhuCPJb
        zrVKJeYc6rVhhcgIwyG71s8Zf8xG71w=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-uKZIOWviOqe6p4JiR8l0UA-1; Thu, 31 Aug 2023 14:21:53 -0400
X-MC-Unique: uKZIOWviOqe6p4JiR8l0UA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34de9c47d75so7331335ab.3
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 11:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693506113; x=1694110913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kDd6agFPPBZ563tT5sO0tAnh1fA6v2usb5U/Ua+TJqU=;
        b=N/9qAoC781bCwE0ev+bFL5eH4a274yua0JkojaMpZ1UKCFc5nvLUr/qdr3UQdnP6G7
         0RPfn16wc1PR9OKuyc+sy/y6XokHLNwfXfGg6H85xhKESA+1slmgFjnnQvaHt+RBIUHB
         qBmoI3rSrhBYKa6it44zsuw45xldiLb7JQ+ELzwyE+ZKOmwcmIy8Z/v30bA9sEFA0SKz
         K6DNKFum3vZwjeGxqrYMLlmZ4aytc3OieakLDtLt1Fbl1isMnJtIFEgL/4alOAQjF/Co
         T6F/muzzgUMH6IT+3KxukB55pgPB2sv1ckpCHiQAITXQHUI167fm6fMjHJeWEP8Icr0H
         4Shg==
X-Gm-Message-State: AOJu0Yyn/yga27V4Mr/Pev21U6rsN93laGf2tRWD6zklzMd4/QnIqsrW
        kAGk8h7mYcv4Od7cdKS7uFjTokYa9QUh0ELedsd9Z5pkMF9bAYUt/CSigihB4su6h1acfJ0zp6M
        CIkAb6PmjNpym
X-Received: by 2002:a05:6e02:eec:b0:34c:e16d:6796 with SMTP id j12-20020a056e020eec00b0034ce16d6796mr329533ilk.16.1693506112878;
        Thu, 31 Aug 2023 11:21:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8vns95higbpw7EtaVkzMpHzdrkGJ9Y2vvSqykV851tdz6ITxD49qYcHcmB/e7+Q3TZCiTtw==
X-Received: by 2002:a05:6e02:eec:b0:34c:e16d:6796 with SMTP id j12-20020a056e020eec00b0034ce16d6796mr329518ilk.16.1693506112687;
        Thu, 31 Aug 2023 11:21:52 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id w18-20020a92c892000000b00345da2c4776sm557598ilo.81.2023.08.31.11.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 11:21:51 -0700 (PDT)
Date:   Thu, 31 Aug 2023 12:21:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ankit Agrawal <ankita@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230831122150.2b97511b.alex.williamson@redhat.com>
In-Reply-To: <ZPCd2sHXrAZHjsHg@infradead.org>
References: <20230822202303.19661-1-ankita@nvidia.com>
        <ZO9JKKurjv4PsmXh@infradead.org>
        <ZO9imcoN5l28GE9+@nvidia.com>
        <ZPCG9/P0fm88E2Zi@infradead.org>
        <BY5PR12MB37631B2F41DB62CBDD7B1F69B0E5A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <ZPCd2sHXrAZHjsHg@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Aug 2023 07:04:10 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Aug 31, 2023 at 01:51:11PM +0000, Ankit Agrawal wrote:
> > Hi Christoph,
> >   
> > >Whats the actual consumer running in a qemu VM here?  
> > The primary use case in the VM is to run the open source Nvidia
> > driver (https://github.com/NVIDIA/open-gpu-kernel-modules)
> > and workloads.  
> 
> So this infrastructure to run things in a VM that we don't even support
> in mainline?  I think we need nouveau support for this hardware in the
> drm driver first, before adding magic vfio support.

There's really never a guarantee that the thing we're exposing via the
vfio uAPI has mainline drivers, for example we don't consult the
nouveau device table before we expose an NVIDIA GPU to a Windows guest
running proprietary device drivers.

We've also never previously made a requirement that any new code in
vfio must directly contribute to supporting a mainline driver, in fact
I think you'll find examples where we do have such code.

This driver is proposing to expose a coherent memory region associated
with the device, composed as a PCI BAR, largely to bring it into the
vfio device model.  Access to that memory region is still pass-through.
This is essentially behavior that we also enable though mdev drivers
like kvmgt (modulo the coherent aspect).

I assume the above driver understands how to access and make use of
this coherent memory whether running bare-metal or virtualized, so
potentially we have some understanding of how it's used by the driver,
which can't be said for all devices used with vfio.  I'm therefore not
sure how we can suddenly decide to impose a mainline driver requirement
for exposing a device to userspace.  Thanks,

Alex

