Return-Path: <kvm+bounces-41657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E0DA6BBCE
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01580188E37B
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077DF22B598;
	Fri, 21 Mar 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WcdIWNPL";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="F3+dYTwT"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F5D216E01;
	Fri, 21 Mar 2025 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742564317; cv=none; b=B47CBFU1u11VRnDogGYiynhOF2/8JPJnux3Eyw7dNOW289sID7AKpL3jgq9cA8xrMWNT9MlPmkrLMlSld+WhHVKCCMIGuPk8TFZfqCcfy+GvAd3eP1g4ARbqDGAG61+S70n9tbA2Y7e4AUpOpeKT5yKgYcfW4LldpjhWTZKkJWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742564317; c=relaxed/simple;
	bh=x1dxC51lbs6jPFuApurZIzSFJ8UWR3D48O+QX2y/E88=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K45ctvCBkmD+XhBLq+WUAPTXEvAnEZ/o3DXIwfACAtyINblFknEYaPF702IhJfpMhgQZrz2TUBuMv6RPGz6lGiMsh6IoDL3naoTpu9UQVE+DQJrWTYvvpJN2tbQDJ+uo7YMaF463Kob8IO3bDyQw+ftcoY0gqbyNh29F0UYdNow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WcdIWNPL; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=F3+dYTwT; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742564314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2bZMkMal/b569eRfIDoJCT9zyRtoqlj1ERsu3Rhnr8=;
	b=WcdIWNPL+1+Bznv3fucQBiLMqGZlJ+iYJKGJtVkumzEcjnByzfyCrY52kIwHR2DQ9L8l8d
	wO0Q37x48tzY+52mIZahOfZ/0Oes8+M+gWu9PuxN3VOgmEqEGO8l1YgaBiayke2p3ovNne
	pGB2rj4zEucKgf05vAbOlALg0mQyoPCMXWXb8oEo38KYUSh0qICiMPaMtM5orE/tnY0qP3
	Lup00elYTnqk6UkU9EEd8KFplF38qcYPaPHJksVjuc4VyuCEK4V6TaG7rbrjbxm6u/Fdub
	u+QvUKVV5YkCryA6WuWPS3kjIk8jqOZqVGUF8x+kTOIJNXMhUzrxRt5/qY6Awg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742564314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2bZMkMal/b569eRfIDoJCT9zyRtoqlj1ERsu3Rhnr8=;
	b=F3+dYTwTm9IE9zps0ypJY3Qy4jlDEqH24QnvafNRgODWzEjAJjlqD+kTm1ny4gGaIjepuG
	nB8+9//ElYjWnCAg==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 03/17] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
In-Reply-To: <20250226090525.231882-4-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-4-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 14:38:33 +0100
Message-ID: <87plia33mu.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:

> +static inline u32 get_reg(char *page, int reg)
> +{
> +	return READ_ONCE(*((u32 *)(page + reg)));

This type casting is disgusting. First you cast the void pointer of the
per CPU backing page implicitely into a signed character pointer and
then cast that to a u32 pointer. Seriously?

struct apic_page {
	union {
		u32	regs[NR_APIC_REGS];
                u8	bytes[PAGE_SIZE];
	};
};                

and the per CPU allocation of apic_page makes this:

static __always_inline u32 get_reg(unsigned int offset)
{
        return READ_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2]));
}

which avoids the whole pointer indirection of your backing page construct.

Thanks,

        tglx

