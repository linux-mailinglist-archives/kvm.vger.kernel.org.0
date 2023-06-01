Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E278071F511
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 23:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjFAVua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 17:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjFAVuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 17:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F3AE76
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 14:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685656142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PELrOUSaGQYkmJ7KQAjCHNVO7U9hEY8agkWV8L2aw1s=;
        b=L4CbqqbekP6gJTuqpSA6hMY7Ix7vUE977IgNVGfEDzlU9uLzDPu4nd113uPSeyGFZgiVGB
        pqdwoO7Dfct5+uJdscVbmdOiYOfNhgJcIUfykG3Xu8R5DbKuNVxv1gjsbun68EWeG9ro8Y
        SScRmaDK2/KdQORFkm+4f/rmAQjJds0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-jASmm308OJmKcJ-UVpSDEA-1; Thu, 01 Jun 2023 17:49:01 -0400
X-MC-Unique: jASmm308OJmKcJ-UVpSDEA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-769036b47a7so35770039f.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 14:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685656140; x=1688248140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PELrOUSaGQYkmJ7KQAjCHNVO7U9hEY8agkWV8L2aw1s=;
        b=I9bjreNDYXtJ8+qLXackM/z2Ajw0SmEseKRoHcfa1kJrZdQd3RIUnTAEznFrVEWPal
         /ZQHeCWEWBU35iTie3Cyzgy27L3q57In3+2SyWPMakDRrUa+83dGY1l3S43YnDoXu1N6
         RTVPFSboek4djUplae152DCY8g/uEL1DTzwYbDcP4UCxGsJiAntg74xreh0iBqa9ie2h
         67P6v1+VQWq4CBI09TQ3vtwWeFVZWPspz/bJmrxxlWzS5uPiyWXRbqyAjyPZRbvFyour
         KK+QnPT+ylLyR/x+6J9S6cHRGUB78ItVbeLLSiBZ0sVzvNV4uXepTaEw8YBNOpBJm2XC
         x8ZA==
X-Gm-Message-State: AC+VfDxauYDjR39QQh/9MvXJVUk80473whWE9GOp96xnzyo+jfxzqD5y
        BT/GqsLfI6DNdaJ5PP8lUG6atEuKgUH6psZfSIGaOHbw4buYMwC6KTV3gjzYAmCX1ufmfdj8Lcu
        3ZXeQjQE54gqTHOcErFX8
X-Received: by 2002:a5d:884c:0:b0:717:ce6a:188a with SMTP id t12-20020a5d884c000000b00717ce6a188amr493388ios.18.1685656140016;
        Thu, 01 Jun 2023 14:49:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6+NTs68CmLSK7I4KHPMaGzibqoBNcjTeCpMt/yqB5ULhUf+X6q0/msn0T+dpasC3GjmbM6aA==
X-Received: by 2002:a5d:884c:0:b0:717:ce6a:188a with SMTP id t12-20020a5d884c000000b00717ce6a188amr493383ios.18.1685656139720;
        Thu, 01 Jun 2023 14:48:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k4-20020a02c644000000b004161870da90sm93920jan.151.2023.06.01.14.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 14:48:59 -0700 (PDT)
Date:   Thu, 1 Jun 2023 15:48:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio: Fixup kconfig ordering for VFIO_PCI_CORE
Message-ID: <20230601154857.62cbe199.alex.williamson@redhat.com>
In-Reply-To: <ZHkEG28EFVDKVb/Z@nvidia.com>
References: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
        <20230601144238.77c2ad29.alex.williamson@redhat.com>
        <ZHkEG28EFVDKVb/Z@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Jun 2023 17:48:27 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 01, 2023 at 02:42:38PM -0600, Alex Williamson wrote:
> > On Mon, 29 May 2023 14:47:59 -0300  
> > > +config VFIO_PCI_CORE
> > > +	tristate "VFIO support for PCI devices"
> > > +	select VFIO_VIRQFD
> > > +	select IRQ_BYPASS_MANAGER
> > > +	help
> > > +	  Base support for VFIO drivers that support PCI devices. At least one
> > > +	  of the implementation drivers must be selected.  
> > 
> > As enforced by what?  
> 
> Doesn't need to be enforced. Probably should have said "should"
> 
> > This is just adding one more layer of dependencies in order to select
> > the actual endpoint driver that is actually what anyone cares about.  
> 
> This is making the kconfig more logical and the menu structure better
> organized. We eliminate the need for the drivers to set special
> depends because the if covers them all.

We can create a menu with a dummy config option, ex:

config VFIO_PCI_DRIVERS
        bool "VFIO support for PCI devices"
        default y

if VFIO_PCI_DRIVERS
...

So the menu organization itself isn't sufficient for me to make
VFIO_PCI_CORE to root of that menu.

The flip side of requiring drivers to set a "special depends" is that
it's possible we might have a PCI variant driver that doesn't use
VFIO_PCI_CORE.  It would be a hard sell, but it's possible.  It also
shouldn't be terribly subtle to the existing variant drivers relying on
vfio-pci-core that this dependency exists.

Allowing VFIO_PCI_CORE without building an in-kernel module that
depends on it seals the deal for me that this is the wrong approach
though.

> > I don't see why we wouldn't just make each of the variant drivers
> > select VFIO_PCI_CORE.  Thanks,  
> 
> It can be done, but it seems more fragile.

How so?  Thanks,

Alex

