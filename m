Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D728348E88
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 12:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhCYLIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 07:08:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhCYLIh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 07:08:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616670517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKj3N7qjc3wKOxA3NoAZDiYAxmrNm7GOxG509L79+1k=;
        b=cu7S7EHiaulfggoULBC4P4taWnfY/OR6EnUoKO/WN792PjJI4fzLuch2hn/dlD6/F1Kntt
        OKVl8FLVZDRNllWHTLCmxa4/O2NpYGjA2GZwXyUbbIAZhol6X8bWokErwYdeNMaoDqO4sA
        hgWoGtnty2pz+sQgmurf/iAonWYij0Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-PzJuig2fPEGjlhoN1k2Uxw-1; Thu, 25 Mar 2021 07:08:35 -0400
X-MC-Unique: PzJuig2fPEGjlhoN1k2Uxw-1
Received: by mail-wm1-f72.google.com with SMTP id a65so1117434wmh.1
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 04:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fKj3N7qjc3wKOxA3NoAZDiYAxmrNm7GOxG509L79+1k=;
        b=qdW6v/4nBjdo6JXsViq3XWIx8OSwIhcpgBdfSoxherg6gpbcswMbBdkELdGKltgzXj
         Hbyn8KbbQtQ3VPpPX6zcHB7ZUFHtM6jCeeN9UQqd8eZZHiZTbyBcd6W5bkW1LjQY9U0V
         +NGN4CaswKk/7ZvcdElDJhz8cXdJkCDNgDTm2WvjBHe+005y64R0JkwycXXtdrnwGck5
         MiqInTRQjl1aw7RqySgKuASrUbb0uCZCzM35IbXaWSCGRW1xLpNJ8ir29ogRP3y5x8D9
         43Lryuk7NwzggjdghZken+Lsa2f4KwS5ArrOPZ5G72RW1TdiV6VVFhlnq0PCe4NTDe+V
         vLcw==
X-Gm-Message-State: AOAM533PFT5oMpdQmjvC3Zhq5RAe2XUcX7PWEgEdPb3++Pb4zbBCPlFF
        MDeTXBE7GYh1uv0la1MzCuv7skdSsP80T2AQySv+YiYa4DI3/nF7LQ9/53hjAhbNUu0hr+3vZx8
        ZSzxnL+pwJmbH
X-Received: by 2002:a05:600c:204f:: with SMTP id p15mr7394496wmg.165.1616670514584;
        Thu, 25 Mar 2021 04:08:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiEtLL2V7byI4WDi3Jbt4TeRDQzSQxBNNRwTIXQ/L2sd55YH0ycog2gsdgUk7sVz7dGg2BRg==
X-Received: by 2002:a05:600c:204f:: with SMTP id p15mr7394472wmg.165.1616670514357;
        Thu, 25 Mar 2021 04:08:34 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id w22sm5958086wmi.22.2021.03.25.04.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 04:08:33 -0700 (PDT)
Date:   Thu, 25 Mar 2021 12:08:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        parav@nvidia.com, bob.liu@oracle.com, hch@infradead.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 03/11] vhost-vdpa: protect concurrent access to vhost
 device iotlb
Message-ID: <20210325110831.v57e4xg7twzzcu7n@steredhat>
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-4-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210315053721.189-4-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 01:37:13PM +0800, Xie Yongji wrote:
>Use vhost_dev->mutex to protect vhost device iotlb from
>concurrent access.
>
>Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
>Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>---
> drivers/vhost/vdpa.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

