Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C91FC51
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfEOVhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:37:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39330 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEOVhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:37:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id n25so1051179wmk.4
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 14:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VtB0B/id2Xp1gcG03Gd36Gk5m2shffL2VJ/Nsotb9T4=;
        b=rf22SiaQpiOQQ9HySes5hcO1coUmoJaBE1cfUe6MnTSH+ZwAkYtHgLLoUx10RFuPP7
         LblDq0vSYdspMZv2/2cw2gITg4/hctgaWUCQ392y3Rz82OZn3Ta8UG2TcM4mmkjx3eXT
         AA8khpjepfLTPv6pTLfdTVtZrBRFzxdvqm2xSBzy1rtN5eLvGexeNZy3BSm7INOyxxrS
         PCb9J7kwM2xRlWmmQ2h4tLnFtBeXYKqC38uBZlfFEc6wZxN4JhcCxa8LrZfezxAEmih5
         guWxdZ/1n7XwPkAKQRzu7zgnh40ABAiOfrJhxtU7iVPiELjtDIgQUeRXSo7sXemwG0io
         32hg==
X-Gm-Message-State: APjAAAX+PGmDIGT22Zf8g49eyELTAaGAh9NdVnwlAWK1FpaVEWqBXQuF
        h0F7Tk9ema1PuSsVHyGQ/VlX3392WjI=
X-Google-Smtp-Source: APXvYqxFSzLss0XDGr/WJfx7Msj3pVzyu8Ubv8+8+b3P3OdWegwu9q3JHEwGfTIX8y9fJhZ+RHJiuQ==
X-Received: by 2002:a1c:e708:: with SMTP id e8mr14654905wmh.11.1557956235969;
        Wed, 15 May 2019 14:37:15 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
        by smtp.gmail.com with ESMTPSA id f6sm2179003wmh.13.2019.05.15.14.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:37:15 -0700 (PDT)
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b5107c1f-c034-743f-f9a0-fc540a3baeaf@redhat.com>
Date:   Wed, 15 May 2019 23:37:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508160819.19603-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/19 18:08, Sean Christopherson wrote:
> The RDPMC-exiting control is dependent on the existence of the RDPMC
> instruction itself, i.e. is not tied to the "Architectural Performance
> Monitoring" feature.  For all intents and purposes, the control exists
> on all CPUs with VMX support since RDPMC also exists on all VCPUs with
> VMX supported.  Per Intel's SDM:
> 
>   The RDPMC instruction was introduced into the IA-32 Architecture in
>   the Pentium Pro processor and the Pentium processor with MMX technology.
>   The earlier Pentium processors have performance-monitoring counters, but
>   they must be read with the RDMSR instruction.
> 
> Because RDPMC-exiting always exists, KVM requires the control and refuses
> to load if it's not available.  As a result, hiding the PMU from a guest
> breaks nested virtualization if the guest attemts to use KVM.
> 
> While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
> check for RDPMC-exiting follows standard fault vs. VM-Exit prioritization
> for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
> checks, but before the counter referenced in ECX is checked for validity.
> 
> In other words, the original KVM behavior of injecting a #GP was correct,
> and the KVM unit test needs to be adjusted accordingly, e.g. eat the #GP
> when the unit test guest (L3 in this case) executes RDPMC without
> RDPMC-exiting set in the unit test host (L2).
> 
> This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.
> 
> Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU")
> Reported-by: David Hill <hilld@binarystorm.net>
> Cc: Saar Amar <saaramar@microsoft.com>
> Cc: Mihai Carabas <mihai.carabas@oracle.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 25 -------------------------
>  1 file changed, 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 60306f19105d..0db7ded18951 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6866,30 +6866,6 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static bool guest_cpuid_has_pmu(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_cpuid_entry2 *entry;
> -	union cpuid10_eax eax;
> -
> -	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
> -	if (!entry)
> -		return false;
> -
> -	eax.full = entry->eax;
> -	return (eax.split.version_id > 0);
> -}
> -
> -static void nested_vmx_procbased_ctls_update(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	bool pmu_enabled = guest_cpuid_has_pmu(vcpu);
> -
> -	if (pmu_enabled)
> -		vmx->nested.msrs.procbased_ctls_high |= CPU_BASED_RDPMC_EXITING;
> -	else
> -		vmx->nested.msrs.procbased_ctls_high &= ~CPU_BASED_RDPMC_EXITING;
> -}
> -
>  static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6978,7 +6954,6 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  	if (nested_vmx_allowed(vcpu)) {
>  		nested_vmx_cr_fixed1_bits_update(vcpu);
>  		nested_vmx_entry_exit_ctls_update(vcpu);
> -		nested_vmx_procbased_ctls_update(vcpu);
>  	}
>  
>  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> 

Queued, thanks.

Paolo
