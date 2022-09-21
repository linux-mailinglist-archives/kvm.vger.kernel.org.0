Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329725BF801
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 09:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiIUHoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 03:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIUHoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 03:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57AE857D8
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 00:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663746252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=86vShVgoh12B6XaEHHutbnawfEbjDkAMZ1MtTQw6pEo=;
        b=TTkRLk9VJyyXDrdcaxlAO54VgWCTn04Nrd41Xj2Xsz9oc6meGlFzy53j1hoSmu6UA6zkSU
        gVIOQnzLzRLR0dPZYeeqjWr111lfp8Lsx8iudmpYsEpQeAB0wBXZbf0moYe3jp0a+sUIJa
        lxPVfk63Fk3EM59z0mM3VO/dEVHQJZw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-1Nsr2On_OPylaaxhaA86xw-1; Wed, 21 Sep 2022 03:44:01 -0400
X-MC-Unique: 1Nsr2On_OPylaaxhaA86xw-1
Received: by mail-oi1-f199.google.com with SMTP id k4-20020a05680808c400b0034f6d529d2bso2732522oij.22
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 00:44:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=86vShVgoh12B6XaEHHutbnawfEbjDkAMZ1MtTQw6pEo=;
        b=pBEe8bqCcXW8+DkN8KgNCJF864GJDfy6/+VNnC9Cwwi6eiRkYyeAXYgnPvyvcH0UOw
         3yiXTRt3l+XYy+63CjfB3ouXfLgZ/vsDcuaeU0rgFOQ1/wTEEPRs7cRCov8BdYxJQEOy
         oW+AKSbd3B9BItV1pOwR7OpPtatYEfp8T++UTzz92TELyHGHit36rsHYlYdFboBlejtG
         sFwgIi7giWm3aZmC+s0Q7Nyoot25ATRjrcYcrqFjWvmkAwkvSVdPr1+G4PXs7j0sf9wy
         s+35xBBe7K2Eou3I30nZqddqCRujkoHzBENmm0P9gL2ZhQd3Mti720QrfLHIQIQ30Lwl
         GbCQ==
X-Gm-Message-State: ACrzQf1Uno2TYyrPRNwxtoqGJuRQvdcUTp5qOcNnBJNiJ29hky6Q4fqf
        Q22lvHBkVSF8yYkikXPV0XcXHRZjmU4IloPleprjCNkrkiHx8aHiT/3NwJWCp7ngtR15Jt3Bzwg
        +77lDkxIcbDujjXijaLECbvyF8/IA
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id y4-20020a056808130400b00350649bf8a1mr3234466oiv.280.1663746241015;
        Wed, 21 Sep 2022 00:44:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7qONZ88pXEclF6rWHrCx6zwa1UB2BpZ/Kart+KFBy/YxtaT63ZnO00Ywv2ymwreiaf+VxnSFQCuGq04KCBrEo=
X-Received: by 2002:a05:6808:1304:b0:350:649b:f8a1 with SMTP id
 y4-20020a056808130400b00350649bf8a1mr3234455oiv.280.1663746240793; Wed, 21
 Sep 2022 00:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-3-lingshan.zhu@intel.com> <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
 <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com> <CACGkMEuusM3EMmWW6+q8V1fZscfjM2R9n7jGefUnSY59UnZDYQ@mail.gmail.com>
 <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
In-Reply-To: <ed56a694-a024-23be-d4cb-7ab51c959b61@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Sep 2022 15:43:49 +0800
Message-ID: <CACGkMEuXA6Uj7OHqUDux=Yz+XFtouKWGOVV4fk5B5XCZW5F22w@mail.gmail.com>
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is set
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 1:39 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 9/21/2022 10:14 AM, Jason Wang wrote:
> > On Tue, Sep 20, 2022 at 1:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >>
> >> On 9/20/2022 10:16 AM, Jason Wang wrote:
> >>> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>>> vdpa_dev_net_config_fill() should only report driver features
> >>>> to userspace after features negotiation is done.
> >>>>
> >>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>>> ---
> >>>>    drivers/vdpa/vdpa.c | 13 +++++++++----
> >>>>    1 file changed, 9 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >>>> index 798a02c7aa94..29d7e8858e6f 100644
> >>>> --- a/drivers/vdpa/vdpa.c
> >>>> +++ b/drivers/vdpa/vdpa.c
> >>>> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>>>           struct virtio_net_config config = {};
> >>>>           u64 features_device, features_driver;
> >>>>           u16 val_u16;
> >>>> +       u8 status;
> >>>>
> >>>>           vdev->config->get_config(vdev, 0, &config, sizeof(config));
> >>>>
> >>>> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>>>           if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>>>                   return -EMSGSIZE;
> >>>>
> >>>> -       features_driver = vdev->config->get_driver_features(vdev);
> >>>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >>>> -                             VDPA_ATTR_PAD))
> >>>> -               return -EMSGSIZE;
> >>>> +       /* only read driver features after the feature negotiation is done */
> >>>> +       status = vdev->config->get_status(vdev);
> >>>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> >>> Any reason this is not checked in its caller as what it used to do before?
> >> will check the existence of vdev->config->get_status before calling it in V2
> > Just to clarify, I meant to check FEAUTRES_OK in the caller -
> > vdpa_dev_config_fill() otherwise each type needs to repeat this in
> > their specific codes.
> if we check FEATURES_OK in the caller vdpa_dev_config_fill(), then
> !FEATURES_OK will block reporting all attributions, for example
> the device features and virtio device config space fields in this series
> and device status.
> Currently only driver features needs to check FEATURES_OK.
> Or did I missed anything?

I don't see much difference, we just move the following part to the
caller, it is not the config but the VDPA_ATTR_DEV_NEGOTIATED_FEATURES
is blocked.

Thanks

>
> Thanks
> >
> > Thanks
> >
> >> Thanks,
> >> Zhu Lingshan
> >>> Thanks
> >>>
> >>>> +               features_driver = vdev->config->get_driver_features(vdev);
> >>>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >>>> +                                     VDPA_ATTR_PAD))
> >>>> +                       return -EMSGSIZE;
> >>>> +       }
> >>>>
> >>>>           features_device = vdev->config->get_device_features(vdev);
> >>>>
> >>>> --
> >>>> 2.31.1
> >>>>
>

