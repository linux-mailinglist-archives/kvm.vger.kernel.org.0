Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15F449CFF
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbhKHUVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 15:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhKHUVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 15:21:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95F7C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 12:18:19 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u17so16589720plg.9
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xCgR6XpMFGzRoI0Wnu3fKwXAyVZwxWNevueJr3lWUtw=;
        b=JkyIF6H/P0UBvTblaseELgJ/mEfzoVsJi5EuVmqL9z/uPaCgzFdzlVn04aIIarLdMB
         dT+p38sIfEGmuAHdtQXL0IhDiOgoM4C+uQZW0nX/q/ZLQfzDdJnemRdl8ZYjpnKTwvjs
         X/6pBhZtACLkEIqVCaZJe3MzfoHnMfUAzNhn3WbsXopIWa/3eRRXBMjxJkznsE2KG47q
         uUtjqNbXwMrZFPK23COHy+Hi/MjcsfHSwGMCJq1pLq2nCYsY3KJwHLIsIlsPVzJY82u+
         7dpwnmrugYKfypXT5eQszwUimKHB9GWY/SpugXs8GaBCUMW31W5sHro4FpViAOPKFGRX
         RPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xCgR6XpMFGzRoI0Wnu3fKwXAyVZwxWNevueJr3lWUtw=;
        b=VueTbQGcuy4scVaN1xKtOA0u6rNrpz34YaA1OejJxljEYmOuBtRU0RGC3EWjGMqySS
         BHYQs+WbEAihhHsNMjL/b5dOQjjym53X6LYxb2cJ93hQaEdIE+L5sQVvrwSxo2/q1mFe
         4rJ5/uT7sijTIzPBGMCT/9QiSlDU90w3la66S6kUf4ykBPsXmtJBS9Nd9boEWA5qfhps
         Kp5K0sf7zgl6m1SASDuY5DhHZfiH+xnuUnhQvyJmaIVl7mQDpuF+a96qjBZx1CJhFiy0
         QRgXhzT3hk/vVMu2Rj3rrXDRHaHjfU5RM2L+2w4cr9WNpNNTWdq4n74H1/IXBtKf0Ea9
         ejjw==
X-Gm-Message-State: AOAM532L0wks2T0vyJftdAJTSN6zzQBdY8wpwqLuXIucYWu7+lh/+V0q
        D4Ss/2FDXtyJil3vOY7BZE2gRA==
X-Google-Smtp-Source: ABdhPJwS3sd0RzShnCkpRHeNSJ1M3JAoBaf96UrTrNhJsQ6fO/l5Ula8VYQ9uXZtkx/5pWkwHIdAWg==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr1021782pjb.199.1636402699095;
        Mon, 08 Nov 2021 12:18:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm1sm194903pjb.3.2021.11.08.12.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 12:18:18 -0800 (PST)
Date:   Mon, 8 Nov 2021 20:18:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Message-ID: <YYmGBhIbzgz+dyqp@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-4-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811101126.8973-4-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Chenyi Qiang wrote:
> @@ -7207,6 +7257,19 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>  	vmx_update_exception_bitmap(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {

Ah, this confused me for a second.  It's not wrong to clear the entry/exit controls
in the "else" path, but it's surprisingly hard to follow because it reads as if the
entry/exit controls are paired with the MSR behavior.

Oh, and more importantly, it's "hiding" a bug: the MSR bitmap needs to be _set_
if userspace disables X86_FEATURE_PKS in guest CPUID, e.g. if for some reason
userspace exposed PKS and then yanked it away.

Oof, two bugs actually.  This will fail to re-enable the entry/exit bits if
userspace hides PKS and then re-enables PKS.

Heh, make that three bugs.  If userspace never sets CPUID, KVM will run with
the entry/exit bits set.  That's arguably not a bug since functionally it's fine,
but it's a bug in the sense that KVM loads an MSR when it doesn't inted to do so.

So this should be:

	if (kvm_vcpu_cap_has(X86_FEATURE_PKS) {
		if (guest_cpuid_has(vcpu, X86_FEATURE_PKS)) {
			vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);

			vm_entry_controls_setbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
			vm_exit_controls_setbit(vmx, VM_EXIT_LOAD_IA32_PKRS)

		} else {
			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);

			vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
			vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS)
		}
	}

and then the bits need to be masked in vmx_vmexit_ctrl() and vmx_vmentry_ctrl(),
a la EFER and PERF_GLOBAL_CTRL.

> +		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PKRS, MSR_TYPE_RW);
> +	} else {
> +		/*
> +		 * Remove VM control in case guest VM doesn't support PKS to mitigate
> +		 * overhead during VM-{exit,entry}. They are present by default
> +		 * if supported.
> +		 */
> +		vm_entry_controls_clearbit(vmx, VM_ENTRY_LOAD_IA32_PKRS);
> +		vm_exit_controls_clearbit(vmx, VM_EXIT_LOAD_IA32_PKRS);
> +	}
>  }
