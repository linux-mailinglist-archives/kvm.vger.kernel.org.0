Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392D332121D
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 09:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBVIiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 03:38:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:1889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhBVIiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 03:38:13 -0500
IronPort-SDR: hJk6zR1Bw9BmLm0l+8K7YyzBepy+XdZFr/gnjROdecwWbLfQKuJNlu/uuTvn/Eomx2qW7mHqYX
 OTbi0r7Td3wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="181873194"
X-IronPort-AV: E=Sophos;i="5.81,196,1610438400"; 
   d="scan'208";a="181873194"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 00:36:26 -0800
IronPort-SDR: PttWpZcASTkkXg2ujXx27QUG3kFJ4dOBSdqxXaoeBRIkr+wB0iG/XQzd1Mow+lqcsQb2WiWQE2
 CONidesRTakg==
X-IronPort-AV: E=Sophos;i="5.81,196,1610438400"; 
   d="scan'208";a="441314258"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.120]) ([10.238.130.120])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 00:36:13 -0800
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing2.liu@intel.com, "x86@kernel.org" <x86@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
 <YCF1d0F0AqPazYqC@google.com>
 <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
 <YCF9GztNd18t1zk/@google.com>
 <c293cdbd-502c-d598-3166-4e177ac21c7a@redhat.com>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <8cc8ab19-7438-8521-9bc3-d3f6d6e0d5c4@linux.intel.com>
Date:   Mon, 22 Feb 2021 16:36:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c293cdbd-502c-d598-3166-4e177ac21c7a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2021 2:12 AM, Paolo Bonzini wrote:
> On 08/02/21 19:04, Sean Christopherson wrote:
>>> That said, the case where we saw MSR autoload as faster involved 
>>> EFER, and
>>> we decided that it was due to TLB flushes (commit f6577a5fa15d, 
>>> "x86, kvm,
>>> vmx: Always use LOAD_IA32_EFER if available", 2014-11-12). Do you 
>>> know if
>>> RDMSR/WRMSR is always slower than MSR autoload?
>> RDMSR/WRMSR may be marginally slower, but only because the autoload 
>> stuff avoids
>> serializing the pipeline after every MSR.
>
> That's probably adding up quickly...
>
>> The autoload paths are effectively
>> just wrappers around the WRMSR ucode, plus some extra VM-Enter 
>> specific checks,
>> as ucode needs to perform all the normal fault checks on the index 
>> and value.
>> On the flip side, if the load lists are dynamically constructed, I 
>> suspect the
>> code overhead of walking the lists negates any advantages of the load 
>> lists.
>
> ... but yeah this is not very encouraging.
Thanks for reviewing the patches.

> Context switch time is a problem for XFD.  In a VM that uses AMX, most 
> threads in the guest will have nonzero XFD but the vCPU thread itself 
> will have zero XFD.  So as soon as one thread in the VM forces the 
> vCPU thread to clear XFD, you pay a price on all vmexits and vmentries.
>

Spec says,
"If XSAVE, XSAVEC, XSAVEOPT, or XSAVES is saving the state component i,
the instruction does not generate #NM when XCR0[i] = IA32_XFD[i] = 1;
instead, it saves bit i of XSTATE_BV field of the XSAVE header as 0
(indicating that the state component is in its initialized state).
With the exception of XSAVE, no data is saved for the state
component (XSAVE saves the initial value of the state component..."

Thus, the key point is not losing the non initial AMX state on vmexit
and vmenter. If AMX state is in initialized state, it doesn't matter.
Otherwise, XFD[i] should not be armed with a nonzero value.

If we don't want to extremely set XFD=0 every time on vmexit, it would
be useful to first detect if guest AMX state is initial or not.
How about using XINUSE notation here?
(Details in SDM vol1 13.6 PROCESSOR TRACKING OF
XSAVE-MANAGED STATE, and vol2 XRSTOR/XRSTORS instruction operation part)
The main idea is processor tracks the status of various state components
by XINUSE, and it shows if the state component is in use or not.
When XINUSE[i]=0, state component i is in initial configuration.
Otherwise, kvm should take care of XFD on vmexit.


> However, running the host with _more_ bits set than necessary in XFD 
> should not be a problem as long as the host doesn't use the AMX 
> instructions. 
Does "running the host" mean running in kvm? why need more bits 
(host_XFD|guest_XFD),
I'm trying to think about the case that guest_XFD is not enough? e.g.
In guest, it only need bit i when guest supports it and guest uses
the passthru XFD[i] for detecting dynamic usage;
In kvm, kvm doesn't use AMX instructions; and "system software should not
use XFD to implement a 'lazy restore' approach to management of the 
XTILEDATA
state component."
Out of kvm, kernel ensures setting correct XFD for threads when scheduling;

Thanks,
Jing

> So perhaps Jing can look into keeping XFD=0 for as little time as 
> possible, and XFD=host_XFD|guest_XFD as much as possible.
>
> Paolo
>

