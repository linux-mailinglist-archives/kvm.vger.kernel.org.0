Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226D629FF13
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 08:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJ3Hux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 03:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgJ3Hux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 03:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604044251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nnyV6U2LzEaiS5MFaLvH7gk9T2CEit3FqFKfvdnfNXw=;
        b=ReIFeBIj0eyLYkiGkAz3mPZq4l5/5K21mCdFiOp5ONuacRfdE8b2y4d/6LNfKGcIWzNjwA
        bW/52ogzEsM/Wh2WpkXPTYLQyL1BuRMDVbUjDyxQXZefOj5SEZi/9LHrbzZIXIdMgIl6iB
        oUzYL7oHkgE86uWJwAz8gGA3asOBdZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-dShenltaMHK7QgdCTee-qA-1; Fri, 30 Oct 2020 03:50:48 -0400
X-MC-Unique: dShenltaMHK7QgdCTee-qA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 935486D581;
        Fri, 30 Oct 2020 07:50:47 +0000 (UTC)
Received: from localhost (ovpn-113-41.ams2.redhat.com [10.36.113.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35BB855761;
        Fri, 30 Oct 2020 07:50:46 +0000 (UTC)
Date:   Fri, 30 Oct 2020 07:50:46 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     hao.wu@intel.com
Cc:     kevin.tian@intel.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: ENQCMD
Message-ID: <20201030075046.GA307361@stefanha-x1.localdomain>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
The "Scalable Work Submission in Device Virtualization" talk at KVM
Forum 2020 was interesting and I have some beginner questions about
ENQCMD:
https://static.sched.com/hosted_files/kvmforum2020/22/Scalable_Work_Submission_In_Device_Virtualization.pdf

Security
--------
If the ENQCMD instruction is allowed for userspace applications, how can
they be prevented from writing to the MMIO address directly (without the
ENQCMD instruction) and faking the 64-byte enqueue register data format?
For example, they could set the PRIV bit or an arbitrary PASID.

Work Queue Design
-----------------
Have you looked at extending existing hardware interfaces like NVMe or
VIRTIO to support enqueue registers?

Have you benchmarked NVMe or VIRTIO devices using ENQCMD instead of
the traditional submission queuing mechanism?

Is ENQCMD faster than traditional I/O request submission? If not, then I
guess it's only intended for shared queues where the PASID translation
is needed?

A few thoughts come to mind:

 * Traditional submission queues are no longer needed and can be
   replaced by an enqueue register. NVMe sqs and VIRTIO avail rings
   aren't needed anymore, although the sqes and vring descriptors are
   still needed to represent commands and buffers.

   Or the enqueue register can be used simply as a doorbell to start DMA
   reading requests from a traditional submission queue. In this case
   the advantage is that a single shared hardware unit (ADI) can emulate
   multiple queues at the same time.

 * In order to support submitting multiple requests in a single enqueue
   register access there needs to be some kind of chaining mechanism.
   For example, the Device Specific Command field contains a num_reqs
   field telling the device how many requests to DMA.

I don't know much about ENQCMD and am trying to figure out where it fits
in. Please let me know if this matches how this feature is intended to
be used.

Thanks,
Stefan

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+bxdYACgkQnKSrs4Gr
c8iPYwf/ZjOUVGQQz4TZmbc4n+G6uPHONhvDQPA24rQNQ1uOtao0JrmwNqM9y4YQ
jOrbuyY+Ne+ElupVu5oaHUIcJkzqCCuxR5iPCVno/qUPiL64tq67yMwhEXwQ93+I
pKnK9Jm5aZLNFP/VK9QAJxnZTj/r8jZDunjFxQyd1EV4y3BqBNJxmg8XqOEW9PVA
8zdOdl89z1VB6lKCAvaFslU+nWW4UAjs6af9rgqYp1r/EHh2c+LcsxibvwX56f2i
33YRwE40dsDm1UgW0w9OiqCw+RvqUf4GU45oE4/aA7M1PCoL6US6zrAfUtFx9ize
z1nEmiGy4tdfcgjgVihOo2Bc89jJ1w==
=+rfy
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--

