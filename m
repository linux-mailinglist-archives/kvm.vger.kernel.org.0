Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DA34C0207
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 20:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiBVTaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 14:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiBVTaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 14:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F22F26546
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 11:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645558183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/Jd5qPSi0YoZ3kqzdTLt1xOvKYnU22Qo00BT9erdYs=;
        b=cWUvuzIEBCRxeeVM6AfOwHjb9u8ay8CZawKb0WI4zLT+y0FksHRjgIinwaJaUgBVJYACSU
        q8b2tsQN93vogykVhE6Qx8Oh0wQ3vpRSxtDHg3Y4T2/RENNK257eLvYx3O0YFZ2lvNIPcl
        LBxXov9IYlWJ4S/yxrz8BVpn29obpQE=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-jEDyHv04O8ycI9yB3L5QaQ-1; Tue, 22 Feb 2022 14:29:42 -0500
X-MC-Unique: jEDyHv04O8ycI9yB3L5QaQ-1
Received: by mail-ot1-f69.google.com with SMTP id g24-20020a9d6a18000000b005af04eaa543so7173202otn.11
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 11:29:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=P/Jd5qPSi0YoZ3kqzdTLt1xOvKYnU22Qo00BT9erdYs=;
        b=vZceJgrHBiGPT3rIpf9JCBo34XUWSi2H53HmqQWjnIFYjBKwphsGLyrzJ+sx2P1SyW
         wnruBnXLziKPPWPI61/C52Z5jgDegVMlHH6EzFV3Oe8JFtL90UyeXNfM0pY+kIkhVWu0
         j/gd97xQusDeP0ezwftVrVTiKn5GvLRO7odmvuXy+rJ0GD3ZNmIct0knuFOndTJYMOYa
         BN4rh9vPrpYTe+Tk3mc0eqdNgvqpOpKdvsL2ClP32/PJB0G2eSlgvZFD2MRoAPOxl7A8
         mtJsn0FYWkQs6kQjU6MeG50pZiWJIhMCROZRDxauS596p4amnehj0FGUx4bHM7vSHZbk
         QSPA==
X-Gm-Message-State: AOAM533AAJwvu9+KswH+/7gTkIo6tSs/ITl/4I9004y7hYZ5hLQn0htM
        Fq7i4mCweRwwzP2xNo4IwnvJGCaMsZ3q+LFe0vdaW1xgrYNcg6NcdndtswiM6iaJhoy4K2epN3y
        fBP0WxDxOFvrI
X-Received: by 2002:a05:6808:2228:b0:2cf:f102:b72b with SMTP id bd40-20020a056808222800b002cff102b72bmr2831425oib.286.1645558181759;
        Tue, 22 Feb 2022 11:29:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwh29+asBEtg/qsvLMW4an6L8Nd9/EVBQ/g0hcum7J+rAegjy9pBVpr3MCPenuuqCzVpTX6pA==
X-Received: by 2002:a05:6808:2228:b0:2cf:f102:b72b with SMTP id bd40-20020a056808222800b002cff102b72bmr2831418oib.286.1645558181540;
        Tue, 22 Feb 2022 11:29:41 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g34sm6632626ooi.48.2022.02.22.11.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 11:29:40 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:29:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 0/8] vfio/hisilicon: add ACC live migration driver
Message-ID: <20220222122939.0394d152.alex.williamson@redhat.com>
In-Reply-To: <20220222004943.GF193956@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220222004943.GF193956@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Feb 2022 20:49:43 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 21, 2022 at 11:40:35AM +0000, Shameer Kolothum wrote:
> >=20
> > Hi,
> >=20
> > This series attempts to add vfio live migration support for
> > HiSilicon ACC VF devices based on the new v2 migration protocol
> > definition and mlx5 v8 series discussed here[0].
> >=20
> > RFCv4 --> v5
> >   - Dropped RFC tag as v2 migration APIs are more stable now.
> >   - Addressed review comments from Jason and Alex (Thanks!).
> >=20
> > This is sanity tested on a HiSilicon platform using the Qemu branch
> > provided here[1].
> >=20
> > Please take a look and let me know your feedback.
> >=20
> > Thanks,
> > Shameer
> > [0] https://lore.kernel.org/kvm/20220220095716.153757-1-yishaih@nvidia.=
com/
> > [1] https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2
> >=20
> >=20
> > v3 --> RFCv4
> > -Based on migration v2 protocol and mlx5 v7 series.
> > -Added RFC tag again as migration v2 protocol is still under discussion.
> > -Added new patch #6 to retrieve the PF QM data.
> > -PRE_COPY compatibility check is now done after the migration data
> > =C2=A0transfer. This is not ideal and needs discussion. =20
>=20
> Alex, do you want to keep the PRE_COPY in just for acc for now? Or do
> you think this is not a good temporary use for it?
>=20
> We have some work toward doing the compatability more generally, but I
> think it will be a while before that is all settled.

In the original migration protocol I recall that we discussed that
using the pre-copy phase for compatibility testing, even without
additional device data, as a valid use case.  The migration driver of
course needs to account for the fact that userspace is not required to
perform a pre-copy, and therefore cannot rely on that exclusively for
compatibility testing, but failing a migration earlier due to detection
of an incompatibility is generally a good thing.

If the ACC driver wants to re-incorporate this behavior into a non-RFC
proposed series and we could align accepting them into the same kernel
release, that sounds ok to me.  Thanks,

Alex

