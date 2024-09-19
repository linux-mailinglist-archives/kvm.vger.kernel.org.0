Return-Path: <kvm+bounces-27176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5BD97C865
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 13:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06551C2525B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 11:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C8619D8B3;
	Thu, 19 Sep 2024 11:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HLl02lb6"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7182219D093;
	Thu, 19 Sep 2024 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726744433; cv=none; b=ds3SQhRmutAr8Muh6w+rNEwP5AL3w58oIfxp47CygllElOJW0NvD6sdDXSKHmblw9qxFhWIsLEubZphRSbpFSs5kcuK194ZVtHJlhrUgXSad4GH+z993/19JO5cx9QXYeyf88518TRaq6V24RWa4iypyXa4eF/dvqaChZPHUW7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726744433; c=relaxed/simple;
	bh=nQLrwtEvPD2RIIWNzQpKhc6xQPqQQ1ILaBmagJ3VLpc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=E5rr0y9rxeHbJXcI7+KoirXCtSQV/j12c7tQ3BUOrIFkyUvRIJ4+ymZ8n/xgcuVfmUk35XJBjAe3A8nnSKJ9VPsGKR8m5KVlXB4sb+7AI1XsYF7UcNWanddn+K20GVS+7niZFN+ubA4IrzojLFzm8HkcB3y6MY2xpT/XA7dnBXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HLl02lb6; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=NeI2rUXnLzjpOtYnknN4FnM+omBAMRqLA336G57YcoI=; b=HLl02lb6kHfUPOArY6JJlLmUfO
	zFsXAspjCR4SgKGMRtcBFd21Cr1nlzpiDNaa5UsqVuOw52ne10PWmQEsnox7Y1Ee5m0Z7IcXkhrkO
	NIdHoEhUnB9ZYVQgd76IdS+1hasPLsdsMuK/x2w0btnm7RxmxBJlJi6NFiewHgErUKUB5zb1Xuo3d
	CjaAoiXkVD40ZN2nXrRVW0GfHzPbl7hT985K9pFD7HbNCkIc5Fih1Qx6uszsG9YNnrRlt624UNt2S
	ee2UDG83JjdmjfhE70NdgdaZDfDxT/j91auEXzbHqCkYpbTPpE44/v0BLCFog6+aKevMv5CN5Rx/W
	WyWEtSVg==;
Received: from [83.68.141.146] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1srF6G-00000000zDq-0RV5;
	Thu, 19 Sep 2024 11:13:28 +0000
Date: Thu, 19 Sep 2024 13:13:25 +0200
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Hussain, Mushahid" <hmushi@amazon.co.uk>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_1/5=5D_KVM=3A_pfncache=3A_Add_ne?=
 =?US-ASCII?Q?eds=5Finvalidation_flag_to_gfn=5Fto=5Fpfn=5Fcache?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240821202814.711673-1-dwmw2@infradead.org>
References: <20240821202814.711673-1-dwmw2@infradead.org>
Message-ID: <30CC6DCB-DF32-4FE5-A600-14CE242CBA61@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 21 August 2024 22:28:09 CEST, David Woodhouse <dwmw2@infradead=2Eorg> wr=
ote:
>From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>This will be used to allow hva_to_pfn_retry() to be more selective about
>its retry loop, which is currently extremely pessimistic=2E
>
>It allows for invalidations to occur even while the PFN is being mapped
>(which happens with the lock dropped), before the GPC is fully valid=2E
>
>No functional change yet, as the existing mmu_notifier_retry_cache()
>function will still return true in all cases where the invalidation
>may have triggered=2E
>
>Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>---
> include/linux/kvm_types=2Eh |  1 +
> virt/kvm/pfncache=2Ec       | 29 ++++++++++++++++++++++++-----
> 2 files changed, 25 insertions(+), 5 deletions(-)
>
>diff --git a/include/linux/kvm_types=2Eh b/include/linux/kvm_types=2Eh
>index 827ecc0b7e10=2E=2E4d8fbd87c320 100644
>--- a/include/linux/kvm_types=2Eh
>+++ b/include/linux/kvm_types=2Eh
>@@ -69,6 +69,7 @@ struct gfn_to_pfn_cache {
> 	void *khva;
> 	kvm_pfn_t pfn;
> 	bool active;
>+	bool needs_invalidation;
> 	bool valid;
> };
>=20
>diff --git a/virt/kvm/pfncache=2Ec b/virt/kvm/pfncache=2Ec
>index f0039efb9e1e=2E=2E7007d32d197a 100644
>--- a/virt/kvm/pfncache=2Ec
>+++ b/virt/kvm/pfncache=2Ec
>@@ -32,7 +32,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,=
 unsigned long start,
> 		read_lock_irq(&gpc->lock);
>=20
> 		/* Only a single page so no need to care about length */
>-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
>+		if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
> 		    gpc->uhva >=3D start && gpc->uhva < end) {
> 			read_unlock_irq(&gpc->lock);
>=20
>@@ -45,9 +45,11 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm=
, unsigned long start,
> 			 */
>=20
> 			write_lock_irq(&gpc->lock);
>-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
>-			    gpc->uhva >=3D start && gpc->uhva < end)
>+			if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
>+			    gpc->uhva >=3D start && gpc->uhva < end) {
>+				gpc->needs_invalidation =3D false;
> 				gpc->valid =3D false;
>+			}
> 			write_unlock_irq(&gpc->lock);
> 			continue;
> 		}
>@@ -93,6 +95,9 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsign=
ed long len)
> 	if (!gpc->valid)
> 		return false;
>=20
>+	/* If it's valid, it needs invalidation! */
>+	WARN_ON_ONCE(!gpc->needs_invalidation);
>+
> 	return true;
> }
>=20
>@@ -175,6 +180,17 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_=
cache *gpc)
> 		mmu_seq =3D gpc->kvm->mmu_invalidate_seq;
> 		smp_rmb();
>=20
>+		/*
>+		 * The translation made by hva_to_pfn() below could be made
>+		 * invalid as soon as it's mapped=2E But the uhva is already
>+		 * known and that's all that gfn_to_pfn_cache_invalidate()
>+		 * looks at=2E So set the 'needs_invalidation' flag to allow
>+		 * the GPC to be marked invalid from the moment the lock is
>+		 * dropped, before the corresponding PFN is even found (and,
>+		 * more to the point, immediately afterwards)=2E
>+		 */
>+		gpc->needs_invalidation =3D true;
>+
> 		write_unlock_irq(&gpc->lock);
>=20
> 		/*
>@@ -224,7 +240,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_c=
ache *gpc)
> 		 * attempting to refresh=2E
> 		 */
> 		WARN_ON_ONCE(gpc->valid);
>-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
>+	} while (!gpc->needs_invalidation ||
>+		 mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
>=20
> 	gpc->valid =3D true;
> 	gpc->pfn =3D new_pfn;
>@@ -339,6 +356,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache =
*gpc, gpa_t gpa, unsigned l
> 	 */
> 	if (ret) {
> 		gpc->valid =3D false;
>+		gpc->needs_invalidation =3D false;
> 		gpc->pfn =3D KVM_PFN_ERR_FAULT;
> 		gpc->khva =3D NULL;
> 	}
>@@ -383,7 +401,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struc=
t kvm *kvm)
> 	gpc->pfn =3D KVM_PFN_ERR_FAULT;
> 	gpc->gpa =3D INVALID_GPA;
> 	gpc->uhva =3D KVM_HVA_ERR_BAD;
>-	gpc->active =3D gpc->valid =3D false;
>+	gpc->active =3D gpc->valid =3D gpc->needs_invalidation =3D false;
> }
>=20
> static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, u=
nsigned long uhva,
>@@ -453,6 +471,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
> 		write_lock_irq(&gpc->lock);
> 		gpc->active =3D false;
> 		gpc->valid =3D false;
>+		gpc->needs_invalidation =3D false;
>=20
> 		/*
> 		 * Leave the GPA =3D> uHVA cache intact, it's protected by the

Ping?

