Return-Path: <kvm+bounces-25371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF0396496F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BD81B25C4A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DC21B3727;
	Thu, 29 Aug 2024 15:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZXO7HL9v"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1A41AC8A0;
	Thu, 29 Aug 2024 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943869; cv=none; b=eEvMRx5uM6BSCnjiJ5fG31mavh46HhKdGrSGQP5+eQKrClnx1Tl0KdxFsQFqoUeuN+mD+SqQ3/lRAWOmCa8gJ96Z5JRBL6kwnYjljppICISFsbKU9vJUNucNZHSa5v7RmPaTbvuqAnlSyWzGp6ux845quU4BijVe+WDjQ14Jrz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943869; c=relaxed/simple;
	bh=lP7O8YnthRSL3opjjOPeri6/0jjOp8ue8AR4MTD9/DI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqhIJmXifd3m+dY0toDDwMl94pqGch8g3LxLkxXwdE3odrFN+jdednSzu1GoYd8Pl9G3BnKYUEgQjzTqK+CKeDdvq6XZJIG4mf8xxYtWpdXvlWh+0JlyEKnTVxXTztAwVj+mUa6qjxfwdv7U2sp4rp6fUn3S5YERBCWeNo5xKxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZXO7HL9v; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D879040E0277;
	Thu, 29 Aug 2024 15:04:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id eGyWPI7l-Okp; Thu, 29 Aug 2024 15:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724943862; bh=YfvEj90/YGTqFstXw+WygwIyDmoZvVGd7EjPYBPVmmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZXO7HL9vBgsg3vVGUgx+5tUa1K02Cy5YiW87naLs7rQWruNBSeAPNX84S5dPpx16Q
	 Phc0unvnj/pAXRoTrl8gKXNmjc28NiQa7Gx7IuKoEwyxMsXo7PCayGQ11aa5YiS41q
	 LH4lBzFE8o/V46xa8cGFGKVfepmKo6lAW1qiI7QW08SFGBPDqWtsmgmC7/qcS8vVB2
	 9jnAbgFEnu/gu2+aAsJgU/noo9i0vUolxyTqDWbJ63DBSJ8wxGpD9r/lSDe/+o7dmk
	 fWipX/QOAaR6LFBXcrGJhzluk01T2RK+pFO8Mle3AgYYbD3g/b9FcW34EUgt8pzwIw
	 VZQgQtSceacb0xUyCqqsrbOEABhkSLE42a6pr40MSN9PhUSQEc0OjzIFAgyX62if/9
	 BdnlIykYUe3hxsiWLWDvRYG157aTgZfWpom0KXvuJk5W2T5Fp595xq7hbkwkcuVyeh
	 QYEOmfNQXpjszVN5KE+N9v2D08w6K8xi7+YfX+hu6vbxjroa1gG90yD6FeS0K0v9uQ
	 4ey8hLyMvDTt2KComHRs7C3FoW1XOH1gCNLx5LB3wUnGKfP7BPJTsnWNiWXYHG01bG
	 WHnpNP+RGVdn/9KHkVmplmyFVp5E1H8+8B5SkDKpVvIah6dWJjHrs02ssUIu+EHhgo
	 bo49QgY29hvKGw7zGc5MgNO0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD3DC40E0275;
	Thu, 29 Aug 2024 15:04:06 +0000 (UTC)
Date: Thu, 29 Aug 2024 17:04:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
	dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	thomas.lendacky@amd.com, michael.roth@amd.com,
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Message-ID: <20240829150401.GGZtCN4ZtVyqjYHbpD@fat_crate.local>
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
 <ZtCKqD_gc6wnqu-P@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtCKqD_gc6wnqu-P@google.com>

On Thu, Aug 29, 2024 at 07:50:16AM -0700, Sean Christopherson wrote:
> Because if the host is panicking, guests are hosed regardless.

Are they?

I read "active SNP VMs"...

I guess if it reaches svm_emergency_disable() we're hosed anyway and that's
what you mean but I'm not sure...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

