Return-Path: <kvm+bounces-18701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F508FA6D9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 02:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1316B251EC
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 00:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB19EC4;
	Tue,  4 Jun 2024 00:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9XptLrH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EDF63E
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 00:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460055; cv=none; b=A+AXJqze2OvP0JxMboiq39ozPmwKzbDv3qd1OOQ3qf/8Pn/Qri+VgghJm+b39Z6zDxuIacTDWCzIC473CtuQCRBDtuKicpupcIVCxOaIFNapz+9JwRGBxWmyJJjoB+ALVmbLrzmWej3E4K+Fa8uUw/TEk35r7ZxLgGTGzCC6UJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460055; c=relaxed/simple;
	bh=O7IEydvJikvy1VRybXHIgo7DsDUOiB9JWN05ebOrWWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IHP8cioBIyB5R+V7FFpJLJDHFmuLGMUHGmcQOXeE3UkFRHeYjT25Kc9CELt+x2C9HIcw1q4ehNC84ua3R29bZGv4wZacC/hSOETCumpxUBQH/fc9yo2rAXvLbtLXgAgPoaoin1FZUYHxkUl9B10Ef14GJuipbwGdDzyhOVTRkgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X9XptLrH; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62ca03fc1ceso21892627b3.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 17:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717460053; x=1718064853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ccoeN8AjVVO4XJ0biqZf4iXVDLjkh53CRVPkhtuV/k=;
        b=X9XptLrHrFkIYZlPmilaKLHsQBTqhE2zNUyKiRS7SGdFCM23kPCm4Uw5dXIpVPfCEZ
         fSN5hmksS1uFQjE7BuKMosCP4IjDp8C9+hgy7vNvgcOEgNmklLyQtwGUZVoqk+aZBS1M
         JGBQfj5fNkTZhI6aErI/y8ipLA2YIz+UfuZT0cmJUrHXwzB03JxwmKo4Co/BJE0f2Zd/
         k2aw5y8QhU3NspXOJYBvkXiJMPIiEmMqJoaz368d+QqwNGB/fL6UF3d2Uu6o+fWSGWoN
         Xe1AC0KQtHElahdWpR2dvIRm4kk1jLlr60c52BLcM6xHl10zkTmH4inlq18dlgemGB4w
         Kw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717460053; x=1718064853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ccoeN8AjVVO4XJ0biqZf4iXVDLjkh53CRVPkhtuV/k=;
        b=spZuvxyQquAvbx6qehbSVpzhFRNlrHkSpDWi7syfv3nZGGyUH3mSr9LaNeeNUx7xX3
         xHAmbp2EGIkjxPAKi1xMFobgQUi4IUq59w4kkL0jcFjzttREfjpKiAZvotxHoA9hk4Jp
         c6lS4lgwwvhfiMqjg5CeHJSIyTPkLHfdprB0frcCfgGi6xtGakH2YdUA6s29b0rGIwdC
         vpm5afyyM3BBvT6po/rBboEwjYBHLc6/bloujJZcHpnMkHPO3A3+ZxhwDgDUfhmLlKsX
         WU5mGw6IG3O3YnZd197yH/8VDjY45HbWuRMh+adw4vvyZaxVhguOI7kw68IXP3jFnkRq
         935A==
X-Gm-Message-State: AOJu0YwdsTW0JF8oaxvDUgSI8D4yiiXNw1YkyIDhbh5kVIVuLPXV+NeR
	7dhFCgK+DjoVn+BF1NHv7D5ESAKHTNudlruhT7L/WmkkzCYDGCxFgBLcl6Nbv4FOhGL6BJ3U/Ur
	ExA==
X-Google-Smtp-Source: AGHT+IEGlXU3eqZFi3/wWkMmZ6JRkzJxAr6p48aczYpJlaUe0U2DQ7zSm8aeZ4clwGvABR+Cj03lEkg+wUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3506:b0:627:a962:4252 with SMTP id
 00721157ae682-62c7983febcmr26991967b3.7.1717460053326; Mon, 03 Jun 2024
 17:14:13 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:14:11 -0700
In-Reply-To: <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com> <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
Message-ID: <Zl5cUwGiMrng2zcc@google.com>
Subject: Re: [PATCH 4/4] KVM: x86: Add vCPU stat for APICv interrupt
 injections causing #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 29, 2024, Alejandro Jimenez wrote:
> Even when APICv/AVIC is active, certain guest accesses to its local APIC(s)
> cannot be fully accelerated, and cause a #VMEXIT to allow the VMM to
> emulate the behavior and side effects. Expose a counter stat for these
> specific #VMEXIT types.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/avic.c         | 7 +++++++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 1 +
>  4 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e7e3213cefae..388979dfe9f3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1576,6 +1576,7 @@ struct kvm_vcpu_stat {
>  	u64 guest_mode;
>  	u64 notify_window_exits;
>  	u64 apicv_active;
> +	u64 apicv_unaccelerated_inj;

The stat name doesn't match the changelog or the code.  The AVIC updates in
avic_incomplete_ipi_interception() are unaccelerated _injection_, they're
unaccelarated _delivery_.  And in those cases, the fact that delivery wasn't
accelerated is relatively uninteresting in most cases.

And avic_unaccelerated_access_interception() and handle_apic_write() don't
necessarily have anything to do with injection.

On the flip side, the slow paths for {svm,vmx}_deliver_interrupt() are very
explicitly unnaccelerated injection.

It's not entirely clear from the changelog what the end goal of this stat is.
A singular stat for all APICv/AVIC access VM-Exits seems uninteresting, as such
a stat essentially just captures that the guest is active.  Maaaybe someone could
glean info from comparing two VMs, but even that is dubious.  E.g. if a guest is
doing something function and generating a lot of avic_incomplete_ipi_interception()
exits, those will likely be in the noise due to the total volume of other AVIC
exits.

>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..274041d3cf66 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -517,6 +517,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  			kvm_apic_write_nodecode(vcpu, APIC_ICR);
>  		else
>  			kvm_apic_send_ipi(apic, icrl, icrh);
> +
> +		++vcpu->stat.apicv_unaccelerated_inj;
>  		break;
>  	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
>  		/*
> @@ -525,6 +527,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  		 * vcpus. So, we just need to kick the appropriate vcpu.
>  		 */
>  		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
> +
> +		++vcpu->stat.apicv_unaccelerated_inj;
>  		break;
>  	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>  		WARN_ONCE(1, "Invalid backing page\n");
> @@ -704,6 +708,9 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
>  					    trap, write, vector);
> +
> +	++vcpu->stat.apicv_unaccelerated_inj;
> +
>  	if (trap) {
>  		/* Handling Trap */
>  		WARN_ONCE(!write, "svm: Handling trap read.\n");
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f10b5f8f364b..a7487f12ded1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5657,6 +5657,8 @@ static int handle_apic_write(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>  
> +	++vcpu->stat.apicv_unaccelerated_inj;
> +
>  	/*
>  	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
>  	 * hardware has done any necessary aliasing, offset adjustments, etc...
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 03cb933920cb..c8730b0fac87 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -307,6 +307,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>  	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>  	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
> +	STATS_DESC_COUNTER(VCPU, apicv_unaccelerated_inj),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {
> -- 
> 2.39.3
> 

