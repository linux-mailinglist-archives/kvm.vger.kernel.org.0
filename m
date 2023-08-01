Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C69876BE73
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 22:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjHAU1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 16:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjHAU1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 16:27:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C1F2684
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 13:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690921606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wy2TkA8uXc4KqWHCSUGw2dDqfqA9SqU7ECQFvC91hnU=;
        b=HQUA0DQ/VMR3HyTphzqETBgKz6XTLs5N0w38IsgGPpVgPaLqsuYzI+uEiWoUJ+3O2vGzJN
        Xilx3LuSOGFOiCmaEUiXRYyYcY+k3+6w8AC6bQYnPVulxddKkVNg225GaGGxV+5cs/7WJq
        SJaFy896mfZVyZkIdrkrbTPc8t3BXBg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-LBnyEU-fNEG5fjFukvA79A-1; Tue, 01 Aug 2023 16:26:45 -0400
X-MC-Unique: LBnyEU-fNEG5fjFukvA79A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7908cca2c06so307475139f.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 13:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690921604; x=1691526404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wy2TkA8uXc4KqWHCSUGw2dDqfqA9SqU7ECQFvC91hnU=;
        b=D12b5Xt3P3PxGOgDy8yZKOCTrk1nT9b3NY0KBj1eg9XAC0Aa1L0Fw72MPFODllziwR
         EPVWxe2TGCV7QzP8rbwiRpQNhXeMjfPYAR2iNFs43cx6CyMBt8AkvlMNptjNq2GSj6+9
         Y3+QpTqZ6XxdNLlOeX6+8k7h8WNkGswO4+t9Odcy606ZaWrHP8+PA/bscivzO3fhcf2W
         MM3sDBACGpsWpA36/7tcIWpFb/9xCvQoTNWI94CTNq1cctUBzApl+h7kjcA9x4EgUIXH
         kBCmdF3HWjx9jhT8rTJrYzpg/8czmnc81V1Et1YmRWYC8WH+v5At2yHh25qEfzKW+Fkc
         3tGg==
X-Gm-Message-State: ABy/qLYjXlSF03yN8vBFq9ZK4b+qdkNWJfCEGA4Qs6CI+spo6sffk+Dj
        qLYmLtpUqp5l1i9jVHpsYqKRMG78UdFvnXAqoGK/88QzfOY548RCy2ReOcTChlXBKsJ24du3iCq
        /fwV/AfHFHbN4HJMccAYb
X-Received: by 2002:a05:6e02:1142:b0:348:b114:a3d2 with SMTP id o2-20020a056e02114200b00348b114a3d2mr10362597ill.21.1690921604041;
        Tue, 01 Aug 2023 13:26:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEbGknYdks2X0/d/P9ZjLKRglWMfz6zhjFdkrvnM7ln7ilY6KAPsrDg/JLdp7L+95yKWi2IeA==
X-Received: by 2002:a05:6e02:1142:b0:348:b114:a3d2 with SMTP id o2-20020a056e02114200b00348b114a3d2mr10362588ill.21.1690921603816;
        Tue, 01 Aug 2023 13:26:43 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id gs14-20020a0566382d8e00b0042b61a5087csm3838753jab.132.2023.08.01.13.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 13:26:43 -0700 (PDT)
Date:   Tue, 1 Aug 2023 14:26:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: eventfd: fix NULL deref irqbypass producer
Message-ID: <20230801142642.1f73ca45.alex.williamson@redhat.com>
In-Reply-To: <20230801085408.69597-1-likexu@tencent.com>
References: <20230801085408.69597-1-likexu@tencent.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  1 Aug 2023 16:54:08 +0800
Like Xu <like.xu.linux@gmail.com> wrote:

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
> ---
>  virt/lib/irqbypass.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


Reviewed-by: Alex Williamson <alex.williamson@redhat.com>


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
>  			continue;
>  
>  		list_for_each_entry(consumer, &consumers, node) {
> 
> base-commit: 5a7591176c47cce363c1eed704241e5d1c42c5a6

