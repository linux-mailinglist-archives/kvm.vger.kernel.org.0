Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D4F1B8874
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 20:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgDYSPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 14:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgDYSPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 14:15:50 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58690217BA
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587838549;
        bh=cVK0toJnn9vOB9E2SmO9CBJWGgOYMugNbByNAh8ilkI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Td1w4w4h9ChWYz5sxGi7UkXFmK/KIcZI+NzSE/qXy5EHXewGWv3PHpGP8/taXuTC8
         uWk+vEI7eTXTaXz696KMMjIcufWpDhgIKKqdFCb7AYkGEgWEYvLqqKw19we/BmxCNY
         FwvAGN5IfcSyhd4VsaVVYwDtAW54CWFlJnBsZaMo=
Received: by mail-wr1-f53.google.com with SMTP id j2so15528045wrs.9
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 11:15:49 -0700 (PDT)
X-Gm-Message-State: AGi0PuYaao0Bl0Q8wt4Iiel3AMJ45kmbY/aRjyaZ0j3WPIkK8wzwFWTa
        NE15rJtPPMQ27TzybbHGduktsxy7vYPks33GH/zMQg==
X-Google-Smtp-Source: APiQypJ7rU7AYr+libqeVqePFVrceb06kci8UbSVnmOb7FS/p9cPbc3OPMNaylAH0ECs1JdRARhF0f+awt47YIcfzuo=
X-Received: by 2002:adf:f648:: with SMTP id x8mr17727377wrp.257.1587838547579;
 Sat, 25 Apr 2020 11:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-56-joro@8bytes.org> <20200424210316.848878-1-mstunes@vmware.com>
 <2c49061d-eb84-032e-8dcb-dd36a891ce90@intel.com> <ead88d04-1756-1190-2b37-b24f86422595@amd.com>
 <4d2ac222-a896-a60e-9b3c-b35aa7e81a97@intel.com> <20200425124909.GO30814@suse.de>
In-Reply-To: <20200425124909.GO30814@suse.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 25 Apr 2020 11:15:35 -0700
X-Gmail-Original-Message-ID: <CALCETrWCiMkA37yf972h+fqsz1_dbfye8AbrkJxDPJzC+1PBEw@mail.gmail.com>
Message-ID: <CALCETrWCiMkA37yf972h+fqsz1_dbfye8AbrkJxDPJzC+1PBEw@mail.gmail.com>
Subject: Re: [PATCH] Allow RDTSC and RDTSCP from userspace
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <jgross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 5:49 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> Hi Dave,
>
> On Fri, Apr 24, 2020 at 03:53:09PM -0700, Dave Hansen wrote:
> > Ahh, so any instruction that can have an instruction intercept set
> > potentially needs to be able to tolerate a #VC?  Those instruction
> > intercepts are under the control of the (untrusted relative to the
> > guest) hypervisor, right?
> >
> > >From the main sev-es series:
> >
> > +#ifdef CONFIG_AMD_MEM_ENCRYPT
> > +idtentry vmm_communication     do_vmm_communication    has_error_code=1
> > +#endif
>
> The next version of the patch-set (which I will hopefully have ready
> next week) will have this changed. The #VC exception handler uses an IST
> stack and is set to paranoid=1 and shift_ist. The IST stacks for the #VC
> handler are only allocated when SEV-ES is active.

shift_ist is gross.  What's it for?  If it's not needed, I'd rather
not use it, and I eventually want to get rid of it for #DB as well.

--Andy
