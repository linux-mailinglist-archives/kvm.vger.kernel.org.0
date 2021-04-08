Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E55358BA1
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhDHRp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:45:58 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13320 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhDHRp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617903947; x=1649439947;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=cRK7cHLlPvIvXeQBZsTih5yQp0YoZivUbAIHh/I9DCY=;
  b=edMobyrzZVYrsPeN3ebdRNr5IkzMCQ2nV8sFTAauVC7nzkVAt3tEjhe5
   tm4ETr5GJlIilM15298CXr4bLZRfi6xz2MRNZLjPxq+qr1sejlS99tf0h
   AhRk8FHOc2s9mp+aMLtSznKVivHH5L9xt87IGap2t9fazA8ZAwnfEfQvh
   s=;
X-IronPort-AV: E=Sophos;i="5.82,207,1613433600"; 
   d="scan'208";a="100501308"
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Apr 2021 17:45:39 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id E3A73A17D1;
        Thu,  8 Apr 2021 17:45:33 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.224) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 8 Apr 2021 17:45:26 +0000
Date:   Thu, 8 Apr 2021 19:45:22 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Wei Liu <wei.liu@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <jmattson@google.com>, <joro@8bytes.org>, <graf@amazon.com>,
        <eyakovl@amazon.de>, <linux-hyperv@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Message-ID: <20210408174521.GF32315@u366d62d47e3651.ant.amazon.com>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408154006.GA32315@u366d62d47e3651.ant.amazon.com>
 <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
 <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
 <20210408163018.mlr23jd2r4st54jc@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210408163018.mlr23jd2r4st54jc@liuwe-devbox-debian-v2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.224]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 04:30:18PM +0000, Wei Liu wrote:
> On Thu, Apr 08, 2021 at 05:54:43PM +0200, Siddharth Chandrasekaran wrote:
> > On Thu, Apr 08, 2021 at 05:48:19PM +0200, Paolo Bonzini wrote:
> > > On 08/04/21 17:40, Siddharth Chandrasekaran wrote:
> > > > > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > > > > > unless the hypervisor advertises support for it, some hypercalls which
> > > > > > > we plan on upstreaming in future uses them anyway.
> > > > > > No, please don't do this. Check the feature bit(s) before you issue
> > > > > > hypercalls which rely on the extended interface.
> > > > > Perhaps Siddharth should clarify this, but I read it as Hyper-V being
> > > > > buggy and using XMM arguments unconditionally.
> > > > The guest is at fault here as it expects Hyper-V to consume arguments
> > > > from XMM registers for certain hypercalls (that we are working) even if
> > > > we didn't expose the feature via CPUID bits.
> > >
> > > What guest is that?
> >
> > It is a Windows Server 2016.
> 
> Can you be more specific? Are you implementing some hypercalls from
> TLFS? If so, which ones?

Yes all of them are from TLFS. We are implementing VSM and there are a
bunch of hypercalls that we have implemented to manage VTL switches,
memory protection and virtual interrupts.

The following 3 hypercalls that use the XMM fast hypercalls are relevant
to this patch set:

HvCallModifyVtlProtectionMask
HvGetVpRegisters 
HvSetVpRegisters 

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



