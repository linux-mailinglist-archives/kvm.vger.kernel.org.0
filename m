Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379112F1050
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 11:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbhAKKoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 05:44:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729285AbhAKKoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 05:44:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610361772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ixUVOIGb/XAJr3qxQXdPsUM6DBOCljtoBWyj9OZ5agw=;
        b=itKxLEmnKH0KsbhfYWV3FkkWYSU3tJsMQRn32XOJ1gurzq1IC1fzOkJpCQfDbaSUfExMA6
        3ghFCNxvG5uXYNmEtkvhcD1Bds9xiawbO2/N7t5jR9DqkIz/7hOmOoA4GA6FOTuAbFr0fS
        7GIMQxiKdVS8t/AGBUHV/zduCbXL2I8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-u5me133ONGm_Y_Qw2CKhtQ-1; Mon, 11 Jan 2021 05:42:51 -0500
X-MC-Unique: u5me133ONGm_Y_Qw2CKhtQ-1
Received: by mail-ed1-f72.google.com with SMTP id p17so8082728edx.22
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 02:42:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ixUVOIGb/XAJr3qxQXdPsUM6DBOCljtoBWyj9OZ5agw=;
        b=lGG3bGde3ouXAB9QcLG6njI+T1GkXUiM8GnlEw2krmDoZg21xRCr98ejT/KH9R82EF
         eMbbVSjdTbu6HDVd/UmyIuGBp89SvPBcVnFLx7bgrkilhKgyZu56tv6wIGuOJlrg0Dor
         RbJVaIGzXOlzxpz8UhVYHHPZqpYYDX9K/Uz4epu2VY5fxi9JiONLxYe8zkcObLoXo+JY
         eOcZVo0AX5Fij+sonEbcDf8Iz7ygO9hho8NI85BRqdYOYmPDnohIKH/onDemkdmhzVEn
         uQkPBJ9MmUB6blyNTa8ekNF9Agta0bOt7sE2Agn74qxDfW1R26OWqvVVjwWptcAvzZgE
         f3hg==
X-Gm-Message-State: AOAM533qNTT7MBJlKv931qCwUhXztk7Smcg2Ot2VWIshkqnJP0wjdeD1
        fGv3NKOjS/1rT6+VNZxZBGC2Huipf93wwSgxmtWv8wO1HVeRfBwKkUmIMxbOSFOr4pGWbTQvtzA
        aSS7tfnlrX66X
X-Received: by 2002:a50:eb44:: with SMTP id z4mr13431750edp.167.1610361770117;
        Mon, 11 Jan 2021 02:42:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbX/oCXfXUXqADHbp1OPdT3DJnuK1Y9QdQdoj+RWltqZSTQDeEQcUQrrvFvmimNu19OBmQQQ==
X-Received: by 2002:a50:eb44:: with SMTP id z4mr13431733edp.167.1610361769920;
        Mon, 11 Jan 2021 02:42:49 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ca4sm7536916edb.80.2021.01.11.02.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 02:42:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/13] KVM: SVM: Move SEV module params/variables to sev.c
In-Reply-To: <20210109004714.1341275-4-seanjc@google.com>
References: <20210109004714.1341275-1-seanjc@google.com>
 <20210109004714.1341275-4-seanjc@google.com>
Date:   Mon, 11 Jan 2021 11:42:48 +0100
Message-ID: <87sg7792l3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Unconditionally invoke sev_hardware_setup() when configuring SVM and
> handle clearing the module params/variable 'sev' and 'sev_es' in
> sev_hardware_setup().  This allows making said variables static within
> sev.c and reduces the odds of a collision with guest code, e.g. the guest
> side of things has already laid claim to 'sev_enabled'.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 11 +++++++++++
>  arch/x86/kvm/svm/svm.c | 15 +--------------
>  arch/x86/kvm/svm/svm.h |  2 --
>  3 files changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0eeb6e1b803d..8ba93b8fa435 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -27,6 +27,14 @@
>  
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>  
> +/* enable/disable SEV support */
> +static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev, int, 0444);
> +
> +/* enable/disable SEV-ES support */
> +static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> +module_param(sev_es, int, 0444);

Two stupid questions (and not really related to your patch) for
self-eduacation if I may:

1) Why do we rely on CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT (which
sound like it control the guest side of things) to set defaults here? 

2) It appears to be possible to do 'modprobe kvm_amd sev=0 sev_es=1' and
this looks like a bogus configuration, should we make an effort to
validate the correctness upon module load?

> +
>  static u8 sev_enc_bit;
>  static int sev_flush_asids(void);
>  static DECLARE_RWSEM(sev_deactivate_lock);
> @@ -1249,6 +1257,9 @@ void __init sev_hardware_setup(void)
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
>  
> +	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
> +		goto out;
> +
>  	/* Does the CPU support SEV? */
>  	if (!boot_cpu_has(X86_FEATURE_SEV))
>  		goto out;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ccf52c5531fb..f89f702b2a58 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -189,14 +189,6 @@ module_param(vls, int, 0444);
>  static int vgif = true;
>  module_param(vgif, int, 0444);
>  
> -/* enable/disable SEV support */
> -int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev, int, 0444);
> -
> -/* enable/disable SEV-ES support */
> -int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
> -module_param(sev_es, int, 0444);
> -
>  bool __read_mostly dump_invalid_vmcb;
>  module_param(dump_invalid_vmcb, bool, 0644);
>  
> @@ -976,12 +968,7 @@ static __init int svm_hardware_setup(void)
>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>  	}
>  
> -	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
> -		sev_hardware_setup();
> -	} else {
> -		sev = false;
> -		sev_es = false;
> -	}
> +	sev_hardware_setup();
>  
>  	svm_adjust_mmio_mask();
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..8e169835f52a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -408,8 +408,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
>  #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
>  #define MSR_INVALID				0xffffffffU
>  
> -extern int sev;
> -extern int sev_es;
>  extern bool dump_invalid_vmcb;
>  
>  u32 svm_msrpm_offset(u32 msr);

-- 
Vitaly

