Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD7E400AA5
	for <lists+kvm@lfdr.de>; Sat,  4 Sep 2021 13:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351131AbhIDJkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Sep 2021 05:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351126AbhIDJky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Sep 2021 05:40:54 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5898C061575;
        Sat,  4 Sep 2021 02:39:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e186so1683533iof.12;
        Sat, 04 Sep 2021 02:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CTXSPDkXsHMJtY8UzqhHPI20F6z6tQe3o1bV6MS8KHE=;
        b=Bx1/NMIjPDbtj7yVO6TxV8zVHjvnxA0qe9WjKVk19MYipCFbD4zzeoxbkn5AQmU/O0
         1tE4t7LH8Ub9mGEb+0R2FYgp8phpSp/oSgay8TBS36rsckSPJBJGOqvKV5fI0z3PFX0H
         9KJ3AwwDekr7p/rw/go8jV6Ey6a4KFt5priXjjnPVQ3cKYIaqeAuIHNfGhs+pt4e4dGd
         DKQEba+hCa37FjJWVTtUcbf4CwhHrbAbQud+eVt2IVkV9M5vDFpFdeNt7kXU/CnMyUKo
         iJuX1XWkTKDi1qnWlpXonYijieFx5Z/xTq0y5jiNXvv7QnNAoI09NEGuEjeWe6x2KAKu
         FwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CTXSPDkXsHMJtY8UzqhHPI20F6z6tQe3o1bV6MS8KHE=;
        b=kxT3ljohMu3wagOqs4QEkuUUK52tR7hh/tHWCB9T5jxcv1nCKf4ZbrBKrDslRVEgIQ
         nXdFdnDWbKl5AXbfJEk2zqlGTQVcuwR5Uu18Olf/TpAVlIeRZCar0gZxpVlKi5eAveHo
         cumdHBfmYydo39nr8tVsE6XPfsxljPiM+uOnKzWmx3Q5+Iw4Qv0LP1iVvwNfpKEaa37I
         1Owfa5jNl9T2nTl5P+b4biWZ8DCdbVWcTjzq4WKuLBxiHtOrgSkKWEqcVkAZkBSf16O9
         DbDxJmdzr6KmaeL1tRKtZvmSFnYNiFA46JtPF9zR1K/VVnV8zA03RGO85AScDBzeAOib
         TCog==
X-Gm-Message-State: AOAM530nRBYTcdQanS2aUagwiEUfH3XMnnYGAO1XzAe3afPi+hN5Xefq
        uNAsXL2sGhMBAdWRQczGW45UHwiundKktJD+A/0=
X-Google-Smtp-Source: ABdhPJzv+UKlBHeKZQPE95qRzjqHei343vDShxOHA7qym7IXRZ990tFXu8oqMKr1yejoqttVhvqx9gvky+piUFJ4cjU=
X-Received: by 2002:a6b:b502:: with SMTP id e2mr2435889iof.152.1630748392236;
 Sat, 04 Sep 2021 02:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200824085511.7553-1-joro@8bytes.org> <20200824085511.7553-43-joro@8bytes.org>
In-Reply-To: <20200824085511.7553-43-joro@8bytes.org>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Sat, 4 Sep 2021 17:39:41 +0800
Message-ID: <CAJhGHyA-GXrBgOxEu0sqN_+LMd7qUot=_2J1g6yGTvo-Mei6xA@mail.gmail.com>
Subject: Re: [PATCH v6 42/76] x86/sev-es: Setup early #VC handler
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -363,6 +370,33 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
>         jmp restore_regs_and_return_to_kernel
>  SYM_CODE_END(early_idt_handler_common)
>
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +/*
> + * VC Exception handler used during very early boot. The
> + * early_idt_handler_array can't be used because it returns via the
> + * paravirtualized INTERRUPT_RETURN and pv-ops don't work that early.

Hello Joerg, Juergen

The commit ae755b5a4548 ("x86/paravirt: Switch iret pvops to ALTERNATIVE")
( https://lore.kernel.org/lkml/20210311142319.4723-12-jgross@suse.com/ )
had been merged and the paravirt_iret is deferenced based via %rip.

Can INTERRUPT_RETURN still be a problem if early_idt_handler_array
is used instead for bringup IDT?

Thanks
Lai
