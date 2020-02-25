Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969A416EBB2
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgBYQrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:47:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728200AbgBYQrp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 11:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582649263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FZvHNq07Djeurqg+hiW9/ZSen/IsOjQSPpn3Q2Vq17Y=;
        b=CKmO4jPBeBKqe/EjWAl2THxKMbL58c7NvT6I41AAs2BFy8+DJyKC057sIXSmQpnGUiNNAZ
        LN1uJsxj3Q1uEzDAtYU79HBb/DXfV/6mrQzqBfPKT2m/9KeVUlBYjXt9NIWnNiIJ7F9uM6
        3lWKru4eXLkzJEQvmAp1M+v8znEuFzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-iAjubWZEMJ6UkmPZrKWNYg-1; Tue, 25 Feb 2020 11:47:39 -0500
X-MC-Unique: iAjubWZEMJ6UkmPZrKWNYg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E03B800D5A;
        Tue, 25 Feb 2020 16:47:38 +0000 (UTC)
Received: from localhost (unknown [10.36.118.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89DE55D9CD;
        Tue, 25 Feb 2020 16:47:32 +0000 (UTC)
Date:   Tue, 25 Feb 2020 16:47:31 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "slp@redhat.com" <slp@redhat.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        "robert.bradford@intel.com" <robert.bradford@intel.com>,
        Dan Horobeanu <dhr@amazon.com>,
        Stephen Barber <smbarber@chromium.org>,
        Peter Shier <pshier@google.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: Proposal for MMIO/PIO dispatch file descriptors (ioregionfd)
Message-ID: <20200225164731.GE41287@stefanha-x1.localdomain>
References: <20200222201916.GA1763717@stefanha-x1.localdomain>
 <62FEFA1E-0D75-4AFB-860A-59CF5B9B45F7@nutanix.com>
 <72104184-234B-4233-AC9D-3C54B1752F7F@nutanix.com>
MIME-Version: 1.0
In-Reply-To: <72104184-234B-4233-AC9D-3C54B1752F7F@nutanix.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2020 at 12:30:16PM +0000, Felipe Franciosi wrote:
> > On Feb 25, 2020, at 12:19 PM, Felipe Franciosi <felipe@nutanix.com> wro=
te:
> >> /* for ioregionfd_cmd::info */
> >> #define IOREGIONFD_CMD_MASK 0xf
> >> # define IOREGIONFD_CMD_READ 0
> >> # define IOREGIONFD_CMD_WRITE 1
> >=20
> > Why do we need 4 bits for this? I appreciate you want to align the
> > next field, but there's SIZE_SHIFT for that; you could have CMD_MASK
> > set to 0x1 unless I'm missing something. The reserved space could be
> > used for something else in the future.

Yes, it's reserved for future commands.

> >> The byte offset being accessed within that region is addr.
> >=20
> > It's not clear to me if addr is GPA absolute or an offset. Sounds like
> > the latter, in which case isn't it preferable to name this "offset"?

Yes, it's an offset into the region.  "Offset" is clearer, thanks!

Stefan

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5VT6MACgkQnKSrs4Gr
c8jjCggAlCNWqwikeEyvORn4D5YRUiEJEiu1l2ffHhhYW4oICqNfMt9FVlxf+rtU
EBJcMxv3iyHEPWUsUgnD8cnf+YBKzn76pWZCCfClKWBwTIMOtdDaYK/YbXkLkFkb
Lch1x5nVbD8UJcSJfG2o9PYmA4qUp2D0A59/neB/DcqDBshMPKr9ChPVkqa+XPUJ
OMWGZijOBQPBVC54R6MoBfaoaX+wjVxn9G/8VNiB+aXy0Calc94DG/o0Jas3VzYf
yF46x9ufVp7/jrFtNBDAsiyPWoSd1sZtFNrXfN6FSCcnpyZ1bxhRxgGBSmaUsQYQ
82po/e087EZ50Ha5kfTGzGEMdlJa3Q==
=oq/3
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--

