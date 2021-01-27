Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E648B3052EA
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 07:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhA0GCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 01:02:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:41740 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236787AbhA0DmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 22:42:10 -0500
IronPort-SDR: 06L6+8c5jo1mTPH/ZMq44UL2ygYRXej0cpXeeuOLa3K9dlZ3uo8wcnYGI5O/DtRP3MnEB8FFQR
 DrATW+y0kaQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="167683851"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="167683851"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:41:26 -0800
IronPort-SDR: MmQkc7n0mNTk2dJzE9NQiwP2KYB1eRqLlklGEtJ9eIny+oH9VtAcDAoPQPqhrVH7Fac5lo4o41
 U0ixskdqvTeA==
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="388133735"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.104]) ([10.239.13.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 19:41:24 -0800
Subject: Re: [RESEND PATCH 1/2] KVM: X86: Add support for the emulation of
 DR6_BUS_LOCK bit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108064924.1677-1-chenyi.qiang@intel.com>
 <20210108064924.1677-2-chenyi.qiang@intel.com>
 <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <5f3089a2-5a5c-a839-9ed9-471c404738a3@intel.com>
Date:   Wed, 27 Jan 2021 11:41:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <fc29c63f-7820-078a-7d92-4a7adf828067@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/2021 12:31 AM, Paolo Bonzini wrote:
> On 08/01/21 07:49, Chenyi Qiang wrote:
>> To avoid breaking the CPUs without bus lock detection, activate the
>> DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.
>>
>> The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
>> register. The processor clears DR6_BUS_LOCK when bus lock debug
>> exception is generated. (For all other #DB the processor sets this bit
>> to 1.) Software #DB handler should set this bit before returning to the
>> interrupted task.
>>
>> For VM exit caused by debug exception, bit 11 of the exit qualification
>> is set to indicate that a bus lock debug exception condition was
>> detected. The VMM should emulate the exception by clearing bit 11 of the
>> guest DR6.
> 
> Please rename DR6_INIT to DR6_ACTIVE_LOW, and then a lot of changes 
> become simpler:

Paolo,

What do you want to convey with the new name DR6_ACTIVE_LOW? To be 
honest, the new name is confusing to me.

>> -        dr6 |= DR6_BD | DR6_RTM;
>> +        dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;
> 
> dr6 |= DR6_BD | DR6_ACTIVE_LOW;
> 


