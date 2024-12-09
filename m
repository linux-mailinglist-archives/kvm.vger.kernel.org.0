Return-Path: <kvm+bounces-33326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E67859E9AB0
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 16:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A63B82860E9
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 15:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA13A1C5CD2;
	Mon,  9 Dec 2024 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CvVXKVbO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A601B423A;
	Mon,  9 Dec 2024 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733758713; cv=none; b=kyrhJAwte7l1Oi3tnMLHu2C/eWAxzd4qw2ygueC3bme41FNvNIXOy+srXuwxrscv5V6ZXtknO9eYg8qG4H2geHPRd45WUiAPwK/7KKbhKTQpn+T2Nuu40HoW02w/14nRiSIV0PJn+5ieMB4tz3xhyqMAyXaYPwodsXl2dxz0adA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733758713; c=relaxed/simple;
	bh=rwINOh45wrebVn6I9kZss6deQVKEdkBJm9a3dDITvrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGy1j+b4LAY83DhnLLmfNWz1bae/ADeX0PaqCjbcnBpu2j4jJjfSOw7hdw4jWrbDOpNmB7oMHf9H6F8b8PqgPn5Uear2BHl0qk3WC+h7baHRbwxoR1oztPJhxuHb/7Mhg21g1b/IBb0ga+IYBse68cbLoWxqkLx5/z2cYu4Ub7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CvVXKVbO; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7211A40E019C;
	Mon,  9 Dec 2024 15:38:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YGNFox0KmrF1; Mon,  9 Dec 2024 15:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733758706; bh=nqIYzy7qDv83P6KCz+Yk/4aP1izF32dWJhj20IVJS0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvVXKVbOCOTF40JQdyIxdOOPgcsCJ7ZgHoBknq1W/8lLF14w10PzqMM0r3fgG8kBT
	 qWIKeUrlu6/IRIksEs8Hkc21wNreqog3D9nhNjc56XTV063DZ7gvu6eTjhJTkm/R/b
	 pVwI/G90XR2VQ6zsWOzjamH+L4vVOD+aXu5qNz4ly/gMl03ZM5BztayTB6Xb+aer6T
	 +FolRzAPbX4ZwccVFc04J5P/xA8JCSBRTlTgvxk5aNIyZlJnF7xLVzrbRWNi8VfAfC
	 UTAripbOHs7rNgKLwbOJtKH5GJ2PTAj2I79LcegV6Pb5XmEg/FVQ1op4NSzc2gsZpT
	 DwxK6iT7FSLgXuUSaGmlR6Ykj8dHViktWyerCOJiyRDvSSG+JGj9To83TuWNkda3Hz
	 8psS4DdQQKufwtPxi4YaH4huDp4FSVEek3Ksj0SK85C+K4u5O3AUfcrH5PakYWFa7i
	 CruHgjdDpLr19vXu/VQvdC/iTdxMRRpNwK5gbl8YTYdx16dpyvWPz651kbr56faUvy
	 5Dry6+vp1PZQgkFP+K4H7m6A3FgCmVIuB/7IoNE0rdB+q/2Q0fX+kOlS0HGBXOdCBZ
	 LSu0UqsZKhoOE6pcmnCU3nxzLb77gtFWA2zAkTGE8T/SVk+90/2jgpmFl/3zBz1lRV
	 StXVQDMLAV7fVxlD7fHCkDPU=
Received: from zn.tnic (p200300Ea971f9307329C23fFfea6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5F4F840E015E;
	Mon,  9 Dec 2024 15:38:15 +0000 (UTC)
Date: Mon, 9 Dec 2024 16:38:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241209153814.GEZ1cO5uw_lp0fg8Bg@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
 <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
 <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
 <f0b27aab-2adb-444c-97d3-07e69c4c48a7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f0b27aab-2adb-444c-97d3-07e69c4c48a7@amd.com>

On Mon, Dec 09, 2024 at 11:46:44AM +0530, Nikunj A. Dadhania wrote:
> That leaves us with only one site: snp_init_crypto(), should I fold this
> change in current patch ?

Nah, a pre-patch pls.

Along with an explanation summing up our discussion in the commit message.
This patch is already doing enough.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

