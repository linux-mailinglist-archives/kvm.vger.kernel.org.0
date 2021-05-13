Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753DA37FB76
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 18:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhEMQ3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 12:29:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235171AbhEMQ3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 12:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620923277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tuYp5/3obltv5r7eq8xKVUNYQlDv3pda6zIjqU9HN2U=;
        b=H+PL5U//NXLpnpo9Egg8S9xSfIzAVgJ+HVIRnXWXE0VXzXF0qlW3KaMXTcBsoYtgI1xon1
        Mr/v6TqaGzJ+QabkDr6U2ZZSnEaalQWyED0R+tKcznKOxTWo/3Nl5kUalZESuZy9MKDHta
        efGI2Q7ft6PtKfQL0ICJlDR3VIDWwCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-YOsAi3fFNcaukYidOwfrtQ-1; Thu, 13 May 2021 12:27:53 -0400
X-MC-Unique: YOsAi3fFNcaukYidOwfrtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A08701922035;
        Thu, 13 May 2021 16:27:51 +0000 (UTC)
Received: from localhost (ovpn-113-21.ams2.redhat.com [10.36.113.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1324C17264;
        Thu, 13 May 2021 16:27:46 +0000 (UTC)
Date:   Thu, 13 May 2021 17:27:46 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
References: <20210423080942.2997-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kSjLBUWR7rqI1Fnp"
Content-Disposition: inline
In-Reply-To: <20210423080942.2997-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--kSjLBUWR7rqI1Fnp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> Sometimes, the driver doesn't trust the device. This is usually
> happens for the encrtpyed VM or VDUSE[1].

Thanks for doing this.

Can you describe the overall memory safety model that virtio drivers
must follow? For example:

- Driver-to-device buffers must be on dedicated pages to avoid
  information leaks.

- Driver-to-device buffers must be on dedicated pages to avoid memory
  corruption.

When I say "pages" I guess it's the IOMMU page size that matters?

What is the memory access granularity of VDUSE?

I'm asking these questions because there is driver code that exposes
kernel memory to the device and I'm not sure it's safe. For example:

  static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr,
                  struct scatterlist *data_sg, bool have_data)
  {
          struct scatterlist hdr, status, *sgs[3];
          unsigned int num_out = 0, num_in = 0;

          sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
	                    ^^^^^^^^^^^^^
          sgs[num_out++] = &hdr;

          if (have_data) {
                  if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIRTIO_BLK_T_OUT))
                          sgs[num_out++] = data_sg;
                  else
                          sgs[num_out + num_in++] = data_sg;
          }

          sg_init_one(&status, &vbr->status, sizeof(vbr->status));
                               ^^^^^^^^^^^^
          sgs[num_out + num_in++] = &status;

          return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
  }

I guess the drivers don't need to be modified as long as swiotlb is used
to bounce the buffers through "insecure" memory so that the memory
surrounding the buffers is not exposed?

Stefan

--kSjLBUWR7rqI1Fnp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCdU4EACgkQnKSrs4Gr
c8jIXQf/bDxDNATkynJc8tGJ7x7Bp5ZiiG3XuUvb5LEsvtzjs+2kmYIZyhESbHN6
pasUhocXLHhIiBmRf5XAHiSbQI+cdOgjgf/Owykd4xM5esusvzNOQy8I8oUCrbX/
yxPI+spnxLyM3U7f7He68vjS86KPn/5pvwbXiRNfFF9KPjk6qE7w+daSgZLOh/NP
BafdMFIW1E7csCnTPZjqEr2gw8WqHAAwD6vd2dkytBkoGfL1UHT4OwUpP1Ig5Vmb
ytJDZ/tx+mG2JVfBfzXAj0n1FOXosho5Md9BcUPMNw1yqwwzJrmzfg22wdJacPzQ
D+K0W3qs/r3YDv++4i/cJa96khB/ng==
=T94O
-----END PGP SIGNATURE-----

--kSjLBUWR7rqI1Fnp--

