Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D6D67F8A
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 17:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfGNPGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 11:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbfGNPG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 11:06:29 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C612183E
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563116788;
        bh=9v0TSmLCn8TjvoXn1mqXdhjjoJsiEcxlv4LvLVZbR0I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v0TmOJxy83Vs7zwskqPZknhJBHliByWQ9slt88eUlJmFucrdhem7QgBNJjIHsEncL
         7r1MjLILZtAzjraM7v/6sOCnRImcX93hQrOaGfUCyDDn0RQY7log3hDh3/ibKrYXJj
         SPkMGaiBSRrNaF/5iAD/xywYdZdj9CsvNJiGqkvg=
Received: by mail-wm1-f52.google.com with SMTP id g67so8673576wme.1
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 08:06:28 -0700 (PDT)
X-Gm-Message-State: APjAAAWzsBCzG7S/NHOMVcLQqmuVk1+O7BnBeGQq7ZTd8cOThHobnWGO
        TVTbE5cmQZZ8R2tk6Gvmpy3ORgtzrTtB/XcLMIH8ZQ==
X-Google-Smtp-Source: APXvYqxduSTS2xAezjNhiFs/zv4vEOdtjl3od0VTpH2E1vVYA88Q+UFag4kZUKep/WXl0oYayxVpidWQx6QWYEWJtLo=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr18654369wme.173.1563116786554;
 Sun, 14 Jul 2019 08:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com> <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de>
 <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com> <20190712190620.GX3419@hirez.programming.kicks-ass.net>
In-Reply-To: <20190712190620.GX3419@hirez.programming.kicks-ass.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 14 Jul 2019 08:06:12 -0700
X-Gmail-Original-Message-ID: <CALCETrWcnJhtUsJ2nrwAqqgdbRrZG6FNLKY_T-WTETL6-B-C1g@mail.gmail.com>
Message-ID: <CALCETrWcnJhtUsJ2nrwAqqgdbRrZG6FNLKY_T-WTETL6-B-C1g@mail.gmail.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>,
        Alexander Graf <graf@amazon.de>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 12:06 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Jul 12, 2019 at 06:37:47PM +0200, Alexandre Chartre wrote:
> > On 7/12/19 5:16 PM, Thomas Gleixner wrote:
>
> > > Right. If we decide to expose more parts of the kernel mappings then that's
> > > just adding more stuff to the existing user (PTI) map mechanics.
> >
> > If we expose more parts of the kernel mapping by adding them to the existing
> > user (PTI) map, then we only control the mapping of kernel sensitive data but
> > we don't control user mapping (with ASI, we exclude all user mappings).
> >
> > How would you control the mapping of userland sensitive data and exclude them
> > from the user map? Would you have the application explicitly identify sensitive
> > data (like Andy suggested with a /dev/xpfo device)?
>
> To what purpose do you want to exclude userspace from the kernel
> mapping; that is, what are you mitigating against with that?

Mutually distrusting user/guest tenants.  Imagine an attack against a
VM hosting provider (GCE, for example).  If the overall system is
well-designed, the host kernel won't possess secrets that are
important to the overall hosting network.  The interesting secrets are
in the memory of other tenants running under the same host.  So, if we
can mostly or completely avoid mapping one tenant's memory in the
host, we reduce the amount of valuable information that could leak via
a speculation (or wild read) attack to another tenant.

The practicality of such a scheme is obviously an open question.
