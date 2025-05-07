Return-Path: <kvm+bounces-45705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A38F0AADCA4
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 12:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A8943A8648
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DAA2147FC;
	Wed,  7 May 2025 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MMOW6rfd"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29B1B87D5;
	Wed,  7 May 2025 10:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746614337; cv=none; b=MlDzBT4/pVMyTermAh+WpJ6zE4cp40HucgrNYOVgFLEc95hqdwUYa/a6M1B0r+C8Sl6q17jvhIjNN+5AfegdtGXcDWDG5igMra7V1/XFTO1tRuoplzT1Cu/tjuPDtucTS6oOpuzqfnWJAbEU+xHEFMbYbXIDh+WSYruirCX7/TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746614337; c=relaxed/simple;
	bh=C12Kkx8kkpkqsq8XfghKSPwFlwi6qGFqHeCaSrbW3/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLF//3jxK6zDDhrwcps/j7BA7Ni9eEWsb4gAi8uCT2EgLTnw5C6vNtPQmOHhgG2tK+N+sQlEmf+RgaCPyw3/tfxk15HxdelIKp8RqzIVYsdWAt9SuUS56CNMlwQK62FkWL3kq0U24jHA3a2FrVvZSFegP8buOpXPmlW/VB8F5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MMOW6rfd; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A3F1040E0238;
	Wed,  7 May 2025 10:38:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5NxdQlzpfchg; Wed,  7 May 2025 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1746614328; bh=jsxjYtuSaUYoq44jVayqHfQabpuP4aDbz6Wxb67ZlSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMOW6rfdk+xn01cb3BPDMCZyLZhag1dJD6GJku1/T3uMt4v5owu5Fh75UvdXXtkGf
	 sMnxJxSidHDLibNiwb0VVED+qGBvR/i9rnjGJAR27No6ek2MPPpYhFsOhA2IasVlKq
	 NXjrMUfUY0unL3q3dFiJTXPD/d1JOP4jNaIrL9LFvd3Z4q9wqifBXp2nnF0dDKs9Da
	 ZRvuu87JFSPNkxWDE7BZE9AGb2r9pyPwUlbJH1Wo9HtsLj74HiTSZZncUF3hsNeJ/9
	 fH31z+99/h/O3UBG2/sjuhkhz2ohcjYaZx9zxepRpXgtFuMXysbSdHNrY/dL5QzS1E
	 IeiLKYEJoce1GbGtRi+IXrZZSWy2P5XS4f5A5xHohdPZz9AQAQPApMoenAKeK4/Xch
	 EYDs42nmPoqwNMW8kcHE1ZDX/6U8O1fAUiXZ71MzfC2UjepaXOjlHF85Lrx+B6IqTp
	 eRQKgpwyWfK44MiK+8TH2CI2l+wS+tGyIPbrBIb7Vv/bG2TDEQ+dzRW22nEu2GS5Iq
	 LcaPh4/qhxwCg+0jNuYOxErrAKpbtzPcZUoi5po/2vwe8iqiP6lpfkYY8pflcOQvTi
	 PNFp2ipsDY4SrPUzJMcW861uXeI3PrJgjNDQLPkFE2Z3OKy7D7oEcQzLh/EiH8hVuZ
	 NHj2FkLsxKkl080XlGW9UkPo=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3E08440E0222;
	Wed,  7 May 2025 10:38:27 +0000 (UTC)
Date: Wed, 7 May 2025 12:38:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a
 common header
Message-ID: <20250507103821.GOaBs4HVnMXOdzOo_y@fat_crate.local>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
 <aBDlVF4qXeUltuju@google.com>
 <62ae9c91-b62e-4bf9-8cf2-e68ddd0a1487@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <62ae9c91-b62e-4bf9-8cf2-e68ddd0a1487@amd.com>

On Tue, Apr 29, 2025 at 11:39:53PM +0530, Neeraj Upadhyay wrote:
> My bad. I missed updating the changelog with the information about logic update.

No, remember: when you move code like this, your first patch is *solely*
*mechanical* move.

Then, ontop, in further patches you do other changes.

You want to keep mechanical move separate from other changes because it
complicates review unnecessarily.

One of the reasons I'm trying to get you guys to do review too is because then
you'll know.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

