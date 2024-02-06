Return-Path: <kvm+bounces-8095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 119A784B1E5
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 11:04:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A607428633B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 10:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC27C12DD86;
	Tue,  6 Feb 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eH7neTiI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED611E4AE;
	Tue,  6 Feb 2024 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707213879; cv=none; b=hPaeQO4M/j4LNhyaOd0GagSrY9rXUYIhNX0ijqFpdyI42xg10zEVU12jbbjvrVtemmNBNme3briSbLPCpn05Nh1n5qwzjtbGzBJcYw7KJAf6c8x/cNFMTOhXNLqFfj4FsTpbg+9jK1MzPMKiEMdBULKRxNbWVjj4RnnCn74fVMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707213879; c=relaxed/simple;
	bh=gW7t8hW3imp+PqsXZyr05n6ePuqZalGznC/r4/tBlcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D63hFMIW6FCAJyXRlU3+WEVNPUtP36XFrdubWGHUOI0M+rT1ZyvOlgZEbHzMZ74PPjEXTUnfA1RxN/xEjhe1oyvZH2kV7QEMNketLRzbNYYBu2VYZ5o51x+Nl3rtPGS7n28DEP9nFeFznI7racEPC8n0rbxjFOTSnK+zloG0zIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eH7neTiI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1DD5B40E00B2;
	Tue,  6 Feb 2024 10:04:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mAzo3U_xm5y6; Tue,  6 Feb 2024 10:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1707213870; bh=YQPRmOIMAlWlSmT/Yk/DsVNxBZ/3BBFLfb2NXakTptQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eH7neTiISK8x2qljS9HWtxySFGDAEFJLhsCUMgzUi+nyvbxe61vVKpAVLQQ/Y0Hsz
	 QbFim+qqKgFGFstfykWBP7HRs+OqtdHjejgsAJbbveZyyEm/cf/ZbIzt58pXpt8wrC
	 t1yg/KiMm44vvn4iROf6uTyDfVkAb/VkEkkkccUVTGeTWF+54/sStjb1OiTVc/G9vz
	 z5jqKlo+dGPnbgVTIgq78XmFRMlmVTNKZTs7akZ7pcq4DGJgYVxCWAsmn4WhWuUlly
	 lCYX0BUrBa+AkdJUD3K9Dsd003Hnk2R1T1gxqh55/ynRZ0o+HMyG+7npPeuVtbH6nz
	 idZg8oCKMgQrzjLGBZw0NcTz+H2bySzbFwCI9fo4KnZbI8s1zxsk46TcpGTxFnF8FH
	 R9/9bNuxhw1ymwCI5QARv6lcQaAqtf7nYZT5XG1cec+HDPKUJU1h9O9ePtya8mvk1Z
	 cliv8WR5y/1ZCQtaLSIJo83sGYhgTu7I/MU0yEWrYgLNNyw/7MVqiOGb80yRf/K750
	 qvDc/4/vxFBwClc8PoslwGwebaK2A4x2G3X90mS1IlnQ1G46lw/KYPMVOSHl5mI+vN
	 A5qmze+/2xTTKirUpAQvT1CRGGfIVIrf4UWJtPJ7pwquNh6KTpOMhrbjXr9QN/ih7v
	 pZnu89Ds9cXfwN6kT2/2qARs=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8947740E016D;
	Tue,  6 Feb 2024 10:04:18 +0000 (UTC)
Date: Tue, 6 Feb 2024 11:04:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Message-ID: <20240206100412.GAZcIEHGET2NfMPHnk@fat_crate.local>
References: <20231220151358.2147066-1-nikunj@amd.com>
 <20231220151358.2147066-4-nikunj@amd.com>
 <20240125115952.GXZbJNOGfxfuiC5WRT@fat_crate.local>
 <03719b26-9b59-4e88-9e7e-60c6f2617565@amd.com>
 <20240201102946.GCZbtymsufm3j2KI85@fat_crate.local>
 <98b23de9-48e4-4599-9e7f-0736055893fc@amd.com>
 <20240201140727.GDZbuln8aOnCn1Hooz@fat_crate.local>
 <408e40b4-4428-4bef-bb96-8009194a9633@amd.com>
 <20240202161455.GCZb0U_9jckCT8loBc@fat_crate.local>
 <ec2be3f2-b20a-46c1-815c-9065e10f292a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ec2be3f2-b20a-46c1-815c-9065e10f292a@amd.com>

On Mon, Feb 05, 2024 at 02:53:30PM +0530, Nikunj A. Dadhania wrote:
> Sure, below is the updated patch. Complete series is pushed here 
> 
> https://github.com/AMDESE/linux-kvm/commits/sectsc-guest-latest/

Yap, that looks more like it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

