Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879A56DE4F9
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDKT3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDKT3H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:29:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F5C135
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681241300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZEKtuwNJGmtYAK5ZDQZnYdhRcfjYTid9CwH+lPhpUg=;
        b=b2vJK1zSQ04erV8PJ3WaZ++IQgDwSHYhXI52SO0qZ+s4TzK+dH/www6ggCk9OcmUoeqK+Y
        X/tuvCPbS/y2fSuC1k63nZNA9q3gigbOJ1zszCaVVXm7/FrIgdzThpMRAW3Lpxec31kUnu
        2B58Z6tenJG/wXTCnbkqTJUQVy8xgCs=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-Nc7z37r5MUCie-ONoXg2Xw-1; Tue, 11 Apr 2023 15:28:19 -0400
X-MC-Unique: Nc7z37r5MUCie-ONoXg2Xw-1
Received: by mail-io1-f71.google.com with SMTP id i68-20020a6b3b47000000b00760a6d1a015so48742ioa.1
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681241298; x=1683833298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ZEKtuwNJGmtYAK5ZDQZnYdhRcfjYTid9CwH+lPhpUg=;
        b=yuVMMUdtG0Ovoy7ouVbBIKSGks0lhUZYTvAoRxsxPjmP9n1CdwP53JDxrKRXwMXhcv
         Z/nEGyhZ9heHPbeMgj0QljQEI9gX1PPsy2gyp+dmSNTJT593hfJ6pcL97p1qQ1HaLNUL
         l+Md7h+ykl96HCUu/LaZkL2WmAQ8hr+awwt0x+ERmJqZaAoGJsba+byk59k45kddavWM
         H1OCE/1rWI3cx8eL5VMIvG+mNuKVOIXpTiYtBWRTwOwC4W+zfd5kbWwxBhtFismoMfH9
         EPG041e9FrWWrwv7xoF9UcFjNs6kX1xUVU7yVNU9UDE6X0Bazm30j9OttxnmRMxToRWL
         dzSg==
X-Gm-Message-State: AAQBX9cRv5QDbmnDCIZNZyv74paWnatJTT4MPmDEtyFCXkPWyrZFRm5v
        AHI4k2t7yWaqQWe56Hn9HG8jpBn2T82D5fxj1FO2E87ziQOPuldg8EeRUFRNufIZYEoocuG6P20
        sWLPdPsEV/W4DeYndZ8q7
X-Received: by 2002:a92:512:0:b0:315:359e:2750 with SMTP id q18-20020a920512000000b00315359e2750mr9530561ile.20.1681241298002;
        Tue, 11 Apr 2023 12:28:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y075HOqnk/ugsl6NkWBPtpulmp36BmS/tHbbyW71cHGowa9WPQAwjw+UvrRMkSIzSJi80jow==
X-Received: by 2002:a92:512:0:b0:315:359e:2750 with SMTP id q18-20020a920512000000b00315359e2750mr9530556ile.20.1681241297782;
        Tue, 11 Apr 2023 12:28:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v3-20020a92c6c3000000b003292f183c95sm113795ilm.58.2023.04.11.12.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:28:17 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:28:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        pbonzini@redhat.co
Subject: Re: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Message-ID: <20230411132803.4628e9fc.alex.williamson@redhat.com>
In-Reply-To: <20230222022231.266381-1-yi.l.liu@intel.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 21 Feb 2023 18:22:31 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> as some vfio_device drivers require a kvm pointer to be set in their
> open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
> v2:
>  - Adopt Alex's suggestion
> v1: https://lore.kernel.org/kvm/20230221034114.135386-1-yi.l.liu@intel.com/
> ---
>  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/devices/vfio.rst b/Documentation/virt/kvm/devices/vfio.rst
> index 2d20dc561069..79b6811bb4f3 100644
> --- a/Documentation/virt/kvm/devices/vfio.rst
> +++ b/Documentation/virt/kvm/devices/vfio.rst
> @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
>  	- @groupfd is a file descriptor for a VFIO group;
>  	- @tablefd is a file descriptor for a TCE table allocated via
>  	  KVM_CREATE_SPAPR_TCE.
> +
> +::
> +
> +The GROUP_ADD operation above should be invoked prior to accessing the
> +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to support
> +drivers which require a kvm pointer to be set in their .open_device()
> +callback.

I updated the title and commit log so as not to further construe that
documentation can impose a requirement, otherwise applied to vfio next
branch for v6.4.  Thanks,

Alex

