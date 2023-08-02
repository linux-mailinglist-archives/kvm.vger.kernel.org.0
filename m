Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CBE76D6E1
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 20:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbjHBSbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjHBSbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 14:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE0D19AD
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 11:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691001023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZVdmius26RlSXht2Utt64qaaZXvCxBapXtuIJrKTQ8A=;
        b=ZJlwRzMb4wLXeVzkBSLXRDEQCcL55pjo7iNL9v6MBQlxVpiwwVn75ybqgRJe2i8CYNnnJb
        cqIFfFM7w1MO68144xEgia0gY55uqa8Z8hHDX7sTmFBjXa4KTgTornxWuR6bii03wtgP48
        G/3ANnNcoqd2wblkD5DOSQrTroARhpw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-N9qvbwQNMq6A_zQ-EIFnxg-1; Wed, 02 Aug 2023 14:30:21 -0400
X-MC-Unique: N9qvbwQNMq6A_zQ-EIFnxg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34911a70e74so791225ab.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 11:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691001020; x=1691605820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVdmius26RlSXht2Utt64qaaZXvCxBapXtuIJrKTQ8A=;
        b=MZsdE9jsw096pWNflpD23evIo4aKxCE1X0ORBr1xXhmEU1ZWO2BoZ2Zqe2SLd6glJn
         WG6tW9BMrF1M5A6VpPvJR/GTTNZ1tZLXR3h2NshHk5GiBRDq5gSyYZ+zDr0givLfP9Vg
         geRzBp9btv/eC5GX9UEVjbODqK4mspppEdTHeacfK3wyBZgLToassWTtCfTD9yyAH8Ly
         oKxlOB3cZ4Zf1wt3vXGo4xxTMC7Pl4YDO3TvI/3fgR4V6/3pkVEZgfXbH27cQMtdurAg
         cPbvYMDNd3K/agLYy4U2PkxrqWHlC1cbJgIh0Sk5heHpYPaCD71MUHreg8y4i8o+lCaB
         udsw==
X-Gm-Message-State: ABy/qLbgUS7Fotui10FAsmdL3BTFSYBm1CLC0QgidM+ofnn0G9eHvIJD
        WMLuHTkUJ5Z8h5ys0PQ+/0mpvu7jUR5426uK3LQ4msmTdPK/FFe7UxpJkPSvH7lc5SFwoybbXV4
        5j1W2PeoSOe7pCrAxDMAD
X-Received: by 2002:a05:6e02:1d95:b0:343:c8b1:b7f0 with SMTP id h21-20020a056e021d9500b00343c8b1b7f0mr20169464ila.23.1691001020470;
        Wed, 02 Aug 2023 11:30:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEVKivkGg6Az6ZWImURjR70SdK+Vyx1AOC/SoM4fyPdpUkslD0r2GYwjg2gVKL8geGuwkyi0Q==
X-Received: by 2002:a05:6e02:1d95:b0:343:c8b1:b7f0 with SMTP id h21-20020a056e021d9500b00343c8b1b7f0mr20169442ila.23.1691001020147;
        Wed, 02 Aug 2023 11:30:20 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id z5-20020a02cea5000000b0042b4b1246cbsm4607233jaq.148.2023.08.02.11.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 11:30:19 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:30:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: irqbypass: Convert producers/consumers
 single linked list to XArray
Message-ID: <20230802123017.5695fe0a.alex.williamson@redhat.com>
In-Reply-To: <20230802051700.52321-3-likexu@tencent.com>
References: <20230802051700.52321-1-likexu@tencent.com>
        <20230802051700.52321-3-likexu@tencent.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  2 Aug 2023 13:17:00 +0800
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
>  include/linux/irqbypass.h |   8 +--
>  virt/lib/irqbypass.c      | 127 +++++++++++++++++++-------------------
>  2 files changed, 63 insertions(+), 72 deletions(-)
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
> index e0aabbbf27ec..3f8736951e92 100644
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
> @@ -97,24 +98,23 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
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
> +	ret = xa_err(xa_store(&producers, token, producer, GFP_KERNEL));
> +	if (ret)
> +		goto out_err;
> +
> +	consumer = xa_load(&consumers, token);
> +	if (consumer) {
> +		ret = __connect(producer, consumer);
> +		if (ret)
>  			goto out_err;

This doesn't match previous behavior, the producer is registered to the
xarray regardless of the result of the connect operation and the caller
cannot distinguish between failures.  The module reference is released
regardless of xarray item.  Nak.

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
> -
>  	mutex_unlock(&lock);
>  
>  	return 0;
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
> @@ -193,24 +189,23 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
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
> +	ret = xa_err(xa_store(&consumers, token, consumer, GFP_KERNEL));
> +	if (ret)
> +		goto out_err;
> +
> +	producer = xa_load(&producers, token);
> +	if (producer) {
> +		ret = __connect(producer, consumer);
> +		if (ret)
>  			goto out_err;

Same.  Thanks,

Alex

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
> -
>  	mutex_unlock(&lock);
>  
>  	return 0;
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

