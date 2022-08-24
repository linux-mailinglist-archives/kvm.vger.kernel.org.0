Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC215A0452
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 00:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiHXW6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 18:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiHXW6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 18:58:20 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A91ADEAF
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:58:19 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q9so7238562pgq.6
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7uKSPP7wtQ3PYuBGGC9h5HElz/JUzm6F2UIsi7vY/QM=;
        b=NuiQK2A5b/fHXxhYvlXEcTR4hghg7STEpnTevT+DKP6JDA9odmCB+yvUYrHSz7UlXh
         tcvMbMxjZyVAShWZm7Rn6jYL4EpMx31nVe2cTcFNzeoRLceKU8Y/ZoUJEMmPE2MhA+Ph
         1EjOzkPygFolUJAWNMwpwYOmXMrI7L9qZFbP262eOQVA2TXL/Dg2y/b3j8zjGYSQ2Pav
         2xhGmaBJwORbWb8lbI9YHmaj1SOThtuj4hp4R2kr2I/hD8qk5ZDfhCZCSrZAElEkZcc1
         CcWG5Ynh9PUQnm1ZssnKyg9oc/E97I3R+7hvLKxQo5wHF5RlOdZ8uTWCWN1bago2zpa1
         tymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7uKSPP7wtQ3PYuBGGC9h5HElz/JUzm6F2UIsi7vY/QM=;
        b=77SV0owh5tDtw8+kdq4APOy+rmyjqzwmcuWOX7W+84vfa9a0QnUfpK84RIdwfxFVXS
         inxfzWMRA7zWjO8pwUSWC+MP22kstBu36DRZZTh9zoKYVV2YR+FZMInCXPFJJbj4pD8T
         bGUStX5le0B5vDSlqdQjuiS71AneD40llhvutloGs44Q9vU55FISYlOuPEpiOeTweRDR
         JBzFE1TAFKqA0Ri9d88JiWDk5epS9kSSvAbAwtR6MA+BuB6Y04zN0BNVMCNEpRixvbIP
         trT7DgYsUdrcI989hNEmQn4ZjIV6jzRvt5XEBoloJnsUaMsL3rWk1eHkRYYonKC+R54J
         cHjw==
X-Gm-Message-State: ACgBeo3SVhjsu6BvwHneyHd4dAJEt5PtFjrl9YmWJK2RL2DgA9SVuEgf
        rU004uNL8uIk0n6O+8asru7O5g==
X-Google-Smtp-Source: AA6agR4tgl9E6PRbu6VIqVEKHVN3amsz4PBpEeifJ6EMQDqF3m63uKCt5a4Mm7BvfC6NaNhXv/WI7g==
X-Received: by 2002:a62:7bd8:0:b0:536:9c1a:1ed3 with SMTP id w207-20020a627bd8000000b005369c1a1ed3mr950732pfc.77.1661381898446;
        Wed, 24 Aug 2022 15:58:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id lt2-20020a17090b354200b001fabaeb1245sm1986695pjb.24.2022.08.24.15.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 15:58:18 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:58:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 12/13] KVM: x86: SVM: don't save SVM state to SMRAM
 when VM is not long mode capable
Message-ID: <YwatBgiVoCv+UNlp@google.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
 <20220803155011.43721-13-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803155011.43721-13-mlevitsk@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Maxim Levitsky wrote:
> When the guest CPUID doesn't have support for long mode, 32 bit SMRAM
> layout is used and it has no support for preserving EFER and/or SVM
> state.
> 
> Note that this isn't relevant to running 32 bit guests on VM which is
> long mode capable - such VM can still run 32 bit guests in compatibility
> mode.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7ca5e06878e19a..64cfd26bc5e7a6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4442,6 +4442,15 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
>  	if (!is_guest_mode(vcpu))
>  		return 0;
>  
> +	/*
> +	 * 32 bit SMRAM format doesn't preserve EFER and SVM state.
> +	 * SVM should not be enabled by the userspace without marking
> +	 * the CPU as at least long mode capable.

Hmm, or userspace can ensure SMIs never get delivered.  Maybe?

	/*
	 * 32-bit SMRAM format doesn't preserve EFER and SVM state.  Userspace is
	 * responsible for ensuring nested SVM and SMIs are mutually exclusive.
	 */

> +	 */
> +

Unnecessary newline.

> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
> +		return 1;

This doesn't actually fix anything,  RSM will still jump to L2 state but in L1
context.  I think we first need to actually handle errors from
static_call(kvm_x86_enter_smm).

Given that SVM can't even guarantee nested_svm_simple_vmexit() succeeds, i.e. KVM
can't force the vCPU out of L2 to ensure triple fault would hit L1, killing the VM
seems like the least awful solution (and it's still quite awful).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 54fa0aa95785..38a6f4089296 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9985,7 +9985,10 @@ static void enter_smm(struct kvm_vcpu *vcpu)
         * state (e.g. leave guest mode) after we've saved the state into the
         * SMM state-save area.
         */
-       static_call(kvm_x86_enter_smm)(vcpu, &smram);
+       if (static_call(kvm_x86_enter_smm)(vcpu, &smram)) {
+               kvm_vm_dead(vcpu->vm);
+               return;
+       }

        kvm_smm_changed(vcpu, true);
        kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram));

> +
>  	smram->smram64.svm_guest_flag = 1;
>  	smram->smram64.svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
>  
> -- 
> 2.26.3
> 
