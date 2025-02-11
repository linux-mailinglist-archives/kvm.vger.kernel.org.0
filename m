Return-Path: <kvm+bounces-37916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93636A316B8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF433A722E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308EC262D39;
	Tue, 11 Feb 2025 20:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AFUlWZ0D"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7898D2641C9;
	Tue, 11 Feb 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739306010; cv=none; b=IhVkxR5WGzkpy10bHiLGsdl1kWeY8xz9PbfoP9bdtOY9R4UMECVTeet795x61PzzbQVZX9tCV4ETStXBTe33sLp0ZgHn1qYTL1Znua5HH6kFU7auUWRqkjl9P7h8j2/5DjTJt8QB+W8wqys89+AirSw64ghZhvIakFQULBfpjhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739306010; c=relaxed/simple;
	bh=0f9pRQChVXubkmyasXArzZjjwmP416IPg/pG89VNEA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6+ewDNNGWrdoj4iHUXNtBqjx6FXIOBtD72OAuWNkGYX1wkBZOrKRvrfxvdGSBisdAa7OBgR4JtNtwVuVVHKBgkSrkYGmoaQqUDSxZw5geExDk6B/hCFfBcfroDB/8qLVq5VOapLHO2bJ6y+JeH7lFzrwSTlW2SgqhcjQbGGLcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AFUlWZ0D; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DE2F840E01A3;
	Tue, 11 Feb 2025 20:33:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0PKbeqaqAjw5; Tue, 11 Feb 2025 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739306000; bh=vokWJlVITGsJPLU0E80fHH3PEIz2HUpoUnuaGEO2j6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AFUlWZ0DeHiRMMNZlsix1H04k414jFQXrFBZ4u3Kh2xhD2zeHLtcREVfv49eBYkRE
	 2Uz9r44M6OkcAd2F5Tn7kyK54+mdJErAicpYaNXR5S8izEv6nOBNpsfOARwcge74iV
	 TmFenLLylZGXmeyAeLI3nuHQQHBU2J6D6cdEUsbjr8oC/7h9T8eXDJLpgzdS3/+oed
	 n+iLHWSmOZGWw6969PcR/8iGtpI6qBuDGIA8ivjzHStxYrTWMw4iMsEiBHObvGMiOE
	 0F++vYiFXcsy06/Yyu+lUaQ0CD2ROX/Z7mFlltOaOF120lQPflr7FoK+/pnwpPv8RO
	 o+BTQsdyQ1uay0JWxnM0UkpR8iMddQuZcfI0g+Pkv0NpO60BeLqja2fmr0932rvMzV
	 H7swDSsow4+pjCTDJLJkUshJPe55qQFYObG4woYT3lFYOx6VaW8u6H/pHsQGIp4mDy
	 2YqTmmnf4zue9xs9Zxbl0lkm/c4+hDjqw48dAXQQCo/YCqaJSZfmZVt6Lw1NSKjbbM
	 xPSOgyxuaZxgWmt5yvo9yxKxR07xMLcPjtvKDfJL1ve7VLNfix1x6/FU76QemVtK4L
	 c8kDVs/Lv7/yXWNcgMavW2AoNALm74nfMtCcWr8skhL1PWzrEeIzE/P6v/K7uMPWPZ
	 08T7FYKdJuebMVv1SZsOImxo=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5016940E01A0;
	Tue, 11 Feb 2025 20:32:56 +0000 (UTC)
Date: Tue, 11 Feb 2025 21:32:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev,
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH 03/16] x86/tsc: Add helper to register CPU and TSC freq
 calibration routines
Message-ID: <20250211203250.GHZ6uz8qs-bzcbi0_b@fat_crate.local>
References: <20250201021718.699411-1-seanjc@google.com>
 <20250201021718.699411-4-seanjc@google.com>
 <20250211173238.GDZ6uJtkVBi8_X7kia@fat_crate.local>
 <Z6uMOyHD3C6-qCXz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z6uMOyHD3C6-qCXz@google.com>

On Tue, Feb 11, 2025 at 09:43:23AM -0800, Sean Christopherson wrote:
> It conflates two very different things: host/bare metal support for memory
> encryption, and SEV guest support.  For kernels that will never run in a VM,
> pulling in all the SEV guest code just to enable host-side support for SME (and
> SEV) is very undesirable.

Well, that might've grown in the meantime... when we started it, it was all
small so it didn't really matter and we kept it simple. That's why I never
thought about it. And actually, we've been thinking of even ripping out SME
in favor of TSME which is transparent and doesn't need any SME glue. But there
was some reason why we didn't want to do it yet, Tom would know.

As to carving it out now, meh, dunno how much savings that would be. Got
a student to put on that task? :-P

> And in this case, because AMD_MEM_ENCRYPT gates both host and guest code, it
> can't depend on HYPERVISOR_GUEST like it should, because taking a dependency on
> HYPERVISOR_GUEST to enable SME is obviously wrong.

Right.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

