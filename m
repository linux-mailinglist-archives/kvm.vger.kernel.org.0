Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CA93052E9
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 07:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhA0GB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 01:01:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:55827 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234838AbhA0DOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 22:14:47 -0500
IronPort-SDR: l/qT0CVbFlFlXb59AMQTPfgamfsoO0YpRyUFwbPls1Y/czUG9YCe5S8R5tFgl45E/4GXMLpRp4
 GdxwVAkBvWbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180154600"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="180154600"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:14:05 -0800
IronPort-SDR: nBXMqG4mKqCgtT7YN641IjBw0KdW3UoTl5gYpbThMYS+sw6Ybj9V/DHgBvPQEpsmAVK7vfznHx
 sfuTSvFwl8tA==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388126129"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:14:02 -0800
Subject: Re: [RFC 4/7] KVM: MMU: Refactor pkr_mask to cache condition
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-5-chenyi.qiang@intel.com>
 <f4e5dd40-f721-049f-de0f-3af59d48a003@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <9eeb5ebc-d9e8-a6b7-d659-7ab05ebfcb6f@intel.com>
Date:   Wed, 27 Jan 2021 11:14:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <f4e5dd40-f721-049f-de0f-3af59d48a003@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/2021 2:16 AM, Paolo Bonzini wrote:
> On 07/08/20 10:48, Chenyi Qiang wrote:
>>
>>          * index of the protection domain, so pte_pkey * 2 is
>>          * is the index of the first bit for the domain.
>>          */
>> -        pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>> +        if (pte_access & PT_USER_MASK)
>> +            pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>> +        else
>> +            pkr_bits = 0;
>>
>> -        /* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
>> -        offset = (pfec & ~1) +
>> -            ((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - 
>> PT_USER_SHIFT));
>> +        /* clear present bit */
>> +        offset = (pfec & ~1);
>>
>>          pkr_bits &= mmu->pkr_mask >> offset;
>>          errcode |= -pkr_bits & PFERR_PK_MASK;
> 
> I think this is incorrect.  mmu->pkr_mask must cover both clear and set 
> ACC_USER_MASK, in to cover all combinations of CR4.PKE and CR4.PKS. 
> Right now, check_pkey is !ff && pte_user, but you need to make it 
> something like
> 
>      check_pkey = !ff && (pte_user ? cr4_pke : cr4_pks);
> 
> Paolo

Oh, I didn't distinguish the cr4_pke/cr4_pks check. Will fix this issue.

> 
