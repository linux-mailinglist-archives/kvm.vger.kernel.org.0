Return-Path: <kvm+bounces-67366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D3933D0289D
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 13:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D201130123FE
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 11:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE3748AE09;
	Thu,  8 Jan 2026 10:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JSCbw8qN"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33EE48CE72
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767867941; cv=none; b=erkwpCKpP8iJJ0YXDA9ksRWrhZkVMHcz0w1+mZnwvJ8+P/UheGv83AunpR7kJ8WPYHMSv53/zxM+Ycr8QqtclkfiYK+8mnUky36D2Uy0XpSD1XetWB2Kqx0U8NYCb8gdhZ6j8nzagIPLYTqfEpwSWUoFD9MDIScNp3RrYSDE9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767867941; c=relaxed/simple;
	bh=hV8cdqEVmDNIC+PyDeitq6drXJfHlHagjlpm7np4GmA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l11CSI+LXJgb6HYHZ+uwpSn/DhRS7S32Z8NHQ0ZUW38BMRkq0FSeOToNb/+DVb9AGFIuhReWVEsdBOTusJd1M/Im1AlEhje3n4hz0JKXDa1ctu750tgIpB5SP/HefSOjRiokyty8ag3BDo3/3x8ZWJEYhDusgNEra0oQfvrpGvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JSCbw8qN; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=of4seSqIPdCyuLzFSq3d1KkXUCDbWW18kLWy2KllRF8=;
	b=JSCbw8qN3TULPk70WRzdVzdYEXVw3Ik2TS6P58byeRVe4pQ++f7S7y8G8x5dc/31ekpfJDf1c
	dtKOa3orKfpIohcuJulnWEajcJmvWC14t9ufbitVGdonVyp5TP8op23nK/8hNNA23wjwZSw3pKZ
	JCHxJfpq8LzRhxo871gW684=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dn1FN1PGtzMlWV;
	Thu,  8 Jan 2026 18:23:04 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn1Hg593mzHnH71;
	Thu,  8 Jan 2026 18:25:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A081C40086;
	Thu,  8 Jan 2026 18:25:11 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 10:25:10 +0000
Date: Thu, 8 Jan 2026 10:25:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, "Suzuki
 Poulose" <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Message-ID: <20260108102509.000061fb@huawei.com>
In-Reply-To: <5b9fd030e3048fadcd4ac95ddb0671e1af7dc960.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-8-sascha.bischoff@arm.com>
	<20260106184313.00002a8c@huawei.com>
	<5b9fd030e3048fadcd4ac95ddb0671e1af7dc960.camel@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Thu, 8 Jan 2026 09:33:30 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> On Tue, 2026-01-06 at 18:43 +0000, Jonathan Cameron wrote:
> > On Fri, 19 Dec 2025 15:52:38 +0000
> > Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
> >  =20
> > > GICv5 has moved from using interrupt ranges for different interrupt
> > > types to using some of the upper bits of the interrupt ID to denote
> > > the interrupt type. This is not compatible with older GICs (which
> > > rely
> > > on ranges of interrupts to determine the type), and hence a set of
> > > helpers is introduced. These helpers take a struct kvm*, and use
> > > the
> > > vgic model to determine how to interpret the interrupt ID.
> > >=20
> > > Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
> > > helper is introduced to determine if an interrupt is private - SGIs
> > > and PPIs for older GICs, and PPIs only for GICv5.
> > >=20
> > > The helpers are plumbed into the core vgic code, as well as the
> > > Arch
> > > Timer and PMU code.
> > >=20
> > > There should be no functional changes as part of this change.
> > >=20
> > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com> =20
> > Hi Sascha,
> >=20
> > A bit of bikeshedding / 'valuable' naming feedback to end the day.
> > Otherwise LGTM.
> >  =20
> > > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > > index b261fb3968d03..6778f676eaf08 100644
> > > --- a/include/kvm/arm_vgic.h
> > > +++ b/include/kvm/arm_vgic.h =20
> > ...
> >  =20
> > > =A0enum vgic_type {
> > > =A0	VGIC_V2,		/* Good ol' GICv2 */
> > > @@ -418,8 +488,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
> > > =A0
> > > =A0#define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
> > > =A0#define vgic_initialized(k)	((k)->arch.vgic.initialized)
> > > -#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) &&
> > > \
> > > +#define vgic_valid_nv5_spi(k, i)	(((i) >=3D
> > > VGIC_NR_PRIVATE_IRQS) && \
> > > =A0			((i) < (k)->arch.vgic.nr_spis +
> > > VGIC_NR_PRIVATE_IRQS))
> > > +#define vgic_valid_v5_spi(k, i)	(irq_is_spi(k, i) && \
> > > +				 (FIELD_GET(GICV5_HWIRQ_ID, i) <
> > > (k)->arch.vgic.nr_spis))
> > > +#define vgic_valid_spi(k, i) (vgic_is_v5(k)
> > > ?				\
> > > +			=A0=A0=A0=A0=A0 vgic_valid_v5_spi(k, i) :
> > > vgic_valid_nv5_spi(k, i)) =20
> >=20
> > nv is a little awkward as a name as immediately makes me thinking
> > nested virtualization instead of not v5 (which I guess is the
> > thinking behind that?)
> >=20
> > Probably just me and naming it v23 will break if we get to GIC
> > version 23 :)
> > nv5 breaks when we get GICv6 ;) =20
>=20
> Absolutely agreed here. The v5 and nv5 macros were not used anywhere,
> so I've re-worked this a bit to be more in the style of those added
> earlier:
>=20
> -#define vgic_valid_nv5_spi(k, i)       (((i) >=3D VGIC_NR_PRIVATE_IRQS) =
&& \
> -                       ((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_I=
RQS))
> -#define vgic_valid_v5_spi(k, i)        (irq_is_spi(k, i) && \
> -                                (FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arc=
h.vgic.nr_spis))
> -#define vgic_valid_spi(k, i) (vgic_is_v5(k) ?                          \
> -                             vgic_valid_v5_spi(k, i) : vgic_valid_nv5_sp=
i(k, i))
> +#define vgic_valid_spi(k, i)                                           \
> +       ({                                                              \
> +               bool __ret =3D irq_is_spi(k, i);                         =
 \
> +                                                                       \
> +               switch ((k)->arch.vgic.vgic_model) {                    \
> +               case KVM_DEV_TYPE_ARM_VGIC_V5:                          \
> +                       __ret &=3D FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->ar=
ch.vgic.nr_spis; \
> +                       break;                                          \
> +               default:                                                \
> +                       __ret &=3D (i) < ((k)->arch.vgic.nr_spis + VGIC_N=
R_PRIVATE_IRQS); \
> +               }                                                       \
> +                                                                       \
> +               __ret;                                                  \
> +       })
>=20
> More verbose (with annoying line lengths), but certainly more scalable
> and removes the naming issue altogether. Personally, I prefer it
> because it is more aligned with the related macros above.
>=20
> Is this preferable/acceptable?

Looks good to me, though it's getting complex enough that it might be better
as a static inline function. That will also reduce line lengths
a little.

Jonathan

>=20
> Thanks,
> Sascha
>=20
> >=20
> >  =20
> > > =A0
> > > =A0bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
> > > =A0void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu); =20
> >  =20
>=20


