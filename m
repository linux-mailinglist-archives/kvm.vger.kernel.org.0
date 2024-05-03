Return-Path: <kvm+bounces-16551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEA18BB6CF
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 00:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 445491F2366A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 22:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA38758ADD;
	Fri,  3 May 2024 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmZxYtTu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0363398A;
	Fri,  3 May 2024 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714773650; cv=none; b=Pp3+zFllZCzRk/hmyiHLYTiuQ7hQb0lD482BZARtLKWOacqd2XQrtMZHTBtvXcroIDqZDX8zGstZIQjHS43Fa+d25JAxI7JUIK9WY67OarrewYIgkIlqT1axz9v4kFstQQvaISiW2Xf2ryoDyYv94wqSAjX52WmE5lRoow3HH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714773650; c=relaxed/simple;
	bh=Wjp+m2xGOm+Aog+4t+45QhXtC0X2FqTKlfMFUw3zH6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imfZacUQLJxWeMs2xnfNeO4N1oyihm1lxC/O7F09dsAf9WcpHCdazJceVQK3YJQ9XFRvBaWX9ZYe6WNEE73ogoLdE2AjQC+RpCupFZ5r2DQyH4WFsfOKQZEuJ8vBTNvOl3bXYxMj+LOLNNSNipo0PhS4bOJwjwuc0IKekOct7Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bmZxYtTu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC71C116B1;
	Fri,  3 May 2024 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714773649;
	bh=Wjp+m2xGOm+Aog+4t+45QhXtC0X2FqTKlfMFUw3zH6w=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=bmZxYtTuJeCrIAQBq9YXi4/ta3tvs8Z+0/8apdL/RakcPJRNsPpsbG/8Rg2O5zRYI
	 Fol4TpA4dwovaZTtS6ygHr5mfhlFr7iiSzKvjH+b8GPODj/IULorQ2yE3JYEP40pXn
	 2tRj9kmikk7IiGOf+ZJdcoAL+pZRGDERG0rRVO3ZFLNm+NaENfh+/b1Kr0AA2uhUqg
	 UUrc74RelCG6z8e3qDBPsB4r05kzX3kY08pMMF00JSx2mKsKMfJj3dbu0CRwbKqWne
	 SdsFULdUEsmKz54uORoBhvTMGWIRDrLJ8dxDfPcCJd9EPYut2Fty+fQAUawexFm7XC
	 My8F/qkdQ3uyw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 2A074CE0DEC; Fri,  3 May 2024 15:00:49 -0700 (PDT)
Date: Fri, 3 May 2024 15:00:49 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240328171949.743211-1-leobras@redhat.com>
 <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras>
 <ZjVXVc2e_V8NiMy3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjVXVc2e_V8NiMy3@google.com>

On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> On Fri, May 03, 2024, Leonardo Bras wrote:
> > > KVM can provide that information with much better precision, e.g. KVM
> > > knows when when it's in the core vCPU run loop.
> > 
> > That would not be enough.
> > I need to present the application/problem to make a point:
> > 
> > - There is multiple  isolated physical CPU (nohz_full) on which we want to 
> >   run KVM_RT vcpus, which will be running a real-time (low latency) task.
> > - This task should not miss deadlines (RT), so we test the VM to make sure 
> >   the maximum latency on a long run does not exceed the latency requirement
> > - This vcpu will run on SCHED_FIFO, but has to run on lower priority than
> >   rcuc, so we can avoid stalling other cpus.
> > - There may be some scenarios where the vcpu will go back to userspace
> >   (from KVM_RUN ioctl), and that does not mean it's good to interrupt the 
> >   this to run other stuff (like rcuc).
> >
> > Now, I understand it will cover most of our issues if we have a context 
> > tracking around the vcpu_run loop, since we can use that to decide not to 
> > run rcuc on the cpu if the interruption hapenned inside the loop.
> > 
> > But IIUC we can have a thread that "just got out of the loop" getting 
> > interrupted by the timer, and asked to run rcu_core which will be bad for 
> > latency.
> > 
> > I understand that the chance may be statistically low, but happening once 
> > may be enough to crush the latency numbers.
> > 
> > Now, I can't think on a place to put this context trackers in kvm code that 
> > would avoid the chance of rcuc running improperly, that's why the suggested 
> > timeout, even though its ugly.
> > 
> > About the false-positive, IIUC we could reduce it if we reset the per-cpu 
> > last_guest_exit on kvm_put.
> 
> Which then opens up the window that you're trying to avoid (IRQ arriving just
> after the vCPU is put, before the CPU exits to userspace).
> 
> If you want the "entry to guest is imminent" status to be preserved across an exit
> to userspace, then it seems liek the flag really should be a property of the task,
> not a property of the physical CPU.  Similar to how rcu_is_cpu_rrupt_from_idle()
> detects that an idle task was interrupted, that goal is to detect if a vCPU task
> was interrupted.
> 
> PF_VCPU is already "taken" for similar tracking, but if we want to track "this
> task will soon enter an extended quiescent state", I don't see any reason to make
> it specific to vCPU tasks.  Unless the kernel/KVM dynamically manages the flag,
> which as above will create windows for false negatives, the kernel needs to
> trust userspace to a certaine extent no matter what.  E.g. even if KVM sets a
> PF_xxx flag on the first KVM_RUN, nothing would prevent userspace from calling
> into KVM to get KVM to set the flag, and then doing something else entirely with
> the task.
> 
> So if we're comfortable relying on the 1 second timeout to guard against a
> misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> userspace communicate to the kernel that it's a real-time task that spends the
> overwhelming majority of its time in userspace or guest context, i.e. should be
> given extra leniency with respect to rcuc if the task happens to be interrupted
> while it's in kernel context.

But if the task is executing in host kernel context for quite some time,
then the host kernel's RCU really does need to take evasive action.

On the other hand, if that task is executing in guest context (either
kernel or userspace), then the host kernel's RCU can immediately report
that task's quiescent state.

Too much to ask for the host kernel's RCU to be able to sense the
difference?  ;-)

							Thanx, Paul

