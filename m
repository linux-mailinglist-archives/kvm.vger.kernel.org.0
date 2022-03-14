Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1354D8C2A
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbiCNTSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiCNTSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 293D339686
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647285461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=daDOGiFxYv+daOkza11q48xlAEr2nJLNiwY29z+sBn8=;
        b=T1WBWK/uB5k8/avts5YsQ9PXqUDk/DBdSlRIg5QgL5CBD24YuMwuMo3mDFInKIcGBJmUEs
        XqrVnIBeXTqjMsByQfbpgdZ0//cVSymS/ftsefGC8exN9yUsuQFGLUB2PvX02fKzUqnP7l
        HkboYVbi+p7naDpRqza6YjUgtcc7WZ4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-c6TrYvA-Oxm7Nc-T228P9A-1; Mon, 14 Mar 2022 15:17:40 -0400
X-MC-Unique: c6TrYvA-Oxm7Nc-T228P9A-1
Received: by mail-io1-f72.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so12920601iox.10
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=daDOGiFxYv+daOkza11q48xlAEr2nJLNiwY29z+sBn8=;
        b=7DMA48u+ouqZBLq/1tMOXZLbXaw1WVV9c8i+2iOljbzS8wKrM1tU1Xw2StaKLF82cK
         O2eJRfdK0I0qTltjU1Yup0o2jP3Q9uCTg7w4yqqFbgRvL5fxS/+q8dBU/N/vyMPLs56C
         VTVs7iB+jQR9Vw9mJEOuE+soo2QhYcydBz7nxTnA8XIr3LlAwgU2BPly+NcJHsggS0N9
         kKvCNnuGf1D/g8nQwctcVJVLZWpn2fOdqDCUBwgtQsRys9Ro1OuUJdO+YmUXncI6NOOG
         meld/7n+tQU6rublOamubwAK48SigUF5ADizcQkYW7xmNeXumkYJcP1ta2eSafpASPq1
         bI8w==
X-Gm-Message-State: AOAM531zyBrHf4hawB6wd5IvMoczMkpQ8COkcnxyPZ+Fbv7EaQhBSBg9
        p9PZA30sl62OBLvQdbVUjtlpF6JIZOR9T2bPfJd6TxQNDO4OUbkzj3aJ/0xQD20arxXr8iyNgAV
        HP4N/RwJC+2Dl
X-Received: by 2002:a05:6e02:1c8c:b0:2c7:9b38:69ea with SMTP id w12-20020a056e021c8c00b002c79b3869eamr7193963ill.50.1647285459485;
        Mon, 14 Mar 2022 12:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzo3y4VD1H3SQM7st2tJN84lL8sPivPb1chKeRJw63xDV4M4CIwHF2nrTiSJFiTG0fkaJKYBw==
X-Received: by 2002:a05:6e02:1c8c:b0:2c7:9b38:69ea with SMTP id w12-20020a056e021c8c00b002c79b3869eamr7193954ill.50.1647285459222;
        Mon, 14 Mar 2022 12:17:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n14-20020a056602340e00b00648c287cc02sm6029337ioz.27.2022.03.14.12.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:17:38 -0700 (PDT)
Date:   Mon, 14 Mar 2022 13:17:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <linux-kernel@vger.kernel.org>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <linux-doc@vger.kernel.org>, <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci: Provide reviewers and acceptance criteria for
 vendor drivers
Message-ID: <20220314131738.146c3e79.alex.williamson@redhat.com>
In-Reply-To: <a635abc8-be36-a9ee-dd8b-2950cc368562@nvidia.com>
References: <164727326053.17467.1731353533389014796.stgit@omen>
        <a635abc8-be36-a9ee-dd8b-2950cc368562@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Mar 2022 21:07:01 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 3/14/2022 6:09 PM, Alex Williamson wrote:
> > Vendor or device specific extensions for devices exposed to userspace
> > through the vfio-pci-core library open both new functionality and new
> > risks.  Here we attempt to provided formalized requirements and
> > expectations to ensure that future drivers both collaborate in their
> > interaction with existing host drivers, as well as receive additional
> > reviews from community members with experience in this area.
> >
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>
> > Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >
> > Per the proposal here[1], I've collected those that volunteered and
> > those that I interpreted as showing interest (alpha by last name).  For
> > those on the reviewers list below, please R-b/A-b to keep your name as a
> > reviewer.  More volunteers are still welcome, please let me know
> > explicitly; R-b/A-b will not be used to automatically add reviewers but
> > are of course welcome.  Thanks,  
> 
> You can add me as well to the reviewers list.

Thanks, Yishai!  v2 posted including you, please send ack or review.
Thanks,

Alex

