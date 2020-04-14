Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAD71A7EA7
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbgDNNn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 09:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732736AbgDNNnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 09:43:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A3320644;
        Tue, 14 Apr 2020 13:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586871796;
        bh=3koUbGe2LBHalbakeLDQom7EXe+LBTn/mZU+H8wy818=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wvTuJ2KvMEs7RpYKRjMqdZ7Noxqbzu3FUz84V073BNWMVq4DecOZ7bcI5eY7Vk3os
         UeYuUradQiVbk4CiVsGslmtxQBXxWNaJ74F/n0jD7EObUMUgymqHhHdC2jwmmnxKuS
         Bd8vCxQYxboemoA0+5ye6cxU6zTkDdzw7K0EVOAA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jOLqM-003Abw-Jl; Tue, 14 Apr 2020 14:43:14 +0100
Date:   Tue, 14 Apr 2020 14:43:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     =?UTF-8?Q?Andr=C3=A9?= Przywara <andre.przywara@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm: vgic: Synchronize the whole guest on
 GIC{D,R}_I{S,C}ACTIVER read
Message-ID: <20200414144313.1f9645cd@why>
In-Reply-To: <fddef0b7-3db7-89aa-5aac-4f08380ed00d@arm.com>
References: <20200414103517.2824071-1-maz@kernel.org>
        <20200414103517.2824071-2-maz@kernel.org>
        <fddef0b7-3db7-89aa-5aac-4f08380ed00d@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, julien@xen.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Apr 2020 12:16:27 +0100
Andr=C3=A9 Przywara <andre.przywara@arm.com> wrote:

> On 14/04/2020 11:35, Marc Zyngier wrote:
> > When a guest tries to read the active state of its interrupts,
> > we currently just return whatever state we have in memory. This
> > means that if such an interrupt lives in a List Register on another
> > CPU, we fail to obsertve the latest active state for this interrupt. =20
>=20
>                   ^^^^^^^^
>=20
> > In order to remedy this, stop all the other vcpus so that they exit
> > and we can observe the most recent value for the state. =20
>=20
> Maybe worth mentioning that this copies the approach we already deal
> with write accesses (split userland and guess accessors). This is in the
> cover letter, but until I found it there it took me a while to grasp
> what this patch really does.

Fair enough.

>=20
> >=20
> > Reported-by: Julien Grall <julien@xen.org>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
> >  virt/kvm/arm/vgic/vgic-mmio-v3.c |   4 +-
> >  virt/kvm/arm/vgic/vgic-mmio.c    | 100 ++++++++++++++++++++-----------
> >  virt/kvm/arm/vgic/vgic-mmio.h    |   3 +
> >  4 files changed, 71 insertions(+), 40 deletions(-)
> >=20
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-=
mmio-v2.c
> > index 5945f062d749..d63881f60e1a 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -422,11 +422,11 @@ static const struct vgic_register_region vgic_v2_=
dist_registers[] =3D {
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
> >  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> > -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> > +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
> >  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> > -		NULL, vgic_mmio_uaccess_write_cactive, 1,
> > +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive, 1,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> >  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-=
mmio-v3.c
> > index e72dcc454247..77c8ba1a2535 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > @@ -553,11 +553,11 @@ static const struct vgic_register_region vgic_v3_=
dist_registers[] =3D {
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
> >  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> > -		NULL, vgic_mmio_uaccess_write_sactive, 1,
> > +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_sactive, 1,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
> >  		vgic_mmio_read_active, vgic_mmio_write_cactive,
> > -		NULL, vgic_mmio_uaccess_write_cactive,
> > +		vgic_uaccess_read_active, vgic_mmio_uaccess_write_cactive,
> >  		1, VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
> >  		vgic_mmio_read_priority, vgic_mmio_write_priority, NULL, NULL,
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmi=
o.c
> > index 2199302597fa..4012cd68ac93 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -348,8 +348,39 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcp=
u,
> >  	}
> >  }
> > =20
> > -unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> > -				    gpa_t addr, unsigned int len)
> > +
> > +/*
> > + * If we are fiddling with an IRQ's active state, we have to make sure=
 the IRQ
> > + * is not queued on some running VCPU's LRs, because then the change t=
o the
> > + * active state can be overwritten when the VCPU's state is synced com=
ing back
> > + * from the guest.
> > + *
> > + * For shared interrupts as well as GICv3 private interrupts, we have =
to
> > + * stop all the VCPUs because interrupts can be migrated while we don'=
t hold
> > + * the IRQ locks and we don't want to be chasing moving targets.
> > + *
> > + * For GICv2 private interrupts we don't have to do anything because
> > + * userspace accesses to the VGIC state already require all VCPUs to be
> > + * stopped, and only the VCPU itself can modify its private interrupts
> > + * active state, which guarantees that the VCPU is not running.
> > + */
> > +static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 inti=
d)
> > +{
> > +	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3 ||
> > +	    intid > VGIC_NR_PRIVATE_IRQS) =20
>=20
> I understand that this is just moved from existing code below, but
> shouldn't that either read "intid >=3D VGIC_NR_PRIVATE_IRQS" or
> "intid > VGIC_MAX_PRIVATE"?

Nice catch. This was introduced in abd7229626b93 ("KVM: arm/arm64:
Simplify active_change_prepare and plug race"), while we had the
opposite condition before that.

This means that on GICv2, GICD_I[CS]ACTIVER writes are unreliable for
intids 32-63 (we may fail to clear an active bit if it is set in
another vcpu's LRs, for example).

I'll add an extra patch for this.

Thanks,

	M.
--=20
Jazz is not dead. It just smells funny...
