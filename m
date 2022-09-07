Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462835AFB4E
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiIGE2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 00:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIGE2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 00:28:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC7B8C005
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662524882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4j6Q+BCgruPfdfNoIE3/wZJYX17HQyjtjOota9ARPcM=;
        b=Mq/iGyDvDlXkg4a2ZVvdV4zhUEarHJedJBmOZKDuerSfKsGj+zazn3yKNHqjoqxwLGXFbA
        TMNjY3oMWXloZGL53AhoFEtRvYr18DIQdwrYzpjNGAoTW6ursLeSZBDVMnRoxx3wy4OAYW
        wwn6m4pQqKUFu/1EsW8Nbq8bhCuz0nA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-n0twa3vDP2uWlxm-XCE-Ng-1; Wed, 07 Sep 2022 00:27:55 -0400
X-MC-Unique: n0twa3vDP2uWlxm-XCE-Ng-1
Received: by mail-pf1-f199.google.com with SMTP id x25-20020aa79199000000b005358eeebf49so6910849pfa.17
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 21:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4j6Q+BCgruPfdfNoIE3/wZJYX17HQyjtjOota9ARPcM=;
        b=gmiO6CpNgqFA8ncu7CQd6Mngn799oSPIEyPYkXCbfqzVmM/TYRQ1wbunHW1EfjAHw3
         RJ4k/orwO9QRqzHgSMoY24MoHU9Fn02JiUJxmR+UNiT6Upcq9Q8yEY/0N3BDGe5mzyFm
         aj6k6NINdix62kIV0M7aKcsKyRFQ/dhr1UzRrnH2oDztZP+3v7n4RfIsIUP3ANTF6P0i
         Ppy6Y55Pmu9lzR1AMIQyDYrzGWX5Ws3RK0AEV2MRerBfgqAV9VQuKvwr31R/10jZdcdp
         87I5Y6ZFjiBfL+mqJS7e18a+Ayb4SRK6vfHPkm/hacmOCKTEWOSXAVZOQfftwJ5BzYtJ
         yJJw==
X-Gm-Message-State: ACgBeo2wMi2iNadJOFKS67WJFkfBLBMNQFJyw9gqIrOrWZYMuKshSmab
        4//1hqvahZPhYQ/k+Fd8/oX2HujwtfiudOD5NQ9ygSP/MwVi6fJVEBUQLt1xVXiH0ENDaU/B4Gb
        xtglCRjEoGL0k
X-Received: by 2002:a05:6a00:ad1:b0:530:2cb7:84de with SMTP id c17-20020a056a000ad100b005302cb784demr1905276pfl.3.1662524874247;
        Tue, 06 Sep 2022 21:27:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7P5ZyRAOSvxlEfTBlfyhp+ATcHkzoRBcyq3eWnpZwM/6/JJA/8FKFnJZ8VB0LxM3ySljdcsQ==
X-Received: by 2002:a05:6a00:ad1:b0:530:2cb7:84de with SMTP id c17-20020a056a000ad100b005302cb784demr1905253pfl.3.1662524873918;
        Tue, 06 Sep 2022 21:27:53 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u1-20020a632341000000b0042a6dde1d66sm7922152pgm.43.2022.09.06.21.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 21:27:53 -0700 (PDT)
Message-ID: <ff96c12e-95cb-be57-9b5b-2da08b0630c6@redhat.com>
Date:   Wed, 7 Sep 2022 12:27:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v3 3/7] vsock: batch buffers in tx
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
 <20220901055434.824-4-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901055434.824-4-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/9/1 13:54, Guo Zhi 写道:
> Vsock uses buffers in order, and for tx driver doesn't have to
> know the length of the buffer. So we can do a batch for vsock if
> in order negotiated, only write one used ring for a batch of buffers
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vsock.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 368330417bde..e08fbbb5439e 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -497,7 +497,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>   	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
>   						 dev);
>   	struct virtio_vsock_pkt *pkt;
> -	int head, pkts = 0, total_len = 0;
> +	int head, pkts = 0, total_len = 0, add = 0;
>   	unsigned int out, in;
>   	bool added = false;
>   
> @@ -551,10 +551,18 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>   		else
>   			virtio_transport_free_pkt(pkt);
>   
> -		vhost_add_used(vq, head, 0);
> +		if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> +			vhost_add_used(vq, head, 0);


I'd do this step by step.

1) switch to use vhost_add_used_n() for vsock, less copy_to_user() 
better performance
2) do in-order on top


> +		} else {
> +			vq->heads[add].id = head;
> +			vq->heads[add++].len = 0;


How can we guarantee that we are in the boundary of the heads array?

Btw in the case of in-order we don't need to record the heads, instead 
we just need to know the head of the last buffer, it reduces the stress 
on the cache.

Thanks


> +		}
>   		added = true;
>   	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>   
> +	/* If in order feature negotiaged, we can do a batch to increase performance */
> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && added)
> +		vhost_add_used_n(vq, vq->heads, add);
>   no_more_replies:
>   	if (added)
>   		vhost_signal(&vsock->dev, vq);

