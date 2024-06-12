Return-Path: <kvm+bounces-19372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 86DC8904834
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA6EFB20F49
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41294A12;
	Wed, 12 Jun 2024 01:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JBjwKhnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356D391
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718154913; cv=none; b=lM3qEcuYK+lgnGf9eFHNO0x5CeGpjBIYT69AbWR+pVOVcW7tp6pAmqhh0CoOOeq5yMfUbUPD/Zjmd/pB14UNDhU8qwOQHzVdLsjW+fjkba1Ckv7V10oc7CFS8xTL0703tdoYDPQDNN+IcJA74aFNxLUF52w85UbT6kYDrZCvUbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718154913; c=relaxed/simple;
	bh=BqxitAMKU/vCJHWd0Q6rSlbb+pUyMVJMkjtFfSt9X7Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BujOCHhNuvYceubiwaahgHo9uOo4j+U3MnI6ZzyERlacfRdzp4/D/XEY6bVqp1xkak3pknnv2tz12VpWOMTnU7GBEcwnY0u1X8NDvCj20lI+6c9iWjQTJ2iNIdL94ODYW0ia814uQQgm+O5GE/gTeY4rohej46+JtykBJu8UQp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JBjwKhnQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6174d0421so41455245ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718154911; x=1718759711; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=24HjW+OsUYZu1pwQeotVLWpSHq+f4AALAynbUo+kc5c=;
        b=JBjwKhnQt8gV9cb5/4bKbmqScY7rgeFWtvYsh5Kn3Ik7JBghhfr8R0/0DUyb3y2BDA
         VL8UBSlIqnAFc47d+/8+vDreTm2BO7TUFcIIUQhfXJHEcHgDu+1WB9zHJzkPc5/+/tVe
         Pf4wY98GhuW2NMYZdQdvntHA6X11U9TZlG930QPKwxNaHpirPXVBLCeYp588RDGhAJJC
         XkJ+GpnJyUIto/IXNjuERT+vnGIjfnDwAiJNpxBYKP75egZYR5nTFw//E103NNzzFydN
         9jE5eOWdPpASNP96rt4twHdLrB98HBewhleAwuwI4UhY55+AUQuMrDCPSWi7otp/Dthf
         Xjmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718154911; x=1718759711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24HjW+OsUYZu1pwQeotVLWpSHq+f4AALAynbUo+kc5c=;
        b=Kg3Q55Z/7xvWPakWTc6tr1eFEH9qcq1ioj6gnjgQXh8z08UpydA+sxjGMoqG2+2++h
         aDmQPsFny3Obji48MmpTFCyP2l8FwwH1naNPnC2BvkpNJvejZhm4fxVGnqK7GngwbPjI
         iBGkhaT6pFRJ+UsSc4z/b6fXrf8t0FvyLN6d63taThEPUz6ZK95Cmkn/N8obWVTyjVRp
         99Nr26ycwhC0s6bpXvbSfUykqD07rkDvGwCxsvinoQFY8QlhgA8CrzWWTPaWS6nwA7i+
         qyjtWqtXTczpXX/pOtNybfywIqYiMrXgJin8ETBdgVdZSkeHyKlLAbFqVswYK3O6/xti
         GZGA==
X-Forwarded-Encrypted: i=1; AJvYcCWbAXPGaU3iBCC9LNSDXPfs789b+Hv59NRavsTHBP27LMQ6TXPenZXbBZ7Axt3PWAu3N6/X+82qi0RdRvCT65WuRbqy
X-Gm-Message-State: AOJu0YwNoLsto/RS7qIY888E7Hswm9TU0QK9Pv1TjsM9849AFAnzm9im
	X489kshxDkMjkSdWITo7GBI66UZooWMAsa4dHHHSvjig3L/Cbt9+NuY6/Q1wjjqDY4Py9req4RB
	KQQ==
X-Google-Smtp-Source: AGHT+IF17P0Cpn6MZ5P3JNAR3j+g3BI7j6BqYLNwPaeg4oe/duam1YslBK4G7PapPlufPemI94AvVtoVC68=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:eb83:b0:1f7:3bb3:abe2 with SMTP id
 d9443c01a7336-1f83b700219mr18575ad.12.1718154910665; Tue, 11 Jun 2024
 18:15:10 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:15:09 -0700
In-Reply-To: <88c65b89-5174-4076-82cd-7852c8c25b66@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <ad03cb58323158c1ea14f485f834c5dfb7bf9063.1718043121.git.reinette.chatre@intel.com>
 <ZmeYp8Sornz36ZkO@google.com> <a44d4534-3ba1-4bee-b06d-bb2a77fe3856@intel.com>
 <ZmjJnzBkOe58fFL6@google.com> <88c65b89-5174-4076-82cd-7852c8c25b66@intel.com>
Message-ID: <Zmj2nVhtVoGflaiG@google.com>
Subject: Re: [PATCH V8 1/2] KVM: selftests: Add x86_64 guest udelay() utility
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 11, 2024, Reinette Chatre wrote:
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> > index 42151e571953..1116bce5cdbf 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -98,6 +98,8 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
> >          ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
> > +       ucall_arch_do_ucall(GUEST_UCALL_FAILED);
> > +
> >          ucall_free(uc);
> >   }
> > 
> 
> Thank you very much.
> 
> With your suggestion an example unhandled GUEST_ASSERT() looks as below.
> It does not guide on what (beyond vcpu_run()) triggered the assert but it
> indeed provides a hint that adding ucall handling may be needed.
> 
> [SNIP]
> ==== Test Assertion Failure ====
>   lib/ucall_common.c:154: addr != (void *)GUEST_UCALL_FAILED
>   pid=16002 tid=16002 errno=4 - Interrupted system call
>      1  0x000000000040da91: get_ucall at ucall_common.c:154
>      2  0x0000000000410142: assert_on_unhandled_exception at processor.c:614
>      3  0x0000000000406590: _vcpu_run at kvm_util.c:1718
>      4   (inlined by) vcpu_run at kvm_util.c:1729
>      5  0x00000000004026cf: test_apic_bus_clock at apic_bus_clock_test.c:115
>      6   (inlined by) run_apic_bus_clock_test at apic_bus_clock_test.c:164
>      7   (inlined by) main at apic_bus_clock_test.c:201
>      8  0x00007fb1d8429d8f: ?? ??:0
>      9  0x00007fb1d8429e3f: ?? ??:0
>     10  0x00000000004027a4: _start at ??:?
>   Guest failed to allocate ucall struct

/facepalm

No, it won't work, e.g. relies on get_ucall() being invoked.  I'm also being
unnecessarily clever, and missing the obvious, simple solution.

The only reason tests manually handle UCALL_ABORT is because back when it was
added, there was no sprintf support in the guest, i.e. the guest could only spit
out raw information, it couldn't format a human-readable error message.  And so
tests manually handled UCALL_ABORT with a custom message.

When we added sprintf support, (almost) all tests moved formatting to the guest
and converged on using REPORT_GUEST_ASSERT(), but we never completed the cleanup
by moving REPORT_GUEST_ASSERT() to common code.

Even more ridiculous is that assert_on_unhandled_exception() is still a thing.
That code exists _literally_ to handle this scenario, where common guest library
code needs to signal a failure.

In short, the right way to resolve this is to have _vcpu_run() (or maybe even
__vcpu_run()) handle UCALL_ABORT.  The the bajillion REPORT_GUEST_ASSERT() calls
can be removed, as can UCALL_UNHANDLED and assert_on_unhandled_exception() since
they can and should use a normal GUEST_ASSERT() now that guest code can provide
the formating, and library code will ensure the assert is reported.

For this series, just ignore the GUEST_ASSERT() wonkiness.  If someone develops
a test that uses udelay(), doesn't handle ucalls, _and_ runs on funky hardware,
then so be it, they can come yell at me :-)

And I'll work on a series to handle UCALL_ABORT in _vcpu_run() (and poke around
a bit more to see if there's other low hanging cleanup fruit).

