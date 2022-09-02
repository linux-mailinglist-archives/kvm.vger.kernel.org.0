Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147175AB879
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiIBSnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 14:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiIBSnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 14:43:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBE3112EF5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 11:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662144187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkQeBnTijrLXZ/faOr5j44851js3+0quKExFB4IcaLs=;
        b=eWHwkHtXHx86PSjT2HsJu9Ij/8jHlThiA9i8YeGOslD1vo99ytwBfJia5NcsMGA6gs2kj5
        mCKt3yVFY5w/EZ+ZuA4waKeVV3LrFy0XNe8cAsblh88s/gEDTdqWjpEs96Op85RICm60J6
        qxHOh136fItiQRp3eT+RTJG5xKtW3Ok=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-78-k_NW0hl7ONCThFPmY4jnWA-1; Fri, 02 Sep 2022 14:43:04 -0400
X-MC-Unique: k_NW0hl7ONCThFPmY4jnWA-1
Received: by mail-il1-f200.google.com with SMTP id e2-20020a056e020b2200b002e1a5b67e29so2396233ilu.11
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 11:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=GkQeBnTijrLXZ/faOr5j44851js3+0quKExFB4IcaLs=;
        b=zkEL4RGRx2WsrcJD9FruT2bYk9nGtKCBp9PXm3qYlA0LHVza+eOqWITJCEJc4fp2tx
         DyepQeX04YTZra+9GrhZ96sKpqluI4x5mdUX3jNXtxkGHLyfwpguNdAFuXAImg0Y95y+
         nUvOeOnrY+JROEu7Ng6kTJN/COZ2COggZb5fxJZs2nsXqe2vpmFPdMT/oqlQH9clxTvc
         gk2rOSp+nqwKEoXRuFUFrDRugxWf/+unjaGX76Ve8IvWWlIlglR77xMYioBpuiNTQDs/
         FTNLt5LYFDB7fo/jS2+XLvltWH1jjFIpvKByoXWHNvRYDfDnKElAI9EWktPlBBbzEL1O
         2kNQ==
X-Gm-Message-State: ACgBeo1eVmaRUxhI/+74vC2XNxNU6aJjh2mYAdFTNNYwJSBmaC7o0QjE
        B6yiGya5w+SquGMiBajp+NuIMUGEaAbgJhbZIvsi4hvCYRRMxHZF2OZBY4tOuCl9A7ziVtgI4id
        dzbDzGqqD9X0e
X-Received: by 2002:a05:6638:130c:b0:343:5bc5:7a45 with SMTP id r12-20020a056638130c00b003435bc57a45mr21056257jad.250.1662144183883;
        Fri, 02 Sep 2022 11:43:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR47C2qGZNrW880NJXQ8ruteIAjb7tqheAx1HJ2HEfAtkyfjpRPn1BIqRpqfOZ6NCVfnrnf6CQ==
X-Received: by 2002:a05:6638:130c:b0:343:5bc5:7a45 with SMTP id r12-20020a056638130c00b003435bc57a45mr21056250jad.250.1662144183722;
        Fri, 02 Sep 2022 11:43:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x6-20020a056602160600b0067b7a057ee8sm1126680iow.25.2022.09.02.11.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:43:03 -0700 (PDT)
Date:   Fri, 2 Sep 2022 12:42:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/3] Remove private items from linux/vfio_pci_core.h
Message-ID: <20220902124231.5ced46d6.alex.williamson@redhat.com>
In-Reply-To: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
References: <0-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Aug 2022 16:34:00 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The include/linux header should only include things that are intended to
> be used outside the internal implementation of the vfio_pci_core
> module. Several internal-only items were left over in this file after the
> conversion from vfio_pci.
> 
> Transfer most of the items to a new vfio_pci_priv.h located under
> drivers/vfio/pci/.
> 
> v2:

Applied to vfio next branch for v6.1.  Thanks,

Alex

