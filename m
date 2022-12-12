Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1BE649F85
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiLLNLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiLLNLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:11:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577BD1276A
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670850616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pgww3P7VivOi/FIBxfkPIAXabbHo6t9kWUrRb+E5jZY=;
        b=jKa5qDFdEFtCfbBo1EQG9BlaKtKCwpretb/hmFynvAoTzbBBTOihYTWIjWpOKG1pNwlx5g
        yPE+06HJXKj6irIJPDu7fEeiB+G+wjGNqrPeyKwmtTtRy5K6mcS9XgKONBc0rX4qBxWca+
        JXOqIAxslNeGGemddK5Pt8BJw+v+UXc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-101-vmWSX2AnPziI0pO60qa5gA-1; Mon, 12 Dec 2022 08:10:15 -0500
X-MC-Unique: vmWSX2AnPziI0pO60qa5gA-1
Received: by mail-wm1-f71.google.com with SMTP id ay19-20020a05600c1e1300b003cf758f1617so4148793wmb.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:10:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgww3P7VivOi/FIBxfkPIAXabbHo6t9kWUrRb+E5jZY=;
        b=17TCyPRAT/GEbCruzbd8tw9z3RDekwjxLvO5np920ATAac/f9fwBbqx3G5V2rzxrDm
         WPbzwZGPdcEOpuKpObXG/8X/bmWVEo5B9yX/4N5ogpTWIg6qHeEkYx6bXGetZI+m9lHX
         0XGcxNiakzDqopLXz7apLmRRFSxT+/BXBztAdqmadxSCWAd5M18yDW0lCajR651DMHzK
         wQXz34IYKcKc+MduglwwhMF4mxZEXYMmWQQI6fcQnp5wsW/hhbLvffHpXXpd+kr0Acsb
         CjC+qZRCjiGjdYgHN3HFcUPxTICpf4tA9h0CjLv7aBmJXT7GZbWiUmI2DAg+UAuaAOEe
         uVmw==
X-Gm-Message-State: ANoB5pmpU9hL8B2mdvLAQNwtrSoFH35OBUnz1Msu5DX3ziqGlaRe1aZU
        K/9Hiod9usZIu+oL0KN2bqCPnlHWEvoG5pOPEl9hC5shjcqjirRR5RR9X2idi84jfAWQT6eNI8X
        OAM3HpT+5/Vxd
X-Received: by 2002:adf:f205:0:b0:24d:58b3:e55b with SMTP id p5-20020adff205000000b0024d58b3e55bmr5008017wro.22.1670850614237;
        Mon, 12 Dec 2022 05:10:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7OWZ/ougLMGglCtagFz7TqkIUSxpgqX0sWv2cXCfzNusgn/DA3jXTHuPSG+QkujdHkMWAm2A==
X-Received: by 2002:adf:f205:0:b0:24d:58b3:e55b with SMTP id p5-20020adff205000000b0024d58b3e55bmr5008009wro.22.1670850614025;
        Mon, 12 Dec 2022 05:10:14 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id g14-20020adffc8e000000b002421ed1d8c8sm8740554wrr.103.2022.12.12.05.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:10:13 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:10:08 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Ram Muthiah <rammuthiah@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jiang.wang@bytedance.com
Subject: Re: [PATCH 1/1] virtio/vsock: Make vsock virtio packet buff size
 configurable
Message-ID: <20221212131008.aeui7ahq2jp4j33r@sgarzare-redhat>
References: <20210721143001.182009-1-lee.jones@linaro.org>
 <20210722125519.jzs7crke7yqfh73e@steredhat>
 <Y5OQ8jQsK2Dz8tPy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y5OQ8jQsK2Dz8tPy@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 07:48:02PM +0000, Carlos Llamas wrote:
>On Thu, Jul 22, 2021 at 02:55:19PM +0200, Stefano Garzarella wrote:
>> >
>> > +uint virtio_transport_max_vsock_pkt_buf_size = 1024 * 64;
>> > +module_param(virtio_transport_max_vsock_pkt_buf_size, uint, 0444);
>> > +EXPORT_SYMBOL_GPL(virtio_transport_max_vsock_pkt_buf_size);
>> > +
>
>I'm interested on this functionality, so I could take this on.

Great!
We are changing the packet handling using sk_buff [1], so I think it's 
better to rebase on that work that should be merged in net-next after 
the current merge window will close.

>
>>
>> Maybe better to add an entry under sysfs similar to what Jiang proposed
>> here:
>> https://lists.linuxfoundation.org/pipermail/virtualization/2021-June/054769.html
>
>Having a look at Jiang's RFC patch it seems the proposed sysfs node
>hangs off from the main kernel object e.g. /sys/kernel. So I wonder if
>there is a more appropriate parent for this knob?

Agree, what about /sys/devices ?
I would take a closer look at what is recommend in this case.

>
>Also, I noticed that Ram's patch here is using read-only permissions for
>the module parameter and switching to sysfs would mean opening this knob
>up to be dynamically configured? I'd need to be careful here.
>

True, but even if it's changed while we're running, I don't think it's a 
big problem.

Maybe the problem here would be the allocation of RX buffers made during 
the probe. Could this be a good reason to use a module parameter?

Thanks,
Stefano

[1] 
https://lore.kernel.org/lkml/20221202173520.10428-1-bobby.eshleman@bytedance.com/

