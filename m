Return-Path: <kvm+bounces-4522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C6081366E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEA10B20A95
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8053360BA5;
	Thu, 14 Dec 2023 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RIgX3CLh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63610F
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:38:49 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28b0f6a62f9so925561a91.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702571929; x=1703176729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgFC2UkHZlElWA30ukvsWw2kCiyu/c5uf7p4lb7iNbg=;
        b=RIgX3CLhwvI9e4qLUdkZKjdVUhE/5wRLP9vaNpV3KTN/NrBCYTJYB9KNsEwKmiP9pT
         msw+hoILAn4hrM2oxLrbBGdbheeGzwRt98reGcTWp4f2Zk3KSlViesyQQTDdcpC6YBJN
         BynK9lDpfDd53sltuq7VLu2LiIAZ4UGdLMAKO1iaJX46W8gLC+qrnOul9ErNflSTSEEQ
         VSuZBHUTBSOwcIUOS4tKKU2Jhru1jAvu1X4mQZHEw0CpvSiuQa1CnV6rtPbptajkfSil
         q12HYSGnEkgo+DQJFLSsq07rThItJRgSlMUAXrh4hKjYN96W7O7kbSSoHWFpLYvhjLZC
         YnDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702571929; x=1703176729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgFC2UkHZlElWA30ukvsWw2kCiyu/c5uf7p4lb7iNbg=;
        b=FGthQKsMQNXfh/lMzlrPslIO785wDU+RGfCHNl0X1Sn4AIQ2M05x1uyfPc+oUbAyIQ
         9OMW52M0smPr72UoAE0B0lwQghGmf5dn2D3ee9H0JBFgAMs/oqiLSQMMu5Ndzivn6shi
         mYTRXrCd5QyQOfu8nz9OmD57+smYj7mLk4+AmzqtySCHB5MInG/rKTP8ELVUSaad3KwU
         OS0aCCZLl+Kc8zpXPuhx8Hh31FTHUsiia6Vir/XXktTONsuuzFbsdcZ1ogZzE6wG3FW9
         g3GOdUnPgcFtL6+JoxApG62CpVQcrLRcV8r3j95XFEXKASsFbyYT/oRmkAuaz3nFhto4
         8VpQ==
X-Gm-Message-State: AOJu0YzY5ylV5EdXD3XDWU4KXWpZ5u78pzFhYg+0g9mTEhx2SLH6AtDM
	qdspLxgwqSCrfiqBAdxKDyIIM0ACafQ=
X-Google-Smtp-Source: AGHT+IFw3A95D/cMefOg8sp5pB4196OqT6qF241cjoGEiu9axW1D3f3RuNRCUtwd783u/60K/NHS0q5tgd4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ebcb:b0:286:4090:7397 with SMTP id
 cf11-20020a17090aebcb00b0028640907397mr1058904pjb.5.1702571929027; Thu, 14
 Dec 2023 08:38:49 -0800 (PST)
Date: Thu, 14 Dec 2023 08:38:47 -0800
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Message-ID: <ZXsvl7mabUuNkWcY@google.com>
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
From: Sean Christopherson <seanjc@google.com>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Suleiman Souhlal <suleiman@google.com>, 
	Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tejun Heo <tj@kernel.org>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, David Vernet <dvernet@meta.com>
Content-Type: text/plain; charset="us-ascii"

+sched_ext folks

On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
> Double scheduling is a concern with virtualization hosts where the host
> schedules vcpus without knowing whats run by the vcpu and guest schedules
> tasks without knowing where the vcpu is physically running. This causes
> issues related to latencies, power consumption, resource utilization
> etc. An ideal solution would be to have a cooperative scheduling
> framework where the guest and host shares scheduling related information
> and makes an educated scheduling decision to optimally handle the
> workloads. As a first step, we are taking a stab at reducing latencies
> for latency sensitive workloads in the guest.
> 
> This series of patches aims to implement a framework for dynamically
> managing the priority of vcpu threads based on the needs of the workload
> running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
> critcal sections, RT tasks etc) will get a boost from the host so as to
> minimize the latency.
> 
> The host can proactively boost the vcpu threads when it has enough
> information about what is going to run on the vcpu - fo eg: injecting
> interrupts. For rest of the case, guest can request boost if the vcpu is
> not already boosted. The guest can subsequently request unboost after
> the latency sensitive workloads completes. Guest can also request a
> boost if needed.
> 
> A shared memory region is used to communicate the scheduling information.
> Guest shares its needs for priority boosting and host shares the boosting
> status of the vcpu. Guest sets a flag when it needs a boost and continues
> running. Host reads this on next VMEXIT and boosts the vcpu thread. For
> unboosting, it is done synchronously so that host workloads can fairly
> compete with guests when guest is not running any latency sensitive
> workload.

Big thumbs down on my end.  Nothing in this RFC explains why this should be done
in KVM.  In general, I am very opposed to putting policy of any kind into KVM,
and this puts a _lot_ of unmaintainable policy into KVM by deciding when to
start/stop boosting a vCPU.

Concretely, boosting vCPUs for most events is far too coarse grained.  E.g. boosting
a vCPU that is running a low priority workload just because the vCPU triggered
an NMI due to PMU counter overflow doesn't make sense.  Ditto for if a guest's
hrtimer expires on a vCPU running a low priority workload.

And as evidenced by patch 8/8, boosting vCPUs based on when an event is _pending_
is not maintainable.  As hardware virtualizes more and more functionality, KVM's
visilibity into the guest effectively decreases, e.g. Intel and AMD both support
with IPI virtualization.

Boosting the target of a PV spinlock kick is similarly flawed.  In that case, KVM
only gets involved _after_ there is a problem, i.e. after a lock is contended so
heavily that a vCPU stops spinning and instead decided to HLT.  It's not hard to
imagine scenarios where a guest would want to communicate to the host that it's
acquiring a spinlock for a latency sensitive path and so shouldn't be scheduled
out.  And of course that's predicated on the assumption that all vCPUs are subject
to CPU overcommit.

Initiating a boost from the host is also flawed in the sense that it relies on
the guest to be on the same page as to when it should stop boosting.  E.g. if
KVM boosts a vCPU because an IRQ is pending, but the guest doesn't want to boost
IRQs on that vCPU and thus doesn't stop boosting at the end of the IRQ handler,
then the vCPU could end up being boosted long after its done with the IRQ.

Throw nested virtualization into the mix and then all of this becomes nigh
impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2 vCPU, i.e.
a nested guest, and L2 is spamming interrupts for whatever reason, KVM will end
repeatedly boosting the L1 vCPU regardless of the priority of the L2 workload.

For things that aren't clearly in KVM's domain, I don't think we should implement
KVM-specific functionality until every other option has been tried (and failed).
I don't see any reason why KVM needs to get involved in scheduling, beyond maybe
providing *input* regarding event injection, emphasis on *input* because KVM
providing information to userspace or some other entity is wildly different than
KVM making scheduling decisions based on that information.

Pushing the scheduling policies to host userspace would allow for far more control
and flexibility.  E.g. a heavily paravirtualized environment where host userspace
knows *exactly* what workloads are being run could have wildly different policies
than an environment where the guest is a fairly vanilla Linux VM that has received
a small amount of enlightment.

Lastly, if the concern/argument is that userspace doesn't have the right knobs
to (quickly) boost vCPU tasks, then the proposed sched_ext functionality seems
tailor made for the problems you are trying to solve.

https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org

