Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F80542818
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 09:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiFHHHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 03:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353901AbiFHGSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 02:18:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D499619D633
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 23:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654668130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UsmRmrmyC0YlUnFIqRRJkIZ3ojsOtC4OxRQHrbODTWU=;
        b=b/0HxF6hyrN5DTnKpRWi0yAsVB0KrkdBid+kkziRbBamTSKdCq/zdGkII/npka6kNA2VlR
        FnOYGhM7wZrI7jNMB0nzjYMyuwqqE0+hD2HhrHT8F+FT/A+xJl57+PelRb0omCLc2e/DLl
        sCvK+gA2tIv+bVH/HcHmfkteMeJtfRA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-4vgFS01hOWOUZj9mmoXDMw-1; Wed, 08 Jun 2022 02:02:06 -0400
X-MC-Unique: 4vgFS01hOWOUZj9mmoXDMw-1
Received: by mail-wm1-f69.google.com with SMTP id bg7-20020a05600c3c8700b0039468585269so6637022wmb.3
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 23:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UsmRmrmyC0YlUnFIqRRJkIZ3ojsOtC4OxRQHrbODTWU=;
        b=tCDqiA5/ex7OUncclWDOJASnLquGxTlmkBPlg3CIxGj44/iYASvBtagXegkSW+qbWj
         rjMp9pGRD9kUz0ZOAbaU4B80hVEfJqQRvR6NraFub1Yvp1ZHXCfhDtpl8B8JWnkSCkcQ
         KPPC0ruPk8VTuc2VjPFsh6G7fTfhqOGg+EBElB1jErD++SD4DGIq9QBusBt1xBnodgUt
         rA3+zZsD5QRxLTwpYvqI1oTknQX/Nl11L1hWDpzwz9AAJzXgx4bNdVztcbj5ba19csXZ
         +6bZ2ImiIhsMeNJyv3mx+wkTfvJLirBaadPrQJR8owcJRzb5JgD2Ao7KEnn+qnUHBsVz
         UjLA==
X-Gm-Message-State: AOAM533h9gM4uyzjyJjd5000J9iWsG5CPwM3V7932h35QbtiVa2IOiRd
        y5dEeTZ0bkicvf8zHoX7EYGgEfubXIAFM5XxggGS40hD6GK726vaSlWU8fJ4D+4TC1keS51cM0x
        wgCQd93OPWbYa
X-Received: by 2002:a05:6000:147:b0:214:7d6e:cb1d with SMTP id r7-20020a056000014700b002147d6ecb1dmr24578567wrx.650.1654668125050;
        Tue, 07 Jun 2022 23:02:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHgUMf0DiGTalylNFpQjB5EiBfIrRc71DZVAGtXhPU6EUyeZBdyPoZS/71mmMYC1pA8jBi1g==
X-Received: by 2002:a05:6000:147:b0:214:7d6e:cb1d with SMTP id r7-20020a056000014700b002147d6ecb1dmr24578561wrx.650.1654668124893;
        Tue, 07 Jun 2022 23:02:04 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-114-66.web.vodafone.de. [109.42.114.66])
        by smtp.gmail.com with ESMTPSA id x14-20020adff0ce000000b00210396b2eaesm24124187wro.45.2022.06.07.23.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 23:02:04 -0700 (PDT)
Message-ID: <1bdd501e-01f6-a0fb-86f3-49ec19ec5bcf@redhat.com>
Date:   Wed, 8 Jun 2022 08:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v9 21/21] MAINTAINERS: additional files related kvm s390
 pci passthrough
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
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-22-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220606203325.110625-22-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/2022 22.33, Matthew Rosato wrote:
> Add entries from the s390 kvm subdirectory related to pci passthrough.
> 
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6d3bd9d2a8d..3dd8657f5482 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17454,6 +17454,7 @@ M:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported
> +F:	arch/s390/kvm/pci*
>   F:	drivers/vfio/pci/vfio_pci_zdev.c
>   F:	include/uapi/linux/vfio_zdev.h
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

