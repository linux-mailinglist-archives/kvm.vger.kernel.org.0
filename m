Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84303DE8F1
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhHCIxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:53:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:56607 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234418AbhHCIxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 04:53:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="210524224"
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="210524224"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 01:52:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,291,1620716400"; 
   d="scan'208";a="510951911"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.0.162]) ([10.238.0.162])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 01:52:54 -0700
Subject: Re: [PATCH v4 4/5] KVM: MMU: Add support for PKS emulation
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-5-chenyi.qiang@intel.com> <YQLkczVfCsFp4IxW@google.com>
 <fd1b39b1-ce99-3626-b502-eb1324001163@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <9f1edbcb-cba3-015f-bec5-8f9873245d09@intel.com>
Date:   Tue, 3 Aug 2021 16:52:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fd1b39b1-ce99-3626-b502-eb1324001163@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/30/2021 1:45 AM, Paolo Bonzini wrote:
> On 29/07/21 19:25, Sean Christopherson wrote:
>>> -        unsigned int cr4_pke:1;
>>> +        unsigned int cr4_pkr:1;
>> Smushing these together will not work, as this code (from below)
>>
>>> -     ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
>>> +     ext.cr4_pkr = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
>>> +                   !!kvm_read_cr4_bits(vcpu, X86_CR4_PKS);
>> will generate the same mmu_role for CR4.PKE=0,PKS=1 and 
>> CR4.PKE=1,PKS=1 (and
>> other combinations).  I.e. KVM will fail to reconfigure the MMU and 
>> thus skip
>> update_pkr_bitmask() if the guest toggles PKE or PKS while the other 
>> PK* bit is set.
>>
> 
> I'm also not sure why there would be issues in just using cr4_pks.
> 

Will split out the pke and pks.

Thanks
Chenyi

> Paolo
> 
