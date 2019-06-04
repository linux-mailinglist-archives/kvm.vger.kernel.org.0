Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E340734E07
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfFDQxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:53:42 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34912 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfFDQxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:53:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so822159wml.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 09:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+kN7XB2dqdcyQLG9cR8YBMKFohsyQdRAKFpsE2wetQ=;
        b=Iavmp+RBKK5KwjoANdk/pE4Yk+an3AiWbNZwf/qNV1uWC2y6faRCN531umotUuHxMy
         NodPih6yKLWB3OFKpBw1uhhmXpiaiy0ix0EQXFw2S4Ox5zpJw9gxpyGq3DTTkjiDY28H
         XzGraOuQx0jMZpT7M6bZXIm0cY/wnBrrUZe5TxNIrbyefzhbs0C12tkU73xEWjjUX5bP
         w3Pd5onscULZsRmPfwN3Meq+cplqA/K/bWNErtR/9g5Jr1TIcHpzjcStRZtEipvJY6Y5
         JHFucTdPssJDzX7wcwYgzDxzsUcG71jNswk95Jon7rn5fkVy2Y2o0z4ytSCoAvn3zZai
         UwzQ==
X-Gm-Message-State: APjAAAW51q8KAczMzsel5ij9xMl+mtAv2lKKOepylL1Vk6AoTRMCdS6e
        1kER1LMNMSXIY9USy713qoayD2gcH+RMvw==
X-Google-Smtp-Source: APXvYqzfVkVEM5YKEFd/k0uosz5QOdtyvXljVg0Vy5pqTtIadiRvfRhGO9VD9x3aqhKqA7A5AhGrVA==
X-Received: by 2002:a1c:44d4:: with SMTP id r203mr16648433wma.158.1559667215692;
        Tue, 04 Jun 2019 09:53:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id v13sm14321603wmj.46.2019.06.04.09.53.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 09:53:35 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: X86: Provide a capability to disable cstate
 msr read intercepts
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
References: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
 <1558418814-6822-2-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <627e4189-3709-1fb2-a9bc-f1a577712fe0@redhat.com>
Date:   Tue, 4 Jun 2019 18:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558418814-6822-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/19 08:06, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Allow guest reads CORE cstate when exposing host CPU power management capabilities 
> to the guest. PKG cstate is restricted to avoid a guest to get the whole package 
> information in multi-tenant scenario.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * use a separate bit for KVM_CAP_X86_DISABLE_EXITS
> 
>  Documentation/virtual/kvm/api.txt | 1 +
>  arch/x86/include/asm/kvm_host.h   | 1 +
>  arch/x86/kvm/vmx/vmx.c            | 6 ++++++
>  arch/x86/kvm/x86.c                | 5 ++++-
>  arch/x86/kvm/x86.h                | 5 +++++
>  include/uapi/linux/kvm.h          | 4 +++-
>  tools/include/uapi/linux/kvm.h    | 4 +++-
>  7 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 33cd92d..91fd86f 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4894,6 +4894,7 @@ Valid bits in args[0] are
>  #define KVM_X86_DISABLE_EXITS_MWAIT            (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
> +#define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
>  
>  Enabling this capability on a VM provides userspace with a way to no
>  longer intercept some instructions for improved latency in some
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d5457c7..1ce8289 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -882,6 +882,7 @@ struct kvm_arch {
>  	bool mwait_in_guest;
>  	bool hlt_in_guest;
>  	bool pause_in_guest;
> +	bool cstate_in_guest;
>  
>  	unsigned long irq_sources_bitmap;
>  	s64 kvmclock_offset;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0861c71..da24f18 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6637,6 +6637,12 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
>  	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
>  	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> +	if (kvm_cstate_in_guest(kvm)) {
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);

I think I have changed my mind on the implementation of this, sorry.

1) We should emulate these MSRs always, otherwise the guest API changes
between different values of KVM_CAP_X86_DISABLE_EXITS which is not
intended.  Also, KVM_CAP_X86_DISABLE_EXITS does not prevent live
migration, so it should be possible to set the MSRs in the host to
change the delta between the host and guest values.

2) If both KVM_X86_DISABLE_EXITS_HLT and KVM_X86_DISABLE_EXITS_MWAIT are
disabled (i.e. exit happens), the MSRs will be purely emulated.
C3/C6/C7 residency will never increase (it will remain the value that is
set by the host).  When the VM executes an hlt vmexit, it should save
the current TSC.  When it comes back, the C1 residency MSR should be
increased by the time that has passed.

3) If KVM_X86_DISABLE_EXITS_HLT is enabled but
KVM_X86_DISABLE_EXITS_MWAIT is disabled (i.e. mait exits happen),
C3/C6/C7 residency will also never increase, but the C1 residency value
should be read using rdmsr from the host, with a delta added from the
host value.

4) If KVM_X86_DISABLE_EXITS_HLT and KVM_X86_DISABLE_EXITS_MWAIT are both
disabled (i.e. mwait exits do not happen), all four residency values
should be read using rdmsr from the host, with a delta added from the
host value.

5) If KVM_X86_DISABLE_EXITS_HLT is disabled and
KVM_X86_DISABLE_EXITS_MWAIT is enabled, the configuration makes no sense
so it's okay not to be very optimized.  In this case, the residency
value should be read as in (4), but hlt vmexits will be accounted as in
(2) so we need to be careful not to double-count the residency during
hlt.  This means doing four rdmsr before the beginning of the hlt vmexit
and four at the end of the hlt vmexit.

Therefore the data structure should be something like

struct kvm_residency_msr {
	u64 value;
	bool delta_from_host;
	bool count_with_host;
}

u64 kvm_residency_read_host(struct kvm_residency_msr *msr)
{
	u64 unscaled_value = rdmsrl(msr->index);
	// apply TSC scaling...
	return ...
}

u64 kvm_residency_read(struct kvm_residency_msr *msr)
{
	return msr->value +
		(msr->delta_from_host ? kvm_residency_read_host(msr) : 0);
}

void kvm_residency_write(struct kvm_residency_msr *msr,
			 u64 value)
{
	msr->value = value -
		(msr->delta_from_host ? kvm_residency_read_host(msr) : 0);
}

// count_with_host is true for C1 iff any of KVM_CAP_DISABLE_EXITS_HLT
// or KVM_CAP_DISABLE_EXITS_MWAIT is set
// count_with_host is true for C3/C6/C7 iff KVM_CAP_DISABLE_EXITS_MWAIT
is set
void kvm_residency_setup(struct kvm_residency_msr *msr, u16 index,
			 bool count_with_host)
{
	/* Preserve value on calls after the first */
	u64 value = msr->index ? kvm_residency_read(msr) : 0;
	msr->delta_from_host = msr->count_with_host = count_with_host;
	msr->index = index;
	kvm_residency_write(msr, value);
}

// The following functions are called from hlt vmexits.

void kvm_residency_start_hlt(struct kvm_residency_msr *msr)
{
	if (msr->count_with_host) {
		WARN_ON(msr->delta_from_host);
		msr->value += kvm_residency_read_host(msr);
		msr->delta_from_host = false;
	}
}

// host_tsc_waited is 0 except for MSR_CORE_C1_RES
void kvm_residency_end_hlt(struct kvm_residency_msr *msr,
			   u64 host_tsc_waited)
{
	if (msr->count_with_host) {
		WARN_ON(!msr->delta_from_host);
		msr->value -= kvm_residency_read_host(msr);
		msr->delta_from_host = true;
	}
	if (host_tsc_waited) {
		// ... apply TSC scaling to host_tsc_waited ...
		msr->value += ...;
	}
}

Thanks,

Paolo
