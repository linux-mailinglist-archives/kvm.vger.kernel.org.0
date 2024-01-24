Return-Path: <kvm+bounces-6747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381C9839E9A
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 616A41C238E0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14561C3D;
	Wed, 24 Jan 2024 02:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="gWr38nbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0271842
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 02:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706062520; cv=none; b=omUoi+iQoH7S/xPJlep0Zkuxd+qWE6ikLa7UDOAwBeOfrk5hipCspRIT16EaMxo8NH3MPEz9XoG739gTdbFcQUGrJwRy7uwrH7YPB/c3iXBneOfSkagveQmQhRBiSBgPZyjOmxDP7EzipI1epaUBt2FFbb7ns3rdzUgZITchdks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706062520; c=relaxed/simple;
	bh=mAuWimF9/JdolbOXrfa+20Z8dwdDzsIgdCBNesNCbr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ja2+ij3DVUnC3BEUDABNtl8Mn4C7DaadNgoZYYf3f2ESBoFQG21UzOQZiBIBY9WqRz8znvnSDUNC+uz39TbiMtf8QaJhDx1L0pVrom9l0b2Yk7I4J2k48f6NMWm29GU29mWKEQE1B/a9cc7K1SZujb9TOCO8WbrepjKlFjB5WzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=gWr38nbk; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7831e87ba13so434272685a.0
        for <kvm@vger.kernel.org>; Tue, 23 Jan 2024 18:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1706062517; x=1706667317; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mMPalqrqPhrnDRsUwlDy30jOytqjutazMrkyaVaV4ho=;
        b=gWr38nbk2fT2XMsCa9048fLB6hgCjmQ6TNZ5gVfYpji9/WZvYV819J7zgRLLo/tT72
         XpNrLIw+sEp6WUt7ngL7cYF2hcjzfHxeNVgUt3cmHXX/p1B4Tmx8bZ6PA6nTbRLB7IpT
         YgDHgwLwbYp3xLZxI0njF8KCNG5MtHhmi/ucg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706062517; x=1706667317;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMPalqrqPhrnDRsUwlDy30jOytqjutazMrkyaVaV4ho=;
        b=f9ONFWc45uOhfH6W3o2VKdRnehAmgKZqtPf1dW4tUN3lJ2gCOx2xbNj+Uw8DKL+Cqa
         1fgZZaJ2CuExhgpxnQQzcIJ5k7ghZ1u5NJF0yYjZREUkAssAiv8xhYGJjiFFKyOuILZJ
         7HxKub9P6VkESf/teiuffZyOKi3V+1G30cqq3v2yCTwyxy5hFqyyHIrFPCkVZThkNari
         7QCAVDo1cCgPRmE8KKepb6cXSXSOj++Z0n6wif+uYIsbFy0+8BPudV/jcNxKUZKxDT0v
         TlONKbxeTcwSDeObdE5NsEQw7Xg+tNJkCKA51Hrjz+tRd2Z+RJOijEgKnHgNlgZsUgWJ
         WoHA==
X-Gm-Message-State: AOJu0Yy437QO94eNcxUNGOSwx0fD6AuONd0xhy/KbuCvyRFuQnBDXCyl
	GOQpfKXBtPPMhgW+l6z2wOhQ7KStjR29F49ottCclQl7KDZJaNukzpxnG8ml+qE=
X-Google-Smtp-Source: AGHT+IFipmMi4KLP1/zvdpL1Kq7D4lD+Kj1ror1RBNDPzRMbU8+B1FWdw0dEzmAsSLEHrP5/wuCWbw==
X-Received: by 2002:a05:6214:2a48:b0:686:261a:76a0 with SMTP id jf8-20020a0562142a4800b00686261a76a0mr2104642qvb.52.1706062517499;
        Tue, 23 Jan 2024 18:15:17 -0800 (PST)
Received: from [10.5.0.2] ([45.88.220.198])
        by smtp.gmail.com with ESMTPSA id n2-20020a0ce942000000b0067f032cf59bsm3982473qvo.27.2024.01.23.18.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 18:15:16 -0800 (PST)
Message-ID: <052b0521-2273-4b1f-bd94-a3decceb9b05@joelfernandes.org>
Date: Tue, 23 Jan 2024 21:15:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] Dynamic vcpu priority management in kvm
Content-Language: en-US
To: David Vernet <void@manifault.com>
Cc: Sean Christopherson <seanjc@google.com>,
 "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
 Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
 Daniel Bristot de Oliveira <bristot@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Suleiman Souhlal <suleiman@google.com>,
 Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, Tejun Heo <tj@kernel.org>,
 Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>,
 David Dunn <daviddunn@google.com>, julia.lawall@inria.fr,
 himadrispandya@gmail.com, jean-pierre.lozi@inria.fr, ast@kernel.org,
 paulmck@kernel.org
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <ZXsvl7mabUuNkWcY@google.com> <20231215181014.GB2853@maniforge>
 <6595bee6.e90a0220.57b35.76e9@mx.google.com>
 <20240104223410.GE303539@maniforge>
From: Joel Fernandes <joel@joelfernandes.org>
In-Reply-To: <20240104223410.GE303539@maniforge>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi David,
I got again side tracked. I'll now prioritize this thread with quicker
(hopefully daily) replies.

> 
>>>> On Wed, Dec 13, 2023, Vineeth Pillai (Google) wrote:
>>>>> Double scheduling is a concern with virtualization hosts where the host
>>>>> schedules vcpus without knowing whats run by the vcpu and guest schedules
>>>>> tasks without knowing where the vcpu is physically running. This causes
>>>>> issues related to latencies, power consumption, resource utilization
>>>>> etc. An ideal solution would be to have a cooperative scheduling
>>>>> framework where the guest and host shares scheduling related information
>>>>> and makes an educated scheduling decision to optimally handle the
>>>>> workloads. As a first step, we are taking a stab at reducing latencies
>>>>> for latency sensitive workloads in the guest.
>>>>>
>>>>> This series of patches aims to implement a framework for dynamically
>>>>> managing the priority of vcpu threads based on the needs of the workload
>>>>> running on the vcpu. Latency sensitive workloads (nmi, irq, softirq,
>>>>> critcal sections, RT tasks etc) will get a boost from the host so as to
>>>>> minimize the latency.
>>>>>
>>>>> The host can proactively boost the vcpu threads when it has enough
>>>>> information about what is going to run on the vcpu - fo eg: injecting
>>>>> interrupts. For rest of the case, guest can request boost if the vcpu is
>>>>> not already boosted. The guest can subsequently request unboost after
>>>>> the latency sensitive workloads completes. Guest can also request a
>>>>> boost if needed.
>>>>>
>>>>> A shared memory region is used to communicate the scheduling information.
>>>>> Guest shares its needs for priority boosting and host shares the boosting
>>>>> status of the vcpu. Guest sets a flag when it needs a boost and continues
>>>>> running. Host reads this on next VMEXIT and boosts the vcpu thread. For
>>>>> unboosting, it is done synchronously so that host workloads can fairly
>>>>> compete with guests when guest is not running any latency sensitive
>>>>> workload.
>>>>
>>>> Big thumbs down on my end.  Nothing in this RFC explains why this should be done
>>>> in KVM.  In general, I am very opposed to putting policy of any kind into KVM,
>>>> and this puts a _lot_ of unmaintainable policy into KVM by deciding when to
>>>> start/stop boosting a vCPU.
>>>
>>> I have to agree, not least of which is because in addition to imposing a
>>> severe maintenance tax, these policies are far from exhaustive in terms
>>> of what you may want to do for cooperative paravirt scheduling.
>>
>> Just to clarify the 'policy' we are discussing here, it is not about 'how to
>> schedule' but rather 'how/when to boost/unboost'. We want the existing
>> scheduler (or whatever it might be in the future) to make the actual decision
>> about how to schedule.
> 
> Thanks for clarifying. I think we're on the same page. I didn't mean to
> imply that KVM is actually in the scheduler making decisions about what
> task to run next, but that wasn't really my concern. My concern is that
> this patch set makes KVM responsible for all of the possible paravirt
> policies by encoding it in KVM UAPI, and is ultimately responsible for
> being aware of and communicating those policies between the guest to the
> host scheduler.
> 
> Say that we wanted to add some other paravirt related policy like "these
> VCPUs may benefit from being co-located", or, "this VCPU just grabbed a
> critical spinlock so please pin me for a moment". That would require
> updating struct guest_schedinfo UAPI in kvm_para.h, adding getters and
> setters to kvm_host.h to set those policies for the VCPU (though your
> idea to use a BPF hook on VMEXIT may help with that onme), setting the
> state from the guest, etc.

These are valid points, and I agree!

> 
> KVM isn't making scheduling decisions, but it's the arbiter of what data
> is available to the scheduler to consume. As it relates to a VCPU, it
> seems like this patch set makes KVM as much invested in the scheduling
> decision that's eventually made as the actual scheduler. Also worth
> considering is that it ties KVM UAPI to sched/core.c, which seems
> undesirable from the perspective of both subsystems.

Ok, Agreed.

> 
>> In that sense, I agree with Sean that we are probably forcing a singular
>> policy on when and how to boost which might not work for everybody (in theory
>> anyway). And I am perfectly OK with the BPF route as I mentioned in the other
> 
> FWIW, I don't think it's just that boosting may not work well in every
> context (though I do think there's an argument to be made for that, as
> Sean pointed out r.e. hard IRQs in nested context). The problem is also
> that boosting is just one example of a paravirt policy that you may want
> to enable, as I alluded to above, and that comes with complexity and
> maintainership costs.

Ok, agreed.

> 
>> email. So perhaps we can use a tracepoint in the VMEXIT path to run a BPF
>> program (?). And we still have to figure out how to run BPF programs in the
>> interrupt injections patch (I am currently studying those paths more also
>> thanks to Sean's email describing them).
> 
> If I understand correctly, based on your question below, the idea is to
> call sched_setscheduler() from a kfunc in this VMEXIT BPF tracepoint?
> Please let me know if that's correct -- I'll respond to this below where
> you ask the question.

Yes that's correct.

> 
> As an aside, even if we called a BPF tracepoint prog on the VMEXIT path,
> AFAIU it would still require UAPI changes given that we'd still need to
> make all the same changes in the guest, right?

By UAPI, do you mean hypercall or do you mean shared memory? If hypercall, we
actually don't need hypercall for boosting. We boost during VMEXIT. We only need
to set some state from the guest, in shared memory to hint that it might be
needed at some point in the future. If no preemption-induced VMEXIT happens,
then no scheduler boosting happens (or needs to happen).

There might be a caveat to the unboosting path though needing a hypercall and I
need to check with Vineeth on his latest code whether it needs a hypercall, but
we could probably figure that out. In the latest design, one thing I know is
that we just have to force a VMEXIT for both boosting and unboosting. Well for
boosting, the VMEXIT just happens automatically due to vCPU preemption, but for
unboosting it may not.

In any case, can we not just force a VMEXIT from relevant path within the guest,
again using a BPF program? I don't know what the BPF prog to do that would look
like, but I was envisioning we would call a BPF prog from within a guest if
needed at relevant point (example, return to guest userspace).

Does that make sense?

> I see why having a BPF
> hook here would be useful to avoid some of the logic on the host that
> implements the boosting, and to give more flexibility as to when to
> apply that boosting, but in my mind it seems like the UAPI concerns are
> the most relevant.

Yes, lets address the UAPI. My plan is to start a new design document like a
google doc, and I could share that with you so we can sketch this out. What do
you think? And perhaps also we can discuss it at LSFMM.

> 
>> [...]
>>>> Concretely, boosting vCPUs for most events is far too coarse grained.  E.g. boosting
>>>> a vCPU that is running a low priority workload just because the vCPU triggered
>>>> an NMI due to PMU counter overflow doesn't make sense.  Ditto for if a guest's
>>>> hrtimer expires on a vCPU running a low priority workload.
>>>>
>>>> And as evidenced by patch 8/8, boosting vCPUs based on when an event is _pending_
>>>> is not maintainable.  As hardware virtualizes more and more functionality, KVM's
>>>> visilibity into the guest effectively decreases, e.g. Intel and AMD both support
>>>> with IPI virtualization.
>>>>
>>>> Boosting the target of a PV spinlock kick is similarly flawed.  In that case, KVM
>>>> only gets involved _after_ there is a problem, i.e. after a lock is contended so
>>>> heavily that a vCPU stops spinning and instead decided to HLT.  It's not hard to
>>>> imagine scenarios where a guest would want to communicate to the host that it's
>>>> acquiring a spinlock for a latency sensitive path and so shouldn't be scheduled
>>>> out.  And of course that's predicated on the assumption that all vCPUs are subject
>>>> to CPU overcommit.
>>>>
>>>> Initiating a boost from the host is also flawed in the sense that it relies on
>>>> the guest to be on the same page as to when it should stop boosting.  E.g. if
>>>> KVM boosts a vCPU because an IRQ is pending, but the guest doesn't want to boost
>>>> IRQs on that vCPU and thus doesn't stop boosting at the end of the IRQ handler,
>>>> then the vCPU could end up being boosted long after its done with the IRQ.
>>>>
>>>> Throw nested virtualization into the mix and then all of this becomes nigh
>>>> impossible to sort out in KVM.  E.g. if an L1 vCPU is a running an L2 vCPU, i.e.
>>>> a nested guest, and L2 is spamming interrupts for whatever reason, KVM will end
>>>> repeatedly boosting the L1 vCPU regardless of the priority of the L2 workload.
>>>>
>>>> For things that aren't clearly in KVM's domain, I don't think we should implement
>>>> KVM-specific functionality until every other option has been tried (and failed).
>>>> I don't see any reason why KVM needs to get involved in scheduling, beyond maybe
>>>> providing *input* regarding event injection, emphasis on *input* because KVM
>>>> providing information to userspace or some other entity is wildly different than
>>>> KVM making scheduling decisions based on that information.
>>>>
>>>> Pushing the scheduling policies to host userspace would allow for far more control
>>>> and flexibility.  E.g. a heavily paravirtualized environment where host userspace
>>>> knows *exactly* what workloads are being run could have wildly different policies
>>>> than an environment where the guest is a fairly vanilla Linux VM that has received
>>>> a small amount of enlightment.
>>>>
>>>> Lastly, if the concern/argument is that userspace doesn't have the right knobs
>>>> to (quickly) boost vCPU tasks, then the proposed sched_ext functionality seems
>>>> tailor made for the problems you are trying to solve.
>>>>
>>>> https://lkml.kernel.org/r/20231111024835.2164816-1-tj%40kernel.org
>>>
>>> I very much agree. There are some features missing from BPF that we'd
>>> need to add to enable this, but they're on the roadmap, and I don't
>>> think they'd be especially difficult to implement.
>>>
>>> The main building block that I was considering is a new kptr [0] and set
>>> of kfuncs [1] that would allow a BPF program to have one or more R/W
>>> shared memory regions with a guest.
>>
>> I really like your ideas around sharing memory across virt boundary using
>> BPF. The one concern I would have is that, this does require loading a BPF
>> program from the guest userspace, versus just having a guest kernel that
>> 'does the right thing'.
> 
> Yeah, that's a fair concern. The problem is that I'm not sure how we get
> around that if we want to avoid tying up every scheduling paravirt
> policy into a KVM UAPI. Putting everything into UAPI just really doesn't
> seem scalable. I'd be curious to hear Sean's thoughts on this. Note that
> I'm not just talking about scheduling paravirt here -- one could imagine
> many possible examples, e.g. relating to I/O, MM, etc.

We could do same thing in guest, call BPF prog at a certain point, if needed.
But again, since we only need to bother with VMEXIT for scheduler boosting
(which doesn't need hypercall), it should be Ok. For the unboosting part, we
could implement that also using either a BPF prog at appropriate guest hook, or
just having a timer go off to take away boost if boosting has been done too
long. We could award a boost for a bounded time as well, and force a VMEXIT to
unboost if VMEXIT has not already happened yet.. there should be many ways to
avoid an unboost hypercall..

> 
> It seems much more scalable to instead have KVM be responsible for
> plumbing mappings between guest and host BPF programs (I haven't thought
> through the design or interface for that at _all_, just thinking in
> high-level terms here), and then those BPF programs could decide on
> paravirt interfaces that don't have to be in UAPI.

It sounds like by UAPI, you mean hypercalls right? The actual shared memory
structure should not be a UAPI concern since that will defined by the BPF
program and how it wants to interpret the fields..

> Having KVM be
> responsible for setting up opaque communication channels between the
> guest and host feels likes a more natural building block than having it
> actually be aware of the policies being implemented over those
> communication channels.

Agreed.

> 
>> On the host, I would have no problem loading a BPF program as a one-time
>> thing, but on the guest it may be more complex as we don't always control the
>> guest userspace and their BPF loading mechanisms. Example, an Android guest
>> needs to have its userspace modified to load BPF progs, etc. Not hard
>> problems, but flexibility comes with more cost. Last I recall, Android does
>> not use a lot of the BPF features that come with the libbpf library because
>> they write their own userspace from scratch (due to licensing). OTOH, if this
>> was an Android kernel-only change, that would simplify a lot.
> 
> That is true, but the cost is double-sided. On the one hand, we have the
> complexity and maintenance costs of plumbing all of this through KVM and
> making it UAPI. On the other, we have the cost of needing to update a
> user space framework to accommodate loading and managing BPF programs.
> At this point BPF is fully supported on aarch64, so Android should have
> everything it needs to use it. It sounds like it will require some
> (maybe even a lot of) work to accommodate that, but that seems
> preferable to compensating for gaps in a user space framework by adding
> complexity to the kernel, no?

Yes it should be preferable.

> 
>> Still there is a lot of merit to sharing memory with BPF and let BPF decide
>> the format of the shared memory, than baking it into the kernel... so thanks
>> for bringing this up! Lets talk more about it... Oh, and there's my LSFMMBPF
>> invitiation request ;-) ;-).
> 
> Discussing this BPF feature at LSFMMBPF is a great idea -- I'll submit a
> proposal for it and cc you. I looked and couldn't seem to find the
> thread for your LSFMMBPF proposal. Would you mind please sending a link?

I actually have not even submitted one for LSFMM but my management is supportive
of my visit. Do you want to go ahead and submit one with all of us included in
the proposal? And I am again sorry for the late reply and hopefully we did not
miss any deadlines. Also on related note, there is interest in sched_ext for
more custom scheduling. We could discuss that as well while at LSFMM.

> 
>>> This could enable a wide swath of
>>> BPF paravirt use cases that are not limited to scheduling, but in terms
>>> of sched_ext, the BPF scheduler could communicate with the guest
>>> scheduler over this shared memory region in whatever manner was required
>>> for that use case.
>>>
>>> [0]: https://lwn.net/Articles/900749/
>>> [1]: https://lwn.net/Articles/856005/
>>
>> Thanks, I had no idea about these. I have a question -- would it be possible
>> to call the sched_setscheduler() function in core.c via a kfunc? Then we can
>> trigger the boost from a BPF program on the host side. We could start simple
>> from there.
> 
> There's nothing stopping us from adding a kfunc that calls
> sched_setscheduler(). The questions are how other scheduler folks feel
> about that, and whether that's the appropriate general solution to the
> problem. It does seem odd to me to have a random KVM tracepoint be
> entitled to set a generic task's scheduling policy and priority.

Such oddities are application specific though. User space can already call
setscheduler arbitrarily, so why not a BPF program?

> 
>> I agree on the rest below. I just wanted to emphasize though that this patch
>> series does not care about what the scheduler does. It merely hints the
>> scheduler via a priority setting that something is an important task. That's
>> a far cry from how to actually schedule and the spirit here is to use
>> whatever scheduler the user has to decide how to actually schedule.
> 
> Yep, I don't disagree with you at all on that point. To me this really
> comes down to a question of the costs and long-term design choices, as
> we discussed above:
> 
> 1. What is the long-term maintenance cost to KVM and the scheduler to
>    land paravirt scheduling in this form?
> 
> Even assuming that we go with the BPF hook on VMEXIT approach, unless
> I'm missing something, I think we'd still need to make UAPI changes to
> kvm_para.h, and update the guest to set the relevant paravirt state in
> the guest scheduler.

As mentioned above, for boosting, there is no hypercall. The VMEXIT is induced
by host preemption.

> That's not a huge amount of code for just boosting
> and deboosting, but it sets the precedent that any and all future
> scheduling paravirt logic will need to go through UAPI, and that the
> core scheduler will need to accommodate that paravirt when and where
> appropriate.
> 
> I may be being overly pessimistic, but I feel that could open up a
> rather scary can of worms; both in terms of the potential long-term
> complexity in the kernel itself, and in terms of the maintenance burden
> that may eventually be imposed to properly support it. It also imposes a
> very high bar on being able to add and experiment with new paravirt
> policies.

Hmm, yeah lets discuss this more. It does appear we need to do *something* than
leaving the performance on the table.

> 
> 2. What is the cost we're imposing on users if we force paravirt to be
>    done through BPF? Is this prohibitively high?
> 
> There is certainly a nonzero cost. As you pointed out, right now Android
> apparently doesn't use much BPF, and adding the requisite logic to use
> and manage BPF programs is not insigificant.
> 
> Is that cost prohibitively high? I would say no. BPF should be fully
> supported on aarch64 at this point, so it's really a user space problem.
> Managing the system is what user space does best, and many other
> ecosystems have managed to integrate BPF to great effect. So while the
> cost is cetainly nonzero, I think there's a reasonable argument to be
> made that it's not prohibitively high.

Yes, I think it is doable.

Glad to be able to finally reply, and I shall prioritize this thread more on my
side moving forward.

thanks,

- Joel

