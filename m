Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284F61ABBDE
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 10:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503079AbgDPI53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 04:57:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2502930AbgDPIvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 04:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587027050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBOSp8KoaqgQUXlL6khiQxh82SbQfD3UXPaPxlc3NpI=;
        b=JAQRTtIb9MklA6zamJlBfju/xzHtp14oFToK19198GX7xuVp7z1WJpNHDGdLoMznfe+HVl
        7GGx2kjonqChQ986T202VDIDQb/NQsEp+303wHAFPfiwQeJFTsN5dz66z2jOC1j+M+k3HP
        XRWMfkpxOk86swM4WLJ70xkxUW4RzgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-MuypNbuHM0uD0I3hVYYtuw-1; Thu, 16 Apr 2020 04:50:46 -0400
X-MC-Unique: MuypNbuHM0uD0I3hVYYtuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 994A818C35A6;
        Thu, 16 Apr 2020 08:50:42 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 330E27E7C4;
        Thu, 16 Apr 2020 08:50:22 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:50:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
Message-ID: <20200416105019.51191d79.cohuck@redhat.com>
In-Reply-To: <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
        <878sivx67g.fsf@vitty.brq.redhat.com>
        <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
        <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 16:45:33 +0800
Tianjia Zhang <tianjia.zhang@linux.alibaba.com> wrote:

> On 2020/4/16 16:28, Marc Zyngier wrote:
> > On 2020-04-16 08:03, Vitaly Kuznetsov wrote: =20
> >> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
> >> =20
> >>> In earlier versions of kvm, 'kvm_run' is an independent structure
> >>> and is not included in the vcpu structure. At present, 'kvm_run'
> >>> is already included in the vcpu structure, so the parameter
> >>> 'kvm_run' is redundant.
> >>>
> >>> This patch simplify the function definition, removes the extra
> >>> 'kvm_run' parameter, and extract it from the 'kvm_vcpu' structure
> >>> if necessary.
> >>>
> >>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> >>> ---
> >>>
> >>> v2 change:
> >>> =C2=A0 remove 'kvm_run' parameter and extract it from 'kvm_vcpu'
> >>>
> >>> =C2=A0arch/mips/kvm/mips.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 3 ++-
> >>> =C2=A0arch/powerpc/kvm/powerpc.c |=C2=A0 3 ++-
> >>> =C2=A0arch/s390/kvm/kvm-s390.c=C2=A0=C2=A0 |=C2=A0 3 ++-
> >>> =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 11 ++++++-----
> >>> =C2=A0include/linux/kvm_host.h=C2=A0=C2=A0 |=C2=A0 2 +-
> >>> =C2=A0virt/kvm/arm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 6 +++---
> >>> =C2=A0virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 +-
> >>> =C2=A07 files changed, 17 insertions(+), 13 deletions(-)

> > Overall, there is a large set of cleanups to be done when both the vcpu=
=20
> > and the run
> > structures are passed as parameters at the same time. Just grepping the=
=20
> > tree for
> > kvm_run is pretty instructive.
> >=20
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 M. =20
>=20
> Sorry, it's my mistake, I only compiled the x86 platform, I will submit=20
> patch again.

I think it's completely fine (and even preferable) to do cleanups like
that on top.

[FWIW, I compiled s390 here.]

