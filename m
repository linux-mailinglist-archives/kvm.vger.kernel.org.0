Return-Path: <kvm+bounces-21963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CACC937CCB
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 21:01:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 483B4281983
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 19:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C7514831C;
	Fri, 19 Jul 2024 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOu0Xztr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B2145B25
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721415691; cv=none; b=tgTlkNqy2Um/Dz2ffl3gOGGr6dRl0mYk1wwm9nlSjVHoO1EFmGFm/nFs+HW303cbwcxlEwEcid2GM9awcc6yi9IlZ4wolrdaBQ8729jfXcIInjLmc6Ff/P0hPnMGQWvMl127vxjWKUpNtjBUq7hdgqPct63Ry6+5Ah+H6nyypHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721415691; c=relaxed/simple;
	bh=Gg6INx0MEXAjT2LzKZUyPAqI1dMbmA4J0mTophETl7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s+dMxaxNqb4H82P0mrfEJMUulL31tAFCvGdvBUsRlxeIPVTRLwhMtGZ8WCy9We1BuVt6Dp0AaSLHGeTZMgXSgD0vPRp6/DD7CUEgSOgfIX2idj3qpFAFdqVPahDNEFMpcD5pqUYJx2j8Da7G9A84J1LL+X2Vzd+S5462HkggG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOu0Xztr; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc4fcaa2e8so21590765ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 12:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721415689; x=1722020489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OM4td61TX/rzKbok6j5iyLHkRN3YiQLaYhOn9MCeYqE=;
        b=GOu0XztrVhZQfIKd4Wp89Z5B1Ym5SYzLu90AfIvFhjXo2xQEQD4PXNMjJN+Zgf/Euk
         h0frsCLBpXzOTs4DmCLn1XPl2OoHE4CksBTlqiLNlp7JbXWkoB4eyRQr3T11XJm0Niu0
         Aa3ux/xUpcCR25clV9ors0kQ5ozYgmV9cSTJrsl8Fj5qGHnopjWoiSzrv/8HIT+XAzsp
         TJIv5Gk+COzuyllkkkH8IxHyyzJ10i8+FEB5O8D5b3CKtACHmYhdOtQBuwshjNROaGAg
         XahXiKJitbW+dJnvvHrMozzKurw5tlWHcWaIWzOlv7PsFk/1Az8/Aws9FD2pTVDxks2o
         IDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721415689; x=1722020489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OM4td61TX/rzKbok6j5iyLHkRN3YiQLaYhOn9MCeYqE=;
        b=eaBxZhlyv3ucPeGDCApYfamXEWcVoJ3114H9Fpxeiiod68EXIqrIKfxawF8M7FuwQe
         PfEJ/zf1KBuDk9xoE5RAxiatJ9bLrjwE4BdbgAQbb3w883PwO4m9SNb/OhKL4kvg28+m
         rrvaNg7qx7bfpdwGdLt0MF8YySOH6hXrFF7I3XF5e/PbAPoof5eSlJnPZWOu/teY/4J4
         AyqvjPEPjXKawen6A3PlTgHQX7PrPV0uRdut+E4UZBE4SuQnsN4t/1c0gMI/Bj1gYbIT
         g+xim60WvPWzVc+8e0n1J7EKkEoQM0RXDqpg4lRBG+QS66GmbibmGnJ7v+xFmvSEALOi
         QduA==
X-Gm-Message-State: AOJu0YxMYkWep84X6NQ6j2jyPiW3FWze58dAg/CI7aBG/Uw6m/LyDR5o
	uV9b3cSmqX/CgVqurQ96fz0FkMiDvtydMEiE2lqcYGUlu+HvXxIFUPV4UN3GbDYANa3EmJNHA/c
	6HQ==
X-Google-Smtp-Source: AGHT+IGOpDdfnJiDu/5vSzdBdD/CewLyKCGvGPYzKJDAh6d1yeR+iW+Lm8Gcv2AaajmD9LK3arNE+M59oao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e885:b0:1fb:67cb:809f with SMTP id
 d9443c01a7336-1fd74607f99mr622305ad.12.1721415688856; Fri, 19 Jul 2024
 12:01:28 -0700 (PDT)
Date: Fri, 19 Jul 2024 12:01:27 -0700
In-Reply-To: <1eb96f85-edee-45fc-930f-a192cecbf54c@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1eb96f85-edee-45fc-930f-a192cecbf54c@gmail.com>
Message-ID: <Zpq4B2I1xcMLmuox@google.com>
Subject: Re: [BUG] arch/x86/kvm/x86.c: =?utf-8?Q?In?= =?utf-8?Q?_function_=E2=80=98prepare=5Femulation=5Ffailure=5Fexit?=
 =?utf-8?B?4oCZOiBlcnJvcjogdXNlIG9mIE5VTEwg4oCYZGF0YQ==?= =?utf-8?B?4oCZ?=
 where non-null expected
From: Sean Christopherson <seanjc@google.com>
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	David Edmondson <david.edmondson@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> Hi, all!
> 
> On linux-stable 6.10 vanilla tree, another NULL pointer is passed, which was detected
> by the fortify-string.h mechanism.
> 
> arch/x86/kvm/x86.c
> ==================
> 
> 13667 kvm_prepare_emulation_failure_exit(vcpu);
> 
> calls
> 
> 8796 __kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
> 
> which calls
> 
> 8790 prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
> 
> Note here that data == NULL and ndata = 0.
> 
> again data == NULL and ndata == 0, which passes unchanged all until
> 
> 8773 memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data, ndata * sizeof(data[0]));

My reading of the C99 is that KVM's behavior is fine.

  Where an argument declared as size_t n specifies the length of the array for a
  function, n can have the value zero on a call to that function. Unless explicitly stated
  otherwise in the description of a particular function in this subclause, pointer arguments
  on such a call shall still have valid values, as described in 7.1.4. On such a call, a
  function that locates a character finds no occurrence, a function that compares two
  character sequences returns zero, and a function that copies characters copies zero
  characters.

If the function copies zero characters, then there can't be a store to the NULL
pointer, and if there's no store, there's no NULL pointer explosion.

I suppose arguably one could argue the builtin memcpy() could deliberately fail
on an invalid pointer, but that'd be rather ridiculous.

