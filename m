Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F512F3AC8
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 20:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393106AbhALTlh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 14:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732196AbhALTlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 14:41:36 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7650FC061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:40:56 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id t6so1981804plq.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 11:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hPaJJwg8MTOSNiRBibVEGrx1HwOpvfxrWoAXKh+WulM=;
        b=auBKf9s7D1W2kYZXznvNER4bC+hHK8sBoZQbhpUb9hh1MrRreiXgOlF+E39eW6y2oB
         o2aRwPVdeqslvRwRESPvicu0U57HODD/AZn1jPSzT6MiW5ESsLEaeF0f157rOLcyLZZq
         vItrN7/M9EZbN0wsGcTiFn9ZItaffsjhqHyr5ltmu3PXBuqGqY/xnufQq7xRLCGT3nqE
         668JqSlaokH5ixIGZpwEf9FmOhwD/wHih4WpZnK65GeBwdWtwv3PI7J/BDkJ2LbbvYq0
         0meCDAsLnj30hZpLgLwkF6NbcopW0Q929Lbsr35UF7CLeKSUZSQRbjlAnk1cnsc4e1NB
         I7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hPaJJwg8MTOSNiRBibVEGrx1HwOpvfxrWoAXKh+WulM=;
        b=Z1fPdCYfUtdCheKkyN7yETEmzp4nKY12MHFifNGHV+tKqUr0BXNjSwb+hR1cNAPsnK
         D0QfUrsd4IZRrMxq6+WckBDtLIrZv0ilP5GnMD41Ywe0UnHOKaNGCr77LO1wr4euHpRw
         w8Mrdta7ZWTJCk0VNev+b7PPUIpUhY8sG15D2faDaNrdAH5yAsgiEfj4TvdELyoDgdZ0
         p4TZIi9ryZ8oN9OlYrWcQBENTTRO3jlV/4GVqIPulLF2KA7gu2XggGVuV31SuacdhJLY
         owtN8UqIwWamGdzSfdAJrkqtO4reVy2BTkCmujFamGfDnyuQqcnW444Tk748QslbxB98
         zJvA==
X-Gm-Message-State: AOAM530rmeR6gQ2emUoMKDPkq5dHINb/Tz2fQgACRnYnrdxHjVXXTo+A
        vtbcK0wI65SojZOhG3Jb39hBhQ==
X-Google-Smtp-Source: ABdhPJxnBQWV+yw0DsBXg9V4v/r75GpT0aU6Sp7wlpYXIuX9YyY3Q8I1/gBmDZIyC2TGC5xLZF1vtQ==
X-Received: by 2002:a17:902:724b:b029:de:229a:47f1 with SMTP id c11-20020a170902724bb02900de229a47f1mr791709pll.10.1610480455876;
        Tue, 12 Jan 2021 11:40:55 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id r20sm4608042pgb.3.2021.01.12.11.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:40:55 -0800 (PST)
Date:   Tue, 12 Jan 2021 11:40:48 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Huang <wei.huang2@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, joro@8bytes.org,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <X/37QBMHxH8otaMa@google.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Wei Huang wrote:
> +/* Emulate SVM VM execution instructions */
> +static int svm_emulate_vm_instr(struct kvm_vcpu *vcpu, u8 modrm)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	switch (modrm) {
> +	case 0xd8: /* VMRUN */
> +		return vmrun_interception(svm);
> +	case 0xda: /* VMLOAD */
> +		return vmload_interception(svm);
> +	case 0xdb: /* VMSAVE */
> +		return vmsave_interception(svm);
> +	default:
> +		/* inject a #GP for all other cases */
> +		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +		return 1;
> +	}
> +}
v> +
>  static int gp_interception(struct vcpu_svm *svm)
>  {
>  	struct kvm_vcpu *vcpu = &svm->vcpu;
>  	u32 error_code = svm->vmcb->control.exit_info_1;
> -
> -	WARN_ON_ONCE(!enable_vmware_backdoor);
> +	int rc;
>  
>  	/*
> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
> +	 * them has non-zero error codes.
>  	 */
>  	if (error_code) {
>  		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>  		return 1;
>  	}
> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +
> +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
> +	if (rc > 1)
> +		rc = svm_emulate_vm_instr(vcpu, rc);
> +	return rc;
>  }
 
...
  
> +static int is_vm_instr_opcode(struct x86_emulate_ctxt *ctxt)
> +{
> +	unsigned long rax;
> +
> +	if (ctxt->b != 0x1)
> +		return 0;
> +
> +	switch (ctxt->modrm) {
> +	case 0xd8: /* VMRUN */
> +	case 0xda: /* VMLOAD */
> +	case 0xdb: /* VMSAVE */
> +		rax = kvm_register_read(emul_to_vcpu(ctxt), VCPU_REGS_RAX);
> +		if (!kvm_is_host_reserved_region(rax))
> +			return 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return ctxt->modrm;
> +}
> +
>  static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
>  {
>  	switch (ctxt->opcode_len) {
> @@ -7305,6 +7327,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	bool writeback = true;
>  	bool write_fault_to_spt;
> +	int vminstr;
>  
>  	if (unlikely(!kvm_x86_ops.can_emulate_instruction(vcpu, insn, insn_len)))
>  		return 1;
> @@ -7367,10 +7390,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		}
>  	}
>  
> -	if ((emulation_type & EMULTYPE_VMWARE_GP) &&
> -	    !is_vmware_backdoor_opcode(ctxt)) {
> -		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> -		return 1;
> +	if (emulation_type & EMULTYPE_PARAVIRT_GP) {
> +		vminstr = is_vm_instr_opcode(ctxt);
> +		if (!vminstr && !is_vmware_backdoor_opcode(ctxt)) {
> +			kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
> +			return 1;
> +		}
> +		if (vminstr)
> +			return vminstr;

I'm pretty sure this doesn't correctly handle a VM-instr in L2 that hits a bad
L0 GPA and that L1 wants to intercept.  The intercept bitmap isn't checked until
x86_emulate_insn(), and the vm*_interception() helpers expect nested VM-Exits to
be handled further up the stack.

>  	}
>  
>  	/*
> -- 
> 2.27.0
> 
