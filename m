Return-Path: <kvm+bounces-8913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8ED85882F
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 22:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C64F2B228D1
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 21:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C72136678;
	Fri, 16 Feb 2024 21:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="gAVIuj6q";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fFG6Fv0u"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBF61353E4;
	Fri, 16 Feb 2024 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708119949; cv=none; b=R3RpxczHHwLUOpD3NQosoBFrf8Jk7KyuZzsvDJWwqqIab0wdibgxZzalWmzPRCct8RBCB6ghBW4+GZ6JYa+KnK9auIrpFugJ+DO1+XHmk0qJ73YiHoHjOsH7MNupGSG5lkwc9DHlhw9uQFLolsC85ovb2+9NT5FYPwVOqXvLJ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708119949; c=relaxed/simple;
	bh=Mk0nxUw+sq35db+ZT9456aN5/fkc1vmq/3qOwOy1K4M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZiV6IaFQQN58flB8b+3uvKPRkEuR5LCj8O9oaFejo0HKsEhaQgmY2Mb5LeQakRQxXOyjSk3rs5Hm/2s9kyVr9asOuvAgAk0W1lE68g0cZL5jl9O2yyFelTiblgz2qkvxQR9Q4NFPF3VMfqc8O8S0FK0LQmdSmbR1nOgLvb4+syw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=gAVIuj6q; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fFG6Fv0u; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708119946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwgo5N1QWBMtShX9v3D2p+zgcQeVtP2GzdDLktsQC8=;
	b=gAVIuj6qniijsqgHgtIzLeiQgR3BMvBcoIEPyBGKmP+zphoPaMN3uCeMQpVzwLe3/RiFEp
	UZhZ5x70uxt5E4tB9R53WM/x6VohRsdB+2PV9HUuN338zr24EjVEzEprL/6ZSu7opblo0+
	bLUvyUMTnCW134TEkRLD0Us7i04zR17Ch6fNoYCIgdeppiNZZSbv9baFd0rm760cGZqQWM
	zNqcQYAwN3jIwAUlLSsmpoGMQzcMg51shu79JgwsKvaxu0RGKMepS+umoWN3/C2dX6gOmj
	W7fwaHcZveJlqPIfWqx+vzUaT5QAOwfgPig+BVZmQVgZ6+5cP6etJchZaflXXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708119946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwgo5N1QWBMtShX9v3D2p+zgcQeVtP2GzdDLktsQC8=;
	b=fFG6Fv0uT9s8hVazM4DMd94ET+uX8+bc9eWd1hNGvJMzF+aU064xWN5Hxft0bOsfnGLEs8
	u0zXOdvBmVkPJ/Cg==
To: Paolo Bonzini <pbonzini@redhat.com>, Xin Li <xin@zytor.com>, Sean
 Christopherson <seanjc@google.com>, Max Kellermann
 <max.kellermann@ionos.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, Stephen
 Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org
Subject: Re: [PATCH] arch/x86/entry_fred: don't set up KVM IRQs if KVM is
 disabled
In-Reply-To: <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
References: <20240215133631.136538-1-max.kellermann@ionos.com>
 <Zc5sMmT20kQmjYiq@google.com>
 <a61b113c-613c-41df-80a5-b061889edfdf@zytor.com>
 <5a332064-0a26-4bb9-8a3e-c99604d2d919@redhat.com>
Date: Fri, 16 Feb 2024 22:45:45 +0100
Message-ID: <87ttm8axrq.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Feb 16 2024 at 07:31, Paolo Bonzini wrote:
> On 2/16/24 03:10, Xin Li wrote:
>
> It is intentional that KVM-related things are compiled out completely
> if !IS_ENABLED(CONFIG_KVM), because then it's also not necessary to
> have

That's a matter of taste. In both cases _ALL_ KVM related things are
compiled out.

#ifdeffing out the vector numbers is silly to begin with because these
vector numbers stay assigned to KVM whether KVM is enabled or not.

And no, I don't think it's a net win to have the #ifdeffery in that
table. Look at apic_idts[] in arch/x86/kernel/idt.c how this ends up
looking. It's unreadable gunk.

The few NULL defines in a header file next to the real stuff

#if IS_ENABLED(CONFIG_KVM)
.....
#else
# define fred_sysvec_kvm_posted_intr_ipi                NULL
# define fred_sysvec_kvm_posted_intr_wakeup_ipi         NULL
# define fred_sysvec_kvm_posted_intr_nested_ipi         NULL
#endif

are not hurting at all and they are at a place where #ifdeffery is
required anyway. That's a very common pattern all over the kernel and it
limits the #ifdef horror to _ONE_ place.

With your change you propagate the #ifdefffery to the multiple and the
very wrong places for absolutely zero practical value. The resulting
binary code is exactly the same for the price of tasteless #ifdeffery in
places where it matters.

Please get rid of this #ifdef in the vector header and don't inflict
bad taste on everyone.

Thanks,

        tglx



