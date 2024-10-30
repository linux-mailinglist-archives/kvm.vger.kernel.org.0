Return-Path: <kvm+bounces-29984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E109B5894
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF711F221B6
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 00:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DEFB1758B;
	Wed, 30 Oct 2024 00:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfb0zGBM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C0BA4A;
	Wed, 30 Oct 2024 00:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730247913; cv=none; b=aUszdmrMX1R9/vnlcnD9sbmrimNC6PnKCgtokxAYraQgvr05YD4lgB6N0eNj65HXHyP69PWrg41ehWXy28VRGPm2r1YFz++ZARAf0hfjqr+wpe6ushRZcRLsNtqKl3Yn3xRyMuXPtezU5yT1A64nhANrUmHaDTflnw/1VOCky60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730247913; c=relaxed/simple;
	bh=BL5aCCiMZkStQF1EjG4B5SZBurDZGFe+Lr5aoIHpMtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gKLx+XA7Rqe8qGa0fO5tl/VusoU/gfmQ8V8LJIQOrfQKnm2vWPn65lNIGvhnIOykhI2MyzRfL3kba/hEN03UROwZIpr6mSfqb+WXwCs9GywPIhK1osyc0QLdhfUS8lpdZaCZv7WWRMhq9V1kacicaAP0tLLNvzC2UI8I0AF6nC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfb0zGBM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB69C4CECD;
	Wed, 30 Oct 2024 00:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730247913;
	bh=BL5aCCiMZkStQF1EjG4B5SZBurDZGFe+Lr5aoIHpMtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfb0zGBM67fO1txbsHlw983IPG6An+plrWb3yFCRhOG5gDWuoJCshyrvddiQxbAsr
	 JH7oWY/KAGQnul7987ngBeZAWVKH0MgP+2icl6P3DIVgyPzz5JTW28JFtr7XOxeY3J
	 3zFdoA7m/k27m6XtaGBrU9dnm88lHNd4/3DxWuYhImZ9V12NxKXfxnlN2uwCpernp+
	 1L3YfkFOw2RVgrx8xOhSjMwPH6E+tWzUJimYwkGQJmlfujYAbptCb/g3d0HuAfk+bU
	 H45DgiPZOUrcyF0LP+gPaK7+LmCNwd9IFt+TLIWQWEZoHxJAmc8RI9KhUKrNaEdMkX
	 r9aikwrP6G2Vg==
Date: Tue, 29 Oct 2024 14:25:11 -1000
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Luca Boccassi <bluca@debian.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	linux-kernel@vger.kernel.org
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
Message-ID: <ZyF858Ruj-jgdLLw@slm.duckdns.org>
References: <ZyAnSAw34jwWicJl@slm.duckdns.org>
 <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>

Hello, Paolo.

On Tue, Oct 29, 2024 at 11:59:43PM +0100, Paolo Bonzini wrote:
...
> For the freezing part, would this be anything more than
> 
> fdiff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d16ce8174ed6..b7b6a1c1b6a4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -47,6 +47,7 @@
>  #include <linux/kern_levels.h>
>  #include <linux/kstrtox.h>
>  #include <linux/kthread.h>
> +#include <linux/freezer.h>
>  #include <linux/wordpart.h>
>  #include <asm/page.h>
> @@ -7429,22 +7430,27 @@ static long get_nx_huge_page_recovery_timeout(u64 start_time)
>  static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
>  {
>  	u64 start_time;
> +	u64 end_time;
> +
> +	set_freezable();
>  	while (true) {
>  		start_time = get_jiffies_64();
> +		end_time = start_time + get_nx_huge_page_recovery_timeout(start_time);
> +		for (;;) {
>  			set_current_state(TASK_INTERRUPTIBLE);
> +			if (kthread_freezable_should_stop(NULL))
> +				break;
> +			start_time = get_jiffies_64();
> +			if ((s64)(end_time - start_time) <= 0)
> +				break;
> +			schedule_timeout(end_time - start_time);
>  		}
>  		set_current_state(TASK_RUNNING);
> +		if (kthread_freezable_should_stop(NULL))

So, this is the PM and cgroup1 freezer which traps tasks in a pretty opaque
state which is problematic when only a part of the system is frozen, so the
cgroup2 freezer is implemented in the signal delivery / trap path so that
they behave similar to e.g. SIGSTOP stops.

>  			return 0;
>  		kvm_recover_nx_huge_pages(kvm);
> 
> (untested beyond compilation).
> 
> I'm not sure if the KVM worker thread should process signals.  We want it
> to take the CPU time it uses from the guest, but otherwise it's not running
> on behalf of userspace in the way that io_wq_worker() is.

I see, so io_wq_worker()'s handle signals only partially. It sets
PF_USER_WORKER which ignores fatal signals, so the only signals which take
effect are STOP/CONT (and friends) which is handled in do_signal_stop()
which is also where the cgroup2 freezer is implemented.

Given that the kthreads are tied to user processes, I think it'd be better
to behave similarly to user tasks as possible in this regard if userspace
being able to stop/cont these kthreads are okay.

If that can't be done, we can add a mechanism to ignore these tasks when
determining when a cgroup is frozen provided that this doesn't affect the
snapshotting (ie. when taking a snapshot of frozen cgroup, activities from
the kthreads won't corrupt the snapshot).

Thanks.

-- 
tejun

