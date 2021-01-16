Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081792F89DD
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 01:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbhAPARa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 19:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbhAPAR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 19:17:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5184DC061794
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:16:49 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so1242693plg.13
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6yXtcuFIc7dVGNx7ADF/6iAn0EJcDM4Yx9eIq/yQWuE=;
        b=SccGeFKqKYJn6JGRmH/QcNJG9V7LUY+7YiLZyoDBARjMEytCqxFkYJhwJR3fj9ZrdY
         JBP/7CLS57/yGmRuYLOYczMhfd/OTNsISQKhkCmLoV7yNK0QW1xzqzOhOYk/q09GLkl8
         aJ/6zxzBaufKtvaFB+X9EUdhJqtTr/548nwFKgG5f7QqIApV0ZGpsAEI8ZMUuHIOkXOX
         1p3hggceXipEKPIRy98L0vxmtXSP7hl6UYau7rvHI6sgIPbwzjxUQH6lEuC5eD+OOPOV
         iQx6gPIpaEaha+KlXHnWTVw2UOaOJL1axxSODIsaBSvJY6XbvcI0QCyz0JruKNkdE/on
         Obew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6yXtcuFIc7dVGNx7ADF/6iAn0EJcDM4Yx9eIq/yQWuE=;
        b=EkveonSyxKKoAeUSTFu++IGoMZPDKBqUHu04czpb6X4q5pLM2MS/sofDOTaVIcer+Q
         iAVZou95Y6/SRskJ2IElJqiagRMtwtdrK2IKbgudEeP4q1mjeo1FKpoYD/GWcrqZjlNd
         5dGxnQcGYr4IRMumoBWofLwWSxqjZGhner51WDm9IdNeTkFvOVWuntSVrIfwTjzDtCeg
         Ic0xX709Cz/DPy4bO+IBVNfY3Cl/flUbfjHLVDysC7CbQwtN1b8TN9meN/JCHnB+WdIG
         ECeUhkf47i14sOC2HwwfBXtlTndmiV0E36aOboTW16H0eA3QfQ38mWuAJ8976fMYCB9n
         qVIg==
X-Gm-Message-State: AOAM530Mu+ACy+7Vi1sySY8x9qWfvlvkC4Yt2pVxw7BKRfrW3yIKY9i0
        at4lve6+yBBBcpU4kfjpEcp/1w==
X-Google-Smtp-Source: ABdhPJxpUCNtcIJuVaPHGF0+PuvTqJ7Ec8aYYQaHgbFna+6MBMAiL4ant+VpfJMY7oe60+v6dxE0Qw==
X-Received: by 2002:a17:902:8549:b029:de:8aaa:b012 with SMTP id d9-20020a1709028549b02900de8aaab012mr267476plo.34.1610756208738;
        Fri, 15 Jan 2021 16:16:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b188sm5255349pfg.68.2021.01.15.16.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 16:16:48 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:16:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        syzkaller-bugs@googlegroups.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in
 intel_pmu_refresh()
Message-ID: <YAIwaZfxGQdDN1Cg@google.com>
References: <20201229071144.85418-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201229071144.85418-1-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 29, 2020, Like Xu wrote:
> Since we know vPMU will not work properly when the guest bit_width(s) of
> the [gp|fixed] counters are greater than the host ones, so we can setup a
> smaller left shift value and refresh the guest pmu cpuid entry, thus fixing
> the following UBSAN shift-out-of-bounds warning:
> 
> shift exponent 197 is too large for 64-bit type 'long long unsigned int'
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
>  __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
>  intel_pmu_refresh.cold+0x75/0x99 arch/x86/kvm/vmx/pmu_intel.c:348
>  kvm_vcpu_after_set_cpuid+0x65a/0xf80 arch/x86/kvm/cpuid.c:177
>  kvm_vcpu_ioctl_set_cpuid2+0x160/0x440 arch/x86/kvm/cpuid.c:308
>  kvm_arch_vcpu_ioctl+0x11b6/0x2d70 arch/x86/kvm/x86.c:4709
>  kvm_vcpu_ioctl+0x7b9/0xdb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3386
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl fs/ioctl.c:739 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Reported-by: syzbot+ae488dc136a4cc6ba32b@syzkaller.appspotmail.com
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a886a47daebd..a86a1690e75c 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -345,6 +345,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  
>  	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
>  					 x86_pmu.num_counters_gp);
> +	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
>  	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
>  	pmu->available_event_types = ~entry->ebx &
>  					((1ull << eax.split.mask_length) - 1);

eax.split.mask_length needs similar treatment, doesn't it?

> @@ -355,6 +356,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  		pmu->nr_arch_fixed_counters =
>  			min_t(int, edx.split.num_counters_fixed,
>  			      x86_pmu.num_counters_fixed);
> +		edx.split.bit_width_fixed = min_t(int,
> +			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
>  		pmu->counter_bitmask[KVM_PMC_FIXED] =
>  			((u64)1 << edx.split.bit_width_fixed) - 1;
>  	}
> -- 
> 2.29.2
> 
