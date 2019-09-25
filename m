Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E77BDAFE
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbfIYJ37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbfIYJ36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:29:58 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8CA388306
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:29:57 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id c188so1652875wmd.9
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 02:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WYjLLfPkKUjKCL+Z93P2C4mNN/Qpt+t2/yH151Xir48=;
        b=OisQ7aoLizCl48Wq+CD8MjgtKaJgAS3k9FG99jcxKjipSFsNsuNh0DuKuLQ1lFbZtn
         tMCelYD6C5Qvh+UWJiuxDzo6c6sG5Byv4eLiS7iDW5clg/orO4nVzHFSvypK5Q780bSl
         1BhfLx+fksqpRa9bjsddJm5BRRfvKDHMCoCSX1Rkk03NjT8GoevVi0yRTAka2jjSScwR
         0f9Cyirix79ewcBP3Z+PNh+7trJs8RJf+gA6fPiFMKY0P1TwO3UUTqvuC8XJza6eCVYe
         1HkqKbBdLS5WD8cumt+FPXvJE7o3/kCuFKfg6ZuFxli3oKnN1M785GccRduonF3m/sZB
         YI0w==
X-Gm-Message-State: APjAAAUF37gQxWwnmgRoGTG5JZe80Czj4dcAMy8B30XkJhvRhZDZFKzo
        uPm4kzOkibE+PC3ZZqXFgDEJFGgEvJxoIrgAYVQv9FR/24K+fhSmLK9HIgexo29X+NXoB87C5Fx
        gMnXQmHlZfmCv
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr6530792wme.89.1569403795576;
        Wed, 25 Sep 2019 02:29:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqywyAJRLQdLAKloPDovBR8NkCSgvG8gOITk8ef3MHuHcAN1glLyjopQb9xXlszoLeKbrkvrfQ==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr6530750wme.89.1569403795234;
        Wed, 25 Sep 2019 02:29:55 -0700 (PDT)
Received: from steredhat (host170-61-dynamic.36-79-r.retail.telecomitalia.it. [79.36.61.170])
        by smtp.gmail.com with ESMTPSA id z1sm6284120wre.40.2019.09.25.02.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 02:29:54 -0700 (PDT)
Date:   Wed, 25 Sep 2019 11:29:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/8] hw/i386: Factorize PVH related functions
Message-ID: <20190925092952.5fgbbdyakaj7h6tc@steredhat>
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-2-slp@redhat.com>
 <20190925083604.w77kl2x5umx2rubj@steredhat>
 <87d0fosqc1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0fosqc1.fsf@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 11:00:30AM +0200, Sergio Lopez wrote:
> Stefano Garzarella <sgarzare@redhat.com> writes:
> > Hi Sergio,
> >
> > On Tue, Sep 24, 2019 at 02:44:26PM +0200, Sergio Lopez wrote:
> >> Extract PVH related functions from pc.c, and put them in pvh.c, so
> >> they can be shared with other components.
> >> 
> >> Signed-off-by: Sergio Lopez <slp@redhat.com>
> >> ---
> >>  hw/i386/Makefile.objs |   1 +
> >>  hw/i386/pc.c          | 120 +++++-------------------------------------
> >>  hw/i386/pvh.c         | 113 +++++++++++++++++++++++++++++++++++++++
> >>  hw/i386/pvh.h         |  10 ++++
> >>  4 files changed, 136 insertions(+), 108 deletions(-)
> >>  create mode 100644 hw/i386/pvh.c
> >>  create mode 100644 hw/i386/pvh.h
> >> 
> >> diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
> >> index 5d9c9efd5f..c5f20bbd72 100644
> >> --- a/hw/i386/Makefile.objs
> >> +++ b/hw/i386/Makefile.objs
> >> @@ -1,5 +1,6 @@
> >>  obj-$(CONFIG_KVM) += kvm/
> >>  obj-y += multiboot.o
> >> +obj-y += pvh.o
> >>  obj-y += pc.o
> >>  obj-$(CONFIG_I440FX) += pc_piix.o
> >>  obj-$(CONFIG_Q35) += pc_q35.o
> >> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> >> index bad866fe44..10e4ced0c6 100644
> >> --- a/hw/i386/pc.c
> >> +++ b/hw/i386/pc.c
> >> @@ -42,6 +42,7 @@
> >>  #include "elf.h"
> >>  #include "migration/vmstate.h"
> >>  #include "multiboot.h"
> >> +#include "pvh.h"
> >>  #include "hw/timer/mc146818rtc.h"
> >>  #include "hw/dma/i8257.h"
> >>  #include "hw/timer/i8254.h"
> >> @@ -116,9 +117,6 @@ static struct e820_entry *e820_table;
> >>  static unsigned e820_entries;
> >>  struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
> >>  
> >> -/* Physical Address of PVH entry point read from kernel ELF NOTE */
> >> -static size_t pvh_start_addr;
> >> -
> >>  GlobalProperty pc_compat_4_1[] = {};
> >>  const size_t pc_compat_4_1_len = G_N_ELEMENTS(pc_compat_4_1);
> >>  
> >> @@ -1076,109 +1074,6 @@ struct setup_data {
> >>      uint8_t data[0];
> >>  } __attribute__((packed));
> >>  
> >> -
> >> -/*
> >> - * The entry point into the kernel for PVH boot is different from
> >> - * the native entry point.  The PVH entry is defined by the x86/HVM
> >> - * direct boot ABI and is available in an ELFNOTE in the kernel binary.
> >> - *
> >> - * This function is passed to load_elf() when it is called from
> >> - * load_elfboot() which then additionally checks for an ELF Note of
> >> - * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
> >> - * parse the PVH entry address from the ELF Note.
> >> - *
> >> - * Due to trickery in elf_opts.h, load_elf() is actually available as
> >> - * load_elf32() or load_elf64() and this routine needs to be able
> >> - * to deal with being called as 32 or 64 bit.
> >> - *
> >> - * The address of the PVH entry point is saved to the 'pvh_start_addr'
> >> - * global variable.  (although the entry point is 32-bit, the kernel
> >> - * binary can be either 32-bit or 64-bit).
> >> - */
> >> -static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
> >> -{
> >> -    size_t *elf_note_data_addr;
> >> -
> >> -    /* Check if ELF Note header passed in is valid */
> >> -    if (arg1 == NULL) {
> >> -        return 0;
> >> -    }
> >> -
> >> -    if (is64) {
> >> -        struct elf64_note *nhdr64 = (struct elf64_note *)arg1;
> >> -        uint64_t nhdr_size64 = sizeof(struct elf64_note);
> >> -        uint64_t phdr_align = *(uint64_t *)arg2;
> >> -        uint64_t nhdr_namesz = nhdr64->n_namesz;
> >> -
> >> -        elf_note_data_addr =
> >> -            ((void *)nhdr64) + nhdr_size64 +
> >> -            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
> >> -    } else {
> >> -        struct elf32_note *nhdr32 = (struct elf32_note *)arg1;
> >> -        uint32_t nhdr_size32 = sizeof(struct elf32_note);
> >> -        uint32_t phdr_align = *(uint32_t *)arg2;
> >> -        uint32_t nhdr_namesz = nhdr32->n_namesz;
> >> -
> >> -        elf_note_data_addr =
> >> -            ((void *)nhdr32) + nhdr_size32 +
> >> -            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
> >> -    }
> >> -
> >> -    pvh_start_addr = *elf_note_data_addr;
> >> -
> >> -    return pvh_start_addr;
> >> -}
> >> -
> >> -static bool load_elfboot(const char *kernel_filename,
> >> -                   int kernel_file_size,
> >> -                   uint8_t *header,
> >> -                   size_t pvh_xen_start_addr,
> >> -                   FWCfgState *fw_cfg)
> >> -{
> >> -    uint32_t flags = 0;
> >> -    uint32_t mh_load_addr = 0;
> >> -    uint32_t elf_kernel_size = 0;
> >> -    uint64_t elf_entry;
> >> -    uint64_t elf_low, elf_high;
> >> -    int kernel_size;
> >> -
> >
> > Are we removing the following checks (ELF magic, flags) because they
> > are superfluous?
> >
> > Should we mention this in the commit message?
> 
> Damn, good catch, that's wrong.
> 
> The only patches coming from previous iterations are the one factorizing
> the e820 functions and this one, and both are wrong. I'm going to ditch
> them and write whatever it's needed from scratch.
> 
> >> -    if (ldl_p(header) != 0x464c457f) {
> >> -        return false; /* no elfboot */
> >> -    }
> >> -
> >> -    bool elf_is64 = header[EI_CLASS] == ELFCLASS64;
> >> -    flags = elf_is64 ?
> >> -        ((Elf64_Ehdr *)header)->e_flags : ((Elf32_Ehdr *)header)->e_flags;
> >> -
> >> -    if (flags & 0x00010004) { /* LOAD_ELF_HEADER_HAS_ADDR */
> >> -        error_report("elfboot unsupported flags = %x", flags);
> >> -        exit(1);
> >> -    }
> >> -
> >> -    uint64_t elf_note_type = XEN_ELFNOTE_PHYS32_ENTRY;
> >> -    kernel_size = load_elf(kernel_filename, read_pvh_start_addr,
> >> -                           NULL, &elf_note_type, &elf_entry,
> >> -                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
> >> -                           0, 0);
> >> -
> >> -    if (kernel_size < 0) {
> >> -        error_report("Error while loading elf kernel");
> >> -        exit(1);
> >> -    }
> >> -    mh_load_addr = elf_low;
> >> -    elf_kernel_size = elf_high - elf_low;
> >> -
> >> -    if (pvh_start_addr == 0) {
> >> -        error_report("Error loading uncompressed kernel without PVH ELF Note");
> >> -        exit(1);
> >> -    }
> >> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
> >> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
> >> -    fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
> >> -
> >> -    return true;
> >> -}
> >> -
> >>  static void load_linux(PCMachineState *pcms,
> >>                         FWCfgState *fw_cfg)
> >>  {
> >> @@ -1218,6 +1113,9 @@ static void load_linux(PCMachineState *pcms,
> >>      if (ldl_p(header+0x202) == 0x53726448) {
> >>          protocol = lduw_p(header+0x206);
> >>      } else {
> >> +        size_t pvh_start_addr;
> >> +        uint32_t mh_load_addr = 0;
> >> +        uint32_t elf_kernel_size = 0;
> >>          /*
> >>           * This could be a multiboot kernel. If it is, let's stop treating it
> >>           * like a Linux kernel.
> >> @@ -1235,10 +1133,16 @@ static void load_linux(PCMachineState *pcms,
> >>           * If load_elfboot() is successful, populate the fw_cfg info.
> >>           */
> >>          if (pcmc->pvh_enabled &&
> >> -            load_elfboot(kernel_filename, kernel_size,
> >> -                         header, pvh_start_addr, fw_cfg)) {
> >> +            pvh_load_elfboot(kernel_filename,
> >> +                             &mh_load_addr, &elf_kernel_size)) {
> >>              fclose(f);
> >>  
> >> +            pvh_start_addr = pvh_get_start_addr();
> >> +
> >> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ENTRY, pvh_start_addr);
> >> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_ADDR, mh_load_addr);
> >> +            fw_cfg_add_i32(fw_cfg, FW_CFG_KERNEL_SIZE, elf_kernel_size);
> >> +
> >>              fw_cfg_add_i32(fw_cfg, FW_CFG_CMDLINE_SIZE,
> >>                  strlen(kernel_cmdline) + 1);
> >>              fw_cfg_add_string(fw_cfg, FW_CFG_CMDLINE_DATA, kernel_cmdline);
> >> diff --git a/hw/i386/pvh.c b/hw/i386/pvh.c
> >> new file mode 100644
> >> index 0000000000..1c81727811
> >> --- /dev/null
> >> +++ b/hw/i386/pvh.c
> >> @@ -0,0 +1,113 @@
> >> +/*
> >> + * PVH Boot Helper
> >> + *
> >> + * Copyright (C) 2019 Oracle
> >> + * Copyright (C) 2019 Red Hat, Inc
> >> + *
> >> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> >> + * See the COPYING file in the top-level directory.
> >> + *
> >> + */
> >> +
> >> +#include "qemu/osdep.h"
> >> +#include "qemu/units.h"
> >> +#include "qemu/error-report.h"
> >> +#include "hw/loader.h"
> >> +#include "cpu.h"
> >> +#include "elf.h"
> >> +#include "pvh.h"
> >> +
> >> +static size_t pvh_start_addr;
> >> +
> >> +size_t pvh_get_start_addr(void)
> >> +{
> >> +    return pvh_start_addr;
> >> +}
> >> +
> >> +/*
> >> + * The entry point into the kernel for PVH boot is different from
> >> + * the native entry point.  The PVH entry is defined by the x86/HVM
> >> + * direct boot ABI and is available in an ELFNOTE in the kernel binary.
> >> + *
> >> + * This function is passed to load_elf() when it is called from
> >> + * load_elfboot() which then additionally checks for an ELF Note of
> >> + * type XEN_ELFNOTE_PHYS32_ENTRY and passes it to this function to
> >> + * parse the PVH entry address from the ELF Note.
> >> + *
> >> + * Due to trickery in elf_opts.h, load_elf() is actually available as
> >> + * load_elf32() or load_elf64() and this routine needs to be able
> >> + * to deal with being called as 32 or 64 bit.
> >> + *
> >> + * The address of the PVH entry point is saved to the 'pvh_start_addr'
> >> + * global variable.  (although the entry point is 32-bit, the kernel
> >> + * binary can be either 32-bit or 64-bit).
> >> + */
> >> +
> >> +static uint64_t read_pvh_start_addr(void *arg1, void *arg2, bool is64)
> >> +{
> >> +    size_t *elf_note_data_addr;
> >> +
> >> +    /* Check if ELF Note header passed in is valid */
> >> +    if (arg1 == NULL) {
> >> +        return 0;
> >> +    }
> >> +
> >> +    if (is64) {
> >> +        struct elf64_note *nhdr64 = (struct elf64_note *)arg1;
> >> +        uint64_t nhdr_size64 = sizeof(struct elf64_note);
> >> +        uint64_t phdr_align = *(uint64_t *)arg2;
> >> +        uint64_t nhdr_namesz = nhdr64->n_namesz;
> >> +
> >> +        elf_note_data_addr =
> >> +            ((void *)nhdr64) + nhdr_size64 +
> >> +            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
> >> +    } else {
> >> +        struct elf32_note *nhdr32 = (struct elf32_note *)arg1;
> >> +        uint32_t nhdr_size32 = sizeof(struct elf32_note);
> >> +        uint32_t phdr_align = *(uint32_t *)arg2;
> >> +        uint32_t nhdr_namesz = nhdr32->n_namesz;
> >> +
> >> +        elf_note_data_addr =
> >> +            ((void *)nhdr32) + nhdr_size32 +
> >> +            QEMU_ALIGN_UP(nhdr_namesz, phdr_align);
> >> +    }
> >> +
> >> +    pvh_start_addr = *elf_note_data_addr;
> >> +
> >> +    return pvh_start_addr;
> >> +}
> >> +
> >> +bool pvh_load_elfboot(const char *kernel_filename,
> >> +                      uint32_t *mh_load_addr,
> >> +                      uint32_t *elf_kernel_size)
> >> +{
> >> +    uint64_t elf_entry;
> >> +    uint64_t elf_low, elf_high;
> >> +    int kernel_size;
> >> +    uint64_t elf_note_type = XEN_ELFNOTE_PHYS32_ENTRY;
> >> +
> >> +    kernel_size = load_elf(kernel_filename, read_pvh_start_addr,
> >> +                           NULL, &elf_note_type, &elf_entry,
> >> +                           &elf_low, &elf_high, 0, I386_ELF_MACHINE,
> >> +                           0, 0);
> >> +
> >> +    if (kernel_size < 0) {
> >> +        error_report("Error while loading elf kernel");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (pvh_start_addr == 0) {
> >> +        error_report("Error loading uncompressed kernel without PVH ELF Note");
> >> +        return false;
> >> +    }
> >> +
> >> +    if (mh_load_addr) {
> >> +        *mh_load_addr = elf_low;
> >> +    }
> >> +
> >> +    if (elf_kernel_size) {
> >> +        *elf_kernel_size = elf_high - elf_low;
> >> +    }
> >> +
> >> +    return true;
> >> +}
> >> diff --git a/hw/i386/pvh.h b/hw/i386/pvh.h
> >> new file mode 100644
> >> index 0000000000..ada67ff6e8
> >> --- /dev/null
> >> +++ b/hw/i386/pvh.h
> >> @@ -0,0 +1,10 @@
> >> +#ifndef HW_I386_PVH_H
> >> +#define HW_I386_PVH_H
> >> +
> >> +size_t pvh_get_start_addr(void);
> >
> > What about adding "size_t *pvh_start_addr" to the pvh_load_elfboot()?
> > Just an idea, I'm not sure if it is better...
> 
> I agree. In fact, given that patch 4/8 extracts some common functions
> from pc.c into x86.c, and load_linux is among these functions, perhaps
> we can avoid creating an independent file and just put the PVH code
> there.
> 
> What do you think?

Make sense to me, since it's going to be used by pc and microvm.

Thanks,
Stefano
