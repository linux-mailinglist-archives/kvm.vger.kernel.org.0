Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC33415B2EB
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 22:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgBLVnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 16:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727564AbgBLVnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 16:43:02 -0500
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6592D2467D
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581543781;
        bh=/5bgUjnXfKX/YnWj2CVZ6tzhbOUyGqaE9iljMsoLSUs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Do9dVLKHn+WmiWvVm5KO1giK1zzBjXFPv4K+0KaPaAU+ZFrJMbe3xrdYLXsMD33YT
         HT5tMqSNvg8QkYnRPtiJswNABvk53TkuOMS9PFoWqhT46b6TsoN0KZCIMozqIyV4K8
         NqvZraXBlBMH2RxKnUB6a9FkfLoo3qPSZvOOkYtM=
Received: by mail-wm1-f53.google.com with SMTP id b17so4337438wmb.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 13:43:01 -0800 (PST)
X-Gm-Message-State: APjAAAWuY69wLzFAhyhnXnVVJcfMKken0dcqtORKtITvlWoDVCpatrUz
        JaMlv58WnQNwSZyHBSe1Ni5+N48ui/R89HYMFJJLuw==
X-Google-Smtp-Source: APXvYqx80blFuMGO5xbOx9jMb15X8saJRfGQ59bhxN5COt5T4RVqjZzy0EMpurQDrd8Sxj4YjZioVGr2wj1eLccaOos=
X-Received: by 2002:a05:600c:2207:: with SMTP id z7mr1155941wml.138.1581543779800;
 Wed, 12 Feb 2020 13:42:59 -0800 (PST)
MIME-Version: 1.0
References: <20200211135256.24617-1-joro@8bytes.org> <20200211135256.24617-39-joro@8bytes.org>
In-Reply-To: <20200211135256.24617-39-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 12 Feb 2020 13:42:48 -0800
X-Gmail-Original-Message-ID: <CALCETrVRmg88xY0s4a2CONXQ3fgvCKXpW2eYJRJGhqQLneoGqQ@mail.gmail.com>
Message-ID: <CALCETrVRmg88xY0s4a2CONXQ3fgvCKXpW2eYJRJGhqQLneoGqQ@mail.gmail.com>
Subject: Re: [PATCH 38/62] x86/sev-es: Handle instruction fetches from user-space
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
> When a #VC exception is triggered by user-space the instruction
> decoder needs to read the instruction bytes from user addresses.
> Enhance es_fetch_insn_byte() to safely fetch kernel and user
> instruction bytes.

I realize that this is a somewhat arbitrary point in the series to
complain about this, but: the kernel already has infrastructure to
decode and fix up an instruction-based exception.  See
fixup_umip_exception().  Please refactor code so that you can share
the same infrastructure rather than creating an entirely new thing.

FWIW, the fixup_umip_exception() code seems to have much more robust
segment handling than yours :)

--Andy
