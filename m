Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070F727BB72
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 05:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbgI2DVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 23:21:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:56113 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgI2DVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 23:21:24 -0400
IronPort-SDR: 504y/LCfIGTGlSgE3yT/EViSWj7lle61FwWbAMyZ/Oy4GAbFBGcpQ324amPl0NPIowLXiIWkHl
 melI9VfdTTJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="246841671"
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="246841671"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:21:23 -0700
IronPort-SDR: hD0R5aNKsx7VJQxeF/PJDsMQIVzs5Cspp5A8UKp2err7yykVMytonoVNDR5hKAjT6N+lueCpab
 KAy4NPpmZYGQ==
X-IronPort-AV: E=Sophos;i="5.77,316,1596524400"; 
   d="scan'208";a="324517086"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 20:21:23 -0700
Date:   Mon, 28 Sep 2020 20:21:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/3 v3] nVMX: Test vmentry of unrestricted (unpaged
 protected) nested guest
Message-ID: <20200929032122.GF31514@linux.intel.com>
References: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
 <20200921081027.23047-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921081027.23047-4-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 08:10:27AM +0000, Krish Sadhukhan wrote:
> According to section "UNRESTRICTED GUESTS" in SDM vol 3c, if the
> "unrestricted guest" secondary VM-execution control is set, guests can run
> in unpaged protected mode or in real mode. This patch tests vmetnry of an
> unrestricted guest in unpaged protected mode.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

SOB chain is wrong.  Missing a Co-developed-by?  Or is Jim supposed to be
the author?

> ---
>  x86/vmx.c       |  2 +-
>  x86/vmx.h       |  1 +
>  x86/vmx_tests.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 07415b4..1a84a74 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1699,7 +1699,7 @@ static void test_vmx_caps(void)
>  }
>  
>  /* This function can only be called in guest */
> -static void __attribute__((__used__)) hypercall(u32 hypercall_no)
> +void __attribute__((__used__)) hypercall(u32 hypercall_no)
>  {
>  	u64 val = 0;
>  	val = (hypercall_no & HYPERCALL_MASK) | HYPERCALL_BIT;
> diff --git a/x86/vmx.h b/x86/vmx.h
> index d1c2436..e29301e 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -895,6 +895,7 @@ bool ept_ad_bits_supported(void);
>  void __enter_guest(u8 abort_flag, struct vmentry_result *result);
>  void enter_guest(void);
>  void enter_guest_with_bad_controls(void);
> +void hypercall(u32 hypercall_no);
>  
>  typedef void (*test_guest_func)(void);
>  typedef void (*test_teardown_func)(void *data);
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 22f0c7b..1cadc56 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -8029,6 +8029,53 @@ static void vmx_guest_state_area_test(void)
>  	enter_guest();
>  }
>  
> +extern void unrestricted_guest_main(void);
> +asm (".code32\n"
> +	"unrestricted_guest_main:\n"
> +	"vmcall\n"
> +	"nop\n"
> +	"mov $1, %edi\n"
> +	"call hypercall\n"
> +	".code64\n");
> +
> +static void setup_unrestricted_guest(void)
> +{
> +	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) & ~(X86_CR0_PG));
> +	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) & ~ENT_GUEST_64);
> +	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) & ~EFER_LMA);
> +	vmcs_write(GUEST_RIP, virt_to_phys(unrestricted_guest_main));
> +}
> +
> +static void unsetup_unrestricted_guest(void)
> +{
> +	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) | X86_CR0_PG);
> +	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_GUEST_64);
> +	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) | EFER_LMA);
> +	vmcs_write(GUEST_RIP, (u64) phys_to_virt(vmcs_read(GUEST_RIP)));
> +	vmcs_write(GUEST_RSP, (u64) phys_to_virt(vmcs_read(GUEST_RSP)));
> +}
> +
> +/*
> + * If "unrestricted guest" secondary VM-execution control is set, guests
> + * can run in unpaged protected mode.
> + */
> +static void vmentry_unrestricted_guest_test(void)
> +{
> +	test_set_guest(unrestricted_guest_main);
> +	setup_unrestricted_guest();
> +	if (setup_ept(false))
> +		test_skip("EPT not supported");
> +       vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | CPU_URG);
> +       test_guest_state("Unrestricted guest test", false, CPU_URG, "CPU_URG");

Indentation looks funky.

> +
> +	/*
> +	 * Let the guest finish execution as a regular guest
> +	 */
> +	unsetup_unrestricted_guest();
> +	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) & ~CPU_URG);
> +	enter_guest();
> +}
> +
>  static bool valid_vmcs_for_vmentry(void)
>  {
>  	struct vmcs *current_vmcs = NULL;
> @@ -10234,6 +10281,7 @@ struct vmx_test vmx_tests[] = {
>  	TEST(vmx_host_state_area_test),
>  	TEST(vmx_guest_state_area_test),
>  	TEST(vmentry_movss_shadow_test),
> +	TEST(vmentry_unrestricted_guest_test),
>  	/* APICv tests */
>  	TEST(vmx_eoi_bitmap_ioapic_scan_test),
>  	TEST(vmx_hlt_with_rvi_test),
> -- 
> 2.18.4
> 
