Return-Path: <kvm+bounces-25004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FBD95E340
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 14:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E136281F42
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 12:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D14214F9FD;
	Sun, 25 Aug 2024 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FhEsXY1d";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A851qVVR"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2425838F91;
	Sun, 25 Aug 2024 12:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724588228; cv=none; b=DYzeTCDEsOIPiglVvcJyguRfthexB7Qy3GFwTrdA1JrMzMTK2qlgdEmFsPR85XfwQH7O9aZnoip1TF30RzD4FwCRyWbN7cBsHw3HRX2JFOqCS+WpJ5MgWoiE+Uk6GayYc6njIxewNQ7OKe8fD7XmmAJgGIKxq4teO4Yr7MLz6hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724588228; c=relaxed/simple;
	bh=SNbfbbSUKrznPv18ybDcSGmA5gJHpDEIxpd5Cen4qvg=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JWfLZvzkx/ZmhwXfFkYF9CPQjmM26tfHtGgHS5WNQwyYfJtffPLRi08pxJf6BQ4u2sX7r4+ulOxSZ8SHp25d5oDoevu3+w1sxJxE6/N05nVulZVnvxBA0OVm6N8Pobo2wc9h8b7Z9FZmyVD0oJ5vNfI3TmRlVPBbzCvCnnPjzOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FhEsXY1d; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=A851qVVR; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724588225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AeNlc9u1Naz8RxKnWq+uaZlUoAL+ztVV3VZDXQn2oyU=;
	b=FhEsXY1dd4M5YmnIqNCh3ksXih5agOwvcSfiwBEoA0koDjCz34N69njzqXPATZ1CLSnCYO
	EQXAiBHiNldErggLmv7aGwVyhg+MvIropdb8aWSDwiKt+/H8iLPg0vITZED1TV7xeustsA
	1R9UD40RnvB/PgMmrbS/ueuFJLWvpKVLvNmtyR919TKi0/fJo0xEdxKoKiFAemhCiJXsTx
	WyFKhPPrIVChhHkM6F3Vl8qwAve+hyS249O22dAzuUoAzOL5cGKEMTfalNMIkFNCrhtPQA
	sNBUX8jw5EiobIXKKDCP5yS0twgJ1SQL5fYm3UzPiFAknobKaoClwiuDSvXolw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724588225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AeNlc9u1Naz8RxKnWq+uaZlUoAL+ztVV3VZDXQn2oyU=;
	b=A851qVVR+CazHNEDCAR7lFt1/o6edx0+is9z5Q5ZUUFjWlTuvzSWYLFy37qF1R9css5kuB
	ZckTk9SggzCqUqBg==
To: Jim Mattson <jmattson@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Pawan Gupta
 <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>,
 Kai Huang <kai.huang@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Distinguish between variants of IBPB
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
References: <20240823185323.2563194-1-jmattson@google.com>
Date: Sun, 25 Aug 2024 14:17:04 +0200
Message-ID: <875xrog5kv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Aug 23 2024 at 11:53, Jim Mattson wrote:

> Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
> terminology, the RSB). Hence, the older version of AMD's IBPB was not
> equivalent to Intel's IBPB. However, KVM has been treating them as
> equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
> platform that supports the synthetic features X86_FEATURE_IBPB and
> X86_FEATURE_IBRS.
>
> Equivalence also requires a previously ignored feature on the AMD side,
> CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.
>
> v3: Pass through IBPB_RET from hardware to userspace. [Tom]
>     Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
>     X86_FEATURE_IBPB. [Tom]
>     Clarify semantics of X86_FEATURE_IBPB.
>
> v2: Use IBPB_RET to identify semantic equality. [Venkatesh]

Assuming this goes through the KVM tree:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

