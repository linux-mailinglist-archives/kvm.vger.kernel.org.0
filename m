Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C651F35DABE
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 11:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbhDMJK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 05:10:27 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58042 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbhDMJK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 05:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618305008; x=1649841008;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=6DqggFsGnhIjwKPT5yW4TYNKPxGBJ7RPW0npHrxtKjI=;
  b=LRWBPWks2reCrZUZbBumoqf5ZBEw5tEHVCvslXUGaX4Bzl0DW0120rkZ
   r33hzNqasH5h20WLxHo8N3sTHZRcr1tW8MK/HqCRjQj9/RBG8TSUi3yZg
   ZtGvH813aPFQASbKhwvGi/aujRbUx/mupzwzbmy3I2z2MXMrdFZ0nfYMU
   k=;
X-IronPort-AV: E=Sophos;i="5.82,219,1613433600"; 
   d="scan'208";a="101292551"
Subject: Re: [PATCH v2 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM registers
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Apr 2021 09:10:00 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 00B0FA248A;
        Tue, 13 Apr 2021 09:09:53 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.102) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 09:09:45 +0000
Date:   Tue, 13 Apr 2021 11:09:41 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Wei Liu <wei.liu@kernel.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Alexander Graf" <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Message-ID: <20210413090906.GA25751@u366d62d47e3651.ant.amazon.com>
References: <cover.1618244920.git.sidcha@amazon.de>
 <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
 <20210412201319.lnohqg6r54p6embb@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210412201319.lnohqg6r54p6embb@liuwe-devbox-debian-v2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D36UWB003.ant.amazon.com (10.43.161.118) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 08:13:19PM +0000, Wei Liu wrote:
> On Mon, Apr 12, 2021 at 07:00:16PM +0200, Siddharth Chandrasekaran wrote:
> > +
> > +static inline void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)
> 
> Do you really need inline here? The compiler should be smart enough to
> inline this function if necessary.

Removed.

> > +{
> > +     int reg;
> > +
> > +     kvm_fpu_get();
> > +     for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> > +             _kvm_read_sse_reg(reg, &hc->xmm[reg]);
> > +     kvm_fpu_put();
> > +     hc->xmm_dirty = false;
> 
> There is no code that sets xmm_dirty to true? What am I missing? I guess
> that's because you haven't implemented the hypercalls that need writing
> back to guest?

Yes, when a hypercall want to return data via XMM registers, it should
update hc->xmm[] and set hc->dirty (I plan on using this in a future
patch). The reason why I didn't differ this change to actual patch
needs it is that it pairs nicely with the read/write xmm_reg() calls in
kvm_hv_hypercall().

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



