Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DED78EFE5
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345882AbjHaPBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 11:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346479AbjHaPBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 11:01:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEA6CD6
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 08:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693494056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vgwa1dB9SPLXrOuebcpc/xedsvZ9jq5rbgcVN4pe9yQ=;
        b=FBuzfSrLRkrWrrPGOFz1Fy1XTwRHN2XVo8JaHnQLVWvrsRcfu0XRXj6EhS5wP1xM9ZVe3r
        IF/+R/OROo4amAdOgt1T/8w/I5ZdZkTpZU5CREFp3edcgvWtsz5wPdvBv8wxb7eSZpeQFO
        85H1qNSFISAATyBQQYpxrgGBaAP9fWk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-22A9lsIjNm-ObuBYtEndWA-1; Thu, 31 Aug 2023 11:00:53 -0400
X-MC-Unique: 22A9lsIjNm-ObuBYtEndWA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a355cf318so68005766b.2
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 08:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693494052; x=1694098852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vgwa1dB9SPLXrOuebcpc/xedsvZ9jq5rbgcVN4pe9yQ=;
        b=RUbRnv1mMJAgPOICO1iaMZQbm7LCyjFc+vyRFv3zcrLKkWYr4e/L8NJei34qb24J9s
         wZZiEyAmELhkDivwRxkwoYsmBeLy9QOnvFkIfnYBN3FO9brDhLviStFQ5hvdQhLNYTkm
         5q4KR/6hN1vk7rj1STIbWyjuPqC6QjzOxxTQFRnEP99TeG9vZsSQjWnls7sfRCQkhrss
         /tghFA5FCumWNwv7Vh3zGjY/YWXIr5v0ehFHsQXpHY6MF9IJnobJeieaDhXQUe44zLzf
         MoNT0iP7ASrsXc/ojZdvIzRKZt7T1pvQ0j9mnd/UPOFb4q3sgIA5ZckdgsbG5YbgQDFP
         gTnA==
X-Gm-Message-State: AOJu0YzfXN1YYnBYyoqgWzGRowbSsUpHZR2SODXL+KbslPkhaUijFowp
        WOgBqpu/IVQPCB1lqL0kj0JO1hRHYxMSVnekMOh7NYakUGQth4cTD8ae3jp7i4FfXVFpC3Eh8dF
        a+SP3V9aYDsaa
X-Received: by 2002:a17:906:5a6f:b0:9a3:c4f4:12dc with SMTP id my47-20020a1709065a6f00b009a3c4f412dcmr4524807ejc.7.1693494052174;
        Thu, 31 Aug 2023 08:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEItJP1c9NKLWMSDU2Fjxe2iKrYoxUCLRWz4/6JWjMqNieHJ8iRQusTIkf8kXERSXMOfiazaw==
X-Received: by 2002:a17:906:5a6f:b0:9a3:c4f4:12dc with SMTP id my47-20020a1709065a6f00b009a3c4f412dcmr4524784ejc.7.1693494051830;
        Thu, 31 Aug 2023 08:00:51 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id rs10-20020a170907036a00b00992b510089asm855137ejb.84.2023.08.31.08.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 08:00:51 -0700 (PDT)
Date:   Thu, 31 Aug 2023 17:00:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
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
Subject: Re: [RFC PATCH v2 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Message-ID: <gqhfmvel7kkglvaco5lnjiggfj57j7ie5erp6vjvfmm5ifwsw5@o2tzqsnvoc7x>
References: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
 <20230826175900.3693844-2-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230826175900.3693844-2-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 26, 2023 at 08:58:59PM +0300, Arseniy Krasnov wrote:
>POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> net/vmw_vsock/af_vsock.c | 3 +++
> 1 file changed, 3 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 020cf17ab7e4..013b65241b65 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			err = total_written;
> 	}
> out:
>+	if (sk->sk_type == SOCK_STREAM)
>+		err = sk_stream_error(sk, msg->msg_flags, err);
>+
> 	release_sock(sk);
> 	return err;
> }
>-- 
>2.25.1
>

