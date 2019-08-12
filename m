Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12E8A8EF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfHLVFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:05:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:6089 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfHLVFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:05:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 14:05:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,378,1559545200"; 
   d="scan'208";a="327476751"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 12 Aug 2019 14:05:01 -0700
Date:   Mon, 12 Aug 2019 14:05:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Message-ID: <20190812210501.GD1437@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-56-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809160047.8319-56-alazar@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 07:00:10PM +0300, Adalbert Lazăr wrote:
> From: Mihai Donțu <mdontu@bitdefender.com>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 22f08f2732cc..91cd43a7a7bf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1013,6 +1013,8 @@ struct kvm_x86_ops {
>  	bool (*has_emulated_msr)(int index);
>  	void (*cpuid_update)(struct kvm_vcpu *vcpu);
>  
> +	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
> +				bool enable);

This should be toggle_wrmsr_intercept(), or toggle_msr_intercept() with
a paramter to control RDMSR vs. WRMSR.

>  	void (*cr3_write_exiting)(struct kvm_vcpu *vcpu, bool enable);
>  	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
>  	bool (*spt_fault)(struct kvm_vcpu *vcpu);
> @@ -1621,6 +1623,8 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>  #define put_smstate(type, buf, offset, val)                      \
>  	*(type *)((buf) + (offset) - 0x7e00) = val
>  
> +void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
> +				bool enable);
>  bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
>  bool kvm_spt_fault(struct kvm_vcpu *vcpu);
>  void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable);
> diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
> index 83a098dc8939..8285d1eb0db6 100644

...

> diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
> index b3cab0db6a70..5dba4f87afef 100644
> --- a/arch/x86/kvm/kvmi.c
> +++ b/arch/x86/kvm/kvmi.c
> @@ -9,6 +9,133 @@
>  #include <asm/vmx.h>
>  #include "../../../virt/kvm/kvmi_int.h"
>  
> +static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr)
> +{
> +	switch (*msr) {
> +	case 0 ... 0x1fff:
> +		return IVCPU(vcpu)->msr_mask.low;
> +	case 0xc0000000 ... 0xc0001fff:
> +		*msr &= 0x1fff;
> +		return IVCPU(vcpu)->msr_mask.high;
> +	}
> +
> +	return NULL;
> +}

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6450c8c44771..0306c7ef3158 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7784,6 +7784,15 @@ static __exit void hardware_unsetup(void)
>  	free_kvm_area();
>  }
>  
> +static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
> +			      bool enable)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +
> +	vmx_set_intercept_for_msr(msr_bitmap, msr, MSR_TYPE_W, enable);
> +}

Unless I overlooked a check, this will allow userspace to disable WRMSR
interception for any MSR in the above range, i.e. userspace can use KVM
to gain full write access to pretty much all the interesting MSRs.  This
needs to only disable interception if KVM had interception disabled before
introspection started modifying state.
