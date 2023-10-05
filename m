Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B557BA55C
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbjJEQQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbjJEQOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:14:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBF12B889
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 08:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696520335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pRoEsRbsXSOsoH6KGiKH0j22xfVWNx86CTlfVp1YZRk=;
        b=DqcARRhzRwKNcpNUBIPb1GxYGF4gDMj7wmW0m3i+dbkYpeo1xDk32Ow+CWzvBwNtdqxSp5
        aARH30UtqecqZoNYuhbaJ0zd57BlIsL6uC077FqHRyZ5Wj12kMHjf7UfNc5gJ4sdYVXvMm
        8GRVL+voCRIIsZg6+2ABaoIle7zGv8c=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-I_Z1-_UANXy8ygAEhQMk-w-1; Thu, 05 Oct 2023 11:38:43 -0400
X-MC-Unique: I_Z1-_UANXy8ygAEhQMk-w-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1dc580ed1e4so1431351fac.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 08:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696520321; x=1697125121;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pRoEsRbsXSOsoH6KGiKH0j22xfVWNx86CTlfVp1YZRk=;
        b=I8g7hNWtqPDngkDIYtbj7piKmSdVsjxOFOfYq2qhoh44uLt9xui3T/Sxb+2DD9ElHC
         YY/dmwGHJEsr93SQjRJkXqDa3IVXjRUyFWrKN2TmaULBRplSJvEKFwUBwxbjTosT4KG0
         cYtqNfhM6g3dmS6JAYG1GlKYC1CC+qv8YtbjXJYyVh+BHceQvlpHuiQXaeng9DNTZEpu
         jz2BPqWH+v3sSKEr9IBvHDFObsgMjf68VAi56yglr2m2Ht3KU2NDs8rPNpAvoYAG8D9L
         aJzlnk0pa1j2qsnpbBECBxtL5avHLRWjblxXP0k/xAquoS/DJ4kKP71NIJ4NQu97/21K
         4XPA==
X-Gm-Message-State: AOJu0YwztDqvCK8HmGiJ++QrnWntHwQrS8j4LqERgCg0X6hDZMaBDuZP
        3bXWpK3rd9SJe6KjC8yEMZqp19FbFoN+yiibqQyF2TGR7zR5ehmJLjGgAAwkEl/6Ql3tIl4E447
        ijCdszoGMdcXb78nv0v5N
X-Received: by 2002:a05:6871:451:b0:1dc:ddcd:876f with SMTP id e17-20020a056871045100b001dcddcd876fmr6267521oag.41.1696520321578;
        Thu, 05 Oct 2023 08:38:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4R2ZAV/rO3VzgC/Z+lyY537xCjvBhmk+jDRDhf/HSS+5A1ST6FNVq1DHQQIBVX7kgGvc0vA==
X-Received: by 2002:a05:6871:451:b0:1dc:ddcd:876f with SMTP id e17-20020a056871045100b001dcddcd876fmr6267506oag.41.1696520321357;
        Thu, 05 Oct 2023 08:38:41 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id e14-20020a0ce3ce000000b006577e289d37sm583363qvl.2.2023.10.05.08.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 08:38:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Mancini, Riccardo" <mancio@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Teragni, Matias" <mteragni@amazon.com>,
        "Batalov, Eugene" <bataloe@amazon.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: Bug? Incompatible APF for 4.14 guest on 5.10 and later host
In-Reply-To: <9d5ddfbe407940afa02567262a22fa4c@amazon.com>
References: <9d5ddfbe407940afa02567262a22fa4c@amazon.com>
Date:   Thu, 05 Oct 2023 17:38:38 +0200
Message-ID: <877co1cc5d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Mancini, Riccardo" <mancio@amazon.com> writes:

> Hi,
>
> when a 4.14 guest runs on a 5.10 host (and later), it cannot use APF (despite
> CPUID advertising KVM_FEATURE_ASYNC_PF) due to the new interrupt-based
> mechanism 2635b5c4a0 (KVM: x86: interrupt based APF 'page ready' event delivery).
> Kernels after 5.9 won't satisfy the guest request to enable APF through
> KVM_ASYNC_PF_ENABLED, requiring also KVM_ASYNC_PF_DELIVERY_AS_INT to be set.
> Furthermore, the patch set seems to be dropping parts of the legacy #PF handling
> as well.
> I consider this as a bug as it breaks APF compatibility for older guests running
> on newer kernels, by breaking the underlying ABI.
> What do you think? Was this a deliberate decision?

It was. #PF based "page ready" injection was found to be fragile as in
some cases it can collide with an actual #PF and nothing good is
expected if this ever happens. I don't think we've actually broken the
ABI as "asynchronous page fault" was always a "best effort" service: the
guest indicates its readiness to process 'page missing' events but the
host is under no obligation to actually send such notifications.

> Was this already reported in the past (I couldn't find anything in the mailing list
> but I might have missed it!)?

I think it was Andy Lutomirski who started the discussion, see
e.g. https://lore.kernel.org/lkml/ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org/

the patch is about KVM_ASYNC_PF_SEND_ALWAYS but if you go down the
discussion you'll find more concerns expressed.

> Would it be much effort to support the legacy #PF based mechanism for older
> guests that choose to only set KVM_ASYNC_PF_ENABLED?

Personally, I wouldn't go down this road: #PF injection at random time
(for page-ready events) is still considered being fragile.

>
> The reason this is an issue for us now is that not having APF for older guests
> introduces a significant performance regression on 4.14 guests when paired to
> uffd handling of "remote" page-faults (similar to a live migration scenario)
> when we update from a 4.14 host kernel to a 5.10 host kernel.

What about backporting interrupt-based APF mechanism to older guests?

-- 
Vitaly

