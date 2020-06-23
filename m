Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6B204660
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgFWA4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:56:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25753 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732414AbgFWA4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 20:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592873758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAaL/TiInavJGT4pUlGXjgnr3M46tWTz3b0cjG9HI10=;
        b=gT3CJq3oZ6ObSrtFJA8I/fyYEa6ui+curV03qZTYJ99VtASabZQ5cW0Z9FeA86pXkBl7WE
        9nwkJ9pb+NYWcNK07jS83ydrGkQQGCnjjUNk8tYTF/r+xLasoaqVsZAz6mg6qpCQRinTQy
        DJsWWMmLrClwd9JDKnXqE882Nj3RqFg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-hHH3OCACNlyao_zXxy-R0A-1; Mon, 22 Jun 2020 20:55:56 -0400
X-MC-Unique: hHH3OCACNlyao_zXxy-R0A-1
Received: by mail-wr1-f69.google.com with SMTP id a4so12808839wrp.5
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 17:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAaL/TiInavJGT4pUlGXjgnr3M46tWTz3b0cjG9HI10=;
        b=jn/6FQDcRobmMeBV5xWKoDVRH2q8pszHAXKwdzotXua4Ar1Oy1h8C2SA9AlqUmW8X5
         FkpExgyorWHs7Xe5mvpAe3OUkj0KncRRvJC8btGNriXCxlrs2+hvNzDd2cLX3dL9ltU+
         bJ+d9+w90Aq95Dh6y8AjnJclB6lSSW8j/RAijUfTVQTvVT62vdQjnA4ag6BsS3NSbbiV
         CU3LTtiDpaTdUVUi0hW/VSZFZgvTQaBqvEYQCLbdhv90WqW5/4chpwbRn8LgaVr+d0/b
         xF1tuLJk/IdoO7c8DaarZfPZrFWfMkwULOl1RR4syy9NF3podwuPtLTNWi2vVR/r2JuB
         KCTQ==
X-Gm-Message-State: AOAM533WZR5gJ4rvVJP3pbYcSAmnrQBx/E+kQKi/tnUwl21zJth31t98
        ttvbu7MxAVUSpkFnSPURXqtw0FYUQzxUfNuhKGBGJ6YGAJ9GTrLhoFD84OQJOv0zZYBAXaJ6/at
        rfciEN4Nxd9zG
X-Received: by 2002:a1c:f616:: with SMTP id w22mr13688357wmc.155.1592873755258;
        Mon, 22 Jun 2020 17:55:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKKPZc3cey+KTGv80vrG9XaELyLC4ycXlTGGgKNLxMKJ0jRill91HRzNfzQTJIDGNiML7rjA==
X-Received: by 2002:a1c:f616:: with SMTP id w22mr13688338wmc.155.1592873754989;
        Mon, 22 Jun 2020 17:55:54 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id z9sm1381143wmi.41.2020.06.22.17.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:55:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>,
        Tao Xu <tao3.xu@intel.com>
References: <20200623005135.10414-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <13d73fe4-5591-fd66-d46a-c09936205381@redhat.com>
Date:   Tue, 23 Jun 2020 02:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200623005135.10414-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 02:51, Sean Christopherson wrote:
> Remove support for context switching between the guest's and host's
> desired UMWAIT_CONTROL.  Propagating the guest's value to hardware isn't
> required for correct functionality, e.g. KVM intercepts reads and writes
> to the MSR, and the latency effects of the settings controlled by the
> MSR are not architecturally visible.
> 
> As a general rule, KVM should not allow the guest to control power
> management settings unless explicitly enabled by userspace, e.g. see
> KVM_CAP_X86_DISABLE_EXITS.  E.g. Intel's SDM explicitly states that C0.2
> can improve the performance of SMT siblings.  A devious guest could
> disable C0.2 so as to improve the performance of their workloads at the
> detriment to workloads running in the host or on other VMs.
> 
> Wholesale removal of UMWAIT_CONTROL context switching also fixes a race
> condition where updates from the host may cause KVM to enter the guest
> with the incorrect value.  Because updates are are propagated to all
> CPUs via IPI (SMP function callback), the value in hardware may be
> stale with respect to the cached value and KVM could enter the guest
> with the wrong value in hardware.  As above, the guest can't observe the
> bad value, but it's a weird and confusing wart in the implementation.
> 
> Removal also fixes the unnecessary usage of VMX's atomic load/store MSR
> lists.  Using the lists is only necessary for MSRs that are required for
> correct functionality immediately upon VM-Enter/VM-Exit, e.g. EFER on
> old hardware, or for MSRs that need to-the-uop precision, e.g. perf
> related MSRs.  For UMWAIT_CONTROL, the effects are only visible in the
> kernel via TPAUSE/delay(), and KVM doesn't do any form of delay in
> vcpu_vmx_run().  Using the atomic lists is undesirable as they are more
> expensive than direct RDMSR/WRMSR.
> 
> Furthermore, even if giving the guest control of the MSR is legitimate,
> e.g. in pass-through scenarios, it's not clear that the benefits would
> outweigh the overhead.  E.g. saving and restoring an MSR across a VMX
> roundtrip costs ~250 cycles, and if the guest diverged from the host
> that cost would be paid on every run of the guest.  In other words, if
> there is a legitimate use case then it should be enabled by a new
> per-VM capability.
> 
> Note, KVM still needs to emulate MSR_IA32_UMWAIT_CONTROL so that it can
> correctly expose other WAITPKG features to the guest, e.g. TPAUSE,
> UMWAIT and UMONITOR.
> 
> Fixes: 6e3ba4abcea56 ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
> Cc: stable@vger.kernel.org
> Cc: Jingqi Liu <jingqi.liu@intel.com>
> Cc: Tao Xu <tao3.xu@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/mwait.h |  2 --
>  arch/x86/kernel/cpu/umwait.c |  6 ------
>  arch/x86/kvm/vmx/vmx.c       | 18 ------------------
>  3 files changed, 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 73d997aa2966..e039a933aca3 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -25,8 +25,6 @@
>  #define TPAUSE_C01_STATE		1
>  #define TPAUSE_C02_STATE		0
>  
> -u32 get_umwait_control_msr(void);
> -
>  static inline void __monitor(const void *eax, unsigned long ecx,
>  			     unsigned long edx)
>  {
> diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
> index 300e3fd5ade3..ec8064c0ae03 100644
> --- a/arch/x86/kernel/cpu/umwait.c
> +++ b/arch/x86/kernel/cpu/umwait.c
> @@ -18,12 +18,6 @@
>   */
>  static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
>  
> -u32 get_umwait_control_msr(void)
> -{
> -	return umwait_control_cached;
> -}
> -EXPORT_SYMBOL_GPL(get_umwait_control_msr);
> -
>  /*
>   * Cache the original IA32_UMWAIT_CONTROL MSR value which is configured by
>   * hardware or BIOS before kernel boot.
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 08e26a9518c2..b2447c1ee362 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6606,23 +6606,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  					msrs[i].host, false);
>  }
>  
> -static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
> -{
> -	u32 host_umwait_control;
> -
> -	if (!vmx_has_waitpkg(vmx))
> -		return;
> -
> -	host_umwait_control = get_umwait_control_msr();
> -
> -	if (vmx->msr_ia32_umwait_control != host_umwait_control)
> -		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
> -			vmx->msr_ia32_umwait_control,
> -			host_umwait_control, false);
> -	else
> -		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
> -}
> -
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -6730,7 +6713,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	if (vcpu_to_pmu(vcpu)->version)
>  		atomic_switch_perf_msrs(vmx);
> -	atomic_switch_umwait_control_msr(vmx);
>  
>  	if (enable_preemption_timer)
>  		vmx_update_hv_timer(vcpu);
> 

Queued, thanks.

Paolo

