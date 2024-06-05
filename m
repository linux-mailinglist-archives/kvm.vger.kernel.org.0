Return-Path: <kvm+bounces-18947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F3D8FD663
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 21:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CADB81F24DD8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 19:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C0F14D704;
	Wed,  5 Jun 2024 19:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B4Ix76RS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9941C79
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 19:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717615408; cv=none; b=lwA12UxfVPCzVwG6qbSpS53Ah+2ozato3rrCVGSTexvfuJfaMpztnbeg6mq9hXEObafpZLlP7GAbz22d/ikQPfhuTHJgvzFJ5PNkTxlwO0Aa9KUvRtq8RRljuu1VPr0mYyGoGm9tXvEj07UvbdC8V2r1FD0q1Ua1x8AYrk+dAZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717615408; c=relaxed/simple;
	bh=xNUmRVBbmLabH02EGVqYiDi8R5t5o+k1GtkwwSRV3cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eR/HSLWJFCf48VmeZhTXggKwNEwIxWle9AUAKnsr4lMxdAipscL2wi6L6KYKCR8MCCJ77+20q4tlnknu+IZmXhlVUcEbp9iqkqxfiiwNcREIWPI+CZlP+8pP/B7TLjvE265Ud3qm6Un+bHOMBCDABfWC7hkd60f8lZWHYQuyKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B4Ix76RS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6238a6c2eso1828025ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 12:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717615406; x=1718220206; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HezPimuT7DFljRqo9XN5Xky8zEqqwviG0WSUPHBG4qk=;
        b=B4Ix76RSqkv+y4i6v4gQVjkMddLbco/BePGAvfNwGduqYiCtOi7DpcAfHVcDP3RXxK
         jvVuVr1OdJ+sxVBUSoaRnKyQ6hlHmvO9g88mVTXu4ahbvwF6dK6L75jVzKZ33hUZCoDF
         nWm4Ln3587vrqHGM70E3Gek9aTRbu6ISNxOHLS//X43k3QOKwHAVZThF6G4AaryYIrIo
         wf0UzCVWhb70lF1rdSbW3siZKL/a3zu9Y/MP9SRf2q1eKJas1CZg5XO5Wtr+bLLIMXa+
         0i+A012BHpkfnrwb7avJyVNRj5dkc5b1Z2sueQJOmtYzCy+S94oCN213q5RqOLGv9Ac7
         L11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717615406; x=1718220206;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HezPimuT7DFljRqo9XN5Xky8zEqqwviG0WSUPHBG4qk=;
        b=ssdQVACt++54ES4bywBF7ObLy8o1vQAVNAWXIJlxtrT/pOy8uTtG8H1msxmGRL3O6K
         CRg/SlydHmXzKLhEKCV4G7/HA3q7m5Ga/ACvq2el4KQGHd7qHn/ZCVfjhZre+U2lWo6h
         4Oi71INVvnV5SdwtgQEPifJwptPh54qc2vG2/1jU3YIwKbmmzNfFZ8K5fBr9+k2uz388
         3YJGCQ3WaXdSis9H0OcVZ72ksKsddzrHJYcWgxVCzUApz0kxtYK3F2rmwh1aS84CeNtC
         fwkJDr1k+bjOopBwivYYOIUBpjrAsCtFWnKRCxLeV9CGR3snohA3UB4Y0qBaIHiGxbnt
         ZGcQ==
X-Gm-Message-State: AOJu0Yz9OGWgxjaAjlkjqhetsqApvuYtbZPzI8/T3QsG4XODCLbGUd3k
	3BiX45/iprmLNKzZ+UN7tflKlJlIW49ZJdFDGFlhlq4Ufj8PMx4/hS03TJgdoyl85WvAUbRm17f
	d9Q==
X-Google-Smtp-Source: AGHT+IFzrEmr5nF2FZTs3UrZy2ZIxgWCOEy7JH3ZPIKTEhCKIdSOG35K1jMzGLeDgwa2kOlSDu4OyValsPg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50e:b0:1f6:6900:5947 with SMTP id
 d9443c01a7336-1f6a5a0c1a4mr2050405ad.5.1717615405861; Wed, 05 Jun 2024
 12:23:25 -0700 (PDT)
Date: Wed, 5 Jun 2024 12:23:24 -0700
In-Reply-To: <20230504134908.830041-1-rkagan@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230504134908.830041-1-rkagan@amazon.de>
Message-ID: <ZmC7LB6e8nXkMo7G@google.com>
Subject: Re: [kvm-unit-tests] x86/pmu: add testcase for WRMSR to counter in
 PMI handler
From: Sean Christopherson <seanjc@google.com>
To: Roman Kagan <rkagan@amazon.de>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 04, 2023, Roman Kagan wrote:
> Add a testcase where the PMI handler writes a negative value to the perf
> counter whose overflow would trigger that PMI.
> 
> It's meant specifically to cover the KVM bug where every negative value
> written to the counter caused an immediate overflow; in that case the
> vCPU would never leave PMI loop.
> 
> The bug is addressed in
> https://lore.kernel.org/kvm/20230504120042.785651-1-rkagan@amazon.de;
> until this (or some alternative) fix is merged the test will hang on
> this testcase.
> 
> Signed-off-by: Roman Kagan <rkagan@amazon.de>
> ---
>  x86/pmu.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 72c2c9cfd8b0..cdf9093722fb 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -74,6 +74,7 @@ static void cnt_overflow(isr_regs_t *regs)
>  static bool check_irq(void)
>  {
>  	int i;
> +	apic_write(APIC_LVTPC, PMI_VECTOR);
>  	irq_received = 0;
>  	irq_enable();
>  	for (i = 0; i < 100000 && !irq_received; i++)
> @@ -156,7 +157,6 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
>  	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
>      }
>      global_enable(evt);
> -    apic_write(APIC_LVTPC, PMI_VECTOR);
>  }
>  
>  static void start_event(pmu_counter_t *evt)
> @@ -474,6 +474,45 @@ static void check_running_counter_wrmsr(void)
>  	report_prefix_pop();
>  }
>  
> +static void cnt_overflow_with_wrmsr(isr_regs_t *regs)
> +{
> +	cnt_overflow(regs);
> +	/* write negative value that won't cause immediate overflow */
> +	wrmsr(MSR_GP_COUNTERx(0),
> +	      ((-1ull) << 31) & ((1ull << pmu.gp_counter_width) - 1));
> +}

This seems way more complicated than it needs to be.  Linux does the write in its
PMI, but that isn't relevant to hitting the bug, it only makes the bug visible,
i.e. hangs the guest.

Wouldn't it suffice to write a negative value that isn't supposed to overflow,
and then assert that overflow doesn't happen?

If the the PMI shenanigans are needed for some reason, I would vote to just switch
out the handler, not change the vector, which I find weird and unintuitive, e.g.

diff --git a/x86/pmu.c b/x86/pmu.c
index f67da863..6cdd644c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -159,6 +159,7 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
            wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
     global_enable(evt);
+    apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
@@ -493,9 +494,9 @@ static void check_running_counter_wrmsr_in_pmi(void)
        };
 
        report_prefix_push("running counter wrmsr in PMI");
+       handle_irq(PMI_VECTOR, cnt_overflow_with_wrmsr);
 
        start_event(&evt);
-       apic_write(APIC_LVTPC, PMI_VECTOR + 1);
 
        irq_received = 0;
        irq_enable();
@@ -509,6 +510,9 @@ static void check_running_counter_wrmsr_in_pmi(void)
        loop();
        stop_event(&evt);
        irq_disable();
+
+       handle_irq(PMI_VECTOR, cnt_overflow);
+
        report(evt.count >= gp_events[1].min, "cntr");
        report(irq_received, "irq");
 
@@ -755,7 +759,6 @@ int main(int ac, char **av)
 {
        setup_vm();
        handle_irq(PMI_VECTOR, cnt_overflow);
-       handle_irq(PMI_VECTOR + 1, cnt_overflow_with_wrmsr);
        buf = malloc(N*64);
 
        check_invalid_rdpmc_gp();
@@ -782,6 +785,8 @@ int main(int ac, char **av)
        printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
        printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
+       apic_write(APIC_LVTPC, PMI_VECTOR);
+
        check_counters();
 
        if (pmu_has_full_writes()) {



