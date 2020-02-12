Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233CF15AD4F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBLQX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:23:57 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36268 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgBLQX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 11:23:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so1477243pgu.3
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=RPf0qd07XC0OOgOapJr/kDhbr+rGuzMt9BHSs7VK5/M=;
        b=dUeaWcB7fuWIvEKzmYm9b+dMATUK5ExPoVF5uz+XbZrV986c/7ZUKxiELMZyxipwMD
         1RUk/X2dZklh2rOUgrGjHNF1qDI1tftagxZSLDZeZzgJnXon8nHd/5ivrOWxJ2z/Quol
         0fLkLJT9qUyJSI09E6JgFMkBBxxoUuFR2ZoBYCe9KrD28/tVFDRp7HJ80deMqTvy4jc2
         sPljRpie80sjXVDaKmHDRm2v2lVgyQPfm43BcZ9NhdT+n3hvcOemxeUTZvQMiBPEjNiB
         QezheQ9VMb9FKQ0p5qNL3hcNgcu5RQovzjPUuEvlPjHBaCjFoDM0Pa5MHOxqyDTLZACA
         xONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=RPf0qd07XC0OOgOapJr/kDhbr+rGuzMt9BHSs7VK5/M=;
        b=NYk+OOt6hEB95TUQuxxsPcvcQo9qgzMUJ+CpJWkhBWEOdk0PheL8iQO6TnS86pmi0j
         XRV/wWo+TROhCm9gPXZqAn93sQWi3s7wdBsug9XKvc9jm69+nz7mQ589EzE+IDp0hvhp
         EBi2V9fFzsjEP8AAvgXCS7z7pl+98lhsi7FO/xCIfgwW2Q1fh3lq62p/8euktwDglznq
         zFV+ZaeR5B7rZ6i9AdEa2ee1ONwds33Iq4A9bwKpuaHU7X5xapFda2tyP/lb6nvdgA1J
         cvRKi3hzJS4P9VRPHixAOR+NcLncBZaNypEVIeIQrQSdlBENhwmmEqyZ/6c8Js1PVYgd
         KZtA==
X-Gm-Message-State: APjAAAUFB39ipV+jg78OLklevm5J5vE3Nqlx7pBE94cRVkmz3K03OJWr
        65n+YftbExETFbIqfpAGMPCWcYIPG0Y=
X-Google-Smtp-Source: APXvYqwA82NVa9GoZoUratpibu79hOk3wllm05r7A8GrU5cq9PSBnDYtIdZEziICapSe7ywBb9awww==
X-Received: by 2002:a65:4305:: with SMTP id j5mr13799109pgq.315.1581524636923;
        Wed, 12 Feb 2020 08:23:56 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:6918:d286:95c1:bba2? ([2601:646:c200:1ef2:6918:d286:95c1:bba2])
        by smtp.gmail.com with ESMTPSA id s130sm1652186pfc.62.2020.02.12.08.23.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 08:23:56 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 23/62] x86/idt: Move IDT to data segment
Date:   Wed, 12 Feb 2020 08:23:54 -0800
Message-Id: <EEAC8672-C98F-45D0-9F2D-0802516C3908@amacapital.net>
References: <20200212115516.GE20066@8bytes.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Juergen Gross <JGross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
In-Reply-To: <20200212115516.GE20066@8bytes.org>
To:     Joerg Roedel <joro@8bytes.org>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Feb 12, 2020, at 3:55 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> =EF=BB=BFOn Tue, Feb 11, 2020 at 02:41:25PM -0800, Andy Lutomirski wrote:
>>> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
>>>=20
>>> From: Joerg Roedel <jroedel@suse.de>
>>>=20
>>> With SEV-ES, exception handling is needed very early, even before the
>>> kernel has cleared the bss segment. In order to prevent clearing the
>>> currently used IDT, move the IDT to the data segment.
>>=20
>> Ugh.  At the very least this needs a comment in the code.
>=20
> Yes, right, added a comment for that.
>=20
>> I had a patch to fix the kernel ELF loader to clear BSS, which would
>> fix this problem once and for all, but it didn't work due to the messy
>> way that the decompressor handles memory.  I never got around to
>> fixing this, sadly.
>=20
> Aren't there other ways of booting (Xen-PV?) which don't use the kernel
> ELF loader?

Dunno. I would hope the any sane loader would clear BSS before executing any=
thing. This isn=E2=80=99t currently the case, though. Oh well.

>=20
> Regards,
>=20
>    Joerg
