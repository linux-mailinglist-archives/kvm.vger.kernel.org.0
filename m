Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE37C6EB2FF
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjDUUnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjDUUnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 16:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057DE1FCE
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 13:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682109775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2pCl6a9IbUB8+ECxoYZZkM98ncK/UQGjdocWXjn9U8=;
        b=DTw0wlwwPczyVM/mBBBbhsZVZcfY4OD49PuAI40Muq2DYmWllFL1LHNs9M/0mlLCOw/1wm
        LNEd63ViCAJV/MAS9e7MrslR/p6bm0j3Wqwx4tXRrDPxnEIZsM9Hfw31c8kSbWXGIyo/LP
        oQ16K01Xdm+fv8vd9GzmYBigWVubWdc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-G2GG3XNZOOuKtZi_3hf_Tg-1; Fri, 21 Apr 2023 16:42:53 -0400
X-MC-Unique: G2GG3XNZOOuKtZi_3hf_Tg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-32a7770f504so38457915ab.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 13:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682109773; x=1684701773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2pCl6a9IbUB8+ECxoYZZkM98ncK/UQGjdocWXjn9U8=;
        b=CDgjt1BH6tbUj1Wg8UIvF01I993/xDqTgBT/sP+FxvEkAvm5xOF8WbkvlPtVZsHA8v
         wY+ht6BpMEZeIUjBnOgrGK7lGjVPnFA2WODNI3xnoI+Lo6UJyeJSwaxCnnzCEV+3mXNg
         91QzvTxsw0v9cFK7wPiMd0HdsDa4qOsxsVR80qoKQvey/qGXtT1T5G09nNPIRJxthb1B
         isZnrPFrqfhwmoPNBqXopwN8JtfuDiGAyEH4MKbCcXKmVqU1Yij9bqGHIEKZ59/3v1WK
         UYND+CWTBwxiDJXFn64ZqRjDpNd1Yz04n6qk/hAJQekoIK35tI2ppHoVVKPOaIJZftng
         ratQ==
X-Gm-Message-State: AAQBX9dZzy6i585hZcrM0/tgHQozwl4FLf3wsR4YykIG8og/wI+x6Mf2
        XVN0guI6qP8uqUbRQoK1m+rC34W188CvO3i8mb0hstKhyktdXzewL6IHHa7Qu0uV7WyW42LLUkz
        YwYxunA4uzv6c
X-Received: by 2002:a92:d48a:0:b0:328:6c2e:8cb0 with SMTP id p10-20020a92d48a000000b003286c2e8cb0mr91847ilg.30.1682109773188;
        Fri, 21 Apr 2023 13:42:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350a73tQ0fTKp5tLB0DYmhruBvcOFcIagt7HAKDSxE6Sgb1iXQ9vQ47ndxAk+v0fQRvpqeKI++w==
X-Received: by 2002:a92:d48a:0:b0:328:6c2e:8cb0 with SMTP id p10-20020a92d48a000000b003286c2e8cb0mr91838ilg.30.1682109772960;
        Fri, 21 Apr 2023 13:42:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o42-20020a02742a000000b0040f9ed959e3sm1527978jac.13.2023.04.21.13.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 13:42:52 -0700 (PDT)
Date:   Fri, 21 Apr 2023 14:42:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     kevin.tian@intel.com, jgg@nvidia.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com
Subject: Re: [PATCH v3] docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs
 VFIO_GROUP_GET_DEVICE_FD ordering
Message-ID: <20230421144250.61127ce8.alex.williamson@redhat.com>
In-Reply-To: <20230421053611.55839-1-yi.l.liu@intel.com>
References: <20230421053611.55839-1-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Apr 2023 22:36:11 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> as some vfio_device's open_device op requires kvm pointer and kvm pointer
> set is part of GROUP_ADD.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
> v3:
>  - Add r-b from Kevin
>  - Remove "::" to fix "WARNING: Literal block expected; none found."
>    "make htmldocs" looks good.
>  - Rename the subject per Alex's suggestion
> 
> v2: https://lore.kernel.org/kvm/20230222022231.266381-1-yi.l.liu@intel.com/
>  - Adopt Alex's suggestion
> 
> v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..08b544212638 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -39,3 +39,8 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @groupfd is a file descriptor for a VFIO group;
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
> +
> +The GROUP_ADD operation above should be invoked prior to accessing the
> +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> +drivers which require a kvm pointer to be set in their .open_device()
> +callback.

Applied to vfio next branch for v6.4.  Thanks,

Alex

