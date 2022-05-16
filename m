Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251C55281AE
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 12:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbiEPKSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 06:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242357AbiEPKSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 06:18:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1369DEB2
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 03:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652696327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OACVO52ZlkJLVKrD7n6wC0HSWrpeefnl2+wSjxpBQF0=;
        b=iuNkgjpTYbGE5CiPWYPNfyRcTobM4TBO2n+pHuvbsTXX1m2hP14Ut5nuQPro3/LhZSdLyD
        MV+m84u0XxmhUnn/x1urDwozuPMm29v+l53aPwLllrvmC//Wm8ZEw/KWqr5uqiDbibLj6C
        /LcoHvMsi7UkD9CZuf90nbg5tk1YZDs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-56ZFq6WpP2OBlfoOb02TcQ-1; Mon, 16 May 2022 06:18:38 -0400
X-MC-Unique: 56ZFq6WpP2OBlfoOb02TcQ-1
Received: by mail-wm1-f71.google.com with SMTP id q128-20020a1c4386000000b003942fe15835so6543313wma.6
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 03:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OACVO52ZlkJLVKrD7n6wC0HSWrpeefnl2+wSjxpBQF0=;
        b=TulupMVEY1WO+qi8lap4kxfBpAe4f/rMBXLzCL1Hh0DiF0EhBRMgp8mEkSr0jbar8/
         OSK5klWmb4d1c4cwPk3LsTkNXO/HZjtMVXl7XwgyNn6CaNJy5HZCS+2P/UHIlZ3WpQeC
         5K/di3j1JOfgJcV6stGcdGvDRyVsKT7lnrZC30cyknCiPoGwLTjNxELBGmYqHdRks9DS
         k2iH3QJnp50Bo3J5D6+Yh/oB6MVXTrqDk8iGIcY62OCAEq+JevHiN87iJNCQvrv3Tvnp
         UOWKtFA4vOyGEcq9APofeAYoRWdoaEBDyw1elxQrOKMNLkK1SbRUGjPriXcuCT7xdDhv
         9Ynw==
X-Gm-Message-State: AOAM531vziTP21sp0CoMnotwZtjU//XY40BdVBn73beqtTkgZ5DMCqse
        COXSlGGAXYOUkuTPKWiETOjmSjb8mG5qompNjkF0xONCjmjeIIoJ2ZetxFggOt4ANawCCPDVCpQ
        WhWTLuH73mJFK
X-Received: by 2002:a7b:c5d0:0:b0:355:482a:6f44 with SMTP id n16-20020a7bc5d0000000b00355482a6f44mr15891215wmk.58.1652696317256;
        Mon, 16 May 2022 03:18:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSQwk16SVnaahPaNGx+BespB0LTg4zYLJuuHiR6B6yKfb6IpUnFfwvGw90G+5SaudWYJ2Tlw==
X-Received: by 2002:a7b:c5d0:0:b0:355:482a:6f44 with SMTP id n16-20020a7bc5d0000000b00355482a6f44mr15891198wmk.58.1652696317047;
        Mon, 16 May 2022 03:18:37 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-178-142.web.vodafone.de. [109.43.178.142])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c1d9300b003942a244ed1sm9612438wms.22.2022.05.16.03.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 03:18:36 -0700 (PDT)
Message-ID: <96d0a6a5-e50f-429e-9616-178ac1d9883a@redhat.com>
Date:   Mon, 16 May 2022 12:18:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 06/22] s390/airq: allow for airq structure that uses an
 input vector
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-7-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220513191509.272897-7-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2022 21.14, Matthew Rosato wrote:
> When doing device passthrough where interrupts are being forwarded from
> host to guest, we wish to use a pinned section of guest memory as the
> vector (the same memory used by the guest as the vector). To accomplish
> this, add a new parameter for airq_iv_create which allows passing an
> existing vector to be used instead of allocating a new one. The caller
> is responsible for ensuring the vector is pinned in memory as well as for
> unpinning the memory when the vector is no longer needed.
> 
> A subsequent patch will use this new parameter for zPCI interpretation.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/airq.h     |  4 +++-
>   arch/s390/pci/pci_irq.c          |  8 ++++----
>   drivers/s390/cio/airq.c          | 10 +++++++---
>   drivers/s390/virtio/virtio_ccw.c |  2 +-
>   4 files changed, 15 insertions(+), 9 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

