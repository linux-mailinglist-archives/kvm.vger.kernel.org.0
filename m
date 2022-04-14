Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5621501C42
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 21:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345997AbiDNUAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 16:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiDNUAc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 16:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69122DAFCB
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649966286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AE6ziqzRc2dhrjIjlkzQM+upeliMWRHPoIvV5hVYL48=;
        b=aw2F20EUMsUai1MZtEDHIwFgANVTZ1Vwj89JKS9PmO2aRG0GiTVAQzq1kSiLcVuoKbHu+P
        J223FHGrFW2r9rbNRXbdyGbPF/uqPb7+1V2Bc6L2S1QQdcBy96H5zNIHjutZQzzV+XXRyH
        TwN2tyWeQGcPY6toDn1LuTz95BUYbnM=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-ZyrdHFDtNHORf_dY9NjAWg-1; Thu, 14 Apr 2022 15:58:05 -0400
X-MC-Unique: ZyrdHFDtNHORf_dY9NjAWg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-e3163250c1so2427455fac.2
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 12:58:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=AE6ziqzRc2dhrjIjlkzQM+upeliMWRHPoIvV5hVYL48=;
        b=h/78USdTiUr40e+I+0BrGrX3Fj4McqVh18uFftR2D3LoB83xifclulj2+UEMECCBba
         PccD9u9iKkHlA2JaM9dtDYSIKaoqR25et6YahVNfC9nMyCYsGNypvo62afqhP8aJBPtI
         TThBeydjZ8dmWciM5KhbxoaD2FacLpOR2eVFtunZulQsXYTxVr2qe+lCktfSb+29OhLr
         XAxAmpNBTBaqzwH3Ec+UaBRMx74fS+vC6mXPX3XFmXtLE46QCGI1DzmGUG50CKgFtMii
         XGR36pOEHivUxF0Q90HxwSMeaNnWEjwIYVeXgfg6srpdAKiKkIOvOT/4I7xrIS4K/o5L
         ExYA==
X-Gm-Message-State: AOAM533QJc4hWCuKI4d8BA6nGUTbLXsYlf4jPQ0jwpKZDm+T1/nga3ja
        vTqSNC4HKda1jySQC/h93BwiPGzjtDzNAEZ672W/u9lEF2gIqWvp2+gN5YIYusxZmuuQcn7h/WW
        4DQ7FcPm5ZQGQ
X-Received: by 2002:a05:6808:1384:b0:322:2bcc:42c0 with SMTP id c4-20020a056808138400b003222bcc42c0mr109655oiw.11.1649966284303;
        Thu, 14 Apr 2022 12:58:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlq+M8kVUY+y/WxhC3Noj7QLeNYSzazjp1aXJ5+G0+DkrFoIZIkKPXMlgomFVi58BL5erFyQ==
X-Received: by 2002:a05:6808:1384:b0:322:2bcc:42c0 with SMTP id c4-20020a056808138400b003222bcc42c0mr109648oiw.11.1649966284072;
        Thu, 14 Apr 2022 12:58:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s4-20020a0568301e0400b006015bafee43sm402266otr.46.2022.04.14.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:58:03 -0700 (PDT)
Date:   Thu, 14 Apr 2022 13:58:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [GIT PULL] VFIO fixes for v5.18-rc3
Message-ID: <20220414135801.306f33dd.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:

  Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v5.18-rc3

for you to fetch changes up to 1ef3342a934e235aca72b4bcc0d6854d80a65077:

  vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used (2022-04-13 11:37:44 -0600)

----------------------------------------------------------------
VFIO fixes for v5.18-rc3

 - Fix VF token checking for vfio-pci variant drivers (Jason Gunthorpe)

----------------------------------------------------------------
Jason Gunthorpe (1):
      vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used

 drivers/vfio/pci/vfio_pci_core.c | 124 +++++++++++++++++++++++----------------
 include/linux/vfio_pci_core.h    |   2 +
 2 files changed, 76 insertions(+), 50 deletions(-)

