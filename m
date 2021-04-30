Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30E13701DA
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 22:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhD3ULx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 16:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhD3ULr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 16:11:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4F7C06138C
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 13:10:58 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id p12so50142404pgj.10
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 13:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y5hqDeZNhe8SoddKxv/ncGGJkjFlgN/Vvr4BayVVCMY=;
        b=KuHqqWrjKa2m55Q/rYXy8NdBn6FOdROzDmCHjWsY9JynRSJG0cewtOzEeU0vh4SZfL
         8MgNSxiia93hm5iqJxTYx2oNGp3J6RWfv+/uo9ghdK/gJz7saJ2p5VjEMiLdOYNr0rdD
         eGtgn36hh46T0c23mmszl4+hJ+mqknyV3t/KIvT4dWRXs8lc1+L9vqDIBIER0VvjHKZU
         LIcUVNXB4qqAlk+Rxh6US0RqrRnDFdBA2uVDoCBWwVTyGfC61FAyb13mtVILtNSjW/xb
         FXUBbwfiAGviWnMqFzBEOAxTdtkTDITPeKT4hh5ZwzhlTRo4vqvpa+OiyeLsntQTutge
         qsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y5hqDeZNhe8SoddKxv/ncGGJkjFlgN/Vvr4BayVVCMY=;
        b=jUia/qmP3j5M3Eocs0QQ3GmN20Rxu2pFp/uFinWXj8f8GMEoqbBatQJoS0/q3rQpX3
         /5LrdT0MMfVxsIyUr8pqDaWJXVo6mV3SoSShXdkdbzPxbWwyqGqBTNq7Mr8ByPm1rhr5
         XrOhLVQYP3nq8tdJAvoGrR7uIxI42Q07uuzT6TFY54MbBpuEbjaO/36shjX/kBNd7GpI
         k77rza0bJsGcsdYvyYkmYDEAJlsXsWHKUimhEdZuDF9NISwU8NU9HO6/XqlPGQlO8Pb1
         dmIWMLXMj7RBoXskLxUnI4AdNw9PuFrWjYqdPt5WRc/oLOrFNJTMRQJBnW9NDIVZ7HzN
         i6ng==
X-Gm-Message-State: AOAM533hF2dPH4MhkuHktXOWgJvI2NRDQ/fGNyaAMrL2q1NYqLnVMKSJ
        8uAJBn8/m0y6SGqSmSELYaSV0Q==
X-Google-Smtp-Source: ABdhPJzyZYSMg+LE19UpoeZAg2GN8Z10SjNNoosOh5NIqYLoSK/OgyJzEGbzTpfeT1dBNJOxHG6ZiQ==
X-Received: by 2002:a63:2143:: with SMTP id s3mr6326413pgm.429.1619813457493;
        Fri, 30 Apr 2021 13:10:57 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i9sm2922341pji.41.2021.04.30.13.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 13:10:56 -0700 (PDT)
Date:   Fri, 30 Apr 2021 20:10:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YIxkTZsblAzUzsf7@google.com>
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429104707.203055-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Paolo Bonzini wrote:
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 57fc4090031a..cf1b0b2099b0 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -383,5 +383,10 @@ MSR_KVM_MIGRATION_CONTROL:
>  data:
>          This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
>          CPUID.  Bit 0 represents whether live migration of the guest is allowed.
> +
>          When a guest is started, bit 0 will be 1 if the guest has encrypted
> -        memory and 0 if the guest does not have encrypted memory.
> +        memory and 0 if the guest does not have encrypted memory.  If the
> +        guest is communicating page encryption status to the host using the
> +        ``KVM_HC_PAGE_ENC_STATUS`` hypercall, it can set bit 0 in this MSR to
> +        allow live migration of the guest.  The MSR is read-only if
> +        ``KVM_FEATURE_HC_PAGE_STATUS`` is not advertised to the guest.

I still don't get the desire to tie MSR_KVM_MIGRATION_CONTROL to PAGE_ENC_STATUS
in any way shape or form.  I can understand making it read-only or dropping
writes if it's not intercepted by userspace, but making it read-only for
non-encrypted guests makes it useful only for encrypted guests, which defeats
the purpose of genericizing the MSR.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9c40be9235c..0c2524bbaa84 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3279,6 +3279,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
>  			return 1;
>  
> +		/*
> +		 * This implementation is only good if userspace has *not*
> +		 * enabled KVM_FEATURE_HC_PAGE_ENC_STATUS.  If userspace
> +		 * enables KVM_FEATURE_HC_PAGE_ENC_STATUS it must set up an
> +		 * MSR filter in order to accept writes that change bit 0.
> +		 */
>  		if (data != !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm))
>  			return 1;

This behavior doesn't match the documentation.

  a. The MSR is not read-only for legacy guests since they can write '0'.
  b. The MSR is not read-only if KVM_FEATURE_HC_PAGE_STATUS isn't advertised,
     a guest with encrypted memory can write '1' regardless of whether userspace
     has enabled KVM_FEATURE_HC_PAGE_STATUS.
  c. The MSR is never fully writable, e.g. a guest with encrypted memory can set
     bit 0, but not clear it.  This doesn't seem intentional?

Why not simply drop writes?  E.g.

		if (data & ~KVM_MIGRATION_READY)
			return 1;
		break;

And then do "msr->data = 0;" in the read path.  That's just as effective as
making the MSR read-only to force userspace to intercept the MSR if it wants to
do anything useful with the information, and it's easy to document.

>  		break;
