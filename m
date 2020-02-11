Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51543159C62
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgBKWlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:41:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBKWlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:41:39 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB95E21569
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581460899;
        bh=po7kqC7Pvn8ouUFSjitvJdsV90ZhZQbIOK4MtOWD+4c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A9SjsBEnM3jsARVQH6Vr8mTRFYVGhigujF6r85gkGJDQV5NSgyXGAldP+bLnXh/9J
         3m3NtP+kcfOzMI6mAYyqirz9/jX0YVwfQ8kfmP5qG/FH5JKPQCzOSv87B8D9c6/iCa
         ssCsOD+3rbZeEUyj8gwWEpLOQGnncSrhXwJy9lZ0=
Received: by mail-wr1-f48.google.com with SMTP id w15so14605092wru.4
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 14:41:38 -0800 (PST)
X-Gm-Message-State: APjAAAW53xnt3fHIjEAj+AofodpVqRTb7zX2H7hadcNdTq7aEi6qapVL
        Aj8nW9YS4zWsCNOt8oNRoOdQ95ObD3BDS0mwaD1Vzw==
X-Google-Smtp-Source: APXvYqwUKxKnR3eGbA73IwMOx/C58CVPpQncokUat63UmXlmSlb5cTd+e+rYF11OC5oIS9uMBg3BBmcyseI9oUikD18=
X-Received: by 2002:a5d:5305:: with SMTP id e5mr11103645wrv.18.1581460897210;
 Tue, 11 Feb 2020 14:41:37 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-24-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-24-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 11 Feb 2020 14:41:25 -0800
X-Gmail-Original-Message-ID: <CALCETrXswGgGoNaZigboUn3-amTyCY2Ft_JaMMvXchLDDkhJfw@mail.gmail.com>
Message-ID: <CALCETrXswGgGoNaZigboUn3-amTyCY2Ft_JaMMvXchLDDkhJfw@mail.gmail.com>
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
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
> With SEV-ES, exception handling is needed very early, even before the
> kernel has cleared the bss segment. In order to prevent clearing the
> currently used IDT, move the IDT to the data segment.

Ugh.  At the very least this needs a comment in the code.

I had a patch to fix the kernel ELF loader to clear BSS, which would
fix this problem once and for all, but it didn't work due to the messy
way that the decompressor handles memory.  I never got around to
fixing this, sadly.
