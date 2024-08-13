Return-Path: <kvm+bounces-24047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1D4950B2D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 19:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85A60287893
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9063F1A2C38;
	Tue, 13 Aug 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i43OUZ2p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96E1A01C5
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723568809; cv=none; b=TbKEFrawO5NeAbYQJwaiE/7/LI/eUGgTDINqYXOwhwNv0gGbRJVUEuJYDu5YlQSCdkqoO6uMsaRYQcVzSGerUWUfOIpac3iF/enwyIddZvFFQrb9WllMllt4qRa3e1lVGsV5Di5xt2UAMSuR19ghK/bIpqcte9oVZXK5PaHb6u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723568809; c=relaxed/simple;
	bh=Mv6etaTZUzZ38QaIB2HSP43ojhfW0yOynjB0fFyB+go=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eNOhZFfZGMOwzrISG84cp1h8J3qquz+++uRVRE8JqEkcOTJjHT3I4UyUXPvsloY/mAH0YHwxrtd1q6Wf6v1jduRtRFN9tSok3rzRmrPBSYPp3BDHl0CUo0Y7OO8kDm8Oen6h7+HqehuV0V0mPB+Cg50lfytNRUgsMtEXER3YHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i43OUZ2p; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d34fa1726so5903474b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 10:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723568806; x=1724173606; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkQcAH5kDwVzfnb60m1ytw3oq42zm0XUjAUAaDgRcbs=;
        b=i43OUZ2ptoXhs5gwVcxuwp5HBOoi90zalbs74VyzQzuY/HreqrIa4dhW2aAWPhZ1fM
         fYZz9/izA489f0c7E6gigeAN9u9O8rSYk7tNNJfyvr1pLKqn6pBb+1jr2cENrSuCUbJ3
         r4vb8FmH4E861ZRmRXj8e1ACSnAxMbd0oElYYBgOugjD/E8HI6ciSKWHHFWfALTPvSqD
         SBVQL/0ddgWlKc+uTfzlzwSKu1nXkpJzDHttFlTqn3gjVhFH7P9FSNKm0skNC1dTxX8P
         PZvzZYxElusUVZzBd54xhchSaeu45qRspbTepcU8we+vKpJHjzio8r+3eLGWEcdoAi5v
         cAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723568806; x=1724173606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LkQcAH5kDwVzfnb60m1ytw3oq42zm0XUjAUAaDgRcbs=;
        b=NtZxFkeX4qbyt+UkbSLNq4QfIeP/xlf3k0a3rx0XqWflluk6gGG/xPQNsB5gUErkM4
         4OCAONXK5b0526Bo021qL1QioD+XjB/LMoP35Y6/sug6ovR554kcicnRkKu415WLAH+q
         KeGVkzNnfk8sQxuB6PMpElOHmLNMyKLnJQxjrxWS+sy5BU5jb3ntBIhfYw7H8a60dP+p
         tiok/C8QT41rOz1YPWWY7NJpbtcWyDuqb0FF5HAieQ9FHX0iCJ/UgAr72E2pk3ZpwwTb
         psNP+UCF8A7qrARiyR/9+ahtg9TrSDv0Hxvp1hghmjRFMmGvRpcUUQEjGYwxNqfjnoxY
         NLiA==
X-Forwarded-Encrypted: i=1; AJvYcCVd3DrJhxEZxVZB9q94u8TpWfBxpiJ7bnYetj+ORQqIQGpLnJXUdgoirrvL3K3pRhnnNAlzwBm6TjrWjfzM+lzYyluD
X-Gm-Message-State: AOJu0Yw55Lm7ukfS0WNCJpF1HzszjPGXx+G8qT3+yPMNLCf391SlT+Ea
	8+UU/Bp6Ce4sAkarDahtAwQOdHiwDxmnjwOwCn1sf1zWf8VV2WpSPMRNnQnW5jfpSqZC5ln0aMY
	LeA==
X-Google-Smtp-Source: AGHT+IGrDoLqD4wgt4TQE7o0u/hjGQ+TmDr68dAaYNJlImpX3UfrJriqGuJQ245/By9PgsvhLc5r89zIXcc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2c8e:b0:710:c996:84b8 with SMTP id
 d2e1a72fcca58-7126744860dmr4575b3a.5.1723568806321; Tue, 13 Aug 2024 10:06:46
 -0700 (PDT)
Date: Tue, 13 Aug 2024 10:06:44 -0700
In-Reply-To: <Zqi2RJKp8JxSedOI@freefall.freebsd.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710074410.770409-1-suleiman@google.com> <ZqhPVnmD7XwFPHtW@chao-email>
 <Zqi2RJKp8JxSedOI@freefall.freebsd.org>
Message-ID: <ZruSpDcysc2B-HQ-@google.com>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Cc: Chao Gao <chao.gao@intel.com>, Suleiman Souhlal <suleiman@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Suleiman Souhlal wrote:
> On Tue, Jul 30, 2024 at 10:26:30AM +0800, Chao Gao wrote:
> > Hi,
> > 
> > On Wed, Jul 10, 2024 at 04:44:10PM +0900, Suleiman Souhlal wrote:
> > >When the host resumes from a suspend, the guest thinks any task
> > >that was running during the suspend ran for a long time, even though
> > >the effective run time was much shorter, which can end up having
> > >negative effects with scheduling. This can be particularly noticeable
> > >if the guest task was RT, as it can end up getting throttled for a
> > >long time.
> > >
> > >To mitigate this issue, we include the time that the host was
> > >suspended in steal time, which lets the guest can subtract the
> > >duration from the tasks' runtime.
> > >
> > >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > >---
> > > arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
> > > include/linux/kvm_host.h |  4 ++++
> > > 2 files changed, 26 insertions(+), 1 deletion(-)
> > >
> > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >index 0763a0f72a067f..94bbdeef843863 100644
> > >--- a/arch/x86/kvm/x86.c
> > >+++ b/arch/x86/kvm/x86.c
> > >@@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > > 	struct kvm_steal_time __user *st;
> > > 	struct kvm_memslots *slots;
> > > 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> > >-	u64 steal;
> > >+	u64 steal, suspend_duration;
> > > 	u32 version;
> > > 
> > > 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
> > >@@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > > 			return;
> > > 	}
> > > 
> > >+	suspend_duration = 0;
> > >+	if (READ_ONCE(vcpu->suspended)) {
> > >+		suspend_duration = vcpu->kvm->last_suspend_duration;
> > >+		vcpu->suspended = 0;
> > 
> > Can you explain why READ_ONCE() is necessary here, but WRITE_ONCE() isn't used
> > for clearing vcpu->suspended?
> 
> Because this part of the code is essentially single-threaded, it didn't seem
> like WRITE_ONCE() was needed. I can add it in an eventual future version of
> the patch if it makes things less confusing (if this code still exists).

{READ,WRITE}_ONCE() don't provide ordering, they only ensure that the compiler
emits a load/store.  But (a) forcing the compiler to emit a load/store is only
necessary when it's possible for the compiler to know/prove that the load/store
won't affect functionalty, and (b) this code doesn't have have the correct
ordering even if there were the appropriate smp_wmb() and smp_rmb() annotations.

The writer needs to ensure the write to last_suspend_duration is visible before
vcpu->suspended is set, and the reader needs to ensure it reads last_suspend_duration
after vcpu->suspended.

That said, it's likely a moot point, because I assume the PM notifier runs while
tasks are frozen, i.e. its writes are guaranteed to be ordered before
record_steal_time().

And _that_ said, I don't see any reason for two fields, nor do I see any reason
to track the suspended duration in the VM instead of the vCPU.  Similar to what
Chao pointed out, per-VM tracking falls apart if only some vCPUs consume the
suspend duration.  I.e. just accumulate the suspend duration directly in the
vCPU.

> > >+	}
> > >+
> > > 	st = (struct kvm_steal_time __user *)ghc->hva;
> > > 	/*
> > > 	 * Doing a TLB flush here, on the guest's behalf, can avoid
> > >@@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > > 	unsafe_get_user(steal, &st->steal, out);
> > > 	steal += current->sched_info.run_delay -
> > > 		vcpu->arch.st.last_steal;
> > >+	steal += suspend_duration;
> > > 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
> > > 	unsafe_put_user(steal, &st->steal, out);
> > > 
> > >@@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > > 
> > > 	mutex_lock(&kvm->lock);
> > > 	kvm_for_each_vcpu(i, vcpu, kvm) {
> > >+		WRITE_ONCE(vcpu->suspended, 1);
> > > 		if (!vcpu->arch.pv_time.active)
> > > 			continue;
> > > 
> > >@@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > > 	}
> > > 	mutex_unlock(&kvm->lock);
> > > 
> > >+	kvm->suspended_time = ktime_get_boottime_ns();
> > >+
> > > 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
> > > }
> > > 
> > >+static int
> > >+kvm_arch_resume_notifier(struct kvm *kvm)

Do not wrap before the function name.  Linus has a nice explanation/rant on this[*].

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com

> > >+{
> > >+	kvm->last_suspend_duration = ktime_get_boottime_ns() -
> > >+	    kvm->suspended_time;
> > 
> > Is it possible that a vCPU doesn't get any chance to run (i.e., update steal
> > time) between two suspends? In this case, only the second suspend would be
> > recorded.
> 
> Good point. I'll address this.
> 
> > 
> > Maybe we need an infrastructure in the PM subsystem to record accumulated
> > suspended time. When updating steal time, KVM can add the additional suspended
> > time since the last update into steal_time (as how KVM deals with
> > current->sched_info.run_deley). This way, the scenario I mentioned above won't
> > be a problem and KVM needn't calculate the suspend duration for each guest. And
> > this approach can potentially benefit RISC-V and ARM as well, since they have
> > the same logic as x86 regarding steal_time.
> 
> Thanks for the suggestion.
> I'm a bit wary of making a whole PM subsystem addition for such a counter, but
> maybe I can make a architecture-independent KVM change for it, with a PM
> notifier in kvm_main.c.

Yes.  Either that, or the fields need to be in kvm_vcpu_arch, not kvm_vcpu.

> > Additionally, it seems that if a guest migrates to another system after a
> > suspend and before updating steal time, the suspended time is lost during
> > migration. I'm not sure if this is a practical issue.
> 
> The systems where the host suspends don't usually do VM migrations. Or at
> least the ones where we're encountering the problem this patch is trying to
> address don't (laptops).
>
> But even if they did, it doesn't seem that likely that the migration would
> happen over a host suspend.

I think we want to account for this straightaway, or at least have defined and
documented behavior, else we risk rehashing the issues with marking a vCPU as
preempted when it's loaded, but not running.  Which causes problems for live
migration as it results in KVM marking the steal-time page as dirty after vCPUs
have been paused.

[*] https://lkml.kernel.org/r/20240503181734.1467938-4-dmatlack%40google.com

