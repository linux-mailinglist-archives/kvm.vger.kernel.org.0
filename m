Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EFB4C1FCA
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 00:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244865AbiBWXhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 18:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244831AbiBWXhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 18:37:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B81225A0A3
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645659427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4uZUFplVlE5Y8frdrAqmVb5e+dpaoHXAN39OVRnAh4=;
        b=HfvT7Km9xEzosgW97guxKGspVDkjt76JZH5i66eL0dZz+5SAiA89HX/SFfSMixfdbkUm9/
        R7JL5Qr89KYMQccOueAEwl2IQj2VVwk1PkhhUBlSmq4bS+8bM/H7kC18jbKblhgpge/qDb
        9aWlteAKioJ7b1PZ3bjUdTgWo2Q00V0=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-aWGSSt5tPKaAiWgABKdeWw-1; Wed, 23 Feb 2022 18:37:06 -0500
X-MC-Unique: aWGSSt5tPKaAiWgABKdeWw-1
Received: by mail-oi1-f197.google.com with SMTP id w19-20020a0568080d5300b002d54499cc1eso306499oik.19
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 15:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=T4uZUFplVlE5Y8frdrAqmVb5e+dpaoHXAN39OVRnAh4=;
        b=wM18lqwApbQgwKLV/swyfwebtWa27m8H+tIOrUt7GF8Lk8zen1wefPnWmyq8bOQNJT
         p2ErAoYCng+c8Idssw78B8TjTD0hQMj66nBs8cRsPM4sqt1biNZe6sqc8ttzxal50HuS
         mT5ME4t7iLPpaVdZW5G8EQA1aS/tv4gpBjP7TkXeqUXdBMIH663cA/DEbLwrv9V0Z+Mc
         CQw/crL1RHsP5XZr2ZAteCgtgHZabP4uk1PaTzz+UJOUBMgCesGsbK+V+n4BVSDVdxzt
         XDdfiO4YRDWpEjlV/lCrAxiM3ufzYRb9joxgG0aKjxFyWrDbMdJNrGr1fsVt3IORorGx
         kRiQ==
X-Gm-Message-State: AOAM5315cJmNmz9Enm6w3nasqBGpWaAp4wdEOVI6i1V+vafP2C3jZjFK
        B8OW2Ux0hztQ8dyDykzu7ep59Ufszk13T1peevb4umaFABQ5kIGYtdXGBUJUHD2VW9z3tQ+bZh5
        t6ND4XjA/d/j3
X-Received: by 2002:a9d:7016:0:b0:5af:157b:685 with SMTP id k22-20020a9d7016000000b005af157b0685mr10031otj.16.1645659425852;
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxofdQSoSC1/kDx6fUUcLtOCsSdUzQ0Bk8PapztMnNq1yES+yHaSrNxhft1rMXuy1CFcMCgtg==
X-Received: by 2002:a9d:7016:0:b0:5af:157b:685 with SMTP id k22-20020a9d7016000000b005af157b0685mr10026otj.16.1645659425637;
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q73sm422469ooq.33.2022.02.23.15.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 15:37:05 -0800 (PST)
Date:   Wed, 23 Feb 2022 16:37:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 5/8] hisi_acc_vfio_pci: Restrict access to VF dev
 BAR2 migration region
Message-ID: <20220223163703.20690b29.alex.williamson@redhat.com>
In-Reply-To: <20220221114043.2030-6-shameerali.kolothum.thodi@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
        <20220221114043.2030-6-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Feb 2022 11:40:40 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
>  
> +static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
> +	.name = "hisi-acc-vfio-pci",

Use a different name from the ops below?  Thanks,

Alex

> +	.open_device = hisi_acc_vfio_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = hisi_acc_vfio_pci_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = hisi_acc_vfio_pci_read,
> +	.write = hisi_acc_vfio_pci_write,
> +	.mmap = hisi_acc_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +};
> +
>  static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name = "hisi-acc-vfio-pci",
>  	.open_device = hisi_acc_vfio_pci_open_device,

