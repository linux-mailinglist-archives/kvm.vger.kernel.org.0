Return-Path: <kvm+bounces-45139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BD9AA619D
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC6494A0332
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 16:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AD72144D7;
	Thu,  1 May 2025 16:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="db2/jfjW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876E21BD9F0
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746118608; cv=none; b=gcOf6uIbqZCy28W85bY/KWoHOKzxMIahB9esasa0nBNm+1yzeSyzc3M2rHqxHXNj3CCT1UGN6AmsbjfhxmS1KzvL6V+cLUGOgjr7OQcvceXNelDeDDpiQKtN6ZIIB9ryEpnG44t/p/TUqmawMD5DotztrtOEc+6RcD7YYU4LWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746118608; c=relaxed/simple;
	bh=RWONKRAMHQx/HHtWaaMS3+TSfg9I2vQ3LOiF7JfAbco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBnpYMUqzXB2BEyGXnulg9p6jB9vjiaqHSGb+W1V3rm4+JQoqgt4XlDx1SVUqUD9MNyBogj+hDEDlPDT5y/8v/KrG4uwpfPlU11QxehET6GetRkZOTPpSMHTH0XtDi+WpH9OPJMZp/tBtaGIrdSO+u/uT1KWWW9VYMXhJ+DybQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=db2/jfjW; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115383fcecso731886a12.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 09:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746118606; x=1746723406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5/GDZxMbT7to+hhJRhFiVGdhYtg0uYrOFj+zZ21/OJc=;
        b=db2/jfjW9xOwXEpO0mDihbTmc+hKjhpvjUfbUWZBVqwQgwEqtRl/O6bvQdaisf/X6J
         Wmd/RzyrMVQJARE8uVpP2ASdaA/w8uXlygSIS85XkJMufRR0HHcWNNlopnxINqdlmhgD
         B60xaXTpqrNTufqc9v1rkrP5EhRQg7PROPeEdBnzRaK8pPRkmVrE+LDS+SOxOOqrglF8
         kgOt36rLkWNhlqHcSJwAPcRguxQaauBL8X2UE6k6iw324fYCaBnx93SXnt4fBRvdPqbd
         9gtPrSkucNTdCVJVILp4T44odfWhaAgn6xAxLUlo2VDo23nhHuN2yYGJ87xppAbEHBiO
         6iTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746118606; x=1746723406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/GDZxMbT7to+hhJRhFiVGdhYtg0uYrOFj+zZ21/OJc=;
        b=ETrww9dEpW/BeeHO9g+4GhhhRTmFnMZwCpFsI61Q8ekyOESA80O/PQun1VmVGPcy1B
         7iK4ymrP0BMZKTDjNVt+Ob9kvohvVEQJWQM9WyYn3GzUmPxsgpmaUEoHpwOBe1Vj6Ug8
         FAOqcNcpnATZgJv7dSAr0vK9R/8Wy6anTo2RLxP13z3WwaxrlzpfIVAQHW80ftEHY/X4
         f+SXuC6xYaZsE5yj6dvMs+YVjaNeDW6utMNzsZvf3IPL9+JJbRNITuwLGEdUnzGKSF8i
         rcsazQhCYPR/KOOj/IXdtiwe1fkqfddGw2jKJx9rh0fJqjwa1IkQRChXSyrDUbxMmGbF
         aoVQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0gxn3wGg2sQCnBC6ARK5EbaY7a13McbL/5Yj5cVu6tFM/ZSahwdl96WfNCJA6BqrFG+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsCPJLPEarErsMyNS/E1G3EY6dV/mywRHfTYJX/NUEBNTN8gMN
	171s16R0YYWaqdj0gc0Ls2i4uLTiXpzsW9+cuVXIFgtp6ys01RLm4/IRShG4ibZitzD+s/HAZbr
	XXQ==
X-Google-Smtp-Source: AGHT+IEtBgmWNLgCGNVs8Cyt3BKE0GnMHx+2E060vOGPHL+JaEOIee7LkbWlK0+C5WjFVOEc5Q+6CAAlAaA=
X-Received: from pjbsw7.prod.google.com ([2002:a17:90b:2c87:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5290:b0:2ff:5e4e:861
 with SMTP id 98e67ed59e1d1-30a4335de2fmr5395426a91.24.1746118605906; Thu, 01
 May 2025 09:56:45 -0700 (PDT)
Date: Thu, 1 May 2025 09:56:44 -0700
In-Reply-To: <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.> <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
 <Z7OUZhyPHNtZvwGJ@Asmaa.> <20250217202048.GIZ7OaIOWLH9Y05U-D@fat_crate.local>
 <f16941c6a33969a373a0a92733631dc578585c93@linux.dev> <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
 <20250429132546.GAaBDTWqOsWX8alox2@fat_crate.local> <aBKzPyqNTwogNLln@google.com>
 <20250501081918.GAaBMuhq6Qaa0C_xk_@fat_crate.local>
Message-ID: <aBOnzNCngyS_pQIW@google.com>
Subject: Re: x86/bugs: KVM: Add support for SRSO_MSR_FIX, back for moar
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Patrick Bellasi <derkling@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Patrick Bellasi <derkling@matbug.net>, 
	Brendan Jackman <jackmanb@google.com>, David Kaplan <David.Kaplan@amd.com>, 
	Michael Larabel <Michael@michaellarabel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 01, 2025, Borislav Petkov wrote:
> On Wed, Apr 30, 2025 at 04:33:19PM -0700, Sean Christopherson wrote:
> > +static void svm_srso_add_remove_vm(int count)
> > +{
> > +	bool set;
> > +
> > +	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
> > +		return;
> > +
> > +	guard(mutex)(&srso_lock);
> > +
> > +	set = !srso_nr_vms;
> > +	srso_nr_vms += count;
> > +
> > +	WARN_ON_ONCE(srso_nr_vms < 0);
> > +	if (!set && srso_nr_vms)
> > +		return;
> 
> So instead of doing this "by-foot", I would've used any of those
> atomic_inc_return() and atomic_dec_and_test() and act upon the value when it
> becomes 0 or !0 instead of passing 1 and -1. Because the count is kinda
> implicit...

Heh, I considered that, and even tried it this morning because I thought it wouldn't
be as tricky as I first thought, but turns out, yeah, it's tricky.  The complication
is that KVM needs to ensure BP_SPEC_REDUCE=1 on all CPUs before any VM is created.

I thought it wouldn't be _that_ tricky once I realized the 1=>0 case doesn't require
ordering, e.g. running host code while other CPUs have BP_SPEC_REDUCE=1 is totally
fine, KVM just needs to ensure no guest code is executed with BP_SPEC_REDUCE=0.
But guarding against all the possible edge cases is comically difficult.

For giggles, I did get it working, but it's a rather absurd amount of complexity
for very little gain.  In practice, when srso_nr_vms >= 1, CPUs will hold the lock
for only a handful of cycles.  The latency of VM creation is somewhat important,
but it's certainly not that latency sensitive, e.g. KVM already serializes VM
creation on kvm_lock (which is a mutex) in order to add VMs to vm_list.

The only truly slow path is the 0<=>1 transitions, and those *must* be slow to
get the ordering correct.

One thing I can/will do is change the mutex into a spinlock, so that on non-RT
systems there's zero chance of VM creation getting bogged down because a task
happens to get preempted at just the wrong time.  I was thinking it's illegal to
use on_each_cpu() in a spinlock, but that's fine; it's using it with IRQs disabled
that's problematic.

I'll post a proper patch with the spinlock and CONFIG_CPU_MITIGATIONS #ifdef,
assuming testing comes back clean.

As for all the problematic scenarios...  If KVM increments the counter before
sending IPIs, then reacing VM creation can result in the second VM skipping the
mutex and doing KVM_RUN with BP_SPEC_REDUCE=0.

  VMs     MSR     CPU-0   CPU-1
  -----------------------------
  0       0       CREATE
  0       0       lock()
  1       0       inc()
  1       0               CREATE
  2       0               inc()
  2       0               KVM_RUN :-(
  2       0       IPI
  2       1       WRMSR   WRMSR

But simply incrementing the count after sending IPIs obviously doesn't work.

  VMs     MSR     CPU-0   CPU-1
  -----------------------------
  0       0       CREATE
  0       0       lock()
  0       0       IPI
  0       0       WRMSR   WRMSR
  1       0       inc()
  1       0       KVM_RUN :-(

And passing in set/clear (or using separate IPI handlers) doesn't handle the case
where the IPI from destroy arrives after the IPI from create.

  VMs     MSR     CPU-0   CPU-1
  -----------------------------
  1       1               DESTROY
  0       1       CREATE  dec()
  0       1       lock()
  0       1       IPI(1)
  0       1       WRMSR   WRMSR
  0       1               IPI(0)
  0       0       WRMSR   WRMSR
  1       0       inc()
  1       0       KVM_RUN :-(

Addressing that by adding a global flag to track that SRSO needs to be set
almost works, but there's still a race with a destroy IPI if the callback only
checks the "set" flag.

  VMs     MSR     CPU-0   CPU-1
  -----------------------------
  1       1               DESTROY
  0       1       CREATE  dec()
  0       1       lock()
  0       1       set=1
  0       1       IPI
  0       1       WRMSR   WRMSR
  1       0       inc()
  1       1       set=0
  1       1               IPI
  1       0       WRMSR   WRMSR
  1       0       KVM_RUN :-(

To address all of those, I ended up with the below.  It's not actually that much
code, but amount of documentation needed to explain everything is ugly.

#ifndef CONFIG_CPU_MITIGATIONS
static DEFINE_MUTEX(srso_add_vm_lock);
static atomic_t srso_nr_vms;
static bool srso_set;

static void svm_toggle_srso_spec_reduce(void *ign)
{
	/*
	 * Read both srso_set and the count (and don't pass in set/clear!) so
	 * that BP_SPEC_REDUCE isn't incorrectly cleared if IPIs from destroying
	 * he last VM arrive after IPIs from creating the first VM (in the new
	 * "generation").
	 */
	if (READ_ONCE(srso_set) || atomic_read(&srso_nr_vms))
		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
	else
		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
}

static void svm_srso_vm_init(void)
{
	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
		return;

	/*
	 * Acquire the mutex on a 0=>1 transition to ensure BP_SPEC_REDUCE is
	 * set before any VM is fully created.
	 */
	if (atomic_inc_not_zero(&srso_nr_vms))
		return;

	guard(mutex)(&srso_add_vm_lock);

	/*
	 * Re-check the count before sending IPIs, only the first task needs to
	 * toggle BP_SPEC_REDUCE, other tasks just need to wait.  For the 0=>1
	 * case, update the count *after* BP_SPEC_REDUCE is set on all CPUs to
	 * ensure creating multiple VMs concurrently doesn't result in a task
	 * skipping the mutex before BP_SPEC_REDUCE is set.
	 *
	 * Atomically increment the count in all cases as the mutex only guards
	 * 0=>1 transitions, e.g. another task can decrement the count if a VM
	 * was created (0=>1) *and* destroyed (1=>0) between observing a count
	 * of '0' and acquiring the mutex, and another task can increment the
	 * count if the count is already >= 1.
	 */
	if (!atomic_inc_not_zero(&srso_nr_vms)) {
		WRITE_ONCE(srso_set, true);
		on_each_cpu(svm_toggle_srso_spec_reduce, NULL, 1);
		atomic_inc(&srso_nr_vms);
		smp_mb__after_atomic();
		WRITE_ONCE(srso_set, false);
	}
}

static void svm_srso_vm_destroy(void)
{
	if (!cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
		return;

	/*
	 * If the last VM is being destroyed, clear BP_SPEC_REDUCE on all CPUs.
	 * Unlike the creation case, there is no need to wait on other CPUs as
	 * running code with BP_SPEC_REDUCE=1 is always safe, KVM just needs to
	 * ensure guest code never runs with BP_SPEC_REDUCE=0.
	 */
	 if (atomic_dec_and_test(&srso_nr_vms))
		on_each_cpu(svm_toggle_srso_spec_reduce, NULL, 0);
}
#else
static void svm_srso_vm_init(void) { }
static void svm_srso_vm_destroy(void) { }
#endif /* CONFIG_CPU_MITIGATIONS */

