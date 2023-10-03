Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301FC7B6F97
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 19:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjJCRVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 13:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjJCRVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 13:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9847EA3
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696353624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycuqtVjHcrXCLUdvSjDVUvWSxdxF9Ow7PHSrjQNyBrk=;
        b=RRsKE74rjoXpTb7dO40+I3RNaA11/1wzdB/oY+xGYWsqH0LDARG1LJm8L2T6xXdk7lVYel
        3BQRs1pvBgvSUojHQPJ6kZZQ6/LgZ2u0aieOIWEk6QIuP0pjusuPS1dkgI8G2bZUElPzIQ
        thBx6qgo5Rm8ra778SNgEfDryIuxKFM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210--B5VqzNvNt27PLAGOJoikA-1; Tue, 03 Oct 2023 13:20:23 -0400
X-MC-Unique: -B5VqzNvNt27PLAGOJoikA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3527b7aa4e6so7060825ab.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 10:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696353622; x=1696958422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ycuqtVjHcrXCLUdvSjDVUvWSxdxF9Ow7PHSrjQNyBrk=;
        b=LBW/kGC38yulno0Gs7rhrBbS4l1aVR5X5Qe9+7aFp5R8wyweu8NngKwb/SZOqBuQaD
         ofpu2164WOygfy38ddf7dN1kKCEzIKmxgRgpWfqKlShJHL5dvM1+YKAs0TMyNYCkc0t7
         rUGZrxCfpabBKuhghYLDCOT/8EeiFkk8UKIBEiT1OGEBVHx05FhOnOscJYTnctUHAYU/
         rnqhckQm/nz6xv9MlBGDGePT0A49IaXzxUi1U/Pet/X+4iYcpwv35ONytJTZ0Es3+YgL
         aILxyXcktb00ZQmRcziBg8ttCz7Ysk3fRVfy18+wkNyFM7TKzHuS0JI5lxUtkvrmwPcB
         8j+Q==
X-Gm-Message-State: AOJu0YyRw5vs9UYjFVYWImeox/8WUZ/aq6PfJ0AWhjGBsOvUVB/K2MI5
        8nd9lCMaPg+lX5CC+qkCz63susHoXI0qkiBh4wIWGTF8ChI7MQNvWMOSoZdw8jsfRpKqv0PlQ3j
        47JAsTqaVvtel
X-Received: by 2002:a92:c56e:0:b0:351:50f1:1f98 with SMTP id b14-20020a92c56e000000b0035150f11f98mr79553ilj.32.1696353622422;
        Tue, 03 Oct 2023 10:20:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnynlWHi7INx/zf65C77atiF7MZN2t7nxq6zwo60jAkNHoSX51/McrQhTu1+eBifVYHNmEgQ==
X-Received: by 2002:a92:c56e:0:b0:351:50f1:1f98 with SMTP id b14-20020a92c56e000000b0035150f11f98mr79539ilj.32.1696353622136;
        Tue, 03 Oct 2023 10:20:22 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z2-20020a92d182000000b0034e1092bccfsm472062ilz.80.2023.10.03.10.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 10:20:21 -0700 (PDT)
Date:   Tue, 3 Oct 2023 11:20:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        nipun.gupta@amd.com, nikhil.agarwal@amd.com,
        ndesaulniers@google.com, trix@redhat.com, shubham.rohila@amd.com,
        kvm@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] vfio/cdx: Add parentheses between bitwise AND
 expression and logical NOT
Message-ID: <20231003112019.4b067e45.alex.williamson@redhat.com>
In-Reply-To: <20231003152739.GB63187@dev-arch.thelio-3990X>
References: <20231002-vfio-cdx-logical-not-parentheses-v1-1-a8846c7adfb6@kernel.org>
        <1fbe8877-aaa5-1b6f-e18c-1d231a31d2e7@linaro.org>
        <20231003152739.GB63187@dev-arch.thelio-3990X>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Tue, 3 Oct 2023 08:27:39 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> On Tue, Oct 03, 2023 at 09:40:02AM +0200, Philippe Mathieu-Daud=C3=A9 wro=
te:
> > Hi Nathan,
> >=20
> > On 2/10/23 19:53, Nathan Chancellor wrote: =20
> > > When building with clang, there is a warning (or error with
> > > CONFIG_WERROR=3Dy) due to a bitwise AND and logical NOT in
> > > vfio_cdx_bm_ctrl():
> > >=20
> > >    drivers/vfio/cdx/main.c:77:6: error: logical not is only applied t=
o the left hand side of this bitwise operator [-Werror,-Wlogical-not-parent=
heses]
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^            ~
> > >    drivers/vfio/cdx/main.c:77:6: note: add parentheses after the '!' =
to evaluate the bitwise operator first
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^
> > >          |              (                        )
> > >    drivers/vfio/cdx/main.c:77:6: note: add parentheses around left ha=
nd side expression to silence this warning
> > >       77 |         if (!vdev->flags & BME_SUPPORT)
> > >          |             ^
> > >          |             (           )
> > >    1 error generated.
> > >=20
> > > Add the parentheses as suggested in the first note, which is clearly
> > > what was intended here.
> > >=20
> > > Closes: https://github.com/ClangBuiltLinux/linux/issues/1939
> > > Fixes: 8a97ab9b8b31 ("vfio-cdx: add bus mastering device feature supp=
ort") =20
> >=20
> > My current /master points to commit ce36c8b14987 which doesn't include
> > 8a97ab9b8b31, so maybe this can be squashed / reordered in the VFIO tree
> > (where I assume this commit is). That said, the fix is correct, so: =20
>=20
> Yes, this is a -next only issue at the moment and I don't mind this
> change being squashed into the original if Alex rebases his tree (some
> maintainers don't).

Right, where practical we try not to change commit hashes once
something has been included into linux-next, preferring to layer fixes
or even reverts, but occasionally something will come up where it makes
sense to rebase.  This is not such a case :)  Thanks,

Alex

> > Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> =20
>=20
> Thanks a lot for taking a look!
>=20
> Cheers,
> Nathan
>=20
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >   drivers/vfio/cdx/main.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
> > > index a437630be354..a63744302b5e 100644
> > > --- a/drivers/vfio/cdx/main.c
> > > +++ b/drivers/vfio/cdx/main.c
> > > @@ -74,7 +74,7 @@ static int vfio_cdx_bm_ctrl(struct vfio_device *cor=
e_vdev, u32 flags,
> > >   	struct vfio_device_feature_bus_master ops;
> > >   	int ret;
> > > -	if (!vdev->flags & BME_SUPPORT)
> > > +	if (!(vdev->flags & BME_SUPPORT))
> > >   		return -ENOTTY;
> > >   	ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> > >=20
> > > ---
> > > base-commit: fcb2f2ed4a80cfe383d87da75caba958516507e9
> > > change-id: 20231002-vfio-cdx-logical-not-parentheses-aca8fbd6b278
> > >=20
> > > Best regards, =20
> >  =20
>=20

