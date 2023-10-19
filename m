Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5CA7CECB7
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 02:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjJSAVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 20:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 20:21:35 -0400
X-Greylist: delayed 532 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Oct 2023 17:21:33 PDT
Received: from out-208.mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBE8FE
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 17:21:33 -0700 (PDT)
Message-ID: <f2d0aaad-70ca-4417-bf8e-0d7006be6ebc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697674360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiFGcXBir5895gbTnSvVkUAxBA2ZOAi3wV+AILiCiwU=;
        b=gYDHfis9ygwRm6l48oBXXssrXFtLKWBA7IorJAjoGE8Y7cjSK3C6oXw0KLLLCpy6zE4dCc
        ZDd5n0hHsdxcVwqeXXZddcG8WfkDBsqheECQ//wETBy+XTwaaYas4ig9BUhzqjjEnFnkgT
        OsgHmHHIzL+WgaterzAipWgib/DnH2Y=
Date:   Thu, 19 Oct 2023 01:12:34 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] vsock: initialize the_virtio_vsock before using VQs
Content-Language: en-US
To:     Alexandru Matei <alexandru.matei@uipath.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
References: <20231018183247.1827-1-alexandru.matei@uipath.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20231018183247.1827-1-alexandru.matei@uipath.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 19:32, Alexandru Matei wrote:
> Once VQs are filled with empty buffers and we kick the host, it can send
> connection requests. If 'the_virtio_vsock' is not initialized before,
> replies are silently dropped and do not reach the host.
> 
> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
> ---
>   net/vmw_vsock/virtio_transport.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index e95df847176b..eae0867133f8 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -658,12 +658,13 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>   		vsock->seqpacket_allow = true;
>   
>   	vdev->priv = vsock;
> +	rcu_assign_pointer(the_virtio_vsock, vsock);
>   
>   	ret = virtio_vsock_vqs_init(vsock);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		rcu_assign_pointer(the_virtio_vsock, NULL);
>   		goto out;
> -
> -	rcu_assign_pointer(the_virtio_vsock, vsock);
> +	}
>   
>   	mutex_unlock(&the_virtio_vsock_mutex);
>   

Looks like virtio_vsock_restore() needs the same changes. But
virtio_vsock_vqs_init() can fail only in virtio_find_vqs(). Maybe it can 
be split into 2 functions to avoid second rcu_assign_pointer() in case
of error?

