Return-Path: <kvm+bounces-18915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E0B78FD0BE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CB0F1C23CF3
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 14:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E5F1BDDF;
	Wed,  5 Jun 2024 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vdL2Efv+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4435710979
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597367; cv=none; b=fq9oA6Q7qodrpBun8qg41ySaDjJ+tpgW4PNWkjDBJ4/hr/lzSk6EYDHk3ggI1M4bPzGK2aTnQc/89Wt7OEfblXU0HAeOkqeo9jvoZF38Hi30XTec2V9lrhRBWauw0AZ1JZBic7wkkt4xRpFHM538vQPEzgJsNE2QDj8ozZVrleI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597367; c=relaxed/simple;
	bh=OaxfX57DdLiPPMZLsvwQEjhvOkJKa+3clCY0xOaO3zo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eXiUpBRTyheVGjHUFOiylyR4DWEEyAJqPHgCSNLA9Sd3XW6MDbAafr3amZwO50qaLy/O+ic0eweC8ItZPMPGYX/xhHjq4xSp/yjm1t6fu8WmZYLrhzSZky3sTBVFGUUHNJ217Ulvz6KqBm11aK6TCsa8f0dkfEpD+3uLmWmNnDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vdL2Efv+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a1e9807c0so13456797b3.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 07:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717597365; x=1718202165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LvVshO+KN4NNrct7o6V84rhHGa2nQ4U5rvJJ0qDRFtI=;
        b=vdL2Efv+ZXfVhSj5TrphVGbH8MdNP5SLAXrnFZrPzzSrJlb48cbzsqdyIIfOjnm4If
         w2uWnp5VV0r3+IFMs32pqVdayQ3CWNs1iofdBtW9ynZYQol/LQbA4XvHlcyG+KxfuQ5W
         KBmGGtxm6Uc0mirsshQkw7DfaiMxHbrJ6QPgv8JTi63cn1nWS22tkhcLt3rodOKePpRV
         jfTBseZY1AHPu5RwHU/GH1YrTyC33UpXBrqwFcYwoeiuZnIOqfQ7esW5y46NHkPVu1tN
         7OYRmccq8+CFdvVkS/hkDhS9zzmOXkCZ+tGTxfQpGI/WJwKFHXdnNKB0towjGk5vyVeU
         ipVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597365; x=1718202165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LvVshO+KN4NNrct7o6V84rhHGa2nQ4U5rvJJ0qDRFtI=;
        b=DzhGuWVrXAUhWuu12PApPqLWa/GC+u4FGoIykE35VmcqV0hRE1U2nALEdeqU4z+QKZ
         kecyq7i4ayB/fOMUbHvR+eIeDhVjTsi2dlf5MDJbflSKIVInQ9kFoPLbqSR0hgconsSK
         7P/krRK4agT/hqrSPTVWe+O4Ty2XIdULdyIrWN0QThqj6apZTwb/yNan1hqHLILGSdx5
         1j/FuwnL9zVGe56gwi76ZAnx3IH+LFQPSwDC3W+dhLiA9zFkpCM+EJu/oYE2eRedjqRK
         ol+0DNVk81KyfzTcJcOQcisLvLgfl6A5fWT5RRbeE/JYevJYZXdPG9iU+Elww+NoPrti
         7Tfw==
X-Forwarded-Encrypted: i=1; AJvYcCVbrDVfSIM1WRam/6SeCvFmmsv7HhTlVWTfXGAU0whsO1vYUOFch8hVV0RPLXAfoD4JqdedTY8LM4aLU0zkrKIVE9UF
X-Gm-Message-State: AOJu0Yxx5BC+uFaoxztGHD6BVsgaUYYjZP1F1r99TJOU6z3+R+uI77/1
	P3lTH2A0qSeOMRpjQYNG1mT1VW5SI8Zn/O8PvmrWEQPOcdAIITyeBF4obKxHdjdPlCiNoegNQcu
	ZEw==
X-Google-Smtp-Source: AGHT+IGYOrXGN+zi1ebLRYuhCKpTEfY6qm6f+nqEgaR+yJ/7gwSGrmcMVrxvLY9w6YKVxPj0Sq7/w40QmU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d89:b0:61b:32dc:881d with SMTP id
 00721157ae682-62cba666c6fmr7877257b3.3.1717597365293; Wed, 05 Jun 2024
 07:22:45 -0700 (PDT)
Date: Wed, 5 Jun 2024 07:22:43 -0700
In-Reply-To: <d2d64211-bd70-4212-811f-c039d2d8dabd@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <Zl38b3lxLpoBj7pZ@google.com> <d2d64211-bd70-4212-811f-c039d2d8dabd@intel.com>
Message-ID: <ZmB0s7UsfSe90kqr@google.com>
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 04, 2024, Reinette Chatre wrote:
> > > +/*
> > > + * Pick one convenient value, 1.5GHz. No special meaning and different from
> > > + * the default value, 1GHz.
> > 
> > I have no idea where the 1GHz comes from.  KVM doesn't force a default TSC, KVM
> > uses the underlying CPU's frequency.  Peeking further ahead, I don't understand
> > why this test sets KVM_SET_TSC_KHZ.  That brings in a whole different set of
> > behavior, and that behavior is already verified by tsc_scaling_sync.c.
> > 
> > I suspect/assume this test forces a frequency so that it can hardcode the math,
> > but (a) that's odd and (b) x86 selftests really should provide a udelay() so that
> > goofy stuff like this doesn't end up in random tests.
> 
> I believe the "default 1GHz" actually refers to the default APIC bus frequency and
> the goal was indeed to (a) make the TSC frequency different from APIC bus frequency,
> and (b) make math easier.
> 
> Yes, there is no need to use KVM_SET_TSC_KHZ. An implementation of udelay() would
> require calibration and to make this simple for KVM I think we can just use
> KVM_GET_TSC_KHZ. For now I continue to open code this (see later) since I did not
> notice similar patterns in existing tests that may need a utility. I'd be happy
> to add a utility if the needed usage pattern is clear since the closest candidate
> I could find was xapic_ipi_test.c that does not have a nop loop.

Please add a utility.  ARM and RISC-V already implement udelay(), and this isn't
the first test that's wanted udelay() functionality.  At the very least, it'd be
nice to have for debug, e.g. to be able to insert artificial delay if a test is
failing due to a suspected race suspected.  I.e. this is likely an "if you build
it, they will come" situations.

> > Unless I'm misremembering, the timer still counts when the LVT entry is masked
> > so just mask the IRQ in the LVT. Or rather, keep the entry masked in the LVT.
> 
> hmmm ... I do not think this is specific to LVT entry but instead an attempt
> to ignore all maskable external interrupt that may interfere with the test.

I doubt it.  And if that really is the motiviation, that's a fools errand.  This
is _guest_ code.  Disabling IRQs in the guest doesn't prevent host IRQs from being
delivered, it only blocks virtual IRQs.  And KVM selftests guests should never
receive virtual IRQs unless the test itself explicitly sends them.

> LVT entry is prevented from triggering because if the large configuration value.

Yes and no.  A large configuration value _should_ avoid a timer IRQ, but the
entire point of this test is to verify KVM correctly emulates the timer.  If this
test does its job and finds a KVM bug that causes the timer to prematurely expire,
then unmasking the LVT entry will generate an unexpected IRQ.

Of course, the test doesn't configure a legal vector so the IRQ will never be
delivered.  We could fix that problem, but then a test failure would manifest as
a hard-to-triage unexpected event, compared to an explicit TEST_ASSERT() on the
timer value.

That said, I'm not totally pposed to letting the guest die if KVM unexpectedly
injects a timer IRQ, e.g. if all is well, it's a cheap way to provide a bit of
extra coverage.  On the other hand, masking the interrupt is even simpler, and
the odds of false pass are low.

