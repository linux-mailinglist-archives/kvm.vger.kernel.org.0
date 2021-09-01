Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773363FD1D9
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 05:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbhIADfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 23:35:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:25251 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241452AbhIADfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 23:35:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="205836477"
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="205836477"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 20:34:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="531657052"
Received: from zhibosun-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.93])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 20:34:32 -0700
Date:   Wed, 1 Sep 2021 11:34:29 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210901033429.4c2dh5cwlppjvz2h@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <243bc6a3-b43b-cd18-9cbb-1f42a5de802f@redhat.com>
 <765e9bbe-2df5-3dcc-9329-347770dc091d@linux.intel.com>
 <4677f310-5987-0c13-5caf-fd3b625b4344@redhat.com>
 <cf24c39e-2e87-f596-4375-9368ed8ef813@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf24c39e-2e87-f596-4375-9368ed8ef813@linux.intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 01:39:31PM -0700, Andi Kleen wrote:
> 
> On 8/31/2021 1:15 PM, David Hildenbrand wrote:
> > On 31.08.21 22:01, Andi Kleen wrote:
> > > 
> > > > > Thanks a lot for this summary. A question about the requirement: do
> > > > > we or
> > > > > do we not have plan to support assigned device to the protected VM?
> > > > 
> > > > Good question, I assume that is stuff for the far far future.
> > > 
> > > It is in principle possible with the current TDX, but not secure. But
> > > someone might decide to do it. So it would be good to have basic support
> > > at least.
> > 
> > Can you elaborate the "not secure" part? Do you mean, making the device
> > only access "shared" memory, not secure/encrypted/whatsoever?
> 
> 
> Yes that's right. It can only access shared areas.

Thanks, Andy & David.

Actually, enabling of device assinment needs quite some effort, e.g.,
to guarantee only shared pages are mapped in IOMMU page table (using
shared GFNs). And the buffer copying inside TD is still unavoidable,
thus not much performance benefit.

Maybe we should just *disable* VFIO device in TDX first. 

As to the fd-based private memory, enventually we will have to tolerate
its impact on any place where GUP is needed in virtualization. :)

B.R.
Yu
