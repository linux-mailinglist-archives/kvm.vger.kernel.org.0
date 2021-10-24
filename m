Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAAC4388F7
	for <lists+kvm@lfdr.de>; Sun, 24 Oct 2021 14:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJXNCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Oct 2021 09:02:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:8375 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhJXNB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Oct 2021 09:01:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10146"; a="209611243"
X-IronPort-AV: E=Sophos;i="5.87,178,1631602800"; 
   d="scan'208";a="209611243"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2021 05:59:38 -0700
X-IronPort-AV: E=Sophos;i="5.87,178,1631602800"; 
   d="scan'208";a="496400624"
Received: from dluan-mobl2.ccr.corp.intel.com (HELO [10.255.31.184]) ([10.255.31.184])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2021 05:59:33 -0700
Message-ID: <c54ba892-de31-1ebf-25ee-a40a44a15ac1@intel.com>
Date:   Sun, 24 Oct 2021 20:59:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v2 66/69] KVM: TDX: Add "basic" support for building
 and running Trust Domains
Content-Language: en-US
To:     Sagi Shahar <sagis@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Kai Huang <kai.huang@linux.intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>,
        Yuan Yao <yuan.yao@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <75afef2cdfc3166b2ef78ad13e3a4b1c16900578.1625186503.git.isaku.yamahata@intel.com>
 <CAAYXXYyz3S_cc9ohfkUWN4ohrNq5f+h3608CW5twb-n8i=ogBA@mail.gmail.com>
 <CAAhR5DG-__2YfHjMUQ8hPdxJt+kDEbuvToEEcOFPPuF7ktd1Bg@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAAhR5DG-__2YfHjMUQ8hPdxJt+kDEbuvToEEcOFPPuF7ktd1Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/2021 5:44 AM, Sagi Shahar wrote:
>   On Fri, Jul 2, 2021 at 3:06 PM, Isaku Yamahata
> <isaku.yamahata@intel.com> wrote:
>> Subject: [RFC PATCH v2 66/69] KVM: TDX: Add "basic" support for
>> building and running Trust Domains
>>
>>
>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>> +{
>> +       gpa_t gpa = tdvmcall_p1_read(vcpu);
>> +       gpa_t size = tdvmcall_p2_read(vcpu);
>> +
>> +       if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
>> +           (gpa + size) < gpa ||
>> +           (gpa + size) > vcpu->kvm->arch.gfn_shared_mask << (PAGE_SHIFT + 1))
>> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
>> +       else
>> +               tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
>> +
>> +       return 1;
>> +}
> 
> This function looks like a no op in case of success. Is this
> intentional? Is this mapping handled somewhere else later on?
> 

Yes, it's intentional.

The mapping will be exactly set up in EPT violation handler when the GPA 
is really accessed.
