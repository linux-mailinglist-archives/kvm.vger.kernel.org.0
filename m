Return-Path: <kvm+bounces-28244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3CD996CCE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C60BB1C21CC0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EFF19995D;
	Wed,  9 Oct 2024 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="HAtXFfby"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815FB38DE5;
	Wed,  9 Oct 2024 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728482047; cv=none; b=tDh08n0LOTPLEKQXdplkKZuynwUcyc1ql1auHtIbx0JJbpmFOMbEh0/1TuTHJi0lh6cbHTj7jnpec3BC2/n/LK6gLGmJQYF6OCDHO8AT0OZweHVYKOcCtnHD75+Th7cqTOAKxJiMpmon20IF3OqMknMA3PaBb0OOXyBsFfv9OXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728482047; c=relaxed/simple;
	bh=5gy1wURQ9sXzt042bjSluaDkjgIP0l5MjWBbnVlhYe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJNwazTu2O+ggN+GnAYfAUBXdSy7O55HnMPDPQQYTPW9T+9OmPeXrdBQSlYX0HP7WMspQeCEI3P8wdgvjD39AXil4to7eOwpJnOlonkpERkBecHDN79IyVc5BAdp2Si5RBE6nk7rEUDFzaMMPUWrlCxON96g9wyaO3gQ3dGe7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=HAtXFfby; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 39FA340E021E;
	Wed,  9 Oct 2024 13:54:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IdbX89wCKlFI; Wed,  9 Oct 2024 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1728482039; bh=ENByvpOkGcPi0iC2AE3+sSC4IuiELUBQ7SmJZ4Ik5Kg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAtXFfbyhb4nIVi8+kllC9pJb9A6w261F1LECfCAU1UvwUhtwo3y+MefG80xG2uf/
	 hQ2WQbZvNKmX8DmXQa1mg8IgdtsCA1ekPzG3QvQyZgQ4rqGvJ6B1m12B9VrzCQlXyx
	 8wAFRWGB1s5G4JZoCYuQgG0qJegr23Ai7o33rFYpo4M3TQEeN2Rszzh8HvqgsO/5Gv
	 SlebH+Hlz0lTwT1guFGvzMu+c3ZUYWgk5PNzD9yAgUgjp5FHlxOdq/EIbwn+CPXzc+
	 BCXfdpYpUznLlHts5md8m+nbfdYaHCPDtCGPPKqwmomLaDjuIkRVH1vNn1YTxGzU0r
	 8qkQGELNiiltoCwRCk4FcZEGcQsG79/3dtWKmGwEU3VXlk88EqC8aVAEHiPa+QaU9A
	 2l4SpGvD8ioG0SshuxdthgcL/AKr6f2UHKrOfjgRz2k4HrvB7YREICiFzAIScqdGSt
	 4qRdUcR68byHmi52DoCsTCArlYyJL+7mtqQpLYAa3bHJ1i+qIcgNZjkeR/DNi2ix8N
	 NhbuFBiKJolf9AlzhCBQCfjTMfVlh2LJOjKOk7XQfnVI+v/VkXmyC5kn9/C19Tured
	 MoV0RUr0XEqBTVxNvcgsgU78tq+xnyXGT0FVYi+QoxUAtU0qlR4D7a0x1YZHCcsSns
	 fPQ2ed54HKuszUogfr4oiTq0=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF0AB40E0191;
	Wed,  9 Oct 2024 13:53:40 +0000 (UTC)
Date: Wed, 9 Oct 2024 15:53:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
	David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com,
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <20241009135335.GKZwaK32jOZlA477HX@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
 <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
 <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>
 <20241009112216.GHZwZnaI89RBEcEELU@fat_crate.local>
 <wb6tvf6ausm23cq4cexwdncz5tfj52ftrrdhhvrge53za3egcf@ayitc4dd6itr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <wb6tvf6ausm23cq4cexwdncz5tfj52ftrrdhhvrge53za3egcf@ayitc4dd6itr>

On Wed, Oct 09, 2024 at 03:12:41PM +0300, Kirill A. Shutemov wrote:
> If you use SNP or TDX check in generic code something is wrong.  Abstraction
> is broken somewhere. Generic code doesn't need to know concrete
> implementation.

That's perhaps because you're thinking that the *actual* coco implementation type
should be hidden away from generic code. But SNP and TDX are pretty different
so we might as well ask for them by their name.

But I can see why you'd think there might be some abstraction violation there.

My goal here - even though there might be some bad taste of abstraction
violation here - is simplicity. As expressed a bunch of times already, having
cc_platform *and* X86_FEATURE* things used in relation to coco code can be
confusing. So I'd prefer to avoid that confusion.

Nothing says anywhere that arch code cannot use cc_platform interfaces.
Absolutely nothing. So for the sake of KISS I'm going in that direction.

If it turns out later that this was a bad idea and we need to change it, we
can always can. As we do for other interfaces in the kernel.

If you're still not convinced, I already asked you:

"Do you have a better idea which is cleaner than what we do now?"

Your turn.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

