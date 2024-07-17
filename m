Return-Path: <kvm+bounces-21786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C93E4934392
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 22:59:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B9C31F22696
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 20:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DCB186E4B;
	Wed, 17 Jul 2024 20:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="O9NqQwBt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8761822FF
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 20:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721249881; cv=none; b=HhOMKL4ZyRCs3ZaiQUExmYPN0oIsDauLWk7V74M/8ol4hpSqIQIfhMkXbpOE5AYbHkl4+R5cE+Gsmfplh8YwDBw9ZcWOiY+nBBlSX3UUyR0RA4wpmgBniMI2wHZiE3RqMzNxjaJRbToRq2G9C2En8rzlHVfRJeWpLFoVK1DMArc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721249881; c=relaxed/simple;
	bh=tVzT7Tt6vOvYFb7UssEU1fCK87IFh6xMizmuZBZ6IPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgQTTBb0he/dU97tIzohwLxGtG7B0ouaZF5RKVtQyIwbvV3Ved7sBNq5nZ8WITxtLnT0i45GNOCuXtqcqzwKEByxIJB/A2wmljCpJ50uXTxDPdgSbj5eQAKvnUEb/TnP0Q7bAnQ0lRLvou0Zh0nqJVRTTV+kiOWl0IAfTubu0yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=O9NqQwBt; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ee817dac89so1827391fa.1
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1721249878; x=1721854678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f7ZHgs/a7JzOzxMhpORncVZtPnJxl//JcNH0RX5amU=;
        b=O9NqQwBtuaG0fKueRpv9ANUOOXK9GYjwUfbPiJPOHTIq1Z/q94Gu1SXvhmfoV/v/rE
         +B3B/CncAA+CABLGFP4uwrZaEV2D9Sr/Jq/FzAjiYYmcppsoZh1w6mc9v2NWMzaDmUVK
         rvGqsk1rHd8BRa4dcikk3rdaCkV/F3bqClnko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721249878; x=1721854678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5f7ZHgs/a7JzOzxMhpORncVZtPnJxl//JcNH0RX5amU=;
        b=GiY+MSS3g4Tykw5NHqe5wT9XHn1NYgg0g7l6jD6p+1UkF/Y/o/ZPhcajs8ikCXvjSR
         QLuSEcXin48QCA7KQDuwA0QRddZZJZK2Gr4AX6KccRWq4mpuUwzIR8JUWwrEtc4bpNqB
         ENblGoC7XLUr6ex/ma6Oy4o+mVPwpED+q+SxlpmHc+wuG5oZDGsqgnk/yZrYMMHmnnNc
         B9WPgpKQchVAaPVjxGskJLCt6yrnKo3bQgPtGQRHrQNQqReswtG7tb12Ig48hNvEeUDi
         oIcxFHmu+6ZMTPHWlKBst60JQ4+SMGh9SQtGfcws1J4HyeJLMITs+wibECAjeKcIJKdg
         zNag==
X-Forwarded-Encrypted: i=1; AJvYcCWwbJyLO7cic5ie+DZ2/tHRIIoWB2eLisrbqY6YBCNl3yLpMnBPxXHywhlRJ+OnGyqVXhH8grcHpnCM7edcYg5yLyEM
X-Gm-Message-State: AOJu0YznWAo2cDdvee47829vmfTYpy85F0+ytke82VED1hQKiIZv19Bb
	Yns/W4G/XA9zg+LHqZL7wv79zY53NUC5EYJBYoq2o/mb62SwW6JtR/+/x86Vq6PnDvF5gmasZzg
	GBeOghCYKA1jlIb3xmnvOVNgB8pkJlrgQs9LkLA==
X-Google-Smtp-Source: AGHT+IGA1ovJvaCHrQ8ZBN1ngYCRzLRKl2WS9W319qV5aSpyobMWdq/batWjTI32zPQwY4RUuHRoSCdVvYThEW2YIG8=
X-Received: by 2002:a2e:9f4b:0:b0:2ee:4b7a:7c1c with SMTP id
 38308e7fff4ca-2ef065cbecemr996941fa.21.1721249877639; Wed, 17 Jul 2024
 13:57:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home> <ZpFdYFNfWcnq5yJM@google.com>
 <20240712131232.6d77947b@rorschach.local.home> <ZpcFxd_oyInfggXJ@google.com>
 <CAEXW_YS+8VKjUZ8cnkZxCfEcjcW=z52uGYzrfYj+peLfgHL75Q@mail.gmail.com>
 <ZpfR49IcXNLS9qbu@google.com> <20240717103647.735563af@rorschach.local.home>
 <20240717105233.07b4ec00@rorschach.local.home> <20240717112000.63136c12@rorschach.local.home>
In-Reply-To: <20240717112000.63136c12@rorschach.local.home>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 17 Jul 2024 16:57:43 -0400
Message-ID: <CAEXW_YSpaKJg_7eHf4MeEFMASR_rJ9JoRfDPogsB4_66YA2abA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sean Christopherson <seanjc@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Vineeth Remanan Pillai <vineeth@bitbyteword.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	graf@amazon.com, drjunior.org@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 11:20=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Wed, 17 Jul 2024 10:52:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > We could possibly add a new sched class that has a dynamic priority.
>
> It wouldn't need to be a new sched class. This could work with just a
> task_struct flag.
>
> It would only need to be checked in pick_next_task() and
> try_to_wake_up(). It would require that the shared memory has to be
> allocated by the host kernel and always present (unlike rseq). But this
> coming from a virtio device driver, that shouldn't be a problem.

Problem is its not only about preemption, if we set the vCPU boosted
to RT class, and another RT task is already running on the same CPU,
then the vCPU thread should get migrated to different CPU. We can't do
that I think if we just did it without doing a proper
sched_setscheduler() / sched_setattr() and let the scheduler handle
things.  Vineeth's patches was doing that in VMEXIT..

 - Joel

