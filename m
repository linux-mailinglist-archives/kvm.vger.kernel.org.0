Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9576E57FD
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 06:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDREL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 00:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDREL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 00:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358C544B3
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 21:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681791039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xh3TsCLXRD6/SzblTrxESG3WliTN/NlnShwKD7qJmCw=;
        b=U3u2ig5ttXgiKHPNIXHMTcDabvtQWlQUsr8baFf/3+5i3n0oHNEn5sSiW5zZnz8AsXUR4/
        saJuqM7J/aZBQB881HbjsJV6gxXqoWws/QiDje1PHq6ruSiXeJ4klgKMic/ukYMLMcwEQ/
        ly+ZucF0UYpDPAuBI55ArmE/HoWIzEo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-Yktld3IwMmSpqB5Q9VGRlA-1; Tue, 18 Apr 2023 00:10:37 -0400
X-MC-Unique: Yktld3IwMmSpqB5Q9VGRlA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-32879a859d8so18859205ab.3
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 21:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681791037; x=1684383037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xh3TsCLXRD6/SzblTrxESG3WliTN/NlnShwKD7qJmCw=;
        b=gDRrxA7qSNQnvC5B+ki4p0XeGTIn69wTYhsiPGFmEsAtPqXeVxpXOxhmRAFBjiibYt
         s8Kob5vEfQUBWH8WUx6aWiKMA2/Eh0MEG1mwY83OXYvV+hnO497cId3ecFlGkNpJQ8Pa
         wdq5G8leG4oGKEtFbBMdaWH1HcIByofJb5ZL2HYFdIxG5eLjQnfi9qQmkQ/MCeOzvdgP
         qF5f47Yc0T9u5EXIjcu6kfJemod/oP6PWNZOyuQeWL5uBTi5Xa4RPrlwoYmK6QBswlOx
         Tk7OsajTUIhmKN5RbIlmIqPokHy7a+LSEXAJgFNToX38yXJer3FBkE0n/6GSqZDCiwnV
         emzg==
X-Gm-Message-State: AAQBX9cEK68Fvm7ofiykKto0Bvdt5hqsVCxoQAud6Tj1P93U2Vhtv6Zj
        UFpiBNOWUfk0B+9x4McXXOcrMCaJdjFsuJKKwpIoItzLEA6Ty/LAjCoBq0UUhZbX6WgwePYVYrU
        cZMnGCk4OmwMQ
X-Received: by 2002:a92:d902:0:b0:32a:79c4:ce48 with SMTP id s2-20020a92d902000000b0032a79c4ce48mr12354966iln.23.1681791036709;
        Mon, 17 Apr 2023 21:10:36 -0700 (PDT)
X-Google-Smtp-Source: AKy350bdWlJiRpOSPyMXnDBV4MCo70URxAv/pP21vJfcpGLaqYd9J5vCEveva+zeAUdPVlViz88XbA==
X-Received: by 2002:a92:d902:0:b0:32a:79c4:ce48 with SMTP id s2-20020a92d902000000b0032a79c4ce48mr12354932iln.23.1681791036329;
        Mon, 17 Apr 2023 21:10:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 7-20020a921307000000b0032732e7c25esm3585372ilt.36.2023.04.17.21.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 21:10:35 -0700 (PDT)
Date:   Mon, 17 Apr 2023 22:10:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230417221033.778c00c9.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <BN9PR11MB5276D93DDFE3ED97CD1B923B8C9D9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 03:24:46 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, April 18, 2023 4:07 AM
> > 
> > On Mon, 17 Apr 2023 16:31:56 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:  
> > > > Yes, it's not trivial, but Jason is now proposing that we consider
> > > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> > > > this means that regardless of which device calls INFO, there's only one
> > > > answer (assuming same set of devices opened, all cdev, all within same
> > > > iommufd_ctx).  Based on what I explained about my understanding of  
> > INFO2  
> > > > and Jason agreed to, I think the output would be:
> > > >
> > > > flags: NOT_RESETABLE | DEV_ID
> > > > {
> > > >   { valid devA-id,  devA-BDF },
> > > >   { valid devC-id,  devC-BDF },
> > > >   { valid devD-id,  devD-BDF },
> > > >   { invalid dev-id, devE-BDF },
> > > > }
> > > >
> > > > Here devB gets dropped because the kernel understands that devB is
> > > > unopened, affected, and owned.  It's therefore not a blocker for
> > > > hot-reset.  
> > >
> > > I don't think we want to drop anything because it makes the API
> > > ill suited for the debugging purpose.
> > >
> > > devb should be returned with an invalid dev_id if I understand your
> > > example. Maybe it should return with -1 as the dev_id instead of 0, to
> > > make the debugging a bit better.
> > >
> > > Userspace should look at only NOT_RESETTABLE to determine if it
> > > proceeds or not, and it should use the valid dev_id list to iterate
> > > over the devices it has open to do the config stuff.  
> > 
> > If an affected device is owned, not opened, and not interfering with
> > the reset, what is it adding to the API to report it for debugging
> > purposes?  I'm afraid this leads into expanding "invalid dev-id" into an  
> 
> consistent output before and after devB is opened.

In the case where devB is not opened including it only provides
useless information.  In the case where devB is opened it's necessary
to be reported as an opened, affected device.

> > errno or bitmap of error conditions that the user needs to parse.
> >   
> 
> Not exactly.
> 
> If RESETABLE invalid dev_id doesn't matter. The user only use the
> valid dev_id list to iterate as Jason pointed out.

Yes, but...

> If NOT_RESETTABLE due to devE not assigned to the VM one can
> easily figure out the fact by simply looking at the list of affected BDFs
> and the configuration of assigned devices of the VM. Then invalid
> dev_id also doesn't matter.

Huh?

Given:

flags: NOT_RESETABLE | DEV_ID
{
  { valid devA-id,  devA-BDF },
  { invalid dev-id, devB-BDF },
  { valid devC-id,  devC-BDF },
  { valid devD-id,  devD-BDF },
  { invalid dev-id, devE-BDF },
}

How does the user determine that devE is to blame and not devB based on
BDF?  The user cannot rely on sysfs for help, they don't know the IOMMU
grouping, nor do they know the BDF except as inferred by matching valid
dev-ids in the above output.
 
> If NOT_RESETTABLE while devE is already assigned to the VM then it's
> indication of mixing groups, cdevs or multiple iommufd_ctxs. Then
> people should debug with other means/hints to dig out the exact
> culprit.

I don't know what situation you're trying to explain here.  If devE
were opened within the same iommufd_ctx, this becomes:

flags: RESETABLE | DEV_ID
{
  { valid devA-id,  devA-BDF },
  { invalid dev-id, devB-BDF },
  { valid devC-id,  devC-BDF },
  { valid devD-id,  devD-BDF },
  { valid devE-id,  devE-BDF },
}

Yes, the user should only be looking at the flag to determine the
availability of hot-reset, (here's the but) but how is it consistent to
indicate both that hot-reset is available and include an invalid
dev-id?  The consistency as I propose is that an invalid dev-id is only
presented with NOT_RESETTABLE for the device blocking hot-reset.  In
the previous case, devB is not blocking reset and reporting an invalid
dev-id only serves to obfuscate determining the blocking device.

For the cases of affected group-opened devices or separate
iommufd_ctxs, the user gets invalid dev-ids for anything outside of
the calling device's iommufd_ctx.

We haven't discussed how it fails when called on a group-opened device
in a mixed environment.  I'd propose that the INFO ioctl behaves
exactly as it does today, reporting group-id and BDF for each affected
device.  However, the hot-reset ioctl itself is not extended to accept
devicefd because there is no proof-of-ownership model for cdevs.
Therefore even if the user could map group-id to devicefd, they get
-EINVAL calling HOT_RESET with a devicefd when the ioctl is called from
a group-opened device.  Thanks,

Alex

