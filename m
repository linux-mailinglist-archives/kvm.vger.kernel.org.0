Return-Path: <kvm+bounces-6475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E565D8331EC
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 01:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8773EB22900
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 00:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7D0A4A;
	Sat, 20 Jan 2024 00:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="gd1zjiaQ"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE9039F;
	Sat, 20 Jan 2024 00:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705711467; cv=none; b=HTSIh5O1WDRRGDSl4c+bcDAcwnvWFofqoUKNBaGAA5OZvV63OhshnxS/GYwwpTfB1Nk2A7IxXWkjwyLJaBkTFl9CE1teg02Evb2b+gHVYuFrfXn2c69mBaGSKYfTRlOYVzRVmm4RT6ZkHVDI6i6NOSWYLmTMYNF1JrV5X7Zt5uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705711467; c=relaxed/simple;
	bh=mLAwfTqW3JqPYfITefySSYIm5jxOBfJIzaZejnA2Hek=;
	h=Date:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWAt7ImX+Q0/KrmE1XKa7mjkt7JWNRD7MFSWQjRf2hMh5MgqaUQPmx/EqWfhof0SlsaqzIwFFWmamW4UTAZ+VvSPl8p80L2w8xLCJmvSvWksU6uL8KG5YhLncUVi+VrJmuCubZFaZ5XJi5Wfbp3f8/1nZRIpaM1ggDmkE/Wtuvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=gd1zjiaQ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1705711456;
	bh=5EXJu33TqPCGL2xgGmr1B8pslMsApecSKH/SB8e0KQk=;
	h=Date:From:Cc:Subject:In-Reply-To:References:From;
	b=gd1zjiaQujA9BHI56crV1tmzzoTM2Bw2H+aMihqyVyYmiaL5RclU6TVkXzNM/IphG
	 2BBJMFqiPJvSPWhAhAqCxDTMmAk7CUQCWO2GKyPweGROkN3AIojHuYS+EcRvuGCyy6
	 Q+gpG9twBAPkdJ1J/estXqii4zlgwaCrZRsAk/9WvA1lSUzdHoZ/DHzGiKi1DoxOuX
	 SCE+6dq+qApJduNW8b66JPI3+tyRfJcjylsQcHlv1kGJ93hW1yblC0wVBq1IoFiXAd
	 edw+zfl8DBesIaM3k/FF5WbDPK1MzzO8HFu/8TjQ3ECpGsDHKzsa9WabQvxkYsYfQG
	 Gj+rC253P0adg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TGyRM1LtBz4wx8;
	Sat, 20 Jan 2024 11:44:15 +1100 (AEDT)
Date: Sat, 20 Jan 2024 11:44:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Randy Dunlap
 <rdunlap@infradead.org>, Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao
 <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH] LoongArch: KVM: Fix build due to API changes
Message-ID: <20240120114412.2208a8c1@canb.auug.org.au>
In-Reply-To: <20231220144024.7d9fd46b@canb.auug.org.au>
References: <20231115090735.2404866-1-chenhuacai@loongson.cn>
	<15ba5868-42de-4563-9903-ccd0297e2075@infradead.org>
	<20231220144024.7d9fd46b@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Uo2ujjpjD/I=Dix6LsNA.i+";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/Uo2ujjpjD/I=Dix6LsNA.i+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 20 Dec 2023 14:40:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 15 Dec 2023 21:08:06 -0800 Randy Dunlap <rdunlap@infradead.org> w=
rote:
> >
> > Someone please merge this patch... =20
>=20
> I have applied it to my merge of the kvm tree today and will keep
> applying it until it is applied to the kvm tree ...
>=20
> It looks like this:
>=20
> From: Huacai Chen <chenhuacai@loongson.cn>
> To: Paolo Bonzini <pbonzini@redhat.com>,
> 	Huacai Chen <chenhuacai@kernel.org>,
> 	Tianrui Zhao <zhaotianrui@loongson.cn>,
> 	Bibo Mao <maobibo@loongson.cn>
> Cc: kvm@vger.kernel.org,
> 	loongarch@lists.linux.dev,
> 	linux-kernel@vger.kernel.org,
> 	Xuerui Wang <kernel@xen0n.name>,
> 	Jiaxun Yang <jiaxun.yang@flygoat.com>,
> 	Huacai Chen <chenhuacai@loongson.cn>
> Subject: [PATCH] LoongArch: KVM: Fix build due to API changes
> Date: Wed, 15 Nov 2023 17:07:35 +0800
>=20
> Commit 8569992d64b8f750e34b7858eac ("KVM: Use gfn instead of hva for
> mmu_notifier_retry") replaces mmu_invalidate_retry_hva() usage with
> mmu_invalidate_retry_gfn() for X86, LoongArch also need similar changes
> to fix build.
>=20
> Fixes: 8569992d64b8 ("KVM: Use gfn instead of hva for mmu_notifier_retry")
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/loongarch/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 80480df5f550..9463ebecd39b 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -627,7 +627,7 @@ static bool fault_supports_huge_mapping(struct kvm_me=
mory_slot *memslot,
>   *
>   * There are several ways to safely use this helper:
>   *
> - * - Check mmu_invalidate_retry_hva() after grabbing the mapping level, =
before
> + * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, =
before
>   *   consuming it.  In this case, mmu_lock doesn't need to be held durin=
g the
>   *   lookup, but it does need to be held while checking the MMU notifier.
>   *
> @@ -807,7 +807,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsign=
ed long gpa, bool write)
> =20
>  	/* Check if an invalidation has taken place since we got pfn */
>  	spin_lock(&kvm->mmu_lock);
> -	if (mmu_invalidate_retry_hva(kvm, mmu_seq, hva)) {
> +	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn)) {
>  		/*
>  		 * This can happen when mappings are changed asynchronously, but
>  		 * also synchronously if a COW is triggered by
> --=20
> 2.39.3
>=20
> Though my Signed-off-by is not necessary if it applied to the kvm tree.

OK, so it needed to be applied to the merge commit when the loongarch
tree was merged by Linus, but appears to have been forgotten. :-(

--=20
Cheers,
Stephen Rothwell

--Sig_/Uo2ujjpjD/I=Dix6LsNA.i+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmWrF1wACgkQAVBC80lX
0GznHwf+J9OteK9Y4TvrZARvcVljc/vhMzpH0IOshhkyHVBuTKd4HGZC+feioXt8
wrw0wYaXqR6UvcOl0ZRbhpIHPjgM5nvDC/YKgmR7i7Mpf+ui7OZ3GtXiOl2VjKWN
68beXUCalkCnl60EhVVYDHhQhzPn4nCOcfcV7iNAcUcahDHwliglktfsQHL2nB1/
iCoxmeHjplk/LoeFpe4Vrez+bRfoPxp/xvVaWy5TbtvUpkKb90XuLxnpRyA9CkTt
0p4BZpGbEaqMh8KLyqu9r4vLfN8pQqrQeTXbpM2Kyz5dSZfQ9hVwvWdcHU3So1lr
QCKupRyJOOwEpP7m3icFsf7qJz9Kqg==
=Aan9
-----END PGP SIGNATURE-----

--Sig_/Uo2ujjpjD/I=Dix6LsNA.i+--

