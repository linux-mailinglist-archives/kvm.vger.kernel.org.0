Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347646718D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfGLOgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfGLOgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:36:38 -0400
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9232173E
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562942198;
        bh=HHZaY2tFKhZh3Vou4+5i4iiP03K9QdtH44f6+mWjpsU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BMU/i0oks+/4c4QxoYHg4VHE+HQvdXAHjhjm8+Y4yt71+/hMS9dEcxx3tElR67tGe
         7Ciw8GCvF9uol6OSlonEYS3hxruFK/r13XBVes2AggLAR6coK/QrqM8XMN5iOCSyoA
         M3QKOCfY2ED8hqKUxR3qB7zBFtDmxMIEz3H8XPYk=
Received: by mail-wr1-f41.google.com with SMTP id n9so10279282wru.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2019 07:36:37 -0700 (PDT)
X-Gm-Message-State: APjAAAUE9i04HrfAPQRrQ8ve+IgKLLNho3fYRxFvTZnzovWMrDSD3JqK
        HXclnMvm77aW8PZXmC0nmvXonqXPNZaVVlR3ML8/uQ==
X-Google-Smtp-Source: APXvYqzjSAKUc/Rv0po3zmwiq8ExN5gO/owzILZFdZj8fMMJQ7W46dkC79xOvRhglNBrrHNGx+LK7GoJMcCxwv4cvX8=
X-Received: by 2002:adf:a143:: with SMTP id r3mr12152043wrr.352.1562942196223;
 Fri, 12 Jul 2019 07:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com> <20190712125059.GP3419@hirez.programming.kicks-ass.net>
 <a03db3a5-b033-a469-cc6c-c8c86fb25710@oracle.com>
In-Reply-To: <a03db3a5-b033-a469-cc6c-c8c86fb25710@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 12 Jul 2019 07:36:24 -0700
X-Gmail-Original-Message-ID: <CALCETrVcM-SpEqLMJSOdyGuN0gjr+97+cpu2KYneuTv1fJDoog@mail.gmail.com>
Message-ID: <CALCETrVcM-SpEqLMJSOdyGuN0gjr+97+cpu2KYneuTv1fJDoog@mail.gmail.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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

On Fri, Jul 12, 2019 at 6:45 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
>
> On 7/12/19 2:50 PM, Peter Zijlstra wrote:
> > On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
> >
> >> I think that's precisely what makes ASI and PTI different and independent.
> >> PTI is just about switching between userland and kernel page-tables, while
> >> ASI is about switching page-table inside the kernel. You can have ASI without
> >> having PTI. You can also use ASI for kernel threads so for code that won't
> >> be triggered from userland and so which won't involve PTI.
> >
> > PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
> > ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
> >
> > See how very similar they are?
> >
> >
> > Furthermore, to recover SMT for userspace (under MDS) we not only need
> > core-scheduling but core-scheduling per address space. And ASI was
> > specifically designed to help mitigate the trainwreck just described.
> >
> > By explicitly exposing (hopefully harmless) part of the kernel to MDS,
> > we reduce the part that needs core-scheduling and thus reduce the rate
> > the SMT siblngs need to sync up/schedule.
> >
> > But looking at it that way, it makes no sense to retain 3 address
> > spaces, namely:
> >
> >    user / kernel exposed / kernel private.
> >
> > Specifically, it makes no sense to expose part of the kernel through MDS
> > but not through Meltdow. Therefore we can merge the user and kernel
> > exposed address spaces.
>
> The goal of ASI is to provide a reduced address space which exclude sensitive
> data. A user process (for example a database daemon, a web server, or a vmm
> like qemu) will likely have sensitive data mapped in its user address space.
> Such data shouldn't be mapped with ASI because it can potentially leak to the
> sibling hyperthread. For example, if an hyperthread is running a VM then the
> VM could potentially access user sensitive data if they are mapped on the
> sibling hyperthread with ASI.

So I've proposed the following slightly hackish thing:

Add a mechanism (call it /dev/xpfo).  When you open /dev/xpfo and
fallocate it to some size, you allocate that amount of memory and kick
it out of the kernel direct map.  (And pay the IPI cost unless there
were already cached non-direct-mapped pages ready.)  Then you map
*that* into your VMs.  Now, for a dedicated VM host, you map *all* the
VM private memory from /dev/xpfo.  Pretend it's SEV if you want to
determine which pages can be set up like this.

Does this get enough of the benefit at a negligible fraction of the
code complexity cost?  (This plus core scheduling, anyway.)

--Andy
