Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86591358B04
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhDHRLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhDHRLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:11:12 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD765C061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 10:11:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i4so1499180pjk.1
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 10:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sR3+TwtzcgmKXM1DZECybWOT3fd7KGeBrqw4EhHDOxk=;
        b=EeVmCOELA7sKLUZj6mbqz9l/oxLCaip8qepN5DRC8+XYBtHY3B9/vUjYc27AxsqyYx
         H8WAGXwxj1+i+DZ81DuVixcUxc+FktRjYxiqlDqU5QRXPM+fnHLbpNmITjomqO+vDPWC
         5h88MK9ga7us8esAHt7JPwIO3eYIbJ5R07reaVFOC5eKHvbyE8AWCXyWzB/CX2VAiIRy
         L6lJkNmMyZB+XX1IacbmEHyn6bRE8E6Cusf3Ue/FH915BvYGyZcjs7qKZWXToIX4uN4s
         3hQwgd0sA0Kw3Riw3UhiiplF1Mgc0G45RBmTKgdBPnSqN+o8MQwcvyl/keay5HbazqAB
         hxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sR3+TwtzcgmKXM1DZECybWOT3fd7KGeBrqw4EhHDOxk=;
        b=DSRf6tWsVJvjntUjdavdIBFl4WpXbXqn9EryEcZV+YrqgKq/UikYQgjlwigrub8I8d
         r9abIr3ij4TKtnIRaqjfmUiuUqr0A99GBBr8TatGNKdohh8TOI2VsFbgfwSZdw70OqfV
         hkr9JMcpr+GctmXrOFWZ3wddEmW6UtCmXmH++49UPYww4BQZtrqUCX10JpDqtIbTZhrU
         BB+BS7gQ6r4iCzDRnUa68KS5ZiLxl8APDmJC+tzi4rUHsjC8ImfvKG5aWgiQtA3BzC5q
         tBhYclPvoppCYNN3HzDxrs/hnZ+UjLHqep24fJCr55sWDMN8r7rKasitw5w0nDaraf6V
         IbAA==
X-Gm-Message-State: AOAM533ijAU+iwknyzrEG26atU7P6X3DY187jNBfrXah/OQ148uFFif8
        fxaWX+FsAB52L5l/HsLt+SS65A==
X-Google-Smtp-Source: ABdhPJzsXhglooUez/HYyJnVRNvNI/uT4lvIuMRrpeyBeizfBTO1Ty8cBM0m5kPYIH0j6/+IXhy5Jg==
X-Received: by 2002:a17:903:2488:b029:e7:1f01:85c4 with SMTP id p8-20020a1709032488b02900e71f0185c4mr8823113plw.13.1617901860333;
        Thu, 08 Apr 2021 10:11:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t65sm79465pfd.5.2021.04.08.10.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 10:10:59 -0700 (PDT)
Date:   Thu, 8 Apr 2021 17:10:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
Message-ID: <YG85HxqEAVd9eEu/@google.com>
References: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Access to the GHCB is mainly in the VMGEXIT path and it is known that the
> GHCB will be mapped. But there are two paths where it is possible the GHCB
> might not be mapped.
> 
> The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
> the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
> However, if a SIPI is performed without a corresponding AP Reset Hold,
> then the GHCB might not be mapped (depending on the previous VMEXIT),
> which will result in a NULL pointer dereference.
> 
> The svm_complete_emulated_msr() routine will update the GHCB to inform
> the caller of a RDMSR/WRMSR operation about any errors. While it is likely
> that the GHCB will be mapped in this situation, add a safe guard
> in this path to be certain a NULL pointer dereference is not encountered.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> ---
> 
> Changes from v1:
> - Added the svm_complete_emulated_msr() path as suggested by Sean
>   Christopherson
> - Add a WARN_ON_ONCE() to the sev_vcpu_deliver_sipi_vector() path
> ---
>  arch/x86/kvm/svm/sev.c | 3 +++
>  arch/x86/kvm/svm/svm.c | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 83e00e524513..7ac67615c070 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>  	 * non-zero value.
>  	 */
> +	if (WARN_ON_ONCE(!svm->ghcb))

Isn't this guest triggerable?  I.e. send a SIPI without doing the reset hold?
If so, this should not WARN.

> +		return;
> +
>  	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 271196400495..534e52ba6045 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2759,7 +2759,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	if (!sev_es_guest(vcpu->kvm) || !err)
> +	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
>  		return kvm_complete_insn_gp(vcpu, err);
>  
>  	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
> -- 
> 2.31.0
> 
