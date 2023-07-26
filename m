Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B1763EAD
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 20:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjGZSjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 14:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjGZSjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 14:39:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC85269E
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690396699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ZkfxuuQUI6WS1OsCy4f4xk/TS/NLkS7ZKlAlhCGBD4=;
        b=eRb5MtvGXI6/Lv39T0OoIG3Y3MGqsLd1TqqZ3LCTSJXV8WSrpi6FBUD902MZYZ49uyDOjs
        MRjdTXx33v8sjHZZiNWdlqnPm1OkW851TET7kx485YBHAUy66jCDcrzt7bqdPXt5/21HX/
        qvX8aNxVzbS+Ez4JMOntRtS2UE3QPew=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-r_P91dyGObGca9xUg9ybYg-1; Wed, 26 Jul 2023 14:38:17 -0400
X-MC-Unique: r_P91dyGObGca9xUg9ybYg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b9ba3d6191so380111fa.2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 11:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690396696; x=1691001496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZkfxuuQUI6WS1OsCy4f4xk/TS/NLkS7ZKlAlhCGBD4=;
        b=Y8alyQ1Gq9GCsu/jG92t+7bMrnwYoE8v0LPsYENTvzBDjQzvwlUZ3a5JR22w+01sJp
         rQsAxgYW7nw6egwPPfznYivUl1WChCRe6eBzoxdgxLfvMgKyb2ajKAwW/qnaVXoTXRL+
         1oyvO/iYE6x6mmP7RuLY697QAnfSo6ThoxWehh0i5kX4RMUK0aux32+kXGjgmzJnWi7C
         lVWuzlpYc0RUYb+jbAfkzFEvNdP0E5fxTVs14/pbqWbC66iTcxoyrADu7GiQN8ODQWC8
         LX2wgV0EUvr/0/ahAGetWeUzaBZ91KhANedP8ZIKG3Rb25fZ0edj0CtKaST76dIrsKT/
         OwMA==
X-Gm-Message-State: ABy/qLY/pPla8P51eQNDW6SInF4UjIa9F3JR+ct5vP4ZcIrrOeZEAf+/
        il6q+VOjiG3XmClSkYJM0tgJ74LVKJONymSJSODmSs6b3FvZxC6kz1qWB0NfU6dGOa5TPBUZg8l
        LDIQmup7AYoIv
X-Received: by 2002:a05:6512:32aa:b0:4fe:d9e:a47 with SMTP id q10-20020a05651232aa00b004fe0d9e0a47mr2160150lfe.69.1690396696358;
        Wed, 26 Jul 2023 11:38:16 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGrmEcx/kJue2Mk0wlq5n2w2uLYFHBteYJyc3Ij9fkV7DF4dbhcJqImI+mNTHeim2phb5ANfA==
X-Received: by 2002:a05:6512:32aa:b0:4fe:d9e:a47 with SMTP id q10-20020a05651232aa00b004fe0d9e0a47mr2160137lfe.69.1690396695997;
        Wed, 26 Jul 2023 11:38:15 -0700 (PDT)
Received: from redhat.com ([2.52.14.22])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906380200b0099b6becb107sm8669173ejc.95.2023.07.26.11.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 11:38:14 -0700 (PDT)
Date:   Wed, 26 Jul 2023 14:38:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v5 10/14] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <20230726143736-mutt-send-email-mst@kernel.org>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230413-b4-vsock-dgram-v5-10-581bd37fdb26@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v5-10-581bd37fdb26@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 12:50:14AM +0000, Bobby Eshleman wrote:
> This commit adds a feature bit for virtio vsock to support datagrams.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  include/uapi/linux/virtio_vsock.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 331be28b1d30..27b4b2b8bf13 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -40,6 +40,7 @@
>  
>  /* The feature bitmap for virtio vsock */
>  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
> +#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
>  
>  struct virtio_vsock_config {
>  	__le64 guest_cid;

pls do not add interface without first getting it accepted in the
virtio spec.

> -- 
> 2.30.2

