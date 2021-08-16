Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ABB3EDFF8
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 00:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhHPWbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 18:31:15 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:33038 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhHPWbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 18:31:14 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C0FDB92009C; Tue, 17 Aug 2021 00:30:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BBCE492009B;
        Tue, 17 Aug 2021 00:30:39 +0200 (CEST)
Date:   Tue, 17 Aug 2021 00:30:39 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86: PIRQ/ELCR-related fixes and updates
In-Reply-To: <611993B1.4070302@gmail.com>
Message-ID: <alpine.DEB.2.21.2108160027350.45958@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2107171813230.9461@angie.orcam.me.uk> <611993B1.4070302@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikolai,

> >   Nikolai: for your system only 1/6 and 2/6 are required, though you are
> > free to experiment with all the patches.  Mind that 3/6 mechanically
> > depends on the earlier change for the SIO PIRQ router referred above.  In
> > any case please use the debug patch for PCI code as well as the earlier
> > patches for your other system and send the resulting bootstrap log for
> > confirmation.
> 
> Here is a new log with 1/6 and 2/6 applied:
> 
> https://pastebin.com/0MgXAGtG
> 
> It looks like something went a bit unexpected ("runtime IRQ mapping not
> provided by arch").

 Offhand it looks like your system does not supply a PIRQ table, not at 
least at the usual locations we look through.  The presence of the table 
is reported like:

PCI: IRQ init
PCI: Interrupt Routing Table found at 0xfde10
[...]
PCI: IRQ fixup

while your system says:

PCI: IRQ init
PCI: IRQ fixup

If you have a look through /dev/mem and see if there's a "$PIR" signature 
somewhere (though not a Linux kernel area of course), then we may know for 
sure.

 I'm a little busy at the moment with other stuff and may not be able to 
look into it properly right now.  There may be no solution, not at least 
an easy one.  A DMI quirk is not possible, because:

DMI not present or invalid.

There is a PCI BIOS:

PCI: PCI BIOS revision 2.10 entry at 0xf6f41, last bus=0

however, so CONFIG_PCI_BIOS just might work.  Please try that too, by 
choosing CONFIG_PCI_GOANY or CONFIG_PCI_GOBIOS (it may break things 
horribly though I imagine).

  Maciej
