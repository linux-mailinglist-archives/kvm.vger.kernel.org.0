Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA74C6CFDAC
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjC3IEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjC3IDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499E16A40
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680163385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmvkK8fYK4TJ5NfFumKVdlTRthgnv0I/fv0iMmHm2zA=;
        b=ZIQFwgudMjjzSftHwkYjOLdI+mbixvYbSIgdLm3d4QJvSW06AOfYJ3XrVS7/wC1VHY4MCr
        gMmJKLIp0Co397NdriGynuLX1SYM4hngJ9CgypRcIxxajTWKQfZ6KGvet6p9F++wqu9jN5
        3HFAbhLrHrj5KzHxPVK3FktLWAibvEA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-n04fnG-zPSaEpnoCuVSCfA-1; Thu, 30 Mar 2023 04:03:03 -0400
X-MC-Unique: n04fnG-zPSaEpnoCuVSCfA-1
Received: by mail-qk1-f198.google.com with SMTP id 206-20020a370cd7000000b007467b5765d2so8574348qkm.0
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680163383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmvkK8fYK4TJ5NfFumKVdlTRthgnv0I/fv0iMmHm2zA=;
        b=qwbRTMZzJ4iPEMuCTS8GxQoeVvL7+Wn6cPPT+8sE7bsdj286+KRJEYhoJxfWVlAaax
         xX3WSt5fVAyHUKZk7revNQLy0u/4aw1tXdo0asimKNBe/kkCXYRPSmfhvu/fUGtmxKUX
         LKrx0xgfOIhV8Esy8++I1h6ptOMfR5djO6fTkHMb6w6lOK871625SCMfY789RYSL3WD3
         I5k+08aOgk/y/ymAWpIOZq9//27sACIToee/yTsF8l1m9nVlssSaujqaalafD7/hFilt
         yrhwYT0Gq46fKvrbOvv88PaNlK7oDagptVRqc/jcNCcl9Z1YfVMtkE5OLYN62QAWrZYJ
         98WA==
X-Gm-Message-State: AAQBX9dpOuP3L/4P8WJg7Q3tJ7wIqK0EI9cjVaFcco3jG06RdDZ1lFfV
        Y/mEFNxqpMtdbvL9fwvLtSXM5rXF3krxwgW9HfnZZUbn9YflrC2Rp+Z2ejpQmmvkZ8MnuY7XoFY
        OgXh++oVaKx6r
X-Received: by 2002:ad4:5dcd:0:b0:5a9:c0a1:d31a with SMTP id m13-20020ad45dcd000000b005a9c0a1d31amr32511899qvh.49.1680163383480;
        Thu, 30 Mar 2023 01:03:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350b/24uAmv6SuUb1n6/2cdmqOMqi4TQbiOPJWGZJaeeZPx69yK8YzSEPOHSxImFh4Y41wpxtEg==
X-Received: by 2002:ad4:5dcd:0:b0:5a9:c0a1:d31a with SMTP id m13-20020ad45dcd000000b005a9c0a1d31amr32511878qvh.49.1680163383217;
        Thu, 30 Mar 2023 01:03:03 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id mh2-20020a056214564200b005dd8b934582sm5197140qvb.26.2023.03.30.01.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 01:03:02 -0700 (PDT)
Date:   Thu, 30 Mar 2023 10:02:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com, pv-drivers@vmware.com
Subject: Re: [RFC PATCH v2 1/3] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <p64mv3f2ujn4uokl5i7abhdbmed3zy2lrozqoam3llcf4r2qkv@gmyoyikbyiwj>
References: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
 <b910764f-a193-e684-a762-f941883a0745@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b910764f-a193-e684-a762-f941883a0745@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 10:05:45AM +0300, Arseniy Krasnov wrote:
>This removes behaviour, where error code returned from any transport
>was always switched to ENOMEM. This works in the same way as:
>commit
>c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>but for receive calls.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

We should first make sure that all transports return the right value,
and then expose it to the user, so I would move this patch, after
patch 2.

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 5f2dda35c980..413407bb646c 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2043,7 +2043,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>
> 		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
> 		if (read < 0) {
>-			err = -ENOMEM;
>+			err = read;
> 			break;
> 		}
>
>@@ -2094,7 +2094,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>
> 	if (msg_len < 0) {
>-		err = -ENOMEM;
>+		err = msg_len;
> 		goto out;
> 	}
>
>-- 
>2.25.1
>

