Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128356871DB
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjBAXZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBAXZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:25:00 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F7C7283
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:24:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so197041pjl.0
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/6eWRjWKiT+gMF2Kx54kumkGUgR4LPjtTyKTiPj5l0=;
        b=ckQjopjrhkWo6X7I571v3IxwHakCp+4z8GU9uuF7Y/Bjwp1koefwtOVL4LzKiFcJ9C
         XcHGNn1hCKhVYQeg8XhLchKFfSMN38z2M6Yj4CAHz6lLSJBaBcRvydMKDm1U27BRF8id
         tw+wAddPb3sS/YV7szeazVejE6Y3KFzlXjWRIHjH5cQJp+LoRrEDr5Lodp9Z5nZYYZtG
         mm9JVcsH1gEuW3vjtCypkhg+an2xzkI48Msdf7QLvicHGwE6bzrhc7X/hdhiagvbaGzh
         mIfbDUzRI0s7rYCfQp083m75Jy91TPdVW7I7kmZyf01Gqm9G30POTF5iR8/do5rLmN7D
         08nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/6eWRjWKiT+gMF2Kx54kumkGUgR4LPjtTyKTiPj5l0=;
        b=P2/aoyfedxoE2H6ZsY4W7BRapbdGY7oI26/bveimkOcBEJWPAt7VNnRg5HSj4ocm57
         i6xwZS5G8qPccevAfMiGWNP93wtAGowiGjeT5UtZWH+c6+ZtAVQ0doBhTGF1rBNHtuGi
         9zs+mW8zInfo9Rv5ml11DxSFEMs1Sn09Nw7uaT92wk73uyF5feyl92SHTe7Jb9XJmhPa
         aIBPCFHkVZb8BH7Z6M34+cDxJaZziVr/eUFMIqEWDrc4lGSROrEibon3edoKs4Z1ML04
         wtAMRzjaQYTKOb4tLRtGy+c+QJY8baPSx5iRwysGqKmFM5GUtoCIUEjU1/ShZqZzJ55h
         WIIw==
X-Gm-Message-State: AO0yUKX17CsEhTTP+2/Nd08vgN0kPaUCTDsKkot3yTXwTLcsztOl+n1c
        1Zpwm+K5Pfh5P5OBxkc8q469Hw==
X-Google-Smtp-Source: AK7set8Z/TpzonRQfgXFCS0rW4Tud6nVMBKkhAcojJ5fXlAhaL2OoO+ufoYoQ8/5jlrYaXFnGfhDKQ==
X-Received: by 2002:a17:902:b58a:b0:198:af4f:de08 with SMTP id a10-20020a170902b58a00b00198af4fde08mr131238pls.8.1675293871408;
        Wed, 01 Feb 2023 15:24:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000a0a00b00588fb6fafe0sm12006529pfh.188.2023.02.01.15.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:24:31 -0800 (PST)
Date:   Wed, 1 Feb 2023 23:24:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        m Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v4 12/13] KVM: selftests: Make vCPU exit reason test
 assertion common.
Message-ID: <Y9r0q9cuK/ifu+OW@google.com>
References: <20221212183720.4062037-1-vipinsh@google.com>
 <20221212183720.4062037-13-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212183720.4062037-13-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+all the other KVM selftests maintainers and reviewers

On Mon, Dec 12, 2022, Vipin Sharma wrote:
> Make TEST_ASSERT_KVM_EXIT_REASON() macro and replace all exit reason
> test assert statements with it.
> 
> No functional changes intended.
> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c |  4 +--
>  .../testing/selftests/kvm/include/test_util.h | 10 ++++++++
>  .../kvm/lib/s390x/diag318_test_handler.c      |  3 +--
>  .../selftests/kvm/s390x/sync_regs_test.c      | 15 +++--------
>  .../selftests/kvm/set_memory_region_test.c    |  6 +----
>  tools/testing/selftests/kvm/x86_64/amx_test.c |  8 +-----
>  .../kvm/x86_64/cr4_cpuid_sync_test.c          |  8 +-----
>  .../testing/selftests/kvm/x86_64/debug_regs.c |  2 +-
>  .../selftests/kvm/x86_64/flds_emulation.h     |  5 +---
>  .../selftests/kvm/x86_64/hyperv_clock.c       |  7 +-----
>  .../selftests/kvm/x86_64/hyperv_evmcs.c       |  8 +-----
>  .../selftests/kvm/x86_64/hyperv_features.c    | 14 ++---------
>  .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  6 +----
>  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  7 +-----
>  .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 14 ++---------
>  .../selftests/kvm/x86_64/kvm_clock_test.c     |  5 +---
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +---
>  .../selftests/kvm/x86_64/monitor_mwait_test.c |  9 +------
>  .../kvm/x86_64/nested_exceptions_test.c       |  5 +---
>  .../selftests/kvm/x86_64/platform_info_test.c | 14 +++--------
>  .../kvm/x86_64/pmu_event_filter_test.c        |  6 +----
>  tools/testing/selftests/kvm/x86_64/smm_test.c |  9 +------
>  .../testing/selftests/kvm/x86_64/state_test.c |  8 +-----
>  .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  8 +-----
>  .../kvm/x86_64/svm_nested_shutdown_test.c     |  7 +-----
>  .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +----
>  .../selftests/kvm/x86_64/svm_vmcall_test.c    |  6 +----
>  .../selftests/kvm/x86_64/sync_regs_test.c     | 25 ++++---------------
>  .../kvm/x86_64/triple_fault_event_test.c      |  9 ++-----
>  .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  6 +----
>  .../kvm/x86_64/ucna_injection_test.c          | 22 +++-------------
>  .../selftests/kvm/x86_64/userspace_io_test.c  |  6 +----
>  .../kvm/x86_64/userspace_msr_exit_test.c      | 22 +++-------------
>  .../kvm/x86_64/vmx_apic_access_test.c         | 11 ++------
>  .../kvm/x86_64/vmx_close_while_nested_test.c  |  5 +---
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  7 +-----
>  .../vmx_exception_with_invalid_guest_state.c  |  4 +--
>  .../x86_64/vmx_invalid_nested_guest_state.c   |  4 +--
>  .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  6 +----
>  .../kvm/x86_64/vmx_preemption_timer_test.c    |  8 +-----
>  .../kvm/x86_64/vmx_tsc_adjust_test.c          |  6 +----
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |  6 +----
>  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  7 +-----
>  .../selftests/kvm/x86_64/xen_vmcall_test.c    |  5 +---
>  44 files changed, 71 insertions(+), 293 deletions(-)

I love the cleanup, but in the future, please don't squeeze KVM-wide changes in
the middle of an otherwise arch-specific series unless it's absolutely necessary.
I get why you added the macro before copy-pasting more code into a new test, but
the unfortunate side effect is that complicates grabbing the entire series.

And incorporate ./scripts/get_maintainer.pl into your workflow, the other KVM
selftests folks need to be in the loop for these types of changes.

> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 80d6416f3012..3f15f216d2a6 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -63,6 +63,16 @@ void test_assert(bool exp, const char *exp_str,
>  		    #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
>  } while (0)
>  
> +#define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected_exit_reason)		\
> +({									\

Unless the macro needs to "return" a value, do-while(0) is generally preferred.

> +	__u32 exit_reason = (vcpu)->run->exit_reason;			\
> +									\
> +	TEST_ASSERT(exit_reason == (expected_exit_reason),		\
> +		    "Unexpected exit reason: %u (%s)",			\

This "needs" to opportunistically enhance the message to spit out the expected
reason, and to clarify that it's a KVM exit reason.  In the open coded form, the
expected reason is _usually_ captured in the assertion, but that's not guaranteed,
e.g. if it's not hardcoded.  But with the common code, the expected exit reason
will generally get resolved into its literal, which isn't very human friendly.

And even when it is provided, I find it annoying to have to search back a few
lines to understand what failed.

E.g. the new macro yields "x86_64/hyperv_evmcs.c:269: exit_reason == (2)".

> +		    exit_reason,					\
> +		    exit_reason_str(exit_reason));			\

No need to put these on separate lines.

How about this?

#define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected)			\
do {									\
	__u32 exit_reason = (vcpu)->run->exit_reason;			\
									\
	TEST_ASSERT(exit_reason == (expected),				\
		    "Wanted KVM exit reason: %u (%s), got: %u (%s)",	\
		    expected, exit_reason_str(expected),		\
		    exit_reason, exit_reason_str(exit_reason));		\
} while (0)

which yields errors like:

==== Test Assertion Failure ====
  x86_64/hyperv_extended_hypercalls.c:71: exit_reason == (2)
  pid=108104 tid=108104 errno=0 - Success
     1	0x0000000000401793: main at hyperv_extended_hypercalls.c:71
     2	0x00000000004148b3: __libc_start_call_main at libc-start.o:?
     3	0x0000000000415eff: __libc_start_main_impl at ??:?
     4	0x00000000004018f0: _start at ??:?
  Wanted KVM exit reason: 2 (IO), got: 27 (HYPERV)

On a related topic, exit_reason_str() is a bit stale and also annoying to update.
Can you fold in the below when you send v2 of this patch?  And then if you're
feeling ambititous, add another patch to update the array?

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 1 Feb 2023 23:17:19 +0000
Subject: [PATCH] KVM: selftests: Add macro to generate KVM exit reason strings

Add and use a macro to generate the KVM exit reason strings array instead
of relying on developers to correctly copy+paste+edit each string.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 55 ++++++++++++----------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f25b3e9b5a07..b3682b25eedf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1815,38 +1815,41 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		vcpu_dump(stream, vcpu, indent + 2);
 }
 
+#define KVM_EXIT_STRING(x) {KVM_EXIT_##x, #x}
+
 /* Known KVM exit reasons */
 static struct exit_reason {
 	unsigned int reason;
 	const char *name;
 } exit_reasons_known[] = {
-	{KVM_EXIT_UNKNOWN, "UNKNOWN"},
-	{KVM_EXIT_EXCEPTION, "EXCEPTION"},
-	{KVM_EXIT_IO, "IO"},
-	{KVM_EXIT_HYPERCALL, "HYPERCALL"},
-	{KVM_EXIT_DEBUG, "DEBUG"},
-	{KVM_EXIT_HLT, "HLT"},
-	{KVM_EXIT_MMIO, "MMIO"},
-	{KVM_EXIT_IRQ_WINDOW_OPEN, "IRQ_WINDOW_OPEN"},
-	{KVM_EXIT_SHUTDOWN, "SHUTDOWN"},
-	{KVM_EXIT_FAIL_ENTRY, "FAIL_ENTRY"},
-	{KVM_EXIT_INTR, "INTR"},
-	{KVM_EXIT_SET_TPR, "SET_TPR"},
-	{KVM_EXIT_TPR_ACCESS, "TPR_ACCESS"},
-	{KVM_EXIT_S390_SIEIC, "S390_SIEIC"},
-	{KVM_EXIT_S390_RESET, "S390_RESET"},
-	{KVM_EXIT_DCR, "DCR"},
-	{KVM_EXIT_NMI, "NMI"},
-	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
-	{KVM_EXIT_OSI, "OSI"},
-	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
-	{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
-	{KVM_EXIT_X86_RDMSR, "RDMSR"},
-	{KVM_EXIT_X86_WRMSR, "WRMSR"},
-	{KVM_EXIT_XEN, "XEN"},
-	{KVM_EXIT_HYPERV, "HYPERV"},
+	KVM_EXIT_STRING(UNKNOWN),
+	KVM_EXIT_STRING(EXCEPTION),
+	KVM_EXIT_STRING(IO),
+	KVM_EXIT_STRING(HYPERCALL),
+	KVM_EXIT_STRING(DEBUG),
+	KVM_EXIT_STRING(HLT),
+	KVM_EXIT_STRING(MMIO),
+	KVM_EXIT_STRING(IRQ_WINDOW_OPEN),
+	KVM_EXIT_STRING(SHUTDOWN),
+	KVM_EXIT_STRING(FAIL_ENTRY),
+	KVM_EXIT_STRING(INTR),
+	KVM_EXIT_STRING(SET_TPR),
+	KVM_EXIT_STRING(TPR_ACCESS),
+	KVM_EXIT_STRING(S390_SIEIC),
+	KVM_EXIT_STRING(S390_RESET),
+	KVM_EXIT_STRING(DCR),
+	KVM_EXIT_STRING(NMI),
+	KVM_EXIT_STRING(INTERNAL_ERROR),
+	KVM_EXIT_STRING(OSI),
+	KVM_EXIT_STRING(PAPR_HCALL),
+	KVM_EXIT_STRING(DIRTY_RING_FULL),
+	KVM_EXIT_STRING(X86_RDMSR),
+	KVM_EXIT_STRING(X86_WRMSR),
+	KVM_EXIT_STRING(XEN),
+	KVM_EXIT_STRING(HYPERV),
+
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
-	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
+	KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
 #endif
 };
 

base-commit: b20015517a2c6b45bafa09aee45d1698f91428d6
-- 

