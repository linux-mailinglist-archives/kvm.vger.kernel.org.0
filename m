Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D549622534
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKIITm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKIITf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:19:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1819C36
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667981914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dgGprYoeTN22cTQDR5YOz3sASLNpnLaaRp5I0puxy0k=;
        b=AVb96HoqsFxhJwmho87cl+Da/mWdRY3ElfBZelcdDeXuwQYkiALZsWe7lVYHB0PkbQR/g/
        9YRZg1HEBCVtUKruYIT/AL7CxTlbOzt7+YyyNYUHYMqDFNnkDWWEuQsSZmPnndkJuwp3aL
        oclobTSHpCtr6ZO1fMM26i5h8tR7uEM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-us1qVTZlPjKOu0EG53fsAg-1; Wed, 09 Nov 2022 03:18:32 -0500
X-MC-Unique: us1qVTZlPjKOu0EG53fsAg-1
Received: by mail-qv1-f69.google.com with SMTP id e13-20020ad450cd000000b004bb49d98da4so11214904qvq.9
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 00:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgGprYoeTN22cTQDR5YOz3sASLNpnLaaRp5I0puxy0k=;
        b=TXbZceHOSAqjZDYzb9ku3eyzqexc4t3kwphbTzGQu3B1w2PgCsV2IppnA/jmWZi6VJ
         Vo6xucFAke0gtVc7Eq9lmIW0KNE3VJH53YDy3CG+0Drz/48nntJBqezdq6AE3kqErMY/
         NXa9FkHplqBWbeikg0GkXi2T/ADJIc8UiXrgwAab8U4JL6I8kLaNYQTeyFJro1tFpsNL
         5S8PFx1R98yAl7ebIKOA2gDDAAln7nBi4WYFzXR1vFZwv1ZRl04RYIa36dkFcVIg5FTn
         QHGtW8EMMdIbeXHtZB26kHqMiHfYT/NfR8EhUc57yjDyf3bQ7ROmAoprB+1ApQxPq4qw
         6STA==
X-Gm-Message-State: ACrzQf3YDgNPLGcwImrpQE9VFhXqlt1R6wskS1S1YJxwHP8t3zY8MHnf
        V4AEebhfzx9kM+NFBF0IV7Oywa+LH3MzDhG1HBejLsqSEoJ4WFnbJb/dj5DSa01sAlTvSY7UBzU
        /YuII9Tw3O5f+
X-Received: by 2002:a0c:de07:0:b0:4bc:187a:7085 with SMTP id t7-20020a0cde07000000b004bc187a7085mr38386058qvk.13.1667981912273;
        Wed, 09 Nov 2022 00:18:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5nr5OeV6fr2CjoyWBfrNdvGZsceXntb36rsvEakUXbxiiIfozncmPJPob44jTHHjm5hBECkg==
X-Received: by 2002:a0c:de07:0:b0:4bc:187a:7085 with SMTP id t7-20020a0cde07000000b004bc187a7085mr38386045qvk.13.1667981912018;
        Wed, 09 Nov 2022 00:18:32 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bi14-20020a05620a318e00b006b929a56a2bsm10711570qkb.3.2022.11.09.00.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:18:31 -0800 (PST)
Date:   Wed, 9 Nov 2022 09:18:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
Message-ID: <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
References: <20221108103437.105327-1-sgarzare@redhat.com>
 <20221108103437.105327-3-sgarzare@redhat.com>
 <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 11:28:41AM +0800, Jason Wang wrote:
>On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> vhost_iotlb_itree_first() requires `start` and `last` parameters
>> to search for a mapping that overlaps the range.
>>
>> In translate_desc() we cyclically call vhost_iotlb_itree_first(),
>> incrementing `addr` by the amount already translated, so rightly
>> we move the `start` parameter passed to vhost_iotlb_itree_first(),
>> but we should hold the `last` parameter constant.
>>
>> Let's fix it by saving the `last` parameter value before incrementing
>> `addr` in the loop.
>>
>> Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> I'm not sure about the fixes tag. On the one I used this patch should
>> apply cleanly, but looking at the latest stable (4.9), maybe we should
>> use
>>
>> Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
>
>I think this should be the right commit to fix.

Yeah, @Michael should I send a v2 with that tag?

>
>Other than this
>
>Acked-by: Jason Wang <jasowang@redhat.com>
>

Thanks for the review,
Stefano

