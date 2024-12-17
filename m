Return-Path: <kvm+bounces-33913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 255EF9F47A8
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 10:35:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D8361886723
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 09:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2EA1DE2B3;
	Tue, 17 Dec 2024 09:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eLs4+xIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3393D69;
	Tue, 17 Dec 2024 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734428105; cv=none; b=QzRgBv37wvrsuekYwI/KX3jXLSUnFPBzrdv6ITI6vEKDpaqE1SBCVsEYizy8f835LBUBlR5i0nhjLkbrdU710kSZx5prQharsk4rqgkofthNXoCe0KOL6fVdZKxVuD8HMyYiFHkdKf+UvbojSjqr1YPQO9Bc0i+CVh+M7KrkGSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734428105; c=relaxed/simple;
	bh=1AJeEumsisBIcR+JufyuUwYLbSkLC/Ur83iQEoQOhe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MP+yUHsrdu4j4h/Gb4BAfxbit0xov8wZZVgTt4u4ocMZu3SaXDqDYt2mRjgZBYKu4vbjWMgrpAq/H1EkWEX7irtJ4so40j3bqoLwVkkZlfvTBmsT9nYJ0C17ZmubLn9iApzpUx9pZu6CyOg8bAYrq1SvJeFrS3yTFblqf3cM9xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eLs4+xIM; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7953340E0286;
	Tue, 17 Dec 2024 09:34:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Dn0QhEwr2mS6; Tue, 17 Dec 2024 09:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734428089; bh=wSjX9WLP8G/CpiJV3A+YyrZ3lZplv3XGyo+yd5lLDq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLs4+xIMsnGtZRuNsewsQds9pbLFglNr5P2jXYs5sxuvJnkjcMqo/htEqU9miKR+g
	 1aU5c/VgKAA3jC6YnD0JgAX3vKJCgdQTZZ/OPyCRf7oReMDAgw4GJJnfxSIE4Jwf4Z
	 Z2jawIXv0tZZ7zpjH/mqkWRoA0MfMODI4onvNBvIR8gkeeNLzJtFcq96rx+GePuHXW
	 toDUMmkwNto6b/9O+HEt0oPrZ9dRUbXAnTPj31DM0h9ncF/XGRQ/4NNBcrIsvYdoyo
	 duZyTXoWXtrXIyJy4Wrj/M7zxTRUoPDu3wnIBR/F9Bw9vCztElHFRi80lcNlCglxYZ
	 T9pwZ20oZAYO4uW7P4lqJeAbD6dn3n1nWXMZUin6c5qVmgAEOkLZJnxhYynWnY9dD5
	 +UK2he33HengycfUlc5yrqEzYiErjsTIJvEsPvP6sBQEpNSw2CjPvz+WqIH41bn4sb
	 gUolDl/uSKakDWsK6M/UySh4zhxJHhyHviv78DsxjYdut5GIrNTT4C9NWa0mmY2BCM
	 kyERc40gqpUeBXapIz2p5DS9LiF5OKiaQ5xrgzLnXUWPBEsllCmriqcsaJ5GP87JrQ
	 pfM9Ja4mTp7lR7Qtsd0zVYgIQVbTE641tM0aUfeZZ8DXpH0gZsoMaQFQAtCyFfdIBY
	 /wwUmh3A1qz1ln+EUb0jwKZM=
Received: from zn.tnic (p200300EA971f937D329c23FFFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:937d:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D275440E01F9;
	Tue, 17 Dec 2024 09:34:40 +0000 (UTC)
Date: Tue, 17 Dec 2024 10:34:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20241217093434.GAZ2FFqiC_pFimdoYu@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z2B2oZ0VEtguyeDX@google.com>

On Mon, Dec 16, 2024 at 10:51:13AM -0800, Sean Christopherson wrote:
> but I don't see any code that would clear X86_FEATURE_SRSO_MSR_FIX.  Am I missing
> something?

Ah, you want the toggles in svm_{enable,disable}_virtualization_cpu() to not
happen when the mitigation is disabled. Yeah, I guess we should clear the flag
when the mitigation is disabled...

> Gah, sorry.  I suspect I got thinking about how best to "set it only when really
> needed", and got lost in analysis paralysis.

I know *exactly* what you're talking about :-P

> To some extent.  But I strongly suspect that the vast, vast majority of end users
> will end up with systems that automatically load kvm.ko, but don't run VMs the
> majority of the time.  Expecting non-KVM to users to detect a 1-2% regression and
> track down enable_virt_at_load doesn't seem like a winning strategy.

Yap, that was my fear too.  Frankly, I don't have a really good answer to
that yet.

> The other possibility would be to wait to set the bit until a CPU is actually
> going to do VMRUN.  If we use KVM's "user-return MSR" framework, the bit would
> be cleared when the CPU returns to userspace.  The only downside to that is KVM
> would toggle the bit on CPUs running vCPUs on every exit to userspace, e.g. to
> emulate MMIO/IO and other things.
> 
> But, userspace exits are relatively slow paths, so if the below is a wash for
> performance when running VMs, i.e. the cost of the WRMSRs is either in the noise
> or is offset by the regained 1-2% performance for userspace, then I think it's a
> no-brainer.
> 
> Enabling "full" speculation on return to usersepace means non-KVM tasks won't be
> affected, and there's no "sticky" behavior.  E.g. another idea would be to defer
> setting the bit until VMRUN is imminent, but then wait to clear the bit until
> virtualization is disabled.  But that has the downside of the bit being set on all
> CPUs over time, especially if enable_virt_at_load is true.

Yeah, I think we should keep it simple initially and only do anything more
involved when it turns out that we really need it.

> Compile tested only...

Thanks, looks good, I'll run it after I get back from vacation to make sure
we're good and then we'll talk again. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

