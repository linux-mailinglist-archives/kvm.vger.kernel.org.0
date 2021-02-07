Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778F03120A8
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 02:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGBDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 20:03:22 -0500
Received: from mga06.intel.com ([134.134.136.31]:16531 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGBDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Feb 2021 20:03:21 -0500
IronPort-SDR: j4rmBHOzFA5MuRxNDHJi9Vd5iQ4xv1XYnku4fmLTG8ypyR+klsWlAu0HNa5qY14LDFbiZa5M+1
 /iYZtFbO0hSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="243074397"
X-IronPort-AV: E=Sophos;i="5.81,158,1610438400"; 
   d="scan'208";a="243074397"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 17:02:40 -0800
IronPort-SDR: 0QNn1KcbZCAkEbemNVtv8L8towttrsVH2qFeevGaJGC96FXisoZnuZdkN3zWNilx30x4jN4Fin
 QhHDnA84Pmog==
X-IronPort-AV: E=Sophos;i="5.81,158,1610438400"; 
   d="scan'208";a="394527495"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 17:02:38 -0800
Subject: Re: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its
 XSAVES bit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-5-like.xu@linux.intel.com>
 <8321d54b-173b-722b-ddce-df2f9bd7abc4@redhat.com>
 <219d869b-0eeb-9e52-ea99-3444c6ab16a3@intel.com>
 <b73a2945-11b9-38bf-845a-c64e7caa9d2e@intel.com>
 <7698fd6c-94da-e352-193f-e09e002a8961@redhat.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <6f733543-200e-9ddd-240b-1f956a003ed6@intel.com>
Date:   Sun, 7 Feb 2021 09:02:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7698fd6c-94da-e352-193f-e09e002a8961@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/2/5 19:00, Paolo Bonzini wrote:
> On 05/02/21 09:16, Xu, Like wrote:
>> Hi Paolo,
>>
>> I am wondering if it is acceptable for you to
>> review the minor Architecture LBR patch set without XSAVES for v5.12 ?
>>
>> As far as I know, the guest Arch LBR  can still work without XSAVES 
>> support.
>
> I dopn't think it can work.  You could have two guests on the same 
> physical CPU and the MSRs would be corrupted if the guests write to the 
> MSR but they do not enable the LBRs.
>
> Paolo
>
Neither Arch LBR nor the old version of LBR have this corruption issue,
and we will not use XSAVES for at least LBR MSRs in the VMX transaction.

This is because we have reused the LBR save/restore swicth support from the
host perf mechanism in the legacy LBR support, which will save/restore the LBR
MSRs of the vcpu (thread) when the vcpu is sched in/out.

Therefore, if we have two guests on the same physical CPU, the usage of LBR 
MSRs
is isolated, and it's also true when we use LBR to trace the hypervisor on 
the host.
The same thing happens on the platforms which supports Arch LBR.

I propose that we don't support using XSAVES to save/restore Arch LRB *in 
the guest*
(just like the guest Intel PT), but use the traditional RD/WRMSR, which 
still works
like the legacy LBR.

Since we already have legacy LBR support, we can add a small amount of 
effort (just
two more MSRs emulation and related CPUID exposure) to support Arch LBR w/o 
XSAVES.

I estimate that there are many issues we need to address when we supporting 
guests
to use xsaves instructions. As a rational choice, we could enable the basic 
Arch LBR.

Paolo and Sean, what do you think ?

---
thx, likexu
