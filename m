Return-Path: <kvm+bounces-28382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8952998044
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1600282C6E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB1B1C8FAE;
	Thu, 10 Oct 2024 08:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rbNLfl2D"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A549919D897;
	Thu, 10 Oct 2024 08:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548405; cv=none; b=GGy6Vm5MHB3dd886JqifZa2JC2OChanktkbn759jVfD2p1KDS2qFbGuCmQnJ7UZhLTaPOy7UbxBeLwT1bKWho32pzrbD6z/0h83UJMHPmsPZ+sxnwoo5eiSieYXdJ6RlvsXZFGtY5rmdsEMiPZMoUR43jcEfz2/cO6DhigReEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548405; c=relaxed/simple;
	bh=Kh4pC2gW77oAory+0E+bMQuBssQIjFby+oZm9f8dySA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlqUh8SlaEgBrncFqZ2e+qgMqJolf9xWjrp4lh5zidSbeMHR9UZUhjr4pSK3x4JrjmJRrSpYULArNaa8dg01/nSIygMJEDk7waf+Arcw2isY9mL3+CHytlMZHkr0iBdSxvP7efxHAnKXvJ4nRP3msFk0DWFIKWeeOklPd+UorD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rbNLfl2D; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S7JopktVQ56uroxkTqkDMSUntgLmGZrlqgt298BI620=; b=rbNLfl2DahlRkbsb8ALDgwMOM2
	1RXBim7IH+5dDRZz4l6qS3IbxuzxSM+pyYvldF7HuNZJwykJKF2kQLeSmUE+J+B5RPh2i06bopnLn
	XaYPucMnDqOwF6WkB+ESiYEttLLbwREdi0eFe3a/UTe8vwhHuGSO2Jl+9ufOK2MThOWNBIbVYAAEs
	Nt/eHV5pkDX+VV0MA5waAEu3obGBlzCpwI4n41xXTQWrqPEGacH5W6TwYMpaTOSCrtfkoPWSbwAsi
	RU5E2xW1p+3ahT9dGbl+Ly+WMy3WKDzuvhkLgmhAAeAlCeVvoeNPe8z8nnwb4qhfx0enTkF4KmC6u
	PIE/t/cA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1syoOb-00000005F3g-1Brf;
	Thu, 10 Oct 2024 08:19:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E7CFF30088D; Thu, 10 Oct 2024 10:19:40 +0200 (CEST)
Date: Thu, 10 Oct 2024 10:19:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org,
	kprateek.nayak@amd.com, wuyun.abel@bytedance.com,
	youssefesmat@chromium.org, tglx@linutronix.de, efault@gmx.de,
	kvm@vger.kernel.org
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
Message-ID: <20241010081940.GC17263@noisy.programming.kicks-ass.net>
References: <20240727102732.960974693@infradead.org>
 <20240727105030.226163742@infradead.org>
 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
 <ZwdA0sbA2tJA3IKh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwdA0sbA2tJA3IKh@google.com>

On Wed, Oct 09, 2024 at 07:49:54PM -0700, Sean Christopherson wrote:

> TL;DR: Code that checks task_struct.on_rq may be broken by this commit.

Correct, and while I did look at quite a few, I did miss KVM used it,
damn.

> Peter,
> 
> Any thoughts on how best to handle this?  The below hack-a-fix resolves the issue,
> but it's obviously not appropriate.  KVM uses vcpu->preempted for more than just
> posted interrupts, so KVM needs equivalent functionality to current->on-rq as it
> was before this commit.
> 
> @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
>  
>         WRITE_ONCE(vcpu->scheduled_out, true);
>  
> -       if (current->on_rq && vcpu->wants_to_run) {
> +       if (se_runnable(&current->se) && vcpu->wants_to_run) {
>                 WRITE_ONCE(vcpu->preempted, true);
>                 WRITE_ONCE(vcpu->ready, true);
>         }

se_runnable() isn't quite right, but yes, a helper along those lines is
probably best. Let me try and grep more to see if there's others I
missed as well :/

