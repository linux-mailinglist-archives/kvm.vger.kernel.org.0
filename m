Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFF544BA0F
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 02:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhKJBso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 20:48:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:24355 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhKJBso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 20:48:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="256262318"
X-IronPort-AV: E=Sophos;i="5.87,222,1631602800"; 
   d="scan'208";a="256262318"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 17:45:57 -0800
X-IronPort-AV: E=Sophos;i="5.87,222,1631602800"; 
   d="scan'208";a="503752418"
Received: from unknown (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 17:45:52 -0800
Message-ID: <82145eab-5b0b-bc26-8f8e-2bd68b9e7b28@intel.com>
Date:   Wed, 10 Nov 2021 09:45:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v2 24/69] KVM: x86: Introduce "protected guest"
 concept and block disallowed ioctls
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     isaku.yamahata@gmail.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <482264f17fa0652faad9bd5364d652d11cb2ecb8.1625186503.git.isaku.yamahata@intel.com>
 <02ca73b2-7f04-813d-5bb7-649c0edafa06@redhat.com>
 <209a57e9-ca9c-3939-4aaa-4602e3dd7cdd@amd.com>
 <6f0d243c-4f40-d608-3309-5c37536ab866@intel.com>
 <3966eaf0-ed8e-c356-97dd-f8c5c3057439@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <3966eaf0-ed8e-c356-97dd-f8c5c3057439@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2021 1:15 AM, Paolo Bonzini wrote:
> On 11/9/21 14:37, Xiaoyao Li wrote:
>>
>> Tom,
>>
>> I think what you did in this commit is not so correct. It just 
>> silently ignores the ioctls insteaf of returning an error to userspace 
>> to tell this IOCTL is not invalid to this VM. E.g., for 
>> kvm_arch_vcpu_ioctl_get_fpu(), QEMU just gets it succesful with fpu 
>> being all zeros.
> 
> Yes, it's a "cop out" that removes the need for more complex changes in 
> QEMU.
> 
> I think for the get/set registers ioctls 
> KVM_GET/SET_{REGS,SREGS,FPU,XSAVE,XCRS} we need to consider SEV-ES 
> backwards compatibility.  This means, at least for now, only apply the 
> restriction to TDX (using a bool-returning function, see the review for 
> 28/69).
> 
> For SMM, MCE, vCPU events and for kvm_valid/dirty_regs, it can be done 
> as in this patch.
> 

thank you Paolo,

I will go with this direction.


