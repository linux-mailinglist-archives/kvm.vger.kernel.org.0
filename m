Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908C47CC119
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbjJQKxm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 17 Oct 2023 06:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbjJQKxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:53:39 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA411A;
        Tue, 17 Oct 2023 03:53:36 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6c6591642f2so1327420a34.1;
        Tue, 17 Oct 2023 03:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697540015; x=1698144815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wX3CNYvnPcIE1Gw36elnUGyF6yogJQd6j7/KiRGcVg0=;
        b=DSNAq8bbK4FGgZ5St9n+lZXESgqaOowLerXpTZ1KufhY9kCXwh9MmJIwKzLrJzfcqA
         sGT1c3BYR0CHzMRAij2x2BaTokrPz+D9ee4mqBkkqc9AivHag9RQtKPkr0n1thsmxKyA
         XCOw8poHaVQxoeWlKX+WpFB9VNRYd1SGLvTo3A4qEwZ/PWTrdCKNVk3hbpJ2JKScLz9h
         huV28Y2uqbdFXP1fW4e7tVVPaYLlCfkfIX8L6BrsPqGMO6+h9zjIa+OoTC2o3eJ18n1B
         KPlImMIWwXVDguUmx1x/1Z9O0QJy95W8aPAxbeKNHC9XLx0uihH4Zt9ikkqO9IVnPm+J
         sWgQ==
X-Gm-Message-State: AOJu0YycHjEaATLYwLvIzYbDYC0rSSV2YgzJnlmZHfNv2fg6ITBwOfUS
        WADwRqz6uv7Im0NUUTjgGtfL5YWLPGSmr2bGWAWNMwxe
X-Google-Smtp-Source: AGHT+IGGu/g/tGtuwNJOt6oL8lJApqALAEtf5dpAzBPA4y50IpUv0Mivc4jp0tEPT+FAKiA05Ne3bBONUEi65oSoePs=
X-Received: by 2002:a4a:b304:0:b0:581:d5df:9cd2 with SMTP id
 m4-20020a4ab304000000b00581d5df9cd2mr1231598ooo.0.1697540015390; Tue, 17 Oct
 2023 03:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1697532085.git.kai.huang@intel.com> <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
In-Reply-To: <7daec6d20bf93c2ff87268866d112ee8efd44e01.1697532085.git.kai.huang@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 17 Oct 2023 12:53:24 +0200
Message-ID: <CAJZ5v0ifJ5G7yOidiADkbwvuttVAVhVx6eSoJqBDeacZiGXZDg@mail.gmail.com>
Subject: Re: [PATCH v14 21/23] x86/virt/tdx: Handle TDX interaction with ACPI
 S3 and deeper states
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
        peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 12:17 PM Kai Huang <kai.huang@intel.com> wrote:
>
> TDX cannot survive from S3 and deeper states.  The hardware resets and
> disables TDX completely when platform goes to S3 and deeper.  Both TDX
> guests and the TDX module get destroyed permanently.
>
> The kernel uses S3 to support suspend-to-ram, and S4 or deeper states to
> support hibernation.  The kernel also maintains TDX states to track
> whether it has been initialized and its metadata resource, etc.  After
> resuming from S3 or hibernation, these TDX states won't be correct
> anymore.
>
> Theoretically, the kernel can do more complicated things like resetting
> TDX internal states and TDX module metadata before going to S3 or
> deeper, and re-initialize TDX module after resuming, etc, but there is
> no way to save/restore TDX guests for now.
>
> Until TDX supports full save and restore of TDX guests, there is no big
> value to handle TDX module in suspend and hibernation alone.  To make
> things simple, just choose to make TDX mutually exclusive with S3 and
> hibernation.
>
> Note the TDX module is initialized at runtime.  To avoid having to deal
> with the fuss of determining TDX state at runtime, just choose TDX vs S3
> and hibernation at kernel early boot.  It's a bad user experience if the
> choice of TDX and S3/hibernation is done at runtime anyway, i.e., the
> user can experience being able to do S3/hibernation but later becoming
> unable to due to TDX being enabled.
>
> Disable TDX in kernel early boot when hibernation is available, and give
> a message telling the user to disable hibernation via kernel command
> line in order to use TDX.  Currently there's no mechanism exposed by the
> hibernation code to allow other kernel code to disable hibernation once
> for all.
>
> Disable ACPI S3 by setting acpi_suspend_lowlevel function pointer to
> NULL when TDX is enabled by the BIOS.  This avoids having to modify the
> ACPI code to disable ACPI S3 in other ways.
>
> Also give a message telling the user to disable TDX in the BIOS in order
> to use ACPI S3.  A new kernel command line can be added in the future if
> there's a need to let user disable TDX host via kernel command line.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>
> v13 -> v14:
>  - New patch
>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e82f0adeea4d..1d0f1045dd33 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -28,10 +28,12 @@
>  #include <linux/sort.h>
>  #include <linux/log2.h>
>  #include <linux/reboot.h>
> +#include <linux/suspend.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/page.h>
>  #include <asm/special_insns.h>
> +#include <asm/acpi.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>
> @@ -1427,6 +1429,22 @@ static int __init tdx_init(void)
>                 return -ENODEV;
>         }
>
> +#define HIBERNATION_MSG                \
> +       "Disable TDX due to hibernation is available. Use 'nohibernate' command line to disable hibernation."

I'm not sure if this new symbol is really necessary.

The message could be as simple as "Initialization failed: Hibernation
support is enabled" (assuming a properly defined pr_fmt()), because
that carries enough information about the reason for the failure IMO.

How to address it can be documented elsewhere.

> +       /*
> +        * Note hibernation_available() can vary when it is called at
> +        * runtime as it checks secretmem_active() and cxl_mem_active()
> +        * which can both vary at runtime.  But here at early_init() they
> +        * both cannot return true, thus when hibernation_available()
> +        * returns false here, hibernation is disabled by either
> +        * 'nohibernate' or LOCKDOWN_HIBERNATION security lockdown,
> +        * which are both permanent.
> +        */

IIUC, the role of the comment is to document the fact that it is OK to
use hiberation_available() here, because it cannot return "false"
intermittently at this point, so I would just say "At this point,
hibernation_available() indicates whether or not hibernation support
has been permanently disabled", without going into all of the details
(which are irrelevant IMO and may change in the future).

> +       if (hibernation_available()) {
> +               pr_err("initialization failed: %s\n", HIBERNATION_MSG);
> +               return -ENODEV;
> +       }
> +
>         err = register_memory_notifier(&tdx_memory_nb);
>         if (err) {
>                 pr_err("initialization failed: register_memory_notifier() failed (%d)\n",
> @@ -1442,6 +1460,11 @@ static int __init tdx_init(void)
>                 return -ENODEV;
>         }
>
> +#ifdef CONFIG_ACPI
> +       pr_info("Disable ACPI S3 suspend. Turn off TDX in the BIOS to use ACPI S3.\n");
> +       acpi_suspend_lowlevel = NULL;
> +#endif

It would be somewhat nicer to have a helper for setting this pointer.

> +
>         /*
>          * Just use the first TDX KeyID as the 'global KeyID' and
>          * leave the rest for TDX guests.
> --
