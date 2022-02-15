Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB914B6B50
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiBOLml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:42:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiBOLml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:42:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0417B192B6
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644925349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjnbuWeKFhqOoYjM7TShoqpYbBMxPZgJhbxy0whFK08=;
        b=fpCmS37z13ExeF2hiZZ1sR1Bv8RmHkabQe3rRQ2WrISp2cdBwtz5z/2icJ1FzP6Et9L0oE
        7qB6x4vu6gbRqo8MY+rze0vuTn7cusmlhh7azLet/zFptKn5X/XRC+oJaVW9HgLsQ3kU9a
        fDMEciWpqLpuC+x+rRZ5xFmmnmJ3LvA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-9DORiPrYM9eHzq4RyOV0Vw-1; Tue, 15 Feb 2022 06:42:28 -0500
X-MC-Unique: 9DORiPrYM9eHzq4RyOV0Vw-1
Received: by mail-wr1-f71.google.com with SMTP id s5-20020adfbc05000000b001e7af4f2231so126243wrg.3
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 03:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=PjnbuWeKFhqOoYjM7TShoqpYbBMxPZgJhbxy0whFK08=;
        b=w5TExDRi7HnR4mctMKfENkQdTOvzlggVkmVEhd8s6DgDaOiNK24ZgOtAHIREjAdviE
         lfx4YrGSJRtJ9AVS4yACdD3F7jB9xGiBg7n1V4gQ1iZCSnJtr4V/er2rI3+bllxxMGNE
         keojD2koHJ3HdBAkoz1q6XsEik2oeJ7DIzeJqWnMHHV2iSh7p8NBvq/Cgq7oVcW8mt0y
         /otRU4p3SwEcu4f8zuvyHTVKlDCNmfu3bkkywn/chqiVg3SHWSWqVi5bd47OusSKbKoQ
         GLVmFa7vVhkkfUwdYuqrO8pxiACADBXtK+EHWl4DeHIesGlJSJNai++adrgk2y/TBrUu
         Dj7g==
X-Gm-Message-State: AOAM533mF8qros6KRM80ujLvNgyv5wfrZUV6IByAQlgF7s8DefN9+jrA
        w53VLxA6qjJWtBVsv/uKSd5VYAlsh1v0jweewvSb87kiTETEgymgHHlK0GMICbIYAc/XD0D9v5E
        Yzt2V13LyZdxL
X-Received: by 2002:a7b:ca56:0:b0:37c:321e:9947 with SMTP id m22-20020a7bca56000000b0037c321e9947mr2752181wml.14.1644925347641;
        Tue, 15 Feb 2022 03:42:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxoBwAwhuNEUS135wctuAV6IRl4SdvK7l5cFBUZJc6WBHpZGx/EhPB4rfRNzOYOBK5c9+C7kA==
X-Received: by 2002:a7b:ca56:0:b0:37c:321e:9947 with SMTP id m22-20020a7bca56000000b0037c321e9947mr2752161wml.14.1644925347419;
        Tue, 15 Feb 2022 03:42:27 -0800 (PST)
Received: from ?IPV6:2003:cb:c70e:3700:9260:2fb2:742d:da3e? (p200300cbc70e370092602fb2742dda3e.dip0.t-ipconnect.de. [2003:cb:c70e:3700:9260:2fb2:742d:da3e])
        by smtp.gmail.com with ESMTPSA id j10sm9472254wmq.20.2022.02.15.03.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 03:42:27 -0800 (PST)
Message-ID: <e85b6271-5510-959b-efdc-7ba318f114bc@redhat.com>
Date:   Tue, 15 Feb 2022 12:42:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Kameron Lutes <kalutes@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        kvm@vger.kernel.org
Cc:     Suleiman Souhlal <suleiman@chromium.org>,
        Charles William Dick <cwd@google.com>,
        David Stevens <stevensd@chromium.org>
References: <20220214195908.4070138-1-kalutes@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] Virtio-balloon: add user space API for sizing
In-Reply-To: <20220214195908.4070138-1-kalutes@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.22 20:59, Kameron Lutes wrote:
> This new linux API will allow user space applications to directly
> control the size of the virtio-balloon. This is useful in
> situations where the guest must quickly respond to drastically
> increased memory pressure and cannot wait for the host to adjust
> the balloon's size.
> 
> Under the current wording of the Virtio spec, guest driven
> behavior such as this is permitted:
> 
> VIRTIO Version 1.1 Section 5.5.6
> "The device is driven either by the receipt of a configuration
> change notification, or by changing guest memory needs, such as
> performing memory compaction or responding to out of memory
> conditions."

Not quite. num_pages is determined by the hypervisor only and the guest
is not expected to change it, and if it does, it's ignored.

5.5.6 does not indicate at all that the guest may change it or that it
would have any effect. num_pages is examined only, actual is updated by
the driver.

5.5.6.1 documents what's allowed, e.g.,

  The driver SHOULD supply pages to the balloon when num_pages is
  greater than the actual number of pages in the balloon.

  The driver MAY use pages from the balloon when num_pages is less than
  the actual number of pages in the balloon.

and special handling for VIRTIO_BALLOON_F_DEFLATE_ON_OOM.

Especially, we have

  The driver MUST update actual after changing the number of pages in
  the balloon.

  The driver MAY update actual once after multiple inflate and deflate
  operations.

That's also why QEMU never syncs back the num_pages value from the guest
when writing the config.


Current spec does not allow for what you propose.


> 
> The intended use case for this API is one where the host
> communicates a deflation limit to the guest. The guest may then
> choose to respond to memory pressure by deflating its balloon down
> to the guest's allowable limit.

It would be good to have a full proposal and a proper spec update. I'd
assume you'd want separate values for soft vs. hard num_values -- if
that's what we really want.

BUT

There seems to be recent interest in handling memory pressure in a
better way (although how to really detect "serious memory pressure" vs
"ordinary reclaim" in Linux is still to be figured out). There is
already a discussion going on how that could happen. Adding random user
space toggles might not be the best idea. We might want a single
mechanism to achieve that.

https://lists.oasis-open.org/archives/virtio-comment/202201/msg00139.html

-- 
Thanks,

David / dhildenb

