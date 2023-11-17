Return-Path: <kvm+bounces-1955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F057EF378
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 14:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42A651F28AFD
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B800321B8;
	Fri, 17 Nov 2023 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Q+2mo0fS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606111989
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:08:02 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5c2066accc5so294637a12.3
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 05:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1700226481; x=1700831281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d9fdCxWyHirIf75E8ne+77U4HI/4T7vekYV9npqdJ2s=;
        b=Q+2mo0fS/WnFTIEOaUwWzeukaBfD/GNJgzuXcz7DVeqXrZsngozfAbxWtjBjpd8qZu
         rrEZ/KS3npRjRhk7YGnZt2P7wD175G/NEiFEIz9+D0Gda8mSsrBxQKjrE3gQAC+mMThs
         KOu0wJjhQyBGfcDv5GLQ0U3qDHkb1fzesiIjVp0Zjeg0F/TJOWfsDLzA5Vg6X0D2PNY1
         mzNil6EeJvm5o9wLy24oANbWiLlWhtgv09tcdn7GmQEUXRnpsEQYkJd6hN2xxS7YKPkN
         ozudVog0ohNgT5XxKgBVLAJ0MwoPS0N7tr/DJ40IgnN4L8OsEF32XCyPX3vMKgO/rxfR
         +y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700226481; x=1700831281;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9fdCxWyHirIf75E8ne+77U4HI/4T7vekYV9npqdJ2s=;
        b=frFxezHa1Z6KJ5JdFpVd4//tPLbEZxCIwOeHQnPE3H1socRGafTMuZCAHfi92IhvnD
         Il+ny/u/HO/LXq5s8U7vy/tjWcUgQoMIjO3cvabYhBDbVj87TS07IyiBa8luS/Q3tE+2
         7YXdmNXHs6Tcz2QwWR3PadGtOIlzHXXTReAfT3O0XjPBl1/xDavjJTmGkGjfJTmw7ytq
         CT0cpIK1kR8tjciwr+IkiOnQHqJn2S6aNxpe+Hp6c4Kyqd4qtKis6k4eKEeC8tmFsXlJ
         DdYuXjFNoSQ+26aBpMpJ1ZpZsPZSZNKKG2oOHSDeSCpx89HXsNr4CxykLf7U36Oo5u/p
         1PBw==
X-Gm-Message-State: AOJu0YyqgqmWtkyx3rWhy30FVePp0VkvBHriW+yjnQCPXk/SQQsIDEqw
	v2543xMRSyOFwYb2xtFVvXyTGl3jykFSZLEIM3k=
X-Google-Smtp-Source: AGHT+IHv3bjAyGwReXBeWwfu4ee84yUM0tRIPUR3mRnPcXCX/nhgkHOlVIJ/4G1aznUdKoi/6ZQhuQ==
X-Received: by 2002:a17:90b:3a87:b0:279:1367:b9a3 with SMTP id om7-20020a17090b3a8700b002791367b9a3mr17276460pjb.4.1700226481568;
        Fri, 17 Nov 2023 05:08:01 -0800 (PST)
Received: from [10.254.46.51] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b0028017a2a8fasm1488628pjl.3.2023.11.17.05.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 05:08:01 -0800 (PST)
Message-ID: <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
Date: Fri, 17 Nov 2023 21:07:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair:
 Add lag based placement)
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>,
 Tobias Huschle <huschle@linux.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org, mst@redhat.com,
 jasowang@redhat.com
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <20231117123759.GP8262@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/23 8:37 PM, Peter Zijlstra Wrote:
> On Fri, Nov 17, 2023 at 01:24:21PM +0100, Tobias Huschle wrote:
>> On Fri, Nov 17, 2023 at 10:23:18AM +0100, Peter Zijlstra wrote:
> 
>>> kworkers are typically not in cgroups and are part of the root cgroup,
>>> but what's a vhost and where does it live?
>>
>> The qemu instances of the two KVM guests are placed into cgroups.
>> The vhosts run within the context of these qemu instances (4 threads per guest).
>> So they are also put into those cgroups.
>>
>> I'll answer the other questions you brought up as well, but I guess that one
>> is most critical:
>>
>>>
>>> After confirming both tasks are indeed in the same cgroup ofcourse,
>>> because if they're not, vruntime will be meaningless to compare and we
>>> should look elsewhere.
>>
>> In that case we probably have to go with elsewhere ... which is good to know.
> 
> Ah, so if this is a cgroup issue, it might be worth trying this patch
> that we have in tip/sched/urgent.

And please also apply this fix:
https://lore.kernel.org/all/20231117080106.12890-1-s921975628@gmail.com/

> 
> I'll try and read the rest of the email a little later, gotta run
> errands first.
> 
> ---
> 
> commit eab03c23c2a162085b13200d7942fc5a00b5ccc8
> Author: Abel Wu <wuyun.abel@bytedance.com>
> Date:   Tue Nov 7 17:05:07 2023 +0800
> 
>      sched/eevdf: Fix vruntime adjustment on reweight
>      
>      vruntime of the (on_rq && !0-lag) entity needs to be adjusted when
>      it gets re-weighted, and the calculations can be simplified based
>      on the fact that re-weight won't change the w-average of all the
>      entities. Please check the proofs in comments.
>      
>      But adjusting vruntime can also cause position change in RB-tree
>      hence require re-queue to fix up which might be costly. This might
>      be avoided by deferring adjustment to the time the entity actually
>      leaves tree (dequeue/pick), but that will negatively affect task
>      selection and probably not good enough either.
>      
>      Fixes: 147f3efaa241 ("sched/fair: Implement an EEVDF-like scheduling policy")
>      Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>      Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>      Link: https://lkml.kernel.org/r/20231107090510.71322-2-wuyun.abel@bytedance.com
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2048138ce54b..025d90925bf6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3666,41 +3666,140 @@ static inline void
>   dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
>   #endif
>   
> +static void reweight_eevdf(struct cfs_rq *cfs_rq, struct sched_entity *se,
> +			   unsigned long weight)
> +{
> +	unsigned long old_weight = se->load.weight;
> +	u64 avruntime = avg_vruntime(cfs_rq);
> +	s64 vlag, vslice;
> +
> +	/*
> +	 * VRUNTIME
> +	 * ========
> +	 *
> +	 * COROLLARY #1: The virtual runtime of the entity needs to be
> +	 * adjusted if re-weight at !0-lag point.
> +	 *
> +	 * Proof: For contradiction assume this is not true, so we can
> +	 * re-weight without changing vruntime at !0-lag point.
> +	 *
> +	 *             Weight	VRuntime   Avg-VRuntime
> +	 *     before    w          v            V
> +	 *      after    w'         v'           V'
> +	 *
> +	 * Since lag needs to be preserved through re-weight:
> +	 *
> +	 *	lag = (V - v)*w = (V'- v')*w', where v = v'
> +	 *	==>	V' = (V - v)*w/w' + v		(1)
> +	 *
> +	 * Let W be the total weight of the entities before reweight,
> +	 * since V' is the new weighted average of entities:
> +	 *
> +	 *	V' = (WV + w'v - wv) / (W + w' - w)	(2)
> +	 *
> +	 * by using (1) & (2) we obtain:
> +	 *
> +	 *	(WV + w'v - wv) / (W + w' - w) = (V - v)*w/w' + v
> +	 *	==> (WV-Wv+Wv+w'v-wv)/(W+w'-w) = (V - v)*w/w' + v
> +	 *	==> (WV - Wv)/(W + w' - w) + v = (V - v)*w/w' + v
> +	 *	==>	(V - v)*W/(W + w' - w) = (V - v)*w/w' (3)
> +	 *
> +	 * Since we are doing at !0-lag point which means V != v, we
> +	 * can simplify (3):
> +	 *
> +	 *	==>	W / (W + w' - w) = w / w'
> +	 *	==>	Ww' = Ww + ww' - ww
> +	 *	==>	W * (w' - w) = w * (w' - w)
> +	 *	==>	W = w	(re-weight indicates w' != w)
> +	 *
> +	 * So the cfs_rq contains only one entity, hence vruntime of
> +	 * the entity @v should always equal to the cfs_rq's weighted
> +	 * average vruntime @V, which means we will always re-weight
> +	 * at 0-lag point, thus breach assumption. Proof completed.
> +	 *
> +	 *
> +	 * COROLLARY #2: Re-weight does NOT affect weighted average
> +	 * vruntime of all the entities.
> +	 *
> +	 * Proof: According to corollary #1, Eq. (1) should be:
> +	 *
> +	 *	(V - v)*w = (V' - v')*w'
> +	 *	==>    v' = V' - (V - v)*w/w'		(4)
> +	 *
> +	 * According to the weighted average formula, we have:
> +	 *
> +	 *	V' = (WV - wv + w'v') / (W - w + w')
> +	 *	   = (WV - wv + w'(V' - (V - v)w/w')) / (W - w + w')
> +	 *	   = (WV - wv + w'V' - Vw + wv) / (W - w + w')
> +	 *	   = (WV + w'V' - Vw) / (W - w + w')
> +	 *
> +	 *	==>  V'*(W - w + w') = WV + w'V' - Vw
> +	 *	==>	V' * (W - w) = (W - w) * V	(5)
> +	 *
> +	 * If the entity is the only one in the cfs_rq, then reweight
> +	 * always occurs at 0-lag point, so V won't change. Or else
> +	 * there are other entities, hence W != w, then Eq. (5) turns
> +	 * into V' = V. So V won't change in either case, proof done.
> +	 *
> +	 *
> +	 * So according to corollary #1 & #2, the effect of re-weight
> +	 * on vruntime should be:
> +	 *
> +	 *	v' = V' - (V - v) * w / w'		(4)
> +	 *	   = V  - (V - v) * w / w'
> +	 *	   = V  - vl * w / w'
> +	 *	   = V  - vl'
> +	 */
> +	if (avruntime != se->vruntime) {
> +		vlag = (s64)(avruntime - se->vruntime);
> +		vlag = div_s64(vlag * old_weight, weight);
> +		se->vruntime = avruntime - vlag;
> +	}
> +
> +	/*
> +	 * DEADLINE
> +	 * ========
> +	 *
> +	 * When the weight changes, the virtual time slope changes and
> +	 * we should adjust the relative virtual deadline accordingly.
> +	 *
> +	 *	d' = v' + (d - v)*w/w'
> +	 *	   = V' - (V - v)*w/w' + (d - v)*w/w'
> +	 *	   = V  - (V - v)*w/w' + (d - v)*w/w'
> +	 *	   = V  + (d - V)*w/w'
> +	 */
> +	vslice = (s64)(se->deadline - avruntime);
> +	vslice = div_s64(vslice * old_weight, weight);
> +	se->deadline = avruntime + vslice;
> +}
> +
>   static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>   			    unsigned long weight)
>   {
> -	unsigned long old_weight = se->load.weight;
> +	bool curr = cfs_rq->curr == se;
>   
>   	if (se->on_rq) {
>   		/* commit outstanding execution time */
> -		if (cfs_rq->curr == se)
> +		if (curr)
>   			update_curr(cfs_rq);
>   		else
> -			avg_vruntime_sub(cfs_rq, se);
> +			__dequeue_entity(cfs_rq, se);
>   		update_load_sub(&cfs_rq->load, se->load.weight);
>   	}
>   	dequeue_load_avg(cfs_rq, se);
>   
> -	update_load_set(&se->load, weight);
> -
>   	if (!se->on_rq) {
>   		/*
>   		 * Because we keep se->vlag = V - v_i, while: lag_i = w_i*(V - v_i),
>   		 * we need to scale se->vlag when w_i changes.
>   		 */
> -		se->vlag = div_s64(se->vlag * old_weight, weight);
> +		se->vlag = div_s64(se->vlag * se->load.weight, weight);
>   	} else {
> -		s64 deadline = se->deadline - se->vruntime;
> -		/*
> -		 * When the weight changes, the virtual time slope changes and
> -		 * we should adjust the relative virtual deadline accordingly.
> -		 */
> -		deadline = div_s64(deadline * old_weight, weight);
> -		se->deadline = se->vruntime + deadline;
> -		if (se != cfs_rq->curr)
> -			min_deadline_cb_propagate(&se->run_node, NULL);
> +		reweight_eevdf(cfs_rq, se, weight);
>   	}
>   
> +	update_load_set(&se->load, weight);
> +
>   #ifdef CONFIG_SMP
>   	do {
>   		u32 divider = get_pelt_divider(&se->avg);
> @@ -3712,8 +3811,17 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
>   	enqueue_load_avg(cfs_rq, se);
>   	if (se->on_rq) {
>   		update_load_add(&cfs_rq->load, se->load.weight);
> -		if (cfs_rq->curr != se)
> -			avg_vruntime_add(cfs_rq, se);
> +		if (!curr) {
> +			/*
> +			 * The entity's vruntime has been adjusted, so let's check
> +			 * whether the rq-wide min_vruntime needs updated too. Since
> +			 * the calculations above require stable min_vruntime rather
> +			 * than up-to-date one, we do the update at the end of the
> +			 * reweight process.
> +			 */
> +			__enqueue_entity(cfs_rq, se);
> +			update_min_vruntime(cfs_rq);
> +		}
>   	}
>   }
>   
> @@ -3857,14 +3965,11 @@ static void update_cfs_group(struct sched_entity *se)
>   
>   #ifndef CONFIG_SMP
>   	shares = READ_ONCE(gcfs_rq->tg->shares);
> -
> -	if (likely(se->load.weight == shares))
> -		return;
>   #else
> -	shares   = calc_group_shares(gcfs_rq);
> +	shares = calc_group_shares(gcfs_rq);
>   #endif
> -
> -	reweight_entity(cfs_rq_of(se), se, shares);
> +	if (unlikely(se->load.weight != shares))
> +		reweight_entity(cfs_rq_of(se), se, shares);
>   }
>   
>   #else /* CONFIG_FAIR_GROUP_SCHED */

