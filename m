Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D474666D3D5
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbjAQBhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbjAQBhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:37:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6DB23D90
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673919399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OaLWp1o2d67rAK4VOTZ3mI0wZ9vtLhQhgbJPLb7b6EE=;
        b=SpqjEp1MGUEwl6rme3+lPu54wrqeB7i2nsVr61i0elq4o+5Qt3O+CtPCfltzK6z9mRiDxJ
        Sv0LkdQnr+IURMTlzUl1qL4wlqPG84/3KoDMt4cIP/Pb0K1vXf1jEOLwRjImG3FQftCHk/
        cTeG7A46aDyzxsHgGG+XS0fl0WMiNMQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-CRqzrvs_P5CSQm69KHxHAA-1; Mon, 16 Jan 2023 20:36:35 -0500
X-MC-Unique: CRqzrvs_P5CSQm69KHxHAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 311FD3C0DDD1;
        Tue, 17 Jan 2023 01:36:34 +0000 (UTC)
Received: from [10.22.18.0] (unknown [10.22.18.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 520A653AA;
        Tue, 17 Jan 2023 01:36:33 +0000 (UTC)
Message-ID: <5375c559-8c67-3cef-11a9-abeecb75a09f@redhat.com>
Date:   Mon, 16 Jan 2023 20:36:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 4/3] locking/lockdep: Improve the deadlock scenario print
 for sync and read lock
Content-Language: en-US
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113235722.1226525-1-boqun.feng@gmail.com>
 <221e35b8-88f5-5fc5-6961-6a8ce060a97b@redhat.com>
 <Y8XRNdrW3t1jvpMF@boqun-archlinux>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <Y8XRNdrW3t1jvpMF@boqun-archlinux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/23 17:35, Boqun Feng wrote:
> On Mon, Jan 16, 2023 at 05:21:09PM -0500, Waiman Long wrote:
>> On 1/13/23 18:57, Boqun Feng wrote:
>>> Lock scenario print is always a weak spot of lockdep splats. Improvement
>>> can be made if we rework the dependency search and the error printing.
>>>
>>> However without touching the graph search, we can improve a little for
>>> the circular deadlock case, since we have the to-be-added lock
>>> dependency, and know whether these two locks are read/write/sync.
>>>
>>> In order to know whether a held_lock is sync or not, a bit was
>>> "stolen" from ->references, which reduce our limit for the same lock
>>> class nesting from 2^12 to 2^11, and it should still be good enough.
>>>
>>> Besides, since we now have bit in held_lock for sync, we don't need the
>>> "hardirqoffs being 1" trick, and also we can avoid the __lock_release()
>>> if we jump out of __lock_acquire() before the held_lock stored.
>>>
>>> With these changes, a deadlock case evolved with read lock and sync gets
>>> a better print-out from:
>>>
>>> 	[...]  Possible unsafe locking scenario:
>>> 	[...]
>>> 	[...]        CPU0                    CPU1
>>> 	[...]        ----                    ----
>>> 	[...]   lock(srcuA);
>>> 	[...]                                lock(srcuB);
>>> 	[...]                                lock(srcuA);
>>> 	[...]   lock(srcuB);
>>>
>>> to
>>>
>>> 	[...]  Possible unsafe locking scenario:
>>> 	[...]
>>> 	[...]        CPU0                    CPU1
>>> 	[...]        ----                    ----
>>> 	[...]   rlock(srcuA);
>>> 	[...]                                lock(srcuB);
>>> 	[...]                                lock(srcuA);
>>> 	[...]   sync(srcuB);
>>>
>>> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
>>> ---
>>>    include/linux/lockdep.h  |  3 ++-
>>>    kernel/locking/lockdep.c | 48 ++++++++++++++++++++++++++--------------
>>>    2 files changed, 34 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
>>> index ba09df6a0872..febd7ecc225c 100644
>>> --- a/include/linux/lockdep.h
>>> +++ b/include/linux/lockdep.h
>>> @@ -134,7 +134,8 @@ struct held_lock {
>>>    	unsigned int read:2;        /* see lock_acquire() comment */
>>>    	unsigned int check:1;       /* see lock_acquire() comment */
>>>    	unsigned int hardirqs_off:1;
>>> -	unsigned int references:12;					/* 32 bits */
>>> +	unsigned int sync:1;
>>> +	unsigned int references:11;					/* 32 bits */
>>>    	unsigned int pin_count;
>>>    };
>>> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
>>> index cffa026a765f..4031d87f6829 100644
>>> --- a/kernel/locking/lockdep.c
>>> +++ b/kernel/locking/lockdep.c
>>> @@ -1880,6 +1880,8 @@ print_circular_lock_scenario(struct held_lock *src,
>>>    	struct lock_class *source = hlock_class(src);
>>>    	struct lock_class *target = hlock_class(tgt);
>>>    	struct lock_class *parent = prt->class;
>>> +	int src_read = src->read;
>>> +	int tgt_read = tgt->read;
>>>    	/*
>>>    	 * A direct locking problem where unsafe_class lock is taken
>>> @@ -1907,7 +1909,10 @@ print_circular_lock_scenario(struct held_lock *src,
>>>    	printk(" Possible unsafe locking scenario:\n\n");
>>>    	printk("       CPU0                    CPU1\n");
>>>    	printk("       ----                    ----\n");
>>> -	printk("  lock(");
>>> +	if (tgt_read != 0)
>>> +		printk("  rlock(");
>>> +	else
>>> +		printk("  lock(");
>>>    	__print_lock_name(target);
>>>    	printk(KERN_CONT ");\n");
>>>    	printk("                               lock(");
>>> @@ -1916,7 +1921,12 @@ print_circular_lock_scenario(struct held_lock *src,
>>>    	printk("                               lock(");
>>>    	__print_lock_name(target);
>>>    	printk(KERN_CONT ");\n");
>>> -	printk("  lock(");
>>> +	if (src_read != 0)
>>> +		printk("  rlock(");
>>> +	else if (src->sync)
>>> +		printk("  sync(");
>>> +	else
>>> +		printk("  lock(");
>>>    	__print_lock_name(source);
>>>    	printk(KERN_CONT ");\n");
>>>    	printk("\n *** DEADLOCK ***\n\n");
>> src can be sync() but not the target. Is there a reason why that is the
>> case?
>>
> The functions annotated by sync() don't create real critical sections,
> so no lock dependency can be created from a sync(), for example:
>
> 	synchronize_srcu(A);
> 	mutex_lock(B);
>
> no dependency from A to B. In the scenario case, if we see a dependency
> target -> source, the target cannot be a lock_sync(). I will add better
> documentation later.
Right, the dependency won't happen since you reduce lock_sync() to 
mostly do validate_chain() without actually storing it in the lock chain 
which I did miss in my initial review. Without that, a dependency may 
happen if an NMI happens between lock_acquire() and lock_release() in 
lock_sync().
>>> @@ -4530,7 +4540,13 @@ mark_usage(struct task_struct *curr, struct held_lock *hlock, int check)
>>>    					return 0;
>>>    		}
>>>    	}
>>> -	if (!hlock->hardirqs_off) {
>>> +
>>> +	/*
>>> +	 * For lock_sync(), don't mark the ENABLED usage, since lock_sync()
>>> +	 * creates no critical section and no extra dependency can be introduced
>>> +	 * by interrupts
>>> +	 */
>>> +	if (!hlock->hardirqs_off && !hlock->sync) {
>>>    		if (hlock->read) {
>>>    			if (!mark_lock(curr, hlock,
>>>    					LOCK_ENABLED_HARDIRQ_READ))
>>> @@ -4909,7 +4925,7 @@ static int __lock_is_held(const struct lockdep_map *lock, int read);
>>>    static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>>>    			  int trylock, int read, int check, int hardirqs_off,
>>>    			  struct lockdep_map *nest_lock, unsigned long ip,
>>> -			  int references, int pin_count)
>>> +			  int references, int pin_count, int sync)
>>>    {
>>>    	struct task_struct *curr = current;
>>>    	struct lock_class *class = NULL;
>>> @@ -4960,7 +4976,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>>>    	class_idx = class - lock_classes;
>>> -	if (depth) { /* we're holding locks */
>>> +	if (depth && !sync) {
>>> +		/* we're holding locks and the new held lock is not a sync */
>>>    		hlock = curr->held_locks + depth - 1;
>>>    		if (hlock->class_idx == class_idx && nest_lock) {
>>>    			if (!references)
>>> @@ -4994,6 +5011,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>>>    	hlock->trylock = trylock;
>>>    	hlock->read = read;
>>>    	hlock->check = check;
>>> +	hlock->sync = !!sync;
>>>    	hlock->hardirqs_off = !!hardirqs_off;
>>>    	hlock->references = references;
>>>    #ifdef CONFIG_LOCK_STAT
>>> @@ -5055,6 +5073,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>>>    	if (!validate_chain(curr, hlock, chain_head, chain_key))
>>>    		return 0;
>>> +	/* For lock_sync(), we are done here since no actual critical section */
>>> +	if (hlock->sync)
>>> +		return 1;
>>> +
>>>    	curr->curr_chain_key = chain_key;
>>>    	curr->lockdep_depth++;
>>>    	check_chain_key(curr);
>> Even with sync, there is still a corresponding lock_acquire() and
>> lock_release(), you can't exit here without increasing lockdep_depth. That
>> can cause underflow.
>>
> I actually remove the __lock_release() in lock_sync() in this patch, so
> I think it's OK. But I must admit the whole submission is to give David
> something to see whether the output is an improvement, so I probably
> should separate the output changes and the lock_sync() internall into
> two patches (and the later can also be folded into the introduction
> patch).

I saw that now. You may not need to separate it into 2 patches since 
there is some dependency between the two. You do have to document the 2 
different changes in your patch description.

Cheers,
Longman

