Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E384973E455
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjFZQL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjFZQLu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:11:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA33C6
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vSj67Bysge00sGJTpLw1MntXa5IUhJN9aBkXlNz5ucg=;
        b=RJWNUAgesIa1ACMU8n4UcrOSPvUROg/wy6/lJnC5ToTIMjK7ET/tOBctAxlht+ax4Gb/am
        g9bQKfTbmCeQU/z1nCDAnWn+0gsQaHsbpHbDEUFwACjomeyu0Xk9HQ2zxQSsDfLeXQKD9C
        m9ZDf7j86AwHX0EAc6vhHGgT2ccUn1E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-YfUNXwsqOZWycNhI1_YAig-1; Mon, 26 Jun 2023 12:11:03 -0400
X-MC-Unique: YfUNXwsqOZWycNhI1_YAig-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-76594ad37fcso139240885a.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795862; x=1690387862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSj67Bysge00sGJTpLw1MntXa5IUhJN9aBkXlNz5ucg=;
        b=boI0MaH0OW7TzkSoiInAhyy3bvMC1wksd1oUCVIe4s24IgVB8HqNvj3EYyRKtqh0sL
         60St4orFb9B0fycFOBOscLlc47Z2gzUfg1x0PKtSJPRpAxOE3Kx8l2vLbndR+K3Cf6dp
         osc+D4tZjleO3eFyGOZ3xofR8dWVK3JbR6SVnMeS3CfStEzSgfaTxxlv0eeU2ZzfC/4X
         oHlwusykuM7PjJA223ziZkujQqfGgfzVABVfwNjZtH0m+NuyHqseTFyTvkl42Hc1MQZr
         LWWbst1urRYgiQ9n3xIbXElnouw4M1ZHofbclln2zYhq0+MLo0UTUtVZG2JozHN9vxwg
         2H8A==
X-Gm-Message-State: AC+VfDxlzcq3cvw+VN3X0oOHqqHkYb0tjNwatlKQi306VbhsTQxVtIjM
        TuXuAIY3nDdeZvtL+tIQuiDvIvldEJVv+250WOC0St2PUOhYldk739dpoPvWLm6BdmqjlRUys5e
        LhUhZp/hFji/j
X-Received: by 2002:a05:620a:4542:b0:75b:23a1:830c with SMTP id u2-20020a05620a454200b0075b23a1830cmr40000794qkp.7.1687795862087;
        Mon, 26 Jun 2023 09:11:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5AAJeVZO0AaDvZksfxGubjZjegdRtILGSI73Wjq9DgEqaoTB4CbROal09UCjmsMp7T1Z9vfA==
X-Received: by 2002:a05:620a:4542:b0:75b:23a1:830c with SMTP id u2-20020a05620a454200b0075b23a1830cmr40000771qkp.7.1687795861845;
        Mon, 26 Jun 2023 09:11:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id c25-20020a05620a11b900b007607324644asm2806347qkk.118.2023.06.26.09.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:11:01 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:10:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 10/17] vhost/vsock: support MSG_ZEROCOPY for
 transport
Message-ID: <cqlp2jr7laleku3reiqf64swlieso6rvi47u5cnlu24kfn3fnm@3x45ihmjox77>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-11-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-11-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 03, 2023 at 11:49:32PM +0300, Arseniy Krasnov wrote:
>Add 'msgzerocopy_allow()' callback for vhost transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> drivers/vhost/vsock.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index b254aa4b756a..318866713ef7 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -396,6 +396,11 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> 	return val < vq->num;
> }
>
>+static bool vhost_transport_msgzerocopy_allow(void)
>+{
>+	return true;
>+}
>+
> static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>
> static struct virtio_transport vhost_transport = {
>@@ -442,6 +447,7 @@ static struct virtio_transport vhost_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+		.msgzerocopy_allow        = vhost_transport_msgzerocopy_allow,

Can we move this after .seqpacket section?

> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>-- 
>2.25.1
>

