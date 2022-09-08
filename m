Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116B05B253F
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiIHSA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIHSAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676ABBBA59
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662660022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1CJqDZwdhNTxwT7stL4n24A7xf7/eYqBeTJa+7t530=;
        b=KGDJhbikjvlZRpBlMNJX0whJHbylRT9EWFw5pYaRX3nvEqqt1OS+pLUSnkQaSQBUtbZr2F
        3qbXUR2oXZ2uO9BW0Wt8iVF3lzhKjFUnx1i/rOYlrpVu4h0OEqkeleWxnBMk3n2sfcXnXG
        1sqVDsRCvdL+9IS1D2lnVsJfTsI3pyE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-bDU9ICrgObusVT16ytTguQ-1; Thu, 08 Sep 2022 14:00:20 -0400
X-MC-Unique: bDU9ICrgObusVT16ytTguQ-1
Received: by mail-io1-f72.google.com with SMTP id l15-20020a0566022dcf00b00688e70a26deso11824225iow.12
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 11:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/1CJqDZwdhNTxwT7stL4n24A7xf7/eYqBeTJa+7t530=;
        b=pxCSQsQ8oLkE488d2abzkwi+bUxSOzwH4nnutVKynDpfyywsDqMZ3F9aRa/0X7HLpQ
         6NP8DrU0c43E9Mq3uhz3ig+7l0zeKJ6fOAFYybQGRJIwlWFxvIS5IwP/oglxMCRZ4KKK
         Sj4uqLXBbQkPYAMlsDLZ8V2w8JQgrsGjiSWu9rzPfAgTRFml/r3W5XQ0rECY1AcjZjHu
         b2S+6whxE9fXjCvVx9EUeSdBnGWvRe72Q3BiKc40OWg1sv4TziyAzQa5iNzII5dEYy5m
         jenMa/vcmRPtgqsekSt6EfgDwOpTKMmf+CCmbgOsyI9gOtxfJvW8LYRnankalUrgqUcv
         evKA==
X-Gm-Message-State: ACgBeo0ecO1F0oEcODLVipRHVODNo/tcAutJZ8IKxlhhZuCJ7l1qRZIY
        VuGwpOwIhYcPUDCinISdWozM4h+4bFjMvO9p8wVVJzKuyecgRdZnAf1cT8I2SaszZSwGng6hxws
        z5Rs6tiJfKB89
X-Received: by 2002:a05:6e02:2167:b0:2f1:a5f4:e49e with SMTP id s7-20020a056e02216700b002f1a5f4e49emr2594262ilv.136.1662660019996;
        Thu, 08 Sep 2022 11:00:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6RH3UTD9rWrJdbISb1Dj3cENOMfZD3ljMSL4pm/HG0zjU6rQoOp/Bw16M3nBoZIyDLrQPgcQ==
X-Received: by 2002:a05:6e02:2167:b0:2f1:a5f4:e49e with SMTP id s7-20020a056e02216700b002f1a5f4e49emr2594249ilv.136.1662660019743;
        Thu, 08 Sep 2022 11:00:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c12-20020a02330c000000b0034c12270863sm8507755jae.80.2022.09.08.11.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:00:19 -0700 (PDT)
Date:   Thu, 8 Sep 2022 12:00:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [GIT PULL] Please pull mlx5 vfio changes
Message-ID: <20220908120016.473c144c.alex.williamson@redhat.com>
In-Reply-To: <83fe2fa1-7f49-35f5-ba4b-5662175bbe31@nvidia.com>
References: <20220907094344.381661-1-leon@kernel.org>
        <20220907132119.447b9219.alex.williamson@redhat.com>
        <YxmMMR3u1VRedWdK@unreal>
        <20220908105345.28da7c98.alex.williamson@redhat.com>
        <83fe2fa1-7f49-35f5-ba4b-5662175bbe31@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Sep 2022 20:31:35 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 08/09/2022 19:53, Alex Williamson wrote:
> > On Thu, 8 Sep 2022 09:31:13 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >  
> >> On Wed, Sep 07, 2022 at 01:21:19PM -0600, Alex Williamson wrote:  
> >>> On Wed,  7 Sep 2022 12:43:44 +0300
> >>> Leon Romanovsky <leon@kernel.org> wrote:
> >>>      
> >>>> Hi Alex,
> >>>>
> >>>> This series is based on clean 6.0-rc4 as such it causes to two small merge
> >>>> conficts whis vfio-next. One is in thrird patch where you should take whole
> >>>> chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
> >>>> header includes, which you should take too.  
> >>> Is there any reason you can't provide a topic branch for the two
> >>> net/mlx5 patches and the remainder are rebased and committed through
> >>> the vfio tree?  
> >> You added your Acked-by to vfio/mlx5 patches and for me it is a sign to
> >> prepare clean PR with whole series.
> >>
> >> I reset mlx5-vfio topic to have only two net/mlx5 commits without
> >> special tag.
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git topic/mlx5-vfio
> >> Everything else can go directly to your tree without my intervention.  
> > Sorry, I knew the intention initially was to send a PR and I didn't
> > think about the conflicts we'd have versus the base you'd use.  Thanks
> > for splitting this out, I think it'll make for a cleaner upstream path
> > given the clear code split.
> >
> > Yishai, can you post a v7 rebased on the vfio next branch?  
> 
> 
> Sure
> 
> Do you want me to include in V7 the two net/mlx5 patches that are part 
> of the PR or that you'll take them first from the PR, publish your 
> vfio/next tree and I'll drop them from V7 ?

For the sake of having a series that compiles and doesn't confuse
anyone with buildbot errors, please include them, but I'll pull them
from Leon's topic branch rather than applying them directly.  Thanks,

Alex

