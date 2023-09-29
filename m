Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0037B3858
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjI2RHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjI2RHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 13:07:02 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156021B1
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:07:00 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a22eb73cb3so28013757b3.3
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 10:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696007219; x=1696612019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/92yxGXxVVBKQrjBo/lRs9vSnhayZuqRYEizHAYdkPA=;
        b=vN/hF05TlUWSizksDu9diA2ns6FPGvkdgztsEKyfKl/Geh2FGj0CKSmXo0n4LKE9HF
         6f1J2hs2K6sbntpm/POSnyBbzB3uf6W0ZyWGpqKdQacrMCq5tnB/xcM1VS7xyyTcCH11
         GWdHPi7rNfb9q7E3vQemLmCkEW4wotjzK27oGVsK8wAMWaDWDFOLgvJEo3fRStdYEdAr
         avXX9GR4LyXnE7pNc6XJ1SwLSiPa58jsrfVq5AfCF2TJ7oFuhyjW6GcXZSggEx9fWv2h
         nLAnu9E4ArYg0dvLINx19l5v6SnGpNAYu93/IWDgz11n4Ot3eV9LqM4QlnvhNPf+9HKe
         N6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696007219; x=1696612019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/92yxGXxVVBKQrjBo/lRs9vSnhayZuqRYEizHAYdkPA=;
        b=Y6Q2fPzcDmKJd7FCowXH+h5Cvp36PXOEQfWLgukbwYk1J1FOuh/xEQ9KVJEHK6gTMr
         lNc6RVij3ZLXsIHLZzN8eqyYk0Ow9nKKyB0RUVYzwikAzq8iLW6adESPS4JwDZr4BB0V
         JHj/ppWcKdX3LCPL1Lj/3xLUe4qKIe2DKrJBGoxbFBWWIgyJ83FAPGoycGvqAnk1Nu+5
         +5iSburL3VPCuwhpn+1MIENCkPLcjfa3Gm9K/lA6B8DknvYzKO5jds3vi9OtNBdeq+Z8
         SgfVHEKaIVriEa+hk8puW6+qcA3Hhi1Mw6KwqIeknokBAwBOB8OFe1+b0AuVLIwxW5hl
         1jRg==
X-Gm-Message-State: AOJu0Ywt/mItS9/RhA7ADk1E6FBCs0d5xpqYPqMOSJvjyvbnBuPCrlmu
        2Rjvw5AKC2jx1E/1HWojbzJynKGDL5U=
X-Google-Smtp-Source: AGHT+IESvDQ8bKaPB3KqBB5hZKeoEdzU2fTM5Oyynt98OT6DAKS57GziC6IAv43tgG7Pz1KBB7MHLZ43Nc8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6f87:0:b0:d81:754a:7cbb with SMTP id
 k129-20020a256f87000000b00d81754a7cbbmr73112ybc.11.1696007219258; Fri, 29 Sep
 2023 10:06:59 -0700 (PDT)
Date:   Fri, 29 Sep 2023 10:06:57 -0700
In-Reply-To: <20230928185128.824140-4-jmattson@google.com>
Mime-Version: 1.0
References: <20230928185128.824140-1-jmattson@google.com> <20230928185128.824140-4-jmattson@google.com>
Message-ID: <ZRcEMdOFKgfZotQD@google.com>
Subject: Re: [PATCH v3 3/3] KVM: selftests: Test behavior of HWCR
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

On Thu, Sep 28, 2023, Jim Mattson wrote:
> Verify the following:
> * Attempts to set bits 3, 6, or 8 are ignored
> * Bits 18 and 24 are the only bits that can be set
> * Any bit that can be set can also be cleared
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/x86_64/hwcr_msr_test.c      | 52 +++++++++++++++++++
>  2 files changed, 53 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a3bb36fb3cfc..6b0219ca65eb 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -135,6 +135,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> +TEST_GEN_PROGS_x86_64 += x86_64/hwcr_msr_test

Please place this with the other x86_64 specific tests.

Somewhat of a forward looking question, what do folks think about adding an
"msr_tests" subdirectory?  I really want to effectively replace KUT's msr.c test
with a supserset of functionality in selftests, e.g. KUT can't test userspace
writes.  But I don't want to end up with a single massive msr_test.c.  If we add
a subdirectory, then I think that would make it easier to share "private" APIs
and infrastructure without creating a giant monolithic test.

>  # Compiled outputs used by test targets
>  TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
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

uint64_t instead of "unsigned long long".

> +	const unsigned long long valid = BIT_ULL(18) | BIT_ULL(24);
> +	const unsigned long long legal = ignored | valid;
> +	uint64_t val = BIT_ULL(bit);
> +	uint64_t check;
> +	int r;
> +
> +	r = _vcpu_set_msr(vcpu, MSR_K7_HWCR, val);
> +	TEST_ASSERT((r == 1 && (val & legal)) || (r == 0 && !(val & legal)),
> +		    "Unexpected result (%d) when setting HWCR[bit %u]", r, bit);
> +	check =	vcpu_get_msr(vcpu, MSR_K7_HWCR);
> +	if (val & valid) {
> +		TEST_ASSERT(check == val,
> +			    "Bit %u: unexpected HWCR %lx; expected %lx", bit,
> +			    check, val);
> +		vcpu_set_msr(vcpu, MSR_K7_HWCR, 0);
> +	} else {
> +		TEST_ASSERT(!check,
> +			    "Bit %u: unexpected HWCR %lx; expected 0", bit,
> +			    check);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	unsigned int bit;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +
> +	for (bit = 0; bit < BITS_PER_LONG; bit++)
> +		test_hwcr_bit(vcpu, bit);
> +
> +	kvm_vm_free(vm);
> +}
> -- 
> 2.42.0.582.g8ccd20d70d-goog
> 
