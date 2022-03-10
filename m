Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85DC4D5343
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 21:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbiCJUvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 15:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245658AbiCJUvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 15:51:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADD7618644F
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 12:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646945397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wHyperqVD6yT4MZyOSDrCItm0ScJpHPiGZO3nX6coc=;
        b=dme5Spj3BzzmWYzkmx+4hVXJm3vJNXtajhD3vUv9xHvg9kh0tV61kxIm7RmiuzwaCkz8+C
        2+LuCi6po277se54UUIv8OV4yDOF+14aNMGs5GrEhZWPq18RwwQLtCelIq21SZDOaBAQr9
        jyv6vmH1Z+qgu+CKS9QEJEOfMgwm7Qc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-IeFdrebdNXWDEn5ZMebKfA-1; Thu, 10 Mar 2022 15:49:56 -0500
X-MC-Unique: IeFdrebdNXWDEn5ZMebKfA-1
Received: by mail-il1-f198.google.com with SMTP id y19-20020a056e02119300b002c2d3ef05bfso4093385ili.18
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 12:49:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/wHyperqVD6yT4MZyOSDrCItm0ScJpHPiGZO3nX6coc=;
        b=LvCsbN4qBHD5+dC3NvtnxMxbB9Cp7yTznv7Uhd4WzIcuN9o9Zgy4ecDUW9OnOqH6vW
         Xx/u+i6xAGPC0rzO+UwsPWJ2tHL/bqn4Q2vqAVXQoI1tIBJ5RPemJir0PI2JipSgqz5f
         hVk2YyjL5L4EyvHVG/9qj+w/JsLwNhzH9Sg9HT9CYsdkaNAAoZ0ofRhPd+y2tmMBYYqy
         Pi6b0UyCoHTIaklygLCMbCVFFnRxNXLs7fQjd7pxXWIBJQWiXcOnXSRxvZvHazV7301c
         R7w3Om74zeGghlq6tvnV79xLdXoBIvX0MEclfrGrX+DLD1bQPuyDJDE4YMRyEXbCXonc
         2qdA==
X-Gm-Message-State: AOAM5333FbZNjZIz+1SsE22+EIc7huHakJQl3OZjwAewvnpn4x46ni7i
        hV3P5GigtDW0l+rOsFtcfsJkFqG9Rx8s651UhyV35sVwdFeGe4ZSqfrY13vHRl5jmH3zLZ3JJTu
        shfPOEDC1gw0F
X-Received: by 2002:a05:6e02:180d:b0:2c7:733a:f11d with SMTP id a13-20020a056e02180d00b002c7733af11dmr710102ilv.23.1646945395823;
        Thu, 10 Mar 2022 12:49:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdGHIOmSFlUA27ptxSyyRFHgWYtRYdyaS5HXsHLwYYnrbDuYuHO7OCWr0eIL08JCnOU3b0MA==
X-Received: by 2002:a05:6e02:180d:b0:2c7:733a:f11d with SMTP id a13-20020a056e02180d00b002c7733af11dmr710078ilv.23.1646945395433;
        Thu, 10 Mar 2022 12:49:55 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b11-20020a056e02184b00b002c66e75d5f7sm3455113ilv.39.2022.03.10.12.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 12:49:55 -0800 (PST)
Date:   Thu, 10 Mar 2022 13:49:54 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
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
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220310134954.0df4bb12.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
        <20220307120513.74743f17.alex.williamson@redhat.com>
        <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
        <20220307125239.7261c97d.alex.williamson@redhat.com>
        <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220308123312.1f4ba768.alex.williamson@redhat.com>
        <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Wed, 9 Mar 2022 10:11:06 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, March 9, 2022 3:33 AM
> >=20
> > On Tue, 8 Mar 2022 08:11:11 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, March 8, 2022 3:53 AM =20
> > > > > =20
> > > > > > I think we still require acks from Bjorn and Zaibo for select p=
atches
> > > > > > in this series. =20
> > > > >
> > > > > I checked with Ziabo. He moved projects and is no longer looking =
into =20
> > > > crypto stuff. =20
> > > > > Wangzhou and LiuLongfang now take care of this. Received acks fro=
m =20
> > > > Wangzhou =20
> > > > > already and I will request Longfang to provide his. Hope that's o=
k. =20
> > > >
> > > > Maybe a good time to have them update MAINTAINERS as well.  Thanks,
> > > > =20
> > >
> > > I have one question here (similar to what we discussed for mdev befor=
e).
> > >
> > > Now we are adding vendor specific drivers under /drivers/vfio. Two dr=
ivers
> > > on radar and more will come. Then what would be the criteria for
> > > accepting such a driver? Do we prefer to a model in which the author =
=20
> > should =20
> > > provide enough background for vfio community to understand how it =20
> > works =20
> > > or as done here just rely on the PF driver owner to cover device spec=
ific
> > > code?
> > >
> > > If the former we may need document some process for what information
> > > is necessary and also need secure increased review bandwidth from key
> > > reviewers in vfio community.
> > >
> > > If the latter then how can we guarantee no corner case overlooked by =
both
> > > sides (i.e. how to know the coverage of total reviews)? Another open =
is =20
> > who =20
> > > from the PF driver sub-system should be considered as the one to give=
 the
> > > green signal. If the sub-system maintainer trusts the PF driver owner=
 and
> > > just pulls commits from him then having the r-b from the PF driver ow=
ner is
> > > sufficient. But if the sub-system maintainer wants to review detail c=
hange
> > > in every underlying driver then we probably also want to get the ack =
from
> > > the maintainer.
> > >
> > > Overall I didn't mean to slow down the progress of this series. But a=
bove
> > > does be some puzzle occurred in my review. =F0=9F=98=8A =20
> >=20
> > Hi Kevin,
> >=20
> > Good questions, I'd like a better understanding of expectations as
> > well.  I think the intentions are the same as any other sub-system, the
> > drivers make use of shared interfaces and extensions and the role of
> > the sub-system should be to make sure those interfaces are used
> > correctly and extensions fit well within the overall design.  However,
> > just as the network maintainer isn't expected to fully understand every
> > NIC driver, I think/hope we have the same expectations here.  It's
> > certainly a benefit to the community and perceived trustworthiness if
> > each driver outlines its operating model and security nuances, but
> > those are only ever going to be the nuances identified by the people
> > who have the access and energy to evaluate the device.
> >=20
> > It's going to be up to the community to try to determine that any new
> > drivers are seriously considering security and not opening any new gaps
> > relative to behavior using the base vfio-pci driver.  For the driver
> > examples we have, this seems a bit easier than evaluating an entire
> > mdev device because they're largely providing direct access to the
> > device rather than trying to multiplex a shared physical device.  We
> > can therefore focus on incremental functionality, as both drivers have
> > done, implementing a boilerplate vendor driver, then adding migration
> > support.  I imagine this won't always be the case though and some
> > drivers will re-implement much of the core to support further emulation
> > and shared resources.
> >=20
> > So how do we as a community want to handle this?  I wouldn't mind, I'd
> > actually welcome, some sort of review requirement for new vfio vendor
> > driver variants.  Is that reasonable?  What would be the criteria?
> > Approval from the PF driver owner, if different/necessary, and at least
> > one unaffiliated reviewer (preferably an active vfio reviewer or
> > existing vfio variant driver owner/contributor)?  Ideas welcome.
> > Thanks,
> >  =20
>=20
> Yes, and the criteria is the hard part. In the end it largely depend on=20
> the expectations of the reviewers. =20
>=20
> If the unaffiliated reviewer only cares about the usage of shared=20
> interfaces or extensions as you said then what this series does is
> just fine. Such type of review can be easily done via reading code=20
> and doesn't require detail device knowledge.
>=20
> On the other hand if the reviewer wants to do a full functional
> review of how migration is actually supported for such device,=20
> whatever information (patch description, code comment, kdoc,
> etc.) necessary to build a standalone migration story would be
> appreciated, e.g.:
>=20
>   - What composes the device state?
>   - Which portion of the device state is exposed to and managed
>     by the user and which is hidden from the user (i.e. controlled
>     by the PF driver)?
>   - Interface between the vfio driver and the device (and/or PF
>     driver) to manage the device state;
>   - Rich functional-level comments for the reviewer to dive into
>     the migration flow;
>   - ...
>=20
> I guess we don't want to force one model over the other. Just
> from my impression the more information the driver can=20
> provide the more time I'd like to spend on the review. Otherwise
> it has to trend to the minimal form i.e. the first model.
>=20
> and currently I don't have a concrete idea how the 2nd model will
> work. maybe it will get clear only when a future driver attracts=20
> people to do thorough review...

Do you think we should go so far as to formalize this via a MAINTAINERS
entry, for example:

diff --git a/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst b/Doc=
umentation/vfio/vfio-pci-vendor-driver-acceptance.rst
new file mode 100644
index 000000000000..54ebafcdd735
--- /dev/null
+++ b/Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Acceptance criteria for vfio-pci device specific driver variants
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Overview
+--------
+The vfio-pci driver exists as a device agnostic driver using the
+system IOMMU and relying on the robustness of platform fault
+handling to provide isolated device access to userspace.  While the
+vfio-pci driver does include some device specific support, further
+extensions for yet more advanced device specific features are not
+sustainable.  The vfio-pci driver has therefore split out
+vfio-pci-core as a library that may be reused to implement features
+requiring device specific knowledge, ex. saving and loading device
+state for the purposes of supporting migration.
+
+In support of such features, it's expected that some device specific
+variants may interact with parent devices (ex. SR-IOV PF in support of
+a user assigned VF) or other extensions that may not be otherwise
+accessible via the vfio-pci base driver.  Authors of such drivers
+should be diligent not to create exploitable interfaces via such
+interactions or allow unchecked userspace data to have an effect
+beyond the scope of the assigned device.
+
+New driver submissions are therefore requested to have approval via
+Sign-off for any interactions with parent drivers.  Additionally,
+drivers should make an attempt to provide sufficient documentation
+for reviewers to understand the device specific extensions, for
+example in the case of migration data, how is the device state
+composed and consumed, which portions are not otherwise available to
+the user via vfio-pci, what safeguards exist to validate the data,
+etc.  To that extent, authors should additionally expect to require
+reviews from at least one of the listed reviewers, in addition to the
+overall vfio maintainer.
diff --git a/MAINTAINERS b/MAINTAINERS
index 4322b5321891..4f7d26f9aac6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20314,6 +20314,13 @@ F:	drivers/vfio/mdev/
 F:	include/linux/mdev.h
 F:	samples/vfio-mdev/
=20
+VFIO PCI VENDOR DRIVERS
+R:	Your Name <your.name@here.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+P:	Documentation/vfio/vfio-pci-vendor-driver-acceptance.rst
+F:	drivers/vfio/pci/*/
+
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org

Ideally we'd have at least Yishai, Shameer, Jason, and yourself listed
as reviewers (Connie and I are included via the higher level entry).
Thoughts from anyone?  Volunteers for reviewers if we want to press
forward with this as formal acceptance criteria?  Thanks,

Alex

