Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B661A5549BE
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357539AbiFVLpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356662AbiFVLpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:45:16 -0400
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6C2F678;
        Wed, 22 Jun 2022 04:45:12 -0700 (PDT)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-317741c86fdso158073667b3.2;
        Wed, 22 Jun 2022 04:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WTX5K5BXaj2TDhZZlmgXid9tNKs4pj/o6tthvz/low=;
        b=XymGisvmk2hNRg3ICbbGNxV1yO8m5GlNmDZ7gTpUL8RU7jQpkXciak9CbruEiiR3Re
         BXu0sqowB5ANkoFnqq91WfD7nmDDTytxz0k9PMjFEYEZpwSCKEa0pXd1eDYzmG8pJaoE
         Xjir3JAupS4v/EU1O7+oUWNmTcsY/+mdVRQiwzMPTzYQ4NRkurkVUO2O6PokZDnCGVJY
         MymWtQbT0gla99g0+Ayws7kwZkWpWvZTt2ss6dMMt5FkPD5VpSWVfYBGK49jaFLQSOUs
         os5WerQsg6j9nBojFZQiSRv2xhHFmR7px0Y4YlYDueXvGdVGHwCSaf5LU28cqdwUawnw
         NwEA==
X-Gm-Message-State: AJIora+FecAWgTN5sfQCGYvmku0WEpy1SEfrly8mFRmDJ4NeJ/FSL2lm
        XOYRlje6IzSfCZQNBtMsAazFBYzX2uNTI3/TfN0=
X-Google-Smtp-Source: AGRyM1vKezNUcA2B6JEFkznvZwjvQMXmsj14ucblc3UnJ6lN1obXSj885c+JN2R5PaIcPMi5MxcjQX+CLK48hm3jbeU=
X-Received: by 2002:a81:6c06:0:b0:317:94ff:d1a with SMTP id
 h6-20020a816c06000000b0031794ff0d1amr3643424ywc.515.1655898311852; Wed, 22
 Jun 2022 04:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655894131.git.kai.huang@intel.com> <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
In-Reply-To: <87dc19c47bad73509359c8e1e3a81d51d1681e4c.1655894131.git.kai.huang@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 22 Jun 2022 13:45:01 +0200
Message-ID: <CAJZ5v0jEJNdmkidvcOiRn+OVt01D5095t+nyXaJHKsqEAOvcBQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/22] cc_platform: Add new attribute to prevent ACPI
 memory hotplug
To:     Kai Huang <kai.huang@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:
>
> Platforms with confidential computing technology may not support ACPI
> memory hotplug when such technology is enabled by the BIOS.  Examples
> include Intel platforms which support Intel Trust Domain Extensions
> (TDX).
>
> If the kernel ever receives ACPI memory hotplug event, it is likely a
> BIOS bug.  For ACPI memory hot-add, the kernel should speak out this is
> a BIOS bug and reject the new memory.  For hot-removal, for simplicity
> just assume the kernel cannot continue to work normally, and just BUG().
>
> Add a new attribute CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED to indicate the
> platform doesn't support ACPI memory hotplug, so that kernel can handle
> ACPI memory hotplug events for such platform.
>
> In acpi_memory_device_{add|remove}(), add early check against this
> attribute and handle accordingly if it is set.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  drivers/acpi/acpi_memhotplug.c | 23 +++++++++++++++++++++++
>  include/linux/cc_platform.h    | 10 ++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 24f662d8bd39..94d6354ea453 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -15,6 +15,7 @@
>  #include <linux/acpi.h>
>  #include <linux/memory.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/cc_platform.h>
>
>  #include "internal.h"
>
> @@ -291,6 +292,17 @@ static int acpi_memory_device_add(struct acpi_device *device,
>         if (!device)
>                 return -EINVAL;
>
> +       /*
> +        * If the confidential computing platform doesn't support ACPI
> +        * memory hotplug, the BIOS should never deliver such event to
> +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> +        * the memory device.
> +        */
> +       if (cc_platform_has(CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED)) {

Same comment as for the acpi_processor driver: this will affect the
initialization too and it would be cleaner to reset the
.hotplug.enabled flag of the scan handler.

> +               dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI memory hotplug. New memory device ignored.\n");
> +               return -EINVAL;
> +       }
> +
>         mem_device = kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
>         if (!mem_device)
>                 return -ENOMEM;
> @@ -334,6 +346,17 @@ static void acpi_memory_device_remove(struct acpi_device *device)
>         if (!device || !acpi_driver_data(device))
>                 return;
>
> +       /*
> +        * The confidential computing platform is broken if ACPI memory
> +        * hot-removal isn't supported but it happened anyway.  Assume
> +        * it is not guaranteed that the kernel can continue to work
> +        * normally.  Just BUG().
> +        */
> +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {
> +               dev_err(&device->dev, "Platform doesn't support ACPI memory hotplug. BUG().\n");
> +               BUG();
> +       }
> +
>         mem_device = acpi_driver_data(device);
>         acpi_memory_remove_memory(mem_device);
>         acpi_memory_device_free(mem_device);
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index 9ce9256facc8..b831c24bd7f6 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -93,6 +93,16 @@ enum cc_attr {
>          * Examples include TDX platform.
>          */
>         CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED,
> +
> +       /**
> +        * @CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED: ACPI memory hotplug is
> +        *                                        not supported.
> +        *
> +        * The platform/os does not support ACPI memory hotplug.
> +        *
> +        * Examples include TDX platform.
> +        */
> +       CC_ATTR_ACPI_MEMORY_HOTPLUG_DISABLED,
>  };
>
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
> --
> 2.36.1
>
