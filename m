Return-Path: <kvm+bounces-70561-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFO9BgzWiGkYxAQAu9opvQ
	(envelope-from <kvm+bounces-70561-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 19:29:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 846D1109E23
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 19:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8B43630094E8
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 18:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E7B2FBDFF;
	Sun,  8 Feb 2026 18:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="elpt48mc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E52B292B54;
	Sun,  8 Feb 2026 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770575365; cv=none; b=js3TDHY4HfIy5fsUisFo/iBB5dRJBRfaxzaYTU2ZhPaTh3flE091e5NdXeUcCwMAUGroKhYbWlsGXQR7owtAcmHGmLnB84HhmXubmGw+rv6IzsF20ilKXGREcBPtFk04DXq3UbORZ1lOaJ/V+b70yfKma34eBlXMiis5R/gHrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770575365; c=relaxed/simple;
	bh=yfVwxXENM/2FsChb8np3K9P8bnFeWAFfdCyXKBn/Qkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbLnlpWuFNlDgS01hOloz/3PjZLcxCqCOI4U/fLeOJAzgtbHRXiEE2pbc8T+RAizi/19QSOt8ihwXgzIKVHehyN5OuplTzzSWGdcnT0lp9oMDTr7/kKqqNrR8nbCpwM5+V8a0/2xikRQ2PB7DznM16mEe7IQ7ONrv/Eoa3RlWys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=elpt48mc reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DFB7240E0316;
	Sun,  8 Feb 2026 18:29:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Fo_Q9IPir9zW; Sun,  8 Feb 2026 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770575349; bh=Mff3Jt2r6VemdM9GoedtgbE3uM43lz/bRwN+S8QH0uQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=elpt48mcNbCCSpSlsFuCHAgdK68qz+wyWiU84NakEKZR/oR82wYkHhMrukHUohHLZ
	 ssfyu4t1RMXH+ZHSxsaz1sp1WcWpLsBlvOfl2aiR3+pkIMTgpoHyvnxBsjF+16VbD8
	 eacufoWrwV8oar04PKp5gXCwfcS17k6cywmPzKrYKuR1QurUIQ3qLg4IhMEKrXIkTF
	 3ONQkCU6Jdm3onWoVfIwNJuaBN7hwU3jrbAxkqLbpIubalK+eVMKpWF1xja6BZUPhI
	 nyrL2OuoTUXpcgcN8+PZzZV2WlZ7ZNn58Aj3wiK80IdSrlQ5UrjOPau4P8ErApQQeN
	 oq0GOM7aNVlKqadJW2REn5Mk4DDF5zngMw948F+BiSWXBZ4P3Gcs5pUHndWQe4jXbe
	 OU85c2PD5W7A0MO4zMWO6DumCNFPt+vWHe70lKQEBdGab67Tp0UBNVhPHF/Gyhn+HJ
	 6kHZDWqwAFQ6zLwVkPCDL3bvCmtBgdHGdmRTYpwpRGeP+8dyAx3MGoI4t63zx4Y6yi
	 2Qx8P0/u0lK3SrodbPiU3Xsvlf0T3GhU4lIH95N94R4b0iJaEEssBaj9JqPZ/j7P1/
	 yby0+1YTbnGvNEr9s4HxX0kCqXB6QoHECeg+WM+JfgjbhoeoMvxCRVxFhUS2dMkS/A
	 gj7LZxTKRm5efo/JLxKn1E4E=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3873840E02FA;
	Sun,  8 Feb 2026 18:28:58 +0000 (UTC)
Date: Sun, 8 Feb 2026 19:28:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>, seanjc@google.com
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	Babu Moger <bmoger@amd.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
Message-ID: <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
References: <20260208164233.30405-1-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260208164233.30405-1-clopez@suse.de>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[alien8.de : SPF not aligned (strict),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[alien8.de:-];
	TAGGED_FROM(0.00)[bounces-70561-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.984];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 846D1109E23
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 05:42:33PM +0100, Carlos L=C3=B3pez wrote:
> KVM incorrectly synthesizes TSA_SQ_NO and TSA_L1_NO when running
> on AMD Family 19h CPUs by using SYNTHESIZED_F(), which unconditionally
> enables features for KVM-only CPUID leaves (as is the case with
> CPUID_8000_0021_ECX), regardless of the kernel's synthesis logic in
> tsa_init(). This is due to the following logic in kvm_cpu_cap_init():
>=20
>     if (leaf < NCAPINTS)
>         kvm_cpu_caps[leaf] &=3D kernel_cpu_caps[leaf];
>=20
> This can cause an unexpected failure on Family 19h CPUs during SEV-SNP
> guest setup, when userspace issues SNP_LAUNCH_UPDATE, as setting these
> bits in the CPUID page on vulnerable CPUs is explicitly rejected by SNP
> firmware.
>=20
> Switch to SCATTERED_F(), so that the bits are only set if the features
> have been force-set by the kernel in tsa_init(), or if they are reporte=
d
> in the raw CPUID.
>=20
> Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")
> Signed-off-by: Carlos L=C3=B3pez <clopez@suse.de>
> ---
>  arch/x86/kvm/cpuid.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 88a5426674a1..819c176e02ff 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1230,8 +1230,8 @@ void kvm_set_cpu_caps(void)
>  	);
> =20
>  	kvm_cpu_cap_init(CPUID_8000_0021_ECX,
> -		SYNTHESIZED_F(TSA_SQ_NO),
> -		SYNTHESIZED_F(TSA_L1_NO),

Well:

/*
 * Synthesized Feature - For features that are synthesized into boot_cpu_=
data,
 * i.e. may not be present in the raw CPUID, but can still be advertised =
to
 * userspace.  Primarily used for mitigation related feature flags.
 	       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=09
 */
#define SYNTHESIZED_F(name)

> +		SCATTERED_F(TSA_SQ_NO),
> +		SCATTERED_F(TSA_L1_NO),

And scattered are of the same type.

Sean, what's the subtle difference here?

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

