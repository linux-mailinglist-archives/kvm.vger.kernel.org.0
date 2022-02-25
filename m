Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433694C4785
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241789AbiBYOcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241802AbiBYOcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:32:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D48981402E
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645799496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxivWoSNWd6p4/vl38jC6Wxn49Np4iZFofyVxWKJ0dU=;
        b=Ms4cFjB41ecv1LupWa9zzStnp7i17AdpcDeZjZczo7K3KCiFvWvDCqMpKtLfpnCGyZZgjQ
        HIH0dlKE/baHHeH57GBzrKztAmWgsecPq92At/RDnFNDB9BxuZtYfQrrbeXFA7eTskEsO0
        G3YVBj+KHHmcE7ZWct5NxCJHI1l11ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-NFLnV_4gPg2CXTIeu2gkRA-1; Fri, 25 Feb 2022 09:31:33 -0500
X-MC-Unique: NFLnV_4gPg2CXTIeu2gkRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D3E618049CB;
        Fri, 25 Feb 2022 14:31:30 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 357E27C694;
        Fri, 25 Feb 2022 14:31:23 +0000 (UTC)
Message-ID: <9fa1258080c4d5b21a9d56448c02cff1438def90.camel@redhat.com>
Subject: Re: [PATCH v6 4/9] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Date:   Fri, 25 Feb 2022 16:31:22 +0200
In-Reply-To: <20220225082223.18288-5-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-5-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> Add tertiary_exec_control field report in dump_vmcs()
> 
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

