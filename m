Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABE369125D
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 22:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjBIVEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 16:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBIVEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 16:04:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F5168AE4
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675976632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgT2BVRtkGV7fSMuNB71iY2q4cw9J2BVXkfHIxEGnS8=;
        b=i6YGmNq5H4WO/uiY13shnk7i3WkB8Lyx2qYTTwxbC5jf0YqA0yIc9JILhe6tdbNlZPaJBm
        sDSv+vlVq58L41elsy8DvDeWT97VcJ59yXLm/F/66SnD9Vzoi8/SBfljzp/QKNlVG2LKdK
        4KILoTef1Dy3oGaUKR275/RVEuTFnOQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-XFQxxFduNryK11UmwIGEPg-1; Thu, 09 Feb 2023 16:03:51 -0500
X-MC-Unique: XFQxxFduNryK11UmwIGEPg-1
Received: by mail-il1-f197.google.com with SMTP id i23-20020a056e021d1700b003111192e89aso2494803ila.10
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 13:03:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgT2BVRtkGV7fSMuNB71iY2q4cw9J2BVXkfHIxEGnS8=;
        b=NUThYWlv2Wu39J0WKuFgtczgDOrt721GunDmshVKpeU3tOKL1FDGpWaTAj0xpPCEuE
         gbKujXQsQJcVQR3paBaPDcvhtffx90OXrMvAAipmugQLlDcvipiUailiUM9+uflG94C6
         f4R5/J31JDiZ+sF/rqGAOeyhVz8mMzZdHkDSq8wg83u2A/mMSluF45YtPTQzqu7Q5NyF
         nToieKkBadEzlvQ3U1hqEjPvwKDWx0H0CLYyx2kbeeM+Gqc9+8AD0dwMQBw9a14vxHnm
         +c80/Ll7FhhXedJIH8vwpIej98XT83W1T0EJByS1+NTRj/kbkA1A4meF3a6HSYBTuGuI
         6l2w==
X-Gm-Message-State: AO0yUKUZ/xlszzlGethqQYYJgKDrlFzQmhjYOdML2yPrTTOX1TaG+sRd
        qH9SzYauJkDh1ZgrUNJ9mbmaZFMDnFpesHNEvGsr0dW2QplYkhIeMqr0qHpCv98K0UHD/c0H4Cv
        J7oDA1KJd9zFq
X-Received: by 2002:a05:6602:1584:b0:6e9:d035:45df with SMTP id e4-20020a056602158400b006e9d03545dfmr14246385iow.6.1675976630796;
        Thu, 09 Feb 2023 13:03:50 -0800 (PST)
X-Google-Smtp-Source: AK7set/V6v8iY7oc2DS4nnQd6q/YDr0BCykefxmO3uYWIh2Jf3RwoZHF6jrljvpYZxXxH9wTlfengg==
X-Received: by 2002:a05:6602:1584:b0:6e9:d035:45df with SMTP id e4-20020a056602158400b006e9d03545dfmr14246370iow.6.1675976630574;
        Thu, 09 Feb 2023 13:03:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c5-20020a5ea905000000b0071cbf191687sm698346iod.55.2023.02.09.13.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:03:49 -0800 (PST)
Date:   Thu, 9 Feb 2023 14:03:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Update VFIO doc
Message-ID: <20230209140313.06abab8e.alex.williamson@redhat.com>
In-Reply-To: <20230209081210.141372-1-yi.l.liu@intel.com>
References: <20230209081210.141372-1-yi.l.liu@intel.com>
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

On Thu,  9 Feb 2023 00:12:08 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> Two updates for VFIO doc.
> 
> v4:
>  - Refine patch 02 per Alex's suggestion.
> 
> v3: https://lore.kernel.org/kvm/20230204144208.727696-1-yi.l.liu@intel.com/
>  - Fix issues reported by kernel test robot <lkp@intel.com>
> 
> v2: https://lore.kernel.org/kvm/20230203083345.711443-1-yi.l.liu@intel.com/
>  - Add Kevin's r-b for patch 0001
>  - Address comments from Alex and Kevin on the statements in patch 0002
> 
> v1: https://lore.kernel.org/kvm/20230202080201.338571-1-yi.l.liu@intel.com/
> 
> Regards,
> 	Yi Liu
> 
> Yi Liu (2):
>   vfio: Update the kdoc for vfio_device_ops
>   docs: vfio: Update vfio.rst per latest interfaces
> 
>  Documentation/driver-api/vfio.rst | 82 ++++++++++++++++++++++---------
>  include/linux/vfio.h              |  4 ++
>  2 files changed, 64 insertions(+), 22 deletions(-)
> 

Applied to vfio next branch for v6.3.  Thanks,

Alex

