Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650F03CD5A2
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhGSMge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 08:36:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:6137 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237272AbhGSMge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 08:36:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10049"; a="232825154"
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="232825154"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 06:17:13 -0700
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="499913514"
Received: from zengguan-mobl.ccr.corp.intel.com (HELO [10.254.211.183]) ([10.254.211.183])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 06:17:08 -0700
Subject: Re: [PATCH 6/6] KVM: VMX: enable IPI virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-7-guang.zeng@intel.com>
 <8aed2541-082d-d115-09ac-e7fcc05f96dc@redhat.com>
 <89f240cb-cb3a-c362-7ded-ee500cc12dc3@intel.com>
 <0d6f7852-95b3-d628-955b-f44d88a86478@redhat.com>
From:   Zeng Guang <guang.zeng@intel.com>
Message-ID: <026dffc0-032c-72a9-dd06-a46a3efe2add@intel.com>
Date:   Mon, 19 Jul 2021 21:16:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0d6f7852-95b3-d628-955b-f44d88a86478@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/19/2021 4:32 AM, Paolo Bonzini wrote:
> On 17/07/21 05:55, Zeng Guang wrote:
>>>> +    if (vmx->ipiv_active)
>>>> +        install_pid(vmx);
>>> This should be if (enable_ipiv) instead, I think.
>>>
>>> In fact, in all other places that are using vmx->ipiv_active, you can
>>> actually replace it with enable_ipiv; they are all reached only with
>>> kvm_vcpu_apicv_active(vcpu) == true.
>>>
>> enable_ipiv as a global variable indicates the hardware capability to
>> enable IPIv. Each VM may have different IPIv configuration according to
>> kvm_vcpu_apicv_active status. So we use ipiv_active per VM to enclose
>> IPIv related operations.
> Understood, but in practice all uses of vmx->ipiv_active are guarded by
> kvm_vcpu_apicv_active so they are always reached with vmx->ipiv_active
> == enable_ipiv.
>
> The one above instead seems wrong and should just use enable_ipiv.
enable_ipiv associate with "IPI virtualization" setting in tertiary exec 
controls and
enable_apicv which depends on cpu_has_vmx_apicv(). kvm_vcpu_apicv_active 
still
can be false even if enable_ipiv is true, e.g. in case irqchip not 
emulated in kernel.

Though it's ok to use enable_ipiv here, vmcs setup succeed for IPIv but 
it won't take into effect as
false kvm_vcpu_apicv_active runtime disable “IPI virtualization" for VM 
in this case and
leads vmx->ipiv_active become false as well. So vmx->ipiv_active is more 
accurate to reflect
runtime IPIv status.
> Paolo
>
