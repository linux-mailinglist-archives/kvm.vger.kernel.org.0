Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1AD66D139
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 23:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbjAPWBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 17:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbjAPWBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 17:01:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A6E252B0
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 14:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673906468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pKW7zCBLEA66mVcb3Cu7SCLLHnEA4pbfURAi0ynqeO8=;
        b=eICz3Q0k+9JeniZ0aFLPWJYVZUbtlOrtLCVHdaOz+/W+N0MLn/zgJwXEeXIdqDAGplwLv1
        ebt/dJ4VT0apowHCPiaywOq2nAY29VTviu7HT35zgW9fZVq8l8zm/NfUeS8wEz65wQd7dy
        3p0dGGHOslWiVh9ARVdoPe7ZVZ1+e48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-VktBD6VkPFe1XvOqPSP0-A-1; Mon, 16 Jan 2023 17:01:04 -0500
X-MC-Unique: VktBD6VkPFe1XvOqPSP0-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28AAE85CCEF;
        Mon, 16 Jan 2023 22:01:03 +0000 (UTC)
Received: from [10.22.18.0] (unknown [10.22.18.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A8192166B26;
        Mon, 16 Jan 2023 22:01:02 +0000 (UTC)
Message-ID: <ac5c75d4-5d21-68a5-a428-3ef449595836@redhat.com>
Date:   Mon, 16 Jan 2023 17:01:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency
 graph checks
Content-Language: en-US
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
 <20230113065955.815667-3-boqun.feng@gmail.com>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <20230113065955.815667-3-boqun.feng@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/23 01:59, Boqun Feng wrote:
> Although all flavors of RCU are annotated correctly with lockdep as
> recursive read locks, their 'check' parameter of lock_acquire() is
> unset. It means that RCU read locks are not added into the lockdep
> dependency graph therefore deadlock detection based on dependency graph
> won't catch deadlock caused by RCU. This is fine for "non-sleepable" RCU
> flavors since wait-context detection and other context based detection
> can catch these deadlocks. However for sleepable RCU, this is limited.
>
> Actually we can detect the deadlocks caused by SRCU by 1) making
> srcu_read_lock() a 'check'ed recursive read lock and 2) making
> synchronize_srcu() a empty write lock critical section. Even better,
> with the newly introduced lock_sync(), we can avoid false positives
> about irq-unsafe/safe. So do it.
>
> Note that NMI safe SRCU read side critical sections are currently not
> annonated, since step-by-step approach can help us deal with
> false-positives. These may be annotated in the future.
>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>   include/linux/srcu.h  | 23 +++++++++++++++++++++--
>   kernel/rcu/srcutiny.c |  2 ++
>   kernel/rcu/srcutree.c |  2 ++
>   3 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 9b9d0bbf1d3c..a1595f8c5155 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -102,6 +102,21 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
>   	return lock_is_held(&ssp->dep_map);
>   }
>   
> +static inline void srcu_lock_acquire(struct lockdep_map *map)
> +{
> +	lock_map_acquire_read(map);
> +}
> +
> +static inline void srcu_lock_release(struct lockdep_map *map)
> +{
> +	lock_map_release(map);
> +}
> +
> +static inline void srcu_lock_sync(struct lockdep_map *map)
> +{
> +	lock_map_sync(map);
> +}
> +
>   #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */

It would be nice if a comment is added to document the difference 
between the 2 sets of rcu_lock_* and srcu_lock_* functions. It is 
described in patch description, but it is not easy to figure that out 
just by looking at the source files.

Cheers,
Longman

