Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64394EE455
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbiCaWs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbiCaWsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:48:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78491237FCD
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:46:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so795927pjk.4
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7uOUzZnbDEusnKR8cHWSyHd2FNHBMs+CYiJb4fGuX4g=;
        b=saclz8jkvtOn9nSRzBPhcHPd3drlaDn9wlVl5p8YFykQOEoBBxA0XJkjgZ8cTCzPK6
         FMl6af4M26t9yd66jXObaOKA7AYFMkXhp/zQ1E5cjs+Dc23ZC7Nq5jU/PHfe2U3imyNZ
         hej+lIUS1XBxtRjX/eItimBO0l4FfZFjLqAwIOywtDOhEuP222M5iJalT5wFDvKu5hZM
         NJmvlEz/gJYLDuI1NB0/xng2DUv7PxMs7r89lLIQpBgUHyhU7N2mCgfCOjxqp5xo5mNe
         FH3Y02rsAJrnhoBxlMG+13CHQUkcVbCrlj1xEqWkzRqEYLxBDvivu8fTUEJwIxRgkwHy
         /TMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7uOUzZnbDEusnKR8cHWSyHd2FNHBMs+CYiJb4fGuX4g=;
        b=EmRrN5xjvT68rpOSAc05j3KkjU0WyF5gAdMXgUWDsMTm6KRKzd+NVYjvaSn7ZUCWds
         TIyXyA4pzxdx9B3ANebBdpQyMW9j+1uxF7nAj+HNRR/aP/pgkr5+XGHg0V9BTbS4cpjb
         l2l5SatM0veCWCrmRASq3ml2gTot5i/R2j8VvvqlPWkV/iDGbsMcANtytqtBUpMLZ/YK
         v0MAlhEvlyiAa50YXN978JhgDW8gU+V0EOpVXA2gKRnAr1oDcu8IdlqE+kVS9dA/kE5z
         Bupb/5asMiPXyxsMiJVvkF5A42t+UL7dVl/rv6pGDB0mhKOvmHPKYTcbN7xgkCvMLWD5
         0USg==
X-Gm-Message-State: AOAM530NmrWwghIq88Nte/kCCVLXzhf1zunfjpCvOI/WgHkUE5yd+20L
        kXImceh6OOQA/VVELzkBywmQOA==
X-Google-Smtp-Source: ABdhPJxhusEmkTGoR7eUlu5A0Ce5fMesefkDFwNmmHwbnSL8TStNtf2UnkB+Vztq7JGocGm/di0LAQ==
X-Received: by 2002:a17:902:cccb:b0:156:4a0:a2e7 with SMTP id z11-20020a170902cccb00b0015604a0a2e7mr7427200ple.97.1648766796515;
        Thu, 31 Mar 2022 15:46:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm324113pgc.91.2022.03.31.15.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:46:35 -0700 (PDT)
Date:   Thu, 31 Mar 2022 22:46:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Message-ID: <YkYvSHcIrhRgU93l@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-5-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304080725.18135-5-guang.zeng@intel.com>
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

Nit, shortlog is funky, it'd read better as

  KVM: VMX: Report tertiary_exec_control field in dump_vmcs()

On Fri, Mar 04, 2022, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> Add tertiary_exec_control field report in dump_vmcs()

Please call out the shuffling of PinBased and provide a sample dump.  It's not
mandatory to put that sort of info in the changelog, but it really does help
reviewers, e.g. I remember discussing the shuffling and seeing the sample output,
but other reviewers coming into this blind won't have that luxury.

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8a5713d49635..7beba7a9f247 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5891,6 +5891,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 vmentry_ctl, vmexit_ctl;
>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
> +	u64 tertiary_exec_control;
>  	unsigned long cr4;
>  	int efer_slot;
>  
> @@ -5904,9 +5905,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
>  	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
>  	cr4 = vmcs_readl(GUEST_CR4);
> -	secondary_exec_control = 0;
> +
>  	if (cpu_has_secondary_exec_ctrls())
>  		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> +	else
> +		secondary_exec_control = 0;
> +
> +	if (cpu_has_tertiary_exec_ctrls())
> +		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
> +	else
> +		tertiary_exec_control = 0;
>  
>  	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
>  	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
> @@ -6006,9 +6014,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
>  
>  	pr_err("*** Control State ***\n");
> -	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
> -	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
> -	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
> +	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
> +	       cpu_based_exec_ctrl, secondary_exec_control, tertiary_exec_control);
> +	pr_err("PinBased=0x%08x EntryControls=%08x ExitControls=%08x\n",
> +	       pin_based_exec_ctrl, vmentry_ctl, vmexit_ctl);
>  	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
>  	       vmcs_read32(EXCEPTION_BITMAP),
>  	       vmcs_read32(PAGE_FAULT_ERROR_CODE_MASK),
> -- 
> 2.27.0
> 
