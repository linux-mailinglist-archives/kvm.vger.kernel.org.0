Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C368B4B3464
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiBLLCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 06:02:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiBLLCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 06:02:22 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5080B26118;
        Sat, 12 Feb 2022 03:02:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id fy20so27544415ejc.0;
        Sat, 12 Feb 2022 03:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2nsLPIi0Jyp8WpMGSNCbbfOsCpxT0JtH7G04CMqZ8a0=;
        b=U8oA1iWLZ4L8kY3IV6T0/sObqOhi0xEIZoN+nmBOwM9hpxuKSX/pTu31veSuaf6gE8
         cA5CDvpsTOBzMyhlovODwlhzJK1AqcFRG5ypXp9cfMNAL9wF2Ansj8tkgJc1dxWXea9H
         vuT7IbhxJGNyHHYV9MLjLtYyZch9OSD61C7evyfUkHnyYTj4FvXt0e8z+64v4/eSnhQN
         1/lbDOV2XO9xR4+v1SJTQT+n2YENXxIF54ZgvGh59BJwcZ2qymV7UsdxS7WZzSLSElIE
         1uAeG2Om+sT6UWTzyfOnucFkVv18MHxveMEHkTVuK+hUWdy6v5wgroMZoVl+UGRHdbXP
         KaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2nsLPIi0Jyp8WpMGSNCbbfOsCpxT0JtH7G04CMqZ8a0=;
        b=a9yT5uidc2D5nV6fGva3jqwjMKBhuLz5VKyCxv//5lNLu8ZEoab8TUdc8UEZgQVeqf
         J36vdprUjP9eQvD2Ictg2HaGjZOodr2OxrcRBzmzXQfOYqDwniOKYSt0MKrOchheUAWd
         s06p9glDnVq7JC5Qa1QXAVXyg2wC6BxdxDrb2ywcvwRR27Ve2Ujs+pel4OKR8zpB+xV7
         T4no25D+2wbv70EyamoSAR60EuJi3knw2bsh6jBm+IrZGR85E9gm/QSmCSVhp8/d4eY7
         vnavzh/TMIrwxg0089wpUGU51q3jq7hY7TnZMGd73+TZbm2aDBYvhnGPWCpc1vuAKHfZ
         6vKQ==
X-Gm-Message-State: AOAM533Uv7yK7ZG53uS7GfZgExV8HTp8F8d3sps/ZXrl2fq/GJOPsDXJ
        kT22+2Y96aOlvraHLLLpFjs=
X-Google-Smtp-Source: ABdhPJyJWoqxl29NCGoJMhttcOBZrCG9/CVS2+VeXsEMK4oO1Sjbj2U8XkDPjIvgu6Oi0qJXEHAVug==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr4508845ejy.254.1644663737698;
        Sat, 12 Feb 2022 03:02:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h6sm2159942edb.5.2022.02.12.03.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Feb 2022 03:02:17 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5fd84e2f-8ebc-9a4c-64bf-8d6a2c146629@redhat.com>
Date:   Sat, 12 Feb 2022 12:02:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/1] x86/kvm/fpu: Mask guest fpstate->xfeatures with
 guest_supported_xcr0
Content-Language: en-US
To:     Leonardo Bras <leobras@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220211060742.34083-1-leobras@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220211060742.34083-1-leobras@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 07:07, Leonardo Bras wrote:
> During host/guest switch (like in kvm_arch_vcpu_ioctl_run()), the kernel
> swaps the fpu between host/guest contexts, by using fpu_swap_kvm_fpstate().
> 
> When xsave feature is available, the fpu swap is done by:
> - xsave(s) instruction, with guest's fpstate->xfeatures as mask, is used
>    to store the current state of the fpu registers to a buffer.
> - xrstor(s) instruction, with (fpu_kernel_cfg.max_features &
>    XFEATURE_MASK_FPSTATE) as mask, is used to put the buffer into fpu regs.
> 
> For xsave(s) the mask is used to limit what parts of the fpu regs will
> be copied to the buffer. Likewise on xrstor(s), the mask is used to
> limit what parts of the fpu regs will be changed.
> 
> The mask for xsave(s), the guest's fpstate->xfeatures, is defined on
> kvm_arch_vcpu_create(), which (in summary) sets it to all features
> supported by the cpu which are enabled on kernel config.
> 
> This means that xsave(s) will save to guest buffer all the fpu regs
> contents the cpu has enabled when the guest is paused, even if they
> are not used.
> 
> This would not be an issue, if xrstor(s) would also do that.
> 
> xrstor(s)'s mask for host/guest swap is basically every valid feature
> contained in kernel config, except XFEATURE_MASK_PKRU.
> Accordingto kernel src, it is instead switched in switch_to() and
> flush_thread().
> 
> Then, the following happens with a host supporting PKRU starts a
> guest that does not support it:
> 1 - Host has XFEATURE_MASK_PKRU set. 1st switch to guest,
> 2 - xsave(s) fpu regs to host fpustate (buffer has XFEATURE_MASK_PKRU)
> 3 - xrstor(s) guest fpustate to fpu regs (fpu regs have XFEATURE_MASK_PKRU)
> 4 - guest runs, then switch back to host,
> 5 - xsave(s) fpu regs to guest fpstate (buffer now have XFEATURE_MASK_PKRU)
> 6 - xrstor(s) host fpstate to fpu regs.
> 7 - kvm_vcpu_ioctl_x86_get_xsave() copy guest fpstate to userspace (with
>      XFEATURE_MASK_PKRU, which should not be supported by guest vcpu)
> 
> On 5, even though the guest does not support PKRU, it does have the flag
> set on guest fpstate, which is transferred to userspace via vcpu ioctl
> KVM_GET_XSAVE.
> 
> This becomes a problem when the user decides on migrating the above guest
> to another machine that does not support PKRU:
> The new host restores guest's fpu regs to as they were before (xrstor(s)),
> but since the new host don't support PKRU, a general-protection exception
> ocurs in xrstor(s) and that crashes the guest.
> 
> This can be solved by making the guest's fpstate->user_xfeatures only hold
> values compatible to guest_supported_xcr0. This way, on 7 the only flags
> copied to userspace will be the ones compatible to guest requirements,
> and thus there will be no issue during migration.
> 
> As a bonus, will also fail if userspace tries to set fpu features
> that are not compatible to the guest configuration. (KVM_SET_XSAVE ioctl)
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> ---
>   arch/x86/kernel/fpu/core.c | 1 +
>   arch/x86/kvm/cpuid.c       | 4 ++++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 8dea01ffc5c1..e83d8b1fbc83 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -34,6 +34,7 @@ DEFINE_PER_CPU(u64, xfd_state);
>   /* The FPU state configuration data for kernel and user space */
>   struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
>   struct fpu_state_config fpu_user_cfg __ro_after_init;
> +EXPORT_SYMBOL(fpu_user_cfg);
>   
>   /*
>    * Represents the initial FPU state. It's mostly (but not completely) zeroes,
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 494d4d351859..aecebd6bc490 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -296,6 +296,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	vcpu->arch.guest_supported_xcr0 =
>   		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
>   
> +	/* Mask out features unsupported by guest */
> +	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
> +		fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0;

This is not correct, because default_features does not include the
optional features (such as AMX) that were the original reason to
go through all this mess.  What about:

	vcpu->arch.guest_fpu.fpstate->user_xfeatures =
		vcpu->arch.guest_fpu.fpstate->xfeatures & vcpu->arch.guest_supported_xcr0;

?

Paolo

>   	kvm_update_pv_runtime(vcpu);
>   
>   	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);

