Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A575971690A
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjE3QSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjE3QSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:18:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF362127
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685463431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PXXxKnRvMOF+CPjYfKEygZupqtBPL6uEzDsFClnEJ3U=;
        b=dvgYvcBLbTGFSyjk5z8hb7BwSPwXD2ZtVHYQDxemzQLVmu/GLve97kyR63B1uYprT9SEaS
        ZsyoTm/JZfKFYjAD3Q8Dtrddp2TjzjOIyeWGbZIGwk3sMl6PUmgApQsBZ2DyIWte9OFNDQ
        a8q7caySfQNfn1hpokUJAFFns/DJk2c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-zulDb4vtNGqdNztBKFxc_A-1; Tue, 30 May 2023 12:17:07 -0400
X-MC-Unique: zulDb4vtNGqdNztBKFxc_A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f604687a23so20693325e9.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685463426; x=1688055426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXXxKnRvMOF+CPjYfKEygZupqtBPL6uEzDsFClnEJ3U=;
        b=CAo9m0RcGmZpDZSUqVzCZY57hsSdbn8jWyAfJ0LkdxVLXqY9wNCi21M1O9LdGYNQey
         uRIDrU/7ZmTSXkCg665VDvJuVtgO1lwBz8W1CpaIoRn9Yri4sr/7Ta4P3rNMOgMtI0Ov
         Ma5ssM4GMvUyjoHIcy6lTr/gbtlbBqn7ZwDfY3PgxT39KW8zYYify6Vw9W5oiERHkfg/
         A4v2XAFXxhP36IGazUB0Guf7V6vuN9sy9x9CM4SAIMKawAfbxpERSB4MneI25MbYFoPs
         rCIWVoS5bZXz4/pYC0JcHOp0+AzbkL8UxA+5XP3zqJ7I33hTbHP40c2dUqYl6pHT1Ouy
         EwHQ==
X-Gm-Message-State: AC+VfDzhOez/O98Q5CIzVHtv7UgN7HvsLtI/IMzyYmmkl5zPu/FSG0KO
        TjAcaoYkP9O/lN7hhCYJwLj1lTbek3kHVCh49/RmMCVcJjKI7fnQ3pLDZl0axWQsaqBrL9Y1ZlZ
        aVWn1mAqVW0e+
X-Received: by 2002:a05:600c:3787:b0:3f6:1e6:d5a2 with SMTP id o7-20020a05600c378700b003f601e6d5a2mr1912245wmr.4.1685463426375;
        Tue, 30 May 2023 09:17:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6JJkBsRON0rkAHj+JwffsCltg3bPYMz+mQckZWzt5fCsTTE3DG9uwIij60afTolUjor/lsmQ==
X-Received: by 2002:a05:600c:3787:b0:3f6:1e6:d5a2 with SMTP id o7-20020a05600c378700b003f601e6d5a2mr1912237wmr.4.1685463426114;
        Tue, 30 May 2023 09:17:06 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id f10-20020a7bc8ca000000b003f42ceb3bf4sm17673875wml.32.2023.05.30.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 09:17:05 -0700 (PDT)
Date:   Tue, 30 May 2023 18:17:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 11:09:09AM -0500, Mike Christie wrote:
>On 5/30/23 11:00 AM, Stefano Garzarella wrote:
>> I think it is partially related to commit 6e890c5d5021 ("vhost: use
>> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: move
>> worker thread fields to new struct"). Maybe that commits just
>> highlighted the issue and it was already existing.
>
>See my mail about the crash. Agree with your analysis about worker->vtsk
>not being set yet. It's a bug from my commit where I should have not set
>it so early or I should be checking for
>
>if (dev->worker && worker->vtsk)
>
>instead of
>
>if (dev->worker)

Yes, though, in my opinion the problem may persist depending on how the
instructions are reordered.

Should we protect dev->worker() with an RCU to be safe?

>
>One question about the behavior before my commit though and what we want in
>the end going forward. Before that patch we would just drop work if
>vhost_work_queue was called before VHOST_SET_OWNER. Was that correct/expected?

I think so, since we ask the guest to call VHOST_SET_OWNER, before any
other command.

>
>The call to vhost_work_queue in vhost_vsock_start was only seeing the
>works queued after VHOST_SET_OWNER. Did you want works queued before that?
>

Yes, for example if an application in the host has tried to connect and
is waiting for a timeout, we already have work queued up to flush as
soon as we start the device. (See commit 0b841030625c ("vhost: vsock:
kick send_pkt worker once device is started")).

Thanks,
Stefano

