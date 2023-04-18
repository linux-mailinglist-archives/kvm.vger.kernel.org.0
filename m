Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C906E6D95
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 22:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDRUlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 16:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDRUlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 16:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167AF9750
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681850425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q8kM5inZb2d3T//h4ttitFDvzuKHsR8ItNBjFDFDoTM=;
        b=fdFEk69LjfBXBNvsHAjnMpHuY7oCUkt3S7Ic8pUg6D8FCdkHUo2gupUpD8q6Cn/DEIBm+L
        RBwd3kOUY7x02CDG8WTb0sjMxqQIdnAH0xU0YuUAaQOkqoDjzYge/09Ufn4FnUM2CkrgVa
        5fZnMWpcxrCGNA9WipL1wKjelF9OOG0=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-IknWLhgPMwmZ3T8ETSYkEg-1; Tue, 18 Apr 2023 16:40:24 -0400
X-MC-Unique: IknWLhgPMwmZ3T8ETSYkEg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32abae1ff3aso46082375ab.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 13:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681850423; x=1684442423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q8kM5inZb2d3T//h4ttitFDvzuKHsR8ItNBjFDFDoTM=;
        b=DvU5froE0qiBXA0W/QH006/R+NspDq5XFcsEh3wuSOv7VCjix23ABU1jAC9Q4Qd4A6
         wNcsAPvz5HINp5Gq+Iw0PH81qTD9wmWmkrZDz/245axl7V+u2VugRK+3wkeJ259hmnwX
         b9f+xkKAv+6r4boq9y1jqavTcP5L9DisAqW1tavWB8r1AfglB+9yqxU63TKhJ/RdO7nM
         sx1qntcILmWCzhWLpIYSzVUa9bHlmZzzEo7dqDkL3c5BPR/IiPd2SouF4N8twms9xHaF
         Iz9xdn8G92/4E+wW7Tv/e1YxhkhmRW6ruEobftsXR2UriJ0zdPRt819GBMqNFW8yxurB
         yv9w==
X-Gm-Message-State: AAQBX9eQldh3avR9mx8kSEX655SIZ685JTanLDHfdH6D2IMz0dFqOWHu
        xiVNMpKSymAAQWKTp+9Wq2axBGDqUwx4RCpLOp/+udqOznA/dKOuCScjRmUvn5tyhhK1PR7Hf6Z
        Q83e0QEBiVOdXZJviUYkp
X-Received: by 2002:a92:c807:0:b0:329:4a17:4b17 with SMTP id v7-20020a92c807000000b003294a174b17mr1505933iln.21.1681850423737;
        Tue, 18 Apr 2023 13:40:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350YGtmkRKYs7vTtZBkNI5VoCiemSeU6gyMTNqv6GA2PgWmO5GhcU0tMeWb/4Z/6I5YajetDqQg==
X-Received: by 2002:a92:c807:0:b0:329:4a17:4b17 with SMTP id v7-20020a92c807000000b003294a174b17mr1505926iln.21.1681850423487;
        Tue, 18 Apr 2023 13:40:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a9-20020a056e020e0900b00328ab01a23fsm4063807ilk.14.2023.04.18.13.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 13:40:22 -0700 (PDT)
Date:   Tue, 18 Apr 2023 14:40:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nicolas@fjasle.eu" <nicolas@fjasle.eu>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Jansen Van Vuuren, Pieter" <pieter.jansen-van-vuuren@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>
Subject: Re: [PATCH v4] vfio/cdx: add support for CDX bus
Message-ID: <20230418144020.6b8368db.alex.williamson@redhat.com>
In-Reply-To: <CH3PR12MB8308DE1607789063D04B3529E89D9@CH3PR12MB8308.namprd12.prod.outlook.com>
References: <20230418113655.25207-1-nipun.gupta@amd.com>
        <ZD6IiHjWQOv47ZMg@ziepe.ca>
        <CH3PR12MB8308DE1607789063D04B3529E89D9@CH3PR12MB8308.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 12:50:13 +0000
"Gupta, Nipun" <Nipun.Gupta@amd.com> wrote:

> > -----Original Message-----
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Tuesday, April 18, 2023 5:40 PM
> > To: Gupta, Nipun <Nipun.Gupta@amd.com>
> > Cc: alex.williamson@redhat.com; linux-kernel@vger.kernel.org;
> > kvm@vger.kernel.org; masahiroy@kernel.org; nathan@kernel.org;
> > ndesaulniers@google.com; nicolas@fjasle.eu; git (AMD-Xilinx) <git@amd.com>;
> > Anand, Harpreet <harpreet.anand@amd.com>; Jansen Van Vuuren, Pieter
> > <pieter.jansen-van-vuuren@amd.com>; Agarwal, Nikhil
> > <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>
> > Subject: Re: [PATCH v4] vfio/cdx: add support for CDX bus
> > 
> > Caution: This message originated from an External Source. Use proper caution
> > when opening attachments, clicking links, or responding.
> > 
> > 
> > On Tue, Apr 18, 2023 at 05:06:55PM +0530, Nipun Gupta wrote:
> >   
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 89e06c981e43..aba36f5be4ec 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
> > >  source "drivers/vfio/platform/Kconfig"
> > >  source "drivers/vfio/mdev/Kconfig"
> > >  source "drivers/vfio/fsl-mc/Kconfig"
> > > +source "drivers/vfio/cdx/Kconfig"  
> > 
> > keep sorted  
> 
> Since it is not sorted as of now, should a separate patch to be created for
> sorting, before adding vfio-cdx?

These are essentially in chronological order rather than alphabetical,
so I don't really understand this request from Jason.  Perhaps if it
was already alphabetical the request would be justified, but I don't
see any obligation here.

> > >  endif
> > >
> > >  source "virt/lib/Kconfig"
> > > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > > index 70e7dcb302ef..1a27b2516612 100644
> > > --- a/drivers/vfio/Makefile
> > > +++ b/drivers/vfio/Makefile
> > > @@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
> > >  obj-$(CONFIG_VFIO_PLATFORM) += platform/
> > >  obj-$(CONFIG_VFIO_MDEV) += mdev/
> > >  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> > > +obj-$(CONFIG_VFIO_CDX) += cdx/  
> > 
> > keep sorted  
> 
> Is there Linux guideline here on how objects and folders in Makefile are sorted,
> as there are mix and match of files and folders in "drivers/vfio/Makefile".
> I could not find any reference for sorting in other Makefiles as well.

Same here, and I also don't know of a best practices reference that
suggests an alphabetical ordering policy.

> > > diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> > > new file mode 100644
> > > index 000000000000..82e4ef412c0f
> > > --- /dev/null
> > > +++ b/drivers/vfio/cdx/Makefile
> > > @@ -0,0 +1,8 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +#
> > > +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> > > +#
> > > +
> > > +obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
> > > +
> > > +vfio-cdx-objs := vfio_cdx.o  
> > 
> > Linus has asked about "suttering" filenames before, suggest to call
> > this
> > 
> > "vfio/cdx/main.c"  
> 
> Okay, I do not any strong affiliation towards the name.
> Alex, your thoughts on this please?

I think Jason means "stuttering" file paths, or essentially self
redundancy, ex. vfio/cdx/vfio_cdx.c.  Yes, Linus has scolded us for
vfio/pci/vfio_pci_* naming in the past, so in the spirit of not being
further scolded I'd agree with the suggestion here.  Thanks,

Alex

