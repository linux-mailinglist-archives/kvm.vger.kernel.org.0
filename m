Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFFE57C184
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGUASs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGUASr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:18:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802874DEE
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:18:47 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w7so279052ply.12
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ig9etYs538yPyN0CS13kIWTj1dEohsXUW+9HS4HPo3k=;
        b=gyDY7jz0AD9dFRGWwEJCRI/go3GcSEHRKwgo5EdQEchrF1KA6LPmPykKEd3/XJyvlC
         Dlu0pQQg41Sxxu/L27+OU2y6sjm3m60xmPQgsNVsaIWejgwokxQK9+HIIcSvPlKh3tMp
         FEFgm9tDyUM3rtzUwuNkhe7whyrohBSC2sgEemMhYuG0uxwz3I5CSl7jONrUt1UFe7wH
         xZIkpOUf1oUa6fGVQIl6K16KCWU5YH9VopjsNST+utp05LVXTjhdxIzpsV6tNbY4RGnt
         lNo8ETJDezHxvbz1B9WY8tKLGrW+0jYOj4xJKWWTPGgE+E53gddde7/6NwbeEjLFeYic
         qiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ig9etYs538yPyN0CS13kIWTj1dEohsXUW+9HS4HPo3k=;
        b=DwPhyrONms1pcdJbFJBRMtOC06aut2I/hLu7fcTBMO2rdLCnYeKeKY/VF3PJukGG2A
         IGs7SnkyQczGLqrrVbx1QpyZbBgFiQDSXY6doW2fbRrgZi6Lw8XHjlzxr5MkvpWf7UOW
         +IJ4EE8iwijXAu342pAftvotpLsxm8B3U0pCAs1Y+J/0rzKWv37uT0EYcFc8KTA8tumd
         5ddW9MmoyivL5IO1mG4BtZj9hUSqR5TseNcGm5M/RRKvTnaeSj/eimNansRqh+z4BD1o
         rBS9cZZFpKr33QDJzjNP5pKsLT0hZFruoiDGJKWINeNoEieluCCGnfPSrnMD6nRzm9YG
         sD0A==
X-Gm-Message-State: AJIora/+lREHZta3MHVWTaF+8g82H65wwUtFz/Q6u18xkw/edM7g5UoU
        iLzEGWp1FB4rp8RjPnAkX2geUA==
X-Google-Smtp-Source: AGRyM1uuambVTj1y2RS9TJtNYaMZtoObx6giI3dLY/+YMOW3HfoeEYuLzeBPCFiGHOoSlifKFJcVhg==
X-Received: by 2002:a17:90b:33cd:b0:1f0:3655:17a8 with SMTP id lk13-20020a17090b33cd00b001f0365517a8mr8186696pjb.33.1658362726524;
        Wed, 20 Jul 2022 17:18:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p7-20020a170902780700b0016beceac426sm152831pll.138.2022.07.20.17.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:18:45 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:18:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 10/11] KVM: x86: SVM: use smram structs
Message-ID: <YtibYud8NY8bgcPZ@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-11-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-11-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> This removes the last user of put_smstate/GET_SMSTATE so
> remove these functions as well.
> 
> Also add a sanity check that we don't attempt to enter the SMM
> on non long mode capable guest CPU with a running nested guest.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ------
>  arch/x86/kvm/svm/svm.c          | 28 +++++++++++++++++-----------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1038ccb7056a39..9e8467be96b4e6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2057,12 +2057,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>  #endif
>  }
>  
> -#define put_smstate(type, buf, offset, val)                      \
> -	*(type *)((buf) + (offset) - 0x7e00) = val
> -
> -#define GET_SMSTATE(type, buf, offset)		\
> -	(*(type *)((buf) + (offset) - 0x7e00))
> -
>  int kvm_cpu_dirty_log_size(void);
>  
>  int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 136298cfb3fb57..8dcbbe839bef36 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4399,6 +4399,7 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  
>  static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  {
> +	struct kvm_smram_state_64 *smram = (struct kvm_smram_state_64 *)smstate;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_host_map map_save;
>  	int ret;
> @@ -4406,10 +4407,17 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
>  	if (!is_guest_mode(vcpu))
>  		return 0;
>  
> -	/* FED8h - SVM Guest */
> -	put_smstate(u64, smstate, 0x7ed8, 1);
> -	/* FEE0h - SVM Guest VMCB Physical Address */
> -	put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
> +	/*
> +	 * 32 bit SMRAM format doesn't preserve EFER and SVM state.
> +	 * SVM should not be enabled by the userspace without marking
> +	 * the CPU as at least long mode capable.
> +	 */
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> +		return 1;

Isn't this is an independent bug fix?  I.e. should be in its own patch?

> +
> +	smram->svm_guest_flag = 1;
> +	smram->svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
>  
>  	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
>  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
