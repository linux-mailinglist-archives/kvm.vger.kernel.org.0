Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5690577E8D0
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345581AbjHPSh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 14:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345607AbjHPShT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 14:37:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FE819A1
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 11:37:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5660839189fso544812a12.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 11:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692211037; x=1692815837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7fdKmEY7bD6zEhbTIZAzgi0Gq+GtDgf7Fev/C7AAGM=;
        b=rLZhtE01pc4I/k71SWB8oJkUqzVgoZkl9ke1X5JLEjFj6IuHfSYzT0dm1pZJrfdYDF
         3z2/TcRKzbCXR4Op2KduCzCGnYNexhlMbsIUtEHK3vCqhPslckbETavmtCH8tgH6WfM8
         XwLxhZGD4wqa370lTsFYHEL3kMYp+Q+wgfFVEkNNGwWFA5ccGjBywHW9K1uzXkHDsl/Z
         3TezHRxWqpSQRmzvd3I6D0IblynqsTWLj8uUhvUTQAMLghf0S9VIuxazRs91Ov1BpHve
         Z33yEeSf1kIy19Iu92oO0x0tPBZ5bvQpdHSYnafd9DI8M2bQr2lV36BWBEGofOG21pN8
         nkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692211037; x=1692815837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R7fdKmEY7bD6zEhbTIZAzgi0Gq+GtDgf7Fev/C7AAGM=;
        b=OAEz+PRKx5dD1XhVlXnR88r3q9OdyrPrL2fLYVzDmBA8BM0RkkBt3G8eUPQzceO9xB
         dpMIDBtpjRr5vA+UwUrofTnSgpk4eJdP5djpxmzkBJepxRI55qLWq5t0WdWOByn+l1Tv
         mNrxiAuKXcUlWtUucnCxV99PH1ELA1Od2cPUpw+qxFd4r378dbOD8SC9oYwOh7lL32Sf
         CZ5+HMZB0Rr5C5ElD02bB1YuhLhgeeUZYZRUiejLa3mwO1xkKmo4JDM2cArgK8a4Tgrd
         18oj86tkwh9r89ojNU4sJkBHBDcg19JwIcJjzvsHCOVLoNajxiBhOEOKcZxzwxIMEXpi
         k2rw==
X-Gm-Message-State: AOJu0YxFlm8bPsRvmTg5Of70xEOYnjUdX3atnNle56FLu6FLp3d7wTjQ
        GxObAmBRIlD5GU6EiMze5q/V/v9b5o0=
X-Google-Smtp-Source: AGHT+IEFp1LYkqGFtNbmR422YJnqFFI8fTBy63QxTHUvjzRIoP7Ald+8kd/ogLf8DJDRFadAPDh/XaorXLQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:950c:0:b0:565:e2cd:c9e1 with SMTP id
 p12-20020a63950c000000b00565e2cdc9e1mr588044pgd.11.1692211037524; Wed, 16 Aug
 2023 11:37:17 -0700 (PDT)
Date:   Wed, 16 Aug 2023 11:37:16 -0700
In-Reply-To: <20230802051700.52321-2-likexu@tencent.com>
Mime-Version: 1.0
References: <20230802051700.52321-1-likexu@tencent.com> <20230802051700.52321-2-likexu@tencent.com>
Message-ID: <ZN0XXKezcXjv1GWH@google.com>
Subject: Re: [PATCH v2 1/2] KVM: eventfd: Fix NULL deref irqbypass producer
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Adding guard logic to make irq_bypass_register/unregister_producer()
> looks for the producer entry based on producer pointer itself instead
> of pure token matching.
> 
> As was attempted commit 4f3dbdf47e15 ("KVM: eventfd: fix NULL deref
> irqbypass consumer"), two different producers may occasionally have two
> identical eventfd's. In this case, the later producer may unregister
> the previous one after the registration fails (since they share the same
> token), then NULL deref incurres in the path of deleting producer from
> the producers list.
> 
> Registration should also fail if a registered producer changes its
> token and registers again via the same producer pointer.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  virt/lib/irqbypass.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
> index 28fda42e471b..e0aabbbf27ec 100644
> --- a/virt/lib/irqbypass.c
> +++ b/virt/lib/irqbypass.c
> @@ -98,7 +98,7 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
>  	mutex_lock(&lock);
>  
>  	list_for_each_entry(tmp, &producers, node) {
> -		if (tmp->token == producer->token) {
> +		if (tmp->token == producer->token || tmp == producer) {
>  			ret = -EBUSY;
>  			goto out_err;
>  		}
> @@ -148,7 +148,7 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
>  	mutex_lock(&lock);
>  
>  	list_for_each_entry(tmp, &producers, node) {
> -		if (tmp->token != producer->token)
> +		if (tmp != producer)

What are the rules for using these APIs?  E.g. is doing unregister without
first doing a register actually allowed?  Ditto for having multiple in-flight
calls to (un)register the exact same producer or consumer.

E.g. can we do something like the below, and then remove the list iteration to
find the passed in pointer (which is super odd IMO).  Obviously not a blocker
for this patch, but it seems like we could achieve a simpler and more performant
implementation if we first sanitize the rules and the usage.

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471b..be0ba4224a23 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -90,6 +90,9 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
        if (!producer->token)
                return -EINVAL;
 
+       if (WARN_ON_ONCE(producer->node.prev && !list_empty(&producer->node)))
+               return -EINVAL;
+
        might_sleep();
 
        if (!try_module_get(THIS_MODULE))
@@ -140,6 +143,9 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
        if (!producer->token)
                return;
 
+       if (WARN_ON_ONCE(!producer->node.prev || list_empty(&producer->node)))
+               return;
+
        might_sleep();
 
        if (!try_module_get(THIS_MODULE))

