Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7067C76BE96
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 22:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjHAUk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjHAUk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 16:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC5919A1
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 13:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690922382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHYSwcovOuMESUTA5bYv/hl0ljd1OC0AxmWQtxJBqmI=;
        b=GvwUSETQH6NgZZiHyc616jNtNMiSG1u6VuH0NQBc9qsN/SyyL+8v1Tv0lzGgLFOCahTQfJ
        GmVq3pedCQJou6kak7iNkmcyDLv/CIzIUnAYt05s4vxwP/zbRQbekelFmbVt2CRhimE96g
        0+ylHLogeiD/m2NoOXLkbaNC2GoNiQs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-Q03bl8M2MLG9KaQTjM7zVA-1; Tue, 01 Aug 2023 16:39:41 -0400
X-MC-Unique: Q03bl8M2MLG9KaQTjM7zVA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3492ef8860cso12458615ab.2
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 13:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690922380; x=1691527180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EHYSwcovOuMESUTA5bYv/hl0ljd1OC0AxmWQtxJBqmI=;
        b=QNkLbgqBJRXNCOXBq+2MM8v/yqytO/OLYeDmki74N1GSjbNZRUu3kPb/wVOaGFJShG
         /ixqBzQfNZJWY7ensai1xr+wM3J6nHJ/viz4NliJE2K7y6p86d6z7XXTiH0N7yQ2Q19v
         +owFsOfAsgJzbQpxDuyxefqjDlPZzpqZsQOYySxqKv7Pl6N3Pud2ttcDQmAtQejURKde
         WdxOJm7LtXU2Nwk2ayO9O2I9t/SMT5r7YTjht6EgEt+To+mpinzz2X6ciwQ8CitblK4g
         wdIurVoRITaip3KDqish3Y5Bew51DFIPyftz/hQgtDBXHvuALLG2R5cy3cvpMibDEEuy
         5HBg==
X-Gm-Message-State: ABy/qLbLomXVuyd53/as6HoCxJm3uQIY60pn6BeMa6OONdOx8oYXkm3r
        YB4k0F9dU07URiRoTJkCf9+m62oI2+txhVVZKKtHqDo10d+R+hx0pVwvFsM/lc59N6doKWDtjJJ
        vQ8+IJ/fIUzwg
X-Received: by 2002:a05:6e02:20ee:b0:349:191:af05 with SMTP id q14-20020a056e0220ee00b003490191af05mr15049951ilv.16.1690922380422;
        Tue, 01 Aug 2023 13:39:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGOUJASa/jIwgyvXrMdyby51VeIncwaGCEDOw9ZUoeasaw0H4nD5GdMoGeqi4XG3CIBY8DLXA==
X-Received: by 2002:a05:6e02:20ee:b0:349:191:af05 with SMTP id q14-20020a056e0220ee00b003490191af05mr15049938ilv.16.1690922380121;
        Tue, 01 Aug 2023 13:39:40 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id o7-20020a02cc27000000b0042b1cd4c096sm3887565jap.74.2023.08.01.13.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 13:39:39 -0700 (PDT)
Date:   Tue, 1 Aug 2023 14:39:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: irqbypass: Convert producers/consumers single
 linked list to XArray
Message-ID: <20230801143938.3d27a199.alex.williamson@redhat.com>
In-Reply-To: <20230801115646.33990-1-likexu@tencent.com>
References: <20230801115646.33990-1-likexu@tencent.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  1 Aug 2023 19:56:46 +0800
Like Xu <like.xu.linux@gmail.com> wrote:

> From: Like Xu <likexu@tencent.com>
> 
> Replace producers/consumers linked list with XArray. There are no changes
> in functionality, but lookup performance has been improved.
> 
> The producers and consumers in current IRQ bypass manager are stored in
> simple linked lists, and a single mutex is held while traversing the lists
> and connecting a consumer to a producer (and vice versa). With this design
> and implementation, if there are a large number of KVM agents concurrently
> creating irqfds and all requesting to register their irqfds in the global
> consumers list, the global mutex contention will exponentially increase
> the avg wait latency, which is no longer tolerable in modern systems with
> a large number of CPU cores. For example:
> 
> the wait time latency to acquire the mutex in a stress test where 174000
> irqfds were created concurrently on an 2.70GHz ICX w/ 144 cores:
> 
> - avg = 117.855314 ms
> - min = 20 ns
> - max = 11428.340858 ms
> 
> To reduce latency introduced by the irq_bypass_register_consumer() in
> the above usage scenario, the data structure XArray and its normal API
> is applied to track the producers and consumers so that lookups don't
> require a linear walk since the "tokens" used to match producers and
> consumers are just kernel pointers.
> 
> Thanks to the nature of XArray (more memory-efficient, parallelisable
> and cache friendly), the latecny is significantly reduced (compared to
> list and hlist proposal) under the same environment and testing:
> 
> - avg = 314 ns
> - min = 124 ns
> - max = 47637 ns
> 
> In this conversion, the non-NULL opaque token to match between producer
> and consumer () is used as the XArray index. The list_for_each_entry() is
> replaced by xa_load(), and list_add/del() is replaced by xa_store/erase().
> The list_head member for linked list is removed, along with comments.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Reported-by: Yong He <alexyonghe@tencent.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217379
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> Prerequisite:
> - https://lore.kernel.org/kvm/20230801085408.69597-1-likexu@tencent.com

Perhaps send it as a series?

> Test Requests:
> - Please rant to me if it causes a negative impact on vdpa/vfio testing.
>  include/linux/irqbypass.h |   8 +--
>  virt/lib/irqbypass.c      | 123 +++++++++++++++++++-------------------
>  2 files changed, 61 insertions(+), 70 deletions(-)
> 
> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> index 9bdb2a781841..dbcc1b4d0ccf 100644
> --- a/include/linux/irqbypass.h
> +++ b/include/linux/irqbypass.h
> @@ -8,14 +8,12 @@
>  #ifndef IRQBYPASS_H
>  #define IRQBYPASS_H
>  
> -#include <linux/list.h>
> -
>  struct irq_bypass_consumer;
>  
>  /*
>   * Theory of operation
>   *
> - * The IRQ bypass manager is a simple set of lists and callbacks that allows
> + * The IRQ bypass manager is a simple set of xarrays and callbacks that allows
>   * IRQ producers (ex. physical interrupt sources) to be matched to IRQ
>   * consumers (ex. virtualization hardware that allows IRQ bypass or offload)
>   * via a shared token (ex. eventfd_ctx).  Producers and consumers register
> @@ -30,7 +28,6 @@ struct irq_bypass_consumer;
>  
>  /**
>   * struct irq_bypass_producer - IRQ bypass producer definition
> - * @node: IRQ bypass manager private list management
>   * @token: opaque token to match between producer and consumer (non-NULL)
>   * @irq: Linux IRQ number for the producer device
>   * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
> @@ -43,7 +40,6 @@ struct irq_bypass_consumer;
>   * for a physical device assigned to a VM.
>   */
>  struct irq_bypass_producer {
> -	struct list_head node;
>  	void *token;
>  	int irq;
>  	int (*add_consumer)(struct irq_bypass_producer *,
> @@ -56,7 +52,6 @@ struct irq_bypass_producer {
>  
>  /**
>   * struct irq_bypass_consumer - IRQ bypass consumer definition
> - * @node: IRQ bypass manager private list management
>   * @token: opaque token to match between producer and consumer (non-NULL)
>   * @add_producer: Connect the IRQ consumer to an IRQ producer
>   * @del_producer: Disconnect the IRQ consumer from an IRQ producer
> @@ -69,7 +64,6 @@ struct irq_bypass_producer {
>   * portions of the interrupt handling to the VM.
>   */
>  struct irq_bypass_consumer {
> -	struct list_head node;
>  	void *token;
>  	int (*add_producer)(struct irq_bypass_consumer *,
>  			    struct irq_bypass_producer *);
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index e0aabbbf27ec..78238c0fa83f 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -15,15 +15,15 @@
>   */
>  
>  #include <linux/irqbypass.h>
> -#include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/xarray.h>
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("IRQ bypass manager utility module");
>  
> -static LIST_HEAD(producers);
> -static LIST_HEAD(consumers);
> +static DEFINE_XARRAY(producers);
> +static DEFINE_XARRAY(consumers);
>  static DEFINE_MUTEX(lock);
>  
>  /* @lock must be held when calling connect */
> @@ -78,11 +78,12 @@ static void __disconnect(struct irq_bypass_producer *prod,
>   * irq_bypass_register_producer - register IRQ bypass producer
>   * @producer: pointer to producer structure
>   *
> - * Add the provided IRQ producer to the list of producers and connect
> - * with any matching token found on the IRQ consumers list.
> + * Add the provided IRQ producer to the xarray of producers and connect
> + * with any matching token found on the IRQ consumers xarray.
>   */
>  int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>  {
> +	unsigned long token = (unsigned long)producer->token;
>  	struct irq_bypass_producer *tmp;
>  	struct irq_bypass_consumer *consumer;
>  	int ret;
> @@ -97,23 +98,22 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>  
>  	mutex_lock(&lock);
>  
> -	list_for_each_entry(tmp, &producers, node) {
> -		if (tmp->token == producer->token || tmp == producer) {
> -			ret = -EBUSY;
> +	tmp = xa_load(&producers, token);
> +	if (tmp || tmp == producer) {
> +		ret = -EBUSY;
> +		goto out_err;
> +	}
> +
> +	consumer = xa_load(&consumers, token);
> +	if (consumer) {
> +		ret = __connect(producer, consumer);
> +		if (ret)
>  			goto out_err;
> -		}
>  	}
>  
> -	list_for_each_entry(consumer, &consumers, node) {
> -		if (consumer->token == producer->token) {
> -			ret = __connect(producer, consumer);
> -			if (ret)
> -				goto out_err;
> -			break;
> -		}
> -	}
> -
> -	list_add(&producer->node, &producers);
> +	ret = xa_err(xa_store(&producers, token, producer, GFP_KERNEL));
> +	if (ret)
> +		goto out_err;


This leaves the producer and consumer connected but not tracked in the
producers xarray.

>  
>  	mutex_unlock(&lock);
>  
> @@ -129,11 +129,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
>   * irq_bypass_unregister_producer - unregister IRQ bypass producer
>   * @producer: pointer to producer structure
>   *
> - * Remove a previously registered IRQ producer from the list of producers
> + * Remove a previously registered IRQ producer from the xarray of producers
>   * and disconnect it from any connected IRQ consumer.
>   */
>  void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>  {
> +	unsigned long token = (unsigned long)producer->token;
>  	struct irq_bypass_producer *tmp;
>  	struct irq_bypass_consumer *consumer;
>  
> @@ -143,24 +144,18 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>  	might_sleep();
>  
>  	if (!try_module_get(THIS_MODULE))
> -		return; /* nothing in the list anyway */
> +		return; /* nothing in the xarray anyway */
>  
>  	mutex_lock(&lock);
>  
> -	list_for_each_entry(tmp, &producers, node) {
> -		if (tmp != producer)
> -			continue;
> +	tmp = xa_load(&producers, token);
> +	if (tmp == producer) {
> +		consumer = xa_load(&consumers, token);
> +		if (consumer)
> +			__disconnect(producer, consumer);
>  
> -		list_for_each_entry(consumer, &consumers, node) {
> -			if (consumer->token == producer->token) {
> -				__disconnect(producer, consumer);
> -				break;
> -			}
> -		}
> -
> -		list_del(&producer->node);
> +		xa_erase(&producers, token);
>  		module_put(THIS_MODULE);
> -		break;
>  	}
>  
>  	mutex_unlock(&lock);
> @@ -173,11 +168,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
>   * irq_bypass_register_consumer - register IRQ bypass consumer
>   * @consumer: pointer to consumer structure
>   *
> - * Add the provided IRQ consumer to the list of consumers and connect
> - * with any matching token found on the IRQ producer list.
> + * Add the provided IRQ consumer to the xarray of consumers and connect
> + * with any matching token found on the IRQ producer xarray.
>   */
>  int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
>  {
> +	unsigned long token = (unsigned long)consumer->token;
>  	struct irq_bypass_consumer *tmp;
>  	struct irq_bypass_producer *producer;
>  	int ret;
> @@ -193,23 +189,22 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
>  
>  	mutex_lock(&lock);
>  
> -	list_for_each_entry(tmp, &consumers, node) {
> -		if (tmp->token == consumer->token || tmp == consumer) {
> -			ret = -EBUSY;
> +	tmp = xa_load(&consumers, token);
> +	if (tmp || tmp == consumer) {
> +		ret = -EBUSY;
> +		goto out_err;
> +	}
> +
> +	producer = xa_load(&producers, token);
> +	if (producer) {
> +		ret = __connect(producer, consumer);
> +		if (ret)
>  			goto out_err;
> -		}
>  	}
>  
> -	list_for_each_entry(producer, &producers, node) {
> -		if (producer->token == consumer->token) {
> -			ret = __connect(producer, consumer);
> -			if (ret)
> -				goto out_err;
> -			break;
> -		}
> -	}
> -
> -	list_add(&consumer->node, &consumers);
> +	ret = xa_err(xa_store(&consumers, token, consumer, GFP_KERNEL));
> +	if (ret)
> +		goto out_err;

Same as above.  Thanks,

Alex

>  
>  	mutex_unlock(&lock);
>  
> @@ -225,11 +220,12 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
>   * irq_bypass_unregister_consumer - unregister IRQ bypass consumer
>   * @consumer: pointer to consumer structure
>   *
> - * Remove a previously registered IRQ consumer from the list of consumers
> + * Remove a previously registered IRQ consumer from the xarray of consumers
>   * and disconnect it from any connected IRQ producer.
>   */
>  void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>  {
> +	unsigned long token = (unsigned long)consumer->token;
>  	struct irq_bypass_consumer *tmp;
>  	struct irq_bypass_producer *producer;
>  
> @@ -239,24 +235,18 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>  	might_sleep();
>  
>  	if (!try_module_get(THIS_MODULE))
> -		return; /* nothing in the list anyway */
> +		return; /* nothing in the xarray anyway */
>  
>  	mutex_lock(&lock);
>  
> -	list_for_each_entry(tmp, &consumers, node) {
> -		if (tmp != consumer)
> -			continue;
> +	tmp = xa_load(&consumers, token);
> +	if (tmp == consumer) {
> +		producer = xa_load(&producers, token);
> +		if (producer)
> +			__disconnect(producer, consumer);
>  
> -		list_for_each_entry(producer, &producers, node) {
> -			if (producer->token == consumer->token) {
> -				__disconnect(producer, consumer);
> -				break;
> -			}
> -		}
> -
> -		list_del(&consumer->node);
> +		xa_erase(&consumers, token);
>  		module_put(THIS_MODULE);
> -		break;
>  	}
>  
>  	mutex_unlock(&lock);
> @@ -264,3 +254,10 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
>  	module_put(THIS_MODULE);
>  }
>  EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
> +
> +static void __exit irqbypass_exit(void)
> +{
> +	xa_destroy(&producers);
> +	xa_destroy(&consumers);
> +}
> +module_exit(irqbypass_exit);
> 
> base-commit: b580148824057ef8e3cc3a459082ebcb99716880

