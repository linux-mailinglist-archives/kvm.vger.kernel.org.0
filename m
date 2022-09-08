Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B1D5B20AA
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiIHOhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiIHOhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:37:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FACD021F
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 07:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662647820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wFcDqpqfo5+BlCFcCMK6T6o/K8WN6HmeBg3zPocSOsQ=;
        b=QbIlCjgNx9J2Q77eday2QeT5PwYMI8cKX9Nz+5HimDyXUB5wSYzPcGkleNfZajy1d1AMu+
        AheUGYsTGT0MX79CtWPpaqiLqf4AfKHYTWbXXp/ddUOGTxAKRFcqumPHdAp8mbgjO/8IIi
        nWCTn6RBpob3WAxByef3KwceFSs7Fi0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-yG-U_AhRNdSRfqddutV7Pg-1; Thu, 08 Sep 2022 10:36:59 -0400
X-MC-Unique: yG-U_AhRNdSRfqddutV7Pg-1
Received: by mail-wm1-f69.google.com with SMTP id i133-20020a1c3b8b000000b003b33e6160bdso217955wma.7
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 07:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wFcDqpqfo5+BlCFcCMK6T6o/K8WN6HmeBg3zPocSOsQ=;
        b=OL1/XcfXrVy/Zn36XElmcNdNftJ4VBznQG+qSN1P76UCRLmKA7DdzoRMn4VKKX2Sdt
         Z/pf9kXf+IWWJ94SreaumVujwk7mDKmQndAZHkY/d6ox8w8qHoaoo5BDCQiQgXoQIe1K
         78Jd6Rdcgw6r3XhtTsgoDcvcrmQ3+Ya3ckv4LdFsNdHe1sYUuYwipyCwjjmRPefuZhRw
         S73n5c23SPsllOldQN75FuDsavJyfjSBCa/CBVy42bJhUTkedRbkTQcRMqG40H+QSEIu
         +Y59lPMYlNDYQTkCVdYzJvcxupSSeeQDC9BJa30z1Wxh9kCsyv717FzChH+3vh9V9iHG
         lSmA==
X-Gm-Message-State: ACgBeo3ubTWFXywgtF3KaRTZOTV8BWjaLIvDDf8tVHJM+83EcR4VSPEN
        wgJxQWFhm4zMQT6HysE4njW7X10em+Q/agLOzb6zL1Ti9XPMI5wsE4Kzfsul2veu1AAgscCBXLL
        vxH1MQIR57kKv
X-Received: by 2002:a5d:6da2:0:b0:228:64ca:3978 with SMTP id u2-20020a5d6da2000000b0022864ca3978mr5285530wrs.542.1662647818275;
        Thu, 08 Sep 2022 07:36:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6BEGVkHcFX/ZuPLpySO7WMaIWzsWXcmGzFBbS0MxMsqv14mvHPWdYH6rv4OjZ1+HxLnAXdhw==
X-Received: by 2002:a5d:6da2:0:b0:228:64ca:3978 with SMTP id u2-20020a5d6da2000000b0022864ca3978mr5285510wrs.542.1662647818042;
        Thu, 08 Sep 2022 07:36:58 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id v11-20020a05600c444b00b003a3442f1229sm3131212wmn.29.2022.09.08.07.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:36:56 -0700 (PDT)
Date:   Thu, 8 Sep 2022 16:36:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
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
Subject: Call to discuss vsock netdev/sk_buff [was Re: [PATCH 0/6]
 virtio/vsock: introduce dgrams, sk_buff, and qdisc]
Message-ID: <20220908143652.tfyjjx2z6in6v66c@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <YxdKiUzlfpHs3h3q@fedora>
 <Yv5PFz1YrSk8jxzY@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yv5PFz1YrSk8jxzY@bullseye>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022 at 02:39:32PM +0000, Bobby Eshleman wrote:
>On Tue, Sep 06, 2022 at 09:26:33AM -0400, Stefan Hajnoczi wrote:
>> Hi Bobby,
>> If you are attending Linux Foundation conferences in Dublin, Ireland
>> next week (Linux Plumbers Conference, Open Source Summit Europe, KVM
>> Forum, ContainerCon Europe, CloudOpen Europe, etc) then you could meet
>> Stefano Garzarella and others to discuss this patch series.
>>
>> Using netdev and sk_buff is a big change to vsock. Discussing your
>> requirements and the future direction of vsock in person could help.
>>
>> If you won't be in Dublin, don't worry. You can schedule a video call if
>> you feel it would be helpful to discuss these topics.
>>
>> Stefan
>
>Hey Stefan,
>
>That sounds like a great idea! I was unable to make the Dublin trip work
>so I think a video call would be best, of course if okay with everyone.

Looking better at the KVM forum sched, I found 1h slot for Sep 15 at 
16:30 UTC.

Could this work for you?

It would be nice to also have HyperV and VMCI people in the call and 
anyone else who is interested of course.

@Dexuan @Bryan @Vishnu can you attend?

@MST @Jason @Stefan if you can be there that would be great, we could 
connect together from Dublin.

Thanks,
Stefano

