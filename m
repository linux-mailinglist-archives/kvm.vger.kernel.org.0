Return-Path: <kvm+bounces-20506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 251209174AC
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4970281E6D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 23:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECED217F500;
	Tue, 25 Jun 2024 23:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lFNLoKxi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319917D88C
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358030; cv=none; b=AtodAW1mGt7lLL0D03Z6umer7xNRIWjjyYNgn2mrA3d1GhnnNyg1oOJbvFbIW/+nfzFN2CKo2mz/iE4VWJIIHD2POlxk/Gaa4ZwaoCdfY7jWu70RfViIASy5rnicx7xv9JSsO/J2wWBzFy9kl+FrooAnqQ8hxK3N0WdXtLXNpzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358030; c=relaxed/simple;
	bh=rYYmEPcqcQ9NMGqGAnMHOlrWwSNiwufqAydwaFEWLrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HV7cyTdtodF/po6XruvJffdigyfBlB2fP4+0MeOjKcGmTTOGYglm6XGPKpNlynaIa1zkmkv9LxIkVzvqJvRcfReC3TZmeFs5coL3YA+Vr2d6u7d0b+Iwwp0bETvgs0EieOn6p3cYIO5cej3QnAvgQ56Guz7OS1joW3lx+NBev3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lFNLoKxi; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso3286a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 16:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719358027; x=1719962827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S96OdWC18KC7h+HryfBM4Z35r1uFfJ2/I3Xrp+/QQmM=;
        b=lFNLoKxiGwCm7kqHfExztxX597bCTfR36Rh6pYFZ8DRNCpjY0hZv8VbAVy2xfBv20h
         rVQJw2iaQ94vAD1HhOSY+WyNSOVIYeUc1EwBI0fEyB3r/wmmBT6NGt8suwNTZAfInPn4
         lRRcVHCvFCn/t7HxDlnR+z/Ev3MIGyhvRUgN6wyMMO9llrIWo8P6JwPLDeCGYk/vcXa/
         lXcwmSITxkGXIIdCyj48PFSHHQJVbUKUpjq4CL/kKg4BIzkhi+uw8GC/R3ASf4lNgZMc
         FU7XNNDB0ygEj8a84O/cguHTHkSZZyimwb2BMMmIHFmWfZQBe3jv4mjv5/BbYC34TRE2
         NEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719358027; x=1719962827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S96OdWC18KC7h+HryfBM4Z35r1uFfJ2/I3Xrp+/QQmM=;
        b=m5m9P+gFYVvgp5J4UMMbZP01xlpTVjSCudQZqRhm+/tmvaQhrPSI0HQMqwgSs6RTIx
         S1hSu2zo5tb3JUqKjF1MCV5D6GeZKq1LHumDDO798hToEVKYq5Z9+T6AAV6BqRoVDVXh
         1AcgLOiuEwIxMRqAaV2MEMTKFaUUXEU/D339CGommDuOryeglWb8m1bs2M4AkCqfFoKT
         HA8vX8eSljGO1F5OGRZpLKW7jitYzXuOsYKCmxQiufdYIVTpexgyQTI5kPJbBxraEbeO
         3SwuamGUHDXaZqxzxOkioQ84kK6Dng8xuOwRMi74Frz2dr36Q7oYd91LaRrTgINQ3Lvj
         iwUw==
X-Gm-Message-State: AOJu0Yyx1T48yJH2UN/B8dC1/SjFRwl99UBBMOyQuDlY8VxdmS1sFSga
	WL36wJOOhRFJGI2oLvdqb6/TS6vfaSEhusp41yln30HOcOKq8RdgB/OfOAy88RWWtGOF82IUi4R
	99Zx7OwXKpHj/BiWRbpjm+1hjld8oXOss+RaNlGuBry5spm1KAWb9
X-Google-Smtp-Source: AGHT+IFxVSonzGYibIBkNz88obJaOkfp6dpG3dswKL2fmlAw6lj/gtC8qtIwQBCVLXne/B5Sr4ewb3GEPtVn2Qkf7eY=
X-Received: by 2002:a05:6402:27cf:b0:57d:6e52:fff6 with SMTP id
 4fb4d7f45d1cf-58359057f79mr45571a12.5.1719358026508; Tue, 25 Jun 2024
 16:27:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f6bca5b0f9fc1584ef73d8ef71ac25e2c656b81e.camel@redhat.com>
 <ZmxTFFt1FdkJb6wK@google.com> <3a3e1514fb48b415b46045c76969cc211198b114.camel@redhat.com>
In-Reply-To: <3a3e1514fb48b415b46045c76969cc211198b114.camel@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 25 Jun 2024 16:26:50 -0700
Message-ID: <CALMp9eTmez1TrQ6i+R8p7qJrkBNgTS8Xwf2XPw=x2RDcwe3Ekw@mail.gmail.com>
Subject: Re: kvm selftest 'msr' fails on some skylake cpus
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 11:29=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.co=
m> wrote:
>
> On Fri, 2024-06-14 at 07:26 -0700, Sean Christopherson wrote:
> > On Thu, Jun 13, 2024, Maxim Levitsky wrote:
> > > Hi!
> > >
> > > This kvm unit test tests that all reserved bits of the MSR_IA32_FLUSH=
_CMD #GP, but apparently
> > > on some systems this test fails.
> > >
> > > For example I reproduced this on:
> > >
> > > model name  : Intel(R) Xeon(R) CPU E3-1260L v5 @ 2.90GHz
> > > stepping    : 3
> > > microcode   : 0xf0
> > >
> > >
> > > As I see in the 'vmx_vcpu_after_set_cpuid', we passthough this msr to=
 the guest AS IS,
> > > thus the unit test tests the microcode.
> > >
> > > So I suspect that the test actually caught a harmless microcode bug.
> >
> > Yeah, we encountered the same thing and came to the same conclusion.
> >
> > > What do you think we should do to workaround this? Maybe disable this=
 check on
> > > affected cpus or turn it into a warning because MSR_IA32_FLUSH_CMD re=
served bits
> > > test doesn't test KVM?
> >
> > Ya, Mingwei posted a patch[*] to force KVM to emulate the faulting acce=
sses, which
> > more or less does exactly that, but preserves a bit of KVM coverage.  I=
'll get a
> > KUT pull request sent to Paolo today, I've got a sizeable number of cha=
nges ready.
> >
> > [*] https://lore.kernel.org/all/20240417232906.3057638-3-mizhang@google=
.com
> >
>
> This works for me.
> Thanks,
>
> Best regards,
>         Maxim Levitsky

Sean and/or Paolo,

I'm still waiting for this to show up. :)

