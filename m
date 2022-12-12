Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5932E64A482
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiLLP70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLLP7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:59:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D2C12617
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 07:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670860708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cyj1Dm61wUcFqeq0mO7hkOXB3pIX62LvdhDCjcOXZL0=;
        b=dePVgDq0KWOszM1whNDad8B4D758OGAx1Uw65JmFuBLsaZF3e91ivOcnNR8wYsJk71kWbh
        wiuKoG/Cd8ESBpprPRinl6ElpybCYOOCV3QitxiQKBaT4IhHauBlYr9EaOoIfngnUZN8z8
        ax8cfe2jJjlvCUb0HSjYkGpUktiQwRM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-zAGJfAMQMGCIQe8TeOp8Cw-1; Mon, 12 Dec 2022 10:58:27 -0500
X-MC-Unique: zAGJfAMQMGCIQe8TeOp8Cw-1
Received: by mail-il1-f197.google.com with SMTP id j11-20020a056e02218b00b00304b148969dso3188487ila.13
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 07:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cyj1Dm61wUcFqeq0mO7hkOXB3pIX62LvdhDCjcOXZL0=;
        b=EKFuW/IPqfC9KmZKpAAkuSTiblCf0l0e2YuuBXiuox5ET1wK+udb44HcDxZcZFiBbC
         Um1j4TloPjk222qXTYr52AxXPr/SrT8Ec9QKMYx5aQpq3uuWejeMKSQfVVf+ZBqzxtFq
         sNQEhkIwFJTbMYMRFEHsOgtLdtXoeNNTTevtV8/ruUWDPDlw1xFZqF0yS25qszz8nHqA
         Yk/EdVSsRFu0Jw+D1j8YLDyUZt+vRpH/w4vPfgd5qoSW8PWkrHxj1JshPCkQueH/DNqs
         vNM5uvkY4b1gt2gI7yieODEBH8S1nKDgkOlnY+RZJfoQFpq3Oraq4RR7XB5/Ft9oONUA
         pAWg==
X-Gm-Message-State: ANoB5pmWz1tLgeilWdO7vZ8cLsRegIwRWr9EdUeMXovN9rg0luJGwPz/
        UZMne2VU0FDt+tw5krJTNK3tplhQyoERHCt54aVBv64WLunlWxg1vbz1fc/94mBNMk23NVuU6Zj
        T0jf6CC0f9f3R
X-Received: by 2002:a6b:fb0a:0:b0:6df:5a37:ed5 with SMTP id h10-20020a6bfb0a000000b006df5a370ed5mr8654431iog.17.1670860706498;
        Mon, 12 Dec 2022 07:58:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7CHG988r6GMtCvEDH15M9FbZ2JNwztAhGzWghBG+ceXH0T8+7A7lcXohouOcabqqQLfJhHkg==
X-Received: by 2002:a6b:fb0a:0:b0:6df:5a37:ed5 with SMTP id h10-20020a6bfb0a000000b006df5a370ed5mr8654425iog.17.1670860706230;
        Mon, 12 Dec 2022 07:58:26 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b97-20020a0295ea000000b00370decbbff3sm32593jai.148.2022.12.12.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 07:58:25 -0800 (PST)
Date:   Mon, 12 Dec 2022 08:58:23 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221212085823.5d760656.alex.williamson@redhat.com>
In-Reply-To: <Y5cqAk1/6ayzmTjg@ziepe.ca>
References: <167044909523.3885870.619291306425395938.stgit@omen>
        <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20221208094008.1b79dd59.alex.williamson@redhat.com>
        <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
        <20221209124212.672b7a9c.alex.williamson@redhat.com>
        <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
        <20221209140120.667cb658.alex.williamson@redhat.com>
        <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
        <Y5cqAk1/6ayzmTjg@ziepe.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Mon, 12 Dec 2022 09:17:54 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> 
> > Thank you for your thoughtful response.  Rather than debate the degree of
> > of vulnerability, I propose an alternate solution.  The technical crux of
> > the matter is support for mediated devices.    
> 
> I'm not sure I'm convinced about that. It is easy to make problematic
> situations with mdevs, but that doesn't mean other cases don't exist
> too eg what happens if userspace suspends and then immediately does
> something to trigger a domain attachment? Doesn't it still deadlock
> the kernel?

The opportunity for that to deadlock isn't obvious to me, a replay
would be stalled waiting for invalid vaddrs, but this is essentially
the user deadlocking themselves.  There's also code there to handle the
process getting killed while waiting, making it interruptible.  Thanks,

Alex

