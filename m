Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822A2615C15
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKBGOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBGOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:14:37 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821F625C5A
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 23:14:36 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-36ad4cf9132so157222987b3.6
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 23:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ceGZcCBh/C5qXmlTn7aYTLoHRJz3v4pUMXJmQIvbk6c=;
        b=PpsKCaac4R+pcSrWNuGtq19Ptw4FBJabeSPIs3AUQFemtPxbVb/hpaa1Hwf3lPHsH4
         +Bq6UXgWcS7KyHmfFI+Yr4xh/h80tKaZERzI5o00vs1TJS6UPDCPYVytv8rzYo56FxZK
         MA47kWPaskSHgfBibfyM2o3JXXjBEKaNoKQl7HSbeOQBHjudUEo9MugoQAHF+U3ScH4/
         VqR9VSkt4Jk087Bc6hJlqmpTebc8yDRg1Aw3AskeHS3RCun5dFI3dYZWaLcVBq1oofMd
         E+j+FqwmTwKKAkWZ3h2jnd3KAqsKvyOEENMNYGB0b7Tbtp7Y5lX83qWKasKHDj55szx4
         1A+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ceGZcCBh/C5qXmlTn7aYTLoHRJz3v4pUMXJmQIvbk6c=;
        b=X2yu/TrjNQv4nBPfjBpe8pJXkR7ieQsJsFQCHyhYiNbWeDjSr+SGupRwXSXNJeJfJ2
         fnpSy0QbX025xyaMl4Ypj18rbTSfDC89uZKvtN4vski70sJQs9jiNThUJ9ftfPg3Vy3V
         hcNGbedjhKUQcrSFKi9n8WFZGWSNJeGj7+TlFN7uJ5rBGEAYsUGFGyQ1N80LOCIW1NGm
         9h+PaR3mzu/uR35PsTCDHAJL6/ZC8vpnBWD9MEUHftPhslmro00J2QT6IkoHrvieEJD9
         lG58tcTVnRQVIP8PnCs7l8i0eMZv5j1oqZGLj7/sNJcDB2RLscmTD1v2yya7eHOpJElq
         UMjg==
X-Gm-Message-State: ACrzQf3IbBo/lsqr8K7ZKBAwa9hGrDkuTxGQtrR3vkBzsb70JlGMHB1V
        CO8yzlUZOIib1Xn2XlMSh56ZboHg8bo6+8TNuRGZbrncxcnypg==
X-Google-Smtp-Source: AMsMyM6glFWxQ1binyiGrgnZrbEYB6/Gi2XKdHEcxsL+cQS+hj06nQtE6EaDg+KpGr9p9tDmCwAI1uR6EyHJkVZyauk=
X-Received: by 2002:a81:67c5:0:b0:370:c85:7fa4 with SMTP id
 b188-20020a8167c5000000b003700c857fa4mr21688054ywc.216.1667369675738; Tue, 01
 Nov 2022 23:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <20221026194245.1769-1-ajderossi@gmail.com> <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y2EFLVYwWumB9JbL@ziepe.ca>
In-Reply-To: <Y2EFLVYwWumB9JbL@ziepe.ca>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Wed, 2 Nov 2022 06:14:24 +0000
Message-ID: <CAKkLME3bR++sWFusGdxohD3ZCgBDj7rjsjMZs=RvaYYfaJskng@mail.gmail.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 1, 2022 at 11:38 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> I've been meaning to take a deeper look, but I'm thinking vfio_pci
> doesn't need open_count at all any more.

I spent some time looking at it, but I'm not very familiar with this
area.

None of the fields in vfio_pci_core_device look usable as a substitute
for open_count, but calling pci_is_enabled() on the PCI device might be
sufficient. pci_enable_device()/pci_disable_device() appear to be called
in the right locations in vfio_pci_core.

I'm happy to submit a separate patch to check pci_is_enabled() if the
PCI device life cycle makes sense.

Anthony
