Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1B792679
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbjIEQDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354804AbjIEOcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 10:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD50199
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 07:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693924283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzenq7VqMMCkwJKsd3mDOY8BIzQvuIbJSxbV97ojg0w=;
        b=Ad5w9qK8S2xzJjPyXPTdPWRtosjOGXAjcdnz35LEZchUGiHCC90dZQJ7Nq8c177q6Jy4nY
        53cT7PQ3A0BEKQUwSp4BuZeeS/csw7Vxg5TEqcESRjE7TB8gCLnUtiBBOGcwrN/NuKAfwb
        RazMHqv12tiu2i0wRsQnt8Uxub2h/CE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-XMhbeZrNPQKLMaTU_U2jaA-1; Tue, 05 Sep 2023 10:31:22 -0400
X-MC-Unique: XMhbeZrNPQKLMaTU_U2jaA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34e1bf8c73dso15494615ab.1
        for <kvm@vger.kernel.org>; Tue, 05 Sep 2023 07:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693924281; x=1694529081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bzenq7VqMMCkwJKsd3mDOY8BIzQvuIbJSxbV97ojg0w=;
        b=iYQyw9lnH5UH9aGKMzpsxIlv638Y3X7F3UG4carGckkXM5oOeN7Pf964REJO11mK67
         P4ZJaUBd7+i4a8WEfpdeKbwosFYlOWDkmWrsfkHASas9Y3DEs/i1kn8pzYJupaHHxLeR
         B7yYg4z5BE3K/QdcKsQ+YG/joYCpUshWNY0cQkddLLicYoTcAwWtpuyibCe5mup0DA57
         UQ/GJ2A0wRjcSrVyUdQhFFLn5vs2YWeQQRBzgC+4BnRMoXFWTmddYFT+LtrsWyOaCPCL
         tJ7HjBpPfgJFhLkH1kcXCRj6XaahWTNuCZ1GMv+Y5JySnapfF/U6FL798Nd+8ntZsoXf
         cptw==
X-Gm-Message-State: AOJu0Yy3K6jSY8cgDiTxdFa15NIMRJEmgXnRqBfWC6Yx/LvOugCqX3wo
        V5eNbeYnEIffgc70/ZTRfjmGTj2gZVSu2XP0qvAfIxnAk8tZPc26HPWVxJOVXLj0yLIlZhpAimW
        hn2mbtBdf6fqG
X-Received: by 2002:a05:6e02:1546:b0:34f:22a6:7f64 with SMTP id j6-20020a056e02154600b0034f22a67f64mr2356887ilu.1.1693924281448;
        Tue, 05 Sep 2023 07:31:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyGxu88UZAZRlTw19DFI9aMUF5xkID0nsw3RuvJTzJTc5NTXg0lLNV0gwLtA4fgTd1j8Zc5w==
X-Received: by 2002:a05:6e02:1546:b0:34f:22a6:7f64 with SMTP id j6-20020a056e02154600b0034f22a67f64mr2356866ilu.1.1693924281229;
        Tue, 05 Sep 2023 07:31:21 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id m14-20020a924b0e000000b00345cce526cdsm4200396ilg.54.2023.09.05.07.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 07:31:20 -0700 (PDT)
Date:   Tue, 5 Sep 2023 08:31:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     oushixiong <oushixiong@kylinos.cn>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pds: Limit Calling dev_dbg function to
 CONFIG_PCI_ATS
Message-ID: <20230905083119.27cf3c03.alex.williamson@redhat.com>
In-Reply-To: <20230905024028.940377-1-oushixiong@kylinos.cn>
References: <20230905024028.940377-1-oushixiong@kylinos.cn>
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

On Tue,  5 Sep 2023 10:40:28 +0800
oushixiong <oushixiong@kylinos.cn> wrote:

> From: Shixiong Ou <oushixiong@kylinos.cn>
>=20
> If CONFIG_PCI_ATS isn't set, then pdev->physfn is not defined.
> So it causes a compilation issue:
>=20
> ../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: =E2=80=98struct pci_dev=
=E2=80=99 has no member named =E2=80=98physfn=E2=80=99; did you mean =E2=80=
=98is_physfn=E2=80=99?
>   165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>       |                              ^~~~~~
>=20
> Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> ---
>  drivers/vfio/pci/pds/vfio_dev.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_=
dev.c
> index b46174f5eb09..18b4a6a5bc16 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -160,10 +160,13 @@ static int pds_vfio_init_device(struct vfio_device =
*vdev)
>  	vdev->log_ops =3D &pds_vfio_log_ops;
> =20
>  	pci_id =3D PCI_DEVID(pdev->bus->number, pdev->devfn);
> +
> +#ifdef CONFIG_PCI_ATS
>  	dev_dbg(&pdev->dev,
>  		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
>  		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
>  		pci_domain_nr(pdev->bus), pds_vfio);
> +#endif
> =20
>  	return 0;
>  }

AIUI, this whole driver is dependent on SR-IOV functionality, so perhaps
this should be gated at Kconfig?  Thanks,

Alex

