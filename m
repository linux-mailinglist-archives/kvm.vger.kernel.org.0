Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A7F18BB67
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgCSPoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgCSPoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 11:44:17 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF1E2072D
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 15:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584632656;
        bh=FVF/u9TSzlMdhf4kpAsywZwLbl/sGhd8ENC//u14qkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I0y8sUtct/Bh3UhCYALlKYXq+6n0HLrW6vax7RdHHsEFi5n3GSL+JQMq0m0DjnndW
         Xnlr5ugUwiw8Ty8NfSG7okzMxvecohY1DohE1VEjUTEVJLbVTbJhrexGrjUrcjgFHl
         WDAK45zaZZs97psWeLFp4eLJq6uLqm/BJjrLdIjE=
Received: by mail-wr1-f53.google.com with SMTP id j17so212981wru.13
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 08:44:16 -0700 (PDT)
X-Gm-Message-State: ANhLgQ20PCGEVr/bsPK69IppsPGWdguUdjsMARHXNdxhg+soAu9+TF4U
        S4IC43wPySOGGXWk9aXGgXI7F28KUtpM0fCs0h9dvg==
X-Google-Smtp-Source: ADFU+vu9xO32MybzBmacdPgCqlG7WVDPKTtdn223Fbu4PAIymbvyrGwQMSSWxAV7RNpXhGgQhHa1JuyvGJ5sDsUdXMI=
X-Received: by 2002:adf:a30b:: with SMTP id c11mr4940938wrb.257.1584632654996;
 Thu, 19 Mar 2020 08:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-42-joro@8bytes.org>
In-Reply-To: <20200319091407.1481-42-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Mar 2020 08:44:03 -0700
X-Gmail-Original-Message-ID: <CALCETrW9EYi5dzCKNtKkxM18CC4n5BZxTp1=qQ5qZccwstXjzg@mail.gmail.com>
Message-ID: <CALCETrW9EYi5dzCKNtKkxM18CC4n5BZxTp1=qQ5qZccwstXjzg@mail.gmail.com>
Subject: Re: [PATCH 41/70] x86/sev-es: Add Runtime #VC Exception Handler
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

On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> Add the handler for #VC exceptions invoked at runtime.

If I read this correctly, this does not use IST.  If that's true, I
don't see how this can possibly work.  There at least two nasty cases
that come to mind:

1. SYSCALL followed by NMI.  The NMI IRET hack gets to #VC and we
explode.  This is fixable by getting rid of the NMI EFLAGS.TF hack.

2. tools/testing/selftests/x86/mov_ss_trap_64.  User code does MOV
(addr), SS; SYSCALL, where addr has a data breakpoint.  We get #DB
promoted to #VC with no stack.
