Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56025E7C76
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiIWODU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiIWODS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 10:03:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB3613A04D
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663941794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4w0e2qKjVlL2l3TiYoyEN7yHr9QOPhW8hihiff8HOpE=;
        b=QEBLIk63X6hJTxQLsDQ0VoaNNCrbojmQPSWtPZ7vBtUeX/SUsdtuB1zWggAbR9r9bDSJ2g
        ZCsKbYnirOhk04X5w0b7dFvp/iYBgRt+TsCQBLJnnvSfLNc9JmYLtgkIUgxdUo6Z9qO7FB
        kU8+xrHBe1vvPDeaunvIuEQWZ/VpNFA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-1tEV-Up7MACmp7SlWlun9A-1; Fri, 23 Sep 2022 10:03:12 -0400
X-MC-Unique: 1tEV-Up7MACmp7SlWlun9A-1
Received: by mail-io1-f69.google.com with SMTP id 5-20020a5d9c05000000b006a44709a638so275298ioe.11
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 07:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=4w0e2qKjVlL2l3TiYoyEN7yHr9QOPhW8hihiff8HOpE=;
        b=5bGU5qbMyp3+Kb7X9pP6wN/fbOApu6itbvKoKK9pmWdynlHoaGUpJ4na7CNE1wNkej
         SaVFQRWMgM3zXuSZdLVz5tvuR4YeF5k+zqCShX2K8/UM8Ir3p8PC9PkIulNNrrDkb1bE
         lnM4talWMOcFKuki+IzSTdf0h7sCvjKOtlC5kLu0etFUdsJQdRSrA6cFMPe44jm9i9zD
         aXoEo4e1uFWvFtYeeomea4c1z4TlX9aoV2nPAsIOrwU0kSsx5k2bBvt5jtOW2Geslclg
         X46mY4dimONNWG3nfDqLZN7+6GKpQsX0sWDpPB0arY5lQBVJrbClfC1rMAE39Hi+75Gc
         zPAg==
X-Gm-Message-State: ACrzQf1wnOQZSGnq/o2+/vJrCiJOPknb/NcCq7CNuY2Hmb0Cr+bnFCCv
        aTAAp4IRFeUXcrEGyM6mMGCWKACxtqfgY1kq10uVHa8NLXfNZnpYC+mWPhJbkqZvoLx5/5Tv1WX
        hoVKUnllWpBr9
X-Received: by 2002:a05:6638:4907:b0:35a:88c3:594d with SMTP id cx7-20020a056638490700b0035a88c3594dmr4833169jab.194.1663941791988;
        Fri, 23 Sep 2022 07:03:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rtG+aKW4uVpVRTemjU1wMA9ul0qLImqNjuSlGdG9o3Ayhgtkv7S2ZB45Ft3viH7Z1kZz4gw==
X-Received: by 2002:a05:6638:4907:b0:35a:88c3:594d with SMTP id cx7-20020a056638490700b0035a88c3594dmr4833120jab.194.1663941791435;
        Fri, 23 Sep 2022 07:03:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t1-20020a028781000000b003428c21ed12sm3404639jai.167.2022.09.23.07.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 07:03:10 -0700 (PDT)
Date:   Fri, 23 Sep 2022 08:03:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <20220923080307.1d9a6166.alex.williamson@redhat.com>
In-Reply-To: <Yy20xURdYLzf0ikS@nvidia.com>
References: <Yyoa+kAJi2+/YTYn@nvidia.com>
        <20220921120649.5d2ff778.alex.williamson@redhat.com>
        <YytbiCx3CxCnP6fr@nvidia.com>
        <YyxFEpAOC2V1SZwk@redhat.com>
        <YyxsV5SH85YcwKum@nvidia.com>
        <Yyx13kXCF4ovsxZg@redhat.com>
        <Yyx2ijVjKOkhcPQR@nvidia.com>
        <Yyx4cEU1n0l6sP7X@redhat.com>
        <Yyx/yDQ/nDVOTKSD@nvidia.com>
        <Yy10WIgQK3Q74nBm@redhat.com>
        <Yy20xURdYLzf0ikS@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 23 Sep 2022 10:29:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrang=C3=A9 wrote:
>=20
> > Yes, we use cgroups extensively already. =20
>=20
> Ok, I will try to see about this
>=20
> Can you also tell me if the selinux/seccomp will prevent qemu from
> opening more than one /dev/vfio/vfio ? I suppose the answer is no?

QEMU manages the container:group association with legacy vfio, so it
can't be restricted from creating multiple containers.  Thanks,

Alex

