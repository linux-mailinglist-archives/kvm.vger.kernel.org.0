Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD9A5A689A
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiH3Qmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 12:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiH3Qmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 12:42:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF92BAF4BB
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661877755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uPZ0ww9vg3e5wba1jpMWDOMwxa9Ldy+iPGjIGTE5slw=;
        b=Xu+LE3gvraNijWToZ6/DSA8CPHgl3qucrxx7Zf6wuy2sj2r7fcWznwtSLJUOLj0oE1cuHx
        5hA32i4pAvht0itRGQ5xc1E12Tr4KVILyrRLL8bGCCsYSjntoBee21vixN6DvPAKGngjm/
        jqb961Bgz5Cg8QezGr7AumV+8lxf3ao=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-ymqvegL2OsSLG65Zxo1K5w-1; Tue, 30 Aug 2022 12:42:34 -0400
X-MC-Unique: ymqvegL2OsSLG65Zxo1K5w-1
Received: by mail-io1-f72.google.com with SMTP id bh11-20020a056602370b00b00688c8a2b56cso6974606iob.13
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=uPZ0ww9vg3e5wba1jpMWDOMwxa9Ldy+iPGjIGTE5slw=;
        b=PZ6FX0lDRpul6FwjYLfbGgcr+QbskD4/kwf2M8tfBTIwF/a9BCS204UUApynMyvez1
         D/cgl+C0DL978n1dzkg8SzAfN7CNDhCeKj0Qdgf0KKPgym+BjfX8trdqW6Kjxpv2w+UA
         U0MTGYmxjGC8hW0R/SvCMyK5YdMAefuYDfi/Rjnkx2oTN5tGMSqHnVTByZBoFfR6Qc8R
         L3YKliPW1dwRudgDQuVxrOIbLVnomgAFH0b46ev0v9icXiFin3esW3uQTUr3ghRsEsG9
         xMaNrr0gZzRaSAXxbK0T9oUheBj5T65NorMiqK+DQ3eGQg7zXWS2KkzTBEfkNXH3v5Qf
         b0rw==
X-Gm-Message-State: ACgBeo1yrtqLAP3ZBh8Uw8GHuJYfPMLlo9IeleHNA+z8DtsuM65DSMBT
        nANYayFGfnHejZ0tSLzBepF3+ctbXmx1hRcaWkXupKDoMj1DWC7KN5+In7FcLhS+FlRTST0V0J6
        m6LcO+7e9KxLQ
X-Received: by 2002:a05:6602:27c1:b0:688:6a81:8d91 with SMTP id l1-20020a05660227c100b006886a818d91mr11618139ios.189.1661877753306;
        Tue, 30 Aug 2022 09:42:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6i3F6bgTizb0kdbW2f//YvjaU2wFi/oE+HdztyPkBjmAd9hjsyqXqwCRNS3hWZFU5Akgcxeg==
X-Received: by 2002:a05:6602:27c1:b0:688:6a81:8d91 with SMTP id l1-20020a05660227c100b006886a818d91mr11618129ios.189.1661877753077;
        Tue, 30 Aug 2022 09:42:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n15-20020a02c78f000000b003434a4acb8fsm5650072jao.117.2022.08.30.09.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:42:32 -0700 (PDT)
Date:   Tue, 30 Aug 2022 10:42:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Message-ID: <20220830104231.0bbb7c89.alex.williamson@redhat.com>
In-Reply-To: <YwzbB5NZGOqOsOVK@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
        <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <YwzbB5NZGOqOsOVK@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Aug 2022 12:28:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Aug 29, 2022 at 12:41:30AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, August 18, 2022 12:07 AM
> > > 
> > > Make it clear that this is the body of the ioctl - keep the mutex outside
> > > the function since this function doesn't have and wouldn't benefit from
> > > error unwind.  
> > 
> > but doing so make unset_container() unpair with set_container() and
> > be the only one doing additional things in main ioctl body.
> > 
> > I'd prefer to moving mutex inside unset_container() for better readability.  
> 
> Yes, I tried both ways and ended up here since adding the goto unwind
> was kind of ungainly for this function. Don't mind either way
> 
> The functions are not intended as strict pairs, they are ioctl
> dispatch functions.

The lockdep annotation seems sufficient, but what about simply
prefixing the unset ioctl function with underscores to reinforce the
locking requirement, as done by the called function
__vfio_group_unset_container()?  Thanks,

Alex

