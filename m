Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519751BA8A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfEMQCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 12:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbfEMQCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 12:02:47 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BE321883
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557763366;
        bh=beoZx4frclCxoXSfTxDXkTuSz0AY0hIAwe1mG3lYD+0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QnhBLyrlFAFdFMdYGjrxtpZTRix4ohkczb2rqgQsWALhgFd6D7tiD8w3qEuQjKa4t
         6gACJ1mq+rjkrjjgv78C9L1ngGrELfh60U9CNvxeFR0bF4yIiw25vABiO2v6YO8nwh
         2BOKdf6lHrzPUcK3M8mxJ2O4+dZiPBseqIuRUnko=
Received: by mail-wr1-f45.google.com with SMTP id e15so3517122wrs.4
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 09:02:46 -0700 (PDT)
X-Gm-Message-State: APjAAAX70gm7OeHMKRiRbaEGNbO5yDHacsI6xUvsVqHSwPP+V7rBTPYN
        zy7XsANJcX4gwlJZE7QFBsdJ/gXpjA+RixzPz+frIA==
X-Google-Smtp-Source: APXvYqxYv7A+yu/f9CB06sBI0iU4dMZdZfKpnb+KSKIh95NmG1eMi1JsOLR0y6dsa/epkHBDB9VY2z7QBBDgfe/ptV8=
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr17614362wrs.309.1557763364695;
 Mon, 13 May 2019 09:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-25-git-send-email-alexandre.chartre@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 09:02:33 -0700
X-Gmail-Original-Message-ID: <CALCETrXADiujgE6HJ95P_da5OyB05Z5CqR028da50aCUHv4Agg@mail.gmail.com>
Message-ID: <CALCETrXADiujgE6HJ95P_da5OyB05Z5CqR028da50aCUHv4Agg@mail.gmail.com>
Subject: Re: [RFC KVM 24/27] kvm/isolation: KVM page fault handler
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
> The KVM page fault handler handles page fault occurring while using
> the KVM address space by switching to the kernel address space and
> retrying the access (except if the fault occurs while switching
> to the kernel address space). Processing of page faults occurring
> while using the kernel address space is unchanged.
>
> Page fault log is cleared when creating a vm so that page fault
> information doesn't persist when qemu is stopped and restarted.

Are you saying that a page fault will just exit isolation?  This
completely defeats most of the security, right?  Sure, it still helps
with side channels, but not with actual software bugs.
