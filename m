Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042E54CA8D3
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 16:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbiCBPNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 10:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiCBPNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 10:13:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EBB91D0F3
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 07:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646233959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6TNiLFlYcGF3ddTJpMJSNjgDj1FGfe5b4PLw2nW6z80=;
        b=jQx5SxpT5TQyiQro4w3afKwvwxoZT1BFrI7cqo/iNgV73gnyCGtgFpTbb5OQpN6lYLQQJC
        QwGxftEb5WTB4EyS2JteL24dJl1KtRe/JOHYMlwMDQpPucR0UQZ9oUDHR2I8JQcyAOazqU
        FnJrs7jYgcREYpM3zS46esj5wlHHAUw=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-5hmEITpANMee8r3_Nsi2rw-1; Wed, 02 Mar 2022 10:12:38 -0500
X-MC-Unique: 5hmEITpANMee8r3_Nsi2rw-1
Received: by mail-oo1-f70.google.com with SMTP id r4-20020a4abf04000000b0032030c12b39so1412233oop.8
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 07:12:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6TNiLFlYcGF3ddTJpMJSNjgDj1FGfe5b4PLw2nW6z80=;
        b=z2lKgAj43DSDuUxuPaKmO0kVqai48kLEriMjiAYHasa/QPkHJNKV/QgH8qNRRKEno6
         1nTPLnH3OO97MhWrIr5WR42HseIWj2nOkjRlvK9nQZtlba8pw/ro7bM/8HM3ICoBo48y
         2ke3ZGbjdfhs06ZyyLxulH+L6ZQQYiP6jMXYh6K/NMRf3VEfFzU97zKIzJmMYOvvfNOG
         R1iCinR6OQoguGL7S9mFGnW/tBXILXG1M9HBFXqBaG7tepQ84sNCTM/eNRrkYKn4xpH/
         EMU3u+w+mg4ass5OdMvbUCPztRBlqnReWo582o+RBI7qBqv3TkWwmlju01D8BxEayaxY
         XeSg==
X-Gm-Message-State: AOAM532Zbueti6Q/Ukej2D/n/xN6/dUCs8HEmliO/6DDc5bmZOGI2Szl
        aSDXGujbkPSLVLH4rUrXnlQB43zmXo5+CSBOycj2q/KUqBCw0wCF30WI0vujrqOae2olVwrrKXx
        ZYkNvhsjwo1AG
X-Received: by 2002:a05:6830:23b8:b0:5a5:75fd:8f9 with SMTP id m24-20020a05683023b800b005a575fd08f9mr15666160ots.152.1646233957348;
        Wed, 02 Mar 2022 07:12:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUKXcvdMYSNpSDmRV4uh5gtX/gNvk81VHFgaMMwZYft8TCoicAQaumaccPdPuVeKcHQyh9kA==
X-Received: by 2002:a05:6830:23b8:b0:5a5:75fd:8f9 with SMTP id m24-20020a05683023b800b005a575fd08f9mr15666135ots.152.1646233957112;
        Wed, 02 Mar 2022 07:12:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s3-20020a056808208300b002d38ef031d6sm9680263oiw.36.2022.03.02.07.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 07:12:36 -0800 (PST)
Date:   Wed, 2 Mar 2022 08:12:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, vgoyal@redhat.com,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] Allow returning EventNotifier's wfd
Message-ID: <20220302081234.2378ef33.alex.williamson@redhat.com>
In-Reply-To: <20220302113644.43717-2-slp@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
        <20220302113644.43717-2-slp@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  2 Mar 2022 12:36:43 +0100
Sergio Lopez <slp@redhat.com> wrote:

> event_notifier_get_fd(const EventNotifier *e) always returns
> EventNotifier's read file descriptor (rfd). This is not a problem when
> the EventNotifier is backed by a an eventfd, as a single file
> descriptor is used both for reading and triggering events (rfd ==
> wfd).
> 
> But, when EventNotifier is backed by a pipefd, we have two file
> descriptors, one that can only be used for reads (rfd), and the other
> only for writes (wfd).
> 
> There's, at least, one known situation in which we need to obtain wfd
> instead of rfd, which is when setting up the file that's going to be
> sent to the peer in vhost's SET_VRING_CALL.
> 
> Extend event_notifier_get_fd() to receive an argument which indicates
> whether the caller wants to obtain rfd (false) or wfd (true).

There are about 50 places where we add the false arg here and 1 where
we use true.  Seems it would save a lot of churn to hide this
internally, event_notifier_get_fd() returns an rfd, a new
event_notifier_get_wfd() returns the wfd.  Thanks,

Alex

