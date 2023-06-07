Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB672673A
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 19:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjFGRZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 13:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjFGRZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 13:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557562113
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 10:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686158664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qwwhpcf8WOTXyKUHwJfhM5kOdULMbQnXHWx83ndVdoU=;
        b=diHwT/g1z5iW236eB6Zm3sPbn2uGJDm/06hFSN9cVuxdPVfSbnQ8SM2j5FVkx1wHxOuDBa
        Vg6oYbl9JXKOiS0g7dk/d344z+hMRspEZpfP7YZ8zFOMyU5zyLmj2qARwl0W+8tvwWrZFV
        SAfslN8zgTr/45E/7lk99dZPjlVrlEM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-TY_ki6t9O6OVaCJqTC5O-A-1; Wed, 07 Jun 2023 13:24:22 -0400
X-MC-Unique: TY_ki6t9O6OVaCJqTC5O-A-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-766655c2cc7so581167339f.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 10:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686158661; x=1688750661;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qwwhpcf8WOTXyKUHwJfhM5kOdULMbQnXHWx83ndVdoU=;
        b=OW44VcjGBRLSCZDoBIU9bXKD9aJeto3obofeauxQ7S38QFkJL9sfrG6fSVGXKnvqoo
         dKRKrBj/dYNHlrvGhzjy5772SkBSGHAl3jrGNECZJWCtxd3c69oB8E91GkA3XTGD6vlP
         VJl8uWOGnTchHIdvcwAAGsjx40qUjRCVml9euOJ8AYGQTQvdmzfLl2KMDemhxG/Hy2Cm
         Nowxjv1YEmkpMcGAt4AVbJ2d1vizEqVgeUO2Rfyf6ebQT8olr0ymnmSvjiZQOaYMWtfa
         o4wUqZiTqojq6RV7g9+C7/rBbq++a76SEVrcDaJJYBdMC00ofPk0kL3YyXH8C2b3GLki
         qM+w==
X-Gm-Message-State: AC+VfDz6QhiMXyiVeMbz54bY3en/bl7MWIDUsTt2wJQLLvtXusHSDLRW
        F4mOL9AVfDnoCKwPCcCMW9GT4zQMYTIsso8GVe++QGu41OuU4n5gH/oLKTi2P/RYLmHL58yEXHL
        QKPHUjpHozQ2a
X-Received: by 2002:a5e:8715:0:b0:76f:48f2:49bf with SMTP id y21-20020a5e8715000000b0076f48f249bfmr8608482ioj.0.1686158661430;
        Wed, 07 Jun 2023 10:24:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6a3SiSGyuXsN8qtkoudjyhRcTCn4o6nMXrgKH8Kja0SEzHb7LtW/Y6touaelnbxa2nclGuJw==
X-Received: by 2002:a5e:8715:0:b0:76f:48f2:49bf with SMTP id y21-20020a5e8715000000b0076f48f249bfmr8608471ioj.0.1686158661197;
        Wed, 07 Jun 2023 10:24:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a17-20020a5d9ed1000000b0077024f8772esm3884637ioe.51.2023.06.07.10.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:24:20 -0700 (PDT)
Date:   Wed, 7 Jun 2023 11:24:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <20230607112417.1139a954.alex.williamson@redhat.com>
In-Reply-To: <ZH/A7X45jJprLEHx@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
        <20230602213315.2521442-2-alex.williamson@redhat.com>
        <ZH4U6ElPSC3wIp1E@nvidia.com>
        <20230605132518.2d536373.alex.williamson@redhat.com>
        <ZH9BvcgHvX7HFBAa@nvidia.com>
        <20230606155704.037a1f60.alex.williamson@redhat.com>
        <ZH/A7X45jJprLEHx@nvidia.com>
Organization: Red Hat
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

On Tue, 6 Jun 2023 20:27:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 06, 2023 at 03:57:04PM -0600, Alex Williamson wrote:
> > > Not really, maybe it creates a sysfs class, but it certainly doesn't
> > > do anything useful unless there is a vfio driver also selected.  
> > 
> > Sorry, I wasn't referring to vfio "core" here, I was thinking more
> > along the lines of when we include the PCI or IOMMU subsystem there's
> > a degree of base functionality included there regardless of what
> > additional options or drivers are selected.    
> 
> Lots of other cases are just like VFIO where it is the subsystem core
> that really doesn't do anything. Look at tpm, infiniband, drm, etc

This is getting a bit absurd, the build system should not be building
modules that have no users.  Maybe it's not a high enough priority to go
to excessive lengths to prevent it, but I don't see that we're doing
that here.
 
> > The current state is that we cannot build vfio-pci-core.ko without
> > vfio-pci.ko, so there's always an in-kernel user.    
> 
> I think I might have done that, and it wasn't done for that reason.. I
> just messed it up and didn't follow the normal pattern - and this
> caused these troubles with the wrong/missing depends/selects.

I didn't assume this was intentional, but the result of requiring a
built user of vfio-pci-core is not entirely bad.

> I view following the usual pattern as more valuable than a one off fix
> for what is really a systemic issue in kconfig. Which is why I made
> the patch to align with how CONFIG_VFIO works :)

Is using a menu and having drivers select the config option for the
core module they depend on really that unusual?  This all seems like
Kconfig 101.

Perhaps we should be more sensitive to this in vfio than other parts of
the kernel exactly because we're providing a userspace driver
interface.  We should disable as much as we can of that interface when
there are no in-kernel users of it.

I'm failing to see how "this is the way we do things" makes it correct
when we can trivially eliminate the possibility of building this
particular shared module when it has no users.  Thanks,

Alex

