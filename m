Return-Path: <kvm+bounces-63011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0747DC57D19
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3693502B2F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06948352959;
	Thu, 13 Nov 2025 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSiKQUzD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894D63446AA
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040336; cv=none; b=m97t6CbpLztvKYQW5RFLwUtbVFQv2MWiaC9PocezPa1k8igrbk6ZfHXZtUhIwX9CqAvFPINxAB43SR8uPJWT3BO3U146mAA9E7j5eYys6O9+YOqMpiFbAJ+rgSVCOo58vQt2COKYbTFbu8dnmuGfzAPosn7g/xs+ir5R/oW+JGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040336; c=relaxed/simple;
	bh=ZP6dcd7IlPR4hcT0m5FYuFluPw7uPRCzakl+xsoN6cA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q70L17QdKDpRIP2aJDVEfpjj1ZXysUJ5CwZ+f1Kx9dFTjFcGvNthKNuyYmAp2M0HDKLNCr3yHawee5jB63rCwmxjS9j8ErEwXFTZtFWIEZ0OODJu/tj6rQFqc0sBYCSjGzMWdEGtCMeqeHv12BwItbQefV3fUG6Pv3uRz67XDcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aSiKQUzD; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3437af8444cso771075a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 05:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040333; x=1763645133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miKoKkS0E4DDQTU4ZoQVZaIJ9BfwANPVz6M1P6aM+RY=;
        b=aSiKQUzDCCMDoor9rPQZ13MxzX4A//lq7f/RAjzgok2hpP/RKM/b5lwjC4/A8B98Ma
         gsWOIpV8dWtDCFVALcJdjZm5klixxzBpad7DuKBHcSVvNIcfLSwnymipFzt3xzoPs3oD
         qdlmOPP1ev4GYso1kD8YfVm+be8llDquEpjzLsezxMaKEXWYzkBsWDHTRWnLmChyQ0C8
         ucsL4AsQ/46I02VhYLin7FIiIqqv3tWTbP9YCNlqyHGz7lOfQcDp0hCDVdQOLmYme0zl
         djdvZfDdZ8NYlLSwOeVHjQPahCusQ9lWAu9FbMiPk0JLRbTFPUzLru6v7ORKCQr9n/Th
         tL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040333; x=1763645133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=miKoKkS0E4DDQTU4ZoQVZaIJ9BfwANPVz6M1P6aM+RY=;
        b=OOxZ/rpDBvYUNpL25+t9pSY6y8jQFjrM6bhstWIMCOVzrZwzNujJSNfz88CJJJGzOp
         zM9+orVRhL6VvWolaxNPvqHS/B44WBY3ISSwbRvKWFsb7VKKeCgW6ObtjsTY07K3NqcT
         WoV4ovYO+presGtZr4TtSRpY2P+ZZQjJ/W4PrSQQa4ZPZibI7UHzAiuez5zaSho0Xihy
         iIhmuKIDepCjmS4l8zSfIk9sicPn/8l6x/Ct9yBAZSlxa9/zulSxnqWYCFTLS5RugTj8
         OkVRGHK+Uq5r5ldICrMCYKjElcJ57gPZn5fOOjRNCxNscxVmqtw+YqhHYnpyHRp07RR+
         GK1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVx+J4UUdDAvQ3sRZ2i20WmeYsTcPTod6s2sEWvIa+u1NhFTr5aNbBq2e43cglacmfMm4o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLFqwqE+t4hk+RdgGLBM2yEIkUSBf7PzDrePAQMfbprhF2PWFy
	lvj4J86d/yjYbSD2NioauPONIO/B8fpnfpKP0vOWYjV009enuvtqszFXTKC/z+XSbNwVSc64gxn
	M857r3RZWLb5P/Kv7xnmEYPbrkhgbjwwCvzj/ROA=
X-Gm-Gg: ASbGncvMF61pMjQ0Cts4vkhqiH7OObYgTDuPOBnZZ2RtnSTNFT/3k4HjeZO0x8ABKZ2
	JEEtE+aKgrgMg/umHHoqMANM36srzns9xhGmHD1JGo18DQPVWzxIG29WKwCb3Z5WLCISfjEz3Rm
	u1lmkmt4EJOp5FQjpGdy+WED+tiXPt6uTdqW1QXSJw27DJYmi33MaOAbC1/wxOUJt7IFqytdmOl
	xbO//CljrxgpUeKgV1XMPDSIP1mMBQ0zJdO+31P0jcR99EOvZdVuvAIT8roMddKoNmYB40=
X-Google-Smtp-Source: AGHT+IGnUhe7zmpxv88QqqSBQbbROBjgIpHvXD3nGhc2Tm9cAcc2hKjlJ6TKSDJ2dgbArgeGAoOg2zK9RANuA7mFLVs=
X-Received: by 2002:a17:90b:184d:b0:32e:5646:d448 with SMTP id
 98e67ed59e1d1-343dde821a5mr6886548a91.21.1763040332768; Thu, 13 Nov 2025
 05:25:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-5-kernellwp@gmail.com>
 <ef7d974e-7fcd-4e30-8a0d-8b97e00478bc@amd.com>
In-Reply-To: <ef7d974e-7fcd-4e30-8a0d-8b97e00478bc@amd.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Thu, 13 Nov 2025 21:25:21 +0800
X-Gm-Features: AWmQ_bk3OSe7ErsOfPbY7FWe1XcWAd_DsbRR6d73waCp4y01FUk_mR4moqTSaPQ
Message-ID: <CANRm+CxZCkF-1Vy5bxAsFuAM99euUtQVmNwJzb+4SWRa47T4LQ@mail.gmail.com>
Subject: Re: [PATCH 04/10] sched/fair: Add penalty calculation and application logic
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prateek=EF=BC=8C

On Wed, 12 Nov 2025 at 15:25, K Prateek Nayak <kprateek.nayak@amd.com> wrot=
e:
>
> Hello Wanpeng,
>
> On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> > +/*
> > + * Calculate penalty with debounce logic for EEVDF yield deboost.
> > + * Computes vruntime penalty based on fairness gap (need) plus granula=
rity,
> > + * applies queue-size-based caps to prevent excessive penalties in sma=
ll queues,
> > + * and implements reverse-pair debounce (~300us) to reduce ping-pong e=
ffects.
> > + * Returns 0 if no penalty needed, otherwise returns clamped penalty v=
alue.
> > + */
> > +static u64 __maybe_unused yield_deboost_calculate_penalty(struct rq *r=
q, struct sched_entity *se_y_lca,
> > +                                 struct sched_entity *se_t_lca, struct=
 sched_entity *se_t,
> > +                                 int nr_queued)
> > +{
> > +     u64 gran, need, penalty, maxp;
> > +     u64 gran_floor;
> > +     u64 weighted_need, base;
> > +
> > +     gran =3D calc_delta_fair(sysctl_sched_base_slice, se_y_lca);
> > +     /* Low-bound safeguard for gran when slice is abnormally small */
> > +     gran_floor =3D calc_delta_fair(sysctl_sched_base_slice >> 1, se_y=
_lca);
> > +     if (gran < gran_floor)
>
> Is this even possible?

No. Both use the same weight denominator in calc_delta_fair(), the
check is redundant. Will remove.

>
> > +             gran =3D gran_floor;
> > +
> > +     need =3D 0;
> > +     if (se_t_lca->vruntime > se_y_lca->vruntime)
> > +             need =3D se_t_lca->vruntime - se_y_lca->vruntime;
>
> So I'm assuming you want the yielding task's vruntime to
> cross the target's vruntime simply because one task somewhere
> down the hierarchy said so.

Yes, this is a known tradeoff. We apply the penalty at the LCA where A
and B compete to make B schedulable immediately. Side effect:
independent task C in CG0 loses CPU time. In practice, VMs place all
vCPUs in one cgroup (no independent C). If C exists and shares the
lock, the penalty helps. If C is truly independent, it loses ~one
scheduling slice. Your natural convergence approach avoids this but
needs multiple yield cycles before B gets sustained preference.

>
> > +
> > +     /* Apply 10% boost to need when positive (weighted_need =3D need =
* 1.10) */
> > +     penalty =3D gran;
>
> So at the very least I see it getting weighted(base_slice / 2) penalty
> ...
>
> > +     if (need) {
> > +             /* weighted_need =3D need + 10% */
> > +             weighted_need =3D need + need / 10;
> > +             /* clamp to avoid overflow when adding to gran (still cap=
ped later) */
> > +             if (weighted_need > U64_MAX - penalty)
> > +                     weighted_need =3D U64_MAX - penalty;
> > +             penalty +=3D weighted_need;
>
> ... if not more ...

Yes, the floor is gran (weighted ~700=C2=B5s). Empirically, smaller values
didn't sustain preference=E2=80=94the yielder would re-preempt the target
within 1-2 decisions in dbench testing. This is a workload-specific
heuristic. If too aggressive for general use, I can lower it or tie it
to h_nr_queued . Thoughts?

>
> > +     }
> > +
> > +     /* Apply debounce via helper to avoid ping-pong */
> > +     penalty =3D yield_deboost_apply_debounce(rq, se_t, penalty, need,=
 gran);
>
> ... since without debounce, penalty remains same.
>
> > +
> > +     /* Upper bound (cap): slightly more aggressive for mid-size queue=
s */
> > +     if (nr_queued =3D=3D 2)
> > +             maxp =3D gran * 6;                /* Strongest push for 2=
-task ping-pong */
> > +     else if (nr_queued =3D=3D 3)
> > +             maxp =3D gran * 4;                /* 4.0 * gran */
> > +     else if (nr_queued <=3D 6)
> > +             maxp =3D (gran * 5) / 2;          /* 2.5 * gran */
> > +     else if (nr_queued <=3D 8)
> > +             maxp =3D gran * 2;                /* 2.0 * gran */
> > +     else if (nr_queued <=3D 12)
> > +             maxp =3D (gran * 3) / 2;          /* 1.5 * gran */
> > +     else
> > +             maxp =3D gran;                    /* 1.0 * gran */
>
> And all the nr_queued calculations are based on the entities queued
> and not the "h_nr_queued" so we can have a boat load of tasks to
> run above but since one task decided to call yield_to() let us make
> them all starve a little?

You're absolutely right. Using nr_queued (entity count) instead of
h_nr_queued (hierarchical task count) is wrong:
CG0 (nr_queued=3D2, h_nr_queued=3D100)
  =E2=94=9C=E2=94=80 CG1 (50 tasks)
  =E2=94=94=E2=94=80 CG2 (50 tasks)
My code sees 2 entities and applies maxp =3D 6=C3=97gran (strongest penalty=
),
but 100 tasks are competing. This starves unrelated tasks. Will switch
to cfs_rq_common->h_nr_queued . The caps should reflect actual task
count, not group count.

>
> > +
> > +     if (penalty < gran)
> > +             penalty =3D gran;
> > +     if (penalty > maxp)
> > +             penalty =3D maxp;
> > +
> > +     /* If no need, apply refined baseline push (low risk + mid risk c=
ombined). */
> > +     if (need =3D=3D 0) {
> > +             /*
> > +              * Baseline multiplier for need=3D=3D0:
> > +              *   2        -> 1.00 * gran
> > +              *   3        -> 0.9375 * gran
> > +              *   4=E2=80=936      -> 0.625 * gran
> > +              *   7=E2=80=938      -> 0.50  * gran
> > +              *   9=E2=80=9312     -> 0.375 * gran
> > +              *   >12      -> 0.25  * gran
> > +              */
> > +             base =3D gran;
> > +             if (nr_queued =3D=3D 3)
> > +                     base =3D (gran * 15) / 16;        /* 0.9375 */
> > +             else if (nr_queued >=3D 4 && nr_queued <=3D 6)
> > +                     base =3D (gran * 5) / 8;          /* 0.625 */
> > +             else if (nr_queued >=3D 7 && nr_queued <=3D 8)
> > +                     base =3D gran / 2;                /* 0.5 */
> > +             else if (nr_queued >=3D 9 && nr_queued <=3D 12)
> > +                     base =3D (gran * 3) / 8;          /* 0.375 */
> > +             else if (nr_queued > 12)
> > +                     base =3D gran / 4;                /* 0.25 */
> > +
> > +             if (penalty < base)
> > +                     penalty =3D base;
> > +     }
> > +
> > +     return penalty;
> > +}
> > +
> > +/*
> > + * Apply penalty and update EEVDF fields for scheduler consistency.
> > + * Safely applies vruntime penalty with overflow protection, then upda=
tes
> > + * EEVDF-specific fields (deadline, vlag) and cfs_rq min_vruntime to m=
aintain
> > + * scheduler state consistency. Returns true on successful application=
,
> > + * false if penalty cannot be safely applied.
> > + */
> > +static void __maybe_unused yield_deboost_apply_penalty(struct rq *rq, =
struct sched_entity *se_y_lca,
> > +                              struct cfs_rq *cfs_rq_common, u64 penalt=
y)
> > +{
> > +     u64 new_vruntime;
> > +
> > +     /* Overflow protection */
> > +     if (se_y_lca->vruntime > (U64_MAX - penalty))
> > +             return;
> > +
> > +     new_vruntime =3D se_y_lca->vruntime + penalty;
> > +
> > +     /* Validity check */
> > +     if (new_vruntime <=3D se_y_lca->vruntime)
> > +             return;
> > +
> > +     se_y_lca->vruntime =3D new_vruntime;
> > +     se_y_lca->deadline =3D se_y_lca->vruntime + calc_delta_fair(se_y_=
lca->slice, se_y_lca);
>
> And with that we update vruntime to an arbitrary value simply
> because one task in the hierarchy decided to call yield_to().

Yes, modifying vruntime at se_y_lca affects the entire hierarchy
beneath it, not just the calling task. This is the cost of making
yield_to() work in hierarchical scheduling. Is it worth it? We believe
yes, because:
1. Yield_to() is already a hierarchy-wide decision: When vCPU-A yields
to vCPU-B, it's not just task-A helping task-B=E2=80=94it's the entire VM (=
the
hierarchy) requesting another vCPU to make progress. Lock-holder
scenarios are VM-wide problems, not individual task problems.
2. The alternative is broken semantics: Without hierarchy-level
adjustment, yield_to() silently fails in cgroup configurations. Users
call yield_to() expecting it to work, but it doesn't=E2=80=94that's worse t=
han
documented unfairness.
3. Bounded impact: The penalty scales conservatively with h_nr_queued
(larger hierarchies get 1.0=C3=97 gran, not 6.0=C3=97), limiting blast radi=
us.
If the position is that hierarchy-wide vruntime perturbation is never
acceptable regardless of use case, then yield_to() should explicitly
fail or be disabled in cgroup configurations rather than pretending to
work.

>
> Since we are on the topic, you are also missing an update_curr()
> which is only done in yield_task_fair() so you are actually
> looking at old vruntime for the yielding entity.

 Will fix it.

Regards,
Wanpeng

