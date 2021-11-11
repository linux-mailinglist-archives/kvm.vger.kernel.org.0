Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8041644D067
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 04:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhKKDbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 22:31:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:31079 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhKKDbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 22:31:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="296279809"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="296279809"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:28:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="504253909"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:28:07 -0800
Message-ID: <5689dc7e-b0e0-1733-f00f-66dc7b62b960@intel.com>
Date:   Thu, 11 Nov 2021 11:28:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v2 22/69] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <8eb87cd52a89d957af03f93a9ece5634426a7757.1625186503.git.isaku.yamahata@intel.com>
 <e2270f66-abd8-db17-c3bd-b6d9459624ec@redhat.com>
 <YO356ni0SjPsLsSo@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YO356ni0SjPsLsSo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/14/2021 4:39 AM, Sean Christopherson wrote:
> On Tue, Jul 06, 2021, Paolo Bonzini wrote:
>> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
>>>    struct kvm_arch {
>>> +	unsigned long vm_type;
>>
>> Also why not just int or u8?
> 
> Heh, because kvm_dev_ioctl_create_vm() takes an "unsigned long" for the type and
> it felt wrong to store it as something else.  Storing it as a smaller field should
> be fine, I highly doubt we'll get to 256 types anytime soon :-)

It's the bit position. We can get only 8 types with u8 actually.

> 
> I think kvm_x86_ops.is_vm_type_supported() should take the full size though.
> 

