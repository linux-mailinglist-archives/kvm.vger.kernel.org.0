Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99444545697
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 23:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiFIVlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 17:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbiFIVlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 17:41:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 960E252E63
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 14:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654810870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0dAgKBzfPuu/Qpg4c3Cqr8k4N4HCUwtJu4hqNYeV2g=;
        b=YmbL4XZoIJIOU4TL7LW8rCrw/7uNf5B5FP8xCfmWk3JAYRaupqmT4j/MS/WkcR74lWZGHn
        RtSTBE6ULNM77O3y18CSeqyaMeAG67/fgAZG5R5LVQ1ZU00MowNrZezPy5WLmVXnGTYFPe
        K/WbUwPqIRzXvEP/Tdl1Sb7UHjFSSfs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-bdWv-sSZOyqN5vrcPfgKHA-1; Thu, 09 Jun 2022 17:41:07 -0400
X-MC-Unique: bdWv-sSZOyqN5vrcPfgKHA-1
Received: by mail-il1-f198.google.com with SMTP id i16-20020a056e021d1000b002d3bbe39232so18456242ila.20
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 14:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+0dAgKBzfPuu/Qpg4c3Cqr8k4N4HCUwtJu4hqNYeV2g=;
        b=FXD1+W2ZIX76ePrccrRE2YFSOvbFJjgmWCFXGePottK8vDigQvA3EbIpnxoKA5N92l
         3uasLGw3UVTKvFXsfdrE/nbuvG1n71wkLKNnhNMLDGjBjnl8/zgWZIVqyfaRRB0A5qKQ
         MJ7uE4ZFdF3zTrNBEur9JeznjnbNv+kceHxDIaBui6XjdIwz9wIucm6Bbl5bd36LAeQ2
         U8mPAdKdhnkSLQutp3p6cqF/xangTigpfHx9qI8ucT21Ok/OrXx0Mx73aghXyHDM+ePJ
         EmDHqiBjPU6CcmbkYOzLhVhLi39Kg/+nYvmtRgEJa342Izz/yyVWiG/geE5JK/ncZ3c3
         t8BA==
X-Gm-Message-State: AOAM531egtD0JiVfNJ10Z0tawuPI7fie3PNrSBp2s8HxUVXU0Nmg/1qF
        rIMkaun0mMiyOwcvgd9ETcPu6AFqWEb+RbtGRDwBTfks7VEYJW/eS/piBHL5PKHcQh6zqIhfnL1
        hYQg4p1odOEjq
X-Received: by 2002:a05:6638:dd3:b0:331:d98c:9a67 with SMTP id m19-20020a0566380dd300b00331d98c9a67mr7194724jaj.47.1654810866034;
        Thu, 09 Jun 2022 14:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLYxbzXLY+uqvkGUeuaM8Esk3FhbYDeZwBAuNSC8NN4cjxlecj6CnbA+l3i4GOPufnvI4knw==
X-Received: by 2002:a05:6638:dd3:b0:331:d98c:9a67 with SMTP id m19-20020a0566380dd300b00331d98c9a67mr7194664jaj.47.1654810864338;
        Thu, 09 Jun 2022 14:41:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a18-20020a6b6d12000000b0066938e02579sm7583703iod.38.2022.06.09.14.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 14:41:03 -0700 (PDT)
Date:   Thu, 9 Jun 2022 15:41:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     kvm@vger.kernel.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
Message-ID: <20220609154102.5cb1d3ca.alex.williamson@redhat.com>
In-Reply-To: <01c74525-38b7-1e00-51ba-7cd793439f03@suse.de>
References: <165453797543.3592816.6381793341352595461.stgit@omen>
        <165453800875.3592816.12944011921352366695.stgit@omen>
        <0c45183c-cdb8-4578-e346-bc4855be038f@suse.de>
        <20220608080432.45282f0b.alex.williamson@redhat.com>
        <01c74525-38b7-1e00-51ba-7cd793439f03@suse.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jun 2022 11:13:22 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:
> 
> Please have a look at the attached patch. It moves the aperture helpers 
> to a location common to the various possible users (DRM, fbdev, vfio). 
> The DRM interfaces remain untouched for now.  The patch should provide 
> what you need in vfio and also serve our future use cases for graphics 
> drivers. If possible, please create your patch on top of it.

Looks good to me, this of course makes the vfio change quite trivial.
One change I'd request:

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 40c50fa2dd70..7f3c44e1538b 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -10,6 +10,7 @@ config VGA_CONSOLE
 	depends on !4xx && !PPC_8xx && !SPARC && !M68K && !PARISC &&  !SUPERH && \
 		(!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER) && \
 		!ARM64 && !ARC && !MICROBLAZE && !OPENRISC && !S390 && !UML
+	select APERTURE_HELPERS if (DRM || FB || VFIO_PCI)
 	default y
 	help
 	  Saying Y here will allow you to use Linux in text mode through a

This should be VFIO_PCI_CORE.  Thanks,

Alex

