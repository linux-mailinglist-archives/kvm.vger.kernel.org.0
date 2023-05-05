Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578466F807A
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 12:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjEEKCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 06:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjEEKCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 06:02:02 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5DF1161C;
        Fri,  5 May 2023 03:01:59 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 9C7DD12FA060;
        Fri,  5 May 2023 12:01:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1683280913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2U8Eyv9nlZnFEQ8LEuDy/nhAeBfgve9KkqjGss4tmqU=;
        b=oxOU7q3BEN1zLMIqYfCJqAmwPBRg+HQJ6RDIO+mpq9nrSjS/Vakss/QZ9YVIY5CEjQan4R
        rQj0RKBx6PVnqPMNs+g9G3gf5MHHqHh/oBDle2jQXoEreSS+7G30UUyq/97BJVXkDIePg8
        pr4EPL2LkMeKwL09YhQVRy98D1SjeIY=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>, Bo Liu <liubo03@inspur.com>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: demote hiding ecap messages to debug level
Date:   Fri, 05 May 2023 12:01:51 +0200
Message-ID: <2680715.mvXUDI8C0e@natalenko.name>
In-Reply-To: <20230504170111.70a7f639.alex.williamson@redhat.com>
References: <20230504131654.24922-1-oleksandr@natalenko.name>
 <20230504170111.70a7f639.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

On p=C3=A1tek 5. kv=C4=9Btna 2023 1:01:11 CEST Alex Williamson wrote:
> On Thu,  4 May 2023 15:16:54 +0200
> Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
>=20
> > Seeing a burst of messages like this:
> >=20
> >     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
> >     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
> >     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
> >     vfio-pci 0000:98:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
> >     vfio-pci 0000:98:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
> >     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x19@0x1d0
> >     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x25@0x200
> >     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x26@0x210
> >     vfio-pci 0000:b1:00.0: vfio_ecap_init: hiding ecap 0x27@0x250
> >     vfio-pci 0000:b1:00.1: vfio_ecap_init: hiding ecap 0x25@0x200
> >=20
> > is of little to no value for an ordinary user.
> >=20
> > Hence, use pci_dbg() instead of pci_info().
> >=20
> > Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio=
_pci_config.c
> > index 948cdd464f4e..dd8dda14e701 100644
> > --- a/drivers/vfio/pci/vfio_pci_config.c
> > +++ b/drivers/vfio/pci/vfio_pci_config.c
> > @@ -1643,7 +1643,7 @@ static int vfio_ecap_init(struct vfio_pci_core_de=
vice *vdev)
> >  		}
> > =20
> >  		if (!len) {
> > -			pci_info(pdev, "%s: hiding ecap %#x@%#x\n",
> > +			pci_dbg(pdev, "%s: hiding ecap %#x@%#x\n",
> >  				 __func__, ecap, epos);
> > =20
> >  			/* If not the first in the chain, we can skip over it */
>=20
> Looks fine to me, though I might adjust that next line to keep the
> previous alignment.

Sure, but if you want me to send v2 with this, please let me know.

Thanks.

> In general this has certainly caused more
> confusion than insightful information, so demoting it to debug is a
> good idea.  Thanks,
>=20
> Alex
>=20
>=20


=2D-=20
Oleksandr Natalenko (post-factum)


