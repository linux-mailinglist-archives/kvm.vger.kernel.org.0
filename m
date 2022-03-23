Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445254E5B4D
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345255AbiCWWix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345242AbiCWWiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25DC48FE70
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648075038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GCO9kWmcJK/zqnHuqkvNPWBBfJrDpoSVizCjP9r818U=;
        b=ECsxb5oP0MuPpqBuv41RL1SgHAgDY6Jd3azPbpv0b0VjJnjNGsnJcrqp2HLRep4moPyzqs
        o5IoEkXV91bhgikU6Py+g+svCznyIbQs5yLJeBglUgrjwDa6zisHaXRsmuBhkBADHMQh6T
        UUJpx2PQud9Z0edaGW8JuMCKEQwApS8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-vr0zUBhqOnGh8zozvqfmPg-1; Wed, 23 Mar 2022 18:37:17 -0400
X-MC-Unique: vr0zUBhqOnGh8zozvqfmPg-1
Received: by mail-wm1-f71.google.com with SMTP id f19-20020a7bcd13000000b0038c01defd5aso1023876wmj.7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GCO9kWmcJK/zqnHuqkvNPWBBfJrDpoSVizCjP9r818U=;
        b=XlXJbem8IiTYMPY965VFfBKyibV0c/GQZJQpgkhTyJ4hBrZyxTpTzJ4AIi8N3eGNr9
         pc6f5Bbd0tBuKcvH3ToAUH/fsVeGl+SN0agRLKy5QNBvoRNWPt/0y7/B0ki95bC+aBCS
         nVlIzYSn2zybRhgaTOFKBOkZqhyNIvHZuqRhhsaDo6NZNotbCEz6dIXFG3P+ouum2mla
         CzTzJQYvqjNk/iur8hRuTNV/3G+Gdv5gBXzOZcQyMrLQ4B6x9P+HpnyezQ/IBAxcehC9
         pWKZuIBMW/dLIxJBxzbAZYupwrBtc57iJQVEjGvAM5zcuMhVIIdGlHaaA367LZDviVYN
         dFTQ==
X-Gm-Message-State: AOAM531dEwGXX8IepHMszx6jubBHvS08agbCz/KdyPeUCz69lxdX4J9V
        SIoH6ulpHe8k55SB+rtBc/9P4gmecI0g7btH59bkWuUESZTatoWYYRSpft9NK08rsXQ2EuAoPqq
        KI52Eahhib1Qa
X-Received: by 2002:adf:9dc3:0:b0:205:7bf0:669f with SMTP id q3-20020adf9dc3000000b002057bf0669fmr1944324wre.4.1648075036542;
        Wed, 23 Mar 2022 15:37:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf4BMQJkf+iGF0bxSMIgVNRplbXP5vi6oAc/EcslZHs0qUwYj6/T80KpKvYkRJT0LDAxm8Pw==
X-Received: by 2002:adf:9dc3:0:b0:205:7bf0:669f with SMTP id q3-20020adf9dc3000000b002057bf0669fmr1944308wre.4.1648075036322;
        Wed, 23 Mar 2022 15:37:16 -0700 (PDT)
Received: from redhat.com ([2.55.151.118])
        by smtp.gmail.com with ESMTPSA id a18-20020a05600c349200b0038ca453a887sm4944273wmq.19.2022.03.23.15.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:37:15 -0700 (PDT)
Date:   Wed, 23 Mar 2022 18:37:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323183657-mutt-send-email-mst@kernel.org>
References: <20220323173625.91119-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 06:36:22PM +0100, Stefano Garzarella wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
> 
> The patch order should simplify backporting in stable branches.


Series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> v3:
> - re-ordered the patch to improve bisectability [MST]
> 
> v2: https://lore.kernel.org/netdev/20220323084954.11769-1-sgarzare@redhat.com/
> v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/
> 
> Stefano Garzarella (3):
>   vsock/virtio: initialize vdev->priv before using VQs
>   vsock/virtio: read the negotiated features before using VQs
>   vsock/virtio: enable VQs early on probe
> 
>  net/vmw_vsock/virtio_transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> -- 
> 2.35.1

