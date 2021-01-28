Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3294E306FF2
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 08:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhA1Hnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 02:43:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:7515 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhA1Hmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 02:42:35 -0500
IronPort-SDR: lN+enLqQGaB3i+P6jDN8tOEPh8TRgsCXJtw2NZsfJCObFAeDYTqOv+UveUl4goHVDMyXYiMWWn
 XoKlxxPZQ3NA==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="159365697"
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="159365697"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 23:41:52 -0800
IronPort-SDR: il97ZBtLZZ16htD7yIEr/euNmrdjpq+PF6kjIc7GM3AwgtmwrGa81BegQxuBNAf76I9juvwfP3
 /SDgzjOg+YFQ==
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="388649122"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.104]) ([10.239.13.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 23:41:48 -0800
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
 <ec623f67-d7b7-2d9a-1610-4da7702288b1@intel.com>
 <b4d66085-3cf9-afaf-97d0-3df2b5eb4a3c@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0de5aad4-231b-e55b-2f2d-e121954742f9@intel.com>
Date:   Thu, 28 Jan 2021 15:41:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <b4d66085-3cf9-afaf-97d0-3df2b5eb4a3c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/2021 3:25 PM, Paolo Bonzini wrote:
> On 28/01/21 08:17, Xiaoyao Li wrote:
>>>
>>> "Active low" means that the bit is usually 1 and goes to 0 when the 
>>> condition (such as RTM or bus lock) happens.  For almost all those 
>>> DR6 bits the value is in fact always 1, but if they are defined in 
>>> the future it will require no code change.
>>
>> Why not keep use DR6_INIT, or DR6_RESET_VALUE? or any other better name.
>>
>> It's just the default clear value of DR6 that no debug condition is hit.
> 
> I preferred "DR6_ACTIVE_LOW" because the value is used only once or 
> twice to initialize dr6, and many times to invert those bits.  For example:
> 
> vcpu->arch.dr6 &= ~DR_TRAP_BITS;
> vcpu->arch.dr6 |= DR6_ACTIVE_LOW;
> vcpu->arch.dr6 |= payload;
> vcpu->arch.dr6 ^= payload & DR6_ACTIVE_LOW;
> 
> payload = vcpu->arch.dr6;
> payload &= ~DR6_BT;
> payload ^= DR6_ACTIVE_LOW;
> 
> The name conveys that it's not just the initialization value; it's also 
> the XOR mask between the #DB exit qualification (which we also use as 
> the "payload") and DR6.

Fair enough.

