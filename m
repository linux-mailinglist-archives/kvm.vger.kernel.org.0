Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931D64C475D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiBYOZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBYOZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:25:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E6E71F685A
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645799079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYPopQnM/N6BqfW8YvCaa4lKNgzUK+lwFuTwoLgolIc=;
        b=hph/dKdlXWNjKWZHOmkx+9AsAjDOpRUXVlpWIteX7qsQZR4nnQBWOgoMXUFREpoTukhUbm
        tP2+U/tW3CxjJXINqGCr6q+Z3/8WXh0+5E+LHj0QEjTBkldUFnS6obe7Oonq8wH5mLvn+7
        /lPZYXbcPIPcDpotlfoEIyWDInoxYCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-ZFBQn_M_PcuHHElDtKleVw-1; Fri, 25 Feb 2022 09:24:35 -0500
X-MC-Unique: ZFBQn_M_PcuHHElDtKleVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 586D4FC80;
        Fri, 25 Feb 2022 14:24:30 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DAEA83569;
        Fri, 25 Feb 2022 14:24:20 +0000 (UTC)
Message-ID: <9da5d168b8327396c91047f0b7b1c0235a67f27f.camel@redhat.com>
Subject: Re: [PATCH v6 2/9] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
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
Date:   Fri, 25 Feb 2022 16:24:19 +0200
In-Reply-To: <20220225082223.18288-3-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-3-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> The Tertiary VM-Exec Control, different from previous control fields, is 64
> bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
> support both 32 bit and 64 bit fields' auxiliary functions building.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 59 ++++++++++++++++++++++--------------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7f2c82e7f38f..e07c76974fb0 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -456,35 +456,38 @@ static inline u8 vmx_get_rvi(void)
>  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>  }
>  
> -#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
> -static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
> -{									    \
> -	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
> -		vmcs_write32(uname, val);				    \
> -		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
> -	}								    \
> -}									    \
> -static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
> -{									    \
> -	return vmcs->controls_shadow.lname;				    \
> -}									    \
> -static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
> -{									    \
> -	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
> -}									    \
> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
> -{									    \
> -	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
> -}									    \
> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
> -{									    \
> -	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
> +#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			\
> +static inline								\
> +void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)		\
> +{									\
> +	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		\
> +		vmcs_write##bits(uname, val);				\
> +		vmx->loaded_vmcs->controls_shadow.lname = val;		\
> +	}								\
> +}									\
> +static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)\
> +{									\
> +	return vmcs->controls_shadow.lname;				\
> +}									\
> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
> +{									\
> +	return __##lname##_controls_get(vmx->loaded_vmcs);		\
> +}									\
> +static inline								\
> +void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)		\
> +{									\
> +	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	\
> +}									\
> +static inline								\
> +void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
> +{									\
> +	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	\
>  }
> -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
> -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
> -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
>  
>  /*
>   * VMX_REGS_LAZY_LOAD_SET - The set of registers that will be updated in the

I must admit that this will make it a bit harder to find references in the code.
I personally would just use pair of 32 bit capabilities, but I don't have strong opinion
on this.

Thus:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


