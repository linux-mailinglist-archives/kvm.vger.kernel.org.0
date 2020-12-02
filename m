Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB42CBFD5
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgLBOff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:35:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726158AbgLBOff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 09:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606919649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EkevmCLQ1GX33E9KXRD3p8BSpTHh3E7pEzchj2FWow=;
        b=JAx6xKFZoZEt3NcuajqKWZn8HtNlrhOzg5+pVIevKGhstpaDzDNx7C9L3/UVPrFhsVDOVb
        aKW+yz/vhyOeDJdzeSOqmkk4sUq0lpn0n++nzr+EWoOx+cPgPUH3eNdtaIxk3x6hIW/Sfv
        3PG1TY+RhHUZfpdXodKgi7yf1FMibQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-OXLcuBxbOca-YDdOQG16zw-1; Wed, 02 Dec 2020 09:34:06 -0500
X-MC-Unique: OXLcuBxbOca-YDdOQG16zw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95C91100E324;
        Wed,  2 Dec 2020 14:34:05 +0000 (UTC)
Received: from localhost (ovpn-114-255.ams2.redhat.com [10.36.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B72D5C1D0;
        Wed,  2 Dec 2020 14:33:57 +0000 (UTC)
Date:   Wed, 2 Dec 2020 14:33:56 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201202143356.GK655829@stefanha-x1.localdomain>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
MIME-Version: 1.0
In-Reply-To: <20201125155711.GA6489@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qDymnuGqqhW10CwH"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--qDymnuGqqhW10CwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:
> On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:
> > > I'd appreciate if you could explain why vfio needs to dma map some
> > > PROT_NONE
> >=20
> > Virtiofs will map a PROT_NONE cache window region firstly, then remap t=
he sub
> > region of that cache window with read or write permission. I guess this=
 might
> > be an security concern. Just CC virtiofs expert Stefan to answer it mor=
e accurately.
>=20
> Yep.  Since my previous sentence was cut off, I'll rephrase: I was thinki=
ng
> whether qemu can do vfio maps only until it remaps the PROT_NONE regions =
into
> PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon PROT_=
NONE.

Userspace processes sometimes use PROT_NONE to reserve virtual address
space. That way future mmap(NULL, ...) calls will not accidentally
allocate an address from the reserved range.

virtio-fs needs to do this because the DAX window mappings change at
runtime. Initially the entire DAX window is just reserved using
PROT_NONE. When it's time to mmap a portion of a file into the DAX
window an mmap(fixed_addr, ...) call will be made.

Stefan

--qDymnuGqqhW10CwH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/HpdQACgkQnKSrs4Gr
c8gPrggAonKj8u861YBXdwmd9ewmkx/VVa0WqmIb9BHstu+ZJU4vEPWSCLs6Ztk3
JlIeWhuwfvHWLRcEL7iki0ON0jgsV4076axu8aFvl0NsKWQk2TTIA3VwUiWh76Li
Qy18X6LEEaR6UAJVgp1mQTG8oQzYQwvirdJSwWUSydq0SmhXPNHFeuRGxmmtcTIR
9JzPk8VIqzddHqEnAHcFUTCE40830cm4oaSq1nesTpqwkuv9nx0tBmE4xj26TONM
pTEHitIJKZIgxh6ZeDDAizwiRZp4l6DMuEb0vxiNsrBaddhe5sIoa7DwGgiXn0Ps
ImXZKCwuxOieIb+HAIyjmwe3fIjctQ==
=P7/h
-----END PGP SIGNATURE-----

--qDymnuGqqhW10CwH--

