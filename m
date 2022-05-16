Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98578529238
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346477AbiEPU6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 16:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348684AbiEPU6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 16:58:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0484E39BB3
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652733186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6mG53WyWafV/8IUwjvrRVUCksuLDk+7kOcnLpxIhrxM=;
        b=UHD+aUE8k0gNDPcjhd0gBaWFuQAXyCe55JD2kA4Wnwa17mH5gLDQJd2du4K0/LRrIkH96r
        7WbqVf97YpbAC94fE+a3k/b0rIHqKgO3V+PpJYPORIhlatXikAZmkGFnOjzzGJGssEGHLU
        Ak0FLvkK5TE2r9108djE6Hmg3rgEWa0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-l2LIh2R2PUeh4B53Si6Xlg-1; Mon, 16 May 2022 16:33:01 -0400
X-MC-Unique: l2LIh2R2PUeh4B53Si6Xlg-1
Received: by mail-io1-f71.google.com with SMTP id i66-20020a6bb845000000b00657bac76fb4so11128266iof.15
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6mG53WyWafV/8IUwjvrRVUCksuLDk+7kOcnLpxIhrxM=;
        b=rhOuKjOpXQuuGe2/qf77Ph/hLR0C5JqdxbVyLaOeQm52pX57fzrmbzvRsq+md2ch0h
         5N2NCpPCu5vx/NBo8C0oWi8TcoKMfhvFuoxjmqvIqhmI1YG8NwV9SPmDx9khdVwi7ItJ
         HsP7Kpeti7paU6s0nAfIfhiIC+tjscOPlCDLkPkFt1sCulqncOAT9o9CpYFy1odoAe97
         oiMDX6XQrqxEHfk6CYsM5ZGwUOnlyHRklM04FmsUOrY7ZNrTGlyMwSieAsvMbhqxVnkg
         uSXhBn2BzwRdC/qWinLdZrv3xonYyuXGfv0muzNr7rH+8g5bzEocIjP6AAFQ0f/amTRm
         LblA==
X-Gm-Message-State: AOAM533pgC0P5hN5JZZP4TNe5GPS0t8Zz6JWoog1Zdzv8L11jQ7RZvMZ
        KEa0xNNQeA8M62QePSEPM+YcfEF9BjocDI648t9n3HdX6q2Itpgsras5Dulhh4EPN2edeMEf7Jb
        wZyzgzd1pSzr/
X-Received: by 2002:a05:6e02:f8f:b0:2d1:2b31:4375 with SMTP id v15-20020a056e020f8f00b002d12b314375mr2102651ilo.56.1652733180922;
        Mon, 16 May 2022 13:33:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXi+qWoRdf68e5Nj9dBDBIPGzqgjFHdEScKjbz1ZTxSyLOYuOQDIAhSQjZqK4UQhOt5xdJvA==
X-Received: by 2002:a05:6e02:f8f:b0:2d1:2b31:4375 with SMTP id v15-20020a056e020f8f00b002d12b314375mr2102638ilo.56.1652733180709;
        Mon, 16 May 2022 13:33:00 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id u12-20020a92da8c000000b002cde6e352bbsm110450iln.5.2022.05.16.13.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:33:00 -0700 (PDT)
Date:   Mon, 16 May 2022 16:32:58 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/9] KVM: selftests: Drop stale function parameter
 comment for nested_map()
Message-ID: <YoK0+q+3kzeOJq3a@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-4-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:29PM +0000, David Matlack wrote:
> nested_map() does not take a parameter named eptp_memslot. Drop the
> comment referring to it.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

