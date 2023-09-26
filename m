Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB37AE3AA
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjIZCdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjIZCdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:33:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBB5BF
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695695575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0JluPBGhmVM8tVgilHr9/e0vzuVc6qwOToBxrpulzw=;
        b=XkjQzBQkQQe9LqJNfWtMiRCMddyWu3j8MaubNDNgP7J0vIO3dLG9fUVL4q++i94wGvMHbz
        paozykxSJEDMIKwBdsGDqHQz+H2wcm74VC+G3xEb/BLDf2oId2B3IvUO2/CiceNW6A+oq8
        VC0T4HUhiZbrDK5w9fd4K8NDlBds75k=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-G9IpJhmvOoiUVpcSWhGJQw-1; Mon, 25 Sep 2023 22:32:53 -0400
X-MC-Unique: G9IpJhmvOoiUVpcSWhGJQw-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-500a9156daaso10906722e87.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695695572; x=1696300372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x0JluPBGhmVM8tVgilHr9/e0vzuVc6qwOToBxrpulzw=;
        b=wwbQf2oklUrVArIzD0Osv5XNNHXG4NzWBR6WzIaf1eiv+2JGxDSuFbZccSGAEQOymM
         nFu/OQ1Wnj22b0wL4uzc92JyaZHJuVLIapfXA7JCwNFVLkcWOwdbLlVa2Ym7jVlzT+Vr
         3M24eD7OT2x7d6uCjB0FhgW0gNEpj6839PgEloA1A43KpMVND2ma+E1j3tuOIJy//N65
         0X1ne5PJDfEIDTaxCoWnv/DLO59ivj/0DQXE08uwHAWX3Sd2b/beaM4COsvDRJtwHrQ/
         ryVUVERvt9dmMqehAQm4tb36DNgsAmkFLMUZo7p27KBsRAzBF4e26UFz/QLRRUrdD5b6
         z2qA==
X-Gm-Message-State: AOJu0YyaDvXIdCBbRvgkHY2NosoTklFTBLZ8K1tZHgqNT+Rcqw0wkWmI
        S3QrUmaAJjSX1UKGFilibYKCuLSAXQsjvfWOEe3/sDzh8f5AV9muK2jRbySjXMIWBg2JOwh15Wy
        pr7T/22d4SMm8AvNErdwRkbPPUvN1
X-Received: by 2002:a19:8c13:0:b0:503:9eb:d277 with SMTP id o19-20020a198c13000000b0050309ebd277mr6080318lfd.49.1695695571771;
        Mon, 25 Sep 2023 19:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE98wMaflBrXS+gHoxgs9l/TJJU2TyupUMywrdMyEJRf1bCQcDZI9jAcScVJR/3wSInoaBGHXT/cPoSMhPJERc=
X-Received: by 2002:a19:8c13:0:b0:503:9eb:d277 with SMTP id
 o19-20020a198c13000000b0050309ebd277mr6080308lfd.49.1695695571442; Mon, 25
 Sep 2023 19:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com> <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com> <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com> <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com> <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 10:32:39 +0800
Message-ID: <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 4:26=E2=80=AFPM Parav Pandit <parav@nvidia.com> wro=
te:
>
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Monday, September 25, 2023 8:00 AM
> >
> > On Fri, Sep 22, 2023 at 8:25=E2=80=AFPM Parav Pandit <parav@nvidia.com>=
 wrote:
> > >
> > >
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Friday, September 22, 2023 5:53 PM
> > >
> > >
> > > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > >
> > > > Oh? How? Our team didn't think so.
> > >
> > > It does not. It was already discussed.
> > > The device reset in legacy is not synchronous.
> >
> > How do you know this?
> >
> Not sure the motivation of same discussion done in the OASIS with you and=
 others in past.

That is exactly the same point.

It's too late to define the legacy behaviour accurately in the spec so
people will be lost in the legacy maze easily.

>
> Anyways, please find the answer below.
>
> About reset,
> The legacy device specification has not enforced below cited 1.0 driver r=
equirement of 1.0.
>
> "The driver SHOULD consider a driver-initiated reset complete when it rea=
ds device status as 0."

We are talking about how to make devices work for legacy drivers. So
it has nothing related to 1.0.

>
> [1] https://ozlabs.org/~rusty/virtio-spec/virtio-0.9.5.pdf
>
> > > The drivers do not wait for reset to complete; it was written for the=
 sw
> > backend.
> >
> > Do you see there's a flush after reset in the legacy driver?
> >
> Yes. it only flushes the write by reading it. The driver does not get _wa=
it_ for the reset to complete within the device like above.

It's the implementation details in legacy. The device needs to make
sure (reset) the driver can work (is done before get_status return).

That's all.

