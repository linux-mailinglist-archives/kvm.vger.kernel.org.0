Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C607AE49F
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 06:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjIZEiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 00:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjIZEiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 00:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D407E9
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695703040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OlxCYW4gvs6NcetxUbOuJzhkEzIekaCZ3GVBq7mXcyw=;
        b=G82Tof8ARAMaHS7vMJYpBXoQihjU8F8KCF9J0ku0j16h3gW33aHybaJ04byFn2+dTN54XJ
        dBPW7BTBHiiZWFwE43dQFI+IYZyzHwu8YNExrFfFoEENb9276dnyv/U4BPa14pJTdVoNvq
        vlDnca447rYdhczN/juOH8XKjE39Wmc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-9A9Fc-FWMCW76jSJdTnqLw-1; Tue, 26 Sep 2023 00:37:18 -0400
X-MC-Unique: 9A9Fc-FWMCW76jSJdTnqLw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-503343a850aso11610493e87.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695703037; x=1696307837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OlxCYW4gvs6NcetxUbOuJzhkEzIekaCZ3GVBq7mXcyw=;
        b=Rr8hl3Eh3aK+VP9nbW0GFJpbczOHnAJdDbrj8/KbQu1sVmq8WlWWSjhkpP/heucoQP
         85TwbcubQHvqPZUVuR71Plpy8Au0d6GJU+Gtjs0w7WWd2rVeMRTHkU8oQtuG1/+AEifs
         1XJHNU1yd8UYS7S4lk3Su+ma3mFP6FqwqMrRX2GXB+8iGtzcs+QYWqlS0hIy1UckU/2O
         PRLr1su9aavy/kpcYk8OdYxcZMUEj6uzhNbYSCn8IPT+ANuQRQjvI66pS+1REgJGyKLb
         ss1g37WNOpoeMTwhJD8t9ZLqK+mFWzPT+7YlqQ8YtQHJJ8hEs8tW3XNOxmW2pnCW4aFW
         mINQ==
X-Gm-Message-State: AOJu0Yyof47Aus3oDlAan3/HFNKMoLNWTVmwjhICER5jOCQSgn/huR/I
        ZfU0DMCANljLUE5w6dK++idZfXWJbEkoI1thRrvjU1ZXe7qWWv6SsBX8jqClO7PaLvpK6FLxEyB
        Hi/IDv7PlLLXZCEnUFoSEDekOYilc
X-Received: by 2002:a05:6512:ea0:b0:4fb:740a:81ae with SMTP id bi32-20020a0565120ea000b004fb740a81aemr8556506lfb.16.1695703037414;
        Mon, 25 Sep 2023 21:37:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNkpmgxSfocjjuW7aLgAyK6C+0u3te928OI7LJMt7eR6OZwrgABZeepiaMfe8FTOCLRsWIJA+ptKT1xgYbLi0=
X-Received: by 2002:a05:6512:ea0:b0:4fb:740a:81ae with SMTP id
 bi32-20020a0565120ea000b004fb740a81aemr8556492lfb.16.1695703037131; Mon, 25
 Sep 2023 21:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com> <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com> <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com> <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com> <PH0PR12MB5481304AA75B517A327C5690DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481304AA75B517A327C5690DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 12:37:05 +0800
Message-ID: <CACGkMEtfYu5zO1Dn7ErKid15DaDd3nm3yyt9kWsE-FVv-U8D0w@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 12:01=E2=80=AFPM Parav Pandit <parav@nvidia.com> wr=
ote:
>
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Tuesday, September 26, 2023 8:03 AM
> >
> > It's the implementation details in legacy. The device needs to make sur=
e (reset)
> > the driver can work (is done before get_status return).
> It is part of the 0.9.5 and 1.x specification as I quoted those text abov=
e.

What I meant is: legacy devices need to find their way to make legacy
drivers work. That's how legacy works.

It's too late to add any normative to the 0.95 spec. So the device
behaviour is actually defined by the legacy drivers. That is why it is
tricky.

If you can't find a way to make legacy drivers work, use modern.

That's it.

Thanks

