Return-Path: <kvm+bounces-33870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE5F9F3799
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 18:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E37C1889272
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0C12066FA;
	Mon, 16 Dec 2024 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GqQmfHgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFD613B792;
	Mon, 16 Dec 2024 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734370324; cv=none; b=LimDjp2fNqJTlBnrYl7nFn9Qf5CF/JygeNwjGN4pO6TkFcRJs5sS95dxCnv5ozFAIt+qb846QyRar7OZ98Mxk/YY09Dl1A18EQF3ktcgJildnEmix7bWfaXLLBZRgRr6SrVSHG+mKhk9KV9vNK02vFNIqD5idGKKLMVtywkZ2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734370324; c=relaxed/simple;
	bh=o/W2DbU65821bvpqtQrpHdNaRHfLttY8EE5Dv6fIJmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=un6mQXFNTXTVn0KHOy5BfnvY6IM5u8Mv6fJ26oRgX4d4NbJ1HJoF/J1Yb28SQuRtohzbZ6JnQN4Aw/JW+rLVaB2Gbmycq2ArbrWR9+OVPNhAnmmgbXI7SfIDRWdnMCRS+zJI9x+jJRap84zk9qv4SkeliwhiqhHs9/hmQDf48AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GqQmfHgX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 60EB540E0289;
	Mon, 16 Dec 2024 17:32:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cRl3I-9wi5Xk; Mon, 16 Dec 2024 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734370316; bh=GDtudFXSVya7QYgCHTKdUi4USIyc9uBaJ50iDVdQh/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqQmfHgXu3lcL17X0I1MDlnw8K2Kkhk6LF+WDGThB9Wy1WzqsgcZe4WqGXBuqZd2M
	 Q5OvjT1e+TknFjWaGiuRwJ27rsJiS6upkfTFNSh6hGZnlMpS6juk/uNJiL/ZMWd04x
	 AqmpqAZKNzwcldsjsiL9BPfqMgDUu7urZYReZYZjQBpGRrP6wSSvebpDYCxgYGjYyl
	 fjjjIAusgQWCvC/2YXkW3Ojv7jnoIbet0G5WCnZHcTJ2Z2cWpM0JVMe2SYyN8TgLUu
	 aIVEFBDnRHn/d7vLOwmKDC2dokQahC13Qtn7ksul4a0eTstDssealq7/8duNL6FSqw
	 PZ4Q5ToiKmyqBwLoIJJzWJx/TOSTcjnJ4AWEvCK/ZH0bf3GYUb0i8srzH2dWT4g0yF
	 /hldbhe8dK6skg5yOBja0rs52ZeBcxuZmIpPkWfgYggrVYGisqBA9JnyL3+BRo2hk1
	 Mhdj8Bda31NA79NFT5S2+D/pDAI+qePKGC06OaofW7Bae5FEAKMb+yqzAAc0p3IHoM
	 LeF3jNcEtdvv1mNecotJ+Hmie4g/VkQ88+6O+Ijbkbb8UrZOEoThKkbaLpGjxDMVIS
	 I9sgCbTVlMXib+g21OMMPYkDuF//21ojJaEVN4xv5Y64gIvMlzic/5xaX2LShMUor6
	 cJC/L8bNAHR1ssHTG5mqoq0s=
Received: from zn.tnic (p200300ea971f937d329c23fFFEA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:937d:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C37840E0288;
	Mon, 16 Dec 2024 17:31:48 +0000 (UTC)
Date: Mon, 16 Dec 2024 18:31:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1oR3qxjr8hHbTpN@google.com>

On Wed, Dec 11, 2024 at 02:27:42PM -0800, Sean Christopherson wrote:
> How much cost are we talking?

Likely 1-2%.

That's why I'm simply enabling it by default.

> IIUC, this magic bit reduces how much the CPU is allowed to speculate in order
> to mitigate potential VM=>host attacks, and that reducing speculation also reduces
> overall performance.
> 
> If that's correct, then enabling the magic bit needs to be gated by an appropriate
> mitagation being enabled, not forced on automatically just because the CPU supports
> X86_FEATURE_SRSO_MSR_FIX.

Well, in  the default case we have safe-RET - the default - but since it is
not needed anymore, it falls back to this thing which is needed when the
mitigation is enabled.

That's why it also is in the SRSO_CMD_IBPB_ON_VMEXIT case as it is part of the
spec_rstack_overflow=ibpb-vmexit mitigation option.

So it kinda already does that. When you disable the mitigation, this one won't
get enabled either.

> And depending on the cost, it might also make sense to set the bit on-demand, and
> then clean up when KVM disables virtualization.  E.g. wait to set the bit until
> entry to a guest is imminent.

So the "when to set that bit" discussion kinda remained unfinished the last
time. Here's gist:

You:

| "It's not strictly KVM module load, it's when KVM enables virtualization.  E.g.
| if userspace clears enable_virt_at_load, the MSR will be toggled every time the
| number of VMs goes from 0=>1 and 1=>0.
| 
| But why do this in KVM?  E.g. why not set-and-forget in init_amd_zen4()?"

I:

| "Because there's no need to impose an unnecessary - albeit small - perf impact
| on users who don't do virt.
| 
| I'm currently gravitating towards the MSR toggling thing, i.e., only when the
| VMs number goes 0=>1 but I'm not sure. If udev rules *always* load kvm.ko then
| yes, the toggling thing sounds better. I.e., set it only when really needed."

So to answer your current question, it sounds like the user can control the
on-demand thing with enable_virt_at_load=0, right?

Or do you mean something else different?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

