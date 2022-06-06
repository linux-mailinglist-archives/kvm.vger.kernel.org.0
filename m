Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F288353EB76
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240150AbiFFO55 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 10:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbiFFO5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 10:57:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 072D12FE61A
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 07:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654527473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=oEg/BxrxwpIVrTIgkNOexZzCDMRvekqGaXNned4YxC8=;
        b=a3h6T0XrFJFRTpBSeHHtk2MdtC74VzEMjUKQ4llOHyGw7u/KerHVG0u780I2RjAh+viu5L
        V2Fst/70VSKmCgcNnSN5Z5/dt4xrjwW5YavnquNdjcReIx//OBOJJjqK2GEvBzVgaLC1Qk
        9P9TA5wVGQ2Ta32LPJ6Ej3Kb0pn5tr8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-CxbHyxR_P92L9-eFDrIRXg-1; Mon, 06 Jun 2022 10:57:50 -0400
X-MC-Unique: CxbHyxR_P92L9-eFDrIRXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 806A929ABA35;
        Mon,  6 Jun 2022 14:57:49 +0000 (UTC)
Received: from localhost (unknown [10.39.193.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F36CA2026D64;
        Mon,  6 Jun 2022 14:57:48 +0000 (UTC)
Date:   Mon, 6 Jun 2022 15:57:47 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Elena Ufimtseva <elena.ufimtseva@oracle.com>
Cc:     qemu-devel@nongnu.org, jag.raman@oracle.com,
        john.g.johnson@oracle.com, john.levon@nutanix.com, mst@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
Subject: ioregionfd with io_uring IORING_OP_URING_CMD
Message-ID: <Yp4V61lfTTN3QsT4@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NmJ6ra3KB8tnU5hE"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NmJ6ra3KB8tnU5hE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
During Elena Afanasova's Outreachy project we discussed whether
ioregionfd should be a custom struct file_operations (anon inode) or a
userspace-provided file (socketpair, UNIX domain socket, etc).

Back then it seemed more flexible and simpler to let userspace provide
the file. It may be worth revisiting this decision in light of the
recent io_uring IORING_OP_URING_CMD feature, which fits for this
performance-critical interface.

IORING_OP_URING_CMD involves a new struct file_operations->uring_cmd()
callback. It's a flexible userspace interface like ioctl(2) but designed
to be asynchronous. ioregionfd can provide a uring_cmd() that reads a
ioregionfd response from userspace and then writes the next ioregionfd
request to userspace.

This single operation merges the request/response so only 1 syscall is
necessary per KVM MMIO/PIO exit instead of a read() + write(). Bypassing
the net/socket infrastructure is likely to help too.

It would be interesting to benchmark this and compare it against the
existing userspace-provided file approach. Although it's not the same
scenario, results for the Linux NVMe driver using ->uring_cmd() are
promising:
https://www.snia.org/educational-library/enabling-asynchronous-i-o-passthru-nvme-native-applications-2021

The downside is it requires more code than general purpose I/O. In
addition to ->uring_cmd(), it's also worth implementing struct
file_operations read/write/poll so traditional file I/O syscalls work
for simple applications that don't want to use io_uring.

It's possible to add ->uring_cmd() later but as a userspace developer I
would prefer the ->uring_cmd() approach, so I'm not sure it's worth
committing to the existing userspace-provided file approach?

Stefan

--NmJ6ra3KB8tnU5hE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmKeFesACgkQnKSrs4Gr
c8hW6gf6Ax8Kb1dAPiFcem5nK7bYZToPIS5yL03lRrOaVh6bIxS28nct3RZM9Z7v
RhlJfDY8xSFQdlocOZVeKJjUMu34RyDCi26BbBKjUgvbFHDsGvIi0gje/43VUQuI
CNVE/GLA0s6q0DUMY+Dl9h+v0tttVMaKJA9aGAbOuSAhRMidg1WvmBdVW7ZBmtsz
FmZrretiXj8jBUl+kdfUSnHJJWLJz3y9RfOHIwYOH7bKzZyJxOSqcXo1zKm3OXO9
WKCgl6jGrL1laYdpjZGPdFLewLav9yr1kdr823vfnDT/f9jcD/liHzvSF8NmmIGa
GcUS4sPyc6XaRQU1GI9G9+RVe+3cZw==
=hUCX
-----END PGP SIGNATURE-----

--NmJ6ra3KB8tnU5hE--

