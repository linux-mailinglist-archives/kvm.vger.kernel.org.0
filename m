Return-Path: <kvm+bounces-21742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D25A39334A6
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 01:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41743284CD2
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 23:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958171448E7;
	Tue, 16 Jul 2024 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sixOvnRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616701411EB
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721173448; cv=none; b=TxefJAyJBJ2xnmINGc5wdS4ojgBXS0QDXWO87eo6rhTcY43fe+WbzjWTYdYYTeRv4ZuvTb7O2nKFIi4TzjhpWNwSPqTQpYzE/TY646+d7u43u/3Yk7vc0L/B+/1d0mcpTjfP5Si2OuOs7+SOxEkGZeok5asvC//6ayiAnkHN0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721173448; c=relaxed/simple;
	bh=Oo2PaSEaHFXVybUVEwfYYXXYC9t1/V6mNAwqg0LKz9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iSF/pT8PwUU4qgrPwlK1wCYbaNWxeZssG6E6pxXxP43KBrcTxbevEGvtjErbG9//sBcOmbKQvw67Kg23Hj9qM2bjGtH9PmkPS3otaxYpnCKtSgNSqMrnBv5CgOxe79LD3G0lmXzXYxaU18roN9TLe3xJRaP8chLTs3UhRRQqiLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sixOvnRO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70af5f8def2so4432692b3a.2
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 16:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721173447; x=1721778247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B2tTHeJ/xmbXoJNWmiUW7X20NdCG5cTyCrl1Jx9sot4=;
        b=sixOvnRO6dno9RNc7D4aC7vzN7HY4ZtiJ9OECqr9NXUXTERZhM2AqWvuaX/6X9rVmg
         m5GVSmAJS6SpgpsWxyUcbHvFu+4DzPFnWMUzDNViqIrJQSGdXriOmG7UyIPKWJZotkoA
         iI5X+N7LMjg+ItBayHfVzxfiTDjYaCapa9Log7+C/6eTen1jiz/XvgCW1/oOu2g62HtX
         zGyyzWVSIK1NRvNu4jJ9bFPnxsp03olbDX/sFHNS5z1iid7qWgEzNLD7zhG0zXnJbzQ5
         iX/nFTqCOD0oFMU1EL0MqwkzlLzBWoV+mzoTd4KciZlv0gxnP6I2Ns0eWSUMpRzwDU6f
         rrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721173447; x=1721778247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2tTHeJ/xmbXoJNWmiUW7X20NdCG5cTyCrl1Jx9sot4=;
        b=qiUDtbyrMGTp76IgaCzOvdAjdGTbn5kVXpaHNuOoturLQaBHp2jony6whdCsJDUWug
         NYx2W7VW3wZstFjrGobDpmJTP/aBSElWZHmsk5V1uOMPuQT9ddPBfZ7eiUvJi0JJwfBa
         lkeAD7XXCxNvqEw9AOuFqTZnEHlzeAI2tF+xVhsHmdgknuXsz/Udq6Ew0GpFUN5Tip4w
         Cx18GEK9fLBYMZ5D3tjAsvDXxDo8brESYZCF0Lz6fWC8dBIK5DMf4c2BT/qOOm+evXjK
         HYNzi6jAVLKI7ibBHlGuhSA3lOGvvoZu80KuqWWrYlgaA3iuQZgnxfk4FSHawR373zhY
         s+/A==
X-Forwarded-Encrypted: i=1; AJvYcCWAOYQ1mE4Vr4X1LZLmzu62PW828TBS5tlKZDqqogvat1ADsuQt7LJP47eMFMkeibSWtCexdTvlDFMnhfe/cj0E6ZUS
X-Gm-Message-State: AOJu0YyVeelD7FwJctjWybJ+T4hoz7qaPujFmnqZAd2WZdplR6XQPGtE
	fghLdGoFxQB0wpHqfoj62iGR+b78hj/Dr4oUuZCv4lHPu33PcC4/YbHd+gamfvnpUg+GFQGETSO
	Rww==
X-Google-Smtp-Source: AGHT+IFpI/eX4p01ZLRfSZuJN/Lpr4jx+K5wlYq+CnuLK/8W4b2/ggAKH1T9+4st+r4xd0muEFAQ1cIKVRc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3e0c:b0:704:3140:5a94 with SMTP id
 d2e1a72fcca58-70ce4e1f95fmr123b3a.2.1721173446419; Tue, 16 Jul 2024 16:44:06
 -0700 (PDT)
Date: Tue, 16 Jul 2024 16:44:05 -0700
In-Reply-To: <20240712131232.6d77947b@rorschach.local.home>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com> <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
 <66912820.050a0220.15d64.10f5@mx.google.com> <19ecf8c8-d5ac-4cfb-a650-cf072ced81ce@efficios.com>
 <20240712122408.3f434cc5@rorschach.local.home> <ZpFdYFNfWcnq5yJM@google.com> <20240712131232.6d77947b@rorschach.local.home>
Message-ID: <ZpcFxd_oyInfggXJ@google.com>
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority management)
From: Sean Christopherson <seanjc@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Joel Fernandes <joel@joelfernandes.org>, 
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
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, Steven Rostedt wrote:
> On Fri, 12 Jul 2024 09:44:16 -0700
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > > All we need is a notifier that gets called at every VMEXIT.  
> > 
> > Why?  The only argument I've seen for needing to hook VM-Exit is so that the
> > host can speculatively boost the priority of the vCPU when deliverying an IRQ,
> > but (a) I'm unconvinced that is necessary, i.e. that the vCPU needs to be boosted
> > _before_ the guest IRQ handler is invoked and (b) it has almost no benefit on
> > modern hardware that supports posted interrupts and IPI virtualization, i.e. for
> > which there will be no VM-Exit.
> 
> No. The speculatively boost was for something else, but slightly
> related. I guess the ideal there was to have the interrupt coming in
> boost the vCPU because the interrupt could be waking an RT task. It may
> still be something needed, but that's not what I'm talking about here.
> 
> The idea here is when an RT task is scheduled in on the guest, we want
> to lazily boost it. As long as the vCPU is running on the CPU, we do
> not need to do anything. If the RT task is scheduled for a very short
> time, it should not need to call any hypercall. It would set the shared
> memory to the new priority when the RT task is scheduled, and then put
> back the lower priority when it is scheduled out and a SCHED_OTHER task
> is scheduled in.
> 
> Now if the vCPU gets preempted, it is this moment that we need the host
> kernel to look at the current priority of the task thread running on
> the vCPU. If it is an RT task, we need to boost the vCPU to that
> priority, so that a lower priority host thread does not interrupt it.

I got all that, but I still don't see any need to hook VM-Exit.  If the vCPU gets
preempted, the host scheduler is already getting "notified", otherwise the vCPU
would still be scheduled in, i.e. wouldn't have been preempted.

> The host should also set a bit in the shared memory to tell the guest
> that it was boosted. Then when the vCPU schedules a lower priority task
> than what is in shared memory, and the bit is set that tells the guest
> the host boosted the vCPU, it needs to make a hypercall to tell the
> host that it can lower its priority again.

Which again doesn't _need_ a dedicated/manual VM-Exit.  E.g. why force the host
to reasses the priority instead of simply waiting until the next reschedule?  If
the host is running tickless, then presumably there is a scheduling entity running
on a different pCPU, i.e. that can react to vCPU priority changes without needing
a VM-Exit.

