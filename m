Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D7B7194F0
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 10:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjFAIBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 04:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjFAIAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 04:00:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500011B4
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 00:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685606342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TS9b3RiFkUpCZDdrYBHho5/2B8BOEzYrjzr41mSr/Ds=;
        b=cPtNYOLSLfv4FWlY5+YO+MnFpW/ONWD7pxxB13FsNly1SDGEPaCcIjzrVMbSlid5Fa+KSo
        oIW9ZzmsnONClB9XYDFY1lP0HXUyueHlbJRBHklgRLdz6VE6wzgklMa3YS2vDVauZN6RHk
        25wF6DQP3NuxYGmh3Y7Fxr0qzsbiJZE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-lkDKdT2LO2aRHrNlPxG8Yw-1; Thu, 01 Jun 2023 03:58:57 -0400
X-MC-Unique: lkDKdT2LO2aRHrNlPxG8Yw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-96f6fee8123so32521966b.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 00:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685606336; x=1688198336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS9b3RiFkUpCZDdrYBHho5/2B8BOEzYrjzr41mSr/Ds=;
        b=TJQAJfJ9TYTgkfyyObpjkp/Xj/eFI7/7sXXqvSzR4f68mb+nYpAMHSo/HJU0hioXBn
         f014W6+TfWKXwyBo505Mv9mgpxzUa3FvMMA3+b+Rt9dk/r5dvmgf/bMymy58TmF0Cfjz
         AqrgPqaCnh9PIv8CH7nvcx+yN0PpzPlSOf1HiR5f/x80j/G+m72w3/AYGTJwvbUe3w1J
         tOcsk6jRAnvP+rBEaoL4tTo1WAfxFIi/quHYBUumpv+o7/F7n5ntPe7c8rmLWnp6Lhv/
         eDRpZNjOcZlWsK3tKHzJUiBGc5N8h2LCuFHBXNhP3z4h15YIuQ8DqRHoqRwqVO2xCFc/
         zjog==
X-Gm-Message-State: AC+VfDwA5okh3McJGAnK4PZBQgIoY9RJl64ZszmOcsJAJo5p5IguEr3c
        KoqW1w/2XZkMgKG13gBCnuDWj4HQm0vMnTZL8eaSHJgMIKzLRqkJ9Roksap+C8dYdXqep2WVP2k
        t362Nkz1Q1V0g
X-Received: by 2002:a17:907:6d1d:b0:96a:1c2a:5a38 with SMTP id sa29-20020a1709076d1d00b0096a1c2a5a38mr7615760ejc.11.1685606335950;
        Thu, 01 Jun 2023 00:58:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ie3v5LmwvGb/KlhSkOFjqXmTaLy6LzatU5TWS+dAPKf5UfysEeO19vXwVk6f6zCMci8fpbA==
X-Received: by 2002:a17:907:6d1d:b0:96a:1c2a:5a38 with SMTP id sa29-20020a1709076d1d00b0096a1c2a5a38mr7615751ejc.11.1685606335678;
        Thu, 01 Jun 2023 00:58:55 -0700 (PDT)
Received: from sgarzare-redhat ([134.0.3.103])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709064e4500b0096f6647b5e8sm10183211ejw.64.2023.06.01.00.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 00:58:54 -0700 (PDT)
Date:   Thu, 1 Jun 2023 09:58:47 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio/vsock: fix sock refcnt bug on owner set
 failure
Message-ID: <35xlmp65lxd4eoal2oy3lwyjxd3v22aeo2nbuyknc4372eljct@vkilkppadayd>
References: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230531-b4-vsock-fix-refcnt-v1-1-0ed7b697cca5@bytedance.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 07:47:32PM +0000, Bobby Eshleman wrote:
>Previous to setting the owner the socket is found via
>vsock_find_connected_socket(), which returns sk after a call to
>sock_hold().
>
>If setting the owner fails, then sock_put() needs to be called.
>
>Fixes: f9d2b1e146e0 ("virtio/vsock: fix leaks due to missing skb owner")
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index b769fc258931..f01cd6adc5cb 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1343,6 +1343,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>
> 	if (!skb_set_owner_sk_safe(skb, sk)) {
> 		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
>+		sock_put(sk);

Did you have any warning, issue here?

IIUC skb_set_owner_sk_safe() can return false only if the ref counter
is 0, so calling a sock_put() on it should have no effect except to
produce a warning.

Thanks,
Stefano

