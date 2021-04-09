Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B838D359102
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 02:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhDIAmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 20:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhDIAmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 20:42:03 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA44C061761
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 17:41:51 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id j26so4150453iog.13
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 17:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4EqcqyyLGjnPnO8hO13ub4Spc+gSKPbDlePKZOyB7VI=;
        b=XZ5RvS6S7qnhCuLT3IeOva06TKLRiIDjAQ9Uvxkg73Fx4yBb/0LMCn0kbBsmELOvhZ
         4eHWymQ370lLtgR7TU3lgL2JoFcsgNmOR1SXfzob/Pt0Vee+hJiWHVdxqhmC7rjGKNq4
         XDJur2k1/oUYJdYnfQYqITOFSAYIJvXgU15G2c9v999iMee3UANiaob8TVYnhtgjoymg
         I0X2Df4odDYIaqhsi4uI+NWUwbaBbu37zjzo4Z64xktKRqbQfV6hf1wjyyZjhl41xlZH
         B4Sf8BsznJ5LFEIGYiv1eDubkR1PHo8qhSnDpkK+1KVD4zipa4tn3fWMzNrZNO+U8nLY
         QMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4EqcqyyLGjnPnO8hO13ub4Spc+gSKPbDlePKZOyB7VI=;
        b=FEhMAmKsNRkhz0P8VxeU4o9cfcP1CELwGZi/lycpa8o/u2Os4lnsu/OCWQoQ8mr/gN
         du1DhCf5d/Tq0JDZdTHP4dBlpQ42VtfPjb3OacehX5RC9S69P5VDFjgY1EOHePLghuvN
         8d5AYRefRgjxxflMXo0bpoR18UjiBhOYmSSDN2uZw9+qkj3bgr1A8H3jCcox4kEeDaBo
         B22CxuywQjtXITk9/SZ8v2FkwEliURzgg0XbXFqMl14MXzc2sF4qUZFZzPYEA0pj5ijc
         NLNs16DR4jZsySupcTXr6eXxsP1LVAgRvXz9nIvvB1bah9wmwsgSMf2hem6H4IVO/X0L
         4exw==
X-Gm-Message-State: AOAM5322Qb8QrW1f//jJuHflgsiZx/bTnJJa+Yzdokw2x8/tmdcH7uhm
        X2J5ZrLsrG0GJOfiN5P/Hj+LXw1aacNjz7HJEjC7TA==
X-Google-Smtp-Source: ABdhPJyuN9O8S99YXTYhOZE7vgJbGiq0LfmDY4/K88DNh54FmfRZMYO4BLuzn59QkWz86MdcrxWrmx9c0zXvOmTIkvI=
X-Received: by 2002:a5e:8c16:: with SMTP id n22mr9083188ioj.156.1617928910195;
 Thu, 08 Apr 2021 17:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210316014027.3116119-1-natet@google.com> <20210402115813.GB17630@ashkalra_ubuntu_server>
 <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com> <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
 <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com> <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
In-Reply-To: <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 8 Apr 2021 17:41:14 -0700
Message-ID: <CABayD+c22hgPtjJBLkhyvyt+WAKXhoQOM6n0toVR1XrFY4WHAw@mail.gmail.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
To:     jejb@linux.ibm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 8, 2021 at 2:15 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Thu, 2021-04-08 at 12:48 -0700, Steve Rutherford wrote:
> > On Thu, Apr 8, 2021 at 10:43 AM James Bottomley <jejb@linux.ibm.com>
> > wrote:
> > > On Fri, 2021-04-02 at 16:20 +0200, Paolo Bonzini wrote:
> > > > On 02/04/21 13:58, Ashish Kalra wrote:
> > > > > Hi Nathan,
> > > > >
> > > > > Will you be posting a corresponding Qemu patch for this ?
> > > >
> > > > Hi Ashish,
> > > >
> > > > as far as I know IBM is working on QEMU patches for guest-based
> > > > migration helpers.
> > >
> > > Yes, that's right, we'll take on this part.
> > >
> > > > However, it would be nice to collaborate on the low-level
> > > > (SEC/PEI) firmware patches to detect whether a CPU is part of the
> > > > primary VM or the mirror.  If Google has any OVMF patches already
> > > > done for that, it would be great to combine it with IBM's SEV
> > > > migration code and merge it into upstream OVMF.
> > >
> > > We've reached the stage with our prototyping where not having the
> > > OVMF support is blocking us from working on QEMU.  If we're going
> > > to have to reinvent the wheel in OVMF because Google is unwilling
> > > to publish the patches, can you at least give some hints about how
> > > you did it?
> > >
> > > Thanks,
> > >
> > > James
> >
> > Hey James,
> > It's not strictly necessary to modify OVMF to make SEV VMs live
> > migrate. If we were to modify OVMF, we would contribute those changes
> > upstream.
>
> Well, no, we already published an OVMF RFC to this list that does
> migration.  However, the mirror approach requires a different boot
> mechanism for the extra vCPU in the mirror.  I assume you're doing this
> bootstrap through OVMF so the hypervisor can interrogate it to get the
> correct entry point?  That's the code we're asking to see because
> that's what replaces our use of the MP service in the RFC.
>
> James

Hey James,
The intention would be to have a separate, stand-alone firmware-like
binary run by the mirror. Since the VMM is in control of where it
places that binary in the guest physical address space and the initial
configuration of the vCPUs, it can point the vCPUs at an entry point
contained within that binary, rather than at the standard x86 reset
vector.

Thanks,
Steve
