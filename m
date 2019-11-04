Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B78EE239
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 15:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfKDO0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 09:26:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27016 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728174AbfKDO0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 09:26:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572877574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0DiESlwZgBm6fWmLVtTDj9kuHuRgmqLGNudx4+qR6w=;
        b=EJEghfwTeR6RvrDj3JuyBg2njmw3ftS5iZ6n7SVJizphcyMh5fpWkuBBsmwdklx+sTjjpS
        kICaGOH88HBhihqg4NYmUBgcF+I0f+bPbrW8eOWVmCJED/EutQO0ZeAQH693Qi8sdv3zwX
        2ra5yIo0hx1UpL29BCWB6jRsmEgJiCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-w0Hzz0ZMPBuFlwEMUBiv_Q-1; Mon, 04 Nov 2019 09:26:11 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8A6C8017DD;
        Mon,  4 Nov 2019 14:26:09 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D9D360C88;
        Mon,  4 Nov 2019 14:26:05 +0000 (UTC)
Date:   Mon, 4 Nov 2019 15:26:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        gor@linux.ibm.com
Subject: Re: [RFC 02/37] s390/protvirt: introduce host side setup
Message-ID: <20191104152603.76f50c60.cohuck@redhat.com>
In-Reply-To: <41fb411d-68b5-96be-fc0e-c88570df9d19@de.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-3-frankja@linux.ibm.com>
        <41fb411d-68b5-96be-fc0e-c88570df9d19@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: w0Hzz0ZMPBuFlwEMUBiv_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Nov 2019 09:53:12 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 24.10.19 13:40, Janosch Frank wrote:
> > From: Vasily Gorbik <gor@linux.ibm.com>
> >=20
> > Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> > protected virtual machines hosting support code.
> >=20
> > Add "prot_virt" command line option which controls if the kernel
> > protected VMs support is enabled at runtime.
> >=20
> > Extend ultravisor info definitions and expose it via uv_info struct
> > filled in during startup.
> >=20
> > Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> > ---
> >  .../admin-guide/kernel-parameters.txt         |  5 ++
> >  arch/s390/boot/Makefile                       |  2 +-
> >  arch/s390/boot/uv.c                           | 20 +++++++-
> >  arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
> >  arch/s390/kernel/Makefile                     |  1 +
> >  arch/s390/kernel/setup.c                      |  4 --
> >  arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
> >  arch/s390/kvm/Kconfig                         |  9 ++++
> >  8 files changed, 126 insertions(+), 9 deletions(-)
> >  create mode 100644 arch/s390/kernel/uv.c

(...)

> > diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> > index d3db3d7ed077..652b36f0efca 100644
> > --- a/arch/s390/kvm/Kconfig
> > +++ b/arch/s390/kvm/Kconfig
> > @@ -55,6 +55,15 @@ config KVM_S390_UCONTROL
> >=20
> >  =09  If unsure, say N.
> >=20
> > +config KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> > +=09bool "Protected guests execution support"
> > +=09depends on KVM
> > +=09---help---
> > +=09  Support hosting protected virtual machines isolated from the
> > +=09  hypervisor.
> > +
> > +=09  If unsure, say Y.
> > +
> >  # OK, it's a little counter-intuitive to do this, but it puts it neatl=
y under
> >  # the virtualization menu.
> >  source "drivers/vhost/Kconfig"
> >  =20
>=20
> As we have the prot_virt kernel paramter there is a way to fence this dur=
ing runtime
> Not sure if we really need a build time fence. We could get rid of
> CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST and just use CONFIG_KVM ins=
tead,
> assuming that in the long run all distros will enable that anyway.=20

I still need to read through the rest of this patch set to have an
informed opinion on that, which will probably take some more time.

> If other reviewers prefer to keep that extra option what about the follow=
ing to the
> help section:
>=20
> ----
> Support hosting protected virtual machines in KVM. The state of these mac=
hines like
> memory content or register content is protected from the host or host adm=
inistrators.
>=20
> Enabling this option will enable extra code that talks to a new firmware =
instance

"...that allows the host kernel to talk..." ?

> called ultravisor that will take care of protecting the guest while also =
enabling
> KVM to run this guest.
>=20
> This feature must be enable by the kernel command line option prot_virt.

s/enable by/enabled via/

>=20
> =09  If unsure, say Y.

Looks better. I'm continuing to read the rest of this series before I
say more, though :)

