Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C84F1B92
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380184AbiDDVVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379724AbiDDR7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:59:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C66834BBA
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:57:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d15so3437141pll.10
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o6hLZdUb/ReT0m7dHtzUEMCrOQA61jDt0sJYjNLeFrM=;
        b=bjGFzmKzBzOkEsGB0baOcb7bfray3F9t5FC2XDPDR25MOdKcPAtOKZplJ3FsM9Myko
         pvDpp5tbpgIb2RTE5S5CLdctjR75ngAbg2862ZMtImR4p5Dm5g/dHuDVoE+W5X4ThfUr
         x+bSrUBWZtWfGJeSUyWeVJwmucmfsgVn1QCkhnuD19SifeUUzCHtBWa8M7oGW9wyBnSL
         X85uNUvUkXpoMyy1BhPAdP5QABgg0bWooDgCUrZPW1OKXzuVYi5SSLBx3QRJZgk522Vo
         Y0bXK4820hvyI+0ks5eoz1oa8mYPmQd8uc96lHBRf86w48NziVyW2Z9bdXfHNCeUW2UQ
         hwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6hLZdUb/ReT0m7dHtzUEMCrOQA61jDt0sJYjNLeFrM=;
        b=SRTX5qCSshl2WyIFhYpaqb07caeKXFkxSKDPMEbBrIlDrFWAZsaXWdCvjSdS1U4qOc
         BLR4gXMKXOaw+S33uDRnv6R/eFmsvDFjyyNCdejkD9+aX3ho507TMd4Bvkjyr/FKBbr7
         jeiO9/fXdPXg9b/m26RDHtZItuv4fvyF238C9IwLiYZyGG+GN5ELnPY3w/iUGfkKJSqL
         B8BmM5ooNi/M8xFkoUjAH/ECjCZhDBvPe80Zdw27Nt4tGm3g07Cx9YUBU0ghlWrbGTXe
         MIfhH6rUF+vhunlAOAffJp5/HdB60ZzYnmeSnRxuHndoqliOmOO/I1yWSlslmO9xkPUQ
         yb+Q==
X-Gm-Message-State: AOAM5331tVmmQUHRbJUzsD4OwNO+d1yZ3j107p7+Qz6WMvI2SIj0fhmk
        IsVjeMghov4/VTDFaIdBuCq2nQ==
X-Google-Smtp-Source: ABdhPJxGWxMtvYIkXrWp3S8TgNg54CUcJ7KsRzi4hwRORB9mUYDQrIppA9nyHmO18bePjSyjyq/LQA==
X-Received: by 2002:a17:90a:4604:b0:1bc:8bdd:4a63 with SMTP id w4-20020a17090a460400b001bc8bdd4a63mr361154pjg.147.1649095052573;
        Mon, 04 Apr 2022 10:57:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm11019145pgb.11.2022.04.04.10.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:57:31 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:57:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 8/8] KVM: VMX: enable IPI virtualization
Message-ID: <YksxiAnNmdR2q65S@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-9-guang.zeng@intel.com>
 <YkZlhI7nAAqDhT0D@google.com>
 <54df6da8-ad68-cc75-48db-d18fc87430e9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54df6da8-ad68-cc75-48db-d18fc87430e9@intel.com>
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

On Sun, Apr 03, 2022, Zeng Guang wrote:
> 
> On 4/1/2022 10:37 AM, Sean Christopherson wrote:
> > > @@ -4219,14 +4226,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> > >   	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
> > >   	if (cpu_has_secondary_exec_ctrls()) {
> > > -		if (kvm_vcpu_apicv_active(vcpu))
> > > +		if (kvm_vcpu_apicv_active(vcpu)) {
> > >   			secondary_exec_controls_setbit(vmx,
> > >   				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
> > >   				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> > > -		else
> > > +			if (enable_ipiv)
> > > +				tertiary_exec_controls_setbit(vmx,
> > > +						TERTIARY_EXEC_IPI_VIRT);
> > > +		} else {
> > >   			secondary_exec_controls_clearbit(vmx,
> > >   					SECONDARY_EXEC_APIC_REGISTER_VIRT |
> > >   					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> > > +			if (enable_ipiv)
> > > +				tertiary_exec_controls_clearbit(vmx,
> > > +						TERTIARY_EXEC_IPI_VIRT);
> > Oof.  The existing code is kludgy.  We should never reach this point without
> > enable_apicv=true, and enable_apicv should be forced off if APICv isn't supported,
> > let alone seconary exec being support.
> > 
> > Unless I'm missing something, throw a prep patch earlier in the series to drop
> > the cpu_has_secondary_exec_ctrls() check, that will clean this code up a smidge.
> 
> cpu_has_secondary_exec_ctrls() check can avoid wrong vmcs write in case mistaken
> invocation.

KVM has far bigger problems on buggy invocation, and in that case the resulting
printk + WARN from the failed VMWRITE is a good thing.

> > > +
> > > +	if (!pages)
> > > +		return -ENOMEM;
> > > +
> > > +	kvm_vmx->pid_table = (void *)page_address(pages);
> > > +	kvm_vmx->pid_last_index = kvm_vmx->kvm.arch.max_vcpu_id - 1;
> > No need to cache pid_last_index, it's only used in one place (initializing the
> > VMCS field).  The allocation/free paths can use max_vcpu_id directly.  Actually,
> 
> In previous design, we don't forbid to change max_vcpu_id after vCPU creation
> or for other purpose in future. Thus it's safe to decouple them and make ipiv
> usage independent. If it can be sure that max_vcpu_id won't be modified , we
> can totally remove pid_last_index and use max_vcpu_id directly even for
> initializing the VMCD field.

max_vcpu_id asolutely needs to be constant after the first vCPU is created.

> > > @@ -7123,6 +7176,22 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
> > >   			goto free_vmcs;
> > >   	}
> > > +	/*
> > > +	 * Allocate PID-table and program this vCPU's PID-table
> > > +	 * entry if IPI virtualization can be enabled.
> > Please wrap comments at 80 chars.  But I'd just drop this one entirely, the code
> > is self-explanatory once the allocation and setting of the vCPU's entry are split.
> > 
> > > +	 */
> > > +	if (vmx_can_use_ipiv(vcpu->kvm)) {
> > > +		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> > > +
> > > +		mutex_lock(&vcpu->kvm->lock);
> > > +		err = vmx_alloc_pid_table(kvm_vmx);
> > > +		mutex_unlock(&vcpu->kvm->lock);
> > This belongs in vmx_vm_init(), doing it in vCPU creation is a remnant of the
> > dynamic resize approach that's no longer needed.
> 
> We cannot allocate pid table in vmx_vm_init() as userspace has no chance to
> set max_vcpu_ids at this stage. That's the reason we do it in vCPU creation
> instead.

Ah, right.  Hrm.  And that's going to be a recurring problem if we try to use the
dynamic kvm->max_vcpu_ids to reduce other kernel allocations.

Argh, and even kvm_arch_vcpu_precreate() isn't protected by kvm->lock.

Taking kvm->lock isn't problematic per se, I just hate doing it so deep in a
per-vCPU flow like this.

A really gross hack/idea would be to make this 64-bit only and steal the upper
32 bits of @type in kvm_create_vm() for the max ID.

I think my first choice would be to move kvm_arch_vcpu_precreate() under kvm->lock.
None of the architectures that have a non-nop implemenation (s390, arm64 and x86)
do significant work, so holding kvm->lock shouldn't harm performance.  s390 has to
acquire kvm->lock in its implementation, so we could drop that.  And looking at
arm64, I believe its logic should also be done under kvm->lock.

It'll mean adding yet another kvm_x86_ops, but I like that more than burying the
code deep in vCPU creation.

Paolo, any thoughts on this?
