Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A79CB12B8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 18:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfILQZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 12:25:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38494 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfILQZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 12:25:13 -0400
Received: by mail-io1-f67.google.com with SMTP id k5so30912292iol.5
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LF/e0cGCSN9IvVALmGVaj7iz0RkHKWd8NvWpFPS1BzY=;
        b=vO4KS8QzZFtG88RQcb/R+R0tpmbuY2SGmOtBeX7H5RcFSXoSYFTH3vBTGXA+JA2NQ8
         fW9nmYtP4A7lMeaCyCGAGgz84eADWtRp15U7xRDqGRNdqmOIs589ZARrmQjFR+45JTs5
         VxymTWK9ycZH1kiunCGgwADldY0feA5qZnrUcS4FJj2tP5ZMUbH9v4rdN1TnNZQayG1e
         db7pDmV2R+P28bpYzqSpkZhXM/QEnNY945u5jBv+3B7q4UTjoRwsiVygNH9qfF6tD7Cs
         RpAPRW/Bi2/p1e6HRTaHtkRPg/gTowvTM7e0eIrSwuo9f5KZxszin2klPIyvvQ4cys/h
         pTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LF/e0cGCSN9IvVALmGVaj7iz0RkHKWd8NvWpFPS1BzY=;
        b=lSutC1qXje8ADJ1a077k9yRmhy0WtI7ro0Zc9FH7+9Fmts8Gs9uJ7+B/qHusHoW+jQ
         pMkpoDBNWBSxoS99DuycrflIKqrEgAmFAR2dDzBBxJ17nBLK8jzra6egFjHnJj/9b/TM
         dxYkexWbyeyZVrPdOqJ26bIyKHtOkzydIFdzT7QR4RzaxWocX++fuPySSZPtv7/Yz+Ql
         9FFCChzF8rA0caBlRGVsu+VohNkmeKOlEmOi6Q4lITtnb9sGnelLVeAw0aa7Z2MNF96Y
         9SG3FAtpP8oPsKNh+bUtBeN1igvUj3IAC66zVyB2lzUaIQpD89VZ95mgwKoDcHvvvvg9
         tkoA==
X-Gm-Message-State: APjAAAWglSE39hLyOBrMcm2MeUVRS0vmV6uelfF68bOeNr5anZeQ3BWT
        AYG70VTUcy1NzThbqiKaxTSY6SHvzTr/3Abrudvv4A==
X-Google-Smtp-Source: APXvYqyNxePogCl0vKtcjTWqmU/KgJfBWKnLJK7ApFawi4gcdGRbFqESiMnGVkYglCZJxfez6eiQ1eh/hZwyuI2ciTQ=
X-Received: by 2002:a02:3b6f:: with SMTP id i47mr19566912jaf.24.1568305512155;
 Thu, 12 Sep 2019 09:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190909222812.232690-1-jmattson@google.com> <20190909222812.232690-2-jmattson@google.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D57154C@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D57154C@SHSMSX104.ccr.corp.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Sep 2019 09:25:01 -0700
Message-ID: <CALMp9eRz7=nCQHHRUcgQ62majARu-+bTCyfuNd7mpn0vRAE-sA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 1/1] KVM: nVMX: Don't leak L1 MMIO regions to L2
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dan Cross <dcross@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 12:55 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Tian, Kevin
> > Sent: Thursday, September 12, 2019 3:49 PM
> >
> > > From: Jim Mattson
> > > Sent: Tuesday, September 10, 2019 6:28 AM
> > >
> > > If the "virtualize APIC accesses" VM-execution control is set in the
> > > VMCS, the APIC virtualization hardware is triggered when a page walk
> > > in VMX non-root mode terminates at a PTE wherein the address of the 4k
> > > page frame matches the APIC-access address specified in the VMCS. On
> > > hardware, the APIC-access address may be any valid 4k-aligned physical
> > > address.
> > >
> > > KVM's nVMX implementation enforces the additional constraint that the
> > > APIC-access address specified in the vmcs12 must be backed by
> > > cacheable memory in L1. If not, L0 will simply clear the "virtualize
> > > APIC accesses" VM-execution control in the vmcs02.
> > >
> > > The problem with this approach is that the L1 guest has arranged the
> > > vmcs12 EPT tables--or shadow page tables, if the "enable EPT"
> > > VM-execution control is clear in the vmcs12--so that the L2 guest
> > > physical address(es)--or L2 guest linear address(es)--that reference
> > > the L2 APIC map to the APIC-access address specified in the
> > > vmcs12. Without the "virtualize APIC accesses" VM-execution control in
> > > the vmcs02, the APIC accesses in the L2 guest will directly access the
> > > APIC-access page in L1.
> > >
> > > When L0 has no mapping whatsoever for the APIC-access address in L1,
> > > the L2 VM just loses the intended APIC virtualization. However, when
> > > the L2 APIC-access address is mapped to an MMIO region in L1, the L2
> > > guest gets direct access to the L1 MMIO device. For example, if the
> > > APIC-access address specified in the vmcs12 is 0xfee00000, then L2
> > > gets direct access to L1's APIC.
> >
> > 'direct access to L1 APIC' is conceptually correct but won't happen
> > in current KVM design. Above either leads to direct access to L0's
> > APIC-access page (if L0 VMM enables "virtualized APIC accesses"
> > and maps L1 0xfee00000 to L0 APIC-access page), which doesn't
> > really hold L1's APIC state, or cause nested EPT violation fault into
> > L1 VMM (if L0 VMM disables "virtualized APIC accesses", thus L1
> > 0xfee00000 has no valid mapping in L0 EPT). Of course either way
> > is still broken. The former cannot properly virtualize the L2 APIC,
> > while the latter may confuse the L1 VMM if only APIC-access
> > VM exit is expected. But there is not direct L2 access to L1's APIC
> > state anyway. :-)
>
> Sorry sent too fast. :/ There is no nested EPT fault in the latter
> case - it's caused by L0 EPT instead of L1 EPT. Then L0 VMM will
> emulate the L2 access using L1's APIC, as you described.

As it must do, or something else is dreadfully wrong. If L1 sets up
the VMCS12 extended page tables (or shadow page tables, if EPT is not
enabled in VMCS12) such that L2 can access an MMIO region in L1, then
accesses from L2 to that MMIO region should interact with the
corresponding L1 device.
