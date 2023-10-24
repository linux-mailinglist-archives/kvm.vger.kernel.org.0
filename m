Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF67D5409
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 16:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343518AbjJXO3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 10:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbjJXO3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 10:29:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9F2111
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698157740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdQMnez5jsVqyd2k1Qq2RfvliqO19PHfA3+OAlVzE/o=;
        b=UWMcEI/RaiYkBRSlPJBTaJWiPbuVPY0y6VDwsvP1O59r2cAYfVAZ2VTJn2xDEm61wGHwIc
        ageOxcGlHOoo6yiEDrGkgwSaFp6RNmw7V/AKwlmU5XZ4BH0Ep7c0bRgWXGg8OZO5422e6G
        boN1gdo5I6U3CPnk47PrQNcIWU8UQwY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-DLi5qpLwNLSiF3_mA2xXeA-1; Tue, 24 Oct 2023 10:28:59 -0400
X-MC-Unique: DLi5qpLwNLSiF3_mA2xXeA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7a668ae1d18so499618239f.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:28:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698157737; x=1698762537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SdQMnez5jsVqyd2k1Qq2RfvliqO19PHfA3+OAlVzE/o=;
        b=bMtrkbeLOXYB0yT/yVdL6N2VJgFMtIUfLlWzhDQQPnI69Zu8mSAedQEwHBrye3Qde0
         abzKr+2n4WpF24mtkPsTaJ42PCOpWWZvYPl6U99k8eVMw4s5y+NwFQAUzha5PwDvlbZr
         S/kgGPDF7rPg5LviF6dB7DslSiWGRI7HmdkRittiy+mqbIFyz9nhIhy9M1QYLUUEykjO
         dAfGSenG/zNvBnxFknMBB2cNWNRLHy/QIT3FtEK7eGYKwwEdPxwxyWywJG7dEPcc5RK2
         TRDaPhlA68v3Enjg96UXkinSeZqQXhkl53Y95hfdCHgRPS+ROE1IGRewyOtVrsDbUrvO
         Geyg==
X-Gm-Message-State: AOJu0YxEnWC3XsAjFYJMDqDblfWkKC2QaT3+l0HnfifMuX88GWqcfvcO
        AoTcZFeqsuytzogjFYItepTJNHS+vIzDe2PfLxRQ/ltoq3/73tnMNVjE7e+Wcp9O/7RDkF0/B+c
        jtKmOlx3DuyTW
X-Received: by 2002:a05:6602:1351:b0:791:16ba:d764 with SMTP id i17-20020a056602135100b0079116bad764mr15985586iov.16.1698157737306;
        Tue, 24 Oct 2023 07:28:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGECoZ+Q9/pwe0atoZJEF3w53tDNXKGVumNA2abMQm5XZ51/BkbnhAED2BkG826qksKaARC+g==
X-Received: by 2002:a05:6602:1351:b0:791:16ba:d764 with SMTP id i17-20020a056602135100b0079116bad764mr15985570iov.16.1698157737057;
        Tue, 24 Oct 2023 07:28:57 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a19-20020a02ac13000000b00459d7c3dcf3sm2822147jao.115.2023.10.24.07.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 07:28:56 -0700 (PDT)
Date:   Tue, 24 Oct 2023 08:28:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231024082854.0b767d74.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Oct 2023 14:03:25 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> > After looking at Yishai's virtio-vfio-pci driver where BAR0 is emula=
ted
> >> > as an IO Port BAR, it occurs to me that there's no config space
> >> > emulation of BAR2 (or BAR3) here.=C2=A0 Doesn't this mean that QEMU =
registers
> >> > the BAR as 32-bit, non-prefetchable?=C2=A0 ie. VFIOBAR.type & .mem64=
 are
> >> > wrong? =20
> >>
> >> Maybe I didn't understand the question, but the PCI config space read/=
write
> >> would still be handled by vfio_pci_core_read/write() which returns the
> >> appropriate flags. I have checked that the device BARs are 64b and
> >> prefetchable in the VM. =20
> >
> > vfio_pci_core_read/write() accesses the physical device, which doesn't
> > implement BAR2.=C2=A0 Why would an unimplemented BAR2 on the physical d=
evice
> > report 64-bit, prefetchable?
> >
> > QEMU records VFIOBAR.type and .mem64 from reading the BAR register in
> > vfio_bar_prepare() and passes this type to pci_register_bar() in
> > vfio_bar_register().=C2=A0 Without an implementation of a config space =
read
> > op in the variant driver and with no physical implementation of BAR2 on
> > the device, I don't see how we get correct values in these fields. =20
>=20
> I think I see the cause of confusion. There are real PCIe compliant BARs
> present on the device, just that it isn't being used once the C2C
> interconnect is active. The BARs are 64b prefetchable. Here it the lspci
> snippet of the device on the host.
> # lspci -v -s 9:1:0.0
> 0009:01:00.0 3D controller: NVIDIA Corporation Device 2342 (rev a1)
>         Subsystem: NVIDIA Corporation Device 16eb
>         Physical Slot: 0-5
>         Flags: bus master, fast devsel, latency 0, IRQ 263, NUMA node 0, =
IOMMU group 19
>         Memory at 661002000000 (64-bit, prefetchable) [size=3D16M]
>         Memory at 662000000000 (64-bit, prefetchable) [size=3D128G]
>         Memory at 661000000000 (64-bit, prefetchable) [size=3D32M]
>=20
> I suppose this answers the BAR sizing question as well?

Does this BAR2 size match the size we're reporting for the region?  Now
I'm confused why we need to intercept the BAR2 region info if there's
physically a real BAR behind it.  Thanks,

Alex

