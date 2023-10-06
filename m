Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB9D7BB090
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 05:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjJFDob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 23:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjJFDo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 23:44:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6B7DB
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 20:44:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8660e23801so2120509276.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 20:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696563868; x=1697168668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pa55BPW4WvEUPJ9QXjScfqr5Mn25swAAquib37Q4LuM=;
        b=tFqckOtop9wnUA3N62NaN0YuArdQi9dbeSwKm3Z0IJgZMRJQO6SEs/sGzt3mNyzsHl
         O42msOVELKKXvh1LNgAsJGsl4s+dpjzj6dc59wV8zDK+gV5xtHCBBP0l51U83bCpmo1O
         1Ld46KaUfhspYL4jObtfJxZVpYWWMw7LnSWcNDOoG5Vlrczm5CtXbOZULvyojpfEkyt9
         mJBiJaYn5YlQ1TkM4Nrw69uR9gGbViLkzFpWnVMKXGfrYVz/869YH0eGzGgo5ROxE7CX
         b3GgS4ftvCSVmJRgGGjBDv3bSWcOi62wJf8KYM+j2b0Q51HaTZtsarO/Y613SDfRVOLV
         qABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696563868; x=1697168668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pa55BPW4WvEUPJ9QXjScfqr5Mn25swAAquib37Q4LuM=;
        b=Ju9z5JpIFCaalzgOO+JQGKOEehuVEGHF6kXCLl6PvxR6aLjr2tcFE/oOc/uU78wJiS
         A98/lN6lJToIJ7gqV+AktQGpYVWZ+mWNb0IYVW1plKyrIUKoLR2for2MJixUoOJ4iajR
         R1nFPOEesVViATDGWWPp5HNBDoaXHJFvs/M1PyBEcIvR2o4RXAKdx+oIk2v07EObx2Ku
         wmJB6yO+SIU4yg5qj8hqqBqBGmqNIRqfpUqnayttw5WWfxAAZoJqwF7PG6iKKcnOpaLt
         6rV4NcKdK2U8fJL9EqCbdMWIx8oKMx5PTkHaWW6+yuuljyQi3b6yCHooFYt2rBmxzELX
         P4Cg==
X-Gm-Message-State: AOJu0Yx8zblhL0K1WCr6YJVK3FUeXSERSRPm9mrV2mMAnnV+DmmToADX
        LjSaZ6GV5Uc+JtkAykRmgBufxQIXdAY=
X-Google-Smtp-Source: AGHT+IFXc0UbbbCoZpPHrU7fLRyuBE7EIbhzIE/SHzZz4/fxdd9HRT370TLtxSE0hcReSSDpCgUeu6Lz8eM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:52d:b0:d13:856b:c10a with SMTP id
 y13-20020a056902052d00b00d13856bc10amr105527ybs.3.1696563867791; Thu, 05 Oct
 2023 20:44:27 -0700 (PDT)
Date:   Thu, 5 Oct 2023 20:44:26 -0700
In-Reply-To: <20230929230246.1954854-4-jmattson@google.com>
Mime-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com> <20230929230246.1954854-4-jmattson@google.com>
Message-ID: <ZR-CmoacxFxkqZ6Z@google.com>
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of HWCR
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, "'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023, Jim Mattson wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
> new file mode 100644
> index 000000000000..1a6a09791ac3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023, Google LLC.
> + *
> + * Tests for the K7_HWCR MSR.

My vote is to drop this.  I have a hard time believing anyone ever gets value
out of these, and they have a bad habit of becoming stale.

> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "vmx.h"
> +
> +void test_hwcr_bit(struct kvm_vcpu *vcpu, unsigned int bit)
> +{
> +	const unsigned long long ignored = BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8);

uint64_t instead of "unsigned long long"

> +	const unsigned long long valid = BIT_ULL(18) | BIT_ULL(24);
> +	const unsigned long long legal = ignored | valid;
> +	uint64_t val = BIT_ULL(bit);
> +	uint64_t check;
> +	int r;
> +
> +	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
> +	TEST_ASSERT((r == 1 && (val & legal)) || (r == 0 && !(val & legal)),

Hrm.  The "val & legal" is weird.  It works, but only because "val" is guaranteed
to be a single bit.  I much prefer to check for illegal bits, not if there is at
least one legal bit.  It's kinda ugly, but IMO using a ternary operator is more
intuitive than checking the same thing twice.

> +		    "Unexpected result (%d) when setting HWCR[bit %u]", r, bit);

And rather than just say "Unexpected result", explicitly say "fail" or "succeed",
I always forget that KVM_SET_MSRS has odd return codes.

	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
	TEST_ASSERT(val & ~legal ? !r : r == 1,
		    "Expected KVM_SET_MSRS(MSR_K7_HWCR) = 0x%lx to %s",
		    val, val & ~legal ? "succeed" : "fail");


> +	check =	vcpu_get_msr(vcpu, MSR_K7_HWCR);

s/check/actual?

> +	if (val & valid) {
> +		TEST_ASSERT(check == val,

There's no reason to force this code to work with single bits.  I don't mind
applying the test with single bit testing, but making it play nice with more
complex values is trivial, and IMO much easier on the eyes.

	TEST_ASSERT(actual == (val & valid),
		    "Bit %u: unexpected HWCR 0x%lx; expected 0x%lx",
		    bit, actual, (val & valid));

> +			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,

0x for the value to avoid decimal vs. hex confusion.

> +			    check, val);
> +		vcpu_set_msr(vcpu, MSR_K7_HWCR, 0);
> +	} else {
> +		TEST_ASSERT(!check,
> +			    "Bit %u: unexpected HWCR %lx; expected 0", bit,
> +			    check);
> +	}
> +}

If you've no objections, I'll apply the changes as below:

---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/hwcr_msr_test.c      | 47 +++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..3b82c583c68d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -119,6 +119,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
new file mode 100644
index 000000000000..df351ae17029
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023, Google LLC.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vmx.h"
+
+void test_hwcr_bit(struct kvm_vcpu *vcpu, unsigned int bit)
+{
+	const uint64_t ignored = BIT_ULL(3) | BIT_ULL(6) | BIT_ULL(8);
+	const uint64_t valid = BIT_ULL(18) | BIT_ULL(24);
+	const uint64_t legal = ignored | valid;
+	uint64_t val = BIT_ULL(bit);
+	uint64_t actual;
+	int r;
+
+	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
+	TEST_ASSERT(val & ~legal ? !r : r == 1,
+		    "Expected KVM_SET_MSRS(MSR_K7_HWCR) = 0x%lx to %s",
+		    val, val & ~legal ? "fail" : "succeed");
+
+	actual = vcpu_get_msr(vcpu, MSR_K7_HWCR);
+	TEST_ASSERT(actual == (val & valid),
+		    "Bit %u: unexpected HWCR 0x%lx; expected 0x%lx",
+		    bit, actual, (val & valid));
+
+	vcpu_set_msr(vcpu, MSR_K7_HWCR, 0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	unsigned int bit;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+
+	for (bit = 0; bit < BITS_PER_LONG; bit++)
+		test_hwcr_bit(vcpu, bit);
+
+	kvm_vm_free(vm);
+}

base-commit: 9a90e7aad79e519f7e4afd9d98778192c3b44b6e
-- 
