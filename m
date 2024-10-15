Return-Path: <kvm+bounces-28928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C6199F42F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 509CCB2342F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C3E1FAEF2;
	Tue, 15 Oct 2024 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="nJn8gjEc"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F91AF0CF;
	Tue, 15 Oct 2024 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013750; cv=none; b=k6mMo3LEywrdk9OANKTfHyMTUvAH4d2UulvWGHgexD1D7QxgvOq82gwVZL2r+lOGtXr9fDn8SygnQCxOQnWyacvJidt1aEpP1+fOPbVJtOUgHsBJJjGjsRvoKKcBgnHztZbf7BAQgocflXPnZMgaavbg9C3SOYXxU6+L8W+DnWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013750; c=relaxed/simple;
	bh=cWMHCrc2KGBoFiC6OYY7D7UPHuPq4qD8qiR/FJ6zDqs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mFf7YSRTsN/CYshhB6FRocCLjCpmD6IIQrlyUzA5LabjEfoE12VbK98Xz5+YKLdrCCQL3ZP9Jx9zrC6IwmmD8xmf/tcrUmyUDHaagzkQnPeXKmdgMERdhZ0nT1jcm2Ktg2jO0TyaeCpQC4tQFEqIlIBseZa3BAGONS5OzkMVo5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=nJn8gjEc; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729010576;
	bh=cWMHCrc2KGBoFiC6OYY7D7UPHuPq4qD8qiR/FJ6zDqs=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=nJn8gjEcns9QtZPWujGYoego966NtFG+DQFIQmKyMGAnUW9JBTjiSf6sWR7RZEI7L
	 3LUdyIhNuC9lB2N7aGxIMWS+CCddJ7e5CU/e0udwPcRcjF9/lot+WiEMQrkq6b3/Aq
	 7SvA05+7Mywk3mkqiZkazpb4pqkVDYLbVbwdDfNc=
Received: by gentwo.org (Postfix, from userid 1003)
	id 3F7834040C; Tue, 15 Oct 2024 09:42:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 3D9DA400C9;
	Tue, 15 Oct 2024 09:42:56 -0700 (PDT)
Date: Tue, 15 Oct 2024 09:42:56 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org, 
    kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <Zw5aPAuVi5sxdN5-@arm.com>
Message-ID: <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 15 Oct 2024, Catalin Marinas wrote:

> > +			unsigned int loop_count = 0;
> >  			if (local_clock_noinstr() - time_start > limit) {
> >  				dev->poll_time_limit = true;
> >  				break;
> >  			}
> > +
> > +			smp_cond_load_relaxed(&current_thread_info()->flags,
> > +					      VAL & _TIF_NEED_RESCHED ||
> > +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
>
> The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
> never set. With the event stream enabled on arm64, the WFE will
> eventually be woken up, loop_count incremented and the condition would
> become true. However, the smp_cond_load_relaxed() semantics require that
> a different agent updates the variable being waited on, not the waiting
> CPU updating it itself. Also note that the event stream can be disabled
> on arm64 on the kernel command line.


Setting of need_resched() from another processor involves sending an IPI
after that was set. I dont think we need to smp_cond_load_relaxed since
the IPI will cause an event. For ARM a WFE would be sufficient.


