Return-Path: <kvm+bounces-1984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F317EFDD1
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 06:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C3911F23942
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 05:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125A3DDAD;
	Sat, 18 Nov 2023 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="BsTnY1nE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80F410D5
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 21:14:38 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cc329ce84cso23945805ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 21:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1700284478; x=1700889278; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=clpaUzNSF9Y0euKE8HoT2iNeGOFsJJ2CPhGb7WB9NWY=;
        b=BsTnY1nEzmKWiPCM+jxUY0lWMAwVTwUSBET17EHcLSQzcvzCcOE/2SuxBXwe9N18S0
         SOTV5DBinDPjhx3Ut2IVhTGxeUlC/sbjKKPOaMON+bqxDZEj8qFr/K/Sp+i8sz/p6CyO
         ibkKAUWvoagsNN9NaxPDOpO6bPd9H4Hm1ptEtcpxrJc0TnsrzWer0cfNYwSRSrfElqlD
         /aM5TUadBK76O7fxAjGc+FqvuHNk6yrSXsJMYkuycmdOHxYvItC8fITNlSx7rD1R9r9g
         4fXT6J0JWDKroENXS4t4VmsuJaOOjweWDO0IOFiwvG4HS+bPGTWN0r5U00tUcISok5G9
         qu9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700284478; x=1700889278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clpaUzNSF9Y0euKE8HoT2iNeGOFsJJ2CPhGb7WB9NWY=;
        b=p6x8Bn3AhEWoqu2uTGyrQWkSfm48bkPXzfkl6ZJhmjHn4b/YbR0YV1Dx6dd2f954A4
         Wh4yyMN29PAzjTmU7YNEqLC0NFTXuciLhM4F+ch4aH+AMTzhmHhBIb/etnLvLwr8SGu8
         57xAOZb/RwArc6Y22sQgDwiXXOrjdZnePbTMZQExA+a5mIZa4YFaAhbkeiSKhsZlkoiP
         E/HkgaEpgJeIfrZlxkMYRU9ybQLw1q4Zz5XioCOgCDuYNBFffUESxIYoynzb9OzfYOde
         DvIVbnsi5lptnxes2tItMmq7HW1GgCecZibo+55qZYZqDFBsfSJSHDDJgS3MqMDQrPgu
         aOqA==
X-Gm-Message-State: AOJu0YxBViBxBXzF0BT6YTeidj+BHbWBhwjGNPxhtW22Q2QbC3lXxkpc
	sumjIPnDKYt2ijnj/v/djJCT9g==
X-Google-Smtp-Source: AGHT+IH+WryRLNe/R1V4RIlPH4bOFnaXQppN9drDViTVHC5Ye2XTJrkIRTbF7/e5t4ucDzSjgCBwhg==
X-Received: by 2002:a17:903:41cb:b0:1cc:5691:5113 with SMTP id u11-20020a17090341cb00b001cc56915113mr2229960ple.26.1700284478075;
        Fri, 17 Nov 2023 21:14:38 -0800 (PST)
Received: from [10.254.46.51] ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id e19-20020a170902ed9300b001c61921d4d2sm2214306plj.302.2023.11.17.21.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 21:14:37 -0800 (PST)
Message-ID: <2c7509e3-6db0-461e-991b-026553157dbe@bytedance.com>
Date: Sat, 18 Nov 2023 13:14:32 +0800
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
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/23 5:23 PM, Peter Zijlstra Wrote:
> 
> Your email is pretty badly mangled by wrapping, please try and
> reconfigure your MUA, esp. the trace and debug output is unreadable.
> 
> On Thu, Nov 16, 2023 at 07:58:18PM +0100, Tobias Huschle wrote:
> 
>> The base scenario are two KVM guests running on an s390 LPAR. One guest
>> hosts the uperf server, one the uperf client.
>> With EEVDF we observe a regression of ~50% for a strburst test.
>> For a more detailed description of the setup see the section TEST SUMMARY at
>> the bottom.
> 
> Well, that's not good :/
> 
>> Short summary:
>> The mentioned kworker has been scheduled to CPU 14 before the tracing was
>> enabled.
>> A vhost process is migrated onto CPU 14.
>> The vruntimes of kworker and vhost differ significantly (86642125805 vs
>> 4242563284 -> factor 20)
> 
> So bear with me, I know absolutely nothing about virt stuff. I suspect
> there's cgroups involved because shiny or something.
> 
> kworkers are typically not in cgroups and are part of the root cgroup,
> but what's a vhost and where does it live?
> 
> Also, what are their weights / nice values?
> 
>> The vhost process wants to wake up the kworker, therefore the kworker is
>> placed onto the runqueue again and set to runnable.
>> The vhost process continues to execute, waking up other vhost processes on
>> other CPUs.
>>
>> So far this behavior is not different to what we see on pre-EEVDF kernels.
>>
>> On timestamp 576.162767, the vhost process triggers the last wake up of
>> another vhost on another CPU.
>> Until timestamp 576.171155, we see no other activity. Now, the vhost process
>> ends its time slice.
>> Then, vhost gets re-assigned new time slices 4 times and gets then migrated
>> off to CPU 15.
> 
> So why does this vhost stay on the CPU if it doesn't have anything to
> do? (I've not tried to make sense of the trace, that's just too
> painful).
> 
>> This does not occur with older kernels.
>> The kworker has to wait for the migration to happen in order to be able to
>> execute again.
>> This is due to the fact, that the vruntime of the kworker is significantly
>> larger than the one of vhost.
> 
> That's, weird. Can you add a trace_printk() to update_entity_lag() and
> have it print out the lag, limit and vlag (post clamping) values? And
> also in place_entity() for the reverse process, lag pre and post scaling
> or something.
> 
> After confirming both tasks are indeed in the same cgroup ofcourse,
> because if they're not, vruntime will be meaningless to compare and we
> should look elsewhere.
> 
> Also, what HZ and what preemption mode are you running? If kworker is
> somehow vastly over-shooting it's slice -- keeps running way past the
> avg_vruntime, then it will build up a giant lag and you get what you
> describe, next time it wakes up it gets placed far to the right (exactly
> where it was when it 'finally' went to sleep, relatively speaking).
> 
>> We found some options which sound plausible but we are not sure if they are
>> valid or not:
>>
>> 1. The wake up path has a dependency on the vruntime metrics that now delays
>> the execution of the kworker.
>> 2. The previous commit af4cf40470c2 (sched/fair: Add cfs_rq::avg_vruntime)
>> which updates the way cfs_rq->min_vruntime and
>>      cfs_rq->avg_runtime are set might have introduced an issue which is
>> uncovered with the commit mentioned above.
> 
> Suppose you have a few tasks (of equal weight) on you virtual timeline
> like so:
> 
>     ---------+---+---+---+---+------
>              ^       ^
> 	    |       `avg_vruntime
> 	    `-min_vruntime
> 
> Then the above would be more or less the relative placements of these
> values. avg_vruntime is the weighted average of the various vruntimes
> and is therefore always in the 'middle' of the tasks, and not somewhere
> out-there.
> 
> min_vruntime is a monotonically increasing 'minimum' that's left-ish on
> the tree (there's a few cases where a new task can be placed left of
> min_vruntime and its no longer actuall the minimum, but whatever).
> 
> These values should be relatively close to one another, depending
> ofcourse on the spread of the tasks. So I don't think this is causing
> trouble.
> 
> Anyway, the big difference with lag based placement is that where
> previously tasks (that do not migrate) retain their old vruntime and on
> placing they get pulled forward to at least min_vruntime, so a task that
> wildly overshoots, but then doesn't run for significant time can still
> be overtaken and then when placed again be 'okay'.
> 
> Now OTOH, with lag-based placement,  we strictly preserve their relative
> offset vs avg_vruntime. So if they were *far* too the right when they go
> to sleep, they will again be there on placement.

Hi Peter, I'm a little confused here. As we adopt placement strategy #1
when PLACE_LAG is enabled, the lag of that entity needs to be preserved.
Given that the weight doesn't change, we have:

	vl' = vl

But in fact it is scaled on placement:

	vl' = vl * W/(W + w)

Does this intended? And to illustrate my understanding of strategy #1:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 07f555857698..a24ef8b297ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5131,7 +5131,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
  	 *
  	 * EEVDF: placement strategy #1 / #2
  	 */
-	if (sched_feat(PLACE_LAG) && cfs_rq->nr_running) {
+	if (sched_feat(PLACE_LAG) && cfs_rq->nr_running && se->vlag) {
  		struct sched_entity *curr = cfs_rq->curr;
  		unsigned long load;
  
@@ -5150,7 +5150,10 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
  		 * To avoid the 'w_i' term all over the place, we only track
  		 * the virtual lag:
  		 *
-		 *   vl_i = V - v_i <=> v_i = V - vl_i
+		 *   vl_i = V' - v_i <=> v_i = V' - vl_i
+		 *
+		 * Where V' is the new weighted average after placing this
+		 * entity, and v_i is its newly assigned vruntime.
  		 *
  		 * And we take V to be the weighted average of all v:
  		 *
@@ -5162,41 +5165,17 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
  		 * vl_i is given by:
  		 *
  		 *   V' = (\Sum w_j*v_j + w_i*v_i) / (W + w_i)
-		 *      = (W*V + w_i*(V - vl_i)) / (W + w_i)
-		 *      = (W*V + w_i*V - w_i*vl_i) / (W + w_i)
-		 *      = (V*(W + w_i) - w_i*l) / (W + w_i)
-		 *      = V - w_i*vl_i / (W + w_i)
-		 *
-		 * And the actual lag after adding an entity with vl_i is:
-		 *
-		 *   vl'_i = V' - v_i
-		 *         = V - w_i*vl_i / (W + w_i) - (V - vl_i)
-		 *         = vl_i - w_i*vl_i / (W + w_i)
-		 *
-		 * Which is strictly less than vl_i. So in order to preserve lag
-		 * we should inflate the lag before placement such that the
-		 * effective lag after placement comes out right.
-		 *
-		 * As such, invert the above relation for vl'_i to get the vl_i
-		 * we need to use such that the lag after placement is the lag
-		 * we computed before dequeue.
+		 *      = (W*V + w_i*(V' - vl_i)) / (W + w_i)
+		 *      = V - w_i*vl_i / W
  		 *
-		 *   vl'_i = vl_i - w_i*vl_i / (W + w_i)
-		 *         = ((W + w_i)*vl_i - w_i*vl_i) / (W + w_i)
-		 *
-		 *   (W + w_i)*vl'_i = (W + w_i)*vl_i - w_i*vl_i
-		 *                   = W*vl_i
-		 *
-		 *   vl_i = (W + w_i)*vl'_i / W
  		 */
  		load = cfs_rq->avg_load;
  		if (curr && curr->on_rq)
  			load += scale_load_down(curr->load.weight);
-
-		lag *= load + scale_load_down(se->load.weight);
  		if (WARN_ON_ONCE(!load))
  			load = 1;
-		lag = div_s64(lag, load);
+
+		vruntime -= div_s64(lag * scale_load_down(se->load.weight), load);
  	}
  
  	se->vruntime = vruntime - lag;

