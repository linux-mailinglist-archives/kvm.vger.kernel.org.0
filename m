Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381A458B023
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiHETBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiHETBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:01:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28E22193E0
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659726093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jrr///GTPolXMT+fiyn3eyuZH49mBtYTjRUTuSdpSs=;
        b=hnFsI5wvrpQnr3PeCsype4VcxGnTIYeFeva3eMPUbkRuY4OIPV1Wy0pRrAdPmdGaveIzIG
        GxVq2MbVsd0Gp0MKDb4xujqqkt800OHu3TtbSJVRpLfiujZ4+2cyJUXY68PNaEIRSm0Uo/
        UME3NEXRK0/vGFH7bB3JFdy3o+sOmvY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-BZqsGK-kN1mx2Vqo5WnCbA-1; Fri, 05 Aug 2022 15:01:24 -0400
X-MC-Unique: BZqsGK-kN1mx2Vqo5WnCbA-1
Received: by mail-io1-f72.google.com with SMTP id u5-20020a6b4905000000b00681e48dbd92so1904011iob.21
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=7jrr///GTPolXMT+fiyn3eyuZH49mBtYTjRUTuSdpSs=;
        b=nrr3q3UIl2g0XPzJ7iha/+thNHyO2QrJQlFdKFsySd+CaVtohd8D5spPIE0bgVaH0v
         I5Em/fnW7kK8+8N6vSRMakn/lG6c5VOa1S7PGafCERBlyjSl3nZoQ1pUC6N8T1afDILx
         yg1mII+RFEDTWyAhvg1azIumGmM8RdRR2R+UrvQGCsA6HlXKcFErQ+62k7VZeWli1E+S
         sjPFKiVXGD+GiChCWat/XGlr0iVkgINuOUQL6NSWGljvWEDG8pEjgSN/NN8VTqswksyp
         fZOqCncF1z/kWUz30kz/erVye1fgTE+Xu5NlNbIHA7RHgemQCanDsZMKrA3PLHiCe2oY
         /f2g==
X-Gm-Message-State: ACgBeo1etHN2fbVDJDKDCDRUHUlonErv2N4fVuaoNJqjO9LzW+Tomk6C
        sdIs0/I1sqVdzGLHcQuOBHPImV4yhfxvUeXGCa+wLgB8agkpkZNkTNrFXRgW06k7RlfFUd8ftqf
        YATsLXzIlv6Th
X-Received: by 2002:a05:6638:1305:b0:33f:7e59:4bc7 with SMTP id r5-20020a056638130500b0033f7e594bc7mr3471392jad.316.1659726083691;
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5tl8wkqOGSRQbqQPvsP8x/sMHa+aTSdU4oxacleMUjEkM/f7HmEieSFt52FFtURojAjdepMg==
X-Received: by 2002:a05:6638:1305:b0:33f:7e59:4bc7 with SMTP id r5-20020a056638130500b0033f7e594bc7mr3471385jad.316.1659726083508;
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f43-20020a02242b000000b00342744f18a9sm1983541jaa.99.2022.08.05.12.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:01:23 -0700 (PDT)
Date:   Fri, 5 Aug 2022 13:01:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V3 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Message-ID: <20220805130121.36a2697d.alex.williamson@redhat.com>
In-Reply-To: <Yu08gdx2Py9vAN1n@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
        <20220731125503.142683-5-yishaih@nvidia.com>
        <Yu08gdx2Py9vAN1n@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Aug 2022 12:51:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sun, Jul 31, 2022 at 03:54:56PM +0300, Yishai Hadas wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > If a source file has the same name as a module then kbuild only supports
> > a single source file in the module.
> > 
> > Rename vfio.c to vfio_main.c so that we can have more that one .c file
> > in vfio.ko.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > 
> > ---
> >  drivers/vfio/Makefile                | 2 ++
> >  drivers/vfio/{vfio.c => vfio_main.c} | 0
> >  2 files changed, 2 insertions(+)
> >  rename drivers/vfio/{vfio.c => vfio_main.c} (100%)  
> 
> Alex, could you grab this patch for the current merge window?
> 
> It is a PITA to rebase across, it would be nice to have the rename in
> rc1

No objection from me, I'll see if Linus picks up my current pull
request and either pull this in or send it separately next week.
Thanks,

Alex

