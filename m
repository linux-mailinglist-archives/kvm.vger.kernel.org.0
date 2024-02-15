Return-Path: <kvm+bounces-8817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12ADE856D21
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA3CD1F2210B
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB8413959A;
	Thu, 15 Feb 2024 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IUPyxFP5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F98E1386C2
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 18:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708023024; cv=none; b=eBUdEcKvaMzCvZtVaK47d3yeC1nTYoUQmgP94+cX9Fj2nUV3kbY4k5SWT8zIDdyFcGH2XXkt337qdoK71w6zcrAKeSxmbyh2Vf8lv89MMw5rZ48GFG3uf8QDh8e/UjhwCuFlEYqX1ojIqzwt93Co2MVrqENSm1g2IhExZqKWavY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708023024; c=relaxed/simple;
	bh=JpEzUCBeX+owqBCYPKaXJjOzHnXj1NY746oEq9OlCi8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wb5r2BKeztJp96YOWC8it3vLAZb/V/wGSsIjWhDeVo5HxJYfFHhqwOy0+mM7bwv2xTarSjP6XpRsz9gDkGz+OWnL34IEIWMQcWcN4j0SUAy2mHIAiO/YGMZTOn2S4+FSoqdwr1FR0Ru95CIE6uvigeXvTh72xSPK/pZyCaEWfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IUPyxFP5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0a67a5de3so1214277b3a.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708023022; x=1708627822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S3bMta7GBZrhe8IxMh4Lf+am/5b/Yofjvcb78FJ+XDg=;
        b=IUPyxFP5HPnTZOHOgf+RafJFVwgQAZeJHXuLBJwY4DLw2mD8sRMxpkBL/kqukNNXKo
         RhnvWGFe8Uf2rT7Kuf1FrPj6cruPUhmRz72uclEXA1LULPrtb3Jd3nlYmsvHgYpAkmYC
         x160mqY+Txxc/PAp/W0WNaRt56z9qQaPxlnd47NTu37BYqZ/Romturcg6wgwtwCoRf+n
         Apy1J1LNEsh4W6T4DQE8IEMlwNEAOFmSqye90Lp228zjqTyGc3+TqEshUv+jdLNCpb33
         3O7WEhr8KA+uL+aijCPqpjfJqt6N9+XOQi/+ZzapTiK4T9rLJISTE5ieI/qrbkhQkoS7
         W8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708023022; x=1708627822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3bMta7GBZrhe8IxMh4Lf+am/5b/Yofjvcb78FJ+XDg=;
        b=KrBUVh3gtZh3vrrxVsbsBiKzFZcXIgCwTLXF+G8KCXVg5iHwTN5fWAwNStvmctVo9L
         JG4w4qGy8CCkpiwBkZtmvR3L6HX9q7iCA6kLc9a3LzbpU/nzF+jG+H7kIX5m9waFRoWx
         YeS6JS9gkJ1LFcrfgCuUaME6YGUTv38gi7jUkSjCTerKxt8fWKG8C67S8h9E5FkGK6rx
         E09eMRog+Kno5qhn1SyBVkjShC04jMTq6IKeeOq0jHUmx/64fS2KnD6VcP8SuLGrLdTw
         zrum8vFwZ8RweJvsNHdmqLkvuckslS7VMgXLswJq6154hwB7My/Ru4QJNRkK9xIbpitI
         IYzA==
X-Forwarded-Encrypted: i=1; AJvYcCVROwO/tFvuHVfXUJzz2gsmaZbR07y4Rxk7mnX42s+pruIiPx5FEHI+Dws0CnOWxuvp0S+7g5L7ylFA0fUOJc6cByHH
X-Gm-Message-State: AOJu0YygXuOpUYEk8kGem66mdoy19+rsC+HSckIZ3jAau5kHuzUtMx8C
	rqiSojWTl8wbMSMCcTgf8vwM9X6KLNK784ZscoGer5GdW9N3Wd1tVm1uVz5tcDBvbGUPf2BkKi8
	lpQ==
X-Google-Smtp-Source: AGHT+IGAr8CFXsoq9Zfz/iCW9/M0F+HzczG16axpvRh8uinokkjMkkzuQYAfnpmSaSbkeniZmnVdSVdtwLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d29:b0:6e0:e2f8:cf3c with SMTP id
 fa41-20020a056a002d2900b006e0e2f8cf3cmr110511pfb.3.1708023022352; Thu, 15 Feb
 2024 10:50:22 -0800 (PST)
Date: Thu, 15 Feb 2024 10:50:20 -0800
In-Reply-To: <Zc3JcNVhghB0Chlz@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215010004.1456078-1-seanjc@google.com> <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev>
Message-ID: <Zc5c7Af-N71_RYq0@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Oliver Upton wrote:
> On Wed, Feb 14, 2024 at 05:00:04PM -0800, Sean Christopherson wrote:
> > Add forced emulation of MOV and LOCK CMPXCHG instructions in the dirty log
> > test's guest code to verify that KVM's emulator marks pages dirty as
> > expected (and obviously to verify the emulator works at all).  In the long
> > term, the guest code would ideally hammer more of KVM's emulator, but for
> > starters, cover the two major paths: writes and atomics.
> > 
> > To minimize #ifdeffery, wrap only the related code that is x86 specific,
> > unnecessariliy synchronizing an extra boolean to the guest is far from the
> > end of the world.
> 
> Meh, I wouldn't say the end result in guest_write_memory() is that
> pretty. Just ifdef the whole function and provide a generic implementation
> for the other architectures.
> 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c | 36 ++++++++++++++++++--
> >  1 file changed, 33 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index eaad5b20854c..ff1d1c7f05d8 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -92,6 +92,29 @@ static uint64_t guest_test_phys_mem;
> >   */
> >  static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
> >  
> > +static bool is_forced_emulation_enabled;
> > +
> > +static void guest_write_memory(uint64_t *mem, uint64_t val, uint64_t rand)
> > +{
> > +#ifdef __x86_64__
> > +	if (is_forced_emulation_enabled && (rand & 1)) {
> > +		if (rand & 2) {
> 
> Can't you invert the logic and drop a level of indentation?
> 
> 	if (!(is_forced_emulation_enabled && (rand & 1))) {
> 		*mem = val;
> 	} else if (rand & 2) {
> 		movq
> 	} else {
> 		cmpxchg8b
> 	}

Yeah, the funky flow I concocted was done purely to have the "no emulation" path
fall through to the common "*mem = val".  I don't have a strong preference, I
mentally flipped a coin on doing that versus what you suggested, and apparently
chose poorly :-)

