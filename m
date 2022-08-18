Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4C7597A93
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 02:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbiHRAWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 20:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbiHRAWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 20:22:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6EBA59A3
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 17:22:20 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v4so22850pgi.10
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 17:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=nFIIDeTvZykZ4JCof0BBN5j4s0/In/3TN3kyZo0Sqgc=;
        b=s05zlC8jnPNo1K+zc5NmU6XEQaBejjlyQhfbnD42fOfAskGnWbUkm6G9hKiY24BwvA
         7ZXooVb576S5UE+xN1CZVKWUKiCacVcgVnEBMZDt+yO9NjIDiy0m1Tk4BUw/9FQPoJPF
         LNzmpzT1nzXPVE8EGYltC1rj12sYWyR9pG6FcIr9a9nYouKtOthaZIxuSIDEwCj7QvAt
         f88TTcFiSaQFlD7IR4DlHznVWSFX8nW0MzsFPe6Dt9fVVjxSJL+/X2VT2c9+6FobOW7s
         jx7t8MTNWUpJ/AnSA7fOiZCZkp5tOLaSALIDSxCM8gZuXiAje+Lbz8w1S24y/jgQkbRH
         2S6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nFIIDeTvZykZ4JCof0BBN5j4s0/In/3TN3kyZo0Sqgc=;
        b=gwTDQEQV9V4lNfmeRgO/hSRrWg/KMtodkFr8vcVSipbqO7OqXLWpUOZtT/cLXKKOzN
         sj4TcB4YvYFReAAEsIh9u8q1maZ08MoqWiKVDPYelkpxfy/K+4JdTPre1rI+eDUYaLBb
         e44kkS3psmuCim4mlpxRnR/zqF4e14XddW61VW/e3pGUczGYmGUSyifPEC3jseaYYYvj
         efmruu+aOZuhr2klbAYB8Jg7A7i2so8tQfKQiS0uqESK5CbI4Utp4DoZ3JYzw6Q7v4mu
         SsHyX5tiTGE4dv48VnpmcbI1QpHFs0eDDRb7z4keoVcHCzm+g7hNbvZOg3RFU0Gz1l5g
         vJZg==
X-Gm-Message-State: ACgBeo0iUwLPajxid5YYtI9BRYxK9P8zZfcN/A9VHRhtN3/gwn2spo93
        GQwNidQsdPcjTG5OvCoKrxeopw==
X-Google-Smtp-Source: AA6agR5k8LtRyUBe46tYyVVoQOEaH1+QAWL1p+9VGvJktMlKEwyJ09ACs+xdu0WuFUuIlu76ZqaPRA==
X-Received: by 2002:a63:1854:0:b0:41d:e04b:44fc with SMTP id 20-20020a631854000000b0041de04b44fcmr547810pgy.237.1660782139843;
        Wed, 17 Aug 2022 17:22:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e8-20020a656788000000b0040c52ff0ba9sm70328pgr.37.2022.08.17.17.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 17:22:19 -0700 (PDT)
Date:   Thu, 18 Aug 2022 00:22:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com
Subject: Re: [V3 11/11] KVM: selftests: Add simple sev vm testing
Message-ID: <Yv2GN1WPvi7K8LdI@google.com>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-12-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810152033.946942-12-pgonda@google.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/sev_vm_launch_measurOn Wed, Aug 10, 2022, Peter Gonda wrote:
> diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
> index 2f7f7c741b12..b6552ea1c716 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/sev.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
> @@ -22,6 +22,9 @@
>  #define SEV_POLICY_NO_DBG	(1UL << 0)
>  #define SEV_POLICY_ES		(1UL << 2)
>  
> +#define CPUID_MEM_ENC_LEAF 0x8000001f
> +#define CPUID_EBX_CBIT_MASK 0x3f

Ha!  I was going to say "put these in processor.h", but I have an even better idea.
I'll try to a series posted tomorrow (compile tested only at this point), but what
I'm hoping to do is to allow automagic retrieval of multi-bit CPUID properties, a la
the existing this_cpu_has() stuff.

E.g.

	#define X86_PROPERTY_CBIT_LOCATION		KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)

and then

	sev->enc_bit = this_cpu_property(X86_PROPERTY_CBIT_LOCATION);

LOL, now I see that the defines in sev.c were introduced back in patch 08.  That's
probably fine for your submission so as not to take a dependency on the "property"
idea.  This patch doesn't need to move the CPUID_* defines because it can use
this_cpu_has(X86_FEATURE_SEV) and avoid referencing CPUID_MEM_ENC_LEAF.

>  enum {
>  	SEV_GSTATE_UNINIT = 0,
>  	SEV_GSTATE_LUPDATE,
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> index 3abcf50c0b5d..8f9f55c685a7 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> @@ -13,8 +13,6 @@
>  #include "sev.h"
>  
>  #define PAGE_SHIFT		12

Already defined in processor.h

> -#define CPUID_MEM_ENC_LEAF 0x8000001f
> -#define CPUID_EBX_CBIT_MASK 0x3f
>  
>  struct sev_vm {
>  	struct kvm_vm *vm;
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> new file mode 100644
> index 000000000000..b319d18bdb60
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Basic SEV boot tests.
> + *
> + * Copyright (C) 2021 Advanced Micro Devices
> + */
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +#include "linux/psp-sev.h"
> +#include "sev.h"
> +
> +#define VCPU_ID			2

Nooooooo.  Unless there is a really, REALLY good reason this needs to be '2', just
pass '0' as a literal to vm_vcpu_add() and delete VCPU_ID.

> +#define PAGE_STRIDE		32
> +
> +#define SHARED_PAGES		8192
> +#define SHARED_VADDR_MIN	0x1000000
> +
> +#define PRIVATE_PAGES		2048
> +#define PRIVATE_VADDR_MIN	(SHARED_VADDR_MIN + SHARED_PAGES * PAGE_SIZE)
> +
> +#define TOTAL_PAGES		(512 + SHARED_PAGES + PRIVATE_PAGES)
> +
> +#define NR_SYNCS 1
> +
> +static void guest_run_loop(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +	int i;
> +
> +	for (i = 0; i <= NR_SYNCS; ++i) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			continue;
> +		case UCALL_DONE:
> +			return;
> +		case UCALL_ABORT:
> +			TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx",
> +				    (const char *)uc.args[0], __FILE__,
> +				    uc.args[1], uc.args[2], uc.args[3]);
> +		default:
> +			TEST_ASSERT(
> +				false, "Unexpected exit: %s",
> +				exit_reason_str(vcpu->run->exit_reason));
> +		}
> +	}
> +}
> +
> +static void __attribute__((__flatten__)) guest_sev_code(void)

Is __flatten__ strictly necessary?  I don't see this being copied over anything
that would require it to be a contiguous chunk.

> +{
> +	uint32_t eax, ebx, ecx, edx;
> +	uint64_t sev_status;
> +
> +	GUEST_SYNC(1);
> +
> +	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> +	GUEST_ASSERT(eax & (1 << 1));

	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
> +
> +	sev_status = rdmsr(MSR_AMD64_SEV);
> +	GUEST_ASSERT((sev_status & 0x1) == 1);
> +
> +	GUEST_DONE();
> +}
> +
> +static struct sev_vm *setup_test_common(void *guest_code, uint64_t policy,
> +					struct kvm_vcpu **vcpu)
> +{
> +	uint8_t measurement[512];
> +	struct sev_vm *sev;
> +	struct kvm_vm *vm;
> +	int i;
> +
> +	sev = sev_vm_create(policy, TOTAL_PAGES);

	TEST_ASSERT(sev, ...) so that this doesn't silently "pass"?

> +	if (!sev)
> +		return NULL;
> +	vm = sev_get_vm(sev);
> +
> +	/* Set up VCPU and initial guest kernel. */
> +	*vcpu = vm_vcpu_add(vm, VCPU_ID, guest_code);
> +	kvm_vm_elf_load(vm, program_invocation_name);
> +
> +	/* Allocations/setup done. Encrypt initial guest payload. */
> +	sev_vm_launch(sev);
> +
> +	/* Dump the initial measurement. A test to actually verify it would be nice. */
> +	sev_vm_launch_measure(sev, measurement);
> +	pr_info("guest measurement: ");
> +	for (i = 0; i < 32; ++i)
> +		pr_info("%02x", measurement[i]);
> +	pr_info("\n");
> +
> +	sev_vm_launch_finish(sev);
> +
> +	return sev;
> +}
> +
> +static void test_sev(void *guest_code, uint64_t policy)
> +{
> +	struct sev_vm *sev;
> +	struct kvm_vcpu *vcpu;
> +
> +	sev = setup_test_common(guest_code, policy, &vcpu);
> +	if (!sev)
> +		return;

And with an assert above, this return goes away.  Or better yet, fold setup_test_common()
into test_sev(), there's only the one user of the so called "common" function.

> +
> +	/* Guest is ready to run. Do the tests. */
> +	guest_run_loop(vcpu);
> +
> +	pr_info("guest ran successfully\n");
> +
> +	sev_vm_free(sev);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	/* SEV tests */
> +	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
> +	test_sev(guest_sev_code, 0);
> +
> +	return 0;
> +}
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
