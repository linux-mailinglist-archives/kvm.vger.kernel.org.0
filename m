Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53421BA50
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbfEMPp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 11:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfEMPp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 11:45:59 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 480F62147A
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557762358;
        bh=BABeuTSqBcwBR4EDIoxeTc9kWB/TDj6EfW9QIQhsYNY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Os4/hJwWSkAdbGceMgGRjKFt8j+/6lOvqEBDCCCNQBIVuwuamTCRkhBSqlKoOIc3B
         bKg4d8F9EV+vF3Ma9/80M5RXduvPhjC/zADKDy9UjeOXh0Lpprw9DYBC66fJ2hbnW8
         5AX19NgZ7HW2pLeO0tk2CRUtry4EHPrNeSrw6c9k=
Received: by mail-wr1-f42.google.com with SMTP id e15so3452456wrs.4
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:45:58 -0700 (PDT)
X-Gm-Message-State: APjAAAV3MnbNzIzFrD+PfYh2RXmfpFqkyie4JlHB2vDawG0Dq+dqY7QC
        pe/VreO2Wul96w3CahWVz5mVblUX3hDEMc0mZ5z6iw==
X-Google-Smtp-Source: APXvYqxB6/LB0zVU0LguK5JO/EJiDHXHRv1uRsxvAKFR9W6Hhrd6sfPq7nawtOobZtwjm1N+m8f5YKFBHh33AnBCP3c=
X-Received: by 2002:a5d:45c7:: with SMTP id b7mr5830508wrs.176.1557762356875;
 Mon, 13 May 2019 08:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-4-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-4-git-send-email-alexandre.chartre@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 08:45:44 -0700
X-Gmail-Original-Message-ID: <CALCETrV9-VAMS2K3pmkqM--pr0AYcb38ASETvwsZ5YhLtLq-9w@mail.gmail.com>
Message-ID: <CALCETrV9-VAMS2K3pmkqM--pr0AYcb38ASETvwsZ5YhLtLq-9w@mail.gmail.com>
Subject: Re: [RFC KVM 03/27] KVM: x86: Introduce KVM separate virtual address space
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
> From: Liran Alon <liran.alon@oracle.com>
>
> Create a separate mm for KVM that will be active when KVM #VMExit
> handlers run. Up until the point which we architectully need to
> access host (or other VM) sensitive data.
>
> This patch just create kvm_mm but never makes it active yet.
> This will be done by next commits.

NAK to this whole pile of code.  KVM is not so special that it can
duplicate core infrastructure like this.  Use copy_init_mm() or
improve it as needed.

--Andy
