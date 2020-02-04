Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47523151A68
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 13:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgBDMPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 07:15:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727148AbgBDMPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 07:15:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580818548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TvRK8kEp1SmaxM3YmINNDBwX6PAtetF0n269SuEbDuo=;
        b=caKDSpZEiQ56EwB7tjIXWWy1exrjsv52OLaRWkbopUZMRZ/i8LXOOZSY88chEk3plmcDLJ
        XUyHt6LNntTja1m0xpGQ0+vU4/lOh9TNgtDO0rD/uyfDOZoGDxZOLgEecH7/BoBZ+YCSZa
        iU65mj+4nDACbG9O+mmhm++rwEhop90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-kmgLvvr_O7qR6kaNY0U56Q-1; Tue, 04 Feb 2020 07:15:46 -0500
X-MC-Unique: kmgLvvr_O7qR6kaNY0U56Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE531DB2F;
        Tue,  4 Feb 2020 12:15:44 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 090708CCE0;
        Tue,  4 Feb 2020 12:15:39 +0000 (UTC)
Date:   Tue, 4 Feb 2020 13:15:37 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 05/37] s390/mm: provide memory management functions for
 protected KVM guests
Message-ID: <20200204131537.3ec82487.cohuck@redhat.com>
In-Reply-To: <e2d208d0-e34c-c3d6-0c1b-57ee9a0c8458@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-6-borntraeger@de.ibm.com>
        <20200204115738.3336787a.cohuck@redhat.com>
        <e2d208d0-e34c-c3d6-0c1b-57ee9a0c8458@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Feb 2020 12:56:10 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 04.02.20 11:57, Cornelia Huck wrote:
>=20
> >> =20
> >>  /* Generic bits for GMAP notification on DAT table entry changes. */
> >> @@ -61,6 +62,7 @@ struct gmap {
> >>  	spinlock_t shadow_lock;
> >>  	struct gmap *parent;
> >>  	unsigned long orig_asce;
> >> +	unsigned long se_handle; =20
> >=20
> > This is a deviation from the "protected virtualization" naming scheme
> > used in the previous patches, but I understand that the naming of this
> > whole feature is still in flux :) (Would still be nice to have it
> > consistent, though.)
> >=20
> > However, I think I'd prefer something named based on protected
> > virtualization: the se_* stuff here just tends to make me think of
> > SELinux... =20
>=20
> I will just use guest_handle as this guests assigned to and from such:
>=20
> arch/s390/include/asm/gmap.h:   unsigned long se_handle;
> arch/s390/include/asm/uv.h:             .guest_handle =3D gmap->se_handle,
> arch/s390/kvm/pv.c:     WRITE_ONCE(kvm->arch.gmap->se_handle, 0);
> arch/s390/kvm/pv.c:     kvm->arch.gmap->se_handle =3D uvcb.guest_handle;
> arch/s390/mm/fault.c:           .guest_handle =3D gmap->se_handle,

Even better.

>=20
>=20
> >  =20
> >>  	int edat_level;
> >>  	bool removed;
> >>  	bool initialized;
> >> diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
> >> index bcfb6371086f..984026cb3608 100644
> >> --- a/arch/s390/include/asm/mmu.h
> >> +++ b/arch/s390/include/asm/mmu.h
> >> @@ -16,6 +16,8 @@ typedef struct {
> >>  	unsigned long asce;
> >>  	unsigned long asce_limit;
> >>  	unsigned long vdso_base;
> >> +	/* The mmu context belongs to a secure guest. */
> >> +	atomic_t is_se; =20
> >=20
> > Here as well. =20
>=20
> I will use is "is_protected"

ok

> >  =20
> >>  	/*
> >>  	 * The following bitfields need a down_write on the mm
> >>  	 * semaphore when they are written to. As they are only =20
> >=20
> > (...)
> >  =20
> >> @@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct mm_struct *=
mm)
> >>  	return 0;
> >>  }
> >> =20
> >> +static inline int mm_is_se(struct mm_struct *mm)
> >> +{
> >> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> >> +	if (unlikely(atomic_read(&mm->context.is_se)))
> >> +		return 1;
> >> +#endif
> >> +	return 0;
> >> +} =20
> >=20
> > I'm wondering how big of an overhead we actually have because we need
> > to check the flag here if the feature is enabled. We have an extra
> > check in a few functions anyway, even if protected virt is not
> > configured in. Given that distributions would likely want to enable the
> > feature in their kernels, I'm currently tending towards dropping the
> > extra config option. =20
>=20
> Makes sense. I will wait a bit more but if you do not disagree I will rem=
ove=20
> the extra host config and bind things to CONFIG_KVM or CONFIG_PGSTE depen=
ding
> on context

=46rom the code I read so far, that makes sense.

