Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89289582638
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiG0MRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 08:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiG0MRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 08:17:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDDEE4B0CB
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 05:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658924237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4rTHmFps6imtrmSGc8bdiFcqdRJQxILQMWRRFRNlZ68=;
        b=KuixpPNWOHqiK7BSiaMgrOKSInQUKlXE/c4zordjG+PmUWUqjuk/FUAbXU3zNXxHYFsgu8
        tjzkCmmNVZsWtvQQWjzRhc1BfsvCjP365VsqlZRom80pevoa3lfB2pKnnD59IT1jTTwZ7C
        gqtKz6tuctaODSKgv0FFVwdO2vT/OUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-trFxoRi0Mo6F6cNkSghLLg-1; Wed, 27 Jul 2022 08:17:16 -0400
X-MC-Unique: trFxoRi0Mo6F6cNkSghLLg-1
Received: by mail-wm1-f71.google.com with SMTP id n30-20020a05600c501e00b003a3264465ebso1702409wmr.1
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 05:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4rTHmFps6imtrmSGc8bdiFcqdRJQxILQMWRRFRNlZ68=;
        b=EcuTnI3CsmIF7gfAET2B21LEBcz0fE4+4Pl4wsRYe4C8OIEuaXtDVk5iZp3aSD9ngu
         jMKojZZbDxd+3RygdOwXMeR+BR79kDddXFKhXDyMDmaBwZgSO0BBXLJcIggBLdefirj4
         yuelLhUBQnLw/W0+bRvZC55EbLo8Qjgu5SNSyF69EQeUsKfDDtTnzvejC58oPPxEBgck
         8BlEn9sDbHLDu0r/D3p8JDZ3wqPR2tKBtTpq93AXGYKCOfFtcEt7r7q9PcVsZLiQR889
         EJDK632laBi3fwcJ5yc6uAsGvGufdZj4Ad/ny5Tn1skaPKlf3qqcqRObwtfZNbNywsId
         b2tw==
X-Gm-Message-State: AJIora83/B3TVPsj9wuMHNst54vpGqwtiW1qz7PapQvLeCk5wJxv0MG9
        RmcovMVoh56kp3dcQS2yQoaBNtNRWRs5AspPtKcmBWTSapRZgsWyUsb6M39TVuudSkad6a3HW6t
        XGnawdeF7lz5t
X-Received: by 2002:a5d:5252:0:b0:21e:6e28:a6da with SMTP id k18-20020a5d5252000000b0021e6e28a6damr12304183wrc.100.1658924235598;
        Wed, 27 Jul 2022 05:17:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tD1wktJsEPz3BQ+vGkdusMkfMqeHo1K0hAUvaOWDoC8PIzZXcZgm9U3hnUKpQkGShIiKos+Q==
X-Received: by 2002:a5d:5252:0:b0:21e:6e28:a6da with SMTP id k18-20020a5d5252000000b0021e6e28a6damr12304167wrc.100.1658924235252;
        Wed, 27 Jul 2022 05:17:15 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u9-20020adff889000000b0020fcaba73bcsm16713440wrp.104.2022.07.27.05.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:17:14 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:17:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 1/9] vsock: use sk_rcvlowat to set
 POLLIN/POLLRDNORM
Message-ID: <20220727121709.z26dspwegqeiv55x@sgarzare-redhat>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <aafc654d-5b42-aa18-bf74-f5277d549f73@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aafc654d-5b42-aa18-bf74-f5277d549f73@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 07:56:59AM +0000, Arseniy Krasnov wrote:
>Both bits indicate, that next data read call won't be blocked, but when
>sk_rcvlowat is not 1, these bits will be set by poll anyway, thus when
>user tries to dequeue data,it will wait until sk_rcvlowat bytes of data
>will be available.
>

The patch LGTM, but I suggest you to rewrite the title and commit of the 
message to better explain what this patch does (pass sock_rcvlowat to 
notify_poll_in as target) and then explain why as you already did (to 
set POLLIN/POLLRDNORM only when target is reached).

Thanks,
Stefano

>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..63a13fa2686a 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1066,8 +1066,9 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		if (transport && transport->stream_is_active(vsk) &&
> 		    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
> 			bool data_ready_now = false;
>+			int target = sock_rcvlowat(sk, 0, INT_MAX);
> 			int ret = transport->notify_poll_in(
>-					vsk, 1, &data_ready_now);
>+					vsk, target, &data_ready_now);
> 			if (ret < 0) {
> 				mask |= EPOLLERR;
> 			} else {
>-- 
>2.25.1

