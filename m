Return-Path: <kvm+bounces-54375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DFCB200AA
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B96561746FD
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 07:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7E92DAFB1;
	Mon, 11 Aug 2025 07:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iTQt2Qvq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BB92D94A8
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 07:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754898462; cv=none; b=QR+pNajQGno9x5RJYYdXEq3a8SxvXcTihOy7nGzehB6N+Wo6C59REAxqVesL8IO4sByggC2dAIiu5tDETda2hgCIIzGL4KyF03cGqPaX1XlQyJ7tWXuaE6oelgcpRxodiX29mjbkBpwPgUHGDHAfcVB+KWgwN3PsGyO/Ny4fbF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754898462; c=relaxed/simple;
	bh=UNVSs8GehkxpQlMuN5aTq7mBpnNtPYtFeHJ/WozzYH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PpD8SvcDllOCSoirWuLnxXKIqxpqU0pKsCrrhiihmKd8/IueJ0uM47SjMiRWVu195V/VOc3ApH7MbFg83ovjl0sFQMFxPK+uNI+w7K+Zljcyq6PImGnCV5Zqz6KHhMaHWTfmtsmYBFsmxnRZi8E3DnfkTX8wxf5NNN1JfTZg/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iTQt2Qvq; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754898460; x=1786434460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UNVSs8GehkxpQlMuN5aTq7mBpnNtPYtFeHJ/WozzYH8=;
  b=iTQt2Qvq4MD0TgkAzBLfOG3J1mWVkNTPJ9TBuFFh8o9TEdKBS5BSuhe6
   PKBB9dSpaBaGe8wMuzOGh3AnEvHKmXSG8zJ6MFwFFSLo0FpU3gaEJ6wcp
   95WCfTdTW9MrZaD68I2dSd0HRvrqyVi2s7lzOfuBVx1bRIsMXFIBtifgZ
   bzeajnQwk9clNuW+yMy68W5p/MrgERb1Qw+ZIbzGJ0iZ0mkqY8y8Q4Cyn
   SXZGIyp7ctmGXp/aT3U8uT+MntRUpGbwcRDz9FzL2WDgXaa/30hXmIlbz
   yOUt/tzx2FhuMCXc6MYrN3wdiuoj2MlzrN3/d9mlo+YgnXXcudaaGNRVw
   A==;
X-CSE-ConnectionGUID: R+FryjJJRMmQ6whHVpNiqQ==
X-CSE-MsgGUID: 1NRTiCREQKiJe4J+0AwQ+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57065230"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57065230"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:47:38 -0700
X-CSE-ConnectionGUID: CC5DJByzRSe3ZspcCPwogg==
X-CSE-MsgGUID: kc1Jo6RuQDaAtwSJOulXMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165086469"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 00:47:37 -0700
Message-ID: <9f1ba406-7638-44e5-bf0d-8aa27be24a59@intel.com>
Date: Mon, 11 Aug 2025 15:47:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/2] nVMX: Test IA32_DEBUGCTLMSR behavior
 on set and cleared save/load debug controls
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
 <20250811063035.12626-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250811063035.12626-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/11/2025 2:30 PM, Chenyi Qiang wrote:
> Besides the existing DR7 test on debug controls, introduce a similar
> separate test for IA32_DEBUGCTLMSR.
> 
> Previously, the IA32_DEBUGCTLMSR was combined with the DR7 test. However,
> it attempted to access the LBR and BTF bits in the MSR which can be
> invalid. Although KVM will exempt these two bits from validity check,
> they will be cleared and resulted in the unexpected MSR value.

Initially, LBR (bit 0) and BTF(bit 1) have been allowed to write by the 
guest but the value are dropped, as the workaround to not break some OS 
that writes to the MSR unconditionally.

BTF never gets supported by KVM. While LBR gained support but it depends 
on PMU and LBR being exposed to the guest, which requires additional 
parameters to the test configuration.

On the other hand, DEBUGCTLMSR_BUS_LOCK_DETECT chosen by this patch 
doesn't require additional parameter, but it requires the hardware 
support of the feature. IIRC, it needs to be SPR and later. So it has 
less coverage of hardwares than LBR.

I'm not sure the preference of Sean/Paolo. Let's see what they would say.

> In this new test, access a valid bit (DEBUGCTLMSR_BUS_LOCK_DETECT, bit 2)
> based on the enumration of Bus Lock Detect.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   x86/vmx_tests.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 88 insertions(+)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 1832bda3..9a2e598f 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1944,6 +1944,92 @@ static int dbgctls_dr7_exit_handler(union exit_reason exit_reason)
>   	return VMX_TEST_VMEXIT;
>   }
>   
> +static int dbgctls_msr_init(struct vmcs *vmcs)
> +{
> +	/* Check for DEBUGCTLMSR_BUS_LOCK_DETECT(bit 2) in IA32_DEBUGCTLMSR */
> +	if (!(cpuid(7).c & (1 << 24))) {
> +		report_skip("%s : \"Bus Lock Detect\" not supported", __func__);
> +		return VMX_TEST_VMSKIP;
> +	}
> +
> +	msr_bmp_init();
> +	wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
> +	vmcs_write(GUEST_DEBUGCTL, 0x4);
> +
> +	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
> +	vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_SAVE_DBGCTLS);
> +
> +	return VMX_TEST_START;
> +}
> +
> +static void dbgctls_msr_main(void)
> +{
> +	u64 debugctl;
> +
> +	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	report(debugctl == 0x4, "DEBUGCTLMSR: Load debug controls");
> +
> +	vmx_set_test_stage(0);
> +	vmcall();
> +	report(vmx_get_test_stage() == 1, "DEBUGCTLMSR: Save debug controls");
> +
> +	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
> +	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
> +		printf("\tDebug controls are always loaded/saved\n");
> +		return;
> +	}
> +	vmx_set_test_stage(2);
> +	vmcall();
> +
> +	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	report(debugctl == 0x0,
> +	       "DEBUGCTLMSR: Guest=host debug controls");
> +
> +	vmx_set_test_stage(3);
> +	vmcall();
> +	report(vmx_get_test_stage() == 4, "DEBUGCTLMSR: Don't save debug controls");
> +}
> +
> +static int dbgctls_msr_exit_handler(union exit_reason exit_reason)
> +{
> +	u32 insn_len = vmcs_read(EXI_INST_LEN);
> +	u64 guest_rip = vmcs_read(GUEST_RIP);
> +	u64 debugctl;
> +
> +	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +
> +	switch (exit_reason.basic) {
> +	case VMX_VMCALL:
> +		switch (vmx_get_test_stage()) {
> +		case 0:
> +			if (debugctl == 0 &&
> +			    vmcs_read(GUEST_DEBUGCTL) == 0x4)
> +				vmx_inc_test_stage();
> +			break;
> +		case 2:
> +			wrmsr(MSR_IA32_DEBUGCTLMSR, 0x0);
> +			vmcs_write(GUEST_DEBUGCTL, 0x4);
> +
> +			vmcs_write(ENT_CONTROLS,
> +				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
> +			vmcs_write(EXI_CONTROLS,
> +				vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_DBGCTLS);
> +			break;
> +		case 3:
> +			if (debugctl == 0 &&
> +			    vmcs_read(GUEST_DEBUGCTL) == 0x4)
> +				vmx_inc_test_stage();
> +			break;
> +		}
> +		vmcs_write(GUEST_RIP, guest_rip + insn_len);
> +		return VMX_TEST_RESUME;
> +	default:
> +		report_fail("Unknown exit reason, %d", exit_reason.full);
> +		print_vmexit_info(exit_reason);
> +	}
> +	return VMX_TEST_VMEXIT;
> +}
> +
>   struct vmx_msr_entry {
>   	u32 index;
>   	u32 reserved;
> @@ -11386,6 +11472,8 @@ struct vmx_test vmx_tests[] = {
>   		nmi_hlt_exit_handler, NULL, {0} },
>   	{ "debug controls dr7", dbgctls_dr7_init, dbgctls_dr7_main, dbgctls_dr7_exit_handler,
>   		NULL, {0} },
> +	{ "debug controls msr", dbgctls_msr_init, dbgctls_msr_main, dbgctls_msr_exit_handler,
> +		NULL, {0} },
>   	{ "MSR switch", msr_switch_init, msr_switch_main,
>   		msr_switch_exit_handler, NULL, {0}, msr_switch_entry_failure },
>   	{ "vmmcall", vmmcall_init, vmmcall_main, vmmcall_exit_handler, NULL, {0} },


