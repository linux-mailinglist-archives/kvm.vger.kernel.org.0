Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA394BEABE
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 20:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiBUS1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 13:27:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiBUS1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 13:27:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35318C7D
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645467997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JZ5IPvV3yb/nAnNH+aq40HHCb2PtQ6O64EyaH6AnGYs=;
        b=TLMp94cimxeF0eLYgW26lJxFD4EWeXxAIHhD9qxtBo29cuTtnaXqEcl5wCiQjzbE5vsAlB
        bnOqlQImT8KDOhllC+JFbNQn1AQJZD8athJWGY3xD+vC/1Q0jO6rPnja+EtntxKpK6ZAUo
        jlLAOnPjY1kJg6jw1EKzyoJCaNw+mog=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-mlIEBVQoNgmE6CXJV94YXQ-1; Mon, 21 Feb 2022 13:26:36 -0500
X-MC-Unique: mlIEBVQoNgmE6CXJV94YXQ-1
Received: by mail-qk1-f199.google.com with SMTP id w4-20020a05620a094400b0060dd52a1445so13035429qkw.3
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 10:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JZ5IPvV3yb/nAnNH+aq40HHCb2PtQ6O64EyaH6AnGYs=;
        b=5nTVl8jefF3brzo95tAA/hV9E78VU47qof5qQJPprCoeolajlM+mX5KMSIcX9xpdDf
         BIcZ6cbwhSpZSATTLFrQKeJeo7BS5+2PYUTsmjSyAq/qm4/nUyUSpxhFN1CWfowcgjgm
         5q7qmnZ34fU/xGS3xGC+vs4Algji3fP9DjtBGtkyXU24PNyLEBXityBjRZJXILby7sm+
         FlhbJsDZtskVVcIJyzA/KfsTaXoBLcgwDa93r3W2z6hXHozjahaIVyo6kCzrxWvNK1UT
         5I78KCJcIZzUMp3cakehEFdVDBypR/UsUhivtA8a8nqLq2OBd7RCSy3H4CSxYiOOTPON
         7cKw==
X-Gm-Message-State: AOAM533+wlN/HY1Oj3hZM+FLnN3hUuAAvbWOLQYbsCQ+KEHWDQnkRK4v
        QLDdGHQcsZ6T/gUACfBUbgF37L7qEVXiR78DfFfNeCQ4lXQTsgPb9N6aAUEV0OJpA2a8jJv2zEZ
        WLuw1JeCQcIRD
X-Received: by 2002:a37:424a:0:b0:47c:cdc:ce63 with SMTP id p71-20020a37424a000000b0047c0cdcce63mr12938102qka.530.1645467994997;
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4Os+URRdB/SGPRTo0xBKVVbUYwpunZIvTXStuObgWhuvPS2PN1PoD2ZEPNCiFy8upFn3MwQ==
X-Received: by 2002:a37:424a:0:b0:47c:cdc:ce63 with SMTP id p71-20020a37424a000000b0047c0cdcce63mr12938089qka.530.1645467994703;
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id c12sm832212qtd.45.2022.02.21.10.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:26:34 -0800 (PST)
Date:   Mon, 21 Feb 2022 19:26:28 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <20220221182628.vy2bjntxnzqh7elj@sgarzare-redhat>
References: <20220221114916.107045-1-sgarzare@redhat.com>
 <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
 <YhO6bwu7iDtUFQGj@anirudhrb.com>
 <20220221164420.cnhs6sgxizc6tcok@sgarzare-redhat>
 <YhPT37ETuSfmxr5G@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YhPT37ETuSfmxr5G@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 11:33:11PM +0530, Anirudh Rayabharam wrote:
>On Mon, Feb 21, 2022 at 05:44:20PM +0100, Stefano Garzarella wrote:
>> On Mon, Feb 21, 2022 at 09:44:39PM +0530, Anirudh Rayabharam wrote:
>> > On Mon, Feb 21, 2022 at 02:59:30PM +0100, Stefano Garzarella wrote:
>> > > On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> > > >
>> > > > vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
>> > > > ownership. It expects current->mm to be valid.
>> > > >
>> > > > vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
>> > > > the user has not done close(), so when we are in do_exit(). In this
>> > > > case current->mm is invalid and we're releasing the device, so we
>> > > > should clean it anyway.
>> > > >
>> > > > Let's check the owner only when vhost_vsock_stop() is called
>> > > > by an ioctl.
>> > > >
>> > > > Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>> > > > Cc: stable@vger.kernel.org
>> > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > > ---
>> > > >  drivers/vhost/vsock.c | 14 ++++++++------
>> > > >  1 file changed, 8 insertions(+), 6 deletions(-)
>> > >
>> > > Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
>> >
>> > I don't think this patch fixes "INFO: task hung in vhost_work_dev_flush"
>> > even though syzbot says so. I am able to reproduce the issue locally
>> > even with this patch applied.
>>
>> Are you using the sysbot reproducer or another test?
>> In that case, can you share it?
>
>I am using the syzbot reproducer.
>
>>
>> From the stack trace it seemed to me that the worker accesses a zone that
>> has been cleaned (iotlb), so it is invalid and fails.
>
>Would the thread hang in that case? How?

Looking at this log [1] it seems that the process is blocked on the 
wait_for_completion() in vhost_work_dev_flush().

Since we're not setting the backend to NULL to stop the worker, it's 
likely that the worker will keep running, preventing the flush work from 
completing.

[1] https://syzkaller.appspot.com/text?tag=CrashLog&x=153f0852700000

