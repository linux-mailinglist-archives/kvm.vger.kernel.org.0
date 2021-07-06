Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC83BD9E5
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 17:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhGFPSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 11:18:43 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:4749 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhGFPSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 11:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1625584563; x=1657120563;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=9L58hslPpBOMuTGHIF6YSUe5tTDWwiAmUslPAdS4H0o=;
  b=E+r/NCWpy3sQllHIQn6+Oj5mnQhbACOApa4ZnjkJmjoZzQCWJWXfRI97
   w9UcNJbe/TVC5L7gCAJbYvpwupEsZ+PSfXuDUiNpogDctuvPO3H+kaBL4
   yHFJvKC3+KJZR3BqmgCNDMKKnSNRRFVQogFYSogxeV3j7ju9zN3j7drvR
   o=;
X-IronPort-AV: E=Sophos;i="5.83,328,1616457600"; 
   d="scan'208";a="120509746"
Subject: Re: [PATCH v4 0/4] Add support for XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 06 Jul 2021 15:15:56 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 25A1BA07A0;
        Tue,  6 Jul 2021 15:15:48 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.66) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 6 Jul 2021 15:15:40 +0000
Date:   Tue, 6 Jul 2021 17:15:36 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Message-ID: <20210706151535.GA28697@u366d62d47e3651.ant.amazon.com>
References: <cover.1622019133.git.sidcha@amazon.de>
 <20210630115559.GA32360@u366d62d47e3651.ant.amazon.com>
 <f318fd42-6b98-1a82-f334-d05f4e6cb715@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f318fd42-6b98-1a82-f334-d05f4e6cb715@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 05:04:59PM +0200, Paolo Bonzini wrote:
> On 30/06/21 13:56, Siddharth Chandrasekaran wrote:
> > On Wed, May 26, 2021 at 10:56:07AM +0200, Siddharth Chandrasekaran wrote:
> > > Hyper-V supports the use of XMM registers to perform fast hypercalls.
> > > This allows guests to take advantage of the improved performance of the
> > > fast hypercall interface even though a hypercall may require more than
> > > (the current maximum of) two general purpose registers.
> > > 
> > > The XMM fast hypercall interface uses an additional six XMM registers
> > > (XMM0 to XMM5) to allow the caller to pass an input parameter block of
> > > up to 112 bytes. Hyper-V can also return data back to the guest in the
> > > remaining XMM registers that are not used by the current hypercall.
> > > 
> > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > unless the hypervisor advertises support for it, some hypercalls which
> > > we plan on upstreaming in future uses them anyway. This patchset adds
> > > necessary infrastructure for handling input/output via XMM registers and
> > > patches kvm_hv_flush_tlb() to use xmm input arguments.
> > 
> > Hi Paolo,
> > 
> > Are you expecting more reviews on these patches?
> 
> They are part of 5.14 already. :)

Ahh, I see them now. I was expecting them to show up in master - that was
the confusion.

Thanks! :)

~ Sid



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



