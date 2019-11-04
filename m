Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F135EDCF4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfKDKy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:54:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727838AbfKDKy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 05:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572864866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SWw/eMGXuF/5dwGNFQvurb0UAzXatryd0Iy+tVUAHU=;
        b=bsnqG2njV8ZHTWazdjEGATfdEgnBFfdGtcus50ivSrh92+1TOa8EoUSSH60GGuAt+atZzI
        mcGSHm1Fa7HIu0dq0RFS+SyJae6n4kv4OeIQ//wYUVQSHWCgyq4HWvVOFsDJriQXC9U6JE
        ixToDNa95CSAPX0Gc3MbEM44pRf60GY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-bjoUjol6OdGh3RHJ7L_ZMw-1; Mon, 04 Nov 2019 05:54:24 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8ADC52AD;
        Mon,  4 Nov 2019 10:54:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C3261001B35;
        Mon,  4 Nov 2019 10:54:19 +0000 (UTC)
Date:   Mon, 4 Nov 2019 11:54:17 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
Message-ID: <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
MIME-Version: 1.0
In-Reply-To: <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: bjoUjol6OdGh3RHJ7L_ZMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 04, 2019 at 11:33:28AM +0100, David Hildenbrand wrote:
> On 04.11.19 11:29, Janosch Frank wrote:
> > Let's test for size and alignment in memalign to catch invalid input
> > data. Also we need to test for NULL after calling the memalign
> > function of the registered alloc operations.
> >=20
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >   lib/alloc.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >=20
> > diff --git a/lib/alloc.c b/lib/alloc.c
> > index ecdbbc4..b763c70 100644
> > --- a/lib/alloc.c
> > +++ b/lib/alloc.c
> > @@ -47,6 +47,8 @@ void *memalign(size_t alignment, size_t size)
> >   =09uintptr_t mem;
> >   =09assert(alloc_ops && alloc_ops->memalign);
> > +=09if (!size || !alignment)
> > +=09=09return NULL;
> >   =09if (alignment <=3D sizeof(uintptr_t))
> >   =09=09alignment =3D sizeof(uintptr_t);
>=20
> BTW, memalign MAN page
>=20
> "EINVAL The alignment argument was not a power of two, or was not a multi=
ple
> of sizeof(void *)."
>=20

Since we're not implementing the EINVAL part, then I'd assert when
alignment isn't correct.

> So we could also return NULL here (not sure if anybody relies on that)

I made the following changes and tested with arm/arm64. No problems.

Thanks,
drew


diff --git a/lib/alloc.c b/lib/alloc.c
index ecdbbc44dbf9..ed8f5f94c9b0 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -46,15 +46,17 @@ void *memalign(size_t alignment, size_t size)
 =09uintptr_t blkalign;
 =09uintptr_t mem;
=20
+=09if (!size)
+=09=09return NULL;
+
+=09assert(alignment >=3D sizeof(void *) && is_power_of_2(alignment));
 =09assert(alloc_ops && alloc_ops->memalign);
-=09if (alignment <=3D sizeof(uintptr_t))
-=09=09alignment =3D sizeof(uintptr_t);
-=09else
-=09=09size +=3D alignment - 1;
=20
+=09size +=3D alignment - 1;
 =09blkalign =3D MAX(alignment, alloc_ops->align_min);
 =09size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
 =09p =3D alloc_ops->memalign(blkalign, size);
+=09assert(p);
=20
 =09/* Leave room for metadata before aligning the result.  */
 =09mem =3D (uintptr_t)p + METADATA_EXTRA;

