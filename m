Return-Path: <kvm+bounces-66976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A60AECF0995
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 05:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2E7230155FB
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 04:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015C4280033;
	Sun,  4 Jan 2026 04:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="nF4j9irY"
X-Original-To: kvm@vger.kernel.org
Received: from r3-24.sinamail.sina.com.cn (r3-24.sinamail.sina.com.cn [202.108.3.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E7D18DB35
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 04:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767500692; cv=none; b=US9d2z3rxqlClozbKNnUkeQ4mYkkFjZ3FC81/macgdfI5w1iNbuc6g3zUMxDjdT0k7TAvxyAXr/4nbEigdfCPnTGF1ENyb7Gf8dlymkxsGm4E60XuLLJKhtXxIq1zsWlhiYj5u685VHrx/Skm/K9G3JNWP0saEC9EW7ITnCwznE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767500692; c=relaxed/simple;
	bh=OK/WPYwWrVKlcRorPhuJ65nPxNrq5wx3wOHqrXF08NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USPr0UVSYu30bH739DN+TMb+slfkYzpoyQ5wft5GvK/oqb+oUKgbD4n+SEc80qU1VmUT3A1c+8LsqoePZzaQYvGoda5H65QlHU1vPWT5sA6jfZ26Fmg6GXzbMv3Ny2eYXU+TqmZpS5DkDQXMa6DYJVJmewgZ0CrICwUIhtUut50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=nF4j9irY; arc=none smtp.client-ip=202.108.3.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767500686;
	bh=U0ogmGsROkK7SdrhjnDjiDrRhFMjLh2c01njNVOPXjU=;
	h=From:Subject:Date:Message-ID;
	b=nF4j9irYEkZyEcELYF4PSHeXYGmqBpkLJHUbPlKJW4NUCG/NMdLjzBP34DWxnsV7K
	 vrOk0Jo1/OkySBTHTHccAcCP+czI821si0CQ+qDNVbdKp121+A8AOshNp7vBY2f32w
	 sSS/mUfTF8RXaRf2+4Dof4Hr+gYm+rRzaiMT7BAA=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.31) with ESMTP
	id 6959E80500003A64; Sun, 4 Jan 2026 12:09:43 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 3720196816273
X-SMAIL-UIID: C517F5C6778747118466FBC437C605EE-20260104-120943-1
From: Hillf Danton <hdanton@sina.com>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v2 2/9] sched/fair: Add rate-limiting and validation helpers
Date: Sun,  4 Jan 2026 12:09:34 +0800
Message-ID: <20260104040936.1912-1-hdanton@sina.com>
In-Reply-To: <20251219035334.39790-3-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Wanpeng 

On Fri, 19 Dec 2025 11:53:26 +0800
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Implement core safety mechanisms for yield deboost operations.
> 
> Add yield_deboost_rate_limit() for high-frequency gating to prevent
> excessive overhead on compute-intensive workloads. The 6ms threshold
> balances responsiveness with overhead reduction.
> 
> Add yield_deboost_validate_tasks() for comprehensive validation ensuring
> both tasks are valid and distinct, both belong to fair_sched_class,
> target is on the same runqueue, and tasks are runnable.
> 
Given IPI in subsequent pacthes, why is same rq required?

> The rate limiter prevents pathological high-frequency cases while
> validation ensures only appropriate task pairs proceed. Both functions
> are static and will be integrated in subsequent patches.
> 
> v1 -> v2:
> - Remove unnecessary READ_ONCE/WRITE_ONCE for per-rq fields accessed
>   under rq->lock
> - Change rq->clock to rq_clock(rq) helper for consistency
> - Change yield_deboost_rate_limit() signature from (rq, now_ns) to (rq),
>   obtaining time internally via rq_clock()
> - Remove redundant sched_class check for p_yielding (already implied by
>   rq->donor being fair)
> - Simplify task_rq check to only verify p_target
> - Change rq->curr to rq->donor for correct EEVDF donor tracking
> - Move sysctl_sched_vcpu_debooster_enabled and NULL checks to caller
>   (yield_to_deboost) for early exit before update_rq_clock()
> - Simplify function signature by returning p_yielding directly instead
>   of using output pointer parameters
> - Add documentation explaining the 6ms rate limit threshold
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  kernel/sched/fair.c | 62 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 87c30db2c853..2f327882bf4d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -9040,6 +9040,68 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev, struct t
>  	}
>  }
>  
> +/*
> + * Rate-limit yield deboost operations to prevent excessive overhead.
> + * Returns true if the operation should be skipped due to rate limiting.
> + *
> + * The 6ms threshold balances responsiveness with overhead reduction:
> + * - Short enough to allow timely yield boosting for lock contention
> + * - Long enough to prevent pathological high-frequency penalty application
> + *
> + * Called under rq->lock, so direct field access is safe.
> + */
> +static bool yield_deboost_rate_limit(struct rq *rq)
> +{
> +	u64 now = rq_clock(rq);
> +	u64 last = rq->yield_deboost_last_time_ns;
> +
> +	if (last && (now - last) <= 6 * NSEC_PER_MSEC)
> +		return true;
> +
> +	rq->yield_deboost_last_time_ns = now;
> +	return false;
> +}
> +
> +/*
> + * Validate tasks for yield deboost operation.
> + * Returns the yielding task on success, NULL on validation failure.
> + *
> + * Checks: feature enabled, valid target, same runqueue, target is fair class,
> + * both on_rq. Called under rq->lock.
> + *
> + * Note: p_yielding (rq->donor) is guaranteed to be fair class by the caller
> + * (yield_to_task_fair is only called when curr->sched_class == p->sched_class).
> + */
> +static struct task_struct __maybe_unused *
> +yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target)
> +{
> +	struct task_struct *p_yielding;
> +
> +	if (!sysctl_sched_vcpu_debooster_enabled)
> +		return NULL;
> +
> +	if (!p_target)
> +		return NULL;
> +
> +	if (yield_deboost_rate_limit(rq))
> +		return NULL;
> +
> +	p_yielding = rq->donor;
> +	if (!p_yielding || p_yielding == p_target)
> +		return NULL;
> +
> +	if (p_target->sched_class != &fair_sched_class)
> +		return NULL;
> +
> +	if (task_rq(p_target) != rq)
> +		return NULL;
> +
> +	if (!p_target->se.on_rq || !p_yielding->se.on_rq)
> +		return NULL;
> +
> +	return p_yielding;
> +}
> +
>  /*
>   * sched_yield() is very simple
>   */
> -- 
> 2.43.0

