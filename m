Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9310E53AB00
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356204AbiFAQWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356100AbiFAQWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:22:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38501255AF
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654100517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fe+RsC/wSV/MG/FY2/4emdTM3FVFwNmxL22TSRT9qK4=;
        b=Kb7onOzH89Ekqm4rIbKwb/Z1EMgR3dRYbHfezcYpJgkPfhI5w5Pk2fgdBTfP8wxGVn4tBR
        0P0r+HgMRQdVnJ/IM2q3a5kGSwTGaqnkVeO3zH/FlL6w+woPaGTq44H0ETA74KVb36vv+m
        WjJbHCriw273q7m7xIPGV7b2hVBFx48=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-n0qAy5dWMAGWuW3fiWwooA-1; Wed, 01 Jun 2022 12:21:55 -0400
X-MC-Unique: n0qAy5dWMAGWuW3fiWwooA-1
Received: by mail-il1-f198.google.com with SMTP id 3-20020a056e0220c300b002d3d7ebdfdeso1147592ilq.16
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 09:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fe+RsC/wSV/MG/FY2/4emdTM3FVFwNmxL22TSRT9qK4=;
        b=6sH2NxMP5rOD42xIygA2QsSEGhkWiFq6joahnMkD4ZslGl0b0YON/If/vPYDn9F89i
         pFLWyBMIHHmA7F7jgnPAGviQywiHDACGT5B0R2KO6Qb/7XeALiYwPq2hTblCZl0j50zY
         aNLyt0CPcXcS8H2obmpokgCupXecUiNtC+XjXS/H9bB2ILXJa+bVxuim48QGv/2jU6Iv
         pdEP7rLJJxBSwXgnyVxNyNJBfSOHB1K2O2yqP5veU9yec76MEtZh9JQi1h2Hl6wrj3Hs
         sz7ZwX9s16S2cQJy63cBepUHUTXfTrrRtgzKA54sc9C6geXrqYEQRwpjI1AOJ15qbJL4
         tncQ==
X-Gm-Message-State: AOAM532fc2I9qcKJc7m3pw0ICwVbxnQbxTsQyzegaO1t5IoBo8RJrDla
        YBFo54UZZ/HkaUC9w0Syb2h36PWsJ/SlZ4znSq9ZOooOJLRsMFQkU6v/XA4at4UsltUvBHZGKBT
        gt3Ow+E5cstBa
X-Received: by 2002:a92:cd87:0:b0:2d3:ce9a:f9a5 with SMTP id r7-20020a92cd87000000b002d3ce9af9a5mr447719ilb.76.1654100513054;
        Wed, 01 Jun 2022 09:21:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuKE3Kbv0zQEPQZ0sShHluFx5fjyQhKbRSTEtrQYLxVTW6PYTPfo2kvTuCDmBnyaJy15fmJA==
X-Received: by 2002:a92:cd87:0:b0:2d3:ce9a:f9a5 with SMTP id r7-20020a92cd87000000b002d3ce9af9a5mr447695ilb.76.1654100512776;
        Wed, 01 Jun 2022 09:21:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e37-20020a022125000000b0032e2996cadesm557032jaa.66.2022.06.01.09.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 09:21:52 -0700 (PDT)
Date:   Wed, 1 Jun 2022 10:21:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220601102151.75445f6a.alex.williamson@redhat.com>
In-Reply-To: <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-9-abhsahu@nvidia.com>
        <20220504134551.70d71bf0.alex.williamson@redhat.com>
        <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
        <20220509154844.79e4915b.alex.williamson@redhat.com>
        <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
        <42518bd5-da8b-554f-2612-80278b527bf5@nvidia.com>
        <20220530122546.GZ1343366@nvidia.com>
        <c73d537b-a653-bf79-68cd-ddc8f0f62a25@nvidia.com>
        <20220531194304.GN1343366@nvidia.com>
        <20220531165209.1c18854f.alex.williamson@redhat.com>
        <00b6e380-ecf4-1eaf-f950-2c418bdb6cac@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Jun 2022 15:19:07 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 6/1/2022 4:22 AM, Alex Williamson wrote:
> > On Tue, 31 May 2022 16:43:04 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >  =20
> >> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote: =20
> >>> On 5/30/2022 5:55 PM, Jason Gunthorpe wrote:   =20
> >>>> On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
> >>>>    =20
> >>>>>  1. In real use case, config or any other ioctl should not come alo=
ng
> >>>>>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
> >>>>> =20
> >>>>>  2. Maintain some 'access_count' which will be incremented when we
> >>>>>     do any config space access or ioctl.   =20
> >>>>
> >>>> Please don't open code locks - if you need a lock then write a proper
> >>>> lock. You can use the 'try' variants to bail out in cases where that
> >>>> is appropriate.
> >>>>
> >>>> Jason   =20
> >>>
> >>>  Thanks Jason for providing your inputs.
> >>>
> >>>  In that case, should I introduce new rw_semaphore (For example
> >>>  power_lock) and move =E2=80=98platform_pm_engaged=E2=80=99 under =E2=
=80=98power_lock=E2=80=99 ?   =20
> >>
> >> Possibly, this is better than an atomic at least
> >> =20
> >>>  1. At the beginning of config space access or ioctl, we can take the
> >>>     lock
> >>> =20
> >>>      down_read(&vdev->power_lock);   =20
> >>
> >> You can also do down_read_trylock() here and bail out as you were
> >> suggesting with the atomic.
> >>
> >> trylock doesn't have lock odering rules because it can't sleep so it
> >> gives a bit more flexability when designing the lock ordering.
> >>
> >> Though userspace has to be able to tolerate the failure, or never make
> >> the request.
> >> =20
>=20
>  Thanks Alex and Jason for providing your inputs.
>=20
>  Using down_read_trylock() along with Alex suggestion seems fine.
>  In real use case, config space access should not happen when the
>  device is in low power state so returning error should not
>  cause any issue in this case.
>=20
> >>>          down_write(&vdev->power_lock);
> >>>          ...
> >>>          switch (vfio_pm.low_power_state) {
> >>>          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
> >>>                  ...
> >>>                          vfio_pci_zap_and_down_write_memory_lock(vdev=
);
> >>>                          vdev->power_state_d3 =3D true;
> >>>                          up_write(&vdev->memory_lock);
> >>>
> >>>          ...
> >>>          up_write(&vdev->power_lock);   =20
> >>
> >> And something checks the power lock before allowing the memor to be
> >> re-enabled?
> >> =20
> >>>  4.  For ioctl access, as mentioned previously I need to add two
> >>>      callbacks functions (one for start and one for end) in the struct
> >>>      vfio_device_ops and call the same at start and end of ioctl from
> >>>      vfio_device_fops_unl_ioctl().   =20
> >>
> >> Not sure I followed this.. =20
> >=20
> > I'm kinda lost here too. =20
>=20
>=20
>  I have summarized the things below
>=20
>  1. In the current patch (v3 8/8), if config space access or ioctl was
>     being made by the user when the device is already in low power state,
>     then it was waking the device. This wake up was happening with
>     pm_runtime_resume_and_get() API in vfio_pci_config_rw() and
>     vfio_device_fops_unl_ioctl() (with patch v3 7/8 in this patch series).
>=20
>  2. Now, it has been decided to return error instead of waking the
>     device if the device is already in low power state.
>=20
>  3. Initially I thought to add following code in config space path
>     (and similar in ioctl)
>=20
>         vfio_pci_config_rw() {
>             ...
>             down_read(&vdev->memory_lock);
>             if (vdev->platform_pm_engaged)
>             {
>                 up_read(&vdev->memory_lock);
>                 return -EIO;
>             }
>             ...
>         }
>=20
>      And then there was a possibility that the physical config happens
>      when the device in D3cold in case of race condition.
>=20
>  4.  So, I wanted to add some mechanism so that the low power entry
>      ioctl will be serialized with other ioctl or config space. With this
>      if low power entry gets scheduled first then config/other ioctls will
>      get failure, otherwise low power entry will wait.
>=20
>  5.  For serializing this access, I need to ensure that lock is held
>      throughout the operation. For config space I can add the code in
>      vfio_pci_config_rw(). But for ioctls, I was not sure what is the best
>      way since few ioctls (VFIO_DEVICE_FEATURE_MIGRATION,
>      VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE etc.) are being handled in the
>      vfio core layer itself.
>=20
>  The memory_lock and the variables to track low power in specific to
>  vfio-pci so I need some mechanism by which I add low power check for
>  each ioctl. For serialization, I need to call function implemented in
>  vfio-pci before vfio core layer makes the actual ioctl to grab the
>  locks. Similarly, I need to release the lock once vfio core layer
>  finished the actual ioctl. I have mentioned about this problem in the
>  above point (point 4 in my earlier mail).
>=20
> > A couple replies back there was some concern
> > about race scenarios with multiple user threads accessing the device.
> > The ones concerning non-deterministic behavior if a user is
> > concurrently changing power state and performing other accesses are a
> > non-issue, imo.   =20
>=20
>  What does non-deterministic behavior here mean.
>  Is it for user side that user will see different result
>  (failure or success) during race condition or in the kernel side
>  (as explained in point 3 above where physical config access
>  happens when the device in D3cold) ? My concern here is for later
>  part where this config space access in D3cold can cause fatal error
>  on the system side as we have seen for memory disablement.

Yes, our only concern should be to prevent such an access.  The user
seeing non-deterministic behavior, such as during concurrent power
control and config space access, all combinations of success/failure
are possible, is par for the course when we decide to block accesses
across the life of the low power state.
=20
> > I think our goal is only to expand the current
> > memory_lock to block accesses, including config space, while the device
> > is in low power, or some approximation bounded by the entry/exit ioctl.
> >=20
> > I think the remaining issues is how to do that relative to the fact
> > that config space access can change the memory enable state and would
> > therefore need to upgrade the memory_lock read-lock to a write-lock.
> > For that I think we can simply drop the read-lock, acquire the
> > write-lock, and re-test the low power state.  If it has changed, that
> > suggests the user has again raced changing power state with another
> > access and we can simply drop the lock and return -EIO.
> >  =20
>=20
>  Yes. This looks better option. So, just to confirm, I can take the
>  memory_lock read-lock at the starting of vfio_pci_config_rw() and
>  release it just before returning from vfio_pci_config_rw() and
>  for memory related config access, we will release this lock and
>  re-aquiring again write version of this. Once memory write happens,
>  then we can downgrade this write lock to read lock ?

We only need to lock for the device access, so if you've finished that
access after acquiring the write-lock, there'd be no point to then
downgrade that to a read-lock.  The access should be finished by that
point.
=20
>  Also, what about IOCTLs. How can I take and release memory_lock for
>  ioctl. is it okay to go with Patch 7 where we call
>  pm_runtime_resume_and_get() before each ioctl or we need to do the
>  same low power check for ioctl also ?
>  In Later case, I am not sure how should I do the implementation so
>  that all other ioctl are covered from vfio core layer itself.

Some ioctls clearly cannot occur while the device is in low power, such
as resets and interrupt control, but even less obvious things like
getting region info require device access.  Migration also provides a
channel to device access.  Do we want to manage a list of ioctls that
are allowed in low power, or do we only want to allow the ioctl to exit
low power?

I'm also still curious how we're going to handle devices that cannot
return to low power such as the self-refresh mode on the GPU.  We can
potentially prevent any wake-ups from the vfio device interface, but
that doesn't preclude a wake-up via an external lspci.  I think we need
to understand how we're going to handle such devices before we can
really complete the design.  AIUI, we cannot disable the self-refresh
sleep mode without imposing unreasonable latency and memory
requirements on the guest and we cannot retrigger the self-refresh
low-power mode without non-trivial device specific code.  Thanks,

Alex

