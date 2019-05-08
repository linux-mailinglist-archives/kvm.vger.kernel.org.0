Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFEA178F8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfEHMBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:01:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55161 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfEHMBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:01:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id b203so1769051wmb.4
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sl780jXSMJA96/69Gf4xxqK0i4TjGqWZXHMHfWHf5rA=;
        b=aGHyvPP1ouMejUv8f6SoslBqQ9g7orQlYKxqYY/IT98w3pRlezscd08/8RZic7vvhi
         ShV/suP6Hdd4uO+X38J5FdzNpfs7lX7SJtj1eg5ZSpo+OtCeMNN8gYe7qrxG9FGaqTb9
         mSpfs3vfn/2LZ16XASEBO8uvF6NkPd8sphapGYlAcz7l0TmOfyDCIBn0nvD47UXT5Ua4
         +TBgTX4qjq1gYJ11CgW6zMMZkxDIgkcR2C+6FFb3FpTnCD7QUUJS0eCB7PX34NN1iP1B
         jU3xVYT3s7IpwKdMwlcUGzCFPKAaR1Kc3FY3Dmkt6iQzoasZLo8c1CrrlE7hEAIOllHf
         WKDg==
X-Gm-Message-State: APjAAAXgL0v4wr5c/vGvH89IuFezsX3nTQUp4E/4yIZproY44D1LOY4X
        q5hb9Uc+ziVtrQTU0qPNJgsN9g==
X-Google-Smtp-Source: APXvYqwuup5BoNFCeXM3bGs4htPZi3KGuVuxwpjo2EpHjJ8ondlBOiaxxpgL0EWYV5NC9EDf30k7rw==
X-Received: by 2002:a1c:ed12:: with SMTP id l18mr2995833wmh.13.1557316880503;
        Wed, 08 May 2019 05:01:20 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id 7sm14495486wro.85.2019.05.08.05.01.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 05:01:19 -0700 (PDT)
Subject: Re: [PATCH] tests: kvm: Add tests for KVM_CAP_MAX_VCPUS and
 KVM_CAP_MAX_CPU_ID
To:     Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, marcorr@google.com, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190502183159.260545-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <46f1db8f-c138-bbb2-ea09-80c2f8c58fcd@redhat.com>
Date:   Wed, 8 May 2019 14:01:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502183159.260545-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/19 13:31, Aaron Lewis wrote:
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../kvm/x86_64/kvm_create_max_vcpus.c         | 70 +++++++++++++++++++
>  3 files changed, 72 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2689d1ea6d7a..98d93c0fd38e 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -6,4 +6,5 @@
>  /x86_64/vmx_close_while_nested_test
>  /x86_64/vmx_tsc_adjust_test
>  /x86_64/state_test
> +/x86_64/kvm_create_max_vcpus
>  /dirty_log_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f8588cca2bef..6b7b3617d25c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> +TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> new file mode 100644
> index 000000000000..50e92996f918
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> @@ -0,0 +1,70 @@
> +/*
> + * kvm_create_max_vcpus
> + *
> + * Copyright (C) 2019, Google LLC.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * Test for KVM_CAP_MAX_VCPUS and KVM_CAP_MAX_VCPU_ID.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +#include "asm/kvm.h"
> +#include "linux/kvm.h"
> +
> +void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
> +{
> +	struct kvm_vm *vm;
> +	int i;
> +
> +	printf("Testing creating %d vCPUs, with IDs %d...%d.\n",
> +	       num_vcpus, first_vcpu_id, first_vcpu_id + num_vcpus - 1);
> +
> +	vm = vm_create(VM_MODE_P52V48_4K, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> +
> +	for (i = 0; i < num_vcpus; i++) {
> +		int vcpu_id = first_vcpu_id + i;
> +
> +		/* This asserts that the vCPU was created. */
> +		vm_vcpu_add(vm, vcpu_id, 0, 0);
> +	}
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
> +	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> +
> +	printf("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
> +	printf("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
> +
> +	/*
> +	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
> +	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
> +	 * in this case.
> +	 */
> +	if (!kvm_max_vcpu_id)
> +		kvm_max_vcpu_id = kvm_max_vcpus;
> +
> +	TEST_ASSERT(kvm_max_vcpu_id >= kvm_max_vcpus,
> +		    "KVM_MAX_VCPU_ID (%d) must be at least as large as KVM_MAX_VCPUS (%d).",
> +		    kvm_max_vcpu_id, kvm_max_vcpus);
> +
> +	test_vcpu_creation(0, kvm_max_vcpus);
> +
> +	if (kvm_max_vcpu_id > kvm_max_vcpus)
> +		test_vcpu_creation(
> +			kvm_max_vcpu_id - kvm_max_vcpus, kvm_max_vcpus);
> +
> +	return 0;
> +}
> 

Queued, thanks.

Paolo
