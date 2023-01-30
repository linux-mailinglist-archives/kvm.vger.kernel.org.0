Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DC0682015
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 00:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjA3Xwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 18:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjA3Xwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 18:52:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B862DE6C
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 15:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675122727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8HtdhIvc3sRp/chnPJ7lbFuqwPwYRMdQgt4UP7MxVGk=;
        b=afmsDikJumznwcYWezhs05Z36JYHiSCvA8C5zfybcGlsuIO7JU0aROFCEflGCSzWjzLviS
        K+CqE07YE0KyaR/aJTA6DTJjWtrOQOrppUohgoB+xJnOSSQ5FxqiAwpLfy+zBVXEjTmRiz
        JeF7rMBo783ICsQSVRBuuzh9jW24elM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-PBqdabMgNSa7nz_Ys5EFrA-1; Mon, 30 Jan 2023 18:52:05 -0500
X-MC-Unique: PBqdabMgNSa7nz_Ys5EFrA-1
Received: by mail-il1-f200.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so8397441iln.21
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 15:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8HtdhIvc3sRp/chnPJ7lbFuqwPwYRMdQgt4UP7MxVGk=;
        b=ofxz6fiJDTCeDLKoHK6iI3dwDv7J56FmgM/V9mxMthI5YzUJxdLINmeZvNNCZeIBUW
         CoSYr7bAjQAlKbQHDMdYDaXEQ/FNSR70lTlMwL1itofeO8aAQ+XI9qPmZbvHUegr1XVF
         ASqYMmBVVUS8bF1Q9wSKypFSMRLo6wiL0aaDkldOeELjewnZyKMcBLhPTyNCZT+dIMUf
         3oQ0xvq9St7RS7OA0RT/6YFCMg3eMjADt5Shq33kDJp1WDSp5hyUltERFrCnYfLSAFKv
         Ne02A/XUEZZyGpj4vmUiZTQcMQLDiDNICCGV+B85+MoE4Wawm08VdIAOYMdSW6U9KkXf
         71ug==
X-Gm-Message-State: AO0yUKX7vrPusZ+x/+IhF0ylOk80RbdAUCc5smM5tnd3QvBSD3y2oGeg
        YsJp+wKfPUXrdMJiBWYWDGCe4/bUBeK1rl930IXMv38Y2pvd91xHu7RsZXK2mpdRRSoCAFXY1np
        1o87dEvECykHC
X-Received: by 2002:a05:6e02:1c43:b0:310:fd98:1cc2 with SMTP id d3-20020a056e021c4300b00310fd981cc2mr3374029ilg.13.1675122725074;
        Mon, 30 Jan 2023 15:52:05 -0800 (PST)
X-Google-Smtp-Source: AK7set+F7KJU5EeEPHjB0AjVP96o4VSNzZzHXDZLVzr/t/KYa8cREe367jMkDLjD6opBHf2H3o4JVA==
X-Received: by 2002:a05:6e02:1c43:b0:310:fd98:1cc2 with SMTP id d3-20020a056e021c4300b00310fd981cc2mr3374021ilg.13.1675122724850;
        Mon, 30 Jan 2023 15:52:04 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c10-20020a056638028a00b0037cb59b5c28sm1321706jaq.52.2023.01.30.15.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 15:52:04 -0800 (PST)
Date:   Mon, 30 Jan 2023 16:52:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>
Subject: Re: [PATCH vfio 0/3] Few improvements in the migration area of mlx5
 driver
Message-ID: <20230130165203.61d6e6b9.alex.williamson@redhat.com>
In-Reply-To: <20230124144955.139901-1-yishaih@nvidia.com>
References: <20230124144955.139901-1-yishaih@nvidia.com>
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

On Tue, 24 Jan 2023 16:49:52 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series includes few improvements for mlx5 driver in the migration
> area as of below.
> 
> The first patch adds an early checking whether the VF was configured to
> support migration and report this capability accordingly.
> 
> This is a complementary patch for the series [1] that was accepted in
> the previous kernel cycle in the devlink/mlx5_core area which requires a
> specific setting for a VF to be migratable capable.
> 
> The other two patches improve the PRE_COPY flow in both the source and
> the target to prepare ahead the stuff (i.e. data buffers, MKEY) that is
> needed upon STOP_COPY and as such reduce the migration downtime.
> 
> [1] https://www.spinics.net/lists/netdev/msg867066.html
> 
> Yishai
> 
> Shay Drory (1):
>   vfio/mlx5: Check whether VF is migratable
> 
> Yishai Hadas (2):
>   vfio/mlx5: Improve the source side flow upon pre_copy
>   vfio/mlx5: Improve the target side flow to reduce downtime
> 
>  drivers/vfio/pci/mlx5/cmd.c  |  58 +++++++--
>  drivers/vfio/pci/mlx5/cmd.h  |  28 +++-
>  drivers/vfio/pci/mlx5/main.c | 244 ++++++++++++++++++++++++++++++-----
>  3 files changed, 284 insertions(+), 46 deletions(-)
> 

Applied to vfio next branch for v6.3.  Thanks,

Alex

