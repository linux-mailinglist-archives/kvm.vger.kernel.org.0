Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2244B7AE4A0
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 06:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjIZEiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 00:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjIZEiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 00:38:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3653E6
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695703047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sK7XhA7pNuDH69jUM+WS48wVbsIihORxbWDu0rbFBU8=;
        b=AFaCVl6XQH4zPNdzYmQsKS5bEHPA4fk2gUK+JcctzarlLjSfttEq7tLEp1fmuTNrbcfsES
        OfZsyT3clqxrdmzl2L7s/JpKZTEERI7HvVckg+zpH8v81QR509iqMFa4txyvs1O2cid4Dd
        cGfb54WyW18pEulrlLdBGPJxND97a2o=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85--OdxFFYBOay2bwOcoYlagw-1; Tue, 26 Sep 2023 00:37:25 -0400
X-MC-Unique: -OdxFFYBOay2bwOcoYlagw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bfb2c81664so108967651fa.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695703044; x=1696307844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sK7XhA7pNuDH69jUM+WS48wVbsIihORxbWDu0rbFBU8=;
        b=lnZ9Z2w379s4RomN73JBYnRB0SXyErJGF91K26dHyljIJBrysh+2tLvnaBb3D6TKqk
         2r0cT7lKsdgMzmcpoGgBzXWp89eSaxf7yXWxCB+e9nnkJ1FoC8ONLIsIX/xLDX65p31q
         eeisvyZYnk3wKvAxNGaguBbIu0rbFdeC9XR5W8s07mvOhCfBiKkbr53SRsX9HK2W8k7Z
         WXK5FEk5n8TTP4AjhWXqTS9e1TaOjn6ubBh50FURL/5T8NCqXUWB0m+JUUb1vejmfO82
         rioLetSo3kuyvYoK/cqbdMfaJkGeiLf2a/1xifKbdAbjpVC4liJYNdKGgAWc/tocYogK
         70hg==
X-Gm-Message-State: AOJu0YxpeftvERj9KkmtVD+ceJLw4ilTlU1lujd8zUTfnTXbUTv1x0Nz
        8JvPlPmmIX8+9isZLDVq/VgmDAl58k+Sl/EufcA7NxEpX7Lvq+Qlw2rYTbq1mtf1QffEvhSrd2Y
        mFZU0//dnjlxDDUOrX43++PP2p+kl
X-Received: by 2002:a05:6512:158d:b0:502:fdca:2ea6 with SMTP id bp13-20020a056512158d00b00502fdca2ea6mr8003665lfb.61.1695703044046;
        Mon, 25 Sep 2023 21:37:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0GVHQpxV6cu/bgf78VPW3Zw2158iGo2jNqikx3gXDl/JuLt9+Gce4NkjWxjwVm9d8/MPIKXfnRlQnBPIhjd4=
X-Received: by 2002:a05:6512:158d:b0:502:fdca:2ea6 with SMTP id
 bp13-20020a056512158d00b00502fdca2ea6mr8003656lfb.61.1695703043675; Mon, 25
 Sep 2023 21:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com> <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org> <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 12:37:12 +0800
Message-ID: <CACGkMEsWJmsHR_iVLD_SK0iQ_tALb3+Ev6fYTRkNm8iPGQ6pXQ@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 11:45=E2=80=AFAM Parav Pandit <parav@nvidia.com> wr=
ote:
>
>
>
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Tuesday, September 26, 2023 12:06 AM
>
> > One can thinkably do that wait in hardware, though. Just defer completi=
on until
> > read is done.
> >
> Once OASIS does such new interface and if some hw vendor _actually_ wants=
 to do such complex hw, may be vfio driver can adopt to it.

It is you that tries to revive legacy in the spec. We all know legacy
is tricky but work.

> When we worked with you, we discussed that there such hw does not have en=
ough returns and hence technical committee choose to proceed with admin com=
mands.

I don't think my questions regarding the legacy transport get good
answers at that time. What's more, we all know spec allows to fix,
workaround or even deprecate a feature.

Thanks

