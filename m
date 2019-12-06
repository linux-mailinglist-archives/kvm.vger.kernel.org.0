Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6394211588F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 22:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfLFVXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 16:23:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:41061 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfLFVXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 16:23:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 13:23:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="362346315"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 06 Dec 2019 13:23:00 -0800
Date:   Fri, 6 Dec 2019 13:23:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/3] kvm: nVMX: Aesthetic cleanup of handle_vmread and
 handle_vmwrite
Message-ID: <20191206212300.GE5433@linux.intel.com>
References: <20191206193144.33209-1-jmattson@google.com>
 <20191206193144.33209-3-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206193144.33209-3-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 06, 2019 at 11:31:44AM -0800, Jim Mattson wrote:
> Apply reverse fir tree declaration order, wrap long lines, reformat a
> block comment, delete an extra blank line, and use BIT_ULL(10) instead
> of (1u << 10i).
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jon Cargille <jcargill@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 94ec089d6d1a..aff163192369 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4751,17 +4751,17 @@ static int handle_vmresume(struct kvm_vcpu *vcpu)
>  
>  static int handle_vmread(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long field;
> -	u64 field_value;
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> -	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> -	int len;
> -	gva_t gva = 0;
>  	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
>  						    : get_vmcs12(vcpu);
> +	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> +	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct x86_exception e;
> +	unsigned long field;
> +	u64 field_value;
> +	gva_t gva = 0;
>  	short offset;
> +	int len;
>  
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
> @@ -4776,7 +4776,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	/* Decode instruction info and find the field to read */
> -	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> +	field = kvm_register_readl(vcpu,
> +				   (((vmx_instruction_info) >> 28) & 0xf));

I find the current version to be more readable.  Alternatively, rename the
local variable to instr_info and eliminate several of these in one shot.

>  
>  	offset = vmcs_field_to_offset(field);
>  	if (offset < 0)
> @@ -4794,7 +4795,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  	 * Note that the number of bits actually copied is 32 or 64 depending
>  	 * on the guest's mode (32 or 64 bit), not on the given field's length.
>  	 */
> -	if (vmx_instruction_info & (1u << 10)) {
> +	if (vmx_instruction_info & BIT_ULL(10)) {

BIT_ULL() is overkill and inaccurate in a sense since instr_info is a
32-bit value.

>  		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
>  			field_value);
>  	} else {
> @@ -4803,7 +4804,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  				vmx_instruction_info, true, len, &gva))
>  			return 1;
>  		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
> -		if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
> +		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
> +						len, &e))

I'd prefer to let this poke out.

>  			kvm_inject_page_fault(vcpu, &e);
>  	}
>  
> @@ -4836,24 +4838,25 @@ static bool is_shadow_field_ro(unsigned long field)
>  
>  static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long field;
> -	int len;
> -	gva_t gva;
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
> +						    : get_vmcs12(vcpu);
>  	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
>  	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct x86_exception e;
> +	unsigned long field;
> +	short offset;
> +	gva_t gva;
> +	int len;
>  
> -	/* The value to write might be 32 or 64 bits, depending on L1's long
> +	/*
> +	 * The value to write might be 32 or 64 bits, depending on L1's long
>  	 * mode, and eventually we need to write that into a field of several
>  	 * possible lengths. The code below first zero-extends the value to 64
>  	 * bit (field_value), and then copies only the appropriate number of
>  	 * bits into the vmcs12 field.
>  	 */
>  	u64 field_value = 0;
> -	struct x86_exception e;
> -	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
> -						    : get_vmcs12(vcpu);
> -	short offset;
>  
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
> @@ -4867,7 +4870,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (vmx_instruction_info & (1u << 10))
> +	if (vmx_instruction_info & BIT_ULL(10))

Same thing here, BIT() is sufficient.

>  		field_value = kvm_register_readl(vcpu,
>  			(((vmx_instruction_info) >> 3) & 0xf));
>  	else {
> @@ -4881,8 +4884,8 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -
> -	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> +	field = kvm_register_readl(vcpu,
> +				   (((vmx_instruction_info) >> 28) & 0xf));
>  
>  	offset = vmcs_field_to_offset(field);
>  	if (offset < 0)
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 
