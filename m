Return-Path: <kvm+bounces-55081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B43D4B2D090
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 02:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A808C4E4C58
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 00:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69CE14AA9;
	Wed, 20 Aug 2025 00:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GOcR5Cjp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F41C27
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755648304; cv=none; b=RPHK/h6QV1TvCq/grI1Ol8eCTXlSUpEEgIL+o8htUJgz6m7uyecrXx39IV3rKv0GP9ALYvzPJEsYpMS2GxyvRNSFXefZVRDsMTYgnDYYqYB2F6FJakbQblNjemkXh/q1VAQmaF58ZDvWhoJazxk6gjs+KJlCWWy9eNRMupCQ6tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755648304; c=relaxed/simple;
	bh=Tfo/19RHyW++txmc1kMnAys7+aIQLnpLmNAqGrRJIgY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K59wBPIjIwtsqdgleB17mF6hvPRvAjpygNFJD97j6ZJgYbv+ZXwpxAJYomNab+tS8JoNFvt7jc87Icec2ZbKi03lSSphULnrmOKv7g+Fx82FzToTETPZYZ6K7xFkDql2fOiZVrazV0VXwUYz1YIi7lk7Yuh58nLmMUpIUnnbZK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GOcR5Cjp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471757dec5so10309115a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755648303; x=1756253103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9wXsk4jqFDa9XGwh3suMWyZDPKqbXwjavw0fzoWkQ8=;
        b=GOcR5Cjp4UvbAlbbMNvW7LsVP1Y/bCXJMcJDrTQt8Sas7Zh0+b3ARyzehbIqvD3nV7
         /yTXZDO32zOb1VvH87lwS2whyv1MlMkPoQTM2rs4PsEhAzyoxYoyY2WFqv2Fj23+093D
         PK3jpv4A4/wSKvTa+3JJJKtGyfkKwU2qq1nCcUa7tqOILH8IG3aOJ0b4uskgvMigbyNF
         KYiBS6jUSX7YsXUMVnSNG2E+nS6b4kQTluX1X1O4SXE/B8PwMsQAoLv4Rei64GrjryFN
         RpKA7BVMtlUnUxtTg5hBe1HZbNMn8ZhXvEdwjgbKUjrPiks9NEgRCPFV4PkqxamVl/7S
         Q7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755648303; x=1756253103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9wXsk4jqFDa9XGwh3suMWyZDPKqbXwjavw0fzoWkQ8=;
        b=c2tEZLgSo5ZF6VfDriQ+WWXFEX4nvcs/wT3WZL+7OPWnbotwPvRwL8chf+u+h6IcsF
         Z9+QeePGI7BVjzwFHmKUJyAlZ0Fe7DgtTxhDrm/VNlHZQNQ+W0sfeKd9tf1DULeOblaK
         9FJ3Ud8dxKIEWIsGZQLS/FEpIY4XLh7BMO2Hqfnd4r2pKWZfsf+TQpFn56FgErqTuK8U
         XukA9Hve9WYCmKfnh7PBoVCZcHAn67hgKBkCmmxAYSEeIvJpeQ3cT+fCWyScJT2doEaW
         rTKz1L4CVnQVrbJ23aM/sB9w80xkBpGZu+Pzp3Pnu+qJ9i/3CMA+7C1yEV1d3SP3L0Du
         u7og==
X-Forwarded-Encrypted: i=1; AJvYcCUPwtsFj/1QxqtI5G7LZjq6O+w64DZ2ajDl3MBIU+KDH7CXz0997+Qq+rAKNU1Bp8Z3Pd8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg70v3Jb+i3w8sGjXk6KUG2Mox+0yEXAK8p/DiYXKYvDR76hF/
	Rv7C9zVQdUW6JhDOUQzHs2vFk1Og6wuKfgroTdEg3rIHMhb9TjTWdSCouIEEVnvxWtn5b+n5K4u
	A76rKtg==
X-Google-Smtp-Source: AGHT+IEgp2iZQpjhp0IVG/RwRNaEA6kfEIJ5+nTH0IRpQP2O/sqcsBBrA4cu+AlVBTYSA0EfMFq00gIPM7c=
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:31f:b2f:aeed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3394:b0:240:aa15:70ac
 with SMTP id adf61e73a8af0-2431b7decdfmr1666131637.16.1755648302882; Tue, 19
 Aug 2025 17:05:02 -0700 (PDT)
Date: Tue, 19 Aug 2025 17:05:01 -0700
In-Reply-To: <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752869333.git.ashish.kalra@amd.com> <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au> <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com> <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
Message-ID: <aKURLcxv6uLnNxI2@google.com>
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neeraj.Upadhyay@amd.com, aik@amd.com, 
	akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de, corbet@lwn.net, 
	dave.hansen@linux.intel.com, davem@davemloft.net, hpa@zytor.com, 
	john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nikunj@amd.com, paulmck@kernel.org, pbonzini@redhat.com, 
	rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Borislav Petkov wrote:
> On Mon, Aug 18, 2025 at 02:38:38PM -0500, Kim Phillips wrote:
> > I have pending comments on patch 7:
> 
> If you're so hell-bent on doing your improvements on-top or aside of them, you
> take his patch, add your stuff ontop or rewrite it, test it and then you send
> it out and say why yours is better.
> 
> Then the maintainer decides.
> 
> There's no need to debate ad absurdum - you simply offer your idea and the
> maintainer decides which one is better. As it has always been done.

Or, the maintainer says "huh!?" and goes with option C.

Why take a string in the first place?  Just use '-1' as "max/auto".

