Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8635970D
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhDIIB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:01:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:31260 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhDIIBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1617955304; x=1649491304;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=0dODJGHTN1G1TKvDMXJr3ylFgw4c3pFqrFNAUGidEao=;
  b=j5auExfar16FkPYwRS5DPW3gt8N2aN9YxXtLYQltKTHUn0VKIVyGDKOp
   wC8cCcjXQhLv/vuvIhi0zc8NvLISEhDpyktBFYw/HWC3DpI0CQjPXSDYJ
   f/ktJCvfg6qQvIzeNTcLRqDN7+r2o9mprnhIwUkcWHH+Jf3oWvLjU8vxa
   E=;
X-IronPort-AV: E=Sophos;i="5.82,208,1613433600"; 
   d="scan'208";a="100638758"
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Apr 2021 07:59:35 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 78A80A1DAA;
        Fri,  9 Apr 2021 07:59:29 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.162.104) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 9 Apr 2021 07:59:21 +0000
Date:   Fri, 9 Apr 2021 09:59:17 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kys@microsoft.com>,
        <haiyangz@microsoft.com>, <sthemmin@microsoft.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <graf@amazon.com>, <eyakovl@amazon.de>,
        <linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Wei Liu <wei.liu@kernel.org>
Message-ID: <20210409075916.GB26597@uc8bbc9586ea454.ant.amazon.com>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
 <20210408154006.GA32315@u366d62d47e3651.ant.amazon.com>
 <53200f24-bd57-1509-aee2-0723aa8a3f6f@redhat.com>
 <20210408155442.GC32315@u366d62d47e3651.ant.amazon.com>
 <20210408163018.mlr23jd2r4st54jc@liuwe-devbox-debian-v2>
 <20210408174521.GF32315@u366d62d47e3651.ant.amazon.com>
 <87wntb7vke.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87wntb7vke.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.162.104]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 09:42:41AM +0200, Vitaly Kuznetsov wrote:
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> > On Thu, Apr 08, 2021 at 04:30:18PM +0000, Wei Liu wrote:
> >> On Thu, Apr 08, 2021 at 05:54:43PM +0200, Siddharth Chandrasekaran wrote:
> >> > On Thu, Apr 08, 2021 at 05:48:19PM +0200, Paolo Bonzini wrote:
> >> > > On 08/04/21 17:40, Siddharth Chandrasekaran wrote:
> >> > > > > > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> >> > > > > > > unless the hypervisor advertises support for it, some hypercalls which
> >> > > > > > > we plan on upstreaming in future uses them anyway.
> >> > > > > > No, please don't do this. Check the feature bit(s) before you issue
> >> > > > > > hypercalls which rely on the extended interface.
> >> > > > > Perhaps Siddharth should clarify this, but I read it as Hyper-V being
> >> > > > > buggy and using XMM arguments unconditionally.
> >> > > > The guest is at fault here as it expects Hyper-V to consume arguments
> >> > > > from XMM registers for certain hypercalls (that we are working) even if
> >> > > > we didn't expose the feature via CPUID bits.
> >> > >
> >> > > What guest is that?
> >> >
> >> > It is a Windows Server 2016.
> >>
> >> Can you be more specific? Are you implementing some hypercalls from
> >> TLFS? If so, which ones?
> >
> > Yes all of them are from TLFS. We are implementing VSM and there are a
> > bunch of hypercalls that we have implemented to manage VTL switches,
> > memory protection and virtual interrupts.
> 
> Wow, sounds awesome! Do you plan to upstream this work?

Yes, that is the plan :-)

> > The following 3 hypercalls that use the XMM fast hypercalls are relevant
> > to this patch set:
> >
> > HvCallModifyVtlProtectionMask
> > HvGetVpRegisters
> > HvSetVpRegisters
> 
> It seems AccessVSM and AccessVpRegisters privilges have implicit
> dependency on XMM input/output. This will need to be enforced in KVM
> userspace.

Noted.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



