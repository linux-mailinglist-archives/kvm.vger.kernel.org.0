Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B05399D5
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 00:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348583AbiEaWwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbiEaWwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 18:52:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE9D72AE2D
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 15:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654037532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9q9k+C5RGQU4qKgmWFkXDcgQ25M6UKH1DBXC6+yr110=;
        b=E8E9R7zmtGGFSoCgN1WEBfttrIFe142RHCIs3N/J7k/laNcpKXQcjeOVw8WsgBIc56QPhH
        NPE9SExht5T5qy3SHxf0Qgo90E2oHpsNZXJiNnKmvg5Yu3GItknp9kJ78Nd7R0PzucS3Li
        yyslTAj5nF5PajyfZ3LAuuD8bekEiwI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-AWfrvt7GMGSBdbh2u-wa3A-1; Tue, 31 May 2022 18:52:11 -0400
X-MC-Unique: AWfrvt7GMGSBdbh2u-wa3A-1
Received: by mail-io1-f71.google.com with SMTP id ay41-20020a5d9da9000000b006685ce50214so5121454iob.22
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 15:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9q9k+C5RGQU4qKgmWFkXDcgQ25M6UKH1DBXC6+yr110=;
        b=bDW5foyRRPBAkHghk7BSGeqCLCwbwueiBTl4xC/KADG8Ptr1ECuqJIdFTTTZm0mxG2
         hSWlefZdXC9EKfm29BqEyzpGxtv4CxQZcv9QJWqMqkInO9jIW7MzcdG9ujGX47/XeqbH
         0NZm/eaSETa05IwmPwE/nVwip0QyqD4A309HwJ2NjUb33cutjSbOVqASWksyO7sQ1vBD
         0isOrp8TdE9lCGb0/Rig5KHdJIFFqOOskzGJ+NKEZeWVeDygez3rCyfz4iefnWv9F3nV
         UHCn41AE9tmUYOq+iLVg93h1/sdZXh4rpckRIRzYSyp8kpGAmXR9+sP1ODQjtJleZDBR
         W7eg==
X-Gm-Message-State: AOAM530JGnv+Bu39J8NwCHLA0JOnj5lKcuAc3SZ3NZW++WhILuF0WHyl
        9VzUQB/XqGTHhvwQlRM4Vw9anivOTnDIKFUE5LtBUFNF+gJ+/xHl0MhuB6/9lqa3fZshG7XGWsd
        cJY8Zpu4a4zmN
X-Received: by 2002:a05:6638:dc6:b0:32e:e2d7:8261 with SMTP id m6-20020a0566380dc600b0032ee2d78261mr21306058jaj.152.1654037531001;
        Tue, 31 May 2022 15:52:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFaz/Zncf57CZD055l8ggcPaldX2dVcDSiNf2yikAtVetyU+4sMp+QQR12XvYG/vo4kFwZKA==
X-Received: by 2002:a05:6638:dc6:b0:32e:e2d7:8261 with SMTP id m6-20020a0566380dc600b0032ee2d78261mr21306045jaj.152.1654037530793;
        Tue, 31 May 2022 15:52:10 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c18-20020a92c8d2000000b002cde6e352ffsm33236ilq.73.2022.05.31.15.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 15:52:10 -0700 (PDT)
Date:   Tue, 31 May 2022 16:52:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
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
Message-ID: <20220531165209.1c18854f.alex.williamson@redhat.com>
In-Reply-To: <20220531194304.GN1343366@nvidia.com>
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

On Tue, 31 May 2022 16:43:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, May 31, 2022 at 05:44:11PM +0530, Abhishek Sahu wrote:
> > On 5/30/2022 5:55 PM, Jason Gunthorpe wrote: =20
> > > On Mon, May 30, 2022 at 04:45:59PM +0530, Abhishek Sahu wrote:
> > >  =20
> > >>  1. In real use case, config or any other ioctl should not come along
> > >>     with VFIO_DEVICE_FEATURE_POWER_MANAGEMENT ioctl request.
> > >> =20
> > >>  2. Maintain some 'access_count' which will be incremented when we
> > >>     do any config space access or ioctl. =20
> > >=20
> > > Please don't open code locks - if you need a lock then write a proper
> > > lock. You can use the 'try' variants to bail out in cases where that
> > > is appropriate.
> > >=20
> > > Jason =20
> >=20
> >  Thanks Jason for providing your inputs.
> >=20
> >  In that case, should I introduce new rw_semaphore (For example
> >  power_lock) and move =E2=80=98platform_pm_engaged=E2=80=99 under =E2=
=80=98power_lock=E2=80=99 ? =20
>=20
> Possibly, this is better than an atomic at least
>=20
> >  1. At the beginning of config space access or ioctl, we can take the
> >     lock
> > =20
> >      down_read(&vdev->power_lock); =20
>=20
> You can also do down_read_trylock() here and bail out as you were
> suggesting with the atomic.
>=20
> trylock doesn't have lock odering rules because it can't sleep so it
> gives a bit more flexability when designing the lock ordering.
>=20
> Though userspace has to be able to tolerate the failure, or never make
> the request.
>=20
> >          down_write(&vdev->power_lock);
> >          ...
> >          switch (vfio_pm.low_power_state) {
> >          case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
> >                  ...
> >                          vfio_pci_zap_and_down_write_memory_lock(vdev);
> >                          vdev->power_state_d3 =3D true;
> >                          up_write(&vdev->memory_lock);
> >=20
> >          ...
> >          up_write(&vdev->power_lock); =20
>=20
> And something checks the power lock before allowing the memor to be
> re-enabled?
>=20
> >  4.  For ioctl access, as mentioned previously I need to add two
> >      callbacks functions (one for start and one for end) in the struct
> >      vfio_device_ops and call the same at start and end of ioctl from
> >      vfio_device_fops_unl_ioctl(). =20
>=20
> Not sure I followed this..

I'm kinda lost here too.  A couple replies back there was some concern
about race scenarios with multiple user threads accessing the device.
The ones concerning non-deterministic behavior if a user is
concurrently changing power state and performing other accesses are a
non-issue, imo.  I think our goal is only to expand the current
memory_lock to block accesses, including config space, while the device
is in low power, or some approximation bounded by the entry/exit ioctl.

I think the remaining issues is how to do that relative to the fact
that config space access can change the memory enable state and would
therefore need to upgrade the memory_lock read-lock to a write-lock.
For that I think we can simply drop the read-lock, acquire the
write-lock, and re-test the low power state.  If it has changed, that
suggests the user has again raced changing power state with another
access and we can simply drop the lock and return -EIO.

If I'm still misunderstanding, please let me know.  Thanks,

Alex

