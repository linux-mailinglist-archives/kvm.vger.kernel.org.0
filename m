Return-Path: <kvm+bounces-57737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F7EB59CC9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B698A165B02
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EEB29B78E;
	Tue, 16 Sep 2025 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bjEzItVX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8EF27EFFA;
	Tue, 16 Sep 2025 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758038479; cv=none; b=Gn8B2BLMEchgaRS6k/mQOv3jc7gcCfhjPhzvfQLFEXqsDv8JyT47z08cFQB1b86FAAUiX3HFLJ220TpaiLdOHveXdkcnbQod+1H4a+g8tRZ/sMrOvN4f8mlkIS2u6KwNdHpjMYaS6ehTL87NLEoesuM/UF3UJbUdfUoqvPbWv/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758038479; c=relaxed/simple;
	bh=21Krwcpj0+SngOBRLh60xP/UrVLCJttLw4rK8+5Jz2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZDDlMyEfJ34pKLNP+9Fp5VMvRRjx92ycSCSyMcC95/zr9IREOwQyVeDY2QxpHXwtSBU9X/63tePbjQs6GvJ9zAhQRLG987mnBXLhGe9ntP61Cllet+ER0oCg5Y5pet39y4N0FXjkTHV3U6zJVGgWG6fM6BZpfugruUphSJ9+Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bjEzItVX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 88E9B40E01A5;
	Tue, 16 Sep 2025 16:01:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IK9AvWzGmseb; Tue, 16 Sep 2025 16:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758038463; bh=No517GNEZAwn0tEDWDqJ1SJLHxLK2NW7CPuDfryTxqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bjEzItVXIpkoGyWsMWLwYpRrE/kVRcqxaszssCcFQBoyMujoqKujYVvZgnjek8wmR
	 9VeuoMldMJ8vUqF3LQDWIMdH2TZRVOhY0yDUkMGJwqmF/jdYZ5HDn/ng1x7odqS0VQ
	 9M311y05wmfsYaHMOlEx4FM6H06CEgayjZW0XuhqUV3ja4446Cxmi8GuRefP2/NPlQ
	 9d0JKIgz5GXqpiPiaCgIIPaqJu8gVQQdeIX3B+EY3O2v57+nahELmyNBguWzys0ij0
	 DZoBLLq16fJbdv12RRV270lVT8KzcYAawO2Rxx2qCNEjld6nanumUqg3xsT+Y7h6C9
	 l17q+pY4dJJuOEHxxw/TOl9u1KOgEoMQTCSab3bVOqT5t+B5qRdq63XDxPyHCfOVrH
	 eSJiNqXcSrdip6yc1biw4SxgFsx7b5JBXTSvZUpz18T7apB9fL49PUF4CpeBe0I0pW
	 31CIhkOLUWvvIbt/tXmfClNaRZV/fLmajJwgObx9xbML0ft8OUP18JtAv7LNZirhEJ
	 LY81T7W6QCQkqjVHSBRrFhE6w/CNLAd4sJu+tDuGfJgCNZjasmrOA1DsQIQ2qe9dUj
	 5Eeh3TnwnBVl4H26N6X3dd5C0TWj6bHbDiYD6cSMKSgsl4Y5tbdG0woXglBYL1lxFg
	 Mh5sHNvbxymW1TIo1dq4ADzY=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2F01440E01A3;
	Tue, 16 Sep 2025 16:00:43 +0000 (UTC)
Date: Tue, 16 Sep 2025 18:00:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, herbert@gondor.apana.org.au, nikunj@amd.com,
	davem@davemloft.net, aik@amd.com, ardb@kernel.org,
	john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
Message-ID: <20250916160036.GHaMmJpHHIW7RybFXD@fat_crate.local>
References: <cover.1757969371.git.ashish.kalra@amd.com>
 <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
 <20250916131221.GCaMliNe3NVmOwzHEN@fat_crate.local>
 <45528c22-9fe7-4f7d-97e9-1d58a0415b08@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45528c22-9fe7-4f7d-97e9-1d58a0415b08@amd.com>

On Tue, Sep 16, 2025 at 08:58:42AM -0500, Tom Lendacky wrote:
> Did the patch merge correctly? I can't see how it would fail since both
> the original and new definitions are in separate parts of the #ifdef... It
> should have failed even before given the way it was changed.
> 
> Maybe I'm missing something.

Nah, you're right. Because your patch is moving sev_evict_cache(), I ended up
resolving it wrong. Sorry for the noise.

Ashish, all patches against tip go ontop of the tip/master branch. Please redo
your set ontop.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

