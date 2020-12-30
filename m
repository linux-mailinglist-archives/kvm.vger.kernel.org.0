Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920FE2E76C9
	for <lists+kvm@lfdr.de>; Wed, 30 Dec 2020 08:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgL3HPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 02:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgL3HPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 02:15:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08135C061799;
        Tue, 29 Dec 2020 23:15:05 -0800 (PST)
Received: from zn.tnic (p200300ec2f0ae90058345bc89b9c20d2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e900:5834:5bc8:9b9c:20d2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4DAA61EC01E0;
        Wed, 30 Dec 2020 08:15:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609312503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fRCzYVFcIqOBFyAjy8t0dU3NQf+SBRgvC8B34AVqExw=;
        b=hir7S9O+8qgwsIpoALUBHZSNPz1rldpLPcMJ4fkqUVq4uk1wkV+eRkkiVa4RJgrwz6LduN
        G5MFOXqaaiS4A25vtjrNlFc0SIwoTspoXj6PeYITvoVIHscstkAUVNJmIDcyyrs3B8MfMw
        2oKh7+/gxjFVWnHxbEEgbSiAZrXiLZE=
Date:   Wed, 30 Dec 2020 08:15:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, thomas.lendacky@amd.com, peterz@infradead.org,
        seanjc@google.com, joro@8bytes.org, x86@kernel.org,
        kyung.min.park@intel.com, linux-kernel@vger.kernel.org,
        krish.sadhukhan@oracle.com, hpa@zytor.com, mgross@linux.intel.com,
        vkuznets@redhat.com, kim.phillips@amd.com, wei.huang2@amd.com,
        jmattson@google.com
Subject: Re: [PATCH v2 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Message-ID: <20201230071501.GB22022@zn.tnic>
References: <160867624053.3471.7106539070175910424.stgit@bmoger-ubuntu>
 <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <160867631505.3471.3808049369257008114.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 22, 2020 at 04:31:55PM -0600, Babu Moger wrote:
> @@ -2549,7 +2559,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>  			return 1;
>  
> -		msr_info->data = svm->spec_ctrl;
> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +			msr_info->data = svm->vmcb->save.spec_ctrl;
> +		else
> +			msr_info->data = svm->spec_ctrl;
>  		break;
>  	case MSR_AMD64_VIRT_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
> @@ -2640,6 +2653,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  			return 1;
>  
>  		svm->spec_ctrl = data;
> +		if (static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> +			svm->vmcb->save.spec_ctrl = data;
>  		if (!data)
>  			break;
>  

Are the get/set_msr() accessors such a fast path that they need
static_cpu_has() ?

svm_get_msr() already uses boot_cpu_has() for MSR_TSC_AUX...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
