Return-Path: <kvm+bounces-67367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FD3D02257
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 11:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1A9B3025313
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 10:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B259F3B5305;
	Thu,  8 Jan 2026 10:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="flRF/P2I"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DFA3A0EBB
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 10:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868023; cv=none; b=sSdkpYJ8MeThuBr2W032Nd/HucyrZ83tXjAvYU5f0Y2HPhFZ0x4sH55ihnib+ZXMouEGt4L5HElh5/DP8mvbtAf1m19IElPWa//AN7qO21QQj9qVGeUa8aO8vLtHaTyNQ6KMOARTJTpUmDJWFJOVrr2qnLsvWAm72kEJh9ViNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868023; c=relaxed/simple;
	bh=NPjKBiDumg2tkM6Ms9hONxx4xE+XFZ5OnqhVN8q2JLU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDPbgbOsrnW7gnc2VZ4anekzND/00pWlaYqqixclgQ7659E3dLrHNSanj/P3aLdwSasZTjU2U3ls+9c1biHCE37iwSqBofyxrxdxWb+ETWgFg4eMWTYo4q4f34zbXqQs0UGBRssVvyJ1Fp0Tg+B/IX+P1zdGaQipUQ6GXI5hcBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=flRF/P2I; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DEmcuElp0UQkGJCO6KQWjXnV/POLT0WxyNyLSZSnVYI=;
	b=flRF/P2IsumUov+UukeIGuQd42cQFPlHBQi38PU20DD9lRCVhiwqBWcxv0uiHC3db8wha37C9
	cct0QUglVjOSoLZyJsDkJAHuqKT5j090f5kxfJaDnojlqlW7H71yFtEwtb3fIY/xtIjoahVt7jm
	Q3BsJYXwDEr9qooEl2u/itw=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dn1HG440CzN1Jm;
	Thu,  8 Jan 2026 18:24:42 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn1KZ0TMyzHnGjN;
	Thu,  8 Jan 2026 18:26:42 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 026654056A;
	Thu,  8 Jan 2026 18:26:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 10:26:49 +0000
Date: Thu, 8 Jan 2026 10:26:47 +0000
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
Subject: Re: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Message-ID: <20260108102647.00004a2d@huawei.com>
In-Reply-To: <5ef0d810c4619b941d5c74e79401ce584193604d.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-9-sascha.bischoff@arm.com>
	<20260107103044.00000df0@huawei.com>
	<5ef0d810c4619b941d5c74e79401ce584193604d.camel@arm.com>
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

On Thu, 8 Jan 2026 09:48:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> On Wed, 2026-01-07 at 10:30 +0000, Jonathan Cameron wrote:
> > On Fri, 19 Dec 2025 15:52:38 +0000
> > Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
> >  =20
> > > There are times when it is desirable to have more than one return
> > > value for a hyp call. Split out kvm_call_hyp_nvhe_res from
> > > kvm_call_hyp_nvhe such that it is possible to directly provide
> > > struct
> > > arm_smccc_res from the calling code. Thereby, additional return
> > > values
> > > can be stored in res.a2, etc.
> > >=20
> > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com> =20
> > One question inline, mostly because I'm curious rather than a
> > suggestion
> > to change anything
> >=20
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> >  =20
> > > ---
> > > =A0arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
> > > =A01 file changed, 10 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/arch/arm64/include/asm/kvm_host.h
> > > b/arch/arm64/include/asm/kvm_host.h
> > > index b552a1e03848c..971b153b0a3fa 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -1208,14 +1208,19 @@ void kvm_arm_resume_guest(struct kvm *kvm);
> > > =A0#define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
> > > =A0
> > > =A0#ifndef __KVM_NVHE_HYPERVISOR__
> > > -#define kvm_call_hyp_nvhe(f,
> > > ...)						\
> > > +#define kvm_call_hyp_nvhe_res(res, f,
> > > ...)				\
> > > =A0	({						=09
> > > 	\
> > > -		struct arm_smccc_res
> > > res;				\
> > > -
> > > 									\
> > > +		struct arm_smccc_res *__res =3D
> > > res;			\ =20
> >=20
> > What's the purpose of the local variable? Type sanity check?
> > Feels like typecheck() would make the intent clearer.
> > Meh. Not used anywhere in arch/arm64 so maybe not. =20
>=20
> Far less exciting, I'm afraid.
>=20
> It is because of the text substitution that happens. The res here is
> replaced with &res from kvm_call_hyp_nvhe() and we end up with &res-
> >a0. Given that -> binds more tightly than &, we end up with the wrong =20
> thing, and the compiler barfs.
>=20
> An alternative would be to do:
>=20
> 	WARN_ON((res)->a0 !=3D SMCCC_RET_SUCCESS);
>=20
> This removes the need for the local variable. I've got no preference
> for which version we go with.

Ah fair enough.  Just leave it as it is.

Jonathan

>=20
> Sascha
>=20
> >=20
> >=20
> >  =20
> > > =A0		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),=09
> > > 	\
> > > -				=A0 ##__VA_ARGS__,
> > > &res);			\
> > > -		WARN_ON(res.a0 !=3D
> > > SMCCC_RET_SUCCESS);			\
> > > +				=A0 ##__VA_ARGS__,
> > > __res);		\
> > > +		WARN_ON(__res->a0 !=3D
> > > SMCCC_RET_SUCCESS);		\
> > > +	})
> > > +
> > > +#define kvm_call_hyp_nvhe(f,
> > > ...)					\
> > > +	({						=09
> > > 	\
> > > +		struct arm_smccc_res
> > > res;				\
> > > =A0							=09
> > > 	\
> > > +		kvm_call_hyp_nvhe_res(&res, f,
> > > ##__VA_ARGS__);		\
> > > =A0		res.a1;				=09
> > > 		\
> > > =A0	})
> > > =A0 =20
> >  =20
>=20


