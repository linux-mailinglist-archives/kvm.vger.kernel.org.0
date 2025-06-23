Return-Path: <kvm+bounces-50304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 838CBAE3E28
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C6D8170EEC
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A209244661;
	Mon, 23 Jun 2025 11:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PKVv51j4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD0E231A23;
	Mon, 23 Jun 2025 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750678930; cv=none; b=gPVq6w0JuL6xBSqIDmAkf0dby29AFpJ2Ipa7lcnjJETTia4D7uh+NmWupyR9wZMoPouOFKgHxnoFNrob/lkUjZyHEsfN1tS0aShPCp6gnKOssUgwbSh9yFK8EnwVukQg9qUkTFWtrNtu9I9JO/3nux+pInyqQNGL8PDv+AVtEXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750678930; c=relaxed/simple;
	bh=2yP9cZ7jGexoJEfMiHFFZZL1pAXX0g1/b+nBVd4xhog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XH+uzANeYbzc3O+YRVAi1kMp8bLivytldzkBNJBuLzCNlUFaKiWyqCbBJjTuh0w/OjPV29tYrft/q5QybBTkZnznWpKh6OP0yEYQwcVM933atUj7CQCdn5XsD8EIVwk2OgpxT9+vZEMz38c+SAo6bjAu8RpdU4/V17zDZHgVGpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PKVv51j4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C043F40E00DD;
	Mon, 23 Jun 2025 11:42:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3R7aqmQKpptH; Mon, 23 Jun 2025 11:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1750678922; bh=bb/GKzqFVGB7gGGZBdz3PxvpScmCCPczePeWPLg6dA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PKVv51j4vxLnraCY+meWk7NgzaK0rRVmiJZGLW5qgyMbE+edvYd6prQtGhNnkbS6L
	 vWHYHHlHUEB8dE1WW6SVY4OrukhQ5xrSsgHF8c/sM999cpWZ/Pnb2/Pw+rNkSCPl1z
	 dWhSJnFc3XRkYcpVOnu+DyiFuHf/CMOi6ApPk34t3fOFUfigd18bFL+pNuNVWhbBa8
	 SnDKzz42AR45WES0LZC0jHBU7/ARFlKKHAvvX5oXwPQ6woUMy38URaNbd/kzDgA7ao
	 3OAesNodURoVIE0IKjH9W5dYyJS+Xk2h44OtKAmKZmgSFgy5k5x/aA1MzBauDlDeuV
	 mSX7gaYSNWW11ltpaqfMKssqtZZn6PqJMQitGvkhvIL4ezgd8lr7prqPY+6BePzMKC
	 9RaGcqg/DQjpG0FUQ2rg5YOKbd46GlMSHHUB3ZilJ2UQ9ieepABTL6rNnNYJ51h+c0
	 kjbu5HKeTVMpxJA6AinO2IvlfpCVOhlywdvR9i1tGkW1aopGanPvDm1H1qG4ptbNKK
	 IjCuCqdKP3X08E+o9R8V7r2kwgzQ9aB8hNuKAjmPr+GjNU0CL15uwO/WnjivfPlmnY
	 6W6ivefG5gnLfv3RtPtkpzbY6iuuy0TgmmaxT4ztBuCYGcWSoyOZKGOsEAK0mOjUOd
	 7i7k2n8avwGtaATQqLkI7N/0=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B525140E01FC;
	Mon, 23 Jun 2025 11:41:39 +0000 (UTC)
Date: Mon, 23 Jun 2025 13:41:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [RFC PATCH v7 02/37] KVM: lapic: Remove redundant parentheses
 around 'bitmap'
Message-ID: <20250623114133.GFaFk9bRYpNeuSjXWn@fat_crate.local>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-3-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250610175424.209796-3-Neeraj.Upadhyay@amd.com>

On Tue, Jun 10, 2025 at 11:23:49PM +0530, Neeraj Upadhyay wrote:
> When doing pointer arithmetic in apic_test_vector() and
> kvm_lapic_{set|clear}_vector(), remove the unnecessary
> parentheses surrounding the 'bitmap' parameter.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v6:
> 
>  - Refactored and moved to the start of the series.
> 
>  arch/x86/kvm/lapic.c | 2 +-
>  arch/x86/kvm/lapic.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

