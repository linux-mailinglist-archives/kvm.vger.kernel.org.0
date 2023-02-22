Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61B269F122
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 10:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjBVJSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 04:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBVJSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 04:18:32 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA3227D48;
        Wed, 22 Feb 2023 01:18:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h16so27749954edz.10;
        Wed, 22 Feb 2023 01:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bDXcsUPRL4UT1twN0Ir2xjoXiwcVYl6Jo6QwftXXn0Q=;
        b=jD2O3mypAIhVO2lUG6fBf60jp6G71KHISNKTa/WE8crJIqS+ZJtRettQw6AA8TAtKn
         rUdvi+hW2rroToXBaiyT0ngE9qAWNxUAhU0ndO1ko+PsSd1aBpBxyEtGz+QlK7WqDITM
         hQhPaIIq3PU3y16VhfUoTnf+GbbktUKGXRyvmMYBeUVdZuxE+5RJEuwx3oS6p8DWPUyj
         Re0vjwlQ36twccACor2l4HR3GnC4Lnlk9Wzn9MVNtoN0eB1B9e03/Ayq1fLiETUEA5ft
         7PlChqRIDpQQAzr3+U7uLgVCAlUjf5Q/35CHX9yVeIuRd84YSa9k7Aqnowg+kLD/VX/f
         zMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bDXcsUPRL4UT1twN0Ir2xjoXiwcVYl6Jo6QwftXXn0Q=;
        b=Ygnp5CANDPih1wIcsVCKIRpLp3Fu6naNEzKwE5Hfo9IbE8XAIWWgSAkOmvVEzcdBPF
         EDu5SCnKT5OqgDWmgchtxZ3mtZdMywrIf+46atAU9gzLDKoN8fHHzypyV10VJzpKGlOv
         oRAIDd6OivayxfxdXmdsFMlLs017Z4Sub2KYuygAnSj14LTxlbLR2HjPT0V3OZ1wYYch
         pVXYm49/ly2XQqfd2N6rSEFZllNzxIiF/nqg3G5UD6Xxe8gbv2YyFFDPna388tq4DYt1
         Xs0YQfSJ19fnK2KrqiDw68IPWfH9ZILDgy3vQr73bZfsk5mXrR/Dd5k6z2ktA0Tnvu7L
         YoSA==
X-Gm-Message-State: AO0yUKUqvE2n1JJofhjjFJZHrrR+JXS/QymiKikOHu4owpFtaor+Wl7Y
        E6I6wNXMBusXPBOJ/o6jyIs=
X-Google-Smtp-Source: AK7set/h7Vr1dqG5wxIxvwcQ1QGoNKpvOIrdzM9OBVTBU38biCpAWbjmbsEkZhdaexjNQtmY94+4mQ==
X-Received: by 2002:aa7:de13:0:b0:4ae:eb0f:4258 with SMTP id h19-20020aa7de13000000b004aeeb0f4258mr7980618edv.30.1677057509656;
        Wed, 22 Feb 2023 01:18:29 -0800 (PST)
Received: from sakura.myxoz.lan (81-230-97-204-no2390.tbcn.telia.com. [81.230.97.204])
        by smtp.gmail.com with ESMTPSA id l1-20020a50c101000000b004ad79733ac4sm3134404edf.40.2023.02.22.01.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 01:18:29 -0800 (PST)
Message-ID: <a4ad3fd15d41feda354ed50feaaccbe73e945d16.camel@gmail.com>
Subject: Re: [PATCH] vfio: Fix NULL pointer dereference caused by
 uninitialized group->iommufd
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Yan Zhao <yan.y.zhao@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     yi.l.liu@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 22 Feb 2023 10:18:28 +0100
In-Reply-To: <20230222074938.13681-1-yan.y.zhao@intel.com>
References: <20230222074938.13681-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-22 at 15:49 +0800, Yan Zhao wrote:
> group->iommufd is not initialized for the iommufd_ctx_put()
>=20
> [20018.331541] BUG: kernel NULL pointer dereference, address:
> 0000000000000000
> [20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
> ...
> [20018.476483] Call Trace:
> [20018.479214]=C2=A0 <TASK>
> [20018.481555]=C2=A0 vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
> [20018.487586]=C2=A0 __x64_sys_ioctl+0x6a/0xb0
> [20018.491773]=C2=A0 ? trace_hardirqs_on+0xc5/0xe0
> [20018.496347]=C2=A0 do_syscall_64+0x67/0x90
> [20018.500340]=C2=A0 entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>=20
> Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into
> group.c")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> =C2=A0drivers/vfio/group.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 57ebe5e1a7e6..8649f85f3be4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -137,7 +137,7 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ret =3D iommufd_vfio_compat_ioas_id(iommufd, &ioas_=
id);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (ret) {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iommufd_c=
tx_put(group->iommufd);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iommufd_c=
tx_put(iommufd);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0got=
o out_unlock;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0

Might want to Cc this to the stable mailing list.
--=20
~miko
