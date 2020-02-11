Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF76159C67
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgBKWo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727199AbgBKWo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:44:58 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A38214DB
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581461098;
        bh=HuV9YLvJEvcc270R9dgBn2WFOwx6DXWaFOZ23rncsqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OXdXWAWEuPD/brdjHF+3LN1PlTCFVy6XDEEKUxvsVrajJaDDhNW+QNfi5q2+tFTor
         /+Rggqh3fb0KrBGOGo5vUTHH9UtuiRdaHtHzpuf43ULG7wlyVmRJDqGyhNQoumptQ7
         r30a6CfCJmEE4IfKRkkYGbWMiOOE9GfUNMXmGUJ0=
Received: by mail-wr1-f53.google.com with SMTP id g3so13505340wrs.12
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:44:58 -0800 (PST)
X-Gm-Message-State: APjAAAWgMbFTWgyCueCSx3U39pWJNnA45G+yQLL7MvZj5a5ZwPRX2BUD
        7siz88Yq1OhpYhzaeShdETBXTnSaY9ifAbngSIgFaQ==
X-Google-Smtp-Source: APXvYqzY81lEi55il13Ueps9hjsu2+bqHRuf6w5qFMRFH7D2LrQCDHIcGTkWr/CLssKA2NO/90BHC3DwgTV3gYkiss8=
X-Received: by 2002:a5d:5305:: with SMTP id e5mr11114870wrv.18.1581461096590;
 Tue, 11 Feb 2020 14:44:56 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-31-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-31-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:44:45 -0800
X-Gmail-Original-Message-ID: <CALCETrVLhTkZ2MMUD+WMWXnhmSvwVhinUtMJey2M6sx_iUREcg@mail.gmail.com>
Message-ID: <CALCETrVLhTkZ2MMUD+WMWXnhmSvwVhinUtMJey2M6sx_iUREcg@mail.gmail.com>
Subject: Re: [PATCH 30/62] x86/head/64: Move early exception dispatch to C code
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> Move the assembly coded dispatch between page-faults and all other
> exceptions to C code to make it easier to maintain and extend.
>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/head64.c  | 20 ++++++++++++++++++++
>  arch/x86/kernel/head_64.S | 11 +----------
>  2 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 7cdfb7113811..d83c62ebaa85 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -36,6 +36,8 @@
>  #include <asm/microcode.h>
>  #include <asm/kasan.h>
>  #include <asm/fixmap.h>
> +#include <asm/extable.h>
> +#include <asm/trap_defs.h>
>
>  /*
>   * Manage page tables very early on.
> @@ -377,6 +379,24 @@ int __init early_make_pgtable(unsigned long address)
>         return __early_make_pgtable(address, pmd);
>  }
>
> +void __init early_exception(struct pt_regs *regs, int trapnr)
> +{
> +       unsigned long cr2;
> +       int r;

How about int (or bool) handled;  Or just if (!early_make_pgtable)
return;  This would also be nicer if you inverted the return value so
that true means "I handled it".

--Andy
