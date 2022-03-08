Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8EF4D2196
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349618AbiCHTeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349605AbiCHTeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:34:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA7F153E00
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646767997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmFvlno7qSph5d/HcceOLIPkKssn1EWwfPpWF2drkf8=;
        b=UD5qHH96lfvSSr1C6bXNDWeIpIrPW4bGiTIocBD+Dfg8Uw/ejoWznyfRdmwDaX7YuhbcJ1
        9avAuWiFtx0NTBJTvQvlIuMQSYlm80gvVrbw3WyfEHN1Ul8Qe9EfV0Ah+lLJ4H8M1dHz3r
        54U4oV/XxiQwwT+UIlqaztFNtNXWhtw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-qVSSpg0kNO2tr1Gz54sgzA-1; Tue, 08 Mar 2022 14:33:16 -0500
X-MC-Unique: qVSSpg0kNO2tr1Gz54sgzA-1
Received: by mail-il1-f198.google.com with SMTP id y7-20020a056e02128700b002c62013aaa6so8026325ilq.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bmFvlno7qSph5d/HcceOLIPkKssn1EWwfPpWF2drkf8=;
        b=JnIc5OFk9r2ciTesszMkC14z6kBKYhMsfBKt+oZpdexTEtSqQYvhBZwtf0kaekNN+0
         v4vYPxx92jiKiKXrjiQsNhl1icyEQxT2Ji+Db8/QSTQMMJ9aeQNpM5fjXDnMBs0smWoe
         sPFRJv9uuGZA09lRmx1qjH7rcuOgaT0cbo4BGbRI8b16F+X7z/6RpxsvXGRCKjDBgyDd
         60xnynbgI4rKFCweIad/vmodD0kBJbYfqdw2iHMLOGGUr5pvKaw+Z6K5LasH9K0lGtU9
         17yAfqRlz586T8ANBnIYCclG1Mu9sF/NO0lSHtUseBrOtNznqvS+UP3BFwTd2yxngIRx
         NAVQ==
X-Gm-Message-State: AOAM5308buduX+duryMzqQMlqBepZSDIDV5rvTPqj/DiyWkwnoPsB4yO
        yRiC/HIGGGPMMScLg6nOBBem4SAgVos0MroeUF2fXcfApuPYWCMpnLNgXhltzs5A40kO71rQezR
        059kYQFEtY+pp
X-Received: by 2002:a05:6638:3014:b0:317:9daf:c42c with SMTP id r20-20020a056638301400b003179dafc42cmr16033250jak.10.1646767995273;
        Tue, 08 Mar 2022 11:33:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDpYCevcieEIuPGlNXODXoatrNQxiFQEvGtMSUMx1SJ+hhy7jWFeUDPSTwNXSqLKnEDsZnrQ==
X-Received: by 2002:a05:6638:3014:b0:317:9daf:c42c with SMTP id r20-20020a056638301400b003179dafc42cmr16033227jak.10.1646767995008;
        Tue, 08 Mar 2022 11:33:15 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k5-20020a5d97c5000000b006412c791f90sm10607942ios.31.2022.03.08.11.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:33:14 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:33:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220308123312.1f4ba768.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
 <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
 <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Mar 2022 08:11:11 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, March 8, 2022 3:53 AM =20
> > > =20
> > > > I think we still require acks from Bjorn and Zaibo for select patch=
es
> > > > in this series. =20
> > >
> > > I checked with Ziabo. He moved projects and is no longer looking into=
 =20
> > crypto stuff. =20
> > > Wangzhou and LiuLongfang now take care of this. Received acks from =20
> > Wangzhou =20
> > > already and I will request Longfang to provide his. Hope that's ok. =
=20
> >=20
> > Maybe a good time to have them update MAINTAINERS as well.  Thanks,
> >  =20
>=20
> I have one question here (similar to what we discussed for mdev before).
>=20
> Now we are adding vendor specific drivers under /drivers/vfio. Two drivers
> on radar and more will come. Then what would be the criteria for=20
> accepting such a driver? Do we prefer to a model in which the author shou=
ld
> provide enough background for vfio community to understand how it works=20
> or as done here just rely on the PF driver owner to cover device specific
> code?
>=20
> If the former we may need document some process for what information
> is necessary and also need secure increased review bandwidth from key
> reviewers in vfio community.
>=20
> If the latter then how can we guarantee no corner case overlooked by both
> sides (i.e. how to know the coverage of total reviews)? Another open is w=
ho
> from the PF driver sub-system should be considered as the one to give the
> green signal. If the sub-system maintainer trusts the PF driver owner and
> just pulls commits from him then having the r-b from the PF driver owner =
is
> sufficient. But if the sub-system maintainer wants to review detail change
> in every underlying driver then we probably also want to get the ack from
> the maintainer.
>=20
> Overall I didn't mean to slow down the progress of this series. But above
> does be some puzzle occurred in my review. =F0=9F=98=8A

Hi Kevin,

Good questions, I'd like a better understanding of expectations as
well.  I think the intentions are the same as any other sub-system, the
drivers make use of shared interfaces and extensions and the role of
the sub-system should be to make sure those interfaces are used
correctly and extensions fit well within the overall design.  However,
just as the network maintainer isn't expected to fully understand every
NIC driver, I think/hope we have the same expectations here.  It's
certainly a benefit to the community and perceived trustworthiness if
each driver outlines its operating model and security nuances, but
those are only ever going to be the nuances identified by the people
who have the access and energy to evaluate the device.

It's going to be up to the community to try to determine that any new
drivers are seriously considering security and not opening any new gaps
relative to behavior using the base vfio-pci driver.  For the driver
examples we have, this seems a bit easier than evaluating an entire
mdev device because they're largely providing direct access to the
device rather than trying to multiplex a shared physical device.  We
can therefore focus on incremental functionality, as both drivers have
done, implementing a boilerplate vendor driver, then adding migration
support.  I imagine this won't always be the case though and some
drivers will re-implement much of the core to support further emulation
and shared resources.

So how do we as a community want to handle this?  I wouldn't mind, I'd
actually welcome, some sort of review requirement for new vfio vendor
driver variants.  Is that reasonable?  What would be the criteria?
Approval from the PF driver owner, if different/necessary, and at least
one unaffiliated reviewer (preferably an active vfio reviewer or
existing vfio variant driver owner/contributor)?  Ideas welcome.
Thanks,

Alex

