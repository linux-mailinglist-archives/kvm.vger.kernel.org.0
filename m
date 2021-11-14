Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180FE44F658
	for <lists+kvm@lfdr.de>; Sun, 14 Nov 2021 04:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhKNDqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Nov 2021 22:46:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:22361 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhKNDqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Nov 2021 22:46:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10167"; a="220186334"
X-IronPort-AV: E=Sophos;i="5.87,233,1631602800"; 
   d="scan'208";a="220186334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2021 19:43:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,233,1631602800"; 
   d="scan'208";a="505432270"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.28.38]) ([10.255.28.38])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2021 19:43:08 -0800
Message-ID: <33598dac-d91c-c9b8-4f70-b3a0f9f20c23@intel.com>
Date:   Sun, 14 Nov 2021 11:43:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH 10/11] KVM: Disallow read-only memory for x86 TDX
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-11-xiaoyao.li@intel.com>
 <YY6b4n8xPaKspoNI@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YY6b4n8xPaKspoNI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/2021 12:52 AM, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Xiaoyao Li wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDX doesn't expose permission bits to the VMM in the SEPT tables, i.e.,
>> doesn't support read-only private memory.
>>
>> Introduce kvm_arch_support_readonly_mem(), which returns true except for
>> x86. x86 has its own implementation based on vm_type that returns faluse
>> for TDX VM.
>>
>> Propagate it to KVM_CAP_READONLY_MEM to allow reporting on a per-VM
>> basis.
> 
> Assuming KVM gains support for private memslots (or memslots that _may_ be mapped
> private), this is incorrect, the restriction on read-only memory only applies to
> private memory.  Userspace should still be allowed to create read-only shared memory.
> Ditto for dirty-logging in the next patch.

Yes. I had the same concern before sending it out. :)
But I forgot to mention it.

> When this patch was originally created, it was "correct" because there was no
> (proposed) concept of a private memslot or of a memslot that can be mapped private.
> 
> So these two patches at least need to wait until KVM has a defind ABI for managing
> guest private memory.
> 

I'll drop the two patches for next submission.
