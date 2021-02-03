Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4482F30D49A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 09:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhBCIEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 03:04:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232310AbhBCIEW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 03:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612339376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEMHaMwbi3AuNVus+rKLM1JLdZEfgnKxlFjzFWyQHnE=;
        b=Pl58sM6qgmPB+8MBPSkaNtaVLbPU0xtvo/tipK9Td7B1HWfHLH+7OA2SNjEBfQ8gLoBrff
        8s/AbS1JLNjbKwbny1OcR+ePkAcKZHoQ4GCwpsdZV0U1/LFVtofZ+Tt6m15Io5NwZXeezg
        AHMnimjCb43bkL596wk2VQZmNSmmrKw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-s-Kgw9TZM2iSZ4zpnLmzAA-1; Wed, 03 Feb 2021 03:02:54 -0500
X-MC-Unique: s-Kgw9TZM2iSZ4zpnLmzAA-1
Received: by mail-ej1-f71.google.com with SMTP id dc21so11531603ejb.19
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 00:02:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEMHaMwbi3AuNVus+rKLM1JLdZEfgnKxlFjzFWyQHnE=;
        b=NN7n3tRjACcGWu+PVRY8kY1ZjX1t1TkTG1sVOnD3dKnqEmQLFUGdk/u7b2Dln4oN1o
         yYR7CiPpZavIFmx9hhl7yRlok4rHLjIqhcHr5UVi2EzmHke7HQ2qS1hpjbIxV1Zz5LzM
         NVChfQz3SMRLfS0+9oBBFPfYdSJ1KTSSDUjSLAUHebPCzD4Uvv1/4D+ZHNmAI6IWXflh
         8OLDz/tZDqIwJAzt0f1s91Nr7w7X96wZ1I9NxNp1lZ4/5sk34U9MyECLtZ3DJtVAYZfL
         VZ7wplCNd/QDHdbwL68n12QGZCSvqlQD4EFX9urqzJ+42qYe5UcVRwuL/UiabaXabJeD
         tm9Q==
X-Gm-Message-State: AOAM531DCc+QeqdGpUeEFEXGPRMd/zbT4eNFgz+sMFMyguhJeNs8n/lP
        qTPlwmVtEMcOTbGytLS+gt+ohRX02nLz20a9OpEKiJ78tYDIPZT9idDuLmJgHHwRmx893n+iuh8
        p9+XclK/op7E2
X-Received: by 2002:a17:907:2da0:: with SMTP id gt32mr1930602ejc.78.1612339373688;
        Wed, 03 Feb 2021 00:02:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwg8QEV5fFm0hkBGzPxCPlW5dNX5HELqVeWY3Alk0wm8qorBkOGSY6HZsOKSn9PPnLp7FCbIg==
X-Received: by 2002:a17:907:2da0:: with SMTP id gt32mr1930589ejc.78.1612339373529;
        Wed, 03 Feb 2021 00:02:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l20sm607221ejb.95.2021.02.03.00.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 00:02:52 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Treat SVM as unsupported when running as an SEV
 guest
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210202212017.2486595-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b38551b-df22-7416-007c-d5f750940f9a@redhat.com>
Date:   Wed, 3 Feb 2021 09:02:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202212017.2486595-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 22:20, Sean Christopherson wrote:
> Don't let KVM load when running as an SEV guest, regardless of what
> CPUID says.  Memory is encrypted with a key that is not accessible to
> the host (L0), thus it's impossible for L0 to emulate SVM, e.g. it'll
> see garbage when reading the VMCB.
> 
> Technically, KVM could decrypt all memory that needs to be accessible to
> the L0 and use shadow paging so that L0 does not need to shadow NPT, but
> exposing such information to L0 largely defeats the purpose of running as
> an SEV guest.  This can always be revisited if someone comes up with a
> use case for running VMs inside SEV guests.
> 
> Note, VMLOAD, VMRUN, etc... will also #GP on GPAs with C-bit set, i.e. KVM
> is doomed even if the SEV guest is debuggable and the hypervisor is willing
> to decrypt the VMCB.  This may or may not be fixed on CPUs that have the
> SVME_ADDR_CHK fix.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> FWIW, I did get nested SVM working on SEV by decrypting all structures
> that are shadowed by L0, albeit with many restrictions.  So even though
> there's unlikely to be a legitimate use case, I don't think KVM (as L0)
> needs to be changed to disallow nSVM for SEV guests, userspace is
> ultimately the one that should hide SVM from L1.
> 
>   arch/x86/kvm/svm/svm.c    | 5 +++++
>   arch/x86/mm/mem_encrypt.c | 1 +
>   2 files changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 687876211ebe..9fb367cb4f15 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -448,6 +448,11 @@ static int has_svm(void)
>   		return 0;
>   	}
>   
> +	if (sev_active()) {
> +		pr_info("KVM is unsupported when running as an SEV guest\n");
> +		return 0;
> +	}
> +
>   	return 1;
>   }
>   
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index c79e5736ab2b..c3d5f0236f35 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -382,6 +382,7 @@ bool sev_active(void)
>   {
>   	return sev_status & MSR_AMD64_SEV_ENABLED;
>   }
> +EXPORT_SYMBOL_GPL(sev_active);
>   
>   /* Needs to be called from non-instrumentable code */
>   bool noinstr sev_es_active(void)
> 

Queued, thanks.

Paolo

