Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E742A3050C4
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbhA0E00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:26:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:32835 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231770AbhA0DBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 22:01:09 -0500
IronPort-SDR: HLqF/EHNpJxUu54CHhMbpCN4nRBW3RF0rjOvOhQ2Cx+Fl08B+LnKjkxO0u6ivZJzUhjDR+87op
 tMtokHaamNtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241537305"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="241537305"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:00:13 -0800
IronPort-SDR: OITLmqZjyxGW3O0pqbKS97pjZeqixSZg3Fvao4C507ABS0Vuho2kUInNmOWHzVSsX9VRlcKtEE
 EUDPRXFOAvDQ==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388122985"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.1.32]) ([10.238.1.32])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:00:09 -0800
Subject: Re: [RFC 5/7] KVM: MMU: Add support for PKS emulation
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-6-chenyi.qiang@intel.com>
 <0689bda9-e91a-2b06-3dd6-f78572879296@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <3e38051e-b341-66b9-5e2e-2c3f26d3ff70@intel.com>
Date:   Wed, 27 Jan 2021 11:00:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <0689bda9-e91a-2b06-3dd6-f78572879296@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/2021 2:23 AM, Paolo Bonzini wrote:
> On 07/08/20 10:48, Chenyi Qiang wrote:
>>
>>          if (pte_access & PT_USER_MASK)
>>              pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
>> +        else if (!kvm_get_msr(vcpu, MSR_IA32_PKRS, &pkrs))
>> +            pkr_bits = (pkrs >> (pte_pkey * 2)) & 3;
> 
> You should be able to always use vcpu->arch.pkrs here.  So
> 
> pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : vcpu->arch.pkrs;
> pkr_bits = (pkr >> pte_pkey * 2) & 3;
> 
> Paolo

Concerning vcpu->arch.pkrs would be the only use case in current 
submitted patches, is it still necessary to shadow it?

> 
