Return-Path: <kvm+bounces-21504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 428D292FACA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 14:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED4BE283EAC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 12:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24016F849;
	Fri, 12 Jul 2024 12:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="MOS2fz0z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE60B8F58
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 12:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720789029; cv=none; b=dF7pOEamxIMJ9ziy7adDqEj9kb/WERTlj8F0yWZOsbNjMkmOzxWGwQ6nJVqISvooNu0uZ8fQdUuXvpPti5gb4UmRvSEOmfUSx/HpDAMP+MxL9m4spASOxYaRkgMBHRyDU13FE08x2Ycplc7nPfi354y+Tc0+B5D79ulThok525E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720789029; c=relaxed/simple;
	bh=xYiH5jCNQqRr/qc+YBTbDX/nQEsyM75tjLTFu8wcHv4=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6ICkh7z/V9TRKXiBP8uwMkxM9YpVc2uOGZ44iM4dbVMpkFNUuL4EZSLHSLHuVSEnmt1XREw3U/oKUBKpZ9Rqy4iGFIGXBhTwhKpb3mroVR1GeITqKzuIPKNmO9jQ/1JwSuAQLnUNpBm4yDHNZ+SsdwcNu436uEinlvBoL6hvy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org; spf=pass smtp.mailfrom=joelfernandes.org; dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b=MOS2fz0z; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-48fe6ddc33bso789717137.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 05:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1720789026; x=1721393826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jlW1hL62nKkPIrMHCW4y3SQ6z/VuasKsPL2u6aFOfQ0=;
        b=MOS2fz0zg0S1nlTHmQTK0DLsCR9DteIsxrUOD2/hU9B/4XPDxlZIIRhsna9TOdsg6P
         3p36KX02sYjnRJTSA+5A8p5i2E3Mi7Lghp9aEcF/oa5nrMuGPuj2gJHSy/6BagfOcUze
         1TKqdkcMO+i3ZpBcIhTG2JkQBl/KU9WEfyh84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720789026; x=1721393826;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlW1hL62nKkPIrMHCW4y3SQ6z/VuasKsPL2u6aFOfQ0=;
        b=r0WPlh27cxDcYnPMG4BlYqSWcxizzIqYcdSboE8zgDaDrMUnkTzZkNtjX41RhpEK6J
         EHapOoBSv0npQn5tbb+pRHF3yNeEmKBxGsP4fCtII/P8UeW6ICBNFeSGksI8i1qmQTg6
         a/0n1/8brdngiZcyvn0neZ43ZCB10iK1glTt6/Qtae5BvyotE7U2y9fbIchZilra4w/j
         AmcFfEwgmYqwxOON2l4UqbecqD3zYL+J7G2c12+qZkCxtsI+gAeMix8BjXWHhHnKToZu
         cIYpGXc8aRKQI9DlpQxFXL5hNc+KptYbLxICkhHeCOYmzN7G2+cLTC+Ji/6uOl8UCW9Q
         v7gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpTOHZ7OfDzssywHSI/DdwJjUBDEd6JyBaCiqOmgE+Z3YhcLC0siWxU+53nSS0XNCezzs/LbzqQMU6vuoG8Lsfu4o3
X-Gm-Message-State: AOJu0Yz9qItPVew4hD6uIF94JSKtA7eQS2NdFnMISo8FlOA91nrKInbn
	Hpwd1kounZbHl0a1KGXoORs5BQ+0vr3qZiG9T4++9nfSRkYwIglwyvAOVX+U3LA=
X-Google-Smtp-Source: AGHT+IHCmrDHC72kNXj9KdTlQ0Pi9TrHeanepCVAglfKq7C7zJXZHmAyi3+kiq5MU3xQ+Exx5Curbg==
X-Received: by 2002:a05:6102:b14:b0:48f:de23:14f0 with SMTP id ada2fe7eead31-4903211103bmr12855549137.8.1720789024871;
        Fri, 12 Jul 2024 05:57:04 -0700 (PDT)
Received: from localhost ([73.134.137.40])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-447f9bd2649sm40566711cf.68.2024.07.12.05.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 05:57:04 -0700 (PDT)
Message-ID: <66912820.050a0220.15d64.10f5@mx.google.com>
X-Google-Original-Message-ID: <20240712125703.GA850@JoelBox.>
Date: Fri, 12 Jul 2024 08:57:03 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	mathieu.desnoyers@efficios.com,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>, himadrics@inria.fr,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	graf@amazon.com, drjunior.org@gmail.com
Subject: Re: [RFC PATCH v2 0/5] Paravirt Scheduling (Dynamic vcpu priority
 management)
References: <20240403140116.3002809-1-vineeth@bitbyteword.org>
 <ZjJf27yn-vkdB32X@google.com>
 <CAO7JXPgbtFJO6fMdGv3jf=DfiCNzcfi4Hgfn3hfotWH=FuD3zQ@mail.gmail.com>
 <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO7JXPhMfibNsX6Nx902PRo7_A2b4Rnc3UP=bpKYeOuQnHvtrw@mail.gmail.com>

On Mon, Jun 24, 2024 at 07:01:19AM -0400, Vineeth Remanan Pillai wrote:
> > > Roughly summarazing an off-list discussion.
> > >
> > >  - Discovery schedulers should be handled outside of KVM and the kernel, e.g.
> > >    similar to how userspace uses PCI, VMBUS, etc. to enumerate devices to the guest.
> > >
> > >  - "Negotiating" features/hooks should also be handled outside of the kernel,
> > >    e.g. similar to how VirtIO devices negotiate features between host and guest.
> > >
> > >  - Pushing PV scheduler entities to KVM should either be done through an exported
> > >    API, e.g. if the scheduler is provided by a separate kernel module, or by a
> > >    KVM or VM ioctl() (especially if the desire is to have per-VM schedulers).
> > >
> > > I think those were the main takeaways?  Vineeth and Joel, please chime in on
> > > anything I've missed or misremembered.
> > >
> > Thanks for the brief about the offlist discussion, all the points are
> > captured, just some minor additions. v2 implementation removed the
> > scheduling policies outside of kvm to a separate entity called pvsched
> > driver and could be implemented as a kernel module or bpf program. But
> > the handshake between guest and host to decide on what pvsched driver
> > to attach was still going through kvm. So it was suggested to move
> > this handshake(discovery and negotiation) outside of kvm. The idea is
> > to have a virtual device exposed by the VMM which would take care of
> > the handshake. Guest driver for this device would talk to the device
> > to understand the pvsched details on the host and pass the shared
> > memory details. Once the handshake is completed, the device is
> > responsible for loading the pvsched driver(bpf program or kernel
> > module responsible for implementing the policies). The pvsched driver
> > will register to the trace points exported by kvm and handle the
> > callbacks from then on. The scheduling will be taken care of by the
> > host scheduler, pvsched driver on host is responsible only for setting
> > the policies(placement, priorities etc).
> >
> > With the above approach, the only change in kvm would be the internal
> > tracepoints for pvsched. Host kernel will also be unchanged and all
> > the complexities move to the VMM and the pvsched driver. Guest kernel
> > will have a new driver to talk to the virtual pvsched device and this
> > driver would hook into the guest kernel for passing scheduling
> > information to the host(via tracepoints).
> >
> Noting down the recent offlist discussion and details of our response.
> 
> Based on the previous discussions, we had come up with a modified
> design focusing on minimum kvm changes. The design is as follows:
> - Guest and host share scheduling information via shared memory
> region. Details of the layout of the memory region, information shared
> and actions and policies are defined by the pvsched protocol. And this
> protocol is implemented by a BPF program or a kernel module.
> - Host exposes a virtual device(pvsched device to the guest). This
> device is the mechanism for host and guest for handshake and
> negotiation to reach a decision on the pvsched protocol to use. The
> virtual device is implemented in the VMM in userland as it doesn't
> come in the performance critical path.
> - Guest loads a pvsched driver during device enumeration. the driver
> initiates the protocol handshake and negotiation with the host and
> decides on the protocol. This driver creates a per-cpu shared memory
> region and shares the GFN with the device in the host. Guest also
> loads the BPF program that implements the protocol in the guest.
> - Once the VMM has all the information needed(per-cpu shared memory
> GFN, vcpu task pids etc), it loads the BPF program which implements
> the protocol on the host.
> - BPF program on the host registers the trace points in kvm to get
> callbacks on interested events like VMENTER, VMEXIT, interrupt
> injection etc. Similarly, the guest BPF program registers tracepoints
> in the guest kernel for interested events like sched wakeup, sched
> switch, enqueue, dequeue, irq entry/exit etc.
> 
> The above design is minimally invasive to the kvm and core kernel and
> implements the protocol as loadable programs and protocol handshake
> and negotiation through the virtual device framework. Protocol
> implementation takes care of information sharing and policy
> enforcements and scheduler handles the actual scheduling decisions.
> Sample policy implementation(boosting for latency sensitive workloads
> as an example) could be included in the kernel for reference.
> 
> We had an offlist discussion about the above design and a couple of
> ideas were suggested as an alternative. We had taken an action item to
> study the alternatives for the feasibility. Rest of the mail lists the
> use cases(not conclusive) and our feasibility investigations.
> 
> Existing use cases
> -------------------------
> 
> - A latency sensitive workload on the guest might need more than one
> time slice to complete, but should not block any higher priority task
> in the host. In our design, the latency sensitive workload shares its
> priority requirements to host(RT priority, cfs nice value etc). Host
> implementation of the protocol sets the priority of the vcpu task
> accordingly so that the host scheduler can make an educated decision
> on the next task to run. This makes sure that host processes and vcpu
> tasks compete fairly for the cpu resource.
> - Guest should be able to notify the host that it is running a lower
> priority task so that the host can reschedule it if needed. As
> mentioned before, the guest shares the priority with the host and the
> host takes a better scheduling decision.
> - Proactive vcpu boosting for events like interrupt injection.
> Depending on the guest for boost request might be too late as the vcpu
> might not be scheduled to run even after interrupt injection. Host
> implementation of the protocol boosts the vcpu tasks priority so that
> it gets a better chance of immediately being scheduled and guest can
> handle the interrupt with minimal latency. Once the guest is done
> handling the interrupt, it can notify the host and lower the priority
> of the vcpu task.
> - Guests which assign specialized tasks to specific vcpus can share
> that information with the host so that host can try to avoid
> colocation of those cpus in a single physical cpu. for eg: there are
> interrupt pinning use cases where specific cpus are chosen to handle
> critical interrupts and passing this information to the host could be
> useful.
> - Another use case is the sharing of cpu capacity details between
> guest and host. Sharing the host cpu's load with the guest will enable
> the guest to schedule latency sensitive tasks on the best possible
> vcpu. This could be partially achievable by steal time, but steal time
> is more apparent on busy vcpus. There are workloads which are mostly
> sleepers, but wake up intermittently to serve short latency sensitive
> workloads. input event handlers in chrome is one such example.
> 
> Data from the prototype implementation shows promising improvement in
> reducing latencies. Data was shared in the v1 cover letter. We have
> not implemented the capacity based placement policies yet, but plan to
> do that soon and have some real numbers to share.
> 
> Ideas brought up during offlist discussion
> -------------------------------------------------------
> 
> 1. rseq based timeslice extension mechanism[1]
> 
> While the rseq based mechanism helps in giving the vcpu task one more
> time slice, it will not help in the other use cases. We had a chat
> with Steve and the rseq mechanism was mainly for improving lock
> contention and would not work best with vcpu boosting considering all
> the use cases above. RT or high priority tasks in the VM would often
> need more than one time slice to complete its work and at the same,
> should not be hurting the host workloads. The goal for the above use
> cases is not requesting an extra slice, but to modify the priority in
> such a way that host processes and guest processes get a fair way to
> compete for cpu resources. This also means that vcpu task can request
> a lower priority when it is running lower priority tasks in the VM.

I was looking at the rseq on request from the KVM call, however it does not
make sense to me yet how to expose the rseq area via the Guest VA to the host
kernel.  rseq is for userspace to kernel, not VM to kernel.

Steven Rostedt said as much as well, thoughts? Add Mathieu as well.

This idea seems to suffer from the same vDSO over-engineering below, rseq
does not seem to fit.

Steven Rostedt told me, what we instead need is a tracepoint callback in a
driver, that does the boosting.

 - Joel



> 
> 2. vDSO approach
> Regarding the vDSO approach, we had a look at that and feel that
> without a major redesign of vDSO, it might be difficult to achieve the
> requirements. vDSO is currently implemented as a shared read-only
> memory region with the processes. For this to work with
> virtualization, we would need to map a similar region to the guest and
> it has to be read-write. This is more or less what we are also
> proposing, but with minimal changes in the core kernel. With the
> current design, the shared memory region would be the responsibility
> of the virtual pvsched device framework.
> 
> Sorry for the long mail. Please have a look and let us know your thoughts :-)
> 
> Thanks,
> 
> [1]: https://lore.kernel.org/all/20231025235413.597287e1@gandalf.local.home/

