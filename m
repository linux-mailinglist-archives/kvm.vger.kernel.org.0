Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EE5443E5
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbiFIGhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiFIGhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:37:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0683538A9;
        Wed,  8 Jun 2022 23:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654756650; x=1686292650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nB84bST6OWA2i2UWChU3Gj5mIQYNBPcDY5KPN5CMvG0=;
  b=Ni5PY9ExNXLray1p/74gB5WwmH5o0arUDhsq5uDHS/MSDPlLl4OEAtuj
   1Ar/rwJJQuLtO4yR4td6Yyr8KDAmdLIdkL+eZFUGrg/tEfqqWQpklWDlF
   fcmyZaJ2H5p9yo1sZJjtEApAjTtsbqHmKUvgB2PQS+t4TWB2de2BxdH9C
   uRLe0AQzV5CsP5KLmy/Qjiuc0WtxMvZ+HToFF1NvTsaztLmpo20Ss903n
   8n2uM1XwIhTNyKcTOq7AxTxE4JMLZROJahy88p4FWVdrd85VdwLY7bteD
   esIOky1WoutPYzT9PcQIR9A1UKDs9M2fh7+5DHU8H4hqkZosHNicAinVT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="274692683"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="274692683"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="637295074"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2022 23:37:20 -0700
Date:   Thu, 9 Jun 2022 14:37:20 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: selftests: Add MONITOR/MWAIT quirk test
Message-ID: <20220609063720.wf4famdgoucbglnq@yy-desk-7060>
References: <20220608224516.3788274-1-seanjc@google.com>
 <20220608224516.3788274-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608224516.3788274-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022 at 10:45:16PM +0000, Sean Christopherson wrote:
> Add a test to verify the "MONITOR/MWAIT never fault" quirk, and as a
> bonus, also verify the related "MISC_ENABLES ignores ENABLE_MWAIT" quirk.
>
> If the "never fault" quirk is enabled, MONITOR/MWAIT should always be
> emulated as NOPs, even if they're reported as disabled in guest CPUID.
> Use the MISC_ENABLES quirk to coerce KVM into toggling the MWAIT CPUID
> enable, as KVM now disallows manually toggling CPUID bits after running
> the vCPU.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/monitor_mwait_test.c | 127 ++++++++++++++++++
>  3 files changed, 129 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 0ab0e255d292..1a56522f009c 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -27,6 +27,7 @@
>  /x86_64/hyperv_svm_test
>  /x86_64/max_vcpuid_cap_test
>  /x86_64/mmio_warning_test
> +/x86_64/monitor_mwait_test
>  /x86_64/platform_info_test
>  /x86_64/pmu_event_filter_test
>  /x86_64/set_boot_cpu_id
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 9a256c1f1bdf..bbbfdeb7ee9b 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> +TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
>  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
>  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
>  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
> diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> new file mode 100644
> index 000000000000..b9af8e29721e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +enum monitor_mwait_testcases {
> +	MWAIT_QUIRK_DISABLED = BIT(0),
> +	MISC_ENABLES_QUIRK_DISABLED = BIT(1),
> +	MWAIT_DISABLED = BIT(2),
> +};
> +
> +static void guest_monitor_wait(int testcase)
> +{
> +	/*
> +	 * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD,
> +	 * in all other scenarios KVM should emulate them as nops.
> +	 */
> +	bool fault_wanted = (testcase & MWAIT_QUIRK_DISABLED) &&
> +			    (testcase & MWAIT_DISABLED);
> +	u8 vector;
> +
> +	GUEST_SYNC(testcase);
> +
> +	vector = kvm_asm_safe("monitor");
> +	if (fault_wanted)
> +		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
> +	else
> +		GUEST_ASSERT_2(!vector, testcase, vector);
> +
> +	vector = kvm_asm_safe("monitor");

emmm... should one of the "monitor" be "mwait" ?

> +	if (fault_wanted)
> +		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
> +	else
> +		GUEST_ASSERT_2(!vector, testcase, vector);
> +}
> +
> +static void guest_code(void)
> +{
> +	guest_monitor_wait(MWAIT_DISABLED);
> +
> +	guest_monitor_wait(MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
> +
> +	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_DISABLED);
> +	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED);
> +
> +	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED | MWAIT_DISABLED);
> +	guest_monitor_wait(MISC_ENABLES_QUIRK_DISABLED | MWAIT_QUIRK_DISABLED);
> +
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	uint64_t disabled_quirks;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	int testcase;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_DISABLE_QUIRKS2));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_MWAIT);
> +
> +	run = vcpu->run;
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +
> +	while (1) {
> +		vcpu_run(vcpu);
> +
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Unexpected exit reason: %u (%s),\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			testcase = uc.args[1];
> +			break;
> +		case UCALL_ABORT:
> +			TEST_FAIL("%s at %s:%ld, testcase = %lx, vector = %ld",
> +				  (const char *)uc.args[0], __FILE__,
> +				  uc.args[1], uc.args[2], uc.args[3]);
> +			goto done;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +			goto done;
> +		}
> +
> +		disabled_quirks = 0;
> +		if (testcase & MWAIT_QUIRK_DISABLED)
> +			disabled_quirks |= KVM_X86_QUIRK_MWAIT_NEVER_FAULTS;
> +		if (testcase & MISC_ENABLES_QUIRK_DISABLED)
> +			disabled_quirks |= KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT;
> +		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, disabled_quirks);
> +
> +		/*
> +		 * If the MISC_ENABLES quirk (KVM neglects to update CPUID to
> +		 * enable/disable MWAIT) is disabled, toggle the ENABLE_MWAIT
> +		 * bit in MISC_ENABLES accordingly.  If the quirk is enabled,
> +		 * the only valid configuration is MWAIT disabled, as CPUID
> +		 * can't be manually changed after running the vCPU.
> +		 */
> +		if (!(testcase & MISC_ENABLES_QUIRK_DISABLED)) {
> +			TEST_ASSERT(testcase & MWAIT_DISABLED,
> +				    "Can't toggle CPUID features after running vCPU");
> +			continue;
> +		}
> +
> +		vcpu_set_msr(vcpu, MSR_IA32_MISC_ENABLE,
> +			     (testcase & MWAIT_DISABLED) ? 0 : MSR_IA32_MISC_ENABLE_MWAIT);
> +	}
> +
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> --
> 2.36.1.255.ge46751e96f-goog
>
