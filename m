Return-Path: <kvm+bounces-17371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 093B88C4D82
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 10:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7611F21E32
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 08:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682961CFBE;
	Tue, 14 May 2024 08:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FG5dvltM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31D817583;
	Tue, 14 May 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715674253; cv=none; b=qktp+wyLUuWpjnbhx1lwx80q00FVcXiN4bAJOGBAgJ4s35irP6haNpDf35aXy/4QR9cm1928VORRxT38cgdbQWd3yAdcSghVRllAuPTf5jMEgcyLI/CwBVQsbHSSfCIfhA+ZSs8cCgrAUOUdHwRw7j4IgxtQx9D7NNjtuk8SAyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715674253; c=relaxed/simple;
	bh=MpHkCTTzT86UodOTRs7438YKurSYodl9BhzbJLYQrFc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=qsGJ0D2+wLF8CcV2pq2AMeW9XIvx+Y1oscPI/5go4blPY+vNyPyFktg1cEtLSEWVJV9Vi4J1efk+BsE/JqOt8t7Ol2q08w4lG5hTddHc7KrTxRSxa4C5EsJCkALF5c5d1nxSoP6qL38hUk7TlQnQfHsfdkJUjPOvMSPLy0rt+Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FG5dvltM; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C2B0D40E016A;
	Tue, 14 May 2024 08:10:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5GgcEjtDY3OT; Tue, 14 May 2024 08:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715674243; bh=t5ROxBLyd57crBiDvNCn5htGvcOSCvJ21aXiNcdc1Jc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=FG5dvltMk9er4ZGaXvdDhAltrQWcMie0x7swib34kGp8na3+Bm2tQyIU/eewygFVm
	 TEdg0nVvIBeFvFWtwVzrncxatN2IDrDdN2x2VUtDf58H2j+wK6wpLsuVwFbrXTz8y8
	 +c30TK9zpPkQYwbMeOcPNVTwShQjJ+3CayDY4PRRwMsp8OVu5iC/ZNh2wq3x2nR7Sg
	 ulJ7EnZ/MWaH2K8EqRk/lJT0YtcFB6Blo08a0pV0Gvke2PKams9StkGzthkKtxMpd0
	 xbPcXcdwgvDuSmSQ5aFtIOBm4beqZ8i/LQCuYJVRa9jlnIjohP0B1/GLR8Qylxnhn0
	 DWy8NAQEx3s1ZIWomP/wAtnmCAhjsQ+gV0v86sPuvo/Qf5xsIHLUWnvtDLFt7gYro8
	 C94c1cl28IE2QuZuX3px16ws3rkWEPmrjUue0GEaeU1QyxCUbUETG4t/uLnnejFZ8F
	 q70r8GhLiPwv9oJsHiQMa3NQu+ZelgdueHdKwOz2EHG9YxqfYZJwLUMxvq7KOB+jfR
	 h60Q4BaIKOIEiwB+YUQhISlLKpkzoldR6RUqovhSCogCNkTsxJS1iPWiO9apfu4xRy
	 Q7HDaOl41AG07Px788iehUPgEs2ghyswpGSrCARG8MU+B6AiN1bXTeQ5g7hRSIh6St
	 tmd5zLArc3Gxe5H6VLx3MwIs=
Received: from [IPv6:::1] (p200300eA973a3496499cB1fE0c65A759.dip0.t-ipconnect.de [IPv6:2003:ea:973a:3496:499c:b1fe:c65:a759])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5FC3240E0192;
	Tue, 14 May 2024 08:10:04 +0000 (UTC)
Date: Tue, 14 May 2024 10:10:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>
CC: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-crypto@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 mingo@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
 ardb@kernel.org, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
 kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v15_22/23=5D_KVM=3A_SEV=3A_Fix_return_c?=
 =?US-ASCII?Q?ode_interpretation_for_RMP_nested_page_faults?=
User-Agent: K-9 Mail for Android
In-Reply-To: <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
References: <20240501085210.2213060-1-michael.roth@amd.com> <20240510015822.503071-1-michael.roth@amd.com> <20240510015822.503071-2-michael.roth@amd.com> <Zj4oFffc7OQivyV-@google.com> <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com> <20240510163719.pnwdwarsbgmcop3h@amd.com> <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
Message-ID: <AFCDFEE1-40CF-4780-B129-5AE56057BE41@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 10, 2024 6:59:37 PM GMT+02:00, Paolo Bonzini <pbonzini@redhat=2Ecom>=
 wrote:
>Well, the merge window starts next sunday, doesn't it?  If there's an -rc=
8 I agree there's some leeway, but that is not too likely=2E

Nah, the merge window just opened yesterday=2E=20

--=20
Sent from a small device: formatting sucks and brevity is inevitable=2E 

