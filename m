Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D591523D4D
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346745AbiEKTVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 15:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346742AbiEKTU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 15:20:57 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F8A34669
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:20:56 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 15so2626262pgf.4
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oxIbllnQbENuoa+9bmqy6v24kDB/poSSDa6J+9ptVpM=;
        b=jzz2FiCQ6xkVxCRWHTFMwVFfjSGeZpoGzzOL7F9T9abU9n0SU0EmfroHzsGKG5A8XK
         AqU0ezgipq2tpz5zsdrf3307iY5CsCoZu5Fz1MqKSy4iOJeUOsjR/dZbI3Q2hQ0fP1t0
         N3ZAThVp82OdEjGZMyPZ5kA31u7LKmz1DMMtYeVP4GblqSoxaf8ADa2TN1FzSzhd6Caf
         hn2O4Ctc8ycXoweZ4vFlQ2J5RgPH1+RUEi3HAc+DGbksKtkN/hNDfUgu5K72T3LyxW+x
         FXlgnB5TdDHSxqWQz/GDm1fzQCsGTBf6DTESuKEZ0iBNYKbNspDmUb7Dm9BpOvdeQHG1
         IxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oxIbllnQbENuoa+9bmqy6v24kDB/poSSDa6J+9ptVpM=;
        b=32jpZ6Sx/v+Ya55ohkFZwjwNu/UFIehhAU4TJ0pLmgocNn2x0QGft/0D9ANklHdl/L
         sDgltE028KMtEGCUMW+f2EWdzax/zkLYHVK552nEvQsssmijU1MpYNPZeb+8u0FXLaQY
         AlpQqLWQjY+MfR3W6CGU1jnCTPlQV50WlJF5enoCHYxpO+jU0Xo4CdLaidxvrAuMvX69
         7x6C5P+MOwsL4XPteRYHYKkJsUQWp1V22E9WrEeDzBKCQuZC8firm3sY9rr12Tffs5h1
         RHNjGW3VwcmBbPWKKlX/nwKu3rU637KqIvaG9S5wrNi0ytpybUIX4mn1Rz8sP5nWDoFi
         BG7Q==
X-Gm-Message-State: AOAM532N/cGaFekFiJamf9IbURjFXCs0MedY2uRHGCurV2Chdr28YMgs
        Grj3S0e1iNOk+l1V8TEDWdd8Zw==
X-Google-Smtp-Source: ABdhPJxlXZOK1iuD2FFqyp9jQWOjBi7mHK2VhA7d0IreQStvaLfLqq+vS59GtL8naaXSSKaDSSBz1w==
X-Received: by 2002:a63:8ac7:0:b0:3aa:f853:4f62 with SMTP id y190-20020a638ac7000000b003aaf8534f62mr22360836pgd.205.1652296856320;
        Wed, 11 May 2022 12:20:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79157000000b0050dc76281cbsm2115300pfi.165.2022.05.11.12.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:20:55 -0700 (PDT)
Date:   Wed, 11 May 2022 19:20:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] KVM: x86: Add support for MCG_CMCI_P and handling
 of injected UCNAs.
Message-ID: <YnwMlFmAL8lRxX7x@google.com>
References: <20220412223134.1736547-1-juew@google.com>
 <20220412223134.1736547-5-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412223134.1736547-5-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> Note prior to this patch, the UCNA type of signaling can already be
> processed by kvm_vcpu_ioctl_x86_set_mce and does not result in correct
> CMCI signaling semantic.

Same as before...

UCNA should be spelled out at least once.

> 
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  1 +
>  arch/x86/kvm/x86.c     | 48 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b730d799c26e..63aa2b3d30ca 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8035,6 +8035,7 @@ static __init int hardware_setup(void)
>  	}
>  
>  	kvm_mce_cap_supported |= MCG_LMCE_P;
> +	kvm_mce_cap_supported |= MCG_CMCI_P;

Is there really no hardware dependency on CMCI?  Honest question  If not, that
should be explicitly called out in the changelog.

>  	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
>  		return -EINVAL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 73c64d2b9e60..eb6058ca1e70 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4775,6 +4775,50 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +static bool is_ucna(u64 mcg_status, u64 mci_status)

Any reason not to take 'struct kvm_x86_mce *mce'?

> +{
> +	return !mcg_status &&
> +		!(mci_status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR));

As someone who knows nothing about MCI encoding, can you add a function comment
explaing, in detail, what's going on here?

Also, my preference is to align the indentation on multi-line returns.  Paolo scoffs
at this nit of mine, but he's obviously wrong ;-)

	return !mcg_status &&
	       !(mci_status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR));

> +}
> +
> +static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu,
> +		struct kvm_x86_mce *mce)

Please align the params.  Actually, just let it run over, it's a single char.

static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu, struct kvm_x86_mce *mce)

> +{
> +	u64 mcg_cap = vcpu->arch.mcg_cap;
> +	unsigned int bank_num = mcg_cap & 0xff;
> +	u64 *banks = vcpu->arch.mce_banks;
> +
> +	/* Check for legal bank number in guest */

Eh, don't think this warrants a comment.

> +	if (mce->bank >= bank_num)
> +		return -EINVAL;
> +
> +	/*
> +	 * UCNA signals should not set bits that are only used for machine check
> +	 * exceptions.
> +	 */
> +	if (mce->mcg_status ||
> +		(mce->status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR)))

Unless mine eyes deceive me, this is the same as:

	if (!is_ucna(mce->mcg_status, mce->status))

> +		return -EINVAL;
> +
> +	/* UCNA must have VAL and UC bits set */
> +	if (!(mce->status & MCI_STATUS_VAL) || !(mce->status & MCI_STATUS_UC))
> +		return -EINVAL;
> +
> +	banks += 4 * mce->bank;
> +	banks[1] = mce->status;
> +	banks[2] = mce->addr;
> +	banks[3] = mce->misc;
> +	vcpu->arch.mcg_status = mce->mcg_status;
> +
> +	if (!(mcg_cap & MCG_CMCI_P) || !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))

This one's worth wrapping, that's quite a long line, and there's a natural split point:

	if (!(mcg_cap & MCG_CMCI_P) ||
	    !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
		return 0;


> +		return 0;
> +
> +	if (lapic_in_kernel(vcpu))
> +		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
> +
> +	return 0;
> +}
> +
>  static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>  				      struct kvm_x86_mce *mce)
>  {
> @@ -4784,6 +4828,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>  
>  	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
>  		return -EINVAL;
> +
> +	if (is_ucna(mce->mcg_status, mce->status))
> +		return kvm_vcpu_x86_set_ucna(vcpu, mce);
> +
>  	/*
>  	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
>  	 * reporting is disabled
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
