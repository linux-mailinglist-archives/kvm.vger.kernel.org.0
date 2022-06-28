Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9880B55E025
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiF1MBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiF1MBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:01:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD09E248D4
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 05:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656417677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UB+jWJJOrlgRb4vi0jdlysSgI5DHBdJAyORCSjXEsls=;
        b=Az5jt0RbqyNgUQU/iUCfN032jzUhzLxgFxGc4dsjv8TCDseuMt3iwn/1oXUHNbSGkjm84X
        66nQDiR4wllA0U3VIbT/FQlFTgFoJceTtNwJuDrcLijKqTKWmCsi+qwQNYZse8NhjP9jDf
        5aAgGYvO1biLK8h03JpYXAmRxfBwmOc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-zx7AVWnPMF-gex0GuNpTlA-1; Tue, 28 Jun 2022 08:01:16 -0400
X-MC-Unique: zx7AVWnPMF-gex0GuNpTlA-1
Received: by mail-wr1-f69.google.com with SMTP id w17-20020a5d6811000000b0021ba89c2e27so1760650wru.10
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 05:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UB+jWJJOrlgRb4vi0jdlysSgI5DHBdJAyORCSjXEsls=;
        b=mQEay5hrli6rC3cEh8QUqDt2+iMbJNJ1d4ntqiMF/OB6wHXmwGJSYCq1cQNRR5GT9M
         FQetKFrVHyD7las2gEXl5ppYMlngIkiVKkzjKOg4ch31HjtHhE5MNCugHHfoTgea65i/
         FWg3q42XP4IdruNJ4nTqti6aUUMZwBZ6r74CxoWGGFrqpaJMRp2cOrSFldmVHtbwwHNt
         v1JcjPQ1PjD54TkFZ7eBCZNHlBCdnlCbAS8u0ZzMJmZ83FDJ1mEwAr9tN51D0m9salzG
         v0cF8Rz7FW5kc8IWaiVYXVompVZPhaFCeWoNkJ8H0ni5SqE2ZXfQKKd6VZjuskZVBrVU
         SKGA==
X-Gm-Message-State: AJIora9vghw6nq97304DVtOSPJ+XKQjG5GbJEfuSXDfuihsQR3dI168y
        MovRotVmWu1FD4oDThZ+7mwvfr+H2OeIe69rySXCe0EQqP2wIRSmaUqLHYC/QJb5Tlpo3O+YDF3
        MB5WvSfXLZo3U
X-Received: by 2002:a05:6000:60b:b0:21b:bd9b:aa15 with SMTP id bn11-20020a056000060b00b0021bbd9baa15mr16293324wrb.365.1656417674725;
        Tue, 28 Jun 2022 05:01:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t5u3NHA/Kst5TxtCM47Bf7rL+ll44GXY6Jcg/sFDaehltv6YIbLBct0treW57gZ+WpSik8TA==
X-Received: by 2002:a05:6000:60b:b0:21b:bd9b:aa15 with SMTP id bn11-20020a056000060b00b0021bbd9baa15mr16293277wrb.365.1656417674397;
        Tue, 28 Jun 2022 05:01:14 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n9-20020a7bcbc9000000b003a039054567sm17186570wmi.18.2022.06.28.05.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 05:01:13 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:01:12 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Len Brown <len.brown@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
Message-ID: <20220628140112.661154cf@redhat.com>
In-Reply-To: <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
References: <cover.1655894131.git.kai.huang@intel.com>
        <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
        <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Jun 2022 13:45:01 +0200
"Rafael J. Wysocki" <rafael@kernel.org> wrote:

> On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
> >
> > Platforms with confidential computing technology may not support ACPI
> > memory hotplug when such technology is enabled by the BIOS.  Examples
> > include Intel platforms which support Intel Trust Domain Extensions
> > (TDX).
> >
> > If the kernel ever receives ACPI memory hotplug event, it is likely a
> > BIOS bug.  For ACPI memory hot-add, the kernel should speak out this is
> > a BIOS bug and reject the new memory.  For hot-removal, for simplicity
> > just assume the kernel cannot continue to work normally, and just BUG().
> >
> > Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate the
> > platform doesn't support ACPI memory hotplug, so that kernel can handle
> > ACPI memory hotplug events for such platform.
> >
> > In acpi_memory_device_{add|remove}(), add early check against this
> > attribute and handle accordingly if it is set.
> >
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
> >  include/linux/cc_platform.h    | 10 ++++++++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > index 24f662d8bd39..94d6354ea453 100644
> > --- a/drivers/acpi/acpi_memhotplug.c
> > +++ b/drivers/acpi/acpi_memhotplug.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/acpi.h>
> >  #include <linux/memory.h>
> >  #include <linux/memory_hotplug.h>
> > +#include <linux/cc_platform.h>
> >
> >  #include "internal.h"
> >
> > @@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_device *device,
> >         if (!device)
> >                 return -EINVAL;
> >
> > +       /*
> > +        * If the confidential computing platform doesn't support ACPI
> > +        * memory hotplug, the BIOS should never deliver such event to
> > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> > +        * the memory device.
> > +        */
> > +       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED)) {  
> 
> Same comment as for the acpi_processor driver: this will affect the
> initialization too and it would be cleaner to reset the
> .hotplug.enabled flag of the scan handler.

with QEMU, it is likely broken when memory is added as
  '-device pc-dimm'
on CLI since it's advertised only as device node in DSDT.

> 
> > +               dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI memory hotplug. New memory device ignored.\n");
> > +               return -EINVAL;
> > +       }
> > +
> >         mem_device = kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
> >         if (!mem_device)
> >                 return -ENOMEM;
> > @@ -334,6 +346,17 @@ static void acpi_memory_device_remove(struct acpi_device *device)
> >         if (!device || !acpi_driver_data(device))
> >                 return;
> >
> > +       /*
> > +        * The confidential computing platform is broken if ACPI memory
> > +        * hot-removal isn't supported but it happened anyway.  Assume
> > +        * it is not guaranteed that the kernel can continue to work
> > +        * normally.  Just BUG().
> > +        */
> > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> > +               dev_err(&device->dev, "Platform doesn't support ACPI memory hotplug. BUG().\n");
> > +               BUG();
> > +       }
> > +
> >         mem_device = acpi_driver_data(device);
> >         acpi_memory_remove_memory(mem_device);
> >         acpi_memory_device_free(mem_device);
> > diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> > index 9ce9256facc8..b831c24bd7f6 100644
> > --- a/include/linux/cc_platform.h
> > +++ b/include/linux/cc_platform.h
> > @@ -93,6 +93,16 @@ enum cc_attr {
> >          * Examples include TDX platform.
> >          */
> >         CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED,
> > +
> > +       /**
> > +        * @CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED: ACPI memory hotplug is
> > +        *                                        not supported.
> > +        *
> > +        * The platform/os does not support ACPI memory hotplug.
> > +        *
> > +        * Examples include TDX platform.
> > +        */
> > +       CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED,
> >  };
> >
> >  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> > --
> > 2.36.1
> >  
> 

