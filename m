Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9D7D6F81
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344943AbjJYOat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344931AbjJYOan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD270132
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698244192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clFd29QeDWnwn0GXLK2EBVzyNpuURUgqAcJDTvU+22I=;
        b=U8izMxsqQyRahqViLsh5u9zUOhyH0AhP1X14Ww4TurRlY3YAa+jafT/hEOOD517YypMHOi
        sj4d6pL5b+QY+4RcKDwaGr9EaisVmxktOPD+Om5uzK7DlLK7hVEVzojWbLKSeU9UrauyP9
        XIs8EVsz76gKXJ/Yi1rRiHj+49plFlE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-EUoiDYPhOpmgL3wIbzQMtA-1; Wed, 25 Oct 2023 10:29:50 -0400
X-MC-Unique: EUoiDYPhOpmgL3wIbzQMtA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-357c8d93b1bso47204475ab.0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698244190; x=1698848990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clFd29QeDWnwn0GXLK2EBVzyNpuURUgqAcJDTvU+22I=;
        b=pfO0gk5cEElC+v88Y+zDHC4qU5sDJaEYMJ0b+dRi4goE+O8TmTiOe51tqI2KW1iSNs
         QIzswV7FgAWL6+lK49YTlZsEzOvbHboO2IuVYKdEpMOibk4yvI3yLTwNebFR/yQfwa5q
         kpzDh5Uenvmz0KbVTYzWKK+9nRj58ZB0qGOIlG92Kh1JwMJlxIm1Zclssq6oBTQ37aNj
         pVk7dUu2CQKTsBBnnw/DAdlLkVvsvB1xcO8CkS5bpGcmgapNWSGdKVyq8DIWfAy+iHxJ
         7OYEDTs91uF+JfspDh9EoNrTIIQ9Zydxim0hCuvpGDFNunITcChclthKKK9+n+SZSjO1
         88SA==
X-Gm-Message-State: AOJu0YzWNPpasUizR2+yyRzdZFlqfQIiXqucXqZH8fXuSl9X/plbOQgO
        NwgMkPeK3Nv6V7IJI1TYoNpV3PaaxvpuNlzFz6hzWVzIYezg+xjy4gaIJXb+bZrXRyyqPfflqM+
        8VXQhT1b9MapE
X-Received: by 2002:a92:dc02:0:b0:357:fa1b:475 with SMTP id t2-20020a92dc02000000b00357fa1b0475mr1918074iln.10.1698244189928;
        Wed, 25 Oct 2023 07:29:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6/mm7xg+tqsYYT06Tao2qBsLe5d3EVw1veyQKDmmT2B2lvS3D7AxwCL48WgNlBFEzd/DMzw==
X-Received: by 2002:a92:dc02:0:b0:357:fa1b:475 with SMTP id t2-20020a92dc02000000b00357fa1b0475mr1918051iln.10.1698244189642;
        Wed, 25 Oct 2023 07:29:49 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id m18-20020a92c532000000b0035298bd42a8sm3798992ili.20.2023.10.25.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 07:29:49 -0700 (PDT)
Date:   Wed, 25 Oct 2023 08:29:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Ankit Agrawal <ankita@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231025082947.6094361d.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231024082854.0b767d74.alex.williamson@redhat.com>
        <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Oct 2023 08:28:44 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, October 24, 2023 10:29 PM
> >=20
> > On Tue, 24 Oct 2023 14:03:25 +0000
> > Ankit Agrawal <ankita@nvidia.com> wrote:
> >  =20
> > > >> > After looking at Yishai's virtio-vfio-pci driver where BAR0 is e=
mulated
> > > >> > as an IO Port BAR, it occurs to me that there's no config space
> > > >> > emulation of BAR2 (or BAR3) here.=C2=A0 Doesn't this mean that Q=
EMU =20
> > registers =20
> > > >> > the BAR as 32-bit, non-prefetchable?=C2=A0 ie. VFIOBAR.type & .m=
em64 are
> > > >> > wrong? =20
> > > >>
> > > >> Maybe I didn't understand the question, but the PCI config space =
=20
> > read/write =20
> > > >> would still be handled by vfio_pci_core_read/write() which returns=
 the
> > > >> appropriate flags. I have checked that the device BARs are 64b and
> > > >> prefetchable in the VM. =20
> > > >
> > > > vfio_pci_core_read/write() accesses the physical device, which does=
n't
> > > > implement BAR2.=C2=A0 Why would an unimplemented BAR2 on the physic=
al =20
> > device =20
> > > > report 64-bit, prefetchable?
> > > >
> > > > QEMU records VFIOBAR.type and .mem64 from reading the BAR register =
=20
> > in =20
> > > > vfio_bar_prepare() and passes this type to pci_register_bar() in
> > > > vfio_bar_register().=C2=A0 Without an implementation of a config sp=
ace read
> > > > op in the variant driver and with no physical implementation of BAR=
2 on
> > > > the device, I don't see how we get correct values in these fields. =
=20
> > >
> > > I think I see the cause of confusion. There are real PCIe compliant B=
ARs
> > > present on the device, just that it isn't being used once the C2C
> > > interconnect is active. The BARs are 64b prefetchable. Here it the ls=
pci
> > > snippet of the device on the host.
> > > # lspci -v -s 9:1:0.0
> > > 0009:01:00.0 3D controller: NVIDIA Corporation Device 2342 (rev a1)
> > >         Subsystem: NVIDIA Corporation Device 16eb
> > >         Physical Slot: 0-5
> > >         Flags: bus master, fast devsel, latency 0, IRQ 263, NUMA node=
 0, =20
> > IOMMU group 19 =20
> > >         Memory at 661002000000 (64-bit, prefetchable) [size=3D16M]
> > >         Memory at 662000000000 (64-bit, prefetchable) [size=3D128G]
> > >         Memory at 661000000000 (64-bit, prefetchable) [size=3D32M]
> > >
> > > I suppose this answers the BAR sizing question as well? =20
> >=20
> > Does this BAR2 size match the size we're reporting for the region?  Now
> > I'm confused why we need to intercept the BAR2 region info if there's
> > physically a real BAR behind it.  Thanks,
> >  =20
>=20
> same confusion.
>=20
> probably vfio-pci-core can include a helper for cfg space emulation
> on emulated BARs to be used by all variant drivers in that category?
>=20
> btw intel vgpu also includes an emulation of BAR sizing. same for
> future SIOV devices. so there sounds like a general requirement but
> of course sharing it between vfio-pci and mdev/siov would be more
> difficult.

Yes, I see a need for this in the virtio-vfio-pci driver as well.  It
would simplify config emulation a lot if the variant driver could
manipulate the perm_bits.virt and .write bit arrays and simply update
vconfig for things like device-id and revision.  Thanks,

Alex

