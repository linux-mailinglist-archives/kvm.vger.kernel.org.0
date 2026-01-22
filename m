Return-Path: <kvm+bounces-68879-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KxxGHYNcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68879-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:43:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB5D662BC
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A99BB8C165E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE30413250;
	Thu, 22 Jan 2026 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="h8rkTjJo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B840F8D5;
	Thu, 22 Jan 2026 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080398; cv=none; b=rYCaFla2yuLrFlnKBzaMpWTcoPwim1MMWcOBPY97+P0zbZ3XuIaeSpKqFxSvg7LzIqMU+Vze9UcZIyBDeeyP/hPYT0ql6VqgT2E4GxZt7vocSXJiW5AtxjIe+TpqrSfGj13kVQMZwJhk5m9Lgd1jKtuCYmrKg/1ry4/ElvPezqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080398; c=relaxed/simple;
	bh=8BhYCRFSZlXehtUzeBJkl0NyILoPaceSRDSZe5TewRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmYHpK1PuLkYQCWdiYsUWIkjb+6c/rXHp2AVdLzk9IlP0OccI6KkE62HVrJWatnJObS0l33r4JUy6biqMZqmijfvi84eLzv3/u38e31m+mO8sCcVmk2nxqq0FufAiupEmdJfKXZmWrmGxW58axNNk2bDOncyCDjEInyi9iGSyKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=h8rkTjJo; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 31ADA40E02E6;
	Thu, 22 Jan 2026 11:13:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cMOAQ70Y7nmQ; Thu, 22 Jan 2026 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769080389; bh=rQbs3zV9IYOCHfIshoOTwAY3jfQletGN3RuhoonZEDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h8rkTjJoVfpc1wSmAHjlWEw5c6XdFoTsmWhkemq4gmFVFzSkwpRDyaeE7Z5BaHzF+
	 KSYg3EzuWmjpcv1rs+srGxHoPI1O38OdTOnC1nENNjPwp9k3H9TwTwNBG9c0XrM8j/
	 x1F8hoba2esy7uQ1dvK6LbhJsCRSWPl2DiB/Jofp+SB3/qf97ju6tANayFb2Fu6CUT
	 5QnDkQAiZb+wn+TPWvw501m6m3aTEn8SRuhrr3KFJjNCjW3/YcRjmskHDHmXRg/VUH
	 KLRmJS9QVN4YQGEzZQwKQ6qA2mbStoeqlzw2dpFSObI/yZP/fK67VR98jppLNbpsIF
	 uC7TSWLz7/JKAb1ps4+NuvDCChcgoIKtXrrJaKHHrXkXijXCOTz2S8GhvlBqbo7boC
	 d4nE0vW91Tiv1plZvcmJ1+rVZ73a47AFIsKju8yufiOs9EIDx6iRQOSPI1fq2n9yCd
	 An0F5jldtwo2oS8OLByIKEittlSfIiXcf3ZWm5m4WRFacFoedxQKqicbQqLDfax5+D
	 NodCRyYl7OaV0TCWbIeaWVH9KR+7vsnHB8dNgzf7dH2w95ZdIAswRoh9lnc5bPkmDk
	 CnbkQ661A0+ig2NGfFOhO3ZB5HqqRqc0TST+FhzDaB5NYAhsum/E5dn3ZOBVPv3Fct
	 u4FA1Zp2lQT85gPBDIkVn4yM=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 701E340E00DE;
	Thu, 22 Jan 2026 11:13:04 +0000 (UTC)
Date: Thu, 22 Jan 2026 12:12:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Message-ID: <20260122111257.GAaXIGORy84Y1IedxR@fat_crate.local>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260116122246.GBaWotlmNRCkKFA-MU@fat_crate.local>
 <CABgObfaxsOA301j1hb1jSEZie3v3bzsW=03PcjqQ5RWynSN1aQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABgObfaxsOA301j1hb1jSEZie3v3bzsW=03PcjqQ5RWynSN1aQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-68879-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[alien8.de,none];
	DKIM_TRACE(0.00)[alien8.de:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,alien8.de:dkim,fat_crate.local:mid]
X-Rspamd-Queue-Id: DEB5D662BC
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 12:35:50PM +0100, Paolo Bonzini wrote:
> It's a fix for a host crash that literally adds a single AND to a
> function that's called fpu_update_*guest*_xfd. The patch doesn't have
> any effect unless KVM is in use,

No Paolo, *exactly* *because* arch/x86/ and KVM are so closely intertwined in
some areas, we should sync on changes there. And judging by our questions
on this thread, one of the aspects were whether the handling of the guest
state is adequate enough. And if it is not then we have to rethink it and
accomodate it.

What we definitely should NOT do is solo efforts without even an ACK.

We've had this before with the X86_FEATURE gunk and we're back at it with the
FPU.

> and on any task that isn't the task currently in KVM_RUN (other than by not
> crashing the system). So, because of the effect of the bug and the small
> size/impact of the patch, and the fact that there are really just two
> approaches and both had been discussed extensively on list,

Not by us.

> I accepted the small possibility that the patches would be rejected and
> would have to be reverted.

And all that smoke and effort just because you can't simply wait for us to
take a look. And what happened? We agreed and it is all good.

So what was all that rush all about?

> If I really wanted to sneak something in, I could have written this
> patch entirely in arch/x86/kvm. It would be possible, though the code
> would be worse and inefficient. Sean wouldn't have let me :) but

In my experience, syncing stuff with Sean who takes what and giving each other
immutable branches to use, works wonderfully. Why can't we simply stick to
that workflow?

> anyway that didn't even cross my mind of course, because sneaking
> something past you guys wasn't something I had in mind either. In fact
> I instead plan to make that impossible, by making fpregs_lock() not
> public and reducing the API exposed to KVM. I certainly will not send
> that change to Linus without acks, even though it would also affect
> only KVM in practice.

So how about we do only that from now on?

> I would be ok with a Cc and sending the patch to Linus after a couple
> weeks, yes, for a patch of similarly small and well-defined impact.
> For example I didn't have a problem when commit b1e1296d7c6a ("kvm:
> explicitly set FOLL_HONOR_NUMA_FAULT in hva_to_pfn_slow()",
> 2023-08-21) was sent without my ack.

It happens. We talked with akpm recently and we'll separate the
responsibilities much better and by the looks of it, it is already much better
this way. I'd suggest you try the same.

What is really annoying and counter-productive are the unsynchronized solo
efforts so let's not do those please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

