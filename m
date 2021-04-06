Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC45355131
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbhDFKuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 06:50:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:36682 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242695AbhDFKu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 06:50:29 -0400
IronPort-SDR: eyEVuMdzHhPeiMFjex/7+UsIr2Jp/OGJxt6rCGD2Aa7wJmTn+ItZyGT/2iZaQZmQ1lFi6qdaZs
 DkHHKPPK97oA==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="193079682"
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="193079682"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 03:50:21 -0700
IronPort-SDR: 8/Y2cr+OADla4TLlnAo6H5OCCTBNzsA8FTkB09gdeAgSuSL4k7U5bXGW5oOw1M/hz7Yw5EhgYD
 Y9x0mvzOWZuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,309,1610438400"; 
   d="scan'208";a="386530847"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 06 Apr 2021 03:50:10 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id A3A4629D; Tue,  6 Apr 2021 13:50:24 +0300 (EEST)
Date:   Tue, 6 Apr 2021 13:50:24 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <20210406105024.ikz5fbozwu476yba@black.fi.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 09:44:07AM +0200, David Hildenbrand wrote:
> On 02.04.21 17:26, Kirill A. Shutemov wrote:
> > TDX architecture aims to provide resiliency against confidentiality and
> > integrity attacks. Towards this goal, the TDX architecture helps enforce
> > the enabling of memory integrity for all TD-private memory.
> > 
> > The CPU memory controller computes the integrity check value (MAC) for
> > the data (cache line) during writes, and it stores the MAC with the
> > memory as meta-data. A 28-bit MAC is stored in the ECC bits.
> > 
> > Checking of memory integrity is performed during memory reads. If
> > integrity check fails, CPU poisones cache line.
> > 
> > On a subsequent consumption (read) of the poisoned data by software,
> > there are two possible scenarios:
> > 
> >   - Core determines that the execution can continue and it treats
> >     poison with exception semantics signaled as a #MCE
> > 
> >   - Core determines execution cannot continue,and it does an unbreakable
> >     shutdown
> > 
> > For more details, see Chapter 14 of Intel TDX Module EAS[1]
> > 
> > As some of integrity check failures may lead to system shutdown host
> > kernel must not allow any writes to TD-private memory. This requirment
> > clashes with KVM design: KVM expects the guest memory to be mapped into
> > host userspace (e.g. QEMU).
> 
> So what you are saying is that if QEMU would write to such memory, it could
> crash the kernel? What a broken design.

Cannot disagree. #MCE for integrity check is very questionable. But I'm not
CPU engineer.

> "As some of integrity check failures may lead to system shutdown host" --
> usually we expect to recover from an MCE by killing the affected process,
> which would be the right thing to do here.

In the most cases that's what happen.

> How can it happen that "Core determines execution cannot continue,and it
> does an unbreakable shutdown". Who is "Core"? CPU "core", MM "core" ?

CPU core.

> And why would it decide to do a shutdown instead of just killing the
> process?

<As I said, I'm not CPU engineer. Below is my understanding of the issue.>

If the CPU handles long flow instruction (involves microcode and doing
multiple memory accesses), consuming poison somewhere in the middle leads
to CPU not being able to get back into sane state and the only option is
system shutdown.

-- 
 Kirill A. Shutemov
