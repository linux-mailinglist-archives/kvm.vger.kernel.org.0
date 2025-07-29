Return-Path: <kvm+bounces-53588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C56DB14547
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 02:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A64E6189CD37
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F589101E6;
	Tue, 29 Jul 2025 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sk1PbxGy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E384828DD0
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 00:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753748328; cv=none; b=M7ubi6L1rzKF3qMyxaDNO09cO1egJoA9P3ckNeOCl8Dtxw8jScmEcids3FQsBNa7o+/2Yi2deOssaewO2YqsDXZXtPFBb0TfbDeQBn93E9hnWgq4qexFU3KjNcSeQcB1WX44fyEV5sTYW/chvHEGXglIBlcUA5g793uwzFYJUd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753748328; c=relaxed/simple;
	bh=Et2bzFjOjnc25vsazFZgNzo3w1UnydpoJ3tE9qbX9R4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=naiKVdj1fHnW5473DPMIMIPEGNTm71+zJbpOc5KWXaRw4Bb+olcW1thUQi4NOYyRtOoktkasv4XB6VMPik0DVqNMHRec91ea2CJHOIghNZmFqCpzadPjSBZIdPoB/mP00fmcxHPdXyQrU1K+Hi13gVsjgtmPpOobF6LKYvMFFYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sk1PbxGy; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e8e1b5e7e71so1282582276.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 17:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753748326; x=1754353126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xX8tzO6PUxS80SD8ArFQV50RaRFzSi6w6vdnm7xcBDY=;
        b=Sk1PbxGyLa2a9ZkYoUVNLRYdqEgDqyEud3Wukj1zjczlywZ4sJ1RmKNH8TUrVzt4H1
         4kK8sZCI5dHMVs12j6cdCG5sX4mYSn92mWms6pLsZ1iJzNHQ+kOKCraV3bMseaxXGD06
         J6ICdt/gWNcxyUTkyviO3GH03Ht+neCf5a7k1nK+UvS7BKb3QEjgvk4jLtYXnPdkE2Id
         eOCkGxZ3uzf8k94MJwXN3swQyoxXTi3XYR8SyNXPekAQhx4f17ham7SahEBfV+VXyvaB
         ULAJCl65mrovzPeptcmrXL6F7vAMZw0Pm41f3Az7qLv37CYLpB2n8MkBC6Nl0HaAQOrk
         1wmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753748326; x=1754353126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xX8tzO6PUxS80SD8ArFQV50RaRFzSi6w6vdnm7xcBDY=;
        b=psTl/ACgnfQBzCsqsEkHzXMO4orxCRxV3bCiGITRbz7d4lH6J9E2FLUpYsBXJgMgMU
         CrbB5VwttrMok1gXBi0GYtMrq2AYr/qEgtQRh8dF+/gPcN+2eQKpkzxA8mHhmP7RUlVC
         8aAUrofjGZAvMHhxHXZBaNcVj5dKNAwNLsCFRZdfZYg7j4dOqnXBjskq6i7kdql7ywQI
         sBniYZZbiBio7UcO86mKwmPqnD1j9vnX24NhQPu3gkC6l1jSqmnMoFD3nPyvRkfJYAt1
         iEhaRHBIIpFbIRLT/jrZnc+28GMf568DGis3QDD30VJ6fbtagSevOXL/So88Dseu71FG
         c8tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrpLJI/FwaCi479+wDgQLkBm7tYxz/hI+fe8JsIkCRumnqsMyBXrhUbjmv8Bs7a18+piI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvPu5eRKJG+mwKwjLY0K1jIlAXY8oJXZBd7GCiEjvTQ3YLfI8D
	32JWDS0Oh2QBKDDcbRXae+c1PazDPQCFBVE/w5FiFaSPX75t/MDpeHX1ZfB2WO00lI3K99vJCxQ
	cdRJcWofhO13RrrtpEz8/trojrZiM/GR1IB+Xa1Cyzy91P34SIJ6d4BIUZJ4=
X-Gm-Gg: ASbGncvK5r5VylGLrm2nNLmOSZQmgBcx5Mm5MBtYFc2Vt0Tl+PISKL0kgWJPdjEr75/
	JIqrnJdzccz5WwiLkpNrgsOq951ZqyMLxNR4BP6KmRXFhbbI3wbKSB20ZcnjI735oiQAOOWsSte
	4s9H5yuCLZ8F/x817QL2LJ3W4VE6S4Nu22DSf6RQFQKZ9AAwcct/68lpUiz4MJwZy8ANZ+J6bQD
	SPGF6Io/6LaSjBPlHINr69kc6+AqCiKAPyLQmK2hdHaA9E=
X-Google-Smtp-Source: AGHT+IEADMGwzNsgoMUWL0L4A1jloaEpmX4nez45KQdsMepUmEA75AjdE59uroYLgAE1OplHOLRj5/AQ1LxLWfPj/Ds=
X-Received: by 2002:a05:6902:2d04:b0:e8b:a52e:5c83 with SMTP id
 3f1490d57ef6-e8df13c1321mr15009090276.37.1753748325508; Mon, 28 Jul 2025
 17:18:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-6-jthoughton@google.com> <aIFLDTa7F7EmhOSR@google.com>
In-Reply-To: <aIFLDTa7F7EmhOSR@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Jul 2025 17:18:09 -0700
X-Gm-Features: Ac12FXx89bImwlCf8Ke2wsHgRSKshJyTpPbZszKqMYAHC84LDJklpYwKK3kBfPU
Message-ID: <CADrL8HW-0i-ALX38af6MOrV-WoNfg0rWKCD87ZHddJ5eu2oYpw@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] KVM: selftests: Introduce a selftest to measure
 execution performance
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2025 at 1:50=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 07, 2025, James Houghton wrote:
> > From: David Matlack <dmatlack@google.com>
> >
> > Introduce a new selftest, execute_perf_test, that uses the
> > perf_test_util framework to measure the performance of executing code
> > within a VM. This test is similar to the other perf_test_util-based
> > tests in that it spins up a variable number of vCPUs and runs them
> > concurrently, accessing memory.
> >
> > In order to support execution, extend perf_test_util to populate guest
> > memory with return instructions rather than random garbage. This way
> > memory can be execute simply by calling it.
> >
> > Currently only x86_64 supports execution, but other architectures can b=
e
> > easily added by providing their return code instruction.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> >  .../testing/selftests/kvm/execute_perf_test.c | 199 ++++++++++++++++++
>
> Honest question, is there really no way to dedup memstress tests?  This s=
eems
> like an insane amount of code just to call memstress_set_execute().

The main pieces of this test come out to:
1. Parse arguments
2. Create a VM
3. Run a couple iterations of memory access
4. Run a few execution iterations
5. Destroy the VM

(1) is slightly difficult to de-duplicate, because the other tests
have more arguments, and so you'd have to look in two places for a
full argument list (in the source code at least).

(2+5) Creating and destroying a VM is already not much code, IMO.

(3+4) Running iterations of guest memory accesses is a pretty good
candidate for de-duplication.

The other memstress tests are:
- access_tracking_perf_test.c
- demand_paging_test.c
- dirty_log_perf_test.c
- memslot_modification_stress_test.c
- x86/dirty_log_page_splitting_test.c

Three of these tests use similar iteration logic (all but
memslot_modification_stress_test.c and demand_paging_test.c).

I could make memstress_start_vcpu_threads() take a pointer to the main
vCPU thread logic, put some iteration logic around that, and then
provide a "run_iteration" interface in memstress. The two tests that
don't really iterate multiple times can just iterate once.

I'm not really sure how much *better* that is, but I can at least give
it a go and see how it looks.

If you're happy with the nx hugepage test[1] in patch #7, feel free to
apply that one without waiting for this one.

[1]: https://lore.kernel.org/kvm/20250707224720.4016504-8-jthoughton@google=
.com/

>
> >  .../testing/selftests/kvm/include/memstress.h |   4 +
> >  tools/testing/selftests/kvm/lib/memstress.c   |  25 ++-
> >  4 files changed, 227 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/s=
elftests/kvm/Makefile.kvm
> > index 38b95998e1e6b..0dc435e944632 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -137,6 +137,7 @@ TEST_GEN_PROGS_x86 +=3D x86/recalc_apic_map_test
> >  TEST_GEN_PROGS_x86 +=3D access_tracking_perf_test
> >  TEST_GEN_PROGS_x86 +=3D coalesced_io_test
> >  TEST_GEN_PROGS_x86 +=3D dirty_log_perf_test
> > +TEST_GEN_PROGS_x86 +=3D execute_perf_test
>
> How about call_ret_perf_test instead of execute_perf_test?  I like that "=
execute"
> aligns with "read" and "write", but as a test name it ends up being quite=
 ambiguous.

call_ret_perf_test to me sounds quite x86-specific, and although the
test currently only supports x86, I think we might as well name it
something more generic in case it becomes useful to support other
architectures.

