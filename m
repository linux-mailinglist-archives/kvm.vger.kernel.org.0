Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E4C6C025B
	for <lists+kvm@lfdr.de>; Sun, 19 Mar 2023 15:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCSOTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Mar 2023 10:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjCSOTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Mar 2023 10:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC351115B
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 07:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679235538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejAeQZaE9t++BUhFELV4UNtc0YbCJ3ps3T5OHxW+rV4=;
        b=FXlyw66xm6jg82Pv4+y9rLyhACJXb2HOboLggJEWGPsYNVac3C9UZs6GBcrCjEAG1noi2b
        PE0RJiDmAoHKD4n2i26NFafbHmbNacXgWDzgcktWX34Zs9PjkLyQIj2eimAj02zWSfaFgl
        chf4+ubKWZEBPnHM/iiZnyXs1SxIt8o=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-Y2uhUOGpPMq7mdX1prRrFA-1; Sun, 19 Mar 2023 10:18:56 -0400
X-MC-Unique: Y2uhUOGpPMq7mdX1prRrFA-1
Received: by mail-pl1-f197.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so5503099plh.8
        for <kvm@vger.kernel.org>; Sun, 19 Mar 2023 07:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679235535;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ejAeQZaE9t++BUhFELV4UNtc0YbCJ3ps3T5OHxW+rV4=;
        b=eou4rmt6z5qITjuSLxky4SYEO7/d63jVU7GzEocekA5OLuZ5AlCzTLmQgre+t87v0I
         5lK3pBg9JlhOSlKCMPb0D1qpq9C7jtmQq7OFqtQXmsWi8WAFh+farbdu9Zt6m/iAJi3u
         BfzXwgEyuJXxtONTmanGsuNZza6Jh7mCv1lttDorevxYNoF2copZ2RpJ8nYRr68xdIvR
         9u6vhdeXob7BJBbzuhzBzUvCaUYUErGEajMXnVLWQsBaBfuLiwUBqYhEz1HLN7vA1PRJ
         7Gw23cy5MIyOGtftwSrAEZaiIdynHAH91QNFK/pMc9M4nieBW42E8SlSuohK71s77Ei5
         rLVQ==
X-Gm-Message-State: AO0yUKWXF5zBx33lGs/icsLZGuJ07wgLOKG1SqxESIdcxftQjHrqu8+0
        3b0dEhROAJLR7scuTOgDVyR/FgSWo+ZJB6QDScGekZWISzOR4Hf+DaEWIL973tDlVrcOO7CpX2T
        N0uh3C29/t55r
X-Received: by 2002:a05:6a20:1327:b0:cd:1709:8d57 with SMTP id g39-20020a056a20132700b000cd17098d57mr12397855pzh.1.1679235535550;
        Sun, 19 Mar 2023 07:18:55 -0700 (PDT)
X-Google-Smtp-Source: AK7set9tfNPRhqGDJlbfTsNxCHhE4W60gGBe9RIUNs+gVdfJeMv07wFEBUoWlMrMnB0KWdE1Op9yyg==
X-Received: by 2002:a05:6a20:1327:b0:cd:1709:8d57 with SMTP id g39-20020a056a20132700b000cd17098d57mr12397839pzh.1.1679235535228;
        Sun, 19 Mar 2023 07:18:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c26-20020aa781da000000b0062578514d6fsm4667135pfn.58.2023.03.19.07.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 07:18:54 -0700 (PDT)
Date:   Sun, 19 Mar 2023 08:18:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: Re: [PATCH vfio] vfio/mlx5: Fix the report of dirty_bytes upon
 pre-copy
Message-ID: <20230319081851.6a078c39.alex.williamson@redhat.com>
In-Reply-To: <e55a6d9d-fcad-4c27-830e-9b1c66aaf04d@nvidia.com>
References: <20230308155723.108218-1-yishaih@nvidia.com>
        <20230308135639.1378418d.alex.williamson@redhat.com>
        <0b8ed235-777f-3752-e416-b50ea87f638c@nvidia.com>
        <e55a6d9d-fcad-4c27-830e-9b1c66aaf04d@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 19 Mar 2023 13:59:31 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 09/03/2023 10:08, Yishai Hadas wrote:
> > On 08/03/2023 22:56, Alex Williamson wrote: =20
> >> On Wed, 8 Mar 2023 17:57:23 +0200
> >> Yishai Hadas <yishaih@nvidia.com> wrote:
> >> =20
> >>> Fix the report of dirty_bytes upon pre-copy to include both the=20
> >>> existing
> >>> data on the migration file and the device extra bytes.
> >>>
> >>> This gives a better close estimation to what can be passed any more as
> >>> part of pre-copy.
> >>>
> >>> Fixes: 0dce165b1adf ("vfio/mlx5: Introduce vfio precopy ioctl=20
> >>> implementation")
> >>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >>> ---
> >>> =C2=A0 drivers/vfio/pci/mlx5/main.c | 14 ++++----------
> >>> =C2=A0 1 file changed, 4 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/pci/mlx5/main.c=20
> >>> b/drivers/vfio/pci/mlx5/main.c
> >>> index e897537a9e8a..d95fd382814c 100644
> >>> --- a/drivers/vfio/pci/mlx5/main.c
> >>> +++ b/drivers/vfio/pci/mlx5/main.c
> >>> @@ -442,16 +442,10 @@ static long mlx5vf_precopy_ioctl(struct file=20
> >>> *filp, unsigned int cmd,
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (migf->pre_copy_initial_bytes > *po=
s) {
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.initial_b=
ytes =3D migf->pre_copy_initial_bytes - *pos;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 buf =3D mlx5vf_get_data_b=
uff_from_pos(migf, *pos, &end_of_data);
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (buf) {
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
nfo.dirty_bytes =3D buf->start_pos + buf->length - *pos;
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (!end_of_data) {
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto err_migf_unlock;
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
nfo.dirty_bytes =3D inc_length;
> >>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.dirty_bytes =3D migf=
->max_pos - *pos;
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!info.dirty_bytes)
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 e=
nd_of_data =3D true;
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 info.dirty_bytes +=3D inc=
_length;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!end_of_data || !inc_length=
) { =20
> >> This is intended for v6.3, correct?=C2=A0 Thanks, =20
> >
> > Yes, thanks.
> >
> > Yishai
> > =20
> Alex,
>=20
> Are we fine to proceed here ?

Yes, I have this in the vfio for-linus branch, so it should already be
in linux-next.  I'll send a pull request for it this week.  Thanks,

Alex

