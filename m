Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2795F55DA09
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiF0ICE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 04:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiF0ICD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 04:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4372E219E
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 01:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656316921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NjQ/y3uzOB0VPioQUmdD2/aH8hZijcv/VXyRMlZuNQg=;
        b=QB2L7UqYcbfJKvcItharUG0ucsLsKmoJv2WheSsmnT1V1bYODE4e7WqukuldHNlEJFWS02
        O5r/++UIVGHLAvQvDs/hmRVdlRo2awHjMLddRSkQZOwlLOwEWG9bzMDRXXR99tjPvjVV8m
        9n4NJF3WhrvJrYEYVZE3NGUl1wy9fjY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-5288VvbbM9uqnFoNaErXTg-1; Mon, 27 Jun 2022 04:01:59 -0400
X-MC-Unique: 5288VvbbM9uqnFoNaErXTg-1
Received: by mail-wm1-f70.google.com with SMTP id t20-20020a1c7714000000b003a032360873so6325194wmi.0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 01:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjQ/y3uzOB0VPioQUmdD2/aH8hZijcv/VXyRMlZuNQg=;
        b=UJky27an5LMaMO0VRvBYIF1mR82eyxekJjbVqQu41yJ04iN/egalKaGCCgjTisiIll
         IeuFtbvR6qlrRf3rC8ztUcvS5LGcALWZqvDdijJgHQ/lpQptvT4xoIungPYZ4B7FAfiP
         Bh6z3XaKqBqPhiu5kaAHkpZmCylascfSMwXc3R9Ua401RA9oVN5JqtXyOrKHhRVQBtuF
         YH0GTPPxP1PzuxXZwqay5Oj4r5mnNqPAbMcbqPJgA0lDMS48YaeMsnRIc59JuUpW+Q0K
         sPIPYg2a0XUyLtoGVvTSDCETbDlmnBpWX9zHzPrxO4+wiRrXI3D1q5FqigDU3JDv4hil
         ehvA==
X-Gm-Message-State: AJIora91fXtr0YePO1x79VeZ/OvREjdwFupoQTsnYWpVO1hq1JbK4GHY
        a+Z4k+Nnnu9ysYrD7hREXHSfgW68WSbJekztU/f5OROEe1MRDviYCgxHE15UY0+abze8GAwbnjX
        hHnpgf1+at+Zn
X-Received: by 2002:a05:600c:4f81:b0:39c:809c:8a9e with SMTP id n1-20020a05600c4f8100b0039c809c8a9emr19091640wmq.39.1656316918080;
        Mon, 27 Jun 2022 01:01:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ucgAGSBXy8zDrJRdc3q59PcoYBheBIuCkSQZpixIvVUMq6Ty2yfJQnho9iegzNyMmUhooTwA==
X-Received: by 2002:a05:600c:4f81:b0:39c:809c:8a9e with SMTP id n1-20020a05600c4f8100b0039c809c8a9emr19091606wmq.39.1656316917811;
        Mon, 27 Jun 2022 01:01:57 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w9-20020a5d6089000000b0020e5b4ebaecsm9700461wrt.4.2022.06.27.01.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 01:01:57 -0700 (PDT)
Date:   Mon, 27 Jun 2022 10:01:55 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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
        isaku.yamahata@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Tianyu.Lan@microsoft.com, Randy Dunlap <rdunlap@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>, dongli.zhang@oracle.com
Subject: Re: [PATCH v5 02/22] cc_platform: Add new attribute to prevent ACPI
 CPU hotplug
Message-ID: <20220627100155.71a7b34c@redhat.com>
In-Reply-To: <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
        <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
        <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
        <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jun 2022 12:01:48 +1200
Kai Huang <kai.huang@intel.com> wrote:

> On Wed, 2022-06-22 at 13:42 +0200, Rafael J. Wysocki wrote:
> > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:  
> > > 
> > > Platforms with confidential computing technology may not support ACPI
> > > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > > include Intel platforms which support Intel Trust Domain Extensions
> > > (TDX).
> > > 
> > > If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> > > bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> > > bug and reject the new CPU.  For hot-removal, for simplicity just assume
> > > the kernel cannot continue to work normally, and BUG().
> > > 
> > > Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
> > > platform doesn't support ACPI CPU hotplug, so that kernel can handle
> > > ACPI CPU hotplug events for such platform.  The existing attribute
> > > CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.
> > > 
> > > In acpi_processor_{add|remove}(), add early check against this attribute
> > > and handle accordingly if it is set.
> > > 
> > > Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
> > > CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
> > > 
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/coco/core.c          |  2 +-
> > >  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
> > >  include/linux/cc_platform.h   | 15 +++++++++++++--
> > >  kernel/cpu.c                  |  2 +-
> > >  4 files changed, 38 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > > index 4320fadae716..1bde1af75296 100644
> > > --- a/arch/x86/coco/core.c
> > > +++ b/arch/x86/coco/core.c
> > > @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> > >  {
> > >         switch (attr) {
> > >         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > -       case CC_ATTR_HOTPLUG_DISABLED:
> > > +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
> > >         case CC_ATTR_GUEST_MEM_ENCRYPT:
> > >         case CC_ATTR_MEM_ENCRYPT:
> > >                 return true;
> > > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > > index 6737b1cbf6d6..b960db864cd4 100644
> > > --- a/drivers/acpi/acpi_processor.c
> > > +++ b/drivers/acpi/acpi_processor.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/module.h>
> > >  #include <linux/pci.h>
> > > +#include <linux/cc_platform.h>
> > > 
> > >  #include <acpi/processor.h>
> > > 
> > > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
> > >         struct device *dev;
> > >         int result = 0;
> > > 
> > > +       /*
> > > +        * If the confidential computing platform doesn't support ACPI
> > > +        * memory hotplug, the BIOS should never deliver such event to
> > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> > > +        * the new CPU.
> > > +        */
> > > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {  
> > 
> > This will affect initialization, not just hotplug AFAICS.
> > 
> > You should reset the .hotplug.enabled flag in processor_handler to
> > false instead.  
> 
> Hi Rafael,
> 
> Thanks for the review.  By "affect initialization" did you mean this
> acpi_processor_add() is also called during kernel boot when any logical cpu is
> brought up?  Or do you mean ACPI CPU hotplug can also happen during kernel boot
> (after acpi_processor_init())?
> 
> I see acpi_processor_init() calls acpi_processor_check_duplicates() which calls
> acpi_evaluate_object() but I don't know details of ACPI so I don't know whether
> this would trigger acpi_processor_add().
> 
> One thing is TDX doesn't support ACPI CPU hotplug is an architectural thing, so
> it is illegal even if it happens during kernel boot.  Dave's idea is the kernel
> should  speak out loudly if physical CPU hotplug indeed happened on (BIOS) TDX-
> enabled platforms.  Otherwise perhaps we can just give up initializing the ACPI
> CPU hotplug in acpi_processor_init(), something like below?

The thing is that by the time ACPI machinery kicks in, physical hotplug
has already happened and in case of (kvm+qemu+ovmf hypervisor combo)
firmware has already handled it somehow and handed it over to ACPI.
If you say it's architectural thing then cpu hotplug is platform/firmware
bug and should be disabled there instead of working around it in the kernel.

Perhaps instead of 'preventing' hotplug, complain/panic and be done with it.
 
> --- a/drivers/acpi/acpi_processor.c
> +++ b/drivers/acpi/acpi_processor.c
> @@ -707,6 +707,10 @@ bool acpi_duplicate_processor_id(int proc_id)
>  void __init acpi_processor_init(void)
>  {
>         acpi_processor_check_duplicates();
> +
> +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED))
> +               return;
> +
>         acpi_scan_add_handler_with_hotplug(&processor_handler, "processor");
>         acpi_scan_add_handler(&processor_container_handler);
>  }
> 
> 
> >   
> > > +               dev_err(&device->dev, "[BIOS bug]: Platform doesn't support ACPI CPU hotplug.  New CPU ignored.\n");
> > > +               return -EINVAL;
> > > +       }
> > > +  
> 

