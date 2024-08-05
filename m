Return-Path: <kvm+bounces-23294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D774B948694
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 02:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14A551C2103D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3870F4A29;
	Tue,  6 Aug 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="To+la7S5"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078F210E5;
	Tue,  6 Aug 2024 00:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722903517; cv=none; b=qcW2XZcnBdmTLbKpFSDu1gClQaKrg+u2lFGPPCypooB1tlz+EHvoMuEAfyzaxZHb+LIL6Njq/9s2nqe++VH+VkZGy3jX8MY/CFCiZ/46IwY7LpgXAQ0BxonoVzM4mCOhErXRLGbMWXVqg5MrsMTkXQaYESkn9wQ5etDo5KsEBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722903517; c=relaxed/simple;
	bh=AIwVlVYhRNiZJnUeGonomBvXhSHWG/wfktvdWfWGQd4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qRjl7CVTJl8R8IdqOZBcWaZYhVixWMcwnaEQyMoQqqJ2N4LM5O+0kP/Pb0c/YQJ4A2cYbUcRc5uw7e7kQ64tw7fqud5/74RJg6bqwlM6S9dwjvtD1eqc/Hsp2JQjAL6k8zMwf7O5axVwS5f7IDAR3uee63TyPNRN8VqrX9+lDmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=To+la7S5; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1722899240;
	bh=AIwVlVYhRNiZJnUeGonomBvXhSHWG/wfktvdWfWGQd4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=To+la7S5p3eu3qmBjPe5pgJ9FVxctQOu0NnZMHOmM2eDjMDtN8VMPuGKganesl+D/
	 1MGkpzzXp7rtfuVSht+sKxomEGi3/whNNTcoXZlK1HxJBI1bagsB5bhD5ISXJJx8cu
	 ct/oG6XWQBZNB4drdnS38OhUZoiD8PyEbKscMPt8=
Received: by gentwo.org (Postfix, from userid 1003)
	id 5284E4035B; Mon,  5 Aug 2024 16:07:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 50FD3401CA;
	Mon,  5 Aug 2024 16:07:20 -0700 (PDT)
Date: Mon, 5 Aug 2024 16:07:20 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com, 
    boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 01/10] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <20240726201332.626395-2-ankur.a.arora@oracle.com>
Message-ID: <29534bd1-1628-e0fb-eb81-6b789133ff43@gentwo.org>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com> <20240726201332.626395-2-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 26 Jul 2024, Ankur Arora wrote:

> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..532e4ed19e0f 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>
> 	raw_local_irq_enable();
> 	if (!current_set_polling_and_test()) {
> -		unsigned int loop_count = 0;
> +		unsigned int loop_count;
> 		u64 limit;

loop_count is only used in the while loop below. So the declaration 
could be placed below the while.

>
> 		limit = cpuidle_poll_time(drv, dev);
>
> 		while (!need_resched()) {
> -			cpu_relax();
> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -				continue;
> -
> 			loop_count = 0;
> 			if (local_clock_noinstr() - time_start > limit) {
> 				dev->poll_time_limit = true;
> 				break;
> 			}

Looks ok otherwise

Reviewed-by: Christoph Lameter <cl@linux.com>


