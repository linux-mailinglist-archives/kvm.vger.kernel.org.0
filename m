Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F253F34A35
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfFDOVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 10:21:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:39356 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbfFDOVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 10:21:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 07:21:09 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2019 07:21:08 -0700
Date:   Tue, 4 Jun 2019 07:21:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 2/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit
 control on vmentry of nested guests
Message-ID: <20190604142108.GQ13384@linux.intel.com>
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
 <20190522234545.5930-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190522234545.5930-3-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 07:45:45PM -0400, Krish Sadhukhan wrote:
>  ..to verify KVM performs the appropriate consistency checks for loading
>    IA32_EFER VM-exit control as part of running a nested guest.
> 
> According to section "Checks on Host Control Registers and MSRs" in Intel
> SDM vol 3C, the following checks are performed on vmentry of nested guests:
> 
>    If the “load IA32_EFER” VM-exit control is 1, bits reserved in the
>    IA32_EFER MSR must be 0 in the field for that register. In addition,
>    the values of the LMA and LME bits in the field must each be that of
>    the “host address-space size” VM-exit control.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  x86/vmx_tests.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 8cb1708..32fa16d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5136,6 +5136,126 @@ static void test_guest_perf_global_ctl(void)
>  			     ENT_CONTROLS, ENT_LOAD_PERF);
>  }
>  
> +static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
> +			   u64 ctrl_bit, u64 efer_bit,
> +			   const char *efer_bit_name)

IMO, the benefits of genericizing this for potential reuse to test
GUEST_EFER is outweighed by the added difficulty to read the code.
And the function can't be reused as is, e.g. the host_addr_size is
host specific, as is the error condition.

> +{
> +	u64 efer_saved = vmcs_read(fld);
> +	u32 ctrl_saved = vmcs_read(ctrl_fld);
> +	u64 host_addr_size = ctrl_saved & EXI_HOST_64;

The nVMX tests are 64-bit only, i.e. host_addr_size will always be true.
We can explicitly test host_addr_size == 0, but only for VM-Fail cases.

> +	u64 efer;
> +
> +	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
> +	efer = efer_saved & ~efer_bit;
> +	vmcs_write(fld, efer);
> +	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
> +			    fld_name, efer);
> +	test_vmx_vmlaunch(0, false);
> +	report_prefix_pop();
> +
> +	efer = efer_saved | efer_bit;
> +	vmcs_write(fld, efer);
> +	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
> +			    fld_name, efer);
> +	test_vmx_vmlaunch(0, false);
> +	report_prefix_pop();
> +
> +	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
> +	efer = efer_saved & ~efer_bit;
> +	vmcs_write(fld, efer);
> +	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
> +			    fld_name, efer);
> +	if (host_addr_size)
> +		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> +				  false);
> +	else
> +		test_vmx_vmlaunch(0, false);
> +	report_prefix_pop();
> +
> +	efer = efer_saved | efer_bit;
> +	vmcs_write(fld, efer);
> +	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
> +			    fld_name, efer);
> +	if (host_addr_size)
> +		test_vmx_vmlaunch(0, false);
> +	else
> +		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> +				  false);
> +	report_prefix_pop();
> +
> +	vmcs_write(ctrl_fld, ctrl_saved);
> +	vmcs_write(fld, efer_saved);
> +}
> +
> +static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
> +		      u64 ctrl_bit)
> +{
> +	u64 efer_saved = vmcs_read(fld);
> +	u32 ctrl_saved = vmcs_read(ctrl_fld);
> +	u64 efer_reserved_bits =  ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
> +	u64 i;
> +	u64 efer;
> +
> +	if (efer_nx_enabled())
> +		efer_reserved_bits &= ~EFER_NX;
> +
> +	/*
> +	 * Check reserved bits
> +	 */
> +	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
> +	for (i = 0; i < 64; i++) {
> +		if ((1ull << i) & efer_reserved_bits) {
> +			efer = efer_saved | (1ull << i);
> +			vmcs_write(fld, efer);
> +			report_prefix_pushf("%s %lx", fld_name, efer);
> +			test_vmx_vmlaunch(0, false);
> +			report_prefix_pop();
> +		}
> +	}

Eh, this feels like a waste of 63 VMLAUNCHes.  My vote would be to do a
single VMLAUNCH with all reserved bits set and the control disabled.

> +	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
> +	for (i = 0; i < 64; i++) {
> +		if ((1ull << i) & efer_reserved_bits) {
> +			efer = efer_saved | (1ull << i);
> +			vmcs_write(fld, efer);
> +			report_prefix_pushf("%s %lx", fld_name, efer);
> +			test_vmx_vmlaunch(
> +				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
> +				false);
> +			report_prefix_pop();
> +		}
> +	}
> +
> +	vmcs_write(ctrl_fld, ctrl_saved);
> +	vmcs_write(fld, efer_saved);
> +
> +	/*
> +	 * Check LMA and LME bits
> +	 */
> +	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LMA,
> +		      "EFER_LMA");
> +	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LME,
> +		      "EFER_LME");
> +}
> +
> +/*
> + * If the “load IA32_EFER” VM-exit control is 1, bits reserved in the
> + * IA32_EFER MSR must be 0 in the field for that register. In addition,
> + * the values of the LMA and LME bits in the field must each be that of
> + * the “host address-space size” VM-exit control.
> + *
> + *  [Intel SDM]
> + */
> +static void test_host_efer(void)
> +{
> +	if (!(ctrl_exit_rev.clr & EXI_LOAD_EFER)) {
> +		printf("\"Load-IA32-EFER\" exit control not supported\n");
> +		return;
> +	}
> +
> +	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
> +}
> +
>  /*
>   * PAT values higher than 8 are uninteresting since they're likely lumped
>   * in with "8". We only test values above 8 one bit at a time,
> @@ -5268,6 +5388,7 @@ static void vmx_host_state_area_test(void)
>  	test_sysenter_field(HOST_SYSENTER_ESP, "HOST_SYSENTER_ESP");
>  	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
>  
> +	test_host_efer();
>  	test_host_perf_global_ctl();
>  	test_load_host_pat();
>  }
> -- 
> 2.20.1
> 
