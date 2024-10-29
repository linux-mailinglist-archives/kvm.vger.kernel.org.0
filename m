Return-Path: <kvm+bounces-29953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 926189B4CD9
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:04:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FDFFB225D1
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0587192B63;
	Tue, 29 Oct 2024 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eLAr+cnt"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504C10F7;
	Tue, 29 Oct 2024 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214230; cv=none; b=Zly/gWQIA66qeIcKI3M6J/Hctq7/Ys8vjNFjx6vpCFhTZNGmeP75k/NDNKcbeubngmXlDtqDvx2xU2QVpinlq7Ezp6NQ2RcWGzacDDR3k+bVdHxwsaUTDl1nCvtX3aA08wC/IePVJFSxvJugz+kjbj0Lxa+0tqOPLXJYofVjKAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214230; c=relaxed/simple;
	bh=RVbFK1tFhoKeJ2NbeHNAp6f1uCvOACbNpikNBax8b0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcQ54j8Xw/yEG237TjxbISEXer7eVWT0HUcYR2yq9kVRnU6V0vtUPYsuAiQd1Vc+lvtW0JNdXkI202GODkkqMyDn6tdpFOIPHLX0nW2Ls0nvZCjzFjujonlcE/q3TPCuINNCqql60KZXxO1DTntH4sVQkNbaNDyX84OxRumETu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eLAr+cnt; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B1E7740E0192;
	Tue, 29 Oct 2024 15:03:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2uaI0SwLwg68; Tue, 29 Oct 2024 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730214221; bh=KuXP+FhBYbX0f8iTTMdhgC2qWAuM3gbCOsNzds/dU3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLAr+cntY8YclkSkkyiInI68VtCMsrfn8p2it5TPVk8XGujLxhLtZCv9e4P2ZqmBr
	 zjkTy/M4zB/b9qkswLIhaaInNSUpMhBfPOAN73QrTptOb29i0B+TJC6o68HthPyv17
	 hCla0CEm/5jfUYPmdAZ95qZfYKzxnaeDt9HU0oq6mGBDWOLTjvnxEgeAap69K7hRmv
	 a671WDcmLYsnPlLKe085Glm5lR7y9XGWG0YvY1J2huldaK/jacIWl+4nWzH5oN8ErS
	 ueLlX2f3IklQj3aphyW+VQze6KrgDMJeKL8gNh55ON6CGyWzLTol7ZkOtRqqgT/Lan
	 YFubmIOQyCA1WlKEgBAGA8BrKe3DBu5sxi0PULq1+rq/Aq4WY+yuewjih9ca2R3Zuy
	 IDPSUMEds3T349ZU6BwPpkGoBhh9rKTPZRgFaJH9d7IbMV0ML7VRiQ+L0HcuaCUHx0
	 VUSE9B54bvNCcUueLBnvZ7WCnz6ExqkCTNGMd2kBU7vGDYmyM8tLKSdHdvNKZN2mjb
	 D90sWnSSHOCOGqol7eR1xrROGN+2INk7QKuX6XW5ucxXBCj7Zyhvd7iq9QzJjxDEu/
	 Kxn0WszF1K4GAKIa6rWGrezHlxTMb3UpNwxiypfDZC7fgkxyFFFBeDxUnKwRyoPlvz
	 RJ+tcx3VQSifYDLBRWu4oP4s=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFFCF40E01A5;
	Tue, 29 Oct 2024 15:03:28 +0000 (UTC)
Date: Tue, 29 Oct 2024 16:03:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20241029150327.GKZyD5P1_tetoNaU_y@fat_crate.local>
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
 <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>

On Tue, Oct 29, 2024 at 10:50:18PM +0800, Xiaoyao Li wrote:
> I meant the starter to add SNP guest specific feature initialization code in
> somewhat in proper place.

https://lore.kernel.org/r/20241029144948.GIZyD2DBjyg6FBLdo4@fat_crate.local

IOW, I don't think we really have a "proper" place yet. There are vendor
checks all over the memory encryption code for different reasons.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

