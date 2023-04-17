Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681AC6E5086
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDQTCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjDQTCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391BF46BF
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681758105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Bvi+Bflt88Ev//sRfi1fS/kQHXju8BfZmtW+TpqD+M=;
        b=JlPeo+NX7NDap7cBUKw6NxqkhFXr+9XQHnPLVV1Np/Z0BmVrSJm7i6mIDEEB+tVa3/OK3A
        PtwXB0+lvzauyNzeOEfTvT4k2/Xc2Vi/fExWcmJwGSVBprpFS1vQTVR3f6kfgGvntpq5Nv
        sSZqGGBrWa966PbmQiluyz8EIZBvBEI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-NWl1zNRKN_S5EocQMz5KhQ-1; Mon, 17 Apr 2023 15:01:44 -0400
X-MC-Unique: NWl1zNRKN_S5EocQMz5KhQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32ad2e6cf31so20460905ab.2
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 12:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758103; x=1684350103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5Bvi+Bflt88Ev//sRfi1fS/kQHXju8BfZmtW+TpqD+M=;
        b=EgSf0dVHmYoIsQsLV8xwHhIVgU32ko+ZuDOGrCIMLA/ANb66wXwTZYqFQKqZdWS6mx
         trcORwHjacIPEkuFqdR5KfQMqvJ3zi7bNtB55RLMKGQCPXqSw+4b/wLdAZEuYIa9rcwT
         J3eOlgY5bTXbNnc/00MqKqgpBiB50oc8IPHglpstdfarAY4xiO7hP+5REkwBJxSechh6
         2igvayLgw5HYmHWczlLCTn2kR+S6G+EGq2Y/DT+sSaV2W6c9UvK8HA6zXA/1fWm/AKp3
         M/3R5EVKUVBk6+Lja9ZHNxwf6liLCMfWkuHeqDBj71/5Jp5XDOwwBej2csaotqmBfd19
         2XzA==
X-Gm-Message-State: AAQBX9fvzcm4JgtV0VwXKJ7Jf0wWshIKcSmboWMyTumcCNJr5YaY8QqO
        gVgH2fkxU1wdcEAg0ANiWsrwMBDszJNmvtuPuSns9vXWDq7R38Zt/onPFPXRyEBnzGVIxSqNz5z
        ryXeiu9gIYc6b
X-Received: by 2002:a92:da4f:0:b0:329:43f0:1570 with SMTP id p15-20020a92da4f000000b0032943f01570mr11901400ilq.23.1681758103320;
        Mon, 17 Apr 2023 12:01:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yc9MHqAd/FKqlu7BJXqDJc1DteytbzaOAPM3AcUnUMNFM/sAGolFFsk6RSPFhmSGf9KsRJww==
X-Received: by 2002:a92:da4f:0:b0:329:43f0:1570 with SMTP id p15-20020a92da4f000000b0032943f01570mr11901377ilq.23.1681758103035;
        Mon, 17 Apr 2023 12:01:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q1-20020a056e020c2100b0031595ea003asm3310707ilg.85.2023.04.17.12.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:01:42 -0700 (PDT)
Date:   Mon, 17 Apr 2023 13:01:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Message-ID: <20230417130140.1b68082e.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
        <20230411155827.3489400a.alex.williamson@redhat.com>
        <ZDX0wtcvZuS4uxmG@nvidia.com>
        <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Apr 2023 04:20:27 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, April 15, 2023 1:11 AM
> > 
> > On Fri, 14 Apr 2023 11:38:24 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Friday, April 14, 2023 5:12 PM
> > > >  
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, April 14, 2023 2:07 AM
> > > > >
> > > > > We had already iterated a proposal where the group-id is replaced with
> > > > > a dev-id in the existing ioctl and a flag indicates when the return
> > > > > value is a dev-id vs group-id.  This had a gap that userspace cannot
> > > > > determine if a reset is available given this information since un-owned
> > > > > devices report an invalid dev-id and userspace can't know if it has
> > > > > implicit ownership.  
> > > >  
> > > > >
> > > > > It seems cleaner to me though that we would could still re-use INFO in
> > > > > a similar way, simply defining a new flag bit which is valid only in
> > > > > the case of returning dev-ids and indicates if the reset is available.
> > > > > Therefore in one ioctl, userspace knows if hot-reset is available
> > > > > (based on a kernel determination) and can pull valid dev-ids from the  
> > >
> > > Need to confirm the meaning of hot-reset available flag. I think it
> > > should at least meet below two conditions to set this flag. Although
> > > it may not mean hot-reset is for sure to succeed. (but should be
> > > a high chance).
> > >
> > > 1) dev_set is resettable (all affected device are in dev_set)
> > > 2) affected device are owned by the current user  
> > 
> > Per thread with Kevin, ownership can't always be known by the kernel.
> > Beyond the group vs cdev discussion there, isn't it also possible
> > (though perhaps not recommended) that a user can have multiple iommufd
> > ctxs?  So I think 2) becomes "ownership of the affected dev-set can be
> > inferred from the iommufd_ctx of the calling device", iow, the
> > null-array calling model is available and the flag is redefined to
> > match.  Reset may still be available via the proof-of-ownership model.  
> 
> Yes, if there are multiple iommufd ctxs, this shall fall back to use
> the proof-of-ownership model.
> 
> >   
> > > Also, we need to has assumption that below two cases are rare
> > > if user encounters it, it just bad luck for them. I think the existing
> > > _INFO and hot-reset already has such assumption. So cdev mode
> > > can adopt it as well.
> > >
> > > a) physical topology change (e.g. new devices plugged to affected slot)
> > > b) an affected device is unbound from vfio  
> > 
> > Yes, these are sufficiently rare that we can't do much about them.
> >   
> > > > So the kernel needs to compare the group id between devices with
> > > > valid dev-ids and devices with invalid dev-ids to decide the implicit
> > > > ownership. For noiommu device which has no group_id when
> > > > VFIO_GROUP is off then it's resettable only if having a valid dev_id.  
> > >
> > > In cdev mode, noiommu device doesn't have dev_id as it is not
> > > bound to valid iommufd. So if VFIO_GROUP is off, we may never
> > > allow hot-reset for noiommu devices. But we don't want to have
> > > regression with noiommu devices. Perhaps we may define the usage
> > > of the resettable flag like this:
> > > 1) if it is set, user does not need to own all the affected devices as
> > >     some of them may have been owned implicitly. Kernel should have
> > >     checked it.
> > > 2) if the flag is not set, that means user needs to check ownership
> > >     by itself. It needs to own all the affected devices. If not, don't
> > >    do hot-reset.  
> > 
> > Exactly, the flag essentially indicates that the null-array approach is
> > available, lack of the flag indicates proof-of-ownership is required.
> >   
> > > This way we can still make noiommu devices support hot-reset
> > > just like VFIO_GROUP is on. Because noiommu devices have fake
> > > groups, such groups are all singleton. So checking all affected
> > > devices are opened by user is just same as check all affected
> > > groups.  
> > 
> > Yep.
> >   
> > > > The only corner case with this option is when a user mixes group
> > > > and cdev usages. iirc you mentioned it's a valid usage to be supported.
> > > > In that case the kernel doesn't have sufficient knowledge to judge
> > > > 'resettable' as it doesn't know which groups are opened by this user.
> > > >
> > > > Not sure whether we can leave it in a ugly way so INFO may not tell
> > > > 'resettable' accurately in that weird scenario.  
> > >
> > > This seems not easy to support. If above scenario is allowed there can be
> > > three cases that returns invalid dev_id.
> > > 1) devices not opened by user but owned implicitly  
> > 
> > The cdev approach has a hard time with this in general, it has no way to
> > represent unopened devices. so any case where the nature of an unopened
> > device block reset on the dev-set is rather opaque to the user.
> >   
> > > 2) devices not owned by user  
> > 
> > (and presumable not owned)  We still provide BDF.  Not much difference
> > from the group case here, being able to point to a BDF or group is
> > about all we can do.
> >   
> > > 3) devices opened via group but owned by user  
> > 
> > I think this still works in the proof-of-ownership, passing fds to
> > hot-reset model.  
> 
> Ok. let's see below scenario and user's processing makes sense.
> 
> Say there are five devices (devA, devB, devC, devD, devE) in the same reset
> group. devA and devB are in the same iommu group. devC, devD, and devE have
> separate iommu groups. Say devA is opened via cdev, devB is not opened, devC
> is opened via group, devD is opened cdev but bound to another iommufdctx that
> is different with devA. devE is not opened by any user
> 
> If this INFO is called on devA, user should get a valid dev_id for devA, but
> four invalid dev_ids. The resettable flag should be clear. Below is how user
> to handle the info returned.

INFO from devA returns:

flags: NOT_RESETABLE | DEV_ID
{
  { valid devA-id,  devA-BDF },
  { invalid dev-id, devB-BDF },
  { invalid dev-id, devC-BDF },
  { invalid dev-id, devD-BDF },
  { invalid dev-id, devE-BDF },
}

User knows devA-id, learns devA-BDF

from devC:
{
  { devA/B-group-id, devA-BDF },
  { devA/B-group-id, devB-BDF },
  { devC-group-id,   devC-BDF },
  { devD-group-id,   devD-BDF },
  { devE-group-id,   devE-BDF },
}

User is assumed to know devC group-id + BDF given group semantics,
knows devA ownership, infers devB ownership.

from devD:
flags: NOT_RESETABLE | DEV_ID
{
  { invalid dev-id, devA-BDF },
  { invalid dev-id, devB-BDF },
  { invalid dev-id, devC-BDF },
  { valid devD-id,  devD-BDF },
  { invalid dev-id, devE-BDF },
}

User knows devD-id, learns devD-bdf, knows devA and devC ownership, and
inferred devB ownership

> - For devB, user shall get the group_id for devA, and also get group_id for
>   devB, hence able to check ownership of devB by checking the group

Per above, groups are only available through the group devices,
therefore inferred ownership of devB can only be learned from devC.

> - For devC, user can check ownership by the group_id and bdf returned

Yes, the INFO ioctl on devC can confirm devC is affected, but more
importantly this is the bridge to learn BDF of other affected devices
and their groups.

> - For devD, if it is opened by the user, should be able to find it by bdf

I think the reverse, the user presumably already knows the dev-id for
devD and knows that a hot-reset of the calling device necessarily
affects the device, but it learns the BDF, which helps it connect 4 of
the 5 device affected by the reset.

> - For devE, user shall fail to find it hence consider no ownership on it.

Yes, which is correct.

> To finish the above check, user needs to get group_id via devid an also needs
> to get group_id via device fd. Is it?

Not absolutely required, but the user needs to do a lot of inferring via
BDF.

> The above example may be the most tricky scenario. Is it? user shall not do
> hot-reset as not all affected devices are owned by user. But if devE is also
> opened by user, it could do hot-reset.

Yes, it's not trivial, but Jason is now proposing that we consider
mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
this means that regardless of which device calls INFO, there's only one
answer (assuming same set of devices opened, all cdev, all within same
iommufd_ctx).  Based on what I explained about my understanding of INFO2
and Jason agreed to, I think the output would be:

flags: NOT_RESETABLE | DEV_ID
{
  { valid devA-id,  devA-BDF },
  { valid devC-id,  devC-BDF },
  { valid devD-id,  devD-BDF },
  { invalid dev-id, devE-BDF },
}

Here devB gets dropped because the kernel understands that devB is
unopened, affected, and owned.  It's therefore not a blocker for
hot-reset.  OTOH, devE is unopened, affected, and un-owned, and we
previously agreed against the opportunistic un-opened/un-owned loophole.

If devA and devD were separate iommufd_ctxs, with devC in the same
ctx as devA, I think this becomes:

INFO on devA:
flags: NOT_RESETABLE | DEV_ID
{
  { valid devA-id,  devA-BDF },
  { valid devC-id,  devC-BDF },
  { invalid dev-id, devD-BDF },
  { invalid dev-id, devE-BDF },
}

INFO on devD:
flags: NOT_RESETABLE | DEV_ID
{
  { invalid dev-id, devA-BDF },
  { invalid dev-id, devB-BDF },
  { invalid dev-id, devC-BDF },
  { valid devD-id, devD-BDF },
  { invalid dev-id, devE-BDF },
}

I think this illustrates that it makes sense for unopened affected
devices with implicit ownership to always be hidden, but otherwise are
fully enumerated.

> > > User would require more info to tell the above cases from each other.  
> > 
> > Obviously we could be equivalent to the group model if IOMMU groups
> > were exposed for a device and all devices had IOMMU groups, but
> > reasons...
> >   
> > > > > array to associate affected, owned devices, and still has the
> > > > > equivalent information to know that one or more of the devices listed
> > > > > with an invalid dev-id are preventing the hot-reset from being
> > > > > available.
> > > > >
> > > > > Is that an option?  Thanks,
> > > > >  
> > > >
> > > > This works for me if above corner case can be waived.  
> > >
> > > One side check, perhaps already confirmed in prior email. @Alex, So
> > > the reason for the prediction of hot-reset is to avoid the possible
> > > vfio_pci_pre_reset() which does heavy operations like stop DMA and
> > > copy config space. Is it? Any other special reason? Anyhow, this reason
> > > is enough for this prediction per my understanding.  
> > 
> > It's not clear to me what "prediction" is referring to.  
> 
> It is predicting whether hot-reset ioctl can work or not as you mentioned
> in prior discussion.[1].
> 
> "I disagree, as I've argued before, the info ioctl becomes so weak and
> effectively arbitrary from a user perspective at being able to predict
> whether the hot-reset ioctl works that it becomes useless, diminishing
> the entire hot-reset info/execute API."
> 
> [1] https://lore.kernel.org/kvm/20230405134945.29e967be.alex.williamson@redhat.com/

I think we're narrowing in on an interface that isn't as arbitrary.  If
we assume the restrictions that Jason proposes, then cdev is exclusively
a kernel determined reset availability model, where I'd agree that
passing device-fds as a proof of ownership is pointless.  The group
interface would therefore remain exclusively a proof-of-ownership
model since we have no incentive to extend it to kernel-determined
given the limited use case of all affected devices managed by the same
vfio container.

> > As above, I
> > think we can redefine the reset-available flag I proposed to more
> > restrictively indicate that the null-array approach is available based
> > on the dev-set group in relation to the iommufd_ctx of the calling
> > device.  Prediction of the affected devices seems like basic
> > functionality to me, we can't assume the user's usage model, they must
> > be able to make a well informed decision regarding affected devices.
> > Thanks,  
> 
> As my above reply with the five-device scenario. It still needs to get
> group_id to check implicit ownership in the case of sharing the same
> iommu_group.

Moot, but there's actually enough information there to infer IOMMU
groups for each device, but we probably can't prove that would always
be the case.  If we adopt Jason's proposal though, I don't see that we
need either a group-id or BDF capability, the BDF is only for debug
reporting.  However, there is a new burden on the kernel to identify
the affected, un-owned devices for that report.  Thanks,

Alex

