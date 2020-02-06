Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3752154011
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 09:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBFIXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 03:23:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726673AbgBFIXr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 03:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580977426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zE/0umiDG6aHdnQ/nah3OJItmeTUm4mCLCMjaiSPlGo=;
        b=JA0EswtoWdc/Cdw5Xvfg9o8226ZTRZncYRTXsLHBaUMIjrQtgwqC8TJAY96MI+32tq9ZwI
        oF4XURodDBZj7fG15k5Mb2bMRxIotZ+N4qJXLDAjZb5vg17TvbHIN0vsGrmoLpaIwvCJuZ
        VTrRdgjHMBWKtxbJVhK03GsT+PaBJpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-9ZbonbHvPwaSSTn9KHLnvw-1; Thu, 06 Feb 2020 03:23:42 -0500
X-MC-Unique: 9ZbonbHvPwaSSTn9KHLnvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B6011081FA1;
        Thu,  6 Feb 2020 08:23:41 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0125F89A7A;
        Thu,  6 Feb 2020 08:23:36 +0000 (UTC)
Date:   Thu, 6 Feb 2020 09:23:34 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     mimu@linux.ibm.com, Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
Message-ID: <20200206092334.0c5e01c9.cohuck@redhat.com>
In-Reply-To: <dd426775-9666-a702-459c-429f1db8711b@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-16-borntraeger@de.ibm.com>
        <20200205123133.34ac71a2.cohuck@redhat.com>
        <512413a4-196e-5acb-9583-561c061e40ee@linux.ibm.com>
        <20200205131146.611a0d78.cohuck@redhat.com>
        <d5878d81-38c5-3147-0da4-573e56610c9c@linux.ibm.com>
        <dd426775-9666-a702-459c-429f1db8711b@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 19:00:47 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.02.20 13:26, Michael Mueller wrote:
> >=20
> >=20
> > On 05.02.20 13:11, Cornelia Huck wrote: =20
> >> On Wed, 5 Feb 2020 12:46:39 +0100
> >> Michael Mueller <mimu@linux.ibm.com> wrote:
> >> =20
> >>> On 05.02.20 12:31, Cornelia Huck wrote: =20
> >>>> On Mon,=C2=A0 3 Feb 2020 08:19:35 -0500
> >>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>>> =C2=A0=C2=A0 =20
> >>>>> From: Michael Mueller <mimu@linux.ibm.com>
> >>>>>
> >>>>> The patch implements interruption injection for the following
> >>>>> list of interruption types:
> >>>>>
> >>>>> =C2=A0=C2=A0=C2=A0 - I/O
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_io (III)
> >>>>>
> >>>>> =C2=A0=C2=A0=C2=A0 - External
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_cpu_timer (IEI)
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_ckc (IEI)
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_emergency_signal (IEI)
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_external_call (IEI)
> >>>>>
> >>>>> =C2=A0=C2=A0=C2=A0 - cpu restart
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __deliver_restart (IRI) =20
> >>>>
> >>>> Hm... what do 'III', 'IEI', and 'IRI' stand for? =20
> >>>
> >>> that's the kind of interruption injection being used:
> >>>
> >>> inject io interruption
> >>> inject external interruption
> >>> inject restart interruption =20
> >>
> >> So, maybe make this:
> >>
> >> - I/O (uses inject io interruption)
> >> =C2=A0=C2=A0 __ deliver_io
> >>
> >> - External (uses inject external interruption)
> >> (and so on)
> >>
> >> I find using the acronyms without explanation very confusing. =20
> >=20
> > Make a guess from where they are coming...
> >=20
> > Christian, would you please update the description accordingly.
> >=20
> >=20
> > =C2=A0 - I/O (uses inject io interruption)
> > =C2=A0=C2=A0=C2=A0 __deliver_io
> >=20
> > =C2=A0 - External (uses inject external interruption)
> > =C2=A0=C2=A0=C2=A0 __deliver_cpu_timer
> > =C2=A0=C2=A0=C2=A0 __deliver_ckc
> > =C2=A0=C2=A0=C2=A0 __deliver_emergency_signal
> > =C2=A0=C2=A0=C2=A0 __deliver_external_call
> >=20
> > =C2=A0 - cpu restart (uses inject restart interruption)
> > =C2=A0=C2=A0=C2=A0 __deliver_restart =20
>=20
> Will use that and also add.
> Please note that posted interrupts (GISA) are not used for protected gues=
ts as of today.

Thanks, that makes it more clear.

>=20
> >=20
> > thanks
> >=20
> > Michael
> >  =20
> >> =20
> >>> =20
> >>>> =C2=A0=C2=A0 =20
> >>>>>
> >>>>> The service interrupt is handled in a followup patch.
> >>>>>
> >>>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> >>>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>>> [fixes]
> >>>>> ---
> >>>>> =C2=A0=C2=A0 arch/s390/include/asm/kvm_host.h |=C2=A0 8 +++
> >>>>> =C2=A0=C2=A0 arch/s390/kvm/interrupt.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 93 ++++++++++++++++++++++----------
> >>>>> =C2=A0=C2=A0 2 files changed, 74 insertions(+), 27 deletions(-) =20
> >> =20
> >  =20
>=20

