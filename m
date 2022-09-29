Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058585EFA6C
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiI2Q1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 12:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiI2Q0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 12:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00835760DB
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664468722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wP+ERui3HiyMQ5txVX6VKAqSsbRuHdNYsyw/tUJPBgg=;
        b=AHanH7k7Vcw7WU8JZm1cyPESs0Q90jD80nFzx6IBZT0butQU9fUuQ5aDKwR0y7TXclTWYL
        CqDtYwIJ3u4iQboQcsG95euefjQDzeexiAJ87uwXLEPGlvocIRaRCUj3CoXg+414ocgdLa
        oXls4ohpBuboNDBEq72s3E3YQIEPHxU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-252-5Q7up9nKMUCpxrK8qIAfmg-1; Thu, 29 Sep 2022 12:25:20 -0400
X-MC-Unique: 5Q7up9nKMUCpxrK8qIAfmg-1
Received: by mail-wr1-f71.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so724469wrg.21
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wP+ERui3HiyMQ5txVX6VKAqSsbRuHdNYsyw/tUJPBgg=;
        b=IWlYuzdByHWOqDzfqaVkWL84yRK7M/3XOUzLCAewA6JAqONWfTpeByvSEtrYrBEMCP
         fxy9DXEQ8o9BoBvBMY9z4NtAehUbVcAgx7ParwEDUFCs1L0M2RnX0cZibWPUIyR3hyce
         mZoeuWZ6UallkE6feNZtcTKvTR4yp075XJ9JfIY68b1N0HwIDyBA1BBYL8iW8AX1iifT
         Ixl/dG32zUcEHSdA6jge1PsGfi6IHIXYDME0u7hWqYoVbP21NVxo7+aeOKQaooH6jEc7
         YrXAB+vkJFOOZZfZvA/PjANl6udWZ0yXVWN+rxku/nVlv6XqWFOGSuot6GQcVXL5vpr3
         yRfA==
X-Gm-Message-State: ACrzQf3YUfa6MbfUSgr7IhH9IFsd3uWfF3YUv6YeH/iWqgr6kcPqE2sH
        X+CQqEg8HUBu+qeIOEArRFuA31e+ma17zLg5We/gltjGZ1VSOvz0VkUoA81OlCW5qzwa98R4QTn
        xK5Fv8UaMN7aL
X-Received: by 2002:a05:600c:3205:b0:3b3:3813:ae3f with SMTP id r5-20020a05600c320500b003b33813ae3fmr3196829wmp.158.1664468719681;
        Thu, 29 Sep 2022 09:25:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7GXSxx1LBarzR7zq6U/e87GpBhC/rEY4V4sODPzyAV8maunzFx+24hSqCxT0BLh73br06cHw==
X-Received: by 2002:a05:600c:3205:b0:3b3:3813:ae3f with SMTP id r5-20020a05600c320500b003b33813ae3fmr3196805wmp.158.1664468719486;
        Thu, 29 Sep 2022 09:25:19 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id t18-20020adfe452000000b00228cd9f6349sm7243877wrm.106.2022.09.29.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 09:25:18 -0700 (PDT)
Date:   Thu, 29 Sep 2022 12:25:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Junichi Uekawa =?utf-8?B?KCDkuIrlt53ntJTkuIAp?= 
        <uekawa@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929122444-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org>
 <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
 <20220929034807-mutt-send-email-mst@kernel.org>
 <20220929090731.27cda58c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929090731.27cda58c@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022 at 09:07:31AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 03:49:18 -0400 Michael S. Tsirkin wrote:
> > net tree would be preferable, my pull for this release is kind of ready ... kuba?
> 
> If we're talking about 6.1 - we can take it, no problem.

I think they want it in 6.0 as it fixes a crash.

