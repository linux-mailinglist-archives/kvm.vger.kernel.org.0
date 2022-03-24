Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BD74E6AD1
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 23:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355466AbiCXWnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355478AbiCXWmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 18:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC310ADD67
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 15:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648161677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9WNoz/FzvLksUXnj3LwqVUaZSJ8tKS3cuqgqvhdHn0=;
        b=Izg8yZKXJM2k8YllcrWc7YsshReDVQV+qnNnifg64CufRVUCjNLvHivPskibr9uMR6Pbi4
        saIMQ5umLZkrPgb/pYQarbOisflM2mLCjWmGAz679rswIMKvGCzEOL4XTIwidGBVrz/RTO
        DFOqT0gDsWQ2ezpmf/4K6gy7wnne0/E=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-sZyYwh4VMca8JaCaHkFvaA-1; Thu, 24 Mar 2022 18:41:16 -0400
X-MC-Unique: sZyYwh4VMca8JaCaHkFvaA-1
Received: by mail-il1-f198.google.com with SMTP id g5-20020a92dd85000000b002c79aa519f4so3587014iln.10
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 15:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l9WNoz/FzvLksUXnj3LwqVUaZSJ8tKS3cuqgqvhdHn0=;
        b=p6A2/0YwALMOvEqDkeSbtlC0RoY/PMLEwDes/b/pOw9fE0eNVnd2Wy1rSynKesEWxG
         qJU0gQSbSypsXGB+hN9AX0pXNiwpsqa6ikM9/jQwjMqy8bLEAB1XTK/cwUhmmbYexcQL
         5WhFejwm6XmPvym2a4I7sycYAzVV9qk1N0rOWUaTvW0iBzHxKZNTKhI0Vjf4pvosbcbo
         FC/qTUzGRHRFWrWOEaBiUbVlknIu4WtJgImUOcVZeG91Yfa3Gp5BgtCrLzlKLuZ0Vwlh
         CxFOicIvTVmp8Yy58vdUNbivIkY9rabxXj9VUHeU6w63ZJcppFUf8WFYR59BCJc9Tia1
         58Mw==
X-Gm-Message-State: AOAM53338cmtDuy32KnZgnJnRDTrdmGycu2m1Vs9EIHfBaXw/1GYvSLH
        4ciOcum29F55tOWicg/9zA5TrP1TW/W+2qh3z1hSJa7Xw9R56QxmsctEl3N3t/dAxytSee+Q5lb
        iNIS5+IQn2b2o
X-Received: by 2002:a05:6638:371f:b0:31a:8654:e49c with SMTP id k31-20020a056638371f00b0031a8654e49cmr3994484jav.197.1648161675850;
        Thu, 24 Mar 2022 15:41:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8BahSZl1L2C0PBuAAPzP0FUv2fHadswqtKoqwYknCJfEeQpET1HU5FEk+lcbhTyW3Tu6Gjg==
X-Received: by 2002:a05:6638:371f:b0:31a:8654:e49c with SMTP id k31-20020a056638371f00b0031a8654e49cmr3994469jav.197.1648161675601;
        Thu, 24 Mar 2022 15:41:15 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q197-20020a6b8ece000000b00648d615e80csm2082175iod.41.2022.03.24.15.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 15:41:15 -0700 (PDT)
Date:   Thu, 24 Mar 2022 16:41:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220324164114.78f2e63a.alex.williamson@redhat.com>
In-Reply-To: <20220324222739.GZ11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
        <20220322145741.GH11336@nvidia.com>
        <20220322092923.5bc79861.alex.williamson@redhat.com>
        <20220322161521.GJ11336@nvidia.com>
        <20220324144015.031ca277.alex.williamson@redhat.com>
        <20220324222739.GZ11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Mar 2022 19:27:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Mar 24, 2022 at 02:40:15PM -0600, Alex Williamson wrote:
> > On Tue, 22 Mar 2022 13:15:21 -0300
> > Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org> wrote:
> >  =20
> > > On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
> > >  =20
> > > > I'm still picking my way through the series, but the later compat
> > > > interface doesn't mention this difference as an outstanding issue.
> > > > Doesn't this difference need to be accounted in how libvirt manages=
 VM
> > > > resource limits?     =20
> > >=20
> > > AFACIT, no, but it should be checked.
> > >  =20
> > > > AIUI libvirt uses some form of prlimit(2) to set process locked
> > > > memory limits.   =20
> > >=20
> > > Yes, and ulimit does work fully. prlimit adjusts the value:
> > >=20
> > > int do_prlimit(struct task_struct *tsk, unsigned int resource,
> > > 		struct rlimit *new_rlim, struct rlimit *old_rlim)
> > > {
> > > 	rlim =3D tsk->signal->rlim + resource;
> > > [..]
> > > 		if (new_rlim)
> > > 			*rlim =3D *new_rlim;
> > >=20
> > > Which vfio reads back here:
> > >=20
> > > drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit =3D =
rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > > drivers/vfio/vfio_iommu_type1.c:        unsigned long limit =3D rlimi=
t(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > >=20
> > > And iommufd does the same read back:
> > >=20
> > > 	lock_limit =3D
> > > 		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > > 	npages =3D pages->npinned - pages->last_npinned;
> > > 	do {
> > > 		cur_pages =3D atomic_long_read(&pages->source_user->locked_vm);
> > > 		new_pages =3D cur_pages + npages;
> > > 		if (new_pages > lock_limit)
> > > 			return -ENOMEM;
> > > 	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pag=
es,
> > > 				     new_pages) !=3D cur_pages);
> > >=20
> > > So it does work essentially the same. =20
> >=20
> > Well, except for the part about vfio updating mm->locked_vm and iommufd
> > updating user->locked_vm, a per-process counter versus a per-user
> > counter.  prlimit specifically sets process resource limits, which get
> > reflected in task_rlimit. =20
>=20
> Indeed, but that is not how the majority of other things seem to
> operate it.
>=20
> > For example, let's say a user has two 4GB VMs and they're hot-adding
> > vfio devices to each of them, so libvirt needs to dynamically modify
> > the locked memory limit for each VM.  AIUI, libvirt would look at the
> > VM size and call prlimit to set that value.  If libvirt does this to
> > both VMs, then each has a task_rlimit of 4GB.  In vfio we add pinned
> > pages to mm->locked_vm, so this works well.  In the iommufd loop above,
> > we're comparing a per-task/process limit to a per-user counter.  So I'm
> > a bit lost how both VMs can pin their pages here. =20
>=20
> I don't know anything about libvirt - it seems strange to use a
> securityish feature like ulimit but not security isolate processes
> with real users.
>=20
> But if it really does this then it really does this.
>=20
> So at the very least VFIO container has to keep working this way.
>=20
> The next question is if we want iommufd's own device node to work this
> way and try to change libvirt somehow. It seems libvirt will have to
> deal with this at some point as iouring will trigger the same problem.
>=20
> > > This whole area is a bit peculiar (eg mlock itself works differently),
> > > IMHO, but with most of the places doing pins voting to use
> > > user->locked_vm as the charge it seems the right path in today's
> > > kernel. =20
> >=20
> > The philosophy of whether it's ultimately a better choice for the
> > kernel aside, if userspace breaks because we're accounting in a
> > per-user pool rather than a per-process pool, then our compatibility
> > layer ain't so transparent. =20
>=20
> Sure, if it doesn't work it doesn't work. Lets be sure and clearly
> document what the compatability issue is and then we have to keep it
> per-process.
>=20
> And the same reasoning likely means I can't change RDMA either as qemu
> will break just as well when qemu uses rdma mode.
>=20
> Which is pretty sucky, but it is what it is..

I added Daniel Berrang=C3=A9 to the cc list for my previous reply, hopefully
he can comment whether libvirt has the sort of user security model you
allude to above that maybe makes this a non-issue for this use case.
Unfortunately it's extremely difficult to prove that there are no such
use cases out there even if libvirt is ok.  Thanks,

Alex

