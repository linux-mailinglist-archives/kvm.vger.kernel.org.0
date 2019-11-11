Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64CFF73E9
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKMb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:31:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48460 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726888AbfKKMb1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 07:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573475486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUJWR6Z3AEdMnsXJ7GL09GNXIHuFMFkMcaZl3P+eXM0=;
        b=KOgABjTg6WP4Uskwjv1f8i3d5qw101x1t32QX/U/qkBXDYkaV1awBgEOiX/uThJGoQW4ZA
        9agHiF1jCEb/ORDdqtCXszgtaDbpeeimKNbuKs7gZc7lYVPrq3cTjhiFEpQjF4qryxEEHc
        7Pz0WHuqH6OftTSxEBd/eUvGAyHSXP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-MfvbkEyANrGrP5JBUeYPyg-1; Mon, 11 Nov 2019 07:31:23 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0A6610A04FB;
        Mon, 11 Nov 2019 12:31:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF36D17AD4;
        Mon, 11 Nov 2019 12:31:11 +0000 (UTC)
Date:   Mon, 11 Nov 2019 13:31:09 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] alloc: Add memalign error checks
Message-ID: <20191111123109.mnibzicgsbcvvtth@kamzik.brq.redhat.com>
References: <20191104102916.10554-1-frankja@linux.ibm.com>
 <61db264b-6d29-66bc-ea60-053b5aa8b995@redhat.com>
 <20191104105417.xt2z5gcuk5xqf4bi@kamzik.brq.redhat.com>
 <a91a1828-017a-b0c6-442f-5b31263f3568@redhat.com>
 <4c26975a-84af-e21b-fe40-33197b51fffd@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <4c26975a-84af-e21b-fe40-33197b51fffd@linux.ibm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: MfvbkEyANrGrP5JBUeYPyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 11:12:41AM +0100, Janosch Frank wrote:
> On 11/4/19 12:29 PM, Paolo Bonzini wrote:
> > On 04/11/19 11:54, Andrew Jones wrote:
> >>
> >> diff --git a/lib/alloc.c b/lib/alloc.c
> >> index ecdbbc44dbf9..ed8f5f94c9b0 100644
> >> --- a/lib/alloc.c
> >> +++ b/lib/alloc.c
> >> @@ -46,15 +46,17 @@ void *memalign(size_t alignment, size_t size)
> >>  =09uintptr_t blkalign;
> >>  =09uintptr_t mem;
> >> =20
> >> +=09if (!size)
> >> +=09=09return NULL;
> >> +
> >> +=09assert(alignment >=3D sizeof(void *) && is_power_of_2(alignment));
> >>  =09assert(alloc_ops && alloc_ops->memalign);
> >> -=09if (alignment <=3D sizeof(uintptr_t))
> >> -=09=09alignment =3D sizeof(uintptr_t);
> >> -=09else
> >> -=09=09size +=3D alignment - 1;
> >> =20
> >> +=09size +=3D alignment - 1;
> >>  =09blkalign =3D MAX(alignment, alloc_ops->align_min);
> >>  =09size =3D ALIGN(size + METADATA_EXTRA, alloc_ops->align_min);
> >>  =09p =3D alloc_ops->memalign(blkalign, size);
> >> +=09assert(p);
>=20
> I had some more time to think about and test this and I think returning
> NULL here is more useful. My usecase is a limit test where I allocate
> until I get a NULL and then free everything afterwards.

I think I prefer the assert here, since most users of this will not be
expecting to run out of memory, and therefore not checking for it. I
think you may want to just write your own allocator in your unit test
that's based on alloc_pages().

Thanks,
drew

