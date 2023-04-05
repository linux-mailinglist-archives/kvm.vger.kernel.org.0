Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4B6D875A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjDETv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjDETvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:51:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A2376AA
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 12:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680724190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VV/1+tZjcISuBy4Cr1ZNzpFLuXRsQrIQ62y/gstXpI=;
        b=QxuN++igsvhzbGo71Uz3jk20+RURCrF4tZu4Ae6f1LmtXPnRok3I3u+0DUPXZwI31roSBR
        1RRButgSfjBxvXsXpba3ZkLHQsSd1q0zTh6U2fHTKoYKlQMzEu7uGJp8GbzjHlWjpP03UH
        ZLnX1YrNBXDdKWyA1iaMo4smZzFMgyY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-GO9bSjv8Nyq3uVFdm7GLlQ-1; Wed, 05 Apr 2023 15:49:48 -0400
X-MC-Unique: GO9bSjv8Nyq3uVFdm7GLlQ-1
Received: by mail-io1-f69.google.com with SMTP id i4-20020a6b5404000000b0075ff3fb6f4cso7467068iob.9
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 12:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680724188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5VV/1+tZjcISuBy4Cr1ZNzpFLuXRsQrIQ62y/gstXpI=;
        b=PFXH+fmSVNTl58IskPnR+2B1FCTwAr+U+Tnb8I8wVbS9hfavNdm3D0/hL9OE8TtLnE
         gSfFaXkvmhGEZlAGnwvrAz7URIDyzFCHpKSYMQLTYEa6hLMlvjcn1MYi5+JCjUbvjc2U
         zND8Fkq3hP5s6wVICRFXRNCb+4kb46mz74DtiRnmvPgd8crWP37t2AVn7O3WM/A9wY3D
         0a/egwNAQDn71gf3whWNJvbnW2wNntsSAdrMBXfrsMetbwD2JKEl9b3KFoJWtMelUYzM
         LG8vKaIdKrWKU+qQSU3DsBPwLzAVKizaU0PTYtVMmvG7ZhWux4ieIclycf7Vw9FCFz9f
         YmFQ==
X-Gm-Message-State: AAQBX9dkpniYAKpXhjgxhFP7ZXBdeMpsIaZMxnB4jvUOUcFhixyBqOtW
        0MgcmG2SumwtsRIGeCBsBBpul3r8XeyYxzL49yWng0zXK5/eGA0ormrrtxvwrI0UNLPtNsDpBnp
        BkftZqRkfJRyX
X-Received: by 2002:a92:d282:0:b0:326:45af:ac3a with SMTP id p2-20020a92d282000000b0032645afac3amr4110792ilp.6.1680724187928;
        Wed, 05 Apr 2023 12:49:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350aOs7AtJ3q6RxmL38alxILOxSsLWA2V9ndGqPOcLj391pPzzJ6A38c2cfdJ1QeIVh53KAfw7Q==
X-Received: by 2002:a92:d282:0:b0:326:45af:ac3a with SMTP id p2-20020a92d282000000b0032645afac3amr4110780ilp.6.1680724187623;
        Wed, 05 Apr 2023 12:49:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x11-20020a92300b000000b00325daf836fdsm4046680ile.17.2023.04.05.12.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 12:49:47 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:49:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230405134945.29e967be.alex.williamson@redhat.com>
In-Reply-To: <ZC3KJUxJa0O0M+9O@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230405102545.41a61424.alex.williamson@redhat.com>
        <ZC2jsQuWiMYM6JZb@nvidia.com>
        <20230405105215.428fa9f5.alex.williamson@redhat.com>
        <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 16:21:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 05, 2023 at 12:56:21PM -0600, Alex Williamson wrote:
> > Usability needs to be a consideration as well.  An interface where the
> > result is effectively arbitrary from a user perspective because the
> > kernel is solely focused on whether the operation is allowed,
> > evaluating constraints that the user is unaware of and cannot control,
> > is unusable.  
> 
> Considering this API is only invoked by qemu we might be overdoing
> this usability and 'no shoot in foot' view.

Ok, I'm not sure why we're diminishing the de facto vfio userspace...

> > > This is a good point that qemu needs to make a policy decision if it
> > > is happy about the VFIO configuration - but that is a policy decision
> > > that should not become entangled with the kernel's security checks.
> > > 
> > > Today qemu can make this policy choice the same way it does right now
> > > - call _INFO and check the group_ids. It gets the exact same outcome
> > > as today. We already discussed that we need to expose the group ID
> > > through an ioctl someplace.  
> > 
> > QEMU can make a policy decision today because the kernel provides a
> > sufficiently reliable interface, ie. based on the set of owned groups, a
> > hot-reset is all but guaranteed to work.    
> 
> And we don't change that with cdev. If qemu wants to make the policy
> decision it keeps using the exact same _INFO interface to make that
> decision same it has always made.
> 
> We weaken the actual reset action to only consider the security side.
> 
> Applications that want this exclusive reset group policy simply must
> check it on their own. It is a reasonable API design.

I disagree, as I've argued before, the info ioctl becomes so weak and
effectively arbitrary from a user perspective at being able to predict
whether the hot-reset ioctl works that it becomes useless, diminishing
the entire hot-reset info/execute API.

> > > If this is too awkward we could add a query to the kernel if the cdev
> > > is "reset exclusive" - eg the iommufd covers all the groups that span
> > > the reset set.  
> > 
> > That's essentially what we have if there are valid dev-ids for each
> > affected device in the info ioctl.  
> 
> If you have dev-ids for everything, yes. If you don't, then you can't
> make the same policy choice using a dev-id interface.

Exactly, you can't make any policy choice because the success or
failure of the hot-reset ioctl can't be known.

> > I don't think it helps the user experience to create loopholes where
> > the hot-reset ioctl can still work in spite of those missing
> > devices.  
> 
> I disagree. The easy straightforward design is that the reset ioctl
> works if the process has security permissions. Mixing a policy check
> into the kernel on this path is creating complexity we don't really
> need.
> 
> I don't view it as a loophole, it is flexability to use the API in a
> way that is different from what qemu wants - eg an app like dpdk may
> be willing to tolerate a reset group that becomes unavailable after
> startup. Who knows, why should we force this in the kernel?

Because look at all the problems it's causing to try to introduce these
loopholes without also introducing subtle bugs.  There's an argument
that we're overly strict, which is better than the alternative, which
seems to be what we're dabbling with.  It is a straightforward
interface for the hot-reset ioctl to mirror the information provided
via the hot-reset info ioctl.

> > For example, we have a VFIO_DEVICE_GET_INFO ioctl that supports
> > capability chains, we could add a capability that reports the group ID
> > for the device.    
> 
> I was going to put that in an iommufd ioctl so it works with VDPA too,
> but sure, lets assume we can get the group ID from a cdev fd.
> 
> > The hot-reset info ioctl remains as it is today, reporting group-ids
> > and bdfs.  
> 
> Sure, but userspace still needs to know how to map the reset sets into
> dev-ids.

No, it doesn't. 

> Remember the reason we started doing this is because we don't
> have easy access to the BDF anymore.

We don't need it, the info ioctl provides the groups, the group
association can be learned from the DEVICE_GET_INFO ioctl, the
hot-reset ioctl only requires a single representative fd per affected
group.  dev-ids not required.

> I like leaving this ioctl alone, lets go back to a dedicated ioctl to
> return the dev_ids.

I don't see any justification for this.  We could add another PCI
specific DEVICE_GET_INFO capability to report the bdf if we really need
it, but reporting the group seems sufficient for this use case.

> > The hot-reset ioctl itself is modified to transparently
> > support either group fds or device fds.  The user can now map cdevs
> > to group-ids and therefore follow the same rules as groups,
> > providing at least one representative device fd for each group.  
> 
> This looks like a very complex uapi compared to the empty list option,
> but it seems like it would work.

It's the same API that we have now.  What's complex is trying to figure
out all the subtle side-effects from the loopholes that are being
proposed in this series.  Thanks,

Alex

