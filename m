Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB876BDB5
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 21:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjHAT1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 15:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjHAT1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 15:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ECEAC
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690917949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wSvNrFp0NYCS/oIN6QKA9aBM8ubANQEi3P7nUmYukh0=;
        b=MIqhAWGR0SHDpdZZRb6qu+dr/LpsKfJIs0+1bwirVSz2CcUZNmd00xWGjVKZxOQbZdHBFi
        tnwEHDwqQI5W30oXofShMQtB5WX5H80fZ2HoaSnRtqevhf2W8c8Kht7WERmBDMM3PssJpc
        ur2su4uJ2Oj7pqLqW4+8zB7mjzQBY2o=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-QGNxz7-rMZuKksCb0Ucr3g-1; Tue, 01 Aug 2023 15:24:55 -0400
X-MC-Unique: QGNxz7-rMZuKksCb0Ucr3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AE063815F66
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 19:24:45 +0000 (UTC)
Received: from localhost (unknown [10.39.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD0240C1258;
        Tue,  1 Aug 2023 19:24:44 +0000 (UTC)
Date:   Tue, 1 Aug 2023 15:24:43 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, sgarzare@redhat.com
Subject: Re: VFIO_IOMMU_GET_INFO capability struct alignment
Message-ID: <20230801192443.GB1414936@fedora>
References: <20230801153846.GA1371443@fedora>
 <20230801101730.607d96ab.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pgpGrWVkZzo7+5tC"
Content-Disposition: inline
In-Reply-To: <20230801101730.607d96ab.alex.williamson@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--pgpGrWVkZzo7+5tC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 01, 2023 at 10:17:30AM -0600, Alex Williamson wrote:
> On Tue, 1 Aug 2023 11:38:46 -0400
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > Hi,
> > It appears that ioctl(VFIO_IOMMU_GET_INFO) can produce misaligned
> > capability structures. Userspace workarounds exist but I wanted to ask
> > whether the kernel can align capability structures to save all userspace
> > programs the trouble?
> >=20
> > The issue is:
> >=20
> >   struct vfio_iommu_type1_info_dma_avail {
> >           struct vfio_info_cap_header header;              /*     0    =
 8 */
> >           __u32                      avail;                /*     8    =
 4 */
> >  =20
> >           /* size: 12, cachelines: 1, members: 2 */
> >           /* last cacheline: 12 bytes */
> >   };
> >=20
> > Once this capability is added, the next capability will be 4-byte
> > aligned but not 8-byte aligned. If there are __u64 fields in the next
> > capability, then they will be misaligned.
> >=20
> > This was noticed when investigating a bug in userspace code that uses
> > ioctl(VFIO_IOMMU_GET_INFO):
> > https://gitlab.com/pci-driver/pci-driver/-/merge_requests/2#note_149573=
4084
> >=20
> > One possible solution is to modify vfio_info_cap_add() so that
> > capability structures are always rounded up to 8 bytes. This does not
> > break the uapi because capability structure offsets are described at
> > runtime via the cap_offset and header->next fields. Existing userspace
> > programs would continue to work and all programs would find that
> > capability structures are now aligned.
>=20
> Yes, I think the helpers should automatically align each added
> capability.  Thanks,

Thanks, I will give it a try and post a patch.

Stefan

--pgpGrWVkZzo7+5tC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTJW/sACgkQnKSrs4Gr
c8g7rwf/e0PFzwRvPdZyNPyn5CLYAm6s17FJvQ+8QBym8ddJOQO0anZHH2gTbfd0
GZMXHMJMPODVS+FW+CDHF/DtafgNZGrRw3pKAL5Q0Qvdzzm0QKefpMwPfU9ksedB
FIRq6NfVFB73LJvE8NLjkSlTnZCFLxiDtNCIDCE3rD/avd6v1RRB40/qxSUDhJ3B
I0NwlnmxUGtr7AlpuN9NA40EJFy2lOd/fFtBXRYn5QqUislwnnJoHvEj1bWLeYN7
tKF0uPbu55z0Pnlk+NIovp6rYQG70C/5J7O1/0/Owk88/C7KxWJuT33jTP/DyZHH
YUQIZil6VUKPSAKY2+rLTm0Yl8bDww==
=+x6C
-----END PGP SIGNATURE-----

--pgpGrWVkZzo7+5tC--

