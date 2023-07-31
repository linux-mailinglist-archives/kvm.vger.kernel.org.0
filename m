Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49B4769C8B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjGaQcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjGaQcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:32:09 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60F51998
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:32:05 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99bdcade7fbso611860866b.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690821124; x=1691425924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSWRC6XbP9Lzf2RUR+88p43812yGhT9wGIsBh6+Oxe8=;
        b=pHF/+dHlLBTHSunlTT0kqJJKOAYyTNCCrVLhGoh/d9Z0Z6d6tEHiqRD5gFOESCytHz
         XuKCFfy08U3uhycytlJow93aji4SuOYJOtM0Z0IlSvv9n2x8PN+eLmr6lM+OVXwE/9j2
         OqR727EBGzws1u38N1S7RzJIe/SsGnmUmcbSLOg9rwEthSQSdsB/3Kz7nfZgXvCwY1K0
         j7JrjU6uYf0n9WR0ylnrEQJuLe0QHvVeTsKhCSnlfdUdN1ZpPE1WjMrZchsYgMnlNBZ9
         ZftcyixKNTam1oA+YmaAHzVZP0Gkue3lt7Am7WAIweR2KnzbRluSlcrPs3Rj7C0JS06Y
         69tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690821124; x=1691425924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSWRC6XbP9Lzf2RUR+88p43812yGhT9wGIsBh6+Oxe8=;
        b=NE8G8CgrNqeohqTCvxxq/cOtwaWyH3Lk2bCim8orv0lEO/TqikYvxJAOhIn/YfnbkX
         LpG9PYnFulQ555OuF1suGbaMxB9Vs37uedTw2TG4ZDabsE6fgo6XJ2kuT5Pw1buXzoBZ
         Cw1ZPZjOpCfKGxRw6CoJNSSs62bc58ue8X6+Z5NMRgQIkx9vZSyleQudevpxlLRb53sd
         WpOgDjpSdhMKnqaSKu5F1VDyNofdllkhanpD29vtSJXEjjx8CaYxdAhqXxK7kofgfSIv
         CwMr0qEx547+kl1otvCQu0I2kCwiugL5nlvP9Rh+i/6oOZg1LnZlBBdLMo3ECZ444MO1
         EIqg==
X-Gm-Message-State: ABy/qLbycEUGQ3EHmK13EGJvGOZSPiV2Vheh+EywA6GeYQR+u1SG4oY5
        +qwTDqF/7oVNBkqwUhHYXQ8MyQ==
X-Google-Smtp-Source: APBJJlELCwb2ZaGhlBAwWr1JohEHQiHCPrJ54oEHYYkr8uhp41hA+eoLldKwEfbFpDKCDf1sS4vIUg==
X-Received: by 2002:a17:906:224b:b0:99b:8c6f:f3af with SMTP id 11-20020a170906224b00b0099b8c6ff3afmr279982ejr.12.1690821124338;
        Mon, 31 Jul 2023 09:32:04 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id lz19-20020a170906fb1300b0099bd1a78ef5sm6367295ejb.74.2023.07.31.09.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 09:32:04 -0700 (PDT)
Date:   Mon, 31 Jul 2023 18:32:03 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4 09/34] KVM: selftests: Add a selftest for guest prints
 and formatted asserts
Message-ID: <20230731-91b64a6b787ba7e23b285785@orel>
References: <20230729003643.1053367-1-seanjc@google.com>
 <20230729003643.1053367-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230729003643.1053367-10-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 05:36:18PM -0700, Sean Christopherson wrote:
> From: Aaron Lewis <aaronlewis@google.com>
> 
> Add a test to exercise the various features in KVM selftest's local
> snprintf() and compare them to LIBC's snprintf() to ensure they behave
> the same.
> 
> This is not an exhaustive test.  KVM's local snprintf() does not
> implement all the features LIBC does, e.g. KVM's local snprintf() does
> not support floats or doubles, so testing for those features were
> excluded.
> 
> Testing was added for the features that are expected to work to
> support a minimal version of printf() in the guest.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/guest_print_test.c  | 223 ++++++++++++++++++
>  2 files changed, 224 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/guest_print_test.c

I added this diff to this patch

diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 3a9a5db9794e..602a23ea9f01 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -115,7 +115,7 @@ static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
        while (1) {
                vcpu_run(vcpu);
 
-               TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+               TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
                            "Unexpected exit reason: %u (%s),\n",
                            run->exit_reason,
                            exit_reason_str(run->exit_reason));
@@ -161,7 +161,7 @@ static void test_limits(void)
        run = vcpu->run;
        vcpu_run(vcpu);
 
-       TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+       TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
                    "Unexpected exit reason: %u (%s),\n",
                    run->exit_reason,
                    exit_reason_str(run->exit_reason));
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 4cf69fa8bfba..4adf526dc378 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -6,8 +6,19 @@
  */
 #ifndef SELFTEST_KVM_UCALL_COMMON_H
 #define SELFTEST_KVM_UCALL_COMMON_H
+#include <linux/kvm.h>
 #include "test_util.h"
 
+#if defined(__aarch64__)
+#define UCALL_EXIT_REASON      KVM_EXIT_MMIO
+#elif defined(__x86_64__)
+#define UCALL_EXIT_REASON      KVM_EXIT_IO
+#elif defined(__s390x__)
+#define UCALL_EXIT_REASON      KVM_EXIT_S390_SIEIC
+#elif defined(__riscv)
+#define UCALL_EXIT_REASON      KVM_EXIT_RISCV_SBI
+#endif
+
 /* Common ucalls */
 enum {
        UCALL_NONE,


and then compiled the test for riscv and it passed. I also ran all other
riscv tests successfully.

Thanks,
drew



> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f65889f5a083..f2a8b3262f17 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -123,6 +123,7 @@ TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86_64 += demand_paging_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
> +TEST_GEN_PROGS_x86_64 += guest_print_test
>  TEST_GEN_PROGS_x86_64 += hardware_disable_test
>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
>  TEST_GEN_PROGS_x86_64 += kvm_page_table_test
> diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
> new file mode 100644
> index 000000000000..777838d42427
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/guest_print_test.c
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * A test for GUEST_PRINTF
> + *
> + * Copyright 2022, Google, Inc. and/or its affiliates.
> + */
> +#define USE_GUEST_ASSERT_PRINTF 1
> +
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +struct guest_vals {
> +	uint64_t a;
> +	uint64_t b;
> +	uint64_t type;
> +};
> +
> +static struct guest_vals vals;
> +
> +/* GUEST_PRINTF()/GUEST_ASSERT_FMT() does not support float or double. */
> +#define TYPE_LIST					\
> +TYPE(test_type_i64,  I64,  "%ld",   int64_t)		\
> +TYPE(test_type_u64,  U64u, "%lu",   uint64_t)		\
> +TYPE(test_type_x64,  U64x, "0x%lx", uint64_t)		\
> +TYPE(test_type_X64,  U64X, "0x%lX", uint64_t)		\
> +TYPE(test_type_u32,  U32u, "%u",    uint32_t)		\
> +TYPE(test_type_x32,  U32x, "0x%x",  uint32_t)		\
> +TYPE(test_type_X32,  U32X, "0x%X",  uint32_t)		\
> +TYPE(test_type_int,  INT,  "%d",    int)		\
> +TYPE(test_type_char, CHAR, "%c",    char)		\
> +TYPE(test_type_str,  STR,  "'%s'",  const char *)	\
> +TYPE(test_type_ptr,  PTR,  "%p",    uintptr_t)
> +
> +enum args_type {
> +#define TYPE(fn, ext, fmt_t, T) TYPE_##ext,
> +	TYPE_LIST
> +#undef TYPE
> +};
> +
> +static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
> +		     const char *expected_assert);
> +
> +#define BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)		     \
> +const char *PRINTF_FMT_##ext = "Got params a = " fmt_t " and b = " fmt_t;    \
> +const char *ASSERT_FMT_##ext = "Expected " fmt_t ", got " fmt_t " instead";  \
> +static void fn(struct kvm_vcpu *vcpu, T a, T b)				     \
> +{									     \
> +	char expected_printf[UCALL_BUFFER_LEN];				     \
> +	char expected_assert[UCALL_BUFFER_LEN];				     \
> +									     \
> +	snprintf(expected_printf, UCALL_BUFFER_LEN, PRINTF_FMT_##ext, a, b); \
> +	snprintf(expected_assert, UCALL_BUFFER_LEN, ASSERT_FMT_##ext, a, b); \
> +	vals = (struct guest_vals){ (uint64_t)a, (uint64_t)b, TYPE_##ext };  \
> +	sync_global_to_guest(vcpu->vm, vals);				     \
> +	run_test(vcpu, expected_printf, expected_assert);		     \
> +}
> +
> +#define TYPE(fn, ext, fmt_t, T) \
> +		BUILD_TYPE_STRINGS_AND_HELPER(fn, ext, fmt_t, T)
> +	TYPE_LIST
> +#undef TYPE
> +
> +static void guest_code(void)
> +{
> +	while (1) {
> +		switch (vals.type) {
> +#define TYPE(fn, ext, fmt_t, T)							\
> +		case TYPE_##ext:						\
> +			GUEST_PRINTF(PRINTF_FMT_##ext, vals.a, vals.b);		\
> +			__GUEST_ASSERT(vals.a == vals.b,			\
> +				       ASSERT_FMT_##ext, vals.a, vals.b);	\
> +			break;
> +		TYPE_LIST
> +#undef TYPE
> +		default:
> +			GUEST_SYNC(vals.type);
> +		}
> +
> +		GUEST_DONE();
> +	}
> +}
> +
> +/*
> + * Unfortunately this gets a little messy because 'assert_msg' doesn't
> + * just contains the matching string, it also contains additional assert
> + * info.  Fortunately the part that matches should be at the very end of
> + * 'assert_msg'.
> + */
> +static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
> +{
> +	int len_str = strlen(assert_msg);
> +	int len_substr = strlen(expected_assert_msg);
> +	int offset = len_str - len_substr;
> +
> +	TEST_ASSERT(len_substr <= len_str,
> +		    "Expected '%s' to be a substring of '%s'\n",
> +		    assert_msg, expected_assert_msg);
> +
> +	TEST_ASSERT(strcmp(&assert_msg[offset], expected_assert_msg) == 0,
> +		    "Unexpected mismatch. Expected: '%s', got: '%s'",
> +		    expected_assert_msg, &assert_msg[offset]);
> +}
> +
> +static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
> +		     const char *expected_assert)
> +{
> +	struct kvm_run *run = vcpu->run;
> +	struct ucall uc;
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
> +			TEST_FAIL("Unknown 'args_type' = %lu", uc.args[1]);
> +			break;
> +		case UCALL_PRINTF:
> +			TEST_ASSERT(strcmp(uc.buffer, expected_printf) == 0,
> +				    "Unexpected mismatch. Expected: '%s', got: '%s'",
> +				    expected_printf, uc.buffer);
> +			break;
> +		case UCALL_ABORT:
> +			ucall_abort(uc.buffer, expected_assert);
> +			break;
> +		case UCALL_DONE:
> +			return;
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +		}
> +	}
> +}
> +
> +static void guest_code_limits(void)
> +{
> +	char test_str[UCALL_BUFFER_LEN + 10];
> +
> +	memset(test_str, 'a', sizeof(test_str));
> +	test_str[sizeof(test_str) - 1] = 0;
> +
> +	GUEST_PRINTF("%s", test_str);
> +}
> +
> +static void test_limits(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
> +	run = vcpu->run;
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +		    "Unexpected exit reason: %u (%s),\n",
> +		    run->exit_reason,
> +		    exit_reason_str(run->exit_reason));
> +
> +	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_ABORT,
> +		    "Unexpected ucall command: %lu,  Expected: %u (UCALL_ABORT)\n",
> +		    uc.cmd, UCALL_ABORT);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	test_type_i64(vcpu, -1, -1);
> +	test_type_i64(vcpu, -1,  1);
> +	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
> +	test_type_i64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
> +
> +	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
> +	test_type_u64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
> +	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
> +	test_type_x64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
> +	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
> +	test_type_X64(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
> +
> +	test_type_u32(vcpu, 0x90abcdef, 0x90abcdef);
> +	test_type_u32(vcpu, 0x90abcdef, 0x90abcdee);
> +	test_type_x32(vcpu, 0x90abcdef, 0x90abcdef);
> +	test_type_x32(vcpu, 0x90abcdef, 0x90abcdee);
> +	test_type_X32(vcpu, 0x90abcdef, 0x90abcdef);
> +	test_type_X32(vcpu, 0x90abcdef, 0x90abcdee);
> +
> +	test_type_int(vcpu, -1, -1);
> +	test_type_int(vcpu, -1,  1);
> +	test_type_int(vcpu,  1,  1);
> +
> +	test_type_char(vcpu, 'a', 'a');
> +	test_type_char(vcpu, 'a', 'A');
> +	test_type_char(vcpu, 'a', 'b');
> +
> +	test_type_str(vcpu, "foo", "foo");
> +	test_type_str(vcpu, "foo", "bar");
> +
> +	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdef);
> +	test_type_ptr(vcpu, 0x1234567890abcdef, 0x1234567890abcdee);
> +
> +	kvm_vm_free(vm);
> +
> +	test_limits();
> +
> +	return 0;
> +}
> -- 
> 2.41.0.487.g6d72f3e995-goog
> 
