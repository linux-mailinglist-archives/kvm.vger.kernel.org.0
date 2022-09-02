Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42B75AB87B
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiIBSnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 14:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiIBSnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 14:43:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597EC1144F9
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 11:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662144195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzZlvwELvY+KaMQ7WTtmZ1RMOwQTWfipcFncJI6AIlc=;
        b=CI/CchxS0wATfjOQpfC5mC7Y33X6l3i2sDtr0dJmTwFid0wxvQMEe0YgS+OWoz/KShZDwL
        ZEVnr0/wHx3r8V7dzESfuqgBwjS7iMintPejsnxk4UnoOG2M114GLirV1PYu4+mmJRMCft
        HzYW1eJy7sskj/THglm7zj37NMf/jdA=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-465-qWSdMH7XOi6wbjMOChzlyw-1; Fri, 02 Sep 2022 14:43:06 -0400
X-MC-Unique: qWSdMH7XOi6wbjMOChzlyw-1
Received: by mail-il1-f198.google.com with SMTP id d18-20020a056e020c1200b002eaea8e6081so2367547ile.6
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 11:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=rzZlvwELvY+KaMQ7WTtmZ1RMOwQTWfipcFncJI6AIlc=;
        b=JbpVTmO7179a8WMWZCPsw3GKFjszf0/JYHwyPggUf6M35fFAcbwN1Qp2dnNWrbmOwl
         df5ZTGN1sj6Fme5fYrzR5zW0CSIjfdqHL4t4sOgugQTMMtvtVQZMsyPC8yvdXfXf0rgX
         7z3rgvW5yt8p9AkfvC6ccamlCnz1IEhY6MSQUffFWyQIjVvUbrIHW7rbw/C9wzHEDqEp
         oIghh2y59AdJhMp1nUOoFxUxusnBLVL2UOPrGF3WKa9VRTYqcNLh8U9tbyyllpmJWNyC
         lp2BC2NUjvdiYsNCEHsdu80oPAL+Vxoph42knEYQ5tHWjRuKpfYFKkb406iQXxlCsldi
         ZkVw==
X-Gm-Message-State: ACgBeo3hY8XbvKWh9SUKywtKWftueA/5/AZpoHe+Fh3VxYAso9dLmii2
        Ub6l8qeEXi0B9SQezmqB8EAnGgjZkLsPR9AtwpT/kFsnorkh5mLcq8Veg5I8v/jgswZ+EtvPqbb
        QbLPmTJ4lGU+I
X-Received: by 2002:a05:6602:4191:b0:68a:144c:82dd with SMTP id bx17-20020a056602419100b0068a144c82ddmr18376480iob.33.1662144186354;
        Fri, 02 Sep 2022 11:43:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6YWf8nBccEN7BBYVFRVsQ/ifFo1eDb2o/b2Bl/zs4U+TFMt0cEmOPtWEOE6znqyuuUPaiqbA==
X-Received: by 2002:a05:6602:4191:b0:68a:144c:82dd with SMTP id bx17-20020a056602419100b0068a144c82ddmr18376470iob.33.1662144186142;
        Fri, 02 Sep 2022 11:43:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x6-20020a056602160600b0067b7a057ee8sm1126680iow.25.2022.09.02.11.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:43:05 -0700 (PDT)
Date:   Fri, 2 Sep 2022 12:42:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <liulongfang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Message-ID: <20220902124236.2363e982.alex.williamson@redhat.com>
In-Reply-To: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Aug 2022 09:59:43 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata") introduced a helper function to
> retrieve the drvdata but used "hssi" instead of "hisi" for the
> function prefix. Correct that and also while at it, moved the
> function a bit down so that it's close to other hisi_ prefixed
> functions.
> 
> No functional changes.
> 
> Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata")
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Applied to vfio next branch for v6.1.  Thanks,

Alex

