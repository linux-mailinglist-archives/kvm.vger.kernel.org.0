Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DBA7D6F0B
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjJYOVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbjJYOVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D195E13A
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698243623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1yh9aFBXnB/uUDqIchESZqamQpwZAPHQV0zqqMljjg=;
        b=KPW6x6rVg7rgOsqO8KUx/BD1X22FUcAV5tt2tTyWxHS7nXLrBOXmMFy/lNu4jxc2dhIVaB
        xFFUmi93uYgWoazqOB7ku5Qgfr3WnPTLxjCv2owQ18RKI5WMQY8wEqBhR5ugKurqwlno1U
        RFXPd7bG6f+sgl3IQU6xn07xEprsWas=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-zFBRW_o4MVS7AFs5J7n3mQ-1; Wed, 25 Oct 2023 10:20:22 -0400
X-MC-Unique: zFBRW_o4MVS7AFs5J7n3mQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7a16fe687aaso603345839f.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698243622; x=1698848422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1yh9aFBXnB/uUDqIchESZqamQpwZAPHQV0zqqMljjg=;
        b=Ek9rfXjvjzt/DvZHncliITruWPr2buIcN+gF6h8jPGpcIZV6q2kn2YHb9hSO/bn5pi
         zTJybJMp9XJlnanqYqJgk2IG31N2TapRGEdgl1QlhnEjHggGAxWeSkW9cXalMXIlUQMK
         CHtQtWNzaeEUERd673UsQwI4IhFzY1YdgHQuFIcUDKNEk3XGW5n/AMymzqE/nz+3zgC2
         +QEu4Alhq5S/tKfALSMJsJzkaxiBTwRtZGnCHdPP70eh1vQ7X4OvVr6GpLlPYtE3Z7Pt
         x585uIbQiMPe+4qh3zx6zZI7AMxzyi4GDKzBt9yqNH08ItbGzMOT4dercn2CqWjmbgtZ
         UNjQ==
X-Gm-Message-State: AOJu0YykfGhDj3YwEDSipbs0WRwFyHQUcFCba3CBZ6yTT+B0JdSHpISO
        yfjh3C6KERUcUVu7zuQfpU1QAkMSZvOMMvdefOv+P7Za7HZ5Z8QS/OsgL7ypiKMN2TLUvQ8PILJ
        TTj7Y7lSj266R
X-Received: by 2002:a05:6e02:12c6:b0:357:a04c:31d2 with SMTP id i6-20020a056e0212c600b00357a04c31d2mr20557626ilm.16.1698243621710;
        Wed, 25 Oct 2023 07:20:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKwcXNmgBx56Nwj0CHsxsSuQrL5I2Rqp2efJfKlsiSWqJhSMRfzxIfmT0Id8DMwf8cHqeybw==
X-Received: by 2002:a05:6e02:12c6:b0:357:a04c:31d2 with SMTP id i6-20020a056e0212c600b00357a04c31d2mr20557588ilm.16.1698243621425;
        Wed, 25 Oct 2023 07:20:21 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a18-20020a92d352000000b0035742971dd3sm3769998ilh.16.2023.10.25.07.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 07:20:20 -0700 (PDT)
Date:   Wed, 25 Oct 2023 08:20:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ankit Agrawal <ankita@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
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
Message-ID: <20231025082019.14575863.alex.williamson@redhat.com>
In-Reply-To: <BY5PR12MB376386DD53954BC3233AF595B0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231024082854.0b767d74.alex.williamson@redhat.com>
        <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
        <BY5PR12MB376386DD53954BC3233AF595B0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Oct 2023 12:43:24 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> While the physical BAR is present on the device, it is not being used on =
the host
> system. The access to the device memory region on the host occur through =
the
> C2C interconnect link (not the PCIe) and is present for access as a separ=
ate memory
> region in the physical address space on the host. The variant driver quer=
ies this range
> from the host ACPI DSD tables.

BTW, it's still never been answered why the latest QEMU series dropped
the _DSD support.

> Now, this device memory region on the host is exposed as a device BAR in =
the VM.
> So the device BAR in the VM is actually mapped to the device memory regio=
n in the
> physical address space (and not to the physical BAR) on the host. The con=
fig space
> accesses to the device however, are still going to the physical BAR on th=
e host.
>=20
> > Does this BAR2 size match the size we're reporting for the region?=C2=
=A0 Now
> > I'm confused why we need to intercept the BAR2 region info if there's
> > physically a real BAR behind it.=C2=A0 Thanks, =20
>=20
> Yes, it does match the size being reported through region info. But the r=
egion
> info ioctl is still intercepted to provide additional cap to establish th=
e sparse
> mapping. Why we do sparse mapping? The actual device memory size is not
> power-of-2 aligned (a requirement for a BAR). So we roundup to the next
> power-of-2 value and report the size as such. Then we utilize sparse mapp=
ing
> to show only the actual size of the device memory as mappable.

Yes, it's clear to me why we need the sparse mapping and why we
intercept the accesses, but the fact that there's an underlying
physical BAR of the same size in config space has been completely
absent in any previous discussions.

In light of that, I don't think we should be independently calculating
the BAR2 region size using roundup_pow_of_two(nvdev->memlength).
Instead we should be using pci_resource_len() of the physical BAR2 to
make it evident that this relationship exists.

The comments throughout should also be updated to reflect this as
currently they're written as if there is no physical BAR2 and we're
making a completely independent decision relative to BAR2 sizing.  A
comment should also be added to nvgrace_gpu_vfio_pci_read/write()
explaining that the physical BAR2 provides the correct behavior
relative to config space accesses.

The probe function should also fail if pci_resource_len() for BAR2 is
not sufficient for the coherent memory region.  Thanks,

Alex

