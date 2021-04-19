Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1282364098
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 13:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhDSLdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 07:33:06 -0400
Received: from mga12.intel.com ([192.55.52.136]:6102 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhDSLdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 07:33:05 -0400
IronPort-SDR: YbmF5Gd1digfDYP8vxklHNb4ndCUIPlI72zNh9nhnuSzu42Zg9iMf4w1qrWYIha16n5S4D9qFj
 VcJ2L5W/Qq/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174798621"
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="174798621"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 04:32:29 -0700
IronPort-SDR: SxlERyW6wwLteodLNuqR0qSiCcGDyl4OveuD9/VOlwvMWExEwcI3sV5YIZTgUhBeoz7qcmfz03
 SivOd1e5ObmA==
X-IronPort-AV: E=Sophos;i="5.82,234,1613462400"; 
   d="scan'208";a="426476438"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.254.213.121]) ([10.254.213.121])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 04:32:25 -0700
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
To:     Sean Christopherson <seanjc@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <fbbc8a7f-a143-9c6a-907f-19e0280842de@intel.com>
Date:   Mon, 19 Apr 2021 19:32:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHnJtvXdrZE+AfM3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/2021 1:30 AM, Sean Christopherson wrote:
> On Fri, Apr 16, 2021, Kirill A. Shutemov wrote:
[...]
>> index fadaccb95a4c..cd2374802702 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -436,6 +436,8 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>   }
>>   #endif
>>   
>> +#define KVM_NR_SHARED_RANGES 32
>> +
>>   /*
>>    * Note:
>>    * memslots are not sorted by id anymore, please use id_to_memslot()
>> @@ -513,6 +515,10 @@ struct kvm {
>>   	pid_t userspace_pid;
>>   	unsigned int max_halt_poll_ns;
>>   	u32 dirty_ring_size;
>> +	bool mem_protected;
>> +	void *id;
>> +	int nr_shared_ranges;
>> +	struct range shared_ranges[KVM_NR_SHARED_RANGES];
> 
> Hard no for me.  IMO, anything that requires KVM to track shared/pinned pages in
> a separate tree/array is non-starter.  More specific to TDX #MCs, KVM should not
> be the canonical reference for the state of a page.
> 

Do you mean something in struct page to track if the page is shared or 
private?
