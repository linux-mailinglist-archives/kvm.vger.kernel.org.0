Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51B5177BA6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730220AbgCCQMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:12:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60720 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728714AbgCCQMN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 11:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583251933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ewMDLFJs+pwUVCPxSOpuH/6W8SJZrs4NnUYkU/1nly8=;
        b=ElCGWQtIs3Q3f+h19UsBW/oqA2nJVVk8XtRzTgmeJ1NP+7a7ewwLVq4fANqgYSilC9VecR
        eA/21UP9jcQfhUNhCG/QSlJ7kTvSkmGy+YWmUJ/SuGfROnOQv3+AJfdhYJpo775kEWMgp7
        hzBTISRdmFnjjeKyYc3n6l5CI5+7RxY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-3PcaTPkPO_SVMwULvVehjw-1; Tue, 03 Mar 2020 11:12:06 -0500
X-MC-Unique: 3PcaTPkPO_SVMwULvVehjw-1
Received: by mail-wr1-f70.google.com with SMTP id n7so1436656wro.9
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:12:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ewMDLFJs+pwUVCPxSOpuH/6W8SJZrs4NnUYkU/1nly8=;
        b=TVS74e3rtvJCt/C6tlksZhzlmzD5m+u/bJhx2l+iaRPg7RWfauJT/yZKUrqXqMktIW
         jWsLNWYSvHz+5unhndjSB+Kn4ntk9MvT7e0f/v+0RzvSxZpUKO2cEdnvHk4UsejtQ1jR
         Djg8Vcj0J/1E0OK7usVz6D/ExY2a3nmg7dMd5QBEEHJFt4xmK+3T9OpKu85ttPsCMu1F
         UaQ4FotR/r3YBwpujMJBryclbMD96vGt4r1URGzrBLDhW/ceqXeshcQPSahhsWYEOW3I
         89Fg5N0/MYlhjCm8nqjeZrYG02yRzyKfp2SeJhJ71BdTqpRa3UlN5QRR1+Ovy18gpGhb
         BCQA==
X-Gm-Message-State: ANhLgQ0UHy/ZqSTq7cL2qAy2zsBxyJavoRSDoxug4MPX/r0ndhnUiiRY
        9hp0LEjJwqo6OyyT7w569itduIMZDxnImTK8vbQNiUqpEK81RFWvvU4zOf7b6Kk//cSSVTqmBUf
        xdXWNkBg94kxW
X-Received: by 2002:adf:b601:: with SMTP id f1mr6559892wre.103.1583251925507;
        Tue, 03 Mar 2020 08:12:05 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs+gmDGERMF3k74BHUSenOqjl0DQn34XjlBAm+4vP34zz/YQPtfXpqrGLsflVDYehy+Smec6A==
X-Received: by 2002:adf:b601:: with SMTP id f1mr6559878wre.103.1583251925275;
        Tue, 03 Mar 2020 08:12:05 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l5sm4806923wml.3.2020.03.03.08.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:12:04 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 64/66] KVM: nSVM: Expose SVM features to L1 iff nested is enabled
In-Reply-To: <20200302235709.27467-65-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-65-sean.j.christopherson@intel.com>
Date:   Tue, 03 Mar 2020 17:12:03 +0100
Message-ID: <878skhfmek.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Set SVM feature bits in KVM capabilities if and only if nested=true, KVM
> shouldn't advertise features that realistically can't be used.  Use
> kvm_cpu_cap_has(X86_FEATURE_SVM) to indirectly query "nested" in
> svm_set_supported_cpuid() in anticipation of moving CPUID 0x8000000A
> adjustments into common x86 code.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index f32fc3c03667..8e39dcd3160d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1373,21 +1373,21 @@ static __init void svm_set_cpu_caps(void)
>  	if (avic)
>  		kvm_cpu_cap_clear(X86_FEATURE_X2APIC);
>  
> -	/* CPUID 0x80000001 */
> -	if (nested)
> +	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
> +	if (nested) {
>  		kvm_cpu_cap_set(X86_FEATURE_SVM);
>  
> +		if (boot_cpu_has(X86_FEATURE_NRIPS))
> +			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
> +
> +		if (npt_enabled)
> +			kvm_cpu_cap_set(X86_FEATURE_NPT);
> +	}
> +
>  	/* CPUID 0x80000008 */
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> -
> -	/* CPUID 0x8000000A */
> -	/* Support next_rip if host supports it */
> -	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
> -
> -	if (npt_enabled)
> -		kvm_cpu_cap_set(X86_FEATURE_NPT);
>  }
>  
>  static __init int svm_hardware_setup(void)
> @@ -6051,6 +6051,10 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
>  	switch (entry->function) {
>  	case 0x8000000A:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
>  		entry->eax = 1; /* SVM revision 1 */
>  		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
>  				   ASID emulation to nested SVM */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

