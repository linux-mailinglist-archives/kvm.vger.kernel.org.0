Return-Path: <kvm+bounces-63009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A01C5751C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C874F3B8EC4
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 12:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6125E34DB7F;
	Thu, 13 Nov 2025 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBk8bIqm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020D4333739
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035235; cv=none; b=kccdX21MV6LYQ6MVna4XgMIRwCighiUDXNlhm/IeAWjxJv5cNVDCj9ghTepDkpSpj5eUlXGvj+kk5IqyRPrqi+nQSxYwoe+LoEwpmgDcxkC0Hx9k3aYxz9W7mBcpLo++pp+Rg3UmakGfPLEF6eC0ay1GleslwCSZAcZzn5ywSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035235; c=relaxed/simple;
	bh=4P4LhGMXNDpOMLzkgSnNvj8G+OXHvtlSD4CrCtiKVM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L9ppSWYiim+h5Odu9ntur36gORoqpINBFzuW+807HyLvQ09k0dlxXvHYBXnVFdZRWOHhQXI3d81JWRnnUHMrAbQ/sXkCdDV7yTbJb0kVfYeOiTrz2E28bb4unFL1kzzTSEg2tpo3Y57kWqH0E72ek+By23/aT02b1G/5oNsUjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBk8bIqm; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-340a5c58bf1so496911a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 04:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035233; x=1763640033; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMbZe017tqsUHZpQ2QjARaQuit2dg0zAawqoQ3eFuRM=;
        b=eBk8bIqm4A2dQDXlFI/NG+b82jOhbvl6/xQehWcEWuZS7pJeHVAehMQZLOi+UACtO3
         4Op2eR2/eCjS7mfhhKpF0VHuBA51iwu2PUMh1moYR1ka8fyFXdM1G897+NAoDJQpKY3z
         2iJdpworRIZwfFeQyzQllzanrWrTAAXCMLYc17EzC9GpIBOxppD6nrIZQYsoX3ePqqAR
         DEfP7BD6oC7ese65TnBmff2J5ymszsIIOI3kZskzfysvvrac9ShEpKH6IrQmaAtFuMKt
         g9ZRD+EdrOnfiCCbbLxiot5DeeBOBUL6AUUkqJY9xMrx31c9YF46BJf/LRFimyA2DxSV
         Ptbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035233; x=1763640033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VMbZe017tqsUHZpQ2QjARaQuit2dg0zAawqoQ3eFuRM=;
        b=Zq8/6KLbWbY1Gq3huCCR0/yYmNcnGxuQ2qPAUBH+OoyvPJo6/H+3tSFf5ifdIgcwI6
         HKOTcttD1B2/WKEw1+xMdpI+Spx5KrjJkSEDSxFCsqa140rN+XKaVDrtUjypdDBAeb3v
         Zv6BdKEN47rhag9MkzZ4bdmyM9UBHIPP1dwq+M2NWs71BRK1UBlCxwkX6S58luLQMLF9
         HLZ/Rxn+TbQ91sX/Pud1AXda+6jxou21+TsUjS12NwZCe/x4Nl2ef1ZX1+yPbaEq0Ye5
         1+OA3VdGJue0Cgjn8xbRsTJ0utQSGNgD338vQ+tiTnrWx82k2rZOND+OtpUwre1fGdM7
         eI7g==
X-Forwarded-Encrypted: i=1; AJvYcCUHMRsJspvXMyMxv6qZPJjMlGbCfd8a3rpfNc1/YsYlkdIRjialCY0n8slQI9FCx5BT/CM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ/D7nBRTZ2okHD9cr6p5M1j7T5ssqJRFdNFnjQqFBUwH7FTtF
	GeHsHHjZDxj0gpPwaFbp1Z+CDT9Fu8WyzFy4qHspG+GgUSr2LU92VD9PlOI17TqbU8bSNq9hLhB
	pQTtoePggxGZPKsQr4HrSO5Q+mai2jqU=
X-Gm-Gg: ASbGncu23gPDqYkixvSgf0jdc1KrSWCLT9WeSlMACJXvYF0neCX3QQIgq83Lx37jZ25
	saVhE5g9tRUa5zHxXSIM7x54rnKYDnZjVtv7tFy3lLLRlrT6DAlVHyArzQ6C1YOhhTrFM27B+hb
	qFcQJKdQkAh4kwUDllqwMaLTJHCTcQD9c/YxIFtoDFoJwb3IrbQjLaINBGDCm6Dj1GtfLa0e5hI
	+X01G7253INY1WXq1a1TcFJ5ZCuRSG/7gWuMtqVG/oTj5RDs88psJwHQevA
X-Google-Smtp-Source: AGHT+IEI2/ETIyN+HIgY1WEvq69lhMhuMqrT7htmjzbXfUhWwBXWYHygAT11nF7Fs+GljLoWjfY7MsHoOczG1GMYc8c=
X-Received: by 2002:a17:90a:d448:b0:340:f7d6:dc70 with SMTP id
 98e67ed59e1d1-343dde13826mr7620363a91.13.1763035233051; Thu, 13 Nov 2025
 04:00:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-3-kernellwp@gmail.com>
 <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com>
In-Reply-To: <015bfa4d-d89c-4d4e-be06-d6e46aec28cb@amd.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Thu, 13 Nov 2025 20:00:21 +0800
X-Gm-Features: AWmQ_bm9GFF_fVDEXPJNSBQ91hN0PH9vClzZfoOKcy5ZG0d_ttlXsdzXEocsdlQ
Message-ID: <CANRm+CzsjNyd9-QjUupszpULNkJ31U+wPWC81A5jaTFRFdPfMg@mail.gmail.com>
Subject: Re: [PATCH 02/10] sched/fair: Add rate-limiting and validation helpers
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

On Wed, 12 Nov 2025 at 14:40, K Prateek Nayak <kprateek.nayak@amd.com> wrot=
e:
>
> Hello Wanpeng,
>
> On 11/10/2025 9:02 AM, Wanpeng Li wrote:
> > +/*
> > + * High-frequency yield gating to reduce overhead on compute-intensive=
 workloads.
> > + * Returns true if the yield should be skipped due to frequency limits=
.
> > + *
> > + * Optimized: single threshold with READ_ONCE/WRITE_ONCE, refresh time=
stamp on every call.
> > + */
> > +static bool yield_deboost_rate_limit(struct rq *rq, u64 now_ns)
> > +{
> > +     u64 last =3D READ_ONCE(rq->yield_deboost_last_time_ns);
> > +     bool limited =3D false;
> > +
> > +     if (last) {
> > +             u64 delta =3D now_ns - last;
> > +             limited =3D (delta <=3D 6000ULL * NSEC_PER_USEC);
> > +     }
> > +
> > +     WRITE_ONCE(rq->yield_deboost_last_time_ns, now_ns);
>
> We only look at local rq so READ_ONCE()/WRITE_ONCE() seems
> unnecessary.

You're right. Since we're under rq->lock and only accessing the local
rq's fields, READ_ONCE()/WRITE_ONCE() provide no benefit here. Will
simplify to direct access.

>
> > +     return limited;
> > +}
> > +
> > +/*
> > + * Validate tasks and basic parameters for yield deboost operation.
> > + * Performs comprehensive safety checks including feature enablement,
> > + * NULL pointer validation, task state verification, and same-rq requi=
rement.
> > + * Returns false with appropriate debug logging if any validation fail=
s,
> > + * ensuring only safe and meaningful yield operations proceed.
> > + */
> > +static bool __maybe_unused yield_deboost_validate_tasks(struct rq *rq,=
 struct task_struct *p_target,
> > +                                       struct task_struct **p_yielding=
_out,
> > +                                       struct sched_entity **se_y_out,
> > +                                       struct sched_entity **se_t_out)
> > +{
> > +     struct task_struct *p_yielding;
> > +     struct sched_entity *se_y, *se_t;
> > +     u64 now_ns;
> > +
> > +     if (!sysctl_sched_vcpu_debooster_enabled)
> > +             return false;
> > +
> > +     if (!rq || !p_target)
> > +             return false;
> > +
> > +     now_ns =3D rq->clock;
>
> Brief look at Patch 5 suggests we are under the rq_lock so might
> as well use the rq_clock(rq) helper. Also, you have to do a
> update_rq_clock() since it isn't done until yield_task_fair().

Good catch. Since yield_to() holds rq_lock but doesn't call
update_rq_clock() before invoking yield_to_task(), I need to call
update_rq_clock(rq) at the start of yield_to_deboost() and use
rq_clock(rq) instead of direct rq->clock access. This ensures the
clock is current before rate limiting checks.

>
> > +
> > +     if (yield_deboost_rate_limit(rq, now_ns))
> > +             return false;
> > +
> > +     p_yielding =3D rq->curr;
> > +     if (!p_yielding || p_yielding =3D=3D p_target ||
> > +         p_target->sched_class !=3D &fair_sched_class ||
> > +         p_yielding->sched_class !=3D &fair_sched_class)
> > +             return false;
>
> yield_to() in syscall.c has already checked for the sched
> class matching under double_rq_lock. That cannot change by the
> time we are here.

Correct. The sched_class checks are redundant since yield_to() already
validates curr->sched_class =3D=3D p->sched_class under double_rq_lock(),
and sched_class cannot change while holding the lock. Will remove.

>
> > +
> > +     se_y =3D &p_yielding->se;
> > +     se_t =3D &p_target->se;
> > +
> > +     if (!se_t || !se_y || !se_t->on_rq || !se_y->on_rq)
> > +             return false;
> > +
> > +     if (task_rq(p_yielding) !=3D rq || task_rq(p_target) !=3D rq)
>
> yield_to() has already checked for this under double_rq_lock()
> so this too should be unnecessary.

Right. yield_to() already ensures both tasks are on their expected run
queues under double_rq_lock(), so the task_rq(p_yielding) !=3D rq ||
task_rq(p_target) !=3D rq check is redundant. Will remove.

>
> > +             return false;
> > +
> > +     *p_yielding_out =3D p_yielding;
> > +     *se_y_out =3D se_y;
> > +     *se_t_out =3D se_t;
>
> Why do we need these pointers? Can't the caller simply do:
>
>     if (!yield_deboost_validate_tasks(rq, target))
>         return;
>
>     p_yielding =3D rq->donor;
>     se_y_out =3D &p_yielding->se;
>     se_t =3D &target->se;

You're right, the output parameters are unnecessary. The caller can
derive them directly:
   p_yielding =3D rq->donor (accounting for proxy exec)
   se_y =3D &p_yielding->se
   se_t =3D &target->se
I'll simplify yield_deboost_validate_tasks() to just return bool and
let the caller obtain these pointers.

>
> That reminds me - now that we have proxy execution, you need
> to re-evaluate the usage of rq->curr (running context) vs
> rq->donor (vruntime context) when looking at all this.

Good catch. Since we're manipulating vruntime/deadline/vlag, I should
use rq->donor (scheduling context) instead of rq->curr (execution
context). In the yield_to() path, curr should equal donor (the
yielding task is running), but using donor makes the vruntime
semantics clearer and consistent with
update_curr_fair()/check_preempt_wakeup_fair().

Regards,
Wanpeng

