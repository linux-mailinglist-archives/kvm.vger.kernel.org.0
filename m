Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17A96F85AB
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjEEP3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbjEEP3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2592D7C
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683300497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j9OUu/Zp5pTyzfVNholQKc+bsN1aJ2Nzh0OYi9UsbYY=;
        b=YMWdyuqlYbxesaMq3w2xkutiU8ZLcR5KJl8i+GedIyEud2GDKdBRuZs5Lw5B4TdARwFTy3
        ZAxfe2zWfiLYBs9jEuZlVi0AsQZmIO1dTmsY+EhtkIE6KMg9KJiN4Z10rj8C05mTggyi50
        gSvezuY00ISSDm7hCeUTGzSXqYk02HY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-728gL7rvP7K3t-QryS8eSQ-1; Fri, 05 May 2023 11:28:14 -0400
X-MC-Unique: 728gL7rvP7K3t-QryS8eSQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-331195f31acso25474705ab.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 08:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683300494; x=1685892494;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9OUu/Zp5pTyzfVNholQKc+bsN1aJ2Nzh0OYi9UsbYY=;
        b=JtNW6kcPKoiXkrPOj5q6bLFcQtWdDDiZcnmthJ5KmM2ANhLN7xx+OwjR0Y47n+6+5I
         +U63iPOl9JYPbZF3wE8cqkI1MwF/vEk5hykBicnOh5evPdMy6rVlUQamHer0gCN2JKf/
         7uFIs/QV+1xg8imOc/Sj5KGRqLxJV73Q5F2wwgdF4bCP5/dHbyKI0osaxlz5696C1OnW
         7R4n3KaUFkJsolO2ayqVF+v4Wd7CtAE4doHVi4WywrFG1S07IXicHQEnv4bcSbp4Ousi
         IHVFaBghjF2alIuUoF8DvbmkFGq1YyT7f+5WFp8NLaJRoY844l5DMFbP7AFnFcHF8COu
         Qotw==
X-Gm-Message-State: AC+VfDzud6JNkXa0jtEKE+gWa3hAAz6HLjYexjC0T7kfN91ZWJzpk9r3
        pLTXNLIcO8dQWmbkSzraKoKtlYhohB54cIA+pCa39/sSJKajFEzFLTTUzgD5ob4N2szx3df1Iu6
        UxHcuuCVfUasW
X-Received: by 2002:a92:de0f:0:b0:331:7203:b8b0 with SMTP id x15-20020a92de0f000000b003317203b8b0mr1429707ilm.3.1683300493938;
        Fri, 05 May 2023 08:28:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ64AzOZHOg/VekzzXWzlouLhgPMhFMfyoILAE3GX07RWSfkRW/Ym2lIe+qRLe9JTSGGpXtYww==
X-Received: by 2002:a92:de0f:0:b0:331:7203:b8b0 with SMTP id x15-20020a92de0f000000b003317203b8b0mr1429686ilm.3.1683300493688;
        Fri, 05 May 2023 08:28:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e26-20020a0566380cda00b0040f9c6ffb6fsm18536jak.76.2023.05.05.08.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 08:28:13 -0700 (PDT)
Date:   Fri, 5 May 2023 09:28:08 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 10/11] vfio/pci: Support dynamic MSI-X
Message-ID: <20230505092808.5c36e1f6.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
        <c4c582970fbeaf4b6000845c400aa4c6b7bb2f13.1682615447.git.reinette.chatre@intel.com>
        <BN9PR11MB5276B67702AACB0B5BF1EC0A8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <296ec21f-fc7d-eaf2-484c-27ae8815c5a8@intel.com>
        <BN9PR11MB5276ED7B47909222093E92438C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 May 2023 08:10:33 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Chatre, Reinette <reinette.chatre@intel.com>
> > Sent: Saturday, April 29, 2023 2:35 AM
> > 
> > Hi Kevin,
> > 
> > On 4/27/2023 11:50 PM, Tian, Kevin wrote:  
> > >> From: Chatre, Reinette <reinette.chatre@intel.com>
> > >> Sent: Friday, April 28, 2023 1:36 AM
> > >>
> > >> pci_msix_alloc_irq_at() enables an individual MSI-X interrupt to be
> > >> allocated after MSI-X enabling.
> > >>
> > >> Use dynamic MSI-X (if supported by the device) to allocate an interrupt
> > >> after MSI-X is enabled. An MSI-X interrupt is dynamically allocated at
> > >> the time a valid eventfd is assigned. This is different behavior from
> > >> a range provided during MSI-X enabling where interrupts are allocated
> > >> for the entire range whether a valid eventfd is provided for each
> > >> interrupt or not.
> > >>
> > >> The PCI-MSIX API requires that some number of irqs are allocated for
> > >> an initial set of vectors when enabling MSI-X on the device. When
> > >> dynamic MSIX allocation is not supported, the vector table, and thus
> > >> the allocated irq set can only be resized by disabling and re-enabling
> > >> MSI-X with a different range. In that case the irq allocation is
> > >> essentially a cache for configuring vectors within the previously
> > >> allocated vector range. When dynamic MSI-X allocation is supported,
> > >> the API still requires some initial set of irqs to be allocated, but
> > >> also supports allocating and freeing specific irq vectors both
> > >> within and beyond the initially allocated range.
> > >>
> > >> For consistency between modes, as well as to reduce latency and improve
> > >> reliability of allocations, and also simplicity, this implementation
> > >> only releases irqs via pci_free_irq_vectors() when either the interrupt
> > >> mode changes or the device is released.  
> > >
> > > It improves the reliability of allocations from the calling device p.o.v.
> > >
> > > But system-wide this is not efficient use of irqs and not releasing them
> > > timely may affect the reliability of allocations for other devices.  
> > 
> > Could you please elaborate how other devices may be impacted?  
> 
> the more this devices reserves the less remains for others, e.g. irte entries.
> 
> >   
> > > Should this behavior be something configurable?  
> > 
> > This is not clear to me and I look to you for guidance here. From practical
> > side it looks like configuration via module parameters is supported but
> > whether it should be done is not clear to me.
> > 
> > When considering this we need to think about what the user may expect
> > when
> > turning on/off the configuration. For example, MSI-X continues to allocate a
> > range of interrupts during enabling. These have always been treated as a
> > "cache" (interrupts remain allocated, whether they have an associated
> > trigger
> > or not). If there is new configurable behavior, do you expect that the
> > driver needs to distinguish between the original "cache" that the user is
> > used to and the new dynamic allocations? That is, should a dynamic MSI-X
> > capable device always free interrupts when user space removes an eventfd
> > or should only interrupts that were allocated dynamically be freed
> > dynamically?  
> 
> That looks tricky. Probably that is why Alex suggested doing this simple
> scheme and it is on par with the old logic anyway. So I'll withdraw this
> comment.

Don't forget we're also releasing the irq reservations when the guest
changes interrupt mode, ex. reboot, so the "caching" is really only
within a session of the guest/userspace driver where it would be
unusual to have an unused reservation for an extended period.  Thanks,

Alex

