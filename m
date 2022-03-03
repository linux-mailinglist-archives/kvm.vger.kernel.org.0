Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B25B4CB5A5
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 04:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiCCEAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 23:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCCEAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 23:00:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEB8C157208
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 19:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646279961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JLyYEFbzKazGajr/Z7eLhFc2iDs9PD4fdRAFMZ5Qomk=;
        b=Xo6PY89Xap6AfFQ2FRhWBcsxBlF9R/3gwYuVBP8FX9aeBV2jbKiMy5IQM363sOdr8y7719
        HD6NwEO77xHRf5j4fSEcxgh4OmfCsqKXIf/aUPodKIIenfoCuomJDrLjDd6AErdz6/PhTU
        /7ER9uadbB/BbsI3W+HmkOp2AU+I+AY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-DVf2UjJfMQi_h7miMerRFA-1; Wed, 02 Mar 2022 22:59:20 -0500
X-MC-Unique: DVf2UjJfMQi_h7miMerRFA-1
Received: by mail-pg1-f197.google.com with SMTP id z10-20020a634c0a000000b0036c5eb39076so2104116pga.18
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 19:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JLyYEFbzKazGajr/Z7eLhFc2iDs9PD4fdRAFMZ5Qomk=;
        b=u3ge3JcT7xQaGiXF2ouegky2MN8icztJqwtU/GF0yShuZJpeCTkRzjG8AY9CmsUICb
         KItID6QYlzZJF6OmmiQJT/QWLpWO3MsXv6zykc3DbIUfpgtv2bVUBg+aBkEBxXYfWgf0
         DYFiFrgggs+6tA8ynPVTis/5HQ42ESsTiXB+4PAvsQ1xTlsNV9Bpc4OkecH0ucC33bLn
         jcSXhCx43xGWmSUlhvmsYXuosAkGV/Q8x6YYuMZq16UDeJ1k/idQw88yYty9cdc5nYeu
         2a8SeoRizHmO0qM+r0sIn8PEyugdDEm62Zg0zRlf0szD1DZpbIUqYnsyBe/hv60o5Jz5
         FIww==
X-Gm-Message-State: AOAM533LCTFyYvb/79xRjOsJpSjpo8k82Beh4QVSQ0yLUsTyPkQYa8mm
        gO2nhrJh6u4R+ZVIeRXQl0zebxYsQhgmDWdeg9kX7WzkM4BtECj108RjruVWGEjPHNYjTlDTEHM
        +2FJaIvR0cK2G
X-Received: by 2002:a05:6a00:188f:b0:4e1:a253:850c with SMTP id x15-20020a056a00188f00b004e1a253850cmr36329966pfh.61.1646279959000;
        Wed, 02 Mar 2022 19:59:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZQZtiyN/+eVQIh36yLquJvhShQxa3L1DH/1+/nasdtDZX5ozJfyYacmVoMm56LpbVlK/3mQ==
X-Received: by 2002:a05:6a00:188f:b0:4e1:a253:850c with SMTP id x15-20020a056a00188f00b004e1a253850cmr36329956pfh.61.1646279958700;
        Wed, 02 Mar 2022 19:59:18 -0800 (PST)
Received: from [10.72.13.250] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u11-20020a056a00124b00b004e11307f8cdsm662501pfi.86.2022.03.02.19.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 19:59:18 -0800 (PST)
Message-ID: <276dfdf4-2ee5-b054-4e34-c5c32b99d6d7@redhat.com>
Date:   Thu, 3 Mar 2022 11:59:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net-next] tuntap: add sanity checks about msg_controllen
 in sendmsg
Content-Language: en-US
To:     Harold Huang <baymaxhuang@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO HOST (VHOST)" <kvm@vger.kernel.org>,
        "open list:VIRTIO HOST (VHOST)" 
        <virtualization@lists.linux-foundation.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
References: <20220301064314.2028737-1-baymaxhuang@gmail.com>
 <20220303022441.383865-1-baymaxhuang@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220303022441.383865-1-baymaxhuang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/3/3 上午10:24, Harold Huang 写道:
> In patch [1], tun_msg_ctl was added to allow pass batched xdp buffers to
> tun_sendmsg. Although we donot use msg_controllen in this path, we should
> check msg_controllen to make sure the caller pass a valid msg_ctl.
>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fe8dd45bb7556246c6b76277b1ba4296c91c2505
>
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Harold Huang <baymaxhuang@gmail.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/tap.c   | 3 ++-
>   drivers/net/tun.c   | 3 ++-
>   drivers/vhost/net.c | 1 +
>   3 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..ba2ef5437e16 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1198,7 +1198,8 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
>   	struct xdp_buff *xdp;
>   	int i;
>   
> -	if (ctl && (ctl->type == TUN_MSG_PTR)) {
> +	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
> +	    ctl && ctl->type == TUN_MSG_PTR) {
>   		for (i = 0; i < ctl->num; i++) {
>   			xdp = &((struct xdp_buff *)ctl->ptr)[i];
>   			tap_get_user_xdp(q, xdp);
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 969ea69fd29d..2a0d8a5d7aec 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2501,7 +2501,8 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	if (!tun)
>   		return -EBADFD;
>   
> -	if (ctl && (ctl->type == TUN_MSG_PTR)) {
> +	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
> +	    ctl && ctl->type == TUN_MSG_PTR) {
>   		struct tun_page tpage;
>   		int n = ctl->num;
>   		int flush = 0, queued = 0;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 28ef323882fb..792ab5f23647 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -473,6 +473,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>   		goto signal_used;
>   
>   	msghdr->msg_control = &ctl;
> +	msghdr->msg_controllen = sizeof(ctl);
>   	err = sock->ops->sendmsg(sock, msghdr, 0);
>   	if (unlikely(err < 0)) {
>   		vq_err(&nvq->vq, "Fail to batch sending packets\n");

