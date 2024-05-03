Return-Path: <kvm+bounces-16543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B9E8BB5B8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C9171C22DCD
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D2A5644F;
	Fri,  3 May 2024 21:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DdxW38AY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D04F88C
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714771800; cv=none; b=Gy93q+2DMepT10su5N2FjHZzRgGeEvKHMkibuH4RXEGSaNWfNsZFBDqHHGYS+OsHq80j7ONv4wKdgdr/dxOJIUCVb+uHbozfPhEzuXNOLirkMSZshouasP6GLAPJz4CX6osuN8np5KFLOcohns2dgQ/qQBVn9hht2Xf/WJYxpQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714771800; c=relaxed/simple;
	bh=EQL3IeOBP2Bu3dDlMxHDHIr3MtiCwMbPHUudi15G5QY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jUVrsgXbZPvzqD23SXQY2ij/1+wCw6aQ6ymUXH28dPWwaWdox4q2Dms/H5QzifMvDLPRGUvRZukLVlz+5XHmYO4kkaYUp1jGJAroi7H6tzi1C0h+pTpHhd0It1yiCQev7EHJKp0bW5DvwqsPYUHeiFjdn27itII6fr8kHjieeyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DdxW38AY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b2c438d031so162086a91.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714771799; x=1715376599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNr9lZmsjOzqzGs7i+GBj2/4wYllIMuY8anx349EdT0=;
        b=DdxW38AYZ4c9t5T6ft/zwfIdQQBEngxmtBJsZei+Ux8Y8kjJRgGUq46Wa7AbpuomB3
         aHveA0IQ+/ta5QwTefzZSjS6po6YK/Lcy6nrVRkbqbv5uD/acTYTKIEQrL9GhW+7YhVa
         GqRoXL3vSA+3NKPGEsAqKmMUdFr0Jj3u3DdO6RIpzOdcBBb3S0zy6hVq5pIgPANfObei
         TjoA1tFqNYRc/CZUfLHLZgWUlZoidlm0VWwzqN6qOeLmD9ZURZst7xr5pJ4+dKtK9a33
         omjMKM/hcWLU1C/uilp9BAP4Kg9u+FAX1e+3VwwAuZ9hv7wi/I4kEHNZnZrXCPjcMDwM
         NVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714771799; x=1715376599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNr9lZmsjOzqzGs7i+GBj2/4wYllIMuY8anx349EdT0=;
        b=in247+zpqwhzAHuT6fuuf1ENka6PcBUbgASy1vt9hKaxOQf/DLb9e/dAfk7YhSlr6P
         bDQbnOYwpdApEBVw1oUarTyH9CnFnG/iXy7wubKwZM0YiPqJwjALe8RjMl86qannay5K
         0xymnOkh4bLjOzyOi2l71mYCSbW62lYN3ZuaJKA7oCMN6P4XQEdNTGyhpR47NHFnmmi7
         NnZKOqLLOCf/QKqc/27VPRkw9J3AeAZli4PAsX6KrneznvU9Dvf1nk/PT0Msi0ubffdr
         idzJdiV9ATIiKRXf2u/Xo6eaByXQh2S+cU+eTqvf05Bw3gpBjee1xplaqkfK+QOIKqH0
         HFjg==
X-Forwarded-Encrypted: i=1; AJvYcCV/HlCdh5Dp5vjk/1i5Sdq4AIY3uOEpLeCft4Q2audu5O/jcxjGySG0mb2bnx41SkB9Ke0WfABySZZuxjz5mlBgADZ9
X-Gm-Message-State: AOJu0YwDittB9uPGTZn+QWu4FMtOlq7OZsmXWu/oQkceipDMvgdxvBcH
	ntigRk/n6TFm4sLRmfeGpmIp5uvPUwARgkNnrmhIIVFUrYVf++9zpXGIldIx345JrzCNO54FWtK
	QOg==
X-Google-Smtp-Source: AGHT+IF9Vxd2NYDOkdG6bdDYRHr51xqBZdk7NhC734vEBMcRNr/FlI1t8PmITviB5QPPFCtj8eIQae1ddMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:db55:b0:2b2:9773:edab with SMTP id
 u21-20020a17090adb5500b002b29773edabmr10552pjx.0.1714771798574; Fri, 03 May
 2024 14:29:58 -0700 (PDT)
Date: Fri, 3 May 2024 14:29:57 -0700
In-Reply-To: <ZjUwHvyvkM3lj80Q@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras>
Message-ID: <ZjVXVc2e_V8NiMy3@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 03, 2024, Leonardo Bras wrote:
> > KVM can provide that information with much better precision, e.g. KVM
> > knows when when it's in the core vCPU run loop.
> 
> That would not be enough.
> I need to present the application/problem to make a point:
> 
> - There is multiple  isolated physical CPU (nohz_full) on which we want to 
>   run KVM_RT vcpus, which will be running a real-time (low latency) task.
> - This task should not miss deadlines (RT), so we test the VM to make sure 
>   the maximum latency on a long run does not exceed the latency requirement
> - This vcpu will run on SCHED_FIFO, but has to run on lower priority than
>   rcuc, so we can avoid stalling other cpus.
> - There may be some scenarios where the vcpu will go back to userspace
>   (from KVM_RUN ioctl), and that does not mean it's good to interrupt the 
>   this to run other stuff (like rcuc).
>
> Now, I understand it will cover most of our issues if we have a context 
> tracking around the vcpu_run loop, since we can use that to decide not to 
> run rcuc on the cpu if the interruption hapenned inside the loop.
> 
> But IIUC we can have a thread that "just got out of the loop" getting 
> interrupted by the timer, and asked to run rcu_core which will be bad for 
> latency.
> 
> I understand that the chance may be statistically low, but happening once 
> may be enough to crush the latency numbers.
> 
> Now, I can't think on a place to put this context trackers in kvm code that 
> would avoid the chance of rcuc running improperly, that's why the suggested 
> timeout, even though its ugly.
> 
> About the false-positive, IIUC we could reduce it if we reset the per-cpu 
> last_guest_exit on kvm_put.

Which then opens up the window that you're trying to avoid (IRQ arriving just
after the vCPU is put, before the CPU exits to userspace).

If you want the "entry to guest is imminent" status to be preserved across an exit
to userspace, then it seems liek the flag really should be a property of the task,
not a property of the physical CPU.  Similar to how rcu_is_cpu_rrupt_from_idle()
detects that an idle task was interrupted, that goal is to detect if a vCPU task
was interrupted.

PF_VCPU is already "taken" for similar tracking, but if we want to track "this
task will soon enter an extended quiescent state", I don't see any reason to make
it specific to vCPU tasks.  Unless the kernel/KVM dynamically manages the flag,
which as above will create windows for false negatives, the kernel needs to
trust userspace to a certaine extent no matter what.  E.g. even if KVM sets a
PF_xxx flag on the first KVM_RUN, nothing would prevent userspace from calling
into KVM to get KVM to set the flag, and then doing something else entirely with
the task.

So if we're comfortable relying on the 1 second timeout to guard against a
misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
userspace communicate to the kernel that it's a real-time task that spends the
overwhelming majority of its time in userspace or guest context, i.e. should be
given extra leniency with respect to rcuc if the task happens to be interrupted
while it's in kernel context.

