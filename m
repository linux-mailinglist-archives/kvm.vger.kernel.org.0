Return-Path: <kvm+bounces-25914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFCB296CA40
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 00:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 643BFB25282
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D8B188A37;
	Wed,  4 Sep 2024 22:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3IUX93i5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748C6188A12
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725488584; cv=none; b=YnjtEAOoZZ8py8j4Y9YJyzJ7VqRv1/EGBXlM7CWftn4WX218iak+RZLoOwm2XyNySAKf6o5gt4sHyxHIZSsvu9yCQypmRcmn+VyOF3zAHD0a3m4vQgKcppepAsQKIMfegAyVMS6MgnIMC9xu41CsTUIuUzlBllkv1uGOKW2EiJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725488584; c=relaxed/simple;
	bh=s5xmMC/cnwws6ZlQFHDlWeIFR1CUFKwSJ6PBP2ziMGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LL43pvQU5d5yEJt7ro9/03jLvh3vaB7aj0zXjKUUy0/GHv/o1vgobYDUoCKLVI6RLpwoMDyuElVn7xSdim2fEtZ+leCxzcox1CLe92ZGD4NNKiCLDd/RvKQxrloxbcmD58yuDj8JoLlNIkWYqyXWoP5Jrp624Supzig/KmDqrro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3IUX93i5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d3e062dbeeso3387677b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 15:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725488581; x=1726093381; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4IcbwmmlOLf0klhujBPied779n3Fl3qlNEilivTVgvc=;
        b=3IUX93i5i+b7svnPiNBtELHyIjur0EeB9FfJJ+lx4JvK4+cKup2TVoeTah6EUk3Pju
         Ofb2TULlJCe7TbT/QQzNIwKzYvYesOPE+L4CXwnQY23kv2kDk1dAV6CbeMxRqDnstmAc
         olAd8GtyJDdjZDvi8KvbFg5b8VfX16bkOvq0E2jVc1nNKLqeKJqcNVarnAiSHkf3yfab
         v+VPVJ6/M/kIciqc+SzQa37JbPC0GUiZCAmzVrPAFHbFGfMHSWxnZwSYB9FED/PgglUi
         +8H+lglcv2HdVer8ecTC3pD5CoLOq23GOlYDsMLJrQKeeCcjv0SNipuhJqi6bFrXaPo8
         NkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725488581; x=1726093381;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4IcbwmmlOLf0klhujBPied779n3Fl3qlNEilivTVgvc=;
        b=kgivd6GK/R/vwI/CsgsUJ+orQo6oy5xKQPGNrd1Xb/2QBwbQAXk4kZYFMr5eXOVs8R
         uvxfDaJPRnn8d8nBUyLmrhurVudjdjEjJ3U3gOfqZsqEs5C0CAUFyvhX/pKiGVYTGntv
         yxFn/9c0KbYZcZG8J2lJkAtIDK7VO5YCkFTIXsfCb//ZgyNl6cTcf37/yAcxKUsVjlll
         WKqt7Pelsck+KbYTMpnLuce5nN6GjPo/OrjgOjyVsBIQMCA+OcgBOdMfUsRsgrctVV4z
         vM3eqNOL/58dSg2h5rbU2gBL1OG8Se48oyVHzEvWEYhIEUeFFRiU1DcaemXnp7NXUuvh
         gAgA==
X-Forwarded-Encrypted: i=1; AJvYcCV9Z7gf8h/3fjaRt9wjirgUNZitwaJ9SJPajEf0XheVYpFhPFAVyNjnHfLuiuVIqonlfkM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwklw3xcu7ztnAXyYWvNlPpfjOgnh4GZ1Qu+Vk1Odz9ZAi+HpF
	fO/aaki3rldjI9xJz7Fg61jkqS6+V2KABHAt5NmOvqyTW1E5495K8BzTnBSDe6lyrd/YK6kGTwO
	c7Q==
X-Google-Smtp-Source: AGHT+IGYeTai88fqs4PTMdPKSg8MaUYgkkisjxloKq27r7jXpBOr3zwINpKcQRS2VjU6U9JC53KdXYeYceY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2009:b0:6be:523:af53 with SMTP id
 00721157ae682-6db26026aaamr1583987b3.3.1725488581437; Wed, 04 Sep 2024
 15:23:01 -0700 (PDT)
Date: Wed, 4 Sep 2024 15:23:00 -0700
In-Reply-To: <c24deb49-4369-4dcf-bb71-3160f2466ac3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240903191033.28365-1-Ashish.Kalra@amd.com> <ZtdpDwT8S_llR9Zn@google.com>
 <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com> <25ca73c9-e4ba-4a95-82c8-0d6cf8d0ff78@redhat.com>
 <14b0bc83-f645-408f-b8af-13f49fe6155d@amd.com> <20240904195408.wfaukcphpw5iwjcg@amd.com>
 <c24deb49-4369-4dcf-bb71-3160f2466ac3@amd.com>
Message-ID: <ZtjdxNTBJymcx2Lq@google.com>
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, peterz@infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	kexec@lists.infradead.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 04, 2024, Ashish Kalra wrote:
> On 9/4/2024 2:54 PM, Michael Roth wrote:
> >   - Sean inquired about making the target kdump kernel more agnostic to
> >     whether or not SNP_SHUTDOWN was done properly, since that might
> >     allow for capturing state even for edge cases where we can't go
> >     through the normal cleanup path. I mentioned we'd tried this to som=
e
> >     degree but hit issues with the IOMMU, and when working around that
> >     there was another issue but I don't quite recall the specifics.
> >     Can you post a quick recap of what the issues are with that approac=
h
> >     so we can determine whether or not this is still an option?
>=20
> Yes, i believe without SNP_SHUTDOWN, early_enable_iommus() configure the
> IOMMUs into an IRQ remapping configuration causing the crash in
> io_apic.c::check_timer().
>=20
> It looks like in this case, we enable IRQ remapping configuration *earlie=
r*
> than when it needs to be enabled and which causes the panic as indicated:
>=20
> EMERGENCY [=C2=A0=C2=A0=C2=A0 1.376701] Kernel panic - not syncing: timer=
 doesn't work
> through Interrupt-remapped IO-APIC

I assume the problem is that IOMMU setup fails in the kdump kernel, not tha=
t it
does the setup earlier.  That's that part I want to understand.

Based on the SNP ABI:

  The firmware initializes the IOMMU to perform RMP enforcement. The firmwa=
re also
  transitions the event log, PPR log, and completion wait buffers of the IO=
MMU to
  an RMP page state that is read only to the hypervisor and cannot be assig=
ned to
  guests.

and commit f366a8dac1b8 ("iommu/amd: Clean up RMP entries for IOMMU pages d=
uring
SNP shutdown"), my understanding is that the pages used for the IOMMU logs =
are
forced to read-only for the IOMMU, and so attempting to access those pages =
in the
kdump kernel will result in an RMP #PF.

That's quite unfortunate, as it means my idea of eating RMP #PFs doesn't re=
ally
work, because that idea is based on the assumption that only guest private =
memory
would generate unexpected RMP #PFs  :-(

> Next, we tried with amd_iommu=3Doff, with that we don't get the irq remap=
ping
> panic during crashkernel boot, but boot still hangs before starting kdump
> tools.
>=20
> So eventually we discovered that irqremapping is required for x2apic and =
with
> amd_iommu=3Doff we don't enable irqremapping at all.

Yeah, that makes sense, as does failing to boot if the system isn't configu=
red
properly, i.e. can't send interrupts to all CPUs.

