Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78DA55DF13
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242319AbiF1LwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344112AbiF1LwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:52:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B18821C937
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656417126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/tExLCcuaEdSq/9II+CzXZ/hLnhseJLrJyprOKPr8M=;
        b=Q2HC02HE1Ds/kolgWUoPKLAr7Rl5t6fKvznEW/PzyxrNuzgaXyzrUQuyhbIq6YYWtl4Y6+
        2IViTMGfOjdjYdARjQ9l4JZGMEGLX50/KvdmTR9jIGknOeULr3089HAQzcN8xi3YXpTTvG
        afhgcZhIiMi13zcyWqiFbvLazkv04+0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-8Y30u9gmM7-6VgBEJ3YY7g-1; Tue, 28 Jun 2022 07:52:05 -0400
X-MC-Unique: 8Y30u9gmM7-6VgBEJ3YY7g-1
Received: by mail-wm1-f70.google.com with SMTP id r4-20020a1c4404000000b003a02fa133ceso926959wma.2
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/tExLCcuaEdSq/9II+CzXZ/hLnhseJLrJyprOKPr8M=;
        b=T1mvT1ERe4kB78NIGwEu3KmP/x8uR9hAJmdnrr5zeL1sem7RWbfU5hgEs09kNSsYrr
         aQPPgDi1JuGXUZrBq6KOLL57LoxAjrTXtrwc7BAHC6xIr7kTa8DHus3eAP9q3XTfvpGB
         U8Ilidj+Tz/ULElZVsSw/Ocz4RfMPbjj7wn/RI+trOlWgK5ajbdEiJh6loYtGE0qzvjU
         IUI2qJjBnhKeV+aPyTd8Y87Si050gUO13HM2DMgXfkwsubmDf7GHDMHd6RW9H1ixIMUo
         +6CcBF7kBSIcdvOG0Ef0qbM9zgxmhuEk8K5DxZLccukIRzta13OoTqmNZsNQ3Cra9Udv
         ab3g==
X-Gm-Message-State: AJIora8gdoPuh3sYPBVB9PEPsNhTw8ug91T0yb9LvyIAK8IGwfaHYUXB
        /qG4Kj5SgBFFAfSbYVvoICH1u575fAXsQJX/coCzqUKqS+P/uWqYzZqFezwSczOwAdcwsZZaaMK
        LdTh9/sx7mFZ3
X-Received: by 2002:a05:6000:703:b0:21b:9274:6b67 with SMTP id bs3-20020a056000070300b0021b92746b67mr18086144wrb.377.1656417123813;
        Tue, 28 Jun 2022 04:52:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uCu4GCzcrPh5RsBK6mfFRrbGHD7B6cejPvSxFZf9VeWkHaPtaXxcEf7abH2qB66w2FLxoAwA==
X-Received: by 2002:a05:6000:703:b0:21b:9274:6b67 with SMTP id bs3-20020a056000070300b0021b92746b67mr18086106wrb.377.1656417123545;
        Tue, 28 Jun 2022 04:52:03 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id j6-20020adff546000000b0021b862ad439sm16178457wrp.9.2022.06.28.04.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 04:52:02 -0700 (PDT)
Date:   Tue, 28 Jun 2022 13:52:00 +0200
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
Message-ID: <20220628135200.6e9be32d@redhat.com>
In-Reply-To: <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
        <f4bff93d83814ea1f54494f51ce3e5d954cf0f5b.1655894131.git.kai.huang@intel.com>
        <CAJZ5v0jV8ODcxuLL+iSpYbW7w=GFtUSakN-n8CO5Zmun3K-Erg@mail.gmail.com>
        <d3ba563f3f4e7aaf90fb99d20c651b5751972f7b.camel@intel.com>
        <20220627100155.71a7b34c@redhat.com>
        <2b676b19db423b995a21c7f215ed117c345c60d9.camel@intel.com>
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

On Tue, 28 Jun 2022 22:04:43 +1200
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 10:01 +0200, Igor Mammedov wrote:
> > On Thu, 23 Jun 2022 12:01:48 +1200
> > Kai Huang <kai.huang@intel.com> wrote:
> >   
> > > On Wed, 2022-06-22 at 13:42 +0200, Rafael J. Wysocki wrote:  
> > > > On Wed, Jun 22, 2022 at 1:16 PM Kai Huang <kai.huang@intel.com> wrote:    
> > > > > 
> > > > > Platforms with confidential computing technology may not support ACPI
> > > > > CPU hotplug when such technology is enabled by the BIOS.  Examples
> > > > > include Intel platforms which support Intel Trust Domain Extensions
> > > > > (TDX).
> > > > > 
> > > > > If the kernel ever receives ACPI CPU hotplug event, it is likely a BIOS
> > > > > bug.  For ACPI CPU hot-add, the kernel should speak out this is a BIOS
> > > > > bug and reject the new CPU.  For hot-removal, for simplicity just assume
> > > > > the kernel cannot continue to work normally, and BUG().
> > > > > 
> > > > > Add a new attribute CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED to indicate the
> > > > > platform doesn't support ACPI CPU hotplug, so that kernel can handle
> > > > > ACPI CPU hotplug events for such platform.  The existing attribute
> > > > > CC_ATTR_HOTPLUG_DISABLED is for software CPU hotplug thus doesn't fit.
> > > > > 
> > > > > In acpi_processor_{add|remove}(), add early check against this attribute
> > > > > and handle accordingly if it is set.
> > > > > 
> > > > > Also take this chance to rename existing CC_ATTR_HOTPLUG_DISABLED to
> > > > > CC_ATTR_CPU_HOTPLUG_DISABLED as it is for software CPU hotplug.
> > > > > 
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > >  arch/x86/coco/core.c          |  2 +-
> > > > >  drivers/acpi/acpi_processor.c | 23 +++++++++++++++++++++++
> > > > >  include/linux/cc_platform.h   | 15 +++++++++++++--
> > > > >  kernel/cpu.c                  |  2 +-
> > > > >  4 files changed, 38 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> > > > > index 4320fadae716..1bde1af75296 100644
> > > > > --- a/arch/x86/coco/core.c
> > > > > +++ b/arch/x86/coco/core.c
> > > > > @@ -20,7 +20,7 @@ static bool intel_cc_platform_has(enum cc_attr attr)
> > > > >  {
> > > > >         switch (attr) {
> > > > >         case CC_ATTR_GUEST_UNROLL_STRING_IO:
> > > > > -       case CC_ATTR_HOTPLUG_DISABLED:
> > > > > +       case CC_ATTR_CPU_HOTPLUG_DISABLED:
> > > > >         case CC_ATTR_GUEST_MEM_ENCRYPT:
> > > > >         case CC_ATTR_MEM_ENCRYPT:
> > > > >                 return true;
> > > > > diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
> > > > > index 6737b1cbf6d6..b960db864cd4 100644
> > > > > --- a/drivers/acpi/acpi_processor.c
> > > > > +++ b/drivers/acpi/acpi_processor.c
> > > > > @@ -15,6 +15,7 @@
> > > > >  #include <linux/kernel.h>
> > > > >  #include <linux/module.h>
> > > > >  #include <linux/pci.h>
> > > > > +#include <linux/cc_platform.h>
> > > > > 
> > > > >  #include <acpi/processor.h>
> > > > > 
> > > > > @@ -357,6 +358,17 @@ static int acpi_processor_add(struct acpi_device *device,
> > > > >         struct device *dev;
> > > > >         int result = 0;
> > > > > 
> > > > > +       /*
> > > > > +        * If the confidential computing platform doesn't support ACPI
> > > > > +        * memory hotplug, the BIOS should never deliver such event to
> > > > > +        * the kernel.  Report ACPI CPU hot-add as a BIOS bug and ignore
> > > > > +        * the new CPU.
> > > > > +        */
> > > > > +       if (cc_platform_has(CC_ATTR_ACPI_CPU_HOTPLUG_DISABLED)) {    
> > > > 
> > > > This will affect initialization, not just hotplug AFAICS.
> > > > 
> > > > You should reset the .hotplug.enabled flag in processor_handler to
> > > > false instead.    
> > > 
> > > Hi Rafael,
> > > 
> > > Thanks for the review.  By "affect initialization" did you mean this
> > > acpi_processor_add() is also called during kernel boot when any logical cpu is
> > > brought up?  Or do you mean ACPI CPU hotplug can also happen during kernel boot
> > > (after acpi_processor_init())?
> > > 
> > > I see acpi_processor_init() calls acpi_processor_check_duplicates() which calls
> > > acpi_evaluate_object() but I don't know details of ACPI so I don't know whether
> > > this would trigger acpi_processor_add().
> > > 
> > > One thing is TDX doesn't support ACPI CPU hotplug is an architectural thing, so
> > > it is illegal even if it happens during kernel boot.  Dave's idea is the kernel
> > > should  speak out loudly if physical CPU hotplug indeed happened on (BIOS) TDX-
> > > enabled platforms.  Otherwise perhaps we can just give up initializing the ACPI
> > > CPU hotplug in acpi_processor_init(), something like below?  
> > 
> > The thing is that by the time ACPI machinery kicks in, physical hotplug
> > has already happened and in case of (kvm+qemu+ovmf hypervisor combo)
> > firmware has already handled it somehow and handed it over to ACPI.
> > If you say it's architectural thing then cpu hotplug is platform/firmware
> > bug and should be disabled there instead of working around it in the kernel.
> > 
> > Perhaps instead of 'preventing' hotplug, complain/panic and be done with it.  
> 
> Hi Igor,
> 
> Thanks for feedback.  Yes the current implementation actually reports CPU hot-
> add as BIOS bug.  I think I can report BIOS bug for hot-removal too.  And
> currently I actually used BUG() for the hot-removal case.  For hot-add I didn't
> use BUG() but rejected the new CPU as the latter is more conservative. 

Is it safe to ignore not properly initialized for TDX CPU,
sitting there (it may wake up to IRQs (as minimum SMI, but
maybe to IPIs as well (depending in what state FW left it))?

for hypervisors, one should disable cpu hotplug there
(ex: in QEMU, you can try to disable cpu hotplug completely
if TDX is enabled so it won't ever come to 'physical' cpu
being added to guest and no CPU hotplug related ACPI AML
code generated)

> Hi Rafael,
> 
> I am not sure I got what you mean by "This will affect initialization, not just
> hotplug AFAICS", could you elaborate a little bit?  Thanks.
> 
> 

