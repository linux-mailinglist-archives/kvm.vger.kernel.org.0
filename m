Return-Path: <kvm+bounces-62831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC51DC50920
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 05:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7CAEF4E8379
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 04:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE6D2D7397;
	Wed, 12 Nov 2025 04:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNVsMenv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067AB78F5D
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 04:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762923309; cv=none; b=oHEj93+InUaI3KMavPjMHZJYbIErYEGZ1odc6F0UR1eJiUcihkMXQS0wee5KtIcSnmDURzrGSmtUYnd423Zkh4lhEZBhycWDlYcWvlyNdnZMnTPCaFuIva4t55FNktNnD6CqgXK0MO0QMLTGzj45Ni8aLm9VPaHBm3HF5AtnBbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762923309; c=relaxed/simple;
	bh=l5LGlODZ4xD/2Y15vU5UzbitjXKwIH/KoNWDjovVBvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJvB3D2QB21AI5e39I8AuIPNpjfiFrsCqp/6iKPfXuMoVtf7c/9a4jEyEVrLktWBaknc9qecio+egtL1JcigursJgiZfN+bd+qoiHW6lZlz50A1hkcwGztWuQToShzkFi3eQJixr8mGB71Ih/ZYdUNlwUjWHNteH4IOdhhHNJlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNVsMenv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3436a97f092so520024a91.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 20:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762923307; x=1763528107; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+ZEKdeS8OnccJT/18IWvvdObkq3Vpl4Fxqk4ywgHOU=;
        b=KNVsMenv/qRTUVSZ1OVie4wucMWhgBGkUVSpNOkTQVj0ytHC+OPTrjO/7FZzra6GGp
         Ol2iQ4ZDbxxkrm5Z7OoeK0JLvoqfGgxIW+ubgcuH78t4O99B3wLyhDiDrHEMWHHZef6Q
         2JRbaUjGYlMwBfdzG5uLVfEaWdc84s2piKGyzXKLP36/I4u86pjAsd+v5OoFbqyGqXFv
         g6omI/PbFohskfWyuygIzINxxqT1jX2Mzv25XiLbFL9wI7+Df6svnYpl/VTXWgrOE+5f
         qHIHFE6vfseUe1H61OqfZx9fzHwirP/HdTfdSegFOgAFOWj6+FZzZBZKI5sn7xz4vWqx
         P4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762923307; x=1763528107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x+ZEKdeS8OnccJT/18IWvvdObkq3Vpl4Fxqk4ywgHOU=;
        b=XqlEsqdsFRM2ZDMFLaEGmztgIXOOiEQ7xnvySe2gtUyoniFDZ6iSfFL5X16sRdzJ6c
         XXE/MKNv/o4HDRGZ4WWf+ZxOKRjY5t6wjgjbExdvywvgrbgL/XwAQi+KPjOsxqxPi2Ke
         3RZ9fxx90FrCeGjdIjmGg11oWI8rcRQyWX7gsYnBEONqKsi//vYww9hegaEINPEVC4rx
         OA6is4Cwhq7rpuGj/3f6dD7uomzMMC/CPVOKzW/QkA2YWdQbVcz5K9ALcPdQWB02zIeU
         s2fqUyhkEcW8Pd7Ml2cwkYkT9ojSBfjMMLBsIGLyCgP/3efEivZCwOkY/dEveDl6wqPF
         DfhA==
X-Forwarded-Encrypted: i=1; AJvYcCXSkjNjPNWyDIA2u+VteQxeYCD6f2Ek6YpkgssjawyhKagP9/4t7fG2DMQZaeSL97CV/xA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/UsuDNM8QTLErpzUMSSD7mUp7W2L7IfRhm2tBwvatR4LW/1Yx
	LiChdu5KhABMQRIHnHQ01q/Zf1ybTeA+6qGbr305O4kXwZTU3IsVHSqkpve3d/eHiq+DUHtmzpo
	JJOPTyM8If8F9IkuI0CmfimgfNowGTbo=
X-Gm-Gg: ASbGncsL0ASWpwExQNgzRN1eSk1YUKi8z/dBFzayUzp86IGiPkfJmqMr7qHn2evl8Eb
	5YVpvnLOuPFlpGgd3RgknoII8srOWtYlazJCjTrTlwQviLHSX8pBe7Zn/+I0+JR2dBEGlAeb0RM
	o0UJaD+x3sUdt8tBN3sjzxUHuoCmweREyG+lF5sdIdQsMbMigcz1raPo5YTkumhavh9HoL82ucm
	TRx0VI5Osa6WxIJYVs3ZwoRoHeaimsPC/jOWdbsEyczhmGZgSl/G0I1FUFF
X-Google-Smtp-Source: AGHT+IGezlfWHsutFc7rVUn5xqIPdMjVgQZhCmkOAuauj8q4oRr7GNK9VuedAhMp2Mp+LopXY/EbfZGg46CMy+swljo=
X-Received: by 2002:a17:90b:510b:b0:32d:a0f7:fa19 with SMTP id
 98e67ed59e1d1-343ddeadc69mr2528906a91.17.1762923307226; Tue, 11 Nov 2025
 20:55:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
In-Reply-To: <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Wed, 12 Nov 2025 12:54:56 +0800
X-Gm-Features: AWmQ_bn1qDk9i98u17BRaRFYgjDjEnolIymTBUUZqbFC072gwUWymGKR4ygmP8w
Message-ID: <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prateek,

On Tue, 11 Nov 2025 at 14:28, K Prateek Nayak <kprateek.nayak@amd.com> wrot=
e:
>
> Hello Wanpeng,
>
> I haven't looked at the entire series and the penalty calculation math
> but I've a few questions looking at the cover-letter.

Thanks for the review and the thoughtful questions.

>
> On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > This series addresses long-standing yield_to() inefficiencies in
> > virtualized environments through two complementary mechanisms: a vCPU
> > debooster in the scheduler and IPI-aware directed yield in KVM.
> >
> > Problem Statement
> > -----------------
> >
> > In overcommitted virtualization scenarios, vCPUs frequently spin on loc=
ks
> > held by other vCPUs that are not currently running. The kernel's
> > paravirtual spinlock support detects these situations and calls yield_t=
o()
> > to boost the lock holder, allowing it to run and release the lock.
> >
> > However, the current implementation has two critical limitations:
> >
> > 1. Scheduler-side limitation:
> >
> >    yield_to_task_fair() relies solely on set_next_buddy() to provide
> >    preference to the target vCPU. This buddy mechanism only offers
> >    immediate, transient preference. Once the buddy hint expires (typica=
lly
> >    after one scheduling decision), the yielding vCPU may preempt the ta=
rget
> >    again, especially in nested cgroup hierarchies where vruntime domain=
s
> >    differ.
>
> So what you are saying is there are configurations out there where vCPUs
> of same guest are put in different cgroups? Why? Does the use case
> warrant enabling the cpu controller for the subtree? Are you running

You're right to question this. The problematic scenario occurs with
nested cgroup hierarchies, which is common when VMs are deployed with
cgroup-based resource management. Even when all vCPUs of a single
guest are in the same leaf cgroup, that leaf sits under parent cgroups
with their own vruntime domains.

The issue manifests when:
   - set_next_buddy() provides preference at the leaf level
   - But vruntime competition happens at parent levels
   - The buddy hint gets "diluted" when pick_task_fair() walks up the hiera=
rchy

The cpu controller is typically enabled in these deployments for quota
enforcement and weight-based sharing. That said, the debooster
mechanism is designed to be general-purpose: it handles any scenario
where yield_to() crosses cgroup boundaries, whether due to nested
hierarchies or sibling cgroups.

> with the "NEXT_BUDDY" sched feat enabled?

Yes, NEXT_BUDDY is enabled. The problem is that set_next_buddy()
provides only immediate, transient preference. Once the buddy hint is
consumed (typically after one pick_next_task_fair() call), the
yielding vCPU can preempt the target again if their vruntime values
haven't diverged sufficiently.

>
> If they are in the same cgroup, the recent optimizations/fixes to
> yield_task_fair() in queue:sched/core should help remedy some of the
> problems you might be seeing.

Agreed - the recent yield_task_fair() improvements in queue:sched/core
(EEVDF-based vruntime =3D deadline with hierarchical walk) are valuable.
However, our patchset focuses on yield_to() rather than yield(), which
has different semantics:
   - yield_task_fair(): "I voluntarily give up CPU, pick someone else"
=E2=86=92 Recent improvements handle this well with hierarchical walk
   - yield_to_task_fair(): "I want *this specific task* to run
instead" =E2=86=92 Requires finding the LCA of yielder and target, then
applying penalties at that level to influence their relative
competition

The debooster extends yield_to() to handle cross-cgroup scenarios
where the yielder and target may be in different subtrees.

>
> For multiple cgroups, perhaps you can extend yield_task_fair() to do:

Thanks for the suggestion. Your hierarchical walk approach shares
similarities with our implementation. A few questions on the details:

>
> ( Only build and boot tested on top of
>     git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git sched/core
>   at commit f82a0f91493f "sched/deadline: Minor cleanup in
>   select_task_rq_dl()" )
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b4617d631549..87560f5a18b3 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -8962,10 +8962,28 @@ static void yield_task_fair(struct rq *rq)
>          * which yields immediately again; without the condition the vrun=
time
>          * ends up quickly running away.
>          */
> -       if (entity_eligible(cfs_rq, se)) {
> +       do {
> +               cfs_rq =3D cfs_rq_of(se);
> +
> +               /*
> +                * Another entity will be selected at next pick.
> +                * Single entity on cfs_rq can never be ineligible.
> +                */
> +               if (!entity_eligible(cfs_rq, se))
> +                       break;
> +
>                 se->vruntime =3D se->deadline;

Setting vruntime =3D deadline zeros out lag. Does this cause fairness
drift with repeated yields? We explicitly recalculate vlag after
adjustment to preserve EEVDF invariants.

>                 se->deadline +=3D calc_delta_fair(se->slice, se);
> -       }
> +
> +               /*
> +                * If we have more than one runnable task queued below
> +                * this cfs_rq, the next pick will likely go for a
> +                * different entity now that we have advanced the
> +                * vruntime and the deadline of the running entity.
> +                */
> +               if (cfs_rq->h_nr_runnable > 1)

Stopping at h_nr_runnable > 1 may not handle cross-cgroup yield_to()
correctly. Shouldn't the penalty apply at the LCA of yielder and
target? Otherwise the vruntime adjustment might not affect the level
where they actually compete.

> +                       break;
> +       } while ((se =3D parent_entity(se)));
>  }
>
>  static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
> ---

Fixed one-slice penalties underperformed in our testing (dbench:
+14.4%/+9.8%/+6.7% for 2/3/4 VMs). We found adaptive scaling (6.0=C3=97
down to 1.0=C3=97 based on queue size) necessary to balance effectiveness
against starvation.

>
> With that, I'm pretty sure there is a good chance we'll not select the
> hierarchy that did a yield_to() unless there is a large discrepancy in
> their weights and just advancing se->vruntime to se->deadline once isn't
> enough to make it ineligible and you'll have to do it multiple time (at
> which point that cgroup hierarchy needs to be studied).
>
> As for the problem that NEXT_BUDDY hint is used only once, you can
> perhaps reintroduce LAST_BUDDY which sets does a set_next_buddy() for
> the "prev" task during schedule?

That's an interesting idea. However, LAST_BUDDY was removed from the
scheduler due to concerns about fairness and latency regressions in
general workloads. Reintroducing it globally might regress non-vCPU
workloads.

Our approach is more targeted: apply vruntime penalties specifically
in the yield_to() path (controlled by debugfs flag), avoiding impact
on general scheduling. The debooster is inert unless explicitly
enabled and rate-limited to prevent pathological overhead.

>
> >
> >    This creates a ping-pong effect: the lock holder runs briefly, gets
> >    preempted before completing critical sections, and the yielding vCPU
> >    spins again, triggering another futile yield_to() cycle. The overhea=
d
> >    accumulates rapidly in workloads with high lock contention.
> >
> > 2. KVM-side limitation:
> >
> >    kvm_vcpu_on_spin() attempts to identify which vCPU to yield to throu=
gh
> >    directed yield candidate selection. However, it lacks awareness of I=
PI
> >    communication patterns. When a vCPU sends an IPI and spins waiting f=
or
> >    a response (common in inter-processor synchronization), the current
> >    heuristics often fail to identify the IPI receiver as the yield targ=
et.
>
> Can't that be solved on the KVM end?

Yes, the IPI tracking is entirely KVM-side (patches 6-10). The
scheduler-side debooster (patches 1-5) and KVM-side IPI tracking are
orthogonal mechanisms:
   - Debooster: sustains yield_to() preference regardless of *who* is
yielding to whom
   - IPI tracking: improves *which* target is selected when a vCPU spins

Both showed independent gains in our testing, and combined effects
were approximately additive.

> Also shouldn't Patch 6 be on top with a "Fixes:" tag.

You're right. Patch 6 (last_boosted_vcpu bug fix) is a standalone
bugfix and should be at the top with a Fixes tag. I'll reorder it in
v2 with:
Fixes: 7e513617da71 ("KVM: Rework core loop of kvm_vcpu_on_spin() to
use a single for-loop")

>
> >
> >    Instead, the code may boost an unrelated vCPU based on coarse-graine=
d
> >    preemption state, missing opportunities to accelerate actual IPI
> >    response handling. This is particularly problematic when the IPI rec=
eiver
> >    is runnable but not scheduled, as lock-holder-detection logic doesn'=
t
> >    capture the IPI dependency relationship.
>
> Are you saying the yield_to() is called with an incorrect target vCPU?

Yes - more precisely, the issue is in kvm_vcpu_on_spin()'s target
selection logic before yield_to() is called. Without IPI tracking, it
relies on preemption state, which doesn't capture "vCPU waiting for
IPI response from specific other vCPU."

The IPI tracking records sender=E2=86=92receiver relationships at interrupt
delivery time (patch 8), enabling kvm_vcpu_on_spin() to directly boost
the IPI receiver when the sender spins (patch 9). This addresses
scenarios where the spinning vCPU is waiting for IPI acknowledgment
rather than lock release.

Performance (16 pCPU host, 16 vCPUs/VM, PARSEC workloads):
   - Dedup: +47.1%/+28.1%/+1.7% for 2/3/4 VMs
   - VIPS: +26.2%/+12.7%/+6.0% for 2/3/4 VMs

Gains are most pronounced at moderate overcommit where the IPI
receiver is often runnable but not scheduled.

Thanks again for the review and suggestions.

Best regards,
Wanpeng

