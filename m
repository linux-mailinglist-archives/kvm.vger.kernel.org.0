Return-Path: <kvm+bounces-24346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4509E9540AF
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 06:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BBC0B23E25
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 04:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35F077F1B;
	Fri, 16 Aug 2024 04:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B501cIFm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA7F5473E
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 04:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723783168; cv=none; b=RQL+TMnj7F+sIR2kR+Lf19C9totxiHxUU9SKEvh6h3MgaC8fI1Ye5Yg7xBbXcEOywJFyDaKTp5j7E7k85nY4jLGxMHprRRqe6w7dn3cuWIhtuXVZPUIjxgN9IfWT+DkwWNsoVuOlHNM/GQJq3p1n/U6UmW+HIkMU6qjRRzsFji4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723783168; c=relaxed/simple;
	bh=jkzhmQKn7XYyW0C0gZXQ/3NIgsh1oKFUjJqKpmGuogA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hggLMmE0+pJ+/Ub6IFPsPPc9KjsKdTlYNIafGXwhyf/EkDvubrDcNcTO6X5jbESJ/jPP9YjXeiT9cKTxJx66l8qjb6th8btzJ1Sz50w4GSwy4PcTT3kiLjBvZHj6p1mOP0CbLTeADIU84TYBvOzuInKXO942kzU9PygjqxT0aO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B501cIFm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7126ca1ece1so1629928b3a.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 21:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723783166; x=1724387966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CxB8IjvtfNFRK51HWQpqUx2HPfNSyPccG/vdlRbXbSY=;
        b=B501cIFm64I9eT+4tWg2y+S39oMKDnYi5nmkurU0PTbBYd2XCkkIgdxv3RLedfUfo/
         +7xgS58CU7gqC1113Tg19IB0nFVFAjutS4mzQZNlsVlb2Gq4WzQbhLbcMwVw2geHMm+U
         +Sov4s5q4wamF66XKbpPUnpj/aiInhCNdHUxtCWHv+giXAkdU9JFU4PFtFAsArg+Pnvt
         UmSv7yUSqOOqj63d4pge8U9g0IutFiVK07+YSbCiolXm9G7JYzdskMDjCdLNMX3Symyq
         M3ooCo+S2gO1+a7iyNhS8eatVWgX5N5hegK+RjD+FNYbh1Cr55MVSqiJ609A9ZVU6gwQ
         w9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723783166; x=1724387966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxB8IjvtfNFRK51HWQpqUx2HPfNSyPccG/vdlRbXbSY=;
        b=t05nDVwsMYs/K1SEWk93r35cwCHwFdKpBRyVdcijPDtV/zZUzSNMY0LmFk2XFS1ftl
         8CwbeiImcl9shqox+TU9jZCznlHnETOK7mmxPAza7Z62XaQooha7bFtlgaeZ3Wvo4EAF
         YKpMhPxawYrjQwECQ3vldkUZdC3GqYXF66pFatbg+od4FnnL+A2cwdLXYE7NwZaeqO+o
         jf6TxN6EopgR4ffsUh1eX9W9NhIF8hxgZYz2shzahiAMfgbditeA0BwRwWLtXAjyn4bV
         KE6jv9m+vHL/TTsQUDJSker3KxyFJo7LBunDH0WsEp2YdSKx7P4MLvv5OMrU9I2bGpPd
         DUbg==
X-Gm-Message-State: AOJu0YziI0EMXvfbzfDtjhKCQrd/ygA+4n/ZFpHpnKkKRKBAO6hQeGkU
	Ya97r9Vb4Xq+hU3+/09Mw/jQa6XOEWA5IN20VKSvFSuZRXpEmx9pMkzRm6K50GfNiBVmL28/Y0D
	LBQ==
X-Google-Smtp-Source: AGHT+IGr4Z+Fxm7myQgGTOIhZd1m3ThN1Gd+rjKJxjeXpNRzSiJaIUCW523d23clEbi0TvrgR6OnBEdw+PA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9450:b0:710:4e5c:967d with SMTP id
 d2e1a72fcca58-713c5b645c4mr54968b3a.0.1723783165500; Thu, 15 Aug 2024
 21:39:25 -0700 (PDT)
Date: Thu, 15 Aug 2024 21:39:23 -0700
In-Reply-To: <20240522001817.619072-21-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-21-dwmw2@infradead.org>
Message-ID: <Zr7X-5qK8sRXxyDP@google.com>
Subject: Re: [RFC PATCH v3 20/21] KVM: x86/xen: Prevent runstate times from
 becoming negative
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When kvm_xen_update_runstate() is invoked to set a vCPU's runstate, the
> time spent in the previous runstate is accounted. This is based on the
> delta between the current KVM clock time, and the previous value stored
> in vcpu->arch.xen.runstate_entry_time.
> 
> If the KVM clock goes backwards, that delta will be negative. Or, since
> it's an unsigned 64-bit integer, very *large*. Linux guests deal with
> that particularly badly, reporting 100% steal time for ever more (well,
> for *centuries* at least, until the delta has been consumed).
> 
> So when a negative delta is detected, just refrain from updating the
> runstates until the KVM clock catches up with runstate_entry_time again.
> 
> The userspace APIs for setting the runstate times do not allow them to
> be set past the current KVM clock, but userspace can still adjust the
> KVM clock *after* setting the runstate times, which would cause this
> situation to occur.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/xen.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 014048c22652..3d4111de4472 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -538,24 +538,34 @@ void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
>  {
>  	struct kvm_vcpu_xen *vx = &v->arch.xen;
>  	u64 now = get_kvmclock_ns(v->kvm);
> -	u64 delta_ns = now - vx->runstate_entry_time;
>  	u64 run_delay = current->sched_info.run_delay;
> +	s64 delta_ns = now - vx->runstate_entry_time;
> +	s64 steal_ns = run_delay - vx->last_steal;
>  
>  	if (unlikely(!vx->runstate_entry_time))
>  		vx->current_runstate = RUNSTATE_offline;
>  
> +	vx->last_steal = run_delay;
> +
> +	/*
> +	 * If KVM clock time went backwards, stop updating until it
> +	 * catches up (or the runstates are reset by userspace).
> +	 */

I take it this is a legitimate scenario where userpace sets KVM clock and then
the runstates, and KVM needs to lend a hand because userspace can't do those two
things atomically?

> +	if (delta_ns < 0)
> +		return;
> +
>  	/*
>  	 * Time waiting for the scheduler isn't "stolen" if the
>  	 * vCPU wasn't running anyway.
>  	 */
> -	if (vx->current_runstate == RUNSTATE_running) {
> -		u64 steal_ns = run_delay - vx->last_steal;
> +	if (vx->current_runstate == RUNSTATE_running && steal_ns > 0) {
> +		if (steal_ns > delta_ns)
> +			steal_ns = delta_ns;
>  
>  		delta_ns -= steal_ns;
>  
>  		vx->runstate_times[RUNSTATE_runnable] += steal_ns;
>  	}
> -	vx->last_steal = run_delay;
>  
>  	vx->runstate_times[vx->current_runstate] += delta_ns;
>  	vx->current_runstate = state;
> -- 
> 2.44.0
> 

