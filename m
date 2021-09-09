Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1372405F07
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 23:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347166AbhIIVnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 17:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344885AbhIIVnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 17:43:07 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B483BC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 14:41:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e7so1972022plh.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 14:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cmi7xVMJh51AjVg5ujaQ3w2M+HVnZy5yn09Ds7yQTCI=;
        b=B1+ODwqLAvPfFWRXxuisetotF1uVlKSYT8OV6/JEXj/8fdsNjKuq4Rh8YuiI350OUo
         xaQFo9bJROXJbhRHoeZZsuSPQ/U8fwHuD9gvnI8noMzMHxThDNdfuR9k4et+O4/IlzuB
         Tfpbzoox009CzUY5nHcN1oxXigDn0Lo6I3jd3KhXq6jBvdaZaszU+GGDwXuVL0eFXRvX
         q7Csh+I48IRHA5wGb88eV86ftte6HT4VW9K0hp8AmpD7qtNDpoYyc3RBgC1D9Hy04zbG
         i67LLtFJqlJxgpz8JkGrK/zK0G/T8bL219wBjVVidvJ53KG+3dRbwi4vYXBBRI/yxgir
         AR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cmi7xVMJh51AjVg5ujaQ3w2M+HVnZy5yn09Ds7yQTCI=;
        b=vgKwqunOhWJ7zE2XdLim3tqF4m7ldpGGcgm9vujOWErxdKitDQASifTq5qGmIIrhoZ
         KTnmoCVDjlWRYJS9k8A4hhuXtKGl5QjjIoYBwcEdPJ+UJIdUDDTcZk2C31+0gZC8SK9J
         fRkOXmbMwEb0SJHxLpuBDuPS5xtFhOZX8kk4UseyW8BhkT2OqO4fAgU5Q6Vzl/kQIIEy
         JcozPYd4ZGFRvFyDQ3+Se/nUaPR33cBD+xEaXnBNKn4Cp3TjYIn4O8jOc8R/de+trPBM
         tBXLv8PFQOPVgyKhlhiTG2pOzP00TpPScYupXpyVZDD57X/o+tjmsDknHInEW7nOWrgM
         245Q==
X-Gm-Message-State: AOAM533+PIH9LWjXlKvizAy7idyCmdnY0MNdPicrVluUehaKrto1/lDJ
        K24S6IZkN/rDSKJZlinwzsOWWw==
X-Google-Smtp-Source: ABdhPJyNNEmvNXWXbLbpiwJCEkwrZPMI6ZxJQjILhKo2FNAMx+uP5cq72TUb0Q1WjyeGDsoEW94ZKQ==
X-Received: by 2002:a17:90a:d789:: with SMTP id z9mr5962122pju.32.1631223717031;
        Thu, 09 Sep 2021 14:41:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n9sm2973973pfu.152.2021.09.09.14.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 14:41:56 -0700 (PDT)
Date:   Thu, 9 Sep 2021 21:41:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Message-ID: <YTp/oGmiin19q4sQ@google.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827070249.924633-7-xiaoyao.li@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Xiaoyao Li wrote:
> CPUID 0xD leaves reports the capabilities of Intel PT, e.g. it decides
> which bits are valid to be set in MSR_IA32_RTIT_CTL, and reports the
> number of PT ADDR ranges.
> 
> KVM needs to check that guest CPUID values set by userspace doesn't
> enable any bit which is not supported by bare metal. Otherwise,
> 1. it will trigger vm-entry failure if hardware unsupported bit is
>    exposed to guest and set by guest.
> 2. it triggers #GP when context switch PT MSRs if exposing more
>    RTIT_ADDR* MSRs than hardware capacity.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> There is bit 31 of CPUID(0xD, 0).ECX that doesn't restrict any bit in
> MSR_IA32_RTIT_CTL. If guest has different value than host, it won't
> cause any vm-entry failure, but guest will parse the PT packet with
> wrong format.
> 
> I also check it to be same as host to ensure the virtualization correctness.
> 
> Changes in v2:
> - Call out that if configuring more PT ADDR MSRs than hardware, it can
>   cause #GP when context switch.
> ---
>  arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 739be5da3bca..0c8e06a24156 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -76,6 +76,7 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>  static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>  {
>  	struct kvm_cpuid_entry2 *best;
> +	u32 eax, ebx, ecx, edx;
>  
>  	/*
>  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
> @@ -89,6 +90,30 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>  			return -EINVAL;
>  	}
>  
> +	/*
> +	 * CPUID 0xD leaves tell Intel PT capabilities, which decides

CPUID.0xD is XSAVE state, CPUID.0x14 is Intel PT.  This series needs tests...

> +	 * pt_desc.ctl_bitmask in later update_intel_pt_cfg().
> +	 *
> +	 * pt_desc.ctl_bitmask decides the legal value for guest
> +	 * MSR_IA32_RTIT_CTL. KVM cannot support PT capabilities beyond native,
> +	 * otherwise it will trigger vm-entry failure if guest sets native
> +	 * unsupported bits in MSR_IA32_RTIT_CTL.
> +	 */
> +	best = cpuid_entry2_find(entries, nent, 0xD, 0);
> +	if (best) {
> +		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
> +		if (best->ebx & ~ebx || best->ecx & ~ecx)
> +			return -EINVAL;
> +	}
> +	best = cpuid_entry2_find(entries, nent, 0xD, 1);
> +	if (best) {
> +		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
> +		if (((best->eax & 0x7) > (eax & 0x7)) ||

Ugh, looking at the rest of the code, even this isn't sufficient because
pt_desc.guest.addr_{a,b} are hardcoded at 4 entries, i.e. running KVM on hardware
with >4 entries will lead to buffer overflows.

One option would be to bump that to the theoretical max of 15, which doesn't seem
too horrible, especially if pt_desc as a whole is allocated on-demand, which it
probably should be since it isn't exactly tiny (nor ubiquitous)

A different option would be to let userspace define whatever it wants for guest
CPUID, and instead cap nr_addr_ranges at min(host.cpuid, guest.cpuid, RTIT_ADDR_RANGE).

Letting userspace generate a bad MSR_IA32_RTIT_CTL is not problematic, there are
plenty of ways userspace can deliberately trigger VM-Entry failure due to invalid
guest state (even if this is a VM-Fail condition, it's not a danger to KVM).

> +		    ((best->eax & ~eax) >> 16) ||
> +		    (best->ebx & ~ebx))
> +			return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.27.0
> 
