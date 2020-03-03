Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255B7176DDC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCCEMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:12:09 -0500
Received: from mga12.intel.com ([192.55.52.136]:10034 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgCCEMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:12:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 20:12:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,510,1574150400"; 
   d="scan'208";a="412601038"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 02 Mar 2020 20:12:08 -0800
Date:   Mon, 2 Mar 2020 20:12:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when
 function is out-of-range
Message-ID: <20200303041208.GE27842@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-2-sean.j.christopherson@intel.com>
 <188dc96a-6a3b-4021-061a-0f11cbb9f177@siemens.com>
 <20200302204940.GG6244@linux.intel.com>
 <16e902a8-7883-0b67-d4ee-73e8fe22f955@intel.com>
 <20200303034532.GC27842@linux.intel.com>
 <fcd08758-2191-8fb0-35b1-c3ce5b2cbb43@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcd08758-2191-8fb0-35b1-c3ce5b2cbb43@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 12:02:39PM +0800, Xiaoyao Li wrote:
> On 3/3/2020 11:45 AM, Sean Christopherson wrote:
> >On Tue, Mar 03, 2020 at 10:27:47AM +0800, Xiaoyao Li wrote:
> >>Sorry I cannot catch you. Why it's a violation of Intel's SDM?
> >
> >The case being discussed above would look like:
> >
> >KVM CPUID Entries:
> >    Function   Index Output
> >    0x00000000 0x00: eax=0x0000000b ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> >    0x00000001 0x00: eax=0x000906ea ebx=0x03000800 ecx=0xfffa3223 edx=0x0f8bfbff
> >    0x00000002 0x00: eax=0x00000001 ebx=0x00000000 ecx=0x0000004d edx=0x002c307d
> >    0x00000003 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >    0x00000004 0x00: eax=0x00000121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >    0x00000004 0x01: eax=0x00000122 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >    0x00000004 0x02: eax=0x00000143 ebx=0x03c0003f ecx=0x00000fff edx=0x00000001
> >    0x00000004 0x03: eax=0x00000163 ebx=0x03c0003f ecx=0x00003fff edx=0x00000006
> >    0x00000005 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000003 edx=0x00000000
> >    0x00000006 0x00: eax=0x00000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >    0x00000007 0x00: eax=0x00000000 ebx=0x009c4fbb ecx=0x00000004 edx=0x84000000
> >    0x00000008 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >    0x00000009 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >    0x0000000a 0x00: eax=0x07300402 ebx=0x00000000 ecx=0x00000000 edx=0x00000603
> >--> MISSING CPUID.0xB.0
> >    0x0000000b 0x01: eax=0x00000000 ebx=0x00000001 ecx=0x00000201 edx=0x00000003
> >
> >CPUID.0xB.0 does not exist, so output.ECX=0, which indicates an invalid
> >level-type.
> >
> >The SDM states (for CPUID.0xB):
> >
> >    If an input value n in ECX returns the invalid level-type of 0 in ECX[15:8],
> >    other input values with ECX > n also return 0 in ECX[15:8]
> >
> >That means returning a valid level-type in CPUID.0xB.1 as above violates
> >the SDM's definition of how leaf 0xB works.  I'm arguing we can ignore the
> >adjustments that would be done on output.E{C,D} for an out of range leaf
> >because the model is bogus.
> 
> Right.
> 
> So we'd better do something in KVM_SET_CPUID* , to avoid userspace set bogus
> cpuid.
> 
> >>Supposing the max basic is 0x1f, and it queries cpuid(0x20, 0x5),
> >>it should return cpuid(0x1f, 0x5).
> >>
> >>But based on this patch, it returns all zeros.
> >
> >Have you tested the patch, or is your comment based on the above discussion
> >and/or code inspection?  Honest question, because I've thoroughly tested
> >the above scenario and it works as you describe, but now I'm worried I
> >completely botched my testing.
> >
> 
> No, I didn't test.
> 
> Leaf 0xB and 0x1f are special cases when they are the maximum basic leaf,
> because no matter what subleaf is, there is always a non-zero E[CX,DX].
> 
> If cpuid.0 returns maximum basic leaf as 0xB/0x1F, when queried leaf is
> greater, it should always return a non-zero value.

Yes, and that's userspace's responsibility to not screw up.  E.g. if
userspace didn't create CPUID.0xB.0 (as above) then it's not KVM's fault
for returning zeros when the guest executes CPUID.0xB.0.
