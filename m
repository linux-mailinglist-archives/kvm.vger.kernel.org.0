Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A480E7281F8
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 15:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbjFHN7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 09:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbjFHN7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 09:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E51B26B3
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 06:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686232719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+Cl85dFCgG9tl5CrXHNcJkL4NHE9KnC3wRcD0zMwGE=;
        b=eMF+ALdTblMRiaV7JJ5Ked/TP/FmfZV5j/n/nJQQBShU8P+AWcXzv9znFkpnpThJXiFFXK
        UBtbmNUbs9rLCfwDb6ya/rP/zg35/6Z0UFJO8dzVCFVOMKLPZI5y5z3YPFN/g/XpPGaUxC
        azw34dzgTfavvtC5/4DC+voIM559CAY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-TComUaNDPJWaTYFo7Dqrqg-1; Thu, 08 Jun 2023 09:58:38 -0400
X-MC-Unique: TComUaNDPJWaTYFo7Dqrqg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-777ab76f328so46689239f.1
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 06:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686232717; x=1688824717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L+Cl85dFCgG9tl5CrXHNcJkL4NHE9KnC3wRcD0zMwGE=;
        b=WjstYnA/EEM5bSR0NEA7LUltlrgkUbTw9cd+3T7W0QRDmsx/hHY3rTlzvqGSZfI/fj
         jRl6vjN8huTl7WyBBpOXTjeLSVSL6F8/Jff01ndK1PIwGMGpgh0LRuCIYd8Pz5waSynZ
         fYzrHA0LSWoKVSrlyRWpWqJtfjQfdBHcwNVxTaBClUNQRXUVLIrbbQl3oLq/awHKwObO
         5iQc9uYZCt9Rnddj+xKr8KO8EG6IB18GYg2lTAfHIQvJi8kVEVY8durNrStFoDjmRzC+
         wRZKHUw5P60sM+iMutP04YbpWMEQfUlqW3aQWUHZQ+hoY8Q/yNQ4c4s1zWiMxwYoQJx6
         Pcsw==
X-Gm-Message-State: AC+VfDwGmM3wc+doUsqrolq+YZ3V4IO9hPvsX3CzJGUVtamfQCZ1YWtK
        Gj/4e8o+m5qqX/GG70Is7s/ScfULyCQSyTYFV8q61zEkPglgMz/nMkqy2j2/wqRSZKAzIXuThEN
        Q5RljI0zlWK0T
X-Received: by 2002:a5d:8b5a:0:b0:774:8d6c:9fe7 with SMTP id c26-20020a5d8b5a000000b007748d6c9fe7mr1290982iot.3.1686232717394;
        Thu, 08 Jun 2023 06:58:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ73R/3+otuTd62ObvF1u5obbP0KM6i0OhUC6Kg9yUiAmHf3DyQqGxxg5M8dzDPP0ynU49ldiA==
X-Received: by 2002:a5d:8b5a:0:b0:774:8d6c:9fe7 with SMTP id c26-20020a5d8b5a000000b007748d6c9fe7mr1290976iot.3.1686232717180;
        Thu, 08 Jun 2023 06:58:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s23-20020a02ad17000000b00411af6e8091sm301466jan.66.2023.06.08.06.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:58:36 -0700 (PDT)
Date:   Thu, 8 Jun 2023 07:58:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@redhat.com>
Cc:     kvm@vger.kernel.org, jgg@nvidia.com, eric.auger@redhat.com,
        diana.craciun@oss.nxp.com
Subject: Re: [PATCH v2 3/3] vfio/fsl: Create Kconfig sub-menu
Message-ID: <20230608075835.4c7359bf.alex.williamson@redhat.com>
In-Reply-To: <d1722794-c0d3-1f7f-4195-334608165ff9@redhat.com>
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
        <20230607230918.3157757-4-alex.williamson@redhat.com>
        <d1722794-c0d3-1f7f-4195-334608165ff9@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Jun 2023 09:25:26 +0200
C=C3=A9dric Le Goater <clg@redhat.com> wrote:

> On 6/8/23 01:09, Alex Williamson wrote:
> > For consistency with pci and platform, push the vfio-fsl-mc option into=
 a
> > sub-menu.
> >=20
> > Reviewed-by: C=C3=A9dric Le Goater <clg@redhat.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >   drivers/vfio/fsl-mc/Kconfig | 4 ++++
> >   1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
> > index 597d338c5c8a..d2757a1114aa 100644
> > --- a/drivers/vfio/fsl-mc/Kconfig
> > +++ b/drivers/vfio/fsl-mc/Kconfig
> > @@ -1,3 +1,5 @@
> > +menu "VFIO support for FSL_MC bus devices"
> > + =20
>=20
> The menu entry can be empty on arches not supporting the FSL-MC bus.
> I think this needs an extra :
>=20
> 	depends on ARM64 || COMPILE_TEST

Good catch, but shouldn't we just move up the FSL_MC_BUS depends to the
menu level?  Thanks,

Alex

> >   config VFIO_FSL_MC
> >   	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
> >   	depends on FSL_MC_BUS
> > @@ -8,3 +10,5 @@ config VFIO_FSL_MC
> >   	  fsl-mc bus devices using the VFIO framework.
> >  =20
> >   	  If you don't know what to do here, say N.
> > +
> > +endmenu =20
>=20

