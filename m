Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDA035DAC7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 11:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245281AbhDMJL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 05:11:59 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:33888 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbhDMJL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 05:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1618305098; x=1649841098;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=9OKBIxKddRO6dVokae9Nxqj8+3Oy9D13htA8hNvlxT0=;
  b=VLmfQlc49UZUIOyLrsXwDwJARKHBAGr/q7BfUWlA9APc2CaMGFB4zHcu
   POTgsPZ6w5SxUMsWpK1pUrpo6YjTGUXAIws+8oePNm2UGlO20ErFxn4ZF
   vjw/1vVpWDEW0NpoTsNHLOo9QUPRj6014mMNLbK/dNWi7MxqwVSqOznIy
   A=;
X-IronPort-AV: E=Sophos;i="5.82,219,1613433600"; 
   d="scan'208";a="925562785"
Subject: Re: [PATCH v2 4/4] KVM: hyper-v: Advertise support for fast XMM hypercalls
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 13 Apr 2021 09:11:30 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 56F38A1D98;
        Tue, 13 Apr 2021 09:11:23 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.209) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Apr 2021 09:11:15 +0000
Date:   Tue, 13 Apr 2021 11:11:11 +0200
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
Message-ID: <20210413091110.GB25751@u366d62d47e3651.ant.amazon.com>
References: <cover.1618244920.git.sidcha@amazon.de>
 <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
 <20210412201423.rfpykzfgpmjh6ydy@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210412201423.rfpykzfgpmjh6ydy@liuwe-devbox-debian-v2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.209]
X-ClientProxiedBy: EX13D47UWC004.ant.amazon.com (10.43.162.74) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 08:14:23PM +0000, Wei Liu wrote:
> On Mon, Apr 12, 2021 at 07:00:17PM +0200, Siddharth Chandrasekaran wrote:
> > Now that all extant hypercalls that can use XMM registers (based on
> > spec) for input/outputs are patched to support them, we can start
> > advertising this feature to guests.
> >
> > Cc: Alexander Graf <graf@amazon.com>
> > Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> > Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> > ---
> >  arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
> >  arch/x86/kvm/hyperv.c              | 2 ++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> > index e6cd3fee562b..716f12be411e 100644
> > --- a/arch/x86/include/asm/hyperv-tlfs.h
> > +++ b/arch/x86/include/asm/hyperv-tlfs.h
> > @@ -52,7 +52,7 @@
> >   * Support for passing hypercall input parameter block via XMM
> >   * registers is available
> >   */
> > -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE                BIT(4)
> > +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE         BIT(4)
> >  /* Support for a virtual guest idle state is available */
> >  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE            BIT(5)
> >  /* Frequency MSRs available */
> > @@ -61,6 +61,11 @@
> >  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE         BIT(10)
> >  /* Support for debug MSRs available */
> >  #define HV_FEATURE_DEBUG_MSRS_AVAILABLE                      BIT(11)
> > +/*
> > + * Support for returning hypercall ouput block via XMM
> 
> "output"

Fixed. Thanks.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



