Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27B3E1E26
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 23:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhHEVwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 17:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhHEVwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 17:52:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CDBC061798
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 14:51:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so15022829pji.5
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 14:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UJ159t+f6VudfuqyLQz6Bo1vrsObE55f3fMhR4Rv5AY=;
        b=LadFTp7W+4br1RY64Wa/mbSJmM2/1D53i4bVyNECEUwYkttrx+8NsVySD/YDIWSDvz
         izyiOz6K0lKYSkIhRSncNLOoN1im/h9chcXR3aEmhjlhU6PdnwuX/X4+wBavKOYexWZS
         X7jGB+tK7Sd5y74Bi2kvUZ2pLkthjAE2OacQggR5bAotBFWuDpO/5sRLYeFRafAo9NTw
         Kd600UA+VsfXySuM2g8DFeTNRexE7evK2a179QQfeOlnFFSg3wojHKSsgx7ds+a7Zqdk
         h5AZlp528PQLvCDfcMKsj7rR1UDCafoGqi8RbUrxRGsiDb8OoLuty2e+kbG5a1k4WvkO
         IHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UJ159t+f6VudfuqyLQz6Bo1vrsObE55f3fMhR4Rv5AY=;
        b=ABCWaMBIK2eGAdSC5nM+/mWYG0tgpUeSfJUG4p/Esu0OxcujYQAFVP0hG6AAVpkIaQ
         XDSMy4LrgUAxnAzS9KuKwhqS5/u3uKZ9pDmMHqT/Y65y3ccWD/qzF6XyozAicmRybtY5
         BaO6lylnWI2+lwDnEnQ4O2N6jsyf6odTGl8hSMI/BomLXf56lBO5pKvuk4pQdXJyVVRh
         aITEH1csBdACU/pIgO9tbidaW9e6goVQBsKZsS7AGh/Cqp2ReMw+vgqiL2ZMCFiNnBIf
         gYlHFR4k/RBYgytlg9n+HCILCWs1rcrluLrBdxTWV5U6EqmWD2Nkbbe46n+uwPn8ii0G
         oKDg==
X-Gm-Message-State: AOAM533emmyw7Bh/S8wvHlhj7NuO59h499bE8Bmqs1nljaddMdPArrJT
        Sq5CONOuBpHg++3YglF06s1iww==
X-Google-Smtp-Source: ABdhPJydq6PTSwGWfRpWmoGZDodNRkO3aMTMpf8xU73hbyW/ueJyc1+cth/noSiSxnnGuHfVo41xbA==
X-Received: by 2002:a17:902:8648:b029:129:dda4:ddc2 with SMTP id y8-20020a1709028648b0290129dda4ddc2mr5713351plt.4.1628200306544;
        Thu, 05 Aug 2021 14:51:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d15sm9178388pgj.84.2021.08.05.14.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 14:51:45 -0700 (PDT)
Date:   Thu, 5 Aug 2021 21:51:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to
 vendor's specific code
Message-ID: <YQxdbq+yoTIJmpL+@google.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-2-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805205504.2647362-2-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Wei Huang wrote:
> Currently the TDP level for x86 vCPU is calculated by checking both
> MAXPHYADDR and max_tdp_level. This design assumes that all x86 CPUs have
> the flexibility of changing the nested page table level different from host
> CPU. This assumption might not be true.

Heh, no need to be circumspect, just state that 5-level NPT inherits CR4.LA57
from the host.  I didn't fully understand this sentence until I looked at patch 3.

> To solve this problem, let us
> create a kvm_x86_ops specific function for TDP level calculation.
> 
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> ---

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..20ddfbac966e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -723,7 +723,6 @@ struct kvm_vcpu_arch {
>  
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
> -	int max_tdp_level;

Ha, this is leftover crud that can get zapped no matter what.

>  	/* emulate context */
>  

...

> -static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
> -{
> -	/* Use 5-level TDP if and only if it's useful/necessary. */
> -	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)

I'd strongly prefer to keep this logic in the MMU.  When this was in vendor code,
there were multiple bugs where the MMU and VMX didn't communicate correctly, I
really don't want to back down that road.

Actually, I'm very, very tempted to say we should simply drop the cpuid_maxphyaddr()
bit and just return the max level (and I suppose rename it), e.g.

	return mmu_tdp_level;

It's effectively a single 4kb page per VM, and Intel's numbers on 5-level paging
were that there was no measurable cost to the extra level.  I would hope that
holds true here, too.

If we want to keep the MAXPHYADDR behavior, I'd vote for something like:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4b65c21b2ca..7e35f2bf89b4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -97,6 +97,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 bool tdp_enabled = false;

 static int max_huge_page_level __read_mostly;
+static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;

 enum {
@@ -4645,6 +4646,9 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,

 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
+       if (tdp_root_level)
+               return tdp_root_level;
+
        /* Use 5-level TDP if and only if it's useful/necessary. */
        if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
                return 4;
@@ -5336,10 +5340,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
         */
 }

-void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
-                      int tdp_huge_page_level)
+void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
+                      int tdp_max_root_level, int tdp_huge_page_level)
 {
        tdp_enabled = enable_tdp;
+       tdp_root_level = tdp_forced_root_level;
        max_tdp_level = tdp_max_root_level;

        /*
