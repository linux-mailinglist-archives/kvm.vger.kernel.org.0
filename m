Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2F9777F4C
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbjHJRlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjHJRlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 13:41:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE05C26AA
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 10:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691689214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cooSfdq0cDIJR35S85G1uR/Tw8ZsJkuhty77AJQBC3A=;
        b=YzarUpYC9TftguvBvxZbKUDIOwwpMaJHJHEcD91e9+lkuBV/s2oDQ/B4Z7RKjZ8l5Xtse+
        0y3r6BMhjtXqOfSx7J/16sXAqiS19fDToXsO6Wj4xFGcm0RnErtW0Mdsu0Vd+CnUFkrlQE
        ht0CcMj5yAMPGtWBsA8N+5HueSQF4rs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-s29PT0v7MkOaL16O0ytkwg-1; Thu, 10 Aug 2023 13:40:10 -0400
X-MC-Unique: s29PT0v7MkOaL16O0ytkwg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-790a08063b2so88004839f.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 10:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691689210; x=1692294010;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cooSfdq0cDIJR35S85G1uR/Tw8ZsJkuhty77AJQBC3A=;
        b=EqdIqYLcxp2PTui3vww5+wfDzxCfPJGNDKhT0tXoayF+53gIih1aA6NPhPi+gwFsIn
         bRmZq8K00XhWbF8laiJMxB7RknDwdQGAG8L1fl9IUD5e4g24+KOGNhj6sMRrY+NfmytI
         bhjguSsCcczPYJKbe4Oto+EoCJMRx85DJ1mMyfodW735nBqOpVeCCb1ksxaYRUOQCze4
         RcyLfwZiCBqpMww06252p6SWob/M9dpLtQRIGma75TsW0opqCmmvr4n+SBJa1AJA5P7q
         0KkqNJnZwSKAca+MWZyAtAbHCyMKWf2Pc8QGtqG4oyRlofLD/+DzS9NCs/jHRClc0BgI
         bHUQ==
X-Gm-Message-State: AOJu0YwsIPV39ZxysgLYK11ejoRSLOhHawl7kNwE02mHpfoc5jR14YZu
        YIUmhQiVSdgysgW7PURZHGLZmZ6QVnG+nMkatZ4/mUyTdI119GCjo1244qhgDuXPH9k6Q++2R2m
        F55fzGsZWL4ru
X-Received: by 2002:a6b:fd09:0:b0:790:a23b:1dfc with SMTP id c9-20020a6bfd09000000b00790a23b1dfcmr4113663ioi.9.1691689210148;
        Thu, 10 Aug 2023 10:40:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsSf1lZCbnO5jHFCYcvCJoUB9+NqxyQmyNvxzjJ38LvoLF2oHE0XViXtG4tGsF3T7Rrg2agg==
X-Received: by 2002:a6b:fd09:0:b0:790:a23b:1dfc with SMTP id c9-20020a6bfd09000000b00790a23b1dfcmr4113643ioi.9.1691689209916;
        Thu, 10 Aug 2023 10:40:09 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id f16-20020a02b790000000b0042bb2448847sm517912jam.53.2023.08.10.10.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 10:40:09 -0700 (PDT)
Date:   Thu, 10 Aug 2023 11:40:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230810114008.6b038d2a.alex.williamson@redhat.com>
In-Reply-To: <ZNUcLM/oRaCd7Ig2@nvidia.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-7-brett.creeley@amd.com>
        <20230808162718.2151e175.alex.williamson@redhat.com>
        <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
        <20230809113300.2c4b0888.alex.williamson@redhat.com>
        <ZNPVmaolrI0XJG7Q@nvidia.com>
        <BN9PR11MB5276F32CC5791B3D91C62A468C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230810104734.74fbe148.alex.williamson@redhat.com>
        <ZNUcLM/oRaCd7Ig2@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Aug 2023 14:19:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Aug 10, 2023 at 10:47:34AM -0600, Alex Williamson wrote:
> > On Thu, 10 Aug 2023 02:47:15 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >  =20
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, August 10, 2023 2:06 AM
> > > >=20
> > > > On Wed, Aug 09, 2023 at 11:33:00AM -0600, Alex Williamson wrote:
> > > >    =20
> > > > > Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
> > > > > approve this series as well.  Thanks,   =20
> > > >=20
> > > > I've looked at it a few times now, I think it is OK, aside from the
> > > > nvme issue.
> > > >    =20
> > >=20
> > > My only concern is the duplication of backing storage management
> > > of the migration file which I didn't take time to review.
> > >=20
> > > If all others are fine to leave it as is then I will not insist. =20
> >=20
> > There's leverage now if you feel strongly about it, but code
> > consolidation could certainly come later.
> >=20
> > Are either of you willing to provide a R-b? =20
>=20
> The code structure is good enough (though I agree with Kevin), so sure:
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> > What are we looking for relative to NVMe?  AIUI, the first couple
> > revisions of this series specified an NVMe device ID, then switched to
> > a wildcard, then settled on an Ethernet device ID, all with no obvious
> > changes that would suggest support is limited to a specific device
> > type.  I think we're therefore concerned that migration of an NVMe VF
> > could be enabled by overriding/adding device IDs, whereas we'd like to
> > standardize NVMe migration to avoid avoid incompatible implementations.=
 =20
>=20
> Yeah
>=20
> > It's somewhat a strange requirement since we have no expectation of
> > compatibility between vendors for any other device type, but how far
> > are we going to take it?  Is it enough that the device table here only
> > includes the Ethernet VF ID or do we want to actively prevent what
> > might be a trivial enabling of migration for another device type
> > because we envision it happening through an industry standard that
> > currently doesn't exist?  Sorry if I'm not familiar with the dynamics
> > of the NVMe working group or previous agreements.  Thanks, =20
>=20
> I don't really have a solid answer. Christoph and others in the NVMe
> space are very firm that NVMe related things must go through
> standards, I think that is their right.
>=20
> It does not seem good to allow undermining that approach.

If we wanted to enforce something like this the probe function could
reject NVMe class devices, but...
=20
> On the flip side, if we are going to allow this driver, why are we not
> letting them enable their full device functionality with all their
> non-compliant VF/PF combinations? They shouldn't have to hide what
> they are actually doing just to get merged.

This.  Is it enough that this appears to implement device type agnostic
migration support for devices hosted by this distributed services card
and NVMe happens to be one of those device types?  Is that a high
enough bar that this is not simply a vendor specific NVMe migration
implementation?
=20
> If we want to block anything it should be to block the PCI spec
> non-compliance of having PF/VF IDs that are different.

PCI Express=C2=AE Base Specification Revision 6.0.1, pg 1461:

  9.3.3.11 VF Device ID (Offset 1Ah)

  This field contains the Device ID that should be presented for every VF t=
o the SI.

  VF Device ID may be different from the PF Device ID...

That?  Thanks,

Alex

