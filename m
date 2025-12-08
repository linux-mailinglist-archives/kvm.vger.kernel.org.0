Return-Path: <kvm+bounces-65511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F15CADF66
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 19:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 113B43065785
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 18:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A7F266B72;
	Mon,  8 Dec 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vE1l1i6A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0C226CFD
	for <kvm@vger.kernel.org>; Mon,  8 Dec 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765217281; cv=none; b=psrguMvE310ntsfmusPW/yynNkvCpYC7S2xijiBL6f4i32GRbjcmYajqPCqsKJjIV3wBqi1YpalkbjgoHYFA2PxFT5RPmwSTfCPjV1mu2gsfGovRzwMfpm7KnjMdB3soMy0CqsCATU9vfEE0cgv99MjIWFyPsmfVoP+YuZ6Q99U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765217281; c=relaxed/simple;
	bh=9iufsu/WFJNy0WogHro7btB7qYSuDu2TmGiNlbbFqhw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bnv//YdDUKwzNZUuDVLrVE+kVj1Ik+pqotbrxllM2GIFvRskcd1CZm7qvA1C/2GqCv2rOLeYNaA7uGzVJHHD//hOHUpt/utVHxEJW7TK32k0N3rgoXHojsCvBlK6x5O/9vQVD2gDDZdAODVm8BPcncsCEWLwHYAgTNxzfhIvTIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vE1l1i6A; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c261fb38so8127158a91.0
        for <kvm@vger.kernel.org>; Mon, 08 Dec 2025 10:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765217279; x=1765822079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SF6h5hGtRuMyBRglBJmpKQuSrVGlyuxXyhedVebSd6M=;
        b=vE1l1i6Aly2WBn1u85OnmHHA+4/1tuppegXDLfZHeS8tcHZSqO9X0mwCzSQ3uZsObZ
         HTrtBphv7J9Ip5Vjo80q7RXXw6Z1CWx0agvmWnGHj4PJZmqAnMan4zx+6vtFRMRoUD4b
         xJNOghHYVnZbGgyQ/VhtBoksP2o3J6mb9WqHV/Edy25cQ4ekaGB81pNYWE44oDto76Vl
         cxgRoJkiF7AmYD4Is4m++XyrkqVzbifQj+dVzehI3YfJuQ9EgbezxWuxuViAixmXQAkZ
         UTBf3hBZz58dRQ33Ev4GSN4H8yIXoc8lYJypWdpbegTO5ioaaN9AjLktovI8AFvv0Q3Y
         FTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765217279; x=1765822079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SF6h5hGtRuMyBRglBJmpKQuSrVGlyuxXyhedVebSd6M=;
        b=dek4PbKcJm3ftBiQKA1YH9GUUG4KCmyeiPuYExpGwZs2NqRAoiUcvQF7t6ZqBILERP
         7S/cPNmkP5BjGibCVxtFZWRU6CzPWx1ZbcuCp1OnmUDkqkWEBdWhYuMDfLf/1jE11mu7
         BKmWbD1dJ0kTCsAkmSBsIIMCFYR9cCgstHBB4HjTC8V1ZXmyErFGNPclvXWt1gnik+I5
         ewxYp0neW09MT9RlMT6tKWzJPBx1FwWfy79eplFQrJB6nEXu/Hzew2uu6cJTcxZbqOwz
         WzB/ocuUgspFAd7xODWVJavfBJCWOUsUnNvuGyAha7JT6nZPHXR3/VclBNoutMM4fyPg
         B1Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWiklCuSbVNqkUpmaQwkRi4vAPT5FMxu82H1in9BZBi9mgSSxOlXFfUEuXepjUhGqyfIw0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6L/wJYYVKlKv9h4YkKRUXs6nHTZJc6lQEqiybyP6NnyjDIxSE
	f+Qgr+kV8l9ZnXboJ+qNB7zlTinYlGM8Tpf0NWWet4MfANj2I52u2UQrdeqF90/bxnqUZ1AlJIk
	wKUjjyQ==
X-Google-Smtp-Source: AGHT+IH3HhOiXlRek80ArMNgo8utGCkumZ6GCHftobZYLKaRSJ46MkO0EFccaQp1M2wj9T7xKajFvZIZ67U=
X-Received: from pjbfs21.prod.google.com ([2002:a17:90a:f295:b0:343:6849:31ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2787:b0:349:8a8b:da5c
 with SMTP id 98e67ed59e1d1-349a24f2f71mr7253927a91.11.1765217279160; Mon, 08
 Dec 2025 10:07:59 -0800 (PST)
Date: Mon, 8 Dec 2025 10:07:57 -0800
In-Reply-To: <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-5-seanjc@google.com>
 <20251208115156.GE3707891@noisy.programming.kicks-ass.net>
Message-ID: <aTcT_QcQaqyHV_S-@google.com>
Subject: Re: [PATCH v6 04/44] perf: Add APIs to create/release mediated guest vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 08, 2025, Peter Zijlstra wrote:
> On Fri, Dec 05, 2025 at 04:16:40PM -0800, Sean Christopherson wrote:
> 
> > +static atomic_t nr_include_guest_events __read_mostly;
> > +
> > +static atomic_t nr_mediated_pmu_vms __read_mostly;
> > +static DEFINE_MUTEX(perf_mediated_pmu_mutex);
> 
> > +static int mediated_pmu_account_event(struct perf_event *event)
> > +{
> > +	if (!is_include_guest_event(event))
> > +		return 0;
> > +
> > +	guard(mutex)(&perf_mediated_pmu_mutex);
> > +
> > +	if (atomic_read(&nr_mediated_pmu_vms))
> > +		return -EOPNOTSUPP;
> > +
> > +	atomic_inc(&nr_include_guest_events);
> > +	return 0;
> > +}
> > +
> > +static void mediated_pmu_unaccount_event(struct perf_event *event)
> > +{
> > +	if (!is_include_guest_event(event))
> > +		return;
> > +
> > +	atomic_dec(&nr_include_guest_events);
> > +}
> 
> > +int perf_create_mediated_pmu(void)
> > +{
> > +	guard(mutex)(&perf_mediated_pmu_mutex);
> > +	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
> > +		return 0;
> > +
> > +	if (atomic_read(&nr_include_guest_events))
> > +		return -EBUSY;
> > +
> > +	atomic_inc(&nr_mediated_pmu_vms);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
> > +
> > +void perf_release_mediated_pmu(void)
> > +{
> > +	if (WARN_ON_ONCE(!atomic_read(&nr_mediated_pmu_vms)))
> > +		return;
> > +
> > +	atomic_dec(&nr_mediated_pmu_vms);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
> 
> These two things are supposed to be symmetric, but are implemented
> differently; what gives?
> 
> That is, should not both have the general shape:
> 
> 	if (atomic_inc_not_zero(&A))
> 		return 0;
> 
> 	guard(mutex)(&lock);
> 
> 	if (atomic_read(&B))
> 		return -EBUSY;
> 
> 	atomic_inc(&A);
> 	return 0;
> 
> Similarly, I would imagine both release variants to have the underflow
> warn on like:
> 
> 	if (WARN_ON_ONCE(!atomic_read(&A)))
> 		return;
> 
> 	atomic_dec(&A);
> 
> Hmm?

IIUC, you're suggesting someting like this?  If so, that makes perfect sense to me.

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c6368c64b866..fa2e7b722283 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6356,7 +6356,8 @@ static int mediated_pmu_account_event(struct perf_event *event)
 
 static void mediated_pmu_unaccount_event(struct perf_event *event)
 {
-       if (!is_include_guest_event(event))
+       if (!is_include_guest_event(event) ||
+           WARN_ON_ONCE(!atomic_read(&nr_include_guest_events)))
                return;
 
        atomic_dec(&nr_include_guest_events);

> Also, EXPORT_SYMBOL_FOR_KVM() ?

Ya, for sure.  I posted this against a branch without EXPORT_SYMBOL_FOR_KVM(),
because there are also hard dependencies on the for-6.19 KVM pull requests, and
I didn't want to wait to post until 6.19-rc1 because of the impending winter
break.  Though I also simply forgot about these exports :-(

These could also use EXPORT_SYMBOL_FOR_KVM():

  EXPORT_SYMBOL_FOR_MODULES(perf_load_guest_lvtpc, "kvm");
  EXPORT_SYMBOL_FOR_MODULES(perf_put_guest_lvtpc, "kvm");


> I can make these edits when applying, if/when we get to applying. Let me
> continue reading.
> 

