Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94621368F94
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbhDWJnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 05:43:19 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:56338 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241859AbhDWJnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 05:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1619170962; x=1650706962;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9mMr/D9KoykMs8D6BsWa8p9s/mOXuf0pFKy9BjBITS8=;
  b=qEknc8/CuCW46YGTJQXU814Iej/ItOY0U8nI+2uFHiJ569ZVhIfiLz3t
   QvM5kPBFtvFF+9jZYzAS/f+Dlxyc0W6UUBuEzOwtXSZ30SK6vaHliXJVX
   jFcFMfR+TktS3VUIUKKJybtJa9abQ+ewGEuR4uS6fEVCEkqFhHbZVmeVk
   o=;
X-IronPort-AV: E=Sophos;i="5.82,245,1613433600"; 
   d="scan'208";a="121018895"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 23 Apr 2021 09:42:33 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id AF72AA1F06;
        Fri, 23 Apr 2021 09:42:28 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.207) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 23 Apr 2021 09:42:22 +0000
Date:   Fri, 23 Apr 2021 11:42:17 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Alexander Graf <graf@amazon.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: hyper-v: Add new exit reason HYPERV_OVERLAY
Message-ID: <20210423094216.GA30824@uc8bbc9586ea454.ant.amazon.com>
References: <20210423090333.21910-1-sidcha@amazon.de>
 <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <224d266e-aea3-3b4b-ec25-7bb120c4d98a@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.207]
X-ClientProxiedBy: EX13D35UWB002.ant.amazon.com (10.43.161.154) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 11:24:04AM +0200, Alexander Graf wrote:
> 
> 
> On 23.04.21 11:03, Siddharth Chandrasekaran wrote:
> > Hypercall code page is specified in the Hyper-V TLFS to be an overlay
> > page, ie., guest chooses a GPA and the host _places_ a page at that
> > location, making it visible to the guest and the existing page becomes
> > inaccessible. Similarly when disabled, the host should _remove_ the
> > overlay and the old page should become visible to the guest.
> > 
> > Currently KVM directly patches the hypercall code into the guest chosen
> > GPA. Since the guest seldom moves the hypercall code page around, it
> > doesn't see any problems even though we are corrupting the exiting data
> > in that GPA.
> > 
> > VSM API introduces more complex overlay workflows during VTL switches
> > where the guest starts to expect that the existing page is intact. This
> > means we need a more generic approach to handling overlay pages: add a
> > new exit reason KVM_EXIT_HYPERV_OVERLAY that exits to userspace with the
> > expectation that a page gets overlaid there.
> 
> I can see how that may get interesting for other overlay pages later, but
> this one in particular is just an MSR write, no? Is there any reason we
> can't just use the user space MSR handling logic instead?
> 
> What's missing then is a way to pull the hcall page contents from KVM. But
> even there I'm not convinced that KVM should be the reference point for its
> contents. Isn't user space in an as good position to assemble it?

Makes sense. Let me explore that route and get back to you.

> > 
> > In the interest of maintaing userspace exposed behaviour, add a new KVM
> > capability to allow the VMMs to enable this if they can handle the
> > hypercall page in userspace.
> > 
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > 
> > CR: https://code.amazon.com/reviews/CR-49011379
> 
> Please remove this line from upstream submissions :).

I noticed it a bit late (a tooling gap). You shouldn't see this in any
of my future patches.

> > ---
> >   arch/x86/include/asm/kvm_host.h |  4 ++++
> >   arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++++++---
> >   arch/x86/kvm/x86.c              |  5 +++++
> >   include/uapi/linux/kvm.h        | 10 ++++++++++
> 
> You're modifying / adding a user space API. Please make sure to update the
> documentation in Documentation/virt/kvm/api.rst when you do that.

Ack. Will add it.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



