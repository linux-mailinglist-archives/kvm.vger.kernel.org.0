Return-Path: <kvm+bounces-21788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9F99343A6
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:09:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF85428373C
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951E818412C;
	Wed, 17 Jul 2024 21:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="vQ4qY5Zv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2E2262B
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 21:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721250576; cv=none; b=oCyB86gYgTuyR6HZx4EtDoCe4RRq0s6FugKLsovp3hQtrO5od/H7L0ORLB+9reazEw1JhNBvtzOCk+nEheVpDhhxiZPKqZpR7BhUGI8OisAer2Sq9zgp7IGM4zKqcq74NEum6ljL8QRLhzhHbp/5015dMT65DoxVRThLldnEsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721250576; c=relaxed/simple;
	bh=Hsmi/tnjvIhP7ky8G51r/RYtJq4r6okNPqnCnkRSCVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b2NQFivlBfiJan+34JdgAevcWwFt4R4H97pb82GKioiutrf1+fZvq4n25bzxKFP1cEYJIkQV12UbwnsTSLpMhUYDy6T44giLqAmjY+ebDJOUqX28QCDR7zUUWrp2CyFAFUJT562Wp/nCOhq0R/D7L+6i2yHem2Jiqy7QkYhOBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=vQ4qY5Zv; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2eea8ea8c06so2446641fa.2
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 14:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1721250573; x=1721855373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hsmi/tnjvIhP7ky8G51r/RYtJq4r6okNPqnCnkRSCVc=;
        b=vQ4qY5ZvHYe+vBxbAw9msmsBRAnAZml4sBjNPn/CAB/sba0b1TW8J/2cxE5GD3VTye
         FIIrOF8ablkFQexZUs+EpiTYmcsMWnfZ2e3bCumtilcHRmSsSIeLaD6dv6sw+jlbUQFH
         llVRcNfcKqTmCw6NO/1exuCMeyp9yjFeE599o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721250573; x=1721855373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hsmi/tnjvIhP7ky8G51r/RYtJq4r6okNPqnCnkRSCVc=;
        b=aahnYFN9Ngp/ui9NqB725KIwFt6yPhqFHsNQ7UG5oJ0yXEKlRhVooQVjdHwUHR+mMU
         k3FLE7PZ0J7Ww66U5ca1lrH5O+chAbeFCzQ7Mp5tRhWe0UbYM2zpcx0Pn03RJTEq/iYN
         DrqH4AHTK6JLT5riWQOmvPm2O7ZqEuiDIcme3/WdcUgwQtxhllXG8uZLfjkUeR0I5XLc
         QCy6bZ0N8i6uwPEQGFEik8ooySrrQqeGRkh3cuRW17fEtGjFlkbuKqx4aGF7l1CNrWGt
         /YHfB5mBNqYXiUvUXqMNla5bMK+gmWKCaAqeEi/L3yrj5MmmYdXOufCEQqGA/MBWHWB4
         BTuw==
X-Forwarded-Encrypted: i=1; AJvYcCXAP/4/JXom0v0JIgshaSuFDkgX9ERurE6O1RZOIVEkyTs1TNgpDvI1jahvlufcNc7FjaZqkZjOEDcTyzbLVC0Bu5OG
X-Gm-Message-State: AOJu0YzjH6eBNCgYq/apO5cHuwUORHwU16S/7pJS0xEpShf1CICsQDXH
	Ch3BpvcztKDanTdBtArquh44sfjwaVzTcDB//+rIXR4LQu9XQL3c4AmGKDf9Bc+g02RkxuFmz3K
	ZaHpUnL3H0dMsQ0K8nf8Toa3VTHMDIqhuSQOuzg==
X-Google-Smtp-Source: AGHT+IEngMDoxAb3PZPlFQ2iU/N7ZIRrnSUXOqH4p09cKPWy37wGZphfyLKn/ZahOp4q8hZH04/iHl6n+5CcEbZY51s=
X-Received: by 2002:a05:651c:1548:b0:2ee:8905:769c with SMTP id
 38308e7fff4ca-2ef05c92204mr3988441fa.28.1721250573534; Wed, 17 Jul 2024
 14:09:33 -0700 (PDT)
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
 <CAEXW_YSpaKJg_7eHf4MeEFMASR_rJ9JoRfDPogsB4_66YA2abA@mail.gmail.com> <20240717170047.5e1094f0@rorschach.local.home>
In-Reply-To: <20240717170047.5e1094f0@rorschach.local.home>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 17 Jul 2024 17:09:20 -0400
Message-ID: <CAEXW_YQWngifqRFpS_H3RjDBwV_uH_OebbYzB63Q=jSwheqjLA@mail.gmail.com>
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

On Wed, Jul 17, 2024 at 5:00=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed, 17 Jul 2024 16:57:43 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > On Wed, Jul 17, 2024 at 11:20=E2=80=AFAM Steven Rostedt <rostedt@goodmi=
s.org> wrote:
> > >
> > > On Wed, 17 Jul 2024 10:52:33 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > > We could possibly add a new sched class that has a dynamic priority=
.
> > >
> > > It wouldn't need to be a new sched class. This could work with just a
> > > task_struct flag.
> > >
> > > It would only need to be checked in pick_next_task() and
> > > try_to_wake_up(). It would require that the shared memory has to be
> > > allocated by the host kernel and always present (unlike rseq). But th=
is
> > > coming from a virtio device driver, that shouldn't be a problem.
> >
> > Problem is its not only about preemption, if we set the vCPU boosted
> > to RT class, and another RT task is already running on the same CPU,
>
> That can only happen on wakeup (interrupt). As the point of lazy
> priority changing, it is only done when the vCPU is running.

True, but I think it will miss stuff related to load balancing, say if
the "boost" is a higher CFS priority. Then someone has to pull the
running vCPU thread to another CPU etc... IMO it is better to set the
priority/class externally and let the scheduler deal with it. Let me
think some more about your idea though..

thanks,

 - Joel

