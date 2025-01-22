Return-Path: <kvm+bounces-36205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F167A1894C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CD4B165E83
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D45381B9;
	Wed, 22 Jan 2025 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gilFqFNW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AECB1B95B
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 01:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507762; cv=none; b=WXhrTwRbo5PGt2kP2UQws1GlIbzw1ppJHzkvPVVUdWL4ou4m8X3Zek5nnzXevUC4OcsPgMd5fiRpWBY+VPlRbUJS+Dky/4iJooHqze7hvPa7yGEa86XVImDD0cvTu+oliZhTsqdG8NxiuBR9ZcEki8jeQsTbYWy5Ze5oxzV4hlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507762; c=relaxed/simple;
	bh=tezEBsXCibYuUPXxrDS54MeSLHdiMXJHHD6Y5j5LjSs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQvHNYEU3IZreGJ3HkGwhHOMZ7Fs7WkZ+TDj4+0UZ+4USJ4GFx0Q5tOrUXJFVwQZ1J5T2qAtrVHEoRe9jFLldNQRJgwGtLmIQGZs2sAXZfgvk6H/udlWfrED8IcJ1a1gwLOnxm48zOTU0EPehgk1hRXUY+izYH7ouxQNv2TDEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gilFqFNW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef6ef86607so687868a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737507760; x=1738112560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qtzsnmCtQGm97ZN0VxmYbx5iyZWKhm71yYZLhaihqrQ=;
        b=gilFqFNWNpbY7QUigFUQVm1X+VSGh8+ZwiPjCAQ7SKJE3Zrra2GuhgjrP/Em9e1LoT
         Q4KbFq8oDRLt6vUxxnP1aeTolavX/gsoK/YcDWp76GkgFMZK6URpR3+qvq/9ouO6c+o2
         J1/L7v1bfyD9CQHUzNg/9HUe+CyjobLo66puktm78hCUirwROMwt5z71JzGQ9PNTgdQk
         HKJJ3COPulXJtB5EtNwALAz5FUpWVBkOVdMbqGAXAWmBfTaxHnR4NXAy7r/RRceDezmF
         Q685FeTgSpFXCy323QgaZ20vV9w9pOUqWvyOs3pEozYstC3fNPMTb3MiJ8fPrO38Y8cY
         OShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737507760; x=1738112560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qtzsnmCtQGm97ZN0VxmYbx5iyZWKhm71yYZLhaihqrQ=;
        b=RlPzaV5BPU7rKJTbWneTK9YwQrw8D6EACMNiRwbrQxH/TrGnAQTzltLvJZ/RWpSVml
         zc9qk6zea7HU8DMIjvEJ207wdat74GHZBSPeCN/LHREY4Av7zfSh+G3oXPHhQt5HzI3o
         oozfS6NBaBqMieN6fedIO7dkULGmfD21i8rjqXt2tr3dL3boJh2i9JeS1rF8eBAT6fbd
         hPUIfnC+H6QquoV3l9xcJgcLsxUBpcs9Y4HjgEoBD5YvtEbuzLCDLlVL9gc+eO6FHhHb
         iK1nIz2pljxiPRm1vDH8CoeXCoR29DDGD+M8I8Z+apbQzf7iagn4IELIlPsM077niHN8
         QVIg==
X-Gm-Message-State: AOJu0YwrmWC8yoIakWkJmn+qOJ/e0Ijj8rjyE6aRQ/OS0EQjCf24lb5Y
	XjFy+k16udqPuqtTVN4dnaItgpWoNplWHWIS4CAkbLKicyXebSg1ys4r6my2x+a/r1diY89F/C5
	j+A==
X-Google-Smtp-Source: AGHT+IGCg0gBqLJHF9Rf1exnB3Lx4P32xL0ddeQecsqgMfDx1FqZkMKv0Nm6HZbwj6IB/oxJDe9OoLEN8ps=
X-Received: from pjbeu16.prod.google.com ([2002:a17:90a:f950:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a81:b0:2ef:7be8:e987
 with SMTP id 98e67ed59e1d1-2f728e4841cmr40912107a91.12.1737507760506; Tue, 21
 Jan 2025 17:02:40 -0800 (PST)
Date: Tue, 21 Jan 2025 17:02:39 -0800
In-Reply-To: <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c9d8269bff69f6359731d758e3b1135dedd7cc61.camel@redhat.com>
 <Zx-z5sRKCXAXysqv@google.com> <948408887cbe83cbcf05452a53d33fb5aaf79524.camel@redhat.com>
Message-ID: <Z5BDr2mm57F0vfax@google.com>
Subject: Re: vmx_pmu_caps_test fails on Skylake based CPUS due to read only LBRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Nov 03, 2024, Maxim Levitsky wrote:
> On Mon, 2024-10-28 at 08:55 -0700, Sean Christopherson wrote:
> > On Fri, Oct 18, 2024, Maxim Levitsky wrote:
> > > Our CI found another issue, this time with vmx_pmu_caps_test.
> > > 
> > > On 'Intel(R) Xeon(R) Gold 6328HL CPU' I see that all LBR msrs (from/to and
> > > TOS), are always read only - even when LBR is disabled - once I disable the
> > > feature in DEBUG_CTL, all LBR msrs reset to 0, and you can't change their
> > > value manually.  Freeze LBRS on PMI seems not to affect this behavior.

...

> When DEBUG_CTL.LBR=1, the LBRs do work, I see all the registers update,
> although TOS does seem to be stuck at one value, but it does change
> sometimes, and it's non zero.
> 
> The FROM/TO do show healthy amount of updates 
> 
> Note that I read all msrs using 'rdmsr' userspace tool.

I'm pretty sure debugging via 'rdmsr', i.e. /dev/msr, isn't going to work.  I
assume perf is clobbering LBR MSRs on context switch, but I haven't tracked that
down to confirm (the code I see on inspecition is gated on at least one perf
event using LBRs).  My guess is that there's a software bug somewhere in the
perf/KVM exchange.

I confirmed that using 'rdmsr' and 'wrmsr' "loses" values, but that hacking KVM
to read/write all LBRs during initialization works with LBRs disabled.

---
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f72835e85b6d..c68a5a79c668 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7907,6 +7907,8 @@ static __init u64 vmx_get_perf_capabilities(void)
 {
        u64 perf_cap = PMU_CAP_FW_WRITES;
        u64 host_perf_cap = 0;
+       u64 debugctl, val;
+       int i;
 
        if (!enable_pmu)
                return 0;
@@ -7954,6 +7956,39 @@ static __init u64 vmx_get_perf_capabilities(void)
                perf_cap &= ~PERF_CAP_PEBS_BASELINE;
        }
 
+       if (!vmx_lbr_caps.nr) {
+               pr_warn("Uh, what?  No LBRs...\n");
+               goto out;
+       }
+
+       rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+       if (debugctl & DEBUGCTLMSR_LBR) {
+               pr_warn("Huh, LBRs enabled at KVM load?  debugctl = %llx\n", debugctl);
+               wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~DEBUGCTLMSR_LBR);
+       }
+
+       for (i = 0; i < vmx_lbr_caps.nr; i++) {
+               wrmsrl(vmx_lbr_caps.from + i, 0xbeef0000 + i);
+               wrmsrl(vmx_lbr_caps.to + i, 0xcafe0000 + i);
+       }
+
+       for (i = 0; i < vmx_lbr_caps.nr; i++) {
+               rdmsrl(vmx_lbr_caps.from + i, val);
+               if (val != 0xbeef0000 + i)
+                       pr_warn("MSR 0x%x Expected %x, got %llx\n",
+                               vmx_lbr_caps.from + i, 0xbeef0000 + i, val);
+               rdmsrl(vmx_lbr_caps.to + i, val);
+               if (val != 0xcafe0000 + i)
+                       pr_warn("MSR 0x%x Expected %x, got %llx\n",
+                               vmx_lbr_caps.from + i, 0xcafe0000 + i, val);
+       }
+
+       pr_warn("Done validating %u from/to LBRs\n", vmx_lbr_caps.nr);
+
+       if (debugctl & DEBUGCTLMSR_LBR)
+               wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+
+out:
        return perf_cap;
 }
--

And given that perf explicitly disables LBRs (see __intel_pmu_lbr_disable())
before reading LBR MSRs (see intel_pmu_lbr_read()) when taking a snaphot, and
AFAIK no one has complained, I would be very surprised if this is hardware doing
something odd.

---
static noinline int
__intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries,
				  unsigned int cnt, unsigned long flags)
{
	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);

	intel_pmu_lbr_read();
	cnt = min_t(unsigned int, cnt, x86_pmu.lbr_nr);

	memcpy(entries, cpuc->lbr_entries, sizeof(struct perf_branch_entry) * cnt);
	intel_pmu_enable_all(0);
	local_irq_restore(flags);
	return cnt;
}

static int
intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int cnt)
{
	unsigned long flags;

	/* must not have branches... */
	local_irq_save(flags);
	__intel_pmu_disable_all(false); /* we don't care about BTS */
	__intel_pmu_lbr_disable();
	/*            ... until here */
	return __intel_pmu_snapshot_branch_stack(entries, cnt, flags);
}
---

