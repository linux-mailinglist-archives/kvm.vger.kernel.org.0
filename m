Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EF84EA12B
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344202AbiC1UOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbiC1UOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:14:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 422A05373C
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648498343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WqVT3KvgQV+tZRe7WZblIXuVXsuTLMlVvflnQm6HlpY=;
        b=hXqUzzXFgYJSi9c0MOyIaksQouoE75XLqLGntE+GPcB3U29ugyb//WRFh/yFFq++3YCA0h
        OdqsTQgvbtOwcd5AF3N/apclm0J4sX1RZVp2tTC44HJ02Ty9NkW79i63XnQFyen563f1Wl
        LU3kNUde/x9kSGSEgcYJQ594De8RpZc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-LywtZ_YnMW2RfyjH6BAHAg-1; Mon, 28 Mar 2022 16:12:21 -0400
X-MC-Unique: LywtZ_YnMW2RfyjH6BAHAg-1
Received: by mail-io1-f69.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so11126900ioo.0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WqVT3KvgQV+tZRe7WZblIXuVXsuTLMlVvflnQm6HlpY=;
        b=WGxN2y/ci60SrWlKDcTS+nVG9iSLZdI+UmPbgWAsksWNRRFWm3dHnZWiej6uYlPkIe
         TJzyQPqtu2XQ01Q6mdQOqDjwIKCGrSk4a6xBtKujUejmLxaOkE+iwIj2SpX/WHSjKUNv
         az6IuE565XYqYqxuMAl6i39nFcvUWV5aXUdpUhk+WMILTSusehOcccBIVXvaJBLy+vk2
         aUddd+WXyO/bc7YepJOMlFmkgOv40eSXJpb6HdqARdLY54qYFnF92sYKxkA/+TxLdmRt
         DNYX26AG1imcRh+8rj3QkRjt6d3bmLD5sp5kEGjMX9N4O//LwJpLVNHN2nAP41P6kx/Y
         2L5Q==
X-Gm-Message-State: AOAM5335o/0wKsrUyfb4gVYHyJ/N4IfFjE8leqYamUZNDo/2rWB1gnN6
        Kl7DTOpkRxnoChiCaXAdwIc1FU2+fUf7hFomdjZRHVigMeVSmq7Zfe/OiXT6q2MzBM08AbXXdCD
        dsqmW+EcTosky
X-Received: by 2002:a5e:820a:0:b0:649:5b8:d02c with SMTP id l10-20020a5e820a000000b0064905b8d02cmr7471322iom.50.1648498340717;
        Mon, 28 Mar 2022 13:12:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBWieBEZJKb+4gcLO8gWGz0t+u2tDXAulAsD5Gd3ckb0X+PQp44Pjwj/KZIpU70TvWYk/mng==
X-Received: by 2002:a5e:820a:0:b0:649:5b8:d02c with SMTP id l10-20020a5e820a000000b0064905b8d02cmr7471310iom.50.1648498340498;
        Mon, 28 Mar 2022 13:12:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f4-20020a92b504000000b002c21ef70a81sm7949207ile.7.2022.03.28.13.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:12:20 -0700 (PDT)
Date:   Mon, 28 Mar 2022 14:12:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <huangzhichao@huawei.com>, <yechuan@huawei.com>
Subject: Re: [PATCH v6 0/5] optimize the downtime for vfio migration
Message-ID: <20220328141219.5da6e010.alex.williamson@redhat.com>
In-Reply-To: <20220326060226.1892-1-longpeng2@huawei.com>
References: <20220326060226.1892-1-longpeng2@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 26 Mar 2022 14:02:21 +0800
"Longpeng(Mike)" <longpeng2@huawei.com> wrote:

> From: Longpeng <longpeng2@huawei.com>
> 
> Hi guys,
>  
> In vfio migration resume phase, the cost would increase if the
> vfio device has more unmasked vectors. We try to optimize it in
> this series.
>  
> You can see the commit message in PATCH 6 for details.
>  
> Patch 1-3 are simple cleanups and fixup.
> Patch 4 are the preparations for the optimization.
> Patch 5 optimizes the vfio msix setup path.
> 
> v5: https://lore.kernel.org/all/20211103081657.1945-1-longpeng2@huawei.com/T/
> 
> Change v5->v6:
>  - remove the Patch 4("kvm: irqchip: extract kvm_irqchip_add_deferred_msi_route")
>     of v5, and use KVMRouteChange API instead. [Paolo, Longpeng]
> 
> Changes v4->v5:
>  - setup the notifier and irqfd in the same function to makes
>    the code neater.    [Alex]
> 
> Changes v3->v4:
>  - fix several typos and grammatical errors [Alex]
>  - remove the patches that fix and clean the MSIX common part
>    from this series [Alex]
>  - Patch 6:
>     - use vector->use directly and fill it with -1 on error
>       paths [Alex]
>     - add comment before enable deferring to commit [Alex]
>     - move the code that do_use/release on vector 0 into an
>       "else" branch [Alex]
>     - introduce vfio_prepare_kvm_msi_virq_batch() that enables
>       the 'defer_kvm_irq_routing' flag [Alex]
>     - introduce vfio_commit_kvm_msi_virq_batch() that clears the
>       'defer_kvm_irq_routing' flag and does further work [Alex]
> 
> Changes v2->v3:
>  - fix two errors [Longpeng]
> 
> Changes v1->v2:
>  - fix several typos and grammatical errors [Alex, Philippe]
>  - split fixups and cleanups into separate patches  [Alex, Philippe]
>  - introduce kvm_irqchip_add_deferred_msi_route to
>    minimize code changes    [Alex]
>  - enable the optimization in msi setup path    [Alex]
> 
> Longpeng (Mike) (5):
>   vfio: simplify the conditional statements in vfio_msi_enable
>   vfio: move re-enabling INTX out of the common helper
>   vfio: simplify the failure path in vfio_msi_enable
>   Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO
>     migration"
>   vfio: defer to commit kvm irq routing when enable msi/msix
> 
>  hw/vfio/pci.c | 183 +++++++++++++++++++++++++++++++-------------------
>  hw/vfio/pci.h |   2 +
>  2 files changed, 115 insertions(+), 70 deletions(-)
> 

Nice to see you found a solution with Paolo's suggestion for
begin/commit batching.  Looks ok to me; I'll queue this for after the
v7.0 QEMU release and look for further reviews and comments in the
interim.  Thanks,

Alex

