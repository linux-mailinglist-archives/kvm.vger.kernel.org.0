Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8333E62281F
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 11:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiKIKLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 05:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiKIKLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 05:11:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E7BCBA
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 02:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667988644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5MPz3Ec+EPgg7rG8vMEpdX68m++2s8DqWYBcdW2qsvI=;
        b=C1Eo/z9K0XzWDaxc+N2ZUnny0vBIxOYELgbh6/qYFOnLDLMRo22mvJfbf407k8f1NbuxZA
        95UXa2IWafvCjJdGwxs1vZeLkTcaDjhFV0qv0R5e/u9ZQ6inbKsZcTFBxTrd7wCQVsuWAh
        jF6Z3SDexZ6bgJ8pNEDtNUqaXH8pD7M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-D9CDb8_WO1-4uR3uTdNHcQ-1; Wed, 09 Nov 2022 05:10:43 -0500
X-MC-Unique: D9CDb8_WO1-4uR3uTdNHcQ-1
Received: by mail-qv1-f72.google.com with SMTP id mo15-20020a056214330f00b004b96d712bccso11514571qvb.22
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 02:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MPz3Ec+EPgg7rG8vMEpdX68m++2s8DqWYBcdW2qsvI=;
        b=e+sqUc/ZhilVAAP7HVOlSNYvxZ3mV2mwECy1QQqPvHVSEMgYBVC9YLAKSUGmI7c8vu
         465unJ4GnIyrTHClyK5cXfCr0XZA3jjpBjpte1axJbr1Mr8E8VzcD++Bv0q9P0ZntzAg
         Vu63JekaGKCVNOF0YJu6+aQoP+AVTgGNb+l7vbaawRD1AUSeDC+KH7spXkkxlmngQjtC
         0qMTnRNR0dl+pIa4xfQLNOnzmRu63HN7kteWe99v/u4vD1X7xJKQcw1poRbgpbuoAzLN
         X9zGQNSsyQ+b8eCAEXbuM5mYdvsOfNjQMdHNwisrYYox25KvKqvJsLGshcWRpvUC6jDv
         +Djw==
X-Gm-Message-State: ACrzQf3eO9u8iL0cF5kHsl3XFqUACevBuYacVrLZNDBKmvxY4XJ0tZeA
        wW5bTEOwD3Jav99imoG1t/u3gJA+yOnbwJPturanjugyg6hbHNbXfCpUgA7UcaSUzigVB5f2OdK
        ZhpL5ugtC5LQ3
X-Received: by 2002:ac8:5058:0:b0:3a5:3cb0:959 with SMTP id h24-20020ac85058000000b003a53cb00959mr32919858qtm.123.1667988642846;
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7zaE5m+054WqSltDiseEsHQRGbV23se1lE6TQwdYPc3zaWSm4fkB44f0GuQqZbDqR+b7Kc9w==
X-Received: by 2002:ac8:5058:0:b0:3a5:3cb0:959 with SMTP id h24-20020ac85058000000b003a53cb00959mr32919847qtm.123.1667988642628;
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
Received: from redhat.com ([185.195.59.52])
        by smtp.gmail.com with ESMTPSA id r4-20020ae9d604000000b006fa2b1c3c1esm10651656qkk.58.2022.11.09.02.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
Date:   Wed, 9 Nov 2022 05:10:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
Message-ID: <20221109051030-mutt-send-email-mst@kernel.org>
References: <20221108103437.105327-1-sgarzare@redhat.com>
 <20221108103437.105327-3-sgarzare@redhat.com>
 <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
 <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022 at 09:18:23AM +0100, Stefano Garzarella wrote:
> On Wed, Nov 09, 2022 at 11:28:41AM +0800, Jason Wang wrote:
> > On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > 
> > > vhost_iotlb_itree_first() requires `start` and `last` parameters
> > > to search for a mapping that overlaps the range.
> > > 
> > > In translate_desc() we cyclically call vhost_iotlb_itree_first(),
> > > incrementing `addr` by the amount already translated, so rightly
> > > we move the `start` parameter passed to vhost_iotlb_itree_first(),
> > > but we should hold the `last` parameter constant.
> > > 
> > > Let's fix it by saving the `last` parameter value before incrementing
> > > `addr` in the loop.
> > > 
> > > Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > 
> > > I'm not sure about the fixes tag. On the one I used this patch should
> > > apply cleanly, but looking at the latest stable (4.9), maybe we should
> > > use
> > > 
> > > Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
> > 
> > I think this should be the right commit to fix.
> 
> Yeah, @Michael should I send a v2 with that tag?

Pls do.

> > 
> > Other than this
> > 
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > 
> 
> Thanks for the review,
> Stefano

