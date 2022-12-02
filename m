Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5264104A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 22:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiLBV7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 16:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiLBV7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 16:59:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578EFF4EB7
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 13:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670018338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDnwcr2MsfbQiTUfEToP1oFEh6S+4RAS/eGf/9UCInk=;
        b=eRKkeZsKfZ8SY30cplSTDIL/LU0xvNp8ndn/dKQu7ZhCd1ikMSoiX4Gw8O1+QiSbdRKcH9
        W9yVRlJ6YtBih9BlhrZg3mtjyr+Ew8WRlc7omiFLbwuWX0XlekDRKMSU9iHPRxt7OuV/H5
        axt67AbGaJBNyTWUOmqqZ1MeKwlDPxM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-8I1KZ_5AMN2FZZRFjiUVqg-1; Fri, 02 Dec 2022 16:58:57 -0500
X-MC-Unique: 8I1KZ_5AMN2FZZRFjiUVqg-1
Received: by mail-io1-f71.google.com with SMTP id y5-20020a056602120500b006cf628c14ddso5663171iot.15
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 13:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDnwcr2MsfbQiTUfEToP1oFEh6S+4RAS/eGf/9UCInk=;
        b=FeWxgfme/+nXuwzdRtqfh4S/VnB+u27IOaJ9Hee8REV5d+LA9zyoDLmuipweoG2nAx
         tv+wmMOpCyRYBVal808osXXBWS1xfXrlnD9ajnWsUNqOYgWlFSSPowJLdbRl8HhmOAuR
         gphBDXMsvqYAl0+EApaiHl9V6MeSGtzEyvMLis8ZP6kp/20uHtfzhOiw1MvMaw6jC0gG
         VEtTGL4/WG9UHyaCmo8A9MX8I+TGnEjTBihcYZoSekDZNtrkxxoTqTO9te+f6t+NMNv8
         BiTb+ph3ekXbugQMdVotcnsBP1xWo3jSqOaOI284jxVNgEPLLSXnmNB51MdrXiHgkENp
         oYBg==
X-Gm-Message-State: ANoB5plJH38a0vk4AoGfuWcZnbZYstepU5hu5M7YgcncjA3I/7teA2nD
        ijqzkwe5iKwc/LuNPOtq9epqnkL8QOpHr5ME1rfoje2pLiz+zvJhbCwdrZeAnBfVcD/StZ2aKNb
        AD7xZYRyQ1e+I
X-Received: by 2002:a05:6638:3c47:b0:363:ba0f:deaf with SMTP id bg7-20020a0566383c4700b00363ba0fdeafmr33437516jab.150.1670018336468;
        Fri, 02 Dec 2022 13:58:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7vqqLeRf1udEkgcPIgFvQP9qhoALK1g1bNloXT0bEs6KEm5PyNBkKc0dw0IEqrvrMZrYEHhQ==
X-Received: by 2002:a05:6638:3c47:b0:363:ba0f:deaf with SMTP id bg7-20020a0566383c4700b00363ba0fdeafmr33437504jab.150.1670018336176;
        Fri, 02 Dec 2022 13:58:56 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l32-20020a026a20000000b00386dde027e7sm2993072jac.73.2022.12.02.13.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:58:55 -0800 (PST)
Date:   Fri, 2 Dec 2022 14:58:53 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com
Subject: Re: [PATCH 07/10] vfio: Refactor vfio_device open and close
Message-ID: <20221202145853.5c09b470.alex.williamson@redhat.com>
In-Reply-To: <20221201145535.589687-8-yi.l.liu@intel.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
        <20221201145535.589687-8-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Dec 2022 06:55:32 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This refactor makes the vfio_device_open() to accept device, iommufd_ctx
> pointer and kvm pointer. These parameters are generic items in today's
> group path and furute device cdev path. Caller of vfio_device_open() should

Minor nit beyond what's already been mentioned here:

s/furute/future/

Thanks,
Alex

