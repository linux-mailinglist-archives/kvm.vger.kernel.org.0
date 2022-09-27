Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212DD5ECB88
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 19:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbiI0RtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 13:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiI0Rsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 13:48:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDC71F497F
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 10:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664300734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dVgPwMiQwWxz9qpcaIbF4/j9KUJT2Ui1z93QE0upqV8=;
        b=bStph4NPFsgGIgWlUTgyXLp3osnNpE357f4QSiai8puCO2/TrL7YQ9ootfN5AmNAUD+eDx
        kSAZZ9C4Bye5YTHJ2lvmhxl4lYkonX9En2ngsznPjKd8kUbrh1hbdphmMndRdC1TBz84Ln
        8ZODVxvuYoMEaGPXZ88p0hcPUPYQkHI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60--jz17UjfNNq2bGNYhO8ZGA-1; Tue, 27 Sep 2022 13:45:32 -0400
X-MC-Unique: -jz17UjfNNq2bGNYhO8ZGA-1
Received: by mail-wm1-f71.google.com with SMTP id b5-20020a05600c4e0500b003b499f99aceso8934339wmq.1
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 10:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=dVgPwMiQwWxz9qpcaIbF4/j9KUJT2Ui1z93QE0upqV8=;
        b=OT+L/T/kSi5pC94uNIDq9smbxJKUhI2R4lBmf7Y02m8KTBy/kOa2K7R5BJUtBrDUHv
         6R/pc9qSw1RqMBoqb65XIb9lxXpDhRg8y9QY9ziKOf7acL7ocjraDX10pMr4jFJENOzP
         tQgdbgJxNe4FvYAMjl6ELnH7qqUA+bvB3VnlhNsfPWpA3DWedkDanMDfdysE1QUxtU3F
         BIHjs7QXhjXEcB53aSaTT8iheRxyPdYgs7wWqTxHaTLpL4jhN68AyqcEvaQIPmDA9eui
         wROWBmYWzIXNcWOsxD7cu/8k/eRmDW/VdGH8ATpSA3wUu0M/g0iHLc+2/iivp8eFG1AZ
         YKpw==
X-Gm-Message-State: ACrzQf0XPEBmne8IvHD1ct1C9FSbCc27xxQEpEYvOBbaxBtWhNy+Ao1O
        x0png/e78x70fCiKq1B9atgtGq9dviHioy6cvcjTdxI/m/CIhQpaZjxuZBiU7QXcTpNauF/pWww
        nQtCmcqYqj7al
X-Received: by 2002:adf:fb88:0:b0:22a:f742:af59 with SMTP id a8-20020adffb88000000b0022af742af59mr17905409wrr.230.1664300728149;
        Tue, 27 Sep 2022 10:45:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5dw5UsDHXguGm9oaXaX47AcmjEId0lTIHxp/R1KfCc218J6dp6bwNiLDUfGstPRwVpRhUHWg==
X-Received: by 2002:adf:fb88:0:b0:22a:f742:af59 with SMTP id a8-20020adffb88000000b0022af742af59mr17905376wrr.230.1664300727822;
        Tue, 27 Sep 2022 10:45:27 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id g14-20020adfe40e000000b0022ae8b862a7sm2328616wrm.35.2022.09.27.10.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:45:27 -0700 (PDT)
Date:   Tue, 27 Sep 2022 19:45:21 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <20220927174521.wo5ygmmti2sgwp2d@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220926134219.sreibsw2rfgw7625@sgarzare-redhat>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 03:42:19PM +0200, Stefano Garzarella wrote:
>Hi,
>
>On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
>>Hey everybody,
>>
>>This series introduces datagrams, packet scheduling, and sk_buff usage
>>to virtio vsock.
>
>Just a reminder for those who are interested, tomorrow Sep 27 @ 16:00 
>UTC we will discuss more about the next steps for this series in this 
>room: https://meet.google.com/fxi-vuzr-jjb
>(I'll try to record it and take notes that we will share)
>

Thank you all for participating in the call!
I'm attaching video/audio recording and notes (feel free to update it).

Notes: 
https://docs.google.com/document/d/14UHH0tEaBKfElLZjNkyKUs_HnOgHhZZBqIS86VEIqR0/edit?usp=sharing
Video recording: 
https://drive.google.com/file/d/1vUvTc_aiE1mB30tLPeJjANnb915-CIKa/view?usp=sharing

Thanks,
Stefano

