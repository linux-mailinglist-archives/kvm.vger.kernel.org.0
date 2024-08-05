Return-Path: <kvm+bounces-23266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7819948569
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51DFD1F23659
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D30C16E892;
	Mon,  5 Aug 2024 22:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="akVuPyyz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7953214A096
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722896243; cv=none; b=NM9xFuATKywMtLuABnIG0/FLuyY2glLPrjZafDMl0mt/xGjt9IZkHqZcQUhFEHU07u8WfV8zWWzjiG3tXGsIxB+HZ4Six0UPiTheHBKbAl7IlO8WxySww7JFvgvdUvx4Y0QADq/Ox6eALFR4ml/2yrz+aGn/V7MnNX/wklDyxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722896243; c=relaxed/simple;
	bh=iRKECyrkvrA1b60BNSEXzwNDg331WnDXiH6+hBJHOug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pxiCj4a7D3t/NLRSDWiomTpMIQaBqcZjwJRF5DuDFwz6UtmUmXqqOjhHhjqCH6XbBruDgdny9He2js3iglY3orXfRgSoyXWHoL/tDVZDbP1OVJuj6+ELg+/nAHuJeYl1Yb3Z3g90/HHeKkqRd+NED7WVA21uaEa5XTWUq6ChVdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=akVuPyyz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a1188b3bc2so9172239a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 15:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722896242; x=1723501042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=301Af552xFNznyaDUGO1KzNgRSOsf/7QBRYuWkDsi3c=;
        b=akVuPyyzFt7PNXn/6yAdWHyZVaZHiOxl0MMLBjkj90WGe2Qbi/mLUtIQEJ55YUr6Fh
         M0LFuR3MS3tfzBz3CddWtFDeSnACtN9sUCy5KFnFmTiXcZE1cUomaN6Az4EtUKZ3Qbps
         qjeGGullmZNrcldOAuNE+q2v6s2DAt6G3G59gorAeoruykgtWWfPyQo8OLLmxgoqzSmA
         ERch+qaVUgBhmaoD2hAnRCjEw913LDfqiYS73dvspq6Jm75iZMRXb7MmfNqbX/GBzfyo
         2jJnpr/WiOdW1tA8i/+orc6Ytpbq9hlRWgqY5IZJf9VcXQat+GmLPmq+De25xSXLqFyH
         7+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722896242; x=1723501042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=301Af552xFNznyaDUGO1KzNgRSOsf/7QBRYuWkDsi3c=;
        b=qsDoSortbXPm4d7aFVMhvU6OlQ2/0ogLvwlzTggNGcZzWqx/IpUtbqdPMrc5iMCYmo
         yMfE9ZTMsIW6Rne+Cn2ZlDADfaSwB4/Q6tkkQU6zV8azK19KdfhiVLiN/hFXZuqN7NNu
         fSvqyJLuCITzBVNe8GTHTmUCflpj6fWKPSkwWpEKqYq3OZqwTnqPs4m4eTINVj/9jzwR
         HDSvCSq5ZbciDfFA53JiuMP0h92FLdjimUxGJDMwGHz4MqOZpQ44/aFHEzD1cSqKY+I2
         y2Mpp8XsrgWO+fJZn7Z5eotXDl/lsmEBXzi3wNdkvOuxP8tuzXiUS3yc6Glh6e4TANQ4
         Wc3A==
X-Forwarded-Encrypted: i=1; AJvYcCWWG8VyxWULxT66Xnfuk+ZhFgjI0EQByzCqNlRxRYPUJdQe3G61NGVMslXipKNSHri2A6H+rAXhG2nWbU8Ex9sEo/wB
X-Gm-Message-State: AOJu0YwdfyuTQJTbXEn444rQ2cNjT1/iDOQG6/IutKa6eApPmmtYqd7t
	mMpSbf21amuc1gptB55I0rvDaVrxoVeCdqOLjqSuBECO+DY1VENQKmMS3gblTeuaKXebRG3YUyR
	zbw==
X-Google-Smtp-Source: AGHT+IHZvKThkZKhtE5tJIz9oLqGFkOkw4wwlz377TZAixmae6KcD/8s5cb7ALAVhMwC9fFwcm7DTo5ozMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4185:0:b0:7a0:d530:86b8 with SMTP id
 41be03b00d2f7-7b74669c700mr25239a12.2.1722896241604; Mon, 05 Aug 2024
 15:17:21 -0700 (PDT)
Date: Mon, 5 Aug 2024 15:17:20 -0700
In-Reply-To: <20240805072013.i3ib4h7eadlzzglm@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com> <20240801183453.57199-6-seanjc@google.com>
 <20240805072013.i3ib4h7eadlzzglm@yy-desk-7060>
Message-ID: <ZrFPcJvYMpv8BH30@google.com>
Subject: Re: [RFC PATCH 5/9] KVM: x86/mmu: Free up A/D bits in FROZEN_SPTE
From: Sean Christopherson <seanjc@google.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 05, 2024, Yuan Yao wrote:
> On Thu, Aug 01, 2024 at 11:34:49AM -0700, Sean Christopherson wrote:
> > Remove all flavors of A/D bits from FROZEN_SPTE so that KVM can keep A/D
> > bits set in SPTEs that are frozen, without getting false positives.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/spte.h | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index ba7ff1dfbeb2..d403ecdfcb8e 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -216,15 +216,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> >   * should not modify the SPTE.
> >   *
> >   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
> > - * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
> > - * vulnerability.
> > + * both AMD and Intel CPUs, doesn't set any A/D bits, and doesn't set PFN bits,
> > + * i.e. doesn't create a L1TF vulnerability.
> >   *
> >   * Only used by the TDP MMU.
> >   */
> > -#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> > +#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x498ULL)
> 
> Question:
> Why bit3 and bit4 also changed from 0 to 1 ?

Purely so that more bits are set, i.e. so that KVM doesn't rely on one or two
bits to identify frozen SPTEs.

> They're not part of AD bits fro EPT and CR3 page table/AMD NPT

This is very delibreate.  The A/D bits need to be '0' in the FROZEN, i.e. bits
5,6, 8, and 9 must not be set in FROZEN_SPTE.

> 
> EPT: Abit:8 Dbit:9
> CR3: Abit:5 Dbit:6

