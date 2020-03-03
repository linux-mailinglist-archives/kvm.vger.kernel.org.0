Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0295177BAC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgCCQOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:14:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47205 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729973AbgCCQOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ke7JyOZ+XUVw15fBOEBYEhZUVs/KiL71BjHy19fu+e0=;
        b=CzpAB3PemCSQLS5qsyjMt3V6cRYb9WEkdDTmrT0bvi9EUfp6COc3Z5enGzwuDzwug7R57B
        ONIsTOantQ6bEttJRu3aYkELLnJ0vrFGymnVKptxCtE3SX7xjFQClWId5M5ShjFY3u3r9D
        jcyAHFjggesvHIt8x8MLo/sYzdJFCWE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-xeFb3K1wPa-7WYp5J1qOeQ-1; Tue, 03 Mar 2020 11:14:16 -0500
X-MC-Unique: xeFb3K1wPa-7WYp5J1qOeQ-1
Received: by mail-wm1-f70.google.com with SMTP id g26so851181wmk.6
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:14:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ke7JyOZ+XUVw15fBOEBYEhZUVs/KiL71BjHy19fu+e0=;
        b=Lle2vRKcLTEsL4E+ONggdExQY3TzqdxGcR+pXXcpstJpW/ik008Iy5yODP/BFVPtX1
         zxNzk13fzNf88hdUkCD3DrcfUtZ8ePibeBrJ80fA6lXgz08yHt4Hx/O6CAMxoACsLH7R
         HJKY1roh2VxAXn+2OIBunZ52gKP9q4OiLSzKI26J9xScr3sayuAerzdsuf484nfGnNXU
         R1G6RDkpIKqV17SVBM163gkIOPUlTEcEqXRu/7fE6zYkuuUXPjqdExbcmTPH0riz01Cl
         aj3giVi42B5osOQtlyx5lnWWnByOiyqAAjYZp/cGyEej/NGrxDhKBqoNpkOwimOwAJFi
         rvjg==
X-Gm-Message-State: ANhLgQ2OAUN+M/DLCTmUzP9Qh5ctMXYiA8WNxuQRaeVQ5c/z28mcliJM
        2raeo3MWCdTGzftGBC8M3SAts2WbmXuGIXMii/RCmAmR/6v4Wq8GX+4vl6I4lU7ZcGmRKUZE0XK
        5RcCPLisTMQf6
X-Received: by 2002:a5d:4385:: with SMTP id i5mr6534000wrq.73.1583252054839;
        Tue, 03 Mar 2020 08:14:14 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvzxW70xc/VJEcuSFwL+qOMYmCt0A4uPOJ819FvR079RmuIjM3QhoM81oK2YqUq/BXSW9GBqg==
X-Received: by 2002:a5d:4385:: with SMTP id i5mr6533975wrq.73.1583252054588;
        Tue, 03 Mar 2020 08:14:14 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q16sm18640242wrj.73.2020.03.03.08.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:14:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 65/66] KVM: nSVM: Advertise and enable NRIPS for L1 iff nrips is enabled
In-Reply-To: <20200302235709.27467-66-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-66-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 17:14:12 +0100
Message-ID: <875zflfmaz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Set NRIPS in KVM capabilities if and only if nrips=true, which naturally
> incorporates the boot_cpu_has() check, and set nrips_enabled only if the
> KVM capability is enabled.
>
> Note, previously KVM would set nrips_enabled based purely on userspace
> input, but at worst that would cause KVM to propagate garbage into L1,
> i.e. userspace would simply be hosing its VM.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8e39dcd3160d..32d9c13ec6b9 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1377,7 +1377,7 @@ static __init void svm_set_cpu_caps(void)
>  	if (nested) {
>  		kvm_cpu_cap_set(X86_FEATURE_SVM);
>  
> -		if (boot_cpu_has(X86_FEATURE_NRIPS))
> +		if (nrips)
>  			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
>  
>  		if (npt_enabled)
> @@ -6031,7 +6031,8 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  				    boot_cpu_has(X86_FEATURE_XSAVES);
>  
>  	/* Update nrips enabled cache */
> -	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
> +	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> +			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
>  
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

