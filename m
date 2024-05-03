Return-Path: <kvm+bounces-16550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4148BB6CC
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 00:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 624D51C23B16
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 22:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFF758ABF;
	Fri,  3 May 2024 22:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWlyIXHI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A15103D
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714773619; cv=none; b=CoGw8LJd2W7KR64dPV8PDn5q+5lG1TjGhWeCHPdK5Ph1BrDeMBhRJUPSwmsmlcaMVNFgU8/HS7od6u+HS8PYzYwTd/3PgHzX2Ro+yQf/zyXtXe+W3DT3kMCB4T/nXwLnhg2WMJEl9E+ojo7bGLli/yM/PVz/O6R+1iqlcBLOXH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714773619; c=relaxed/simple;
	bh=XQiU0er//ycreNecj07YnExhQLfQPkzMxtFyfmDgfLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=PWMfpV4p0qhGlO5YN95G2T501CN+MQZOcuBa6llOgz3Vf4SJsqFro+1MHYXTn3BjcGQJWrR/QrQ5Nsvvq3oKJl/0yEYck3JjlzY54mU8r9FUtUjGA94lbyVIibd2UZ4LPyDXpE8yACcpfFK6I0pRbOgCevZ63zvUMCZvzGV70CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWlyIXHI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714773617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qkMTmfCnwe1TLRVSdXDuN09++cK3MORgect0bHY89+U=;
	b=RWlyIXHIQrssGdyGc/NCLeCyr02EOWsrPfX5ynzv25YDpt2wr5DeWNx8b5CyM2oS4PNHhl
	9Du/i/TJCweS4s8WDqFXaixD8Nqnt4VAvWEPvs8JjHDDjE14Q2N7HEzc9zV9CWAsieKRqQ
	oQ4DsU4sNovMv6QurkE0ISeRn/EusB4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-y5z2dGuGM5GgwGPCaTHEqA-1; Fri, 03 May 2024 18:00:15 -0400
X-MC-Unique: y5z2dGuGM5GgwGPCaTHEqA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-43a2a23190cso1251021cf.2
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 15:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714773615; x=1715378415;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qkMTmfCnwe1TLRVSdXDuN09++cK3MORgect0bHY89+U=;
        b=UHuI2ntz/4zwrxQooDjbZ/HiwhKCqsXmnkxJYXsZe1FRPuRFMEbb6aKXAGxZQV5clY
         aPTv4+Cplbv/uNHNzm0H7kqpi0eB31AaUodUsUV7vppFUtn0x9CWLL/BqOtZohmrcIgB
         aXf8WGxIiBaOtAoSMWpIsNgdUXKGor7FhCm+zUU07s8VxHVSTfIDPNfhE4G6e7AR5kP+
         eLOAAzv//bAEMTYUa7PdBMuV2RS3JnEyJee+XaIfFcuJs4rpgykl42F05eV2bzrqz19R
         DNP3Xl5sW+R3oFdwhees6jduXtlRrBxBuVDpeyMv3p7QjXtuMCEkZd3gx+YtQlqKb3Hh
         8WjA==
X-Forwarded-Encrypted: i=1; AJvYcCU3phvFWlWbml54pvtv4XoALsrIwae/2In3WamgEA1TtmMX46zQieC7TSS0uFTUd6rW3lv2KhnjN55XT9iKi0KJsmL8
X-Gm-Message-State: AOJu0YycI/Vu8ZNXmok++cNKoczN6hFeKIJ4rng0GNSDDGGJmIVgb5Xr
	0IJj16GcFXPjV/xK8he+gHXo/OXonxKalWWS4RY0TyMhzVIn/zVmgTdE5D9XDSGJpNI/nZGaC/X
	r9mjgCq1eoZ6mUH1Gmzt+Phorvui9oh19ncseZ2wC67OYWAAOyA==
X-Received: by 2002:a05:622a:64a:b0:43a:c04c:e3d3 with SMTP id a10-20020a05622a064a00b0043ac04ce3d3mr4760587qtb.34.1714773614902;
        Fri, 03 May 2024 15:00:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtvMvUlssNS/lZYNWfxREqByMmGZElBz+i7SUORBFfOFK20m+exUSKpKGv8DylZ/jEex73aw==
X-Received: by 2002:a05:622a:64a:b0:43a:c04c:e3d3 with SMTP id a10-20020a05622a064a00b0043ac04ce3d3mr4760547qtb.34.1714773614409;
        Fri, 03 May 2024 15:00:14 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:4b0a:b7a4:5eb9:b8a9:508d])
        by smtp.gmail.com with ESMTPSA id cb6-20020a05622a1f8600b0043c7d293f9fsm1986488qtb.67.2024.05.03.15.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 15:00:11 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Fri,  3 May 2024 19:00:01 -0300
Message-ID: <ZjVeYVQm1iU-y7JF@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <ZjVXVc2e_V8NiMy3@google.com>
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com> <ZjUwHvyvkM3lj80Q@LeoBras> <ZjVXVc2e_V8NiMy3@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

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
> 


I think I understand what you propose here.

But I am not sure what would happen in this case:

- RT guest task calls short HLT
- Host schedule another kernel thread (other task)
- Timer interruption, rcu_pending will() check the task which is not set 
  with above flag.
- rcuc runs, introducing latency
- Goes back to previous kernel thread, finishes running with rcuc latency
- Goes back to vcpu thread

Isn't there any chance that, on an short guest HLT, the latency previously 
introduced by rcuc preempting another kernel thread gets to introduce a 
latency to the RT task running in the vcpu?

Thanks!
Leo



- 


