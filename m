Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2606A674C
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCAFU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCAFUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7694B14EB2
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677647974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JoxlAvdJuHDBJCrOgIUTlM4SY8F7dO88WhGAUg3bcpE=;
        b=Oww1PQ2Ip2I7XsFg+AO+cfYBFeyKMBBqgBZ/eLtnNG2w0wEND4dVd05spzonkasLCQlaW4
        n6CmYn2mwASUuLTG0fDsshkyo4KM9sYHul9Gm/MlmCW1h7Y2D5TN870ccyWROz4W55coai
        tuSZkgE2Hn6/zjZGGrNlsSLZbrh/17Q=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-KO9tb_jKOSiPZSApc4DNqQ-1; Wed, 01 Mar 2023 00:19:33 -0500
X-MC-Unique: KO9tb_jKOSiPZSApc4DNqQ-1
Received: by mail-ot1-f70.google.com with SMTP id k5-20020a056830168500b00690d1e0d27dso5976685otr.0
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:19:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JoxlAvdJuHDBJCrOgIUTlM4SY8F7dO88WhGAUg3bcpE=;
        b=Ts25JRnQzwNKiUuxbXiuh+oIQqtylHQe9ERxOkGXz0DSfpB0mADp0qkz8y44NPhlJG
         hh68Skhm16S7DD67aX47e1NS7U4ZSzvAcst4q+7EA4G60ajqhMDuKiZ6mMByW+dpF9eP
         f00/ebOHkeNhEu6jRM42bYyG7HezdLVYIhjBPeTcnMa8duUlhWlqsixiZ2LyTs77NnY0
         o/SJNalDlGpQKH++u8wJ4doyBZQv8YtKPd1xL4tytz6TX9qsAf8LVdDBFsLXxw1KIGFA
         qz1nYDqvbr5lILxcSzeF71VZZp5R/3nGR3QCNaCOZ8BnTYMMBEtw/EVKxxcONEK4/aSK
         LRcg==
X-Gm-Message-State: AO0yUKXvmk62zhyNQcsO9I4m0SMIJQctC6VxGicUTFSj0U9KHexgm00B
        Hx4c/ytIzRtbJyrJQrxryWq+YO15bfixA5qAoFvFP/ToV5Te9M19SoR05cWWOYn+Ll7QuN0yzDK
        KmYryLwn/vIEv/+4PSrGD8EqMO6Go
X-Received: by 2002:a4a:b048:0:b0:525:2b11:9632 with SMTP id g8-20020a4ab048000000b005252b119632mr1623941oon.1.1677647972630;
        Tue, 28 Feb 2023 21:19:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9i1/+HMuLpowSGP2PqpygUBYimgr76SHhjs4rCN/wwE9sYoKKpsSjTm4UtR1ffUtFejDXsaDvAem+iieivOcw=
X-Received: by 2002:a4a:b048:0:b0:525:2b11:9632 with SMTP id
 g8-20020a4ab048000000b005252b119632mr1623935oon.1.1677647972381; Tue, 28 Feb
 2023 21:19:32 -0800 (PST)
MIME-Version: 1.0
References: <20230301021830.880-1-longpeng2@huawei.com>
In-Reply-To: <20230301021830.880-1-longpeng2@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 1 Mar 2023 13:19:20 +0800
Message-ID: <CACGkMEvEOmE8o+HzNHLhCXYauVk1R3myPcH8TKUxdFUQVZmMBw@mail.gmail.com>
Subject: Re: [PATCH] irqbypass: convert producers/consumers single linked list
 to hlist
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     pbonzini@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        eperezma@redhat.com, arei.gonglei@huawei.com, yechuan@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 1, 2023 at 10:18=E2=80=AFAM Longpeng(Mike) <longpeng2@huawei.co=
m> wrote:
>
> From: Longpeng <longpeng2@huawei.com>
>
> There are no functional changes, but this converts the producers/consumer=
s
> single linked list to a hash list. This can speed up the lookup if the VM
> has many irqfds.
>
> This can save about 15ms when assigning all IRQFS to a QEMU/KVM VM with 1=
K
> irqfds. The overhead would be higher if there were much more irqfds in th=
e
> HOST.
>
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>  include/linux/irqbypass.h |   8 +--
>  virt/lib/irqbypass.c      | 131 ++++++++++++++++++++++++--------------
>  2 files changed, 86 insertions(+), 53 deletions(-)
>
> diff --git a/include/linux/irqbypass.h b/include/linux/irqbypass.h
> index 9bdb2a781841..9039b5f6218d 100644
> --- a/include/linux/irqbypass.h
> +++ b/include/linux/irqbypass.h
> @@ -30,7 +30,7 @@ struct irq_bypass_consumer;
>
>  /**
>   * struct irq_bypass_producer - IRQ bypass producer definition
> - * @node: IRQ bypass manager private list management
> + * @node: IRQ bypass manager private hash list management
>   * @token: opaque token to match between producer and consumer (non-NULL=
)
>   * @irq: Linux IRQ number for the producer device
>   * @add_consumer: Connect the IRQ producer to an IRQ consumer (optional)
> @@ -43,7 +43,7 @@ struct irq_bypass_consumer;
>   * for a physical device assigned to a VM.
>   */
>  struct irq_bypass_producer {
> -       struct list_head node;
> +       struct hlist_node node;
>         void *token;
>         int irq;
>         int (*add_consumer)(struct irq_bypass_producer *,
> @@ -56,7 +56,7 @@ struct irq_bypass_producer {
>
>  /**
>   * struct irq_bypass_consumer - IRQ bypass consumer definition
> - * @node: IRQ bypass manager private list management
> + * @node: IRQ bypass manager private hash list management
>   * @token: opaque token to match between producer and consumer (non-NULL=
)
>   * @add_producer: Connect the IRQ consumer to an IRQ producer
>   * @del_producer: Disconnect the IRQ consumer from an IRQ producer
> @@ -69,7 +69,7 @@ struct irq_bypass_producer {
>   * portions of the interrupt handling to the VM.
>   */
>  struct irq_bypass_consumer {
> -       struct list_head node;
> +       struct hlist_node node;
>         void *token;
>         int (*add_producer)(struct irq_bypass_consumer *,
>                             struct irq_bypass_producer *);
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index 28fda42e471b..8096d2daab01 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -18,14 +18,59 @@
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/hashtable.h>
>
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("IRQ bypass manager utility module");
>
> -static LIST_HEAD(producers);
> -static LIST_HEAD(consumers);
> +/*
> + * hash table for produces/consumers. This improve the performace to fin=
d
> + * an existing producer/consumer.
> + */
> +#define PRODUCERS_HASH_BITS    9
> +#define CONSUMERS_HASH_BITS    9
> +static DEFINE_HASHTABLE(producers, PRODUCERS_HASH_BITS);
> +static DEFINE_HASHTABLE(consumers, CONSUMERS_HASH_BITS);
>  static DEFINE_MUTEX(lock);
>
> +
> +/* @lock must be held */
> +static struct irq_bypass_producer *find_producer_by_token(void *token)
> +{
> +       struct irq_bypass_producer *producer;
> +
> +       hash_for_each_possible(producers, producer, node, (uint64_t)token=
)
> +               if (producer->token =3D=3D token)
> +                       return producer;
> +
> +       return NULL;
> +}
> +
> +/* @lock must be held */
> +static struct irq_bypass_consumer *find_consumer_by_token(void *token)
> +{
> +       struct irq_bypass_consumer *consumer;
> +
> +       hash_for_each_possible(producers, consumer, node, (uint64_t)token=
)
> +               if (consumer->token =3D=3D token)
> +                       return consumer;
> +
> +       return NULL;
> +}
> +
> +/* @lock must be held */
> +static bool has_consumer(struct irq_bypass_consumer *consumer)
> +{
> +       struct irq_bypass_consumer *tmp;
> +       int bkt;
> +
> +       hash_for_each(consumers, bkt, tmp, node)
> +               if (tmp =3D=3D consumer)
> +                       return true;
> +
> +       return false;
> +}
> +
>  /* @lock must be held when calling connect */
>  static int __connect(struct irq_bypass_producer *prod,
>                      struct irq_bypass_consumer *cons)
> @@ -97,23 +142,20 @@ int irq_bypass_register_producer(struct irq_bypass_p=
roducer *producer)
>
>         mutex_lock(&lock);
>
> -       list_for_each_entry(tmp, &producers, node) {
> -               if (tmp->token =3D=3D producer->token) {
> -                       ret =3D -EBUSY;
> -                       goto out_err;
> -               }
> +       tmp =3D find_producer_by_token(producer->token);
> +       if (tmp) {
> +               ret =3D -EBUSY;
> +               goto out_err;
>         }

Nit: I wonder if it would be more straightforward to simply open code
the find_producer_by_token() by simply replacing

list_for_each_entry()

with

hash_for_each_possible().

This seems more flexible than adding stuffs like hash_consumer(). Or
factor out the find_producer_by_token first and replace list with
hlist.

Thanks

>
> -       list_for_each_entry(consumer, &consumers, node) {
> -               if (consumer->token =3D=3D producer->token) {
> -                       ret =3D __connect(producer, consumer);
> -                       if (ret)
> -                               goto out_err;
> -                       break;
> -               }
> +       consumer =3D find_consumer_by_token(producer->token);
> +       if (consumer) {
> +               ret =3D __connect(producer, consumer);
> +               if (ret)
> +                       goto out_err;
>         }
>
> -       list_add(&producer->node, &producers);
> +       hash_add(producers, &producer->node, (uint64_t)producer->token);
>
>         mutex_unlock(&lock);
>
> @@ -147,22 +189,18 @@ void irq_bypass_unregister_producer(struct irq_bypa=
ss_producer *producer)
>
>         mutex_lock(&lock);
>
> -       list_for_each_entry(tmp, &producers, node) {
> -               if (tmp->token !=3D producer->token)
> -                       continue;
> +       tmp =3D find_producer_by_token(producer->token);
> +       if (!tmp)
> +               goto out;
>
> -               list_for_each_entry(consumer, &consumers, node) {
> -                       if (consumer->token =3D=3D producer->token) {
> -                               __disconnect(producer, consumer);
> -                               break;
> -                       }
> -               }
> +       consumer =3D find_consumer_by_token(producer->token);
> +       if (consumer)
> +               __disconnect(producer, consumer);
>
> -               list_del(&producer->node);
> -               module_put(THIS_MODULE);
> -               break;
> -       }
> +       hash_del(&producer->node);
> +       module_put(THIS_MODULE);
>
> +out:
>         mutex_unlock(&lock);
>
>         module_put(THIS_MODULE);
> @@ -193,23 +231,20 @@ int irq_bypass_register_consumer(struct irq_bypass_=
consumer *consumer)
>
>         mutex_lock(&lock);
>
> -       list_for_each_entry(tmp, &consumers, node) {
> -               if (tmp->token =3D=3D consumer->token || tmp =3D=3D consu=
mer) {
> -                       ret =3D -EBUSY;
> -                       goto out_err;
> -               }
> +       tmp =3D find_consumer_by_token(consumer->token);
> +       if (tmp || has_consumer(consumer)) {
> +               ret =3D -EBUSY;
> +               goto out_err;
>         }
>
> -       list_for_each_entry(producer, &producers, node) {
> -               if (producer->token =3D=3D consumer->token) {
> -                       ret =3D __connect(producer, consumer);
> -                       if (ret)
> -                               goto out_err;
> -                       break;
> -               }
> +       producer =3D find_producer_by_token(consumer->token);
> +       if (producer) {
> +               ret =3D __connect(producer, consumer);
> +               if (ret)
> +                       goto out_err;
>         }
>
> -       list_add(&consumer->node, &consumers);
> +       hash_add(consumers, &consumer->node, (uint64_t)consumer->token);
>
>         mutex_unlock(&lock);
>
> @@ -232,6 +267,7 @@ void irq_bypass_unregister_consumer(struct irq_bypass=
_consumer *consumer)
>  {
>         struct irq_bypass_consumer *tmp;
>         struct irq_bypass_producer *producer;
> +       int bkt;
>
>         if (!consumer->token)
>                 return;
> @@ -243,18 +279,15 @@ void irq_bypass_unregister_consumer(struct irq_bypa=
ss_consumer *consumer)
>
>         mutex_lock(&lock);
>
> -       list_for_each_entry(tmp, &consumers, node) {
> +       hash_for_each(consumers, bkt, tmp, node) {
>                 if (tmp !=3D consumer)
>                         continue;
>
> -               list_for_each_entry(producer, &producers, node) {
> -                       if (producer->token =3D=3D consumer->token) {
> -                               __disconnect(producer, consumer);
> -                               break;
> -                       }
> -               }
> +               producer =3D find_producer_by_token(consumer->token);
> +               if (producer)
> +                       __disconnect(producer, consumer);
>
> -               list_del(&consumer->node);
> +               hash_del(&consumer->node);
>                 module_put(THIS_MODULE);
>                 break;
>         }
> --
> 2.23.0
>

