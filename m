Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37D306EE6
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 08:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhA1HUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 02:20:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:63854 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231728AbhA1HSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 02:18:07 -0500
IronPort-SDR: gPUDcP/O++Kn2cWMJ635aCkrEOCGMw5k/Juevv5MftelAhqX2SyZ6R4jBTd1+OfRcg5pGQn/Zs
 v61CuN7Rt0Pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="180334930"
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="180334930"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 23:17:23 -0800
IronPort-SDR: 4i/tuonmMO40i7wG9qqRNh9cAXsGwZDWS1ZyYcvhWgyMbtD4INBo7DAZwRXD2YJEBhpd0bafnE
 TH5EUorHw9+A==
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="388640946"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.104]) ([10.239.13.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 23:17:21 -0800
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
 <5f3089a2-5a5c-a839-9ed9-471c404738a3@intel.com>
 <6bf8fc0d-ad7d-0282-9dcc-695f16af0715@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <ec623f67-d7b7-2d9a-1610-4da7702288b1@intel.com>
Date:   Thu, 28 Jan 2021 15:17:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6bf8fc0d-ad7d-0282-9dcc-695f16af0715@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/2021 6:04 PM, Paolo Bonzini wrote:
> On 27/01/21 04:41, Xiaoyao Li wrote:
>> On 1/27/2021 12:31 AM, Paolo Bonzini wrote:
>>> On 08/01/21 07:49, Chenyi Qiang wrote:
>>>> To avoid breaking the CPUs without bus lock detection, activate the
>>>> DR6_BUS_LOCK bit (bit 11) conditionally in DR6_FIXED_1 bits.
>>>>
>>>> The set/clear of DR6_BUS_LOCK is similar to the DR6_RTM in DR6
>>>> register. The processor clears DR6_BUS_LOCK when bus lock debug
>>>> exception is generated. (For all other #DB the processor sets this bit
>>>> to 1.) Software #DB handler should set this bit before returning to the
>>>> interrupted task.
>>>>
>>>> For VM exit caused by debug exception, bit 11 of the exit qualification
>>>> is set to indicate that a bus lock debug exception condition was
>>>> detected. The VMM should emulate the exception by clearing bit 11 of 
>>>> the
>>>> guest DR6.
>>>
>>> Please rename DR6_INIT to DR6_ACTIVE_LOW, and then a lot of changes 
>>> become simpler:
>>
>> Paolo,
>>
>> What do you want to convey with the new name DR6_ACTIVE_LOW? To be 
>> honest, the new name is confusing to me.
> 
> "Active low" means that the bit is usually 1 and goes to 0 when the 
> condition (such as RTM or bus lock) happens.  For almost all those DR6 
> bits the value is in fact always 1, but if they are defined in the 
> future it will require no code change.

Why not keep use DR6_INIT, or DR6_RESET_VALUE? or any other better name.

It's just the default clear value of DR6 that no debug condition is hit.

> Paolo
> 
>>>> -        dr6 |= DR6_BD | DR6_RTM;
>>>> +        dr6 |= DR6_BD | DR6_RTM | DR6_BUS_LOCK;
>>>
>>> dr6 |= DR6_BD | DR6_ACTIVE_LOW;
>>>
>>
>>
> 

