Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDC854282A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 09:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiFHHIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 03:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353286AbiFHGQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 02:16:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E75EA868F
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 23:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654668056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4EmZpbnZG2iGxtLA1wEpmaCgsZIV0Qp3tq0M8QVlG4=;
        b=Ir7Ad9fsKU1Gq7/T2JkDB+IIK3+Zy4UqgIwv1J84RcJT9xo5432ckVBeAay1S6UmzQYLXp
        TCFcU6JwtgdsmwmR5qZfR+r/TERsZwVqS7MWXaaiBMz9eQSGEVvtuhCLgk1TfXxwLfPkG6
        cbf+QkWy6UXPEFzvhZnRgt35zwaDopA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-BeZUp_YENKiRUGDSXOIpMw-1; Wed, 08 Jun 2022 02:00:53 -0400
X-MC-Unique: BeZUp_YENKiRUGDSXOIpMw-1
Received: by mail-wr1-f69.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so4402302wra.15
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 23:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=K4EmZpbnZG2iGxtLA1wEpmaCgsZIV0Qp3tq0M8QVlG4=;
        b=6OqcOLSwqQ/2DQXBHaB7gxVaQnAa+Ir5LjIuMo0ObK/g9zYX9bW0QW1dEXIrvyEZX/
         J7ateXIdM3b3bjViibPEdxLqHWMOsI/gKTdIhOt9dbDp+C8iaReZn9yPULy+Pwup2Rkc
         lDC68bOVCaWMfX2kSmKCeHgvIHnefX8+QQ25GO/fGMRoBXRdLyNq5/XgTzIZXlTNcTir
         4P3e4/SDjNALxotCpKXz4GyejVpamriApaSiAEro/xts20OGG3SwzC+JnHzgh0yvvUSM
         91sCbwZJ56qZlM9qL1J8HkWDAMuSapWWtwKlc60t9L57MB00qdilV+A8Fgg5UOXxhRdI
         ppTQ==
X-Gm-Message-State: AOAM533iOErcBChL+7NZNQlZ3Gi/Z74otts4Va75+CfFOy/xSMMEF5Vh
        4Uf5TKKCBT6u1Sy/Urqt4FT5+CwHvac2ycCtnxTxMxC5nYTwwHjS6/dGlN5TGS0dOoG3u+ELK7P
        RlGO2Q2lHv/+Q
X-Received: by 2002:adf:9cc2:0:b0:20f:e59a:ec41 with SMTP id h2-20020adf9cc2000000b0020fe59aec41mr31401248wre.124.1654668052565;
        Tue, 07 Jun 2022 23:00:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHQplGnELB+79hF5tZieuRC/jNvYpvm+mt9Ta1KGoefr17nHK6bc6qds9St+Vp2bqRhwe1fg==
X-Received: by 2002:adf:9cc2:0:b0:20f:e59a:ec41 with SMTP id h2-20020adf9cc2000000b0020fe59aec41mr31401201wre.124.1654668052305;
        Tue, 07 Jun 2022 23:00:52 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-114-66.web.vodafone.de. [109.42.114.66])
        by smtp.gmail.com with ESMTPSA id h12-20020a05600c2cac00b0039749256d74sm27609665wmc.2.2022.06.07.23.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 23:00:51 -0700 (PDT)
Message-ID: <7350ca00-2dbe-f92c-ee28-9b0438051171@redhat.com>
Date:   Wed, 8 Jun 2022 08:00:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
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
 <20220606203325.110625-21-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v9 20/21] KVM: s390: add KVM_S390_ZPCI_OP to manage guest
 zPCI devices
In-Reply-To: <20220606203325.110625-21-mjrosato@linux.ibm.com>
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
> The KVM_S390_ZPCI_OP ioctl provides a mechanism for managing
> hardware-assisted virtualization features for s390x zPCI passthrough.
> Add the first 2 operations, which can be used to enable/disable
> the specified device for Adapter Event Notification interpretation.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 47 +++++++++++++++++++
>   arch/s390/kvm/kvm-s390.c       | 16 +++++++
>   arch/s390/kvm/pci.c            | 85 ++++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h            |  2 +
>   include/uapi/linux/kvm.h       | 31 +++++++++++++
>   5 files changed, 181 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

