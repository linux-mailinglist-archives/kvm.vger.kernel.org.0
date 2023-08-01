Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39BB76B8D0
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjHAPkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbjHAPkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:40:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40D6193
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690904331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=yq/qYz3Poe9NsVhns+hVeIy1pB+HVVJ4dgynx/VpQtM=;
        b=Dd/NTeiV0weFEsb5UwH6eb0ikz7De5fLUAswpfS7btRap64iI4PeKEqr/IWQV7C1fLyC3g
        v+AnCzH9vk3hXWj/0wyuQpK2Ve/z0gokkT+xwsMAYDHvYWUs5D+Bw2L2xye2Yods3qmY8q
        kLTeXekwuK+S539VCtSxsV5SOQLJggU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-mhY3HjyfPeeNOiYijXgZfw-1; Tue, 01 Aug 2023 11:38:49 -0400
X-MC-Unique: mhY3HjyfPeeNOiYijXgZfw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 461C8185A7A8
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 15:38:49 +0000 (UTC)
Received: from localhost (unknown [10.39.195.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C903401DA9;
        Tue,  1 Aug 2023 15:38:48 +0000 (UTC)
Date:   Tue, 1 Aug 2023 11:38:46 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, sgarzare@redhat.com
Subject: VFIO_IOMMU_GET_INFO capability struct alignment
Message-ID: <20230801153846.GA1371443@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xii5Oczx/KGP+C43"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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


--xii5Oczx/KGP+C43
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
It appears that ioctl(VFIO_IOMMU_GET_INFO) can produce misaligned
capability structures. Userspace workarounds exist but I wanted to ask
whether the kernel can align capability structures to save all userspace
programs the trouble?

The issue is:

  struct vfio_iommu_type1_info_dma_avail {
          struct vfio_info_cap_header header;              /*     0     8 */
          __u32                      avail;                /*     8     4 */
 =20
          /* size: 12, cachelines: 1, members: 2 */
          /* last cacheline: 12 bytes */
  };

Once this capability is added, the next capability will be 4-byte
aligned but not 8-byte aligned. If there are __u64 fields in the next
capability, then they will be misaligned.

This was noticed when investigating a bug in userspace code that uses
ioctl(VFIO_IOMMU_GET_INFO):
https://gitlab.com/pci-driver/pci-driver/-/merge_requests/2#note_1495734084

One possible solution is to modify vfio_info_cap_add() so that
capability structures are always rounded up to 8 bytes. This does not
break the uapi because capability structure offsets are described at
runtime via the cap_offset and header->next fields. Existing userspace
programs would continue to work and all programs would find that
capability structures are now aligned.

Stefan

--xii5Oczx/KGP+C43
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTJJwYACgkQnKSrs4Gr
c8hQZwf+KHRPd+SyfNSeuJTZ/fLo7xckOJFtxo8lnLH2OpJ973U5xs9SiC1ZRmiy
BmArBscCLUbPypkDnoiIII9MVEoEVXgfIgGqppW66hcoUndr6UA5Y0BGPi8UsUM6
PWldH7kpCYtUo7K1HBHbEMO+dp7ik9qxUQ9qjC0AlByjyx93P7gFBj+yYqm7j1eQ
0NPAR9H8nvy5U/tOfsOnQVfyTFOHTqPlbYD5ZcHuDcpAK1tIgvP8culO4va3Gh99
jCTSVtZW+vyMVNzgOw0XU2obIVn98GnSMX3v+EtNpr2Hs1vourQoxDPM1W3GUc5B
ZFFobC1T/UP4HEljCla90bwCmJCbXA==
=hxx1
-----END PGP SIGNATURE-----

--xii5Oczx/KGP+C43--

