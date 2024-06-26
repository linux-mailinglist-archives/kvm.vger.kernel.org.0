Return-Path: <kvm+bounces-20515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3159175FD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 04:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1282F1F23090
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 02:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08AF1C290;
	Wed, 26 Jun 2024 02:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0SNx8dR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51AB1643A
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719367513; cv=none; b=rEpc0xZSuKTTwA9Oh83QTyWJaE6/I2K0avHKFkGB35sr8gHsvA9siLCGDitsFXrb22p0/C0SaXVzGEwvx/fGyH1urCHC4mMH14+2uZVsZ0aZ29lg5CMeIKU+5IyeUrsrWZ2mM3w/BvRKBnFgG63yEgidGQxD63x5jOR+r3tZADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719367513; c=relaxed/simple;
	bh=Luw7BOjHJYPbZPDlmdRmXC6owSO+bJqIepLDrNKSrGA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LF0mMLfEgN6LlkjcKU+WFJVotqyvhx5V+rUldDVjTTq3+3YeNPDALZrCkgtANT/1kqPOfihBJJF8YI3UKQEE3+DCe5otaMbm1a2J0O4t972J/itgI+sV2Eod6Ynj9Y9/mdxKP27kHh2J9AZY+PR+PX+OclPy/svMABzGrRRBSLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0SNx8dR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-63bca8ce79eso133353357b3.1
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 19:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719367510; x=1719972310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9S+kxdxQATqJifY7BuigX+QJw9dzfSNdsmhVE8yZi4=;
        b=h0SNx8dRjEy/MxJBZF5S6AB6xtJuNwHG9ATEMzOLHTZdZAj348kC7q322otFOPYd7W
         4W/kTsZMWRDexS6Peb/2v25Vy4noQaf+AAxwC0mKpepNx7cOwHKy7Fdaq0U77YHAzHiZ
         zDi/BYJMCTZNEn/hqbNI31QVx5PWNXYlgvlMRAkeMSZgi36Zlt3J79GRG+2tufnma/KO
         vtEqlvGnVIg7QjO/IwNcn4nocqTlFOoNYluk17YnvsfdWXzt3g4emycnFyleflgZ8uB3
         m6bWq55dPh5SP/gBKuWOuC9S5D79t6GgGf5kP7wRGh172J502DdhCdDpMsNO0/IbFT8Z
         z8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719367510; x=1719972310;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n9S+kxdxQATqJifY7BuigX+QJw9dzfSNdsmhVE8yZi4=;
        b=JfvndH+ULY9JyRNAEeXE4l68nynbYoDebti4axJFkQs/7A1B13yYxftsOZ+sq8QAdx
         6KnJB/XBLAnAhU8ieICAYB+jKTiJ3PWPy6daBuAGJOrQYY+IbSIFR4MzLY8PgWHPlt9o
         He931U7pgigTaXEkNlU5XLWBurwgUSEBCUFInPVGDfCTdxD2R2HXGiH7H4sP4YYyTctu
         Csb8NISVUF+oeL4Y2Ein4OFk2/x39UKoVmyz0trR0IaDCkYPubnTc5UU6vxAig7UgjUQ
         LZ3m4iRUqLYx/i43NcLmnZR9MAc9N8SMQ+Y32yGKqRjriA7XawoVEkUAW11cmjyIUSqM
         0nQA==
X-Forwarded-Encrypted: i=1; AJvYcCXtKdrBOIuY5NolJwWAury+IJTQbvcIYpdsj3/Z4cVUDI2NnAcuGhYqu2Gnh3fikpBfCWRIJ6JgE05rJsYuyZHB7QKT
X-Gm-Message-State: AOJu0YxZYmCHAu/F9CY7CKVfCh/0YjxDU3eNnpgotrn14el0iF8uPhvF
	oNbfwsxIWtz7H3wWjHtAxxf4h6z6/JoqWUWcL1F1JcKTEJQg+7NbcyCQfjQImzonTvl4EnzjAcA
	wjQ==
X-Google-Smtp-Source: AGHT+IHGSt5yIaXE03KIRkkcoLX0j8JTKvl4SszD7Hd9WLurAsb2+UpER/smAZNtYJLctAfSK4QFj+AlOPQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6086:b0:62c:fa1a:21e7 with SMTP id
 00721157ae682-643adb94892mr3021757b3.6.1719367510590; Tue, 25 Jun 2024
 19:05:10 -0700 (PDT)
Date: Tue, 25 Jun 2024 19:05:09 -0700
In-Reply-To: <CALMp9eTmez1TrQ6i+R8p7qJrkBNgTS8Xwf2XPw=x2RDcwe3Ekw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
 <ZmxTFFt1FdkJb6wK@google.com> <3a3e1514fb48b415b46045c76969cc211198b114.camel@redhat.com>
 <CALMp9eTmez1TrQ6i+R8p7qJrkBNgTS8Xwf2XPw=x2RDcwe3Ekw@mail.gmail.com>
Message-ID: <Znt3VVa5q_bdCZey@google.com>
Subject: Re: kvm selftest 'msr' fails on some skylake cpus
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024, Jim Mattson wrote:
> On Mon, Jun 17, 2024 at 11:29=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.=
com> wrote:
> >
> > On Fri, 2024-06-14 at 07:26 -0700, Sean Christopherson wrote:
> > > On Thu, Jun 13, 2024, Maxim Levitsky wrote:
> > > > Hi!
> > > >
> > > > This kvm unit test tests that all reserved bits of the MSR_IA32_FLU=
SH_CMD #GP, but apparently
> > > > on some systems this test fails.
> > > >
> > > > For example I reproduced this on:
> > > >
> > > > model name  : Intel(R) Xeon(R) CPU E3-1260L v5 @ 2.90GHz
> > > > stepping    : 3
> > > > microcode   : 0xf0
> > > >
> > > >
> > > > As I see in the 'vmx_vcpu_after_set_cpuid', we passthough this msr =
to the guest AS IS,
> > > > thus the unit test tests the microcode.
> > > >
> > > > So I suspect that the test actually caught a harmless microcode bug=
.
> > >
> > > Yeah, we encountered the same thing and came to the same conclusion.
> > >
> > > > What do you think we should do to workaround this? Maybe disable th=
is check on
> > > > affected cpus or turn it into a warning because MSR_IA32_FLUSH_CMD =
reserved bits
> > > > test doesn't test KVM?
> > >
> > > Ya, Mingwei posted a patch[*] to force KVM to emulate the faulting ac=
cesses, which
> > > more or less does exactly that, but preserves a bit of KVM coverage. =
 I'll get a
> > > KUT pull request sent to Paolo today, I've got a sizeable number of c=
hanges ready.
> > >
> > > [*] https://lore.kernel.org/all/20240417232906.3057638-3-mizhang@goog=
le.com
> > >
> >
> > This works for me.
> > Thanks,
> >
> > Best regards,
> >         Maxim Levitsky
>=20
> Sean and/or Paolo,
>=20
> I'm still waiting for this to show up. :)

13a12056be1e4939dadbd0d2cfb65df400832905 x86: msr: testing MSR_IA32_FLUSH_C=
MD reserved bits only in KVM emulation
51b87946279cf6e9248ceacf0f27833b6ebeef5e x86: Add FEP support on read/write=
 register instructions

/drop mic

