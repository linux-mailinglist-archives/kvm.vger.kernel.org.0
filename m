Return-Path: <kvm+bounces-23447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B05DF949B96
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D38591C21874
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 22:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341A8176FAE;
	Tue,  6 Aug 2024 22:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="unct1XGg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EC176AD0
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 22:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722984712; cv=none; b=LA5aAIRrrkkqq1US+BeJ+dpbzzzjxUppqTEHuRlj+Etq+rcwUeyHxsKvP+WqwS7pdPOJq7OOHBma876KIFcdSTTpQ7Vg+YvckSz17G2wk9q6tNWP91vJPouytXONTkNy9MWLnIaQNETL4UwKgEerovf9tuU5hLY+M+wB9lAcSws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722984712; c=relaxed/simple;
	bh=6Y9hXA6AzSaU8XwI9by7FO/wehIsVP4L7s1hSbagEhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s41SfC2BzE+RwZ/EjOOQArww4MB9/N624DZsVDLtASasFTzBbsGioMBSDAni4viWs6M3Hw+pwduhG/6wjQrCHt1ENipzw5dlO+MTvPEqfuTUgKoDOlv8mVmBLZGZzPo3P6oPaAKjJ7g8uFqIYhKwqEe2Z2OlFt6qwXIXAO4h2sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=unct1XGg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-428f5c0833bso1751525e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 15:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722984708; x=1723589508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOOp/YKmc/A5dqoD58ohOhoIfvgLzdB4FRBJ9eYiJAE=;
        b=unct1XGgi9fmnMD9iSK9pVlCxvNlDiD5Lp/gPbFv4uYzLvbw/7ow/iaTj6yPaj4WiD
         Hs+No/YjVOTtkebV5p/COu+t6TD51OXcWB+ZV9zjiZg05UIczXQxX/xO4mfH8xQDfB2Q
         ZkIUwfM9W2IWQ4JwNSeKjNIfbSl1G4AUUgDsZE+ujoGUMsJ5694m9iwAtDHKVIuyMLeV
         9JFRFdhcc2MywhEi4q+r3jxX08UjoK7ARQw8+P+i/O8OU5RsG+q1OYF3KIR3hBK7wFcE
         D9eUYwDtY3/O7XZAYSnuTJ15ZC1yHqOPfpMKdskU/MgvIkWkowaLO1PfWVh30+zv3Tnf
         jjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722984708; x=1723589508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOOp/YKmc/A5dqoD58ohOhoIfvgLzdB4FRBJ9eYiJAE=;
        b=GZ8ioTf1BaAi74Nx1gHMpAo/9y8Kn/SXzvskwr2XHPMx8rbBXSggk6oJe3pIkgtry+
         R8YzOUc8mCDvu0MVdbx8siWomqANTQ+0xZ0t5YuP6SpAKhQbBAJyT02f3WF+x+p6Ubb/
         SKVD/5uNyrrWdIvDQexOyPQIWGcRCU/l5Vf2EIPlwdCgLIpVVfGERAKfS3vxt0a48QGk
         15o63KgAaUjMo7wdKAX2jbavwBkzd80K/wlKWHByN8H3Tr4V/TfxxWfxz6jLngE/5/B5
         DPCohQez3DUcd4aPqllhCjsZ7ra7HJmMKm+5GgrzPuvP3+P9BFJ8Yt2uG+sSoglyzkIL
         31Wg==
X-Forwarded-Encrypted: i=1; AJvYcCV9UFs3Fjf1k+S2ZGourbLbqSa5bRex0GB/cncwYMy89gIGMjCKeTcr7VfrzRLvgU9zIN18nCUTvXe1VljHKSvjItVT
X-Gm-Message-State: AOJu0YxN8OFil1XpHUHxUXOUbPPwjJhPdHK4uCSOidsRy68hH9e3v9da
	L0HesxE/ugIvjWpvF06gDIzBHEHHsJ07dBe5OOOTp/QvVTCJbyPWcAmiuR31gThTV/SSkPkC8jd
	yaEESrcMKX0jdzz+ulAb7MCAy+nsWOms9WL/9
X-Google-Smtp-Source: AGHT+IHxsJV05SvHmbLBzfkJ2/9CLauQTre175KYcg3syg2jB0hoXO5m25jbwBC+niHAL4vOTLYlDRqj7cIekZQCpiY=
X-Received: by 2002:a05:600c:4fd2:b0:426:676a:c4d1 with SMTP id
 5b1f17b1804b1-429050c87famr1855145e9.8.1722984707966; Tue, 06 Aug 2024
 15:51:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240806111157.1336532-1-suleiman@google.com>
In-Reply-To: <20240806111157.1336532-1-suleiman@google.com>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 6 Aug 2024 18:51:36 -0400
Message-ID: <CAJWu+oqp9sUDOvKB23p+_C1cTvFj8sQptfz30UwrWJyKhf1ckg@mail.gmail.com>
Subject: Re: [PATCH] sched: Don't try to catch up excess steal time.
To: Suleiman Souhlal <suleiman@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, vineethrp@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 7:13=E2=80=AFAM Suleiman Souhlal <suleiman@google.co=
m> wrote:
>
> When steal time exceeds the measured delta when updating clock_task, we
> currently try to catch up the excess in future updates.
> However, this results in inaccurate run times for the future clock_task
> measurements, as they end up getting additional steal time that did not
> actually happen, from the previous excess steal time being paid back.
>
> For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> time reported while it ran. clock_task rightly doesn't advance. Then, a
> different task runs on the same rq for 10ms without any time stolen.
> Because of the current catch up mechanism, clock_sched inaccurately ends
> up advancing by only 5ms instead of 10ms even though there wasn't any
> actual time stolen. The second task is getting charged for less time
> than it ran, even though it didn't deserve it.
> In other words, tasks can end up getting more run time than they should
> actually get.
>
> So, we instead don't make future updates pay back past excess stolen time=
.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  kernel/sched/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bcf2c4cc0522..42b37da2bda6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -728,13 +728,15 @@ static void update_rq_clock_task(struct rq *rq, s64=
 delta)
>  #endif
>  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>         if (static_key_false((&paravirt_steal_rq_enabled))) {
> -               steal =3D paravirt_steal_clock(cpu_of(rq));
> +               u64 prev_steal;
> +
> +               steal =3D prev_steal =3D paravirt_steal_clock(cpu_of(rq))=
;
>                 steal -=3D rq->prev_steal_time_rq;
>
>                 if (unlikely(steal > delta))
>                         steal =3D delta;
>
> -               rq->prev_steal_time_rq +=3D steal;
> +               rq->prev_steal_time_rq =3D prev_steal;
>                 delta -=3D steal;

Makes sense, but wouldn't this patch also do the following: If vCPU
task is the only one running and has a large steal time, then
sched_tick() will only freeze the clock for a shorter period, and not
give future credits to the vCPU task itself?  Maybe it does not matter
(and I probably don't understand the code enough) but thought I would
mention.

I am also not sure if the purpose of stealtime is to credit individual
tasks, or rather all tasks on the runqueue because the "whole
runqueue" had time stolen.. No where in this function is it dealing
with individual tasks but rather the rq itself.

Thoughts?

 - Joel



>         }
>  #endif
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>

