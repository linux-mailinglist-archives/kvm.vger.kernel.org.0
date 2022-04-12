Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7CE4FCBE6
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 03:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiDLBeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 21:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiDLBeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 21:34:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DCC19C1C
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 18:32:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id be5so9429752plb.13
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 18:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IdsjBouuaUAW6YtbrhnQK3jJQXWjKyeuOltrdWDIDuU=;
        b=UMqvigVmKFJwWf8Lib1NDIK9iPZSBWT/d/lWPkKM3NJpmqygLpg6vUxTDXND1/sHNU
         luphuZljGR9fCInOxRiTidhHOI2AbOIx/qyZJh4glgDO/Tv1KysQK4esvYeJ24R+AN40
         rT0GpJn0AYprqFS1Lv0sjOyeRW2aN0hZWuoOISdkBaeLxyesPyLC0eWtH0ZFTSizqwyL
         tkTeXUobpCLB6gTdn2JzseOXQ5FPFGXkLBunEx8S/eushDPNSK9KLHAoTDiXCMRmN24z
         foxXoPTg/dv4psoWLQrypFG5HFIIXzyT57kRhqYB/0YVv5XKfHR+0Sj6n8b46LdFBU+Z
         ObAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IdsjBouuaUAW6YtbrhnQK3jJQXWjKyeuOltrdWDIDuU=;
        b=DvD2V4wq+DPIwtwqnI5sLlctKF1hOmFtWv377e7xTGpDCfKuYDbEoS3zah4W3vTKbi
         hl22RLkfezPHVvKBdGD0eBof614TEgVtm8d3knx1cWEhRrsWW0YT67pilSgc03+kvjTc
         9UyXFFpcr8x/zwxrIPK76kDwERbxvuih6MgEkkup7enKzyUR6ATeCOqGQUEydMPiopvV
         kj9PLY90G3KwmqmKEZwCxVRghY96Z/XFq+YtvVx4SUM4gX5G3ZTNLF54FfVpfi3juG/x
         4jNRXQhsrydfFVsX5CIxpsYnb04eZIN0Hp8703w0mwP+LDaqElR6k9G3BaESO0B3HcxE
         /cNg==
X-Gm-Message-State: AOAM5335weCLwrOvqrFTrz3Q63KcIzNqFpm1RF2te+HJVf64qTgypgcq
        IJeIQySBevbB+mt6B2wCBxL9CA==
X-Google-Smtp-Source: ABdhPJw/90zh2RN+4GX3T1hJZxG9/zWfvgUJz9RJQj3Pi4Q1IOkssI4cOlGClXQUYclY7d6wWBFZcw==
X-Received: by 2002:a17:903:22cc:b0:158:52d6:1b0b with SMTP id y12-20020a17090322cc00b0015852d61b0bmr10057064plg.47.1649727139452;
        Mon, 11 Apr 2022 18:32:19 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm37406301pfu.76.2022.04.11.18.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 18:32:18 -0700 (PDT)
Date:   Tue, 12 Apr 2022 01:32:15 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 05/10] KVM: selftests: Add NX huge pages test
Message-ID: <YlTWn6pEKRMaG4gY@google.com>
References: <20220411211015.3091615-1-bgardon@google.com>
 <20220411211015.3091615-6-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411211015.3091615-6-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022, Ben Gardon wrote:
> There's currently no test coverage of NX hugepages in KVM selftests, so
> add a basic test to ensure that the feature works as intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  10 ++
>  .../selftests/kvm/include/kvm_util_base.h     |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  48 ++++++
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 163 ++++++++++++++++++
>  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
>  5 files changed, 247 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
>  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index af582d168621..9bb9bce4df37 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -43,6 +43,10 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handler
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
>  
> +# Non-compiled test targets
> +TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
> +
> +# Compiled test targets
>  TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> @@ -104,6 +108,9 @@ TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
> +# Compiled outputs used by test targets
> +TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
> +
>  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> @@ -142,7 +149,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
>  TEST_GEN_PROGS_riscv += set_memory_region_test
>  TEST_GEN_PROGS_riscv += kvm_binary_stats_test
>  
> +TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
>  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> +TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
>  LIBKVM += $(LIBKVM_$(UNAME_M))
>  
>  INSTALL_HDR_PATH = $(top_srcdir)/usr
> @@ -193,6 +202,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  all: $(STATIC_LIBS)
>  $(TEST_GEN_PROGS): $(STATIC_LIBS)
> +$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
>  
>  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
>  cscope:
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index b2684cfc2cb1..f9c2ac0a5b97 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -408,6 +408,7 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
>  int read_stat_data(int stats_fd, struct kvm_stats_header *header,
>  		   struct kvm_stats_desc *desc, uint64_t *data,
>  		   ssize_t max_elements);
> +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 64e2085f1129..833c7e63d62d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2614,3 +2614,51 @@ int read_stat_data(int stats_fd, struct kvm_stats_header *header,
>  
>  	return ret;
>  }
> +
> +static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
> +			    uint64_t *data, ssize_t max_elements)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +	struct kvm_stats_header header;
> +	struct kvm_stats_desc *desc;
> +	size_t size_desc;
> +	int stats_fd;
> +	int ret = -EINVAL;
> +	int i;
> +
> +	stats_fd = vm_get_stats_fd(vm);
> +
> +	read_vm_stats_header(stats_fd, &header);
> +
> +	stats_desc = alloc_vm_stats_desc(stats_fd, &header);
> +	read_vm_stats_desc(stats_fd, &header, stats_desc);
> +
> +	size_desc = sizeof(struct kvm_stats_desc) + header.name_size;
> +
> +	/* Read kvm stats data one by one */
> +	for (i = 0; i < header.num_desc; ++i) {
> +		desc = (void *)stats_desc + (i * size_desc);
> +
> +		if (strcmp(desc->name, stat_name))
> +			continue;
> +
> +		ret = read_stat_data(stats_fd, &header, desc, data,
> +				     max_elements);
> +	}
> +
> +	free(stats_desc);
> +	close(stats_fd);
> +	return ret;
> +}

I could be wrong, but it seems this function is quite generic. Why not
putting it into kvm_util.c?
> +
> +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> +{
> +	uint64_t data;
> +	int ret;
> +
> +	ret = vm_get_stat_data(vm, stat_name, &data, 1);
> +	TEST_ASSERT(ret == 1,
> +		    "Stat %s expected to have 1 element, but %d returned",
> +		    stat_name, ret);
> +	return data;
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> new file mode 100644
> index 000000000000..3f21726b22c7
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -0,0 +1,163 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * tools/testing/selftests/kvm/nx_huge_page_test.c
> + *
> + * Usage: to be run via nx_huge_page_test.sh, which does the necessary
> + * environment setup and teardown
> + *
> + * Copyright (C) 2022, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <fcntl.h>
> +#include <stdint.h>
> +#include <time.h>
> +
> +#include <test_util.h>
> +#include "kvm_util.h"
> +
> +#define HPAGE_SLOT		10
> +#define HPAGE_GVA		(23*1024*1024)
> +#define HPAGE_GPA		(10*1024*1024)
> +#define HPAGE_SLOT_NPAGES	(512 * 3)
> +#define PAGE_SIZE		4096
> +
> +/*
> + * When writing to guest memory, write the opcode for the `ret` instruction so
> + * that subsequent iteractions can exercise instruction fetch by calling the
> + * memory.
> + */
> +#define RETURN_OPCODE 0xC3
> +
> +void guest_code(void)
> +{
> +	uint64_t hpage_1 = HPAGE_GVA;
> +	uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
> +	uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
> +
> +	READ_ONCE(*(uint64_t *)hpage_1);
> +	GUEST_SYNC(1);
> +
> +	READ_ONCE(*(uint64_t *)hpage_2);
> +	GUEST_SYNC(2);
> +
> +	((void (*)(void)) hpage_1)();
> +	GUEST_SYNC(3);
> +
> +	((void (*)(void)) hpage_3)();
> +	GUEST_SYNC(4);
> +
> +	READ_ONCE(*(uint64_t *)hpage_1);
> +	GUEST_SYNC(5);
> +
> +	READ_ONCE(*(uint64_t *)hpage_3);
> +	GUEST_SYNC(6);
> +}
> +
> +static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
> +{
> +	int actual_pages_2m;
> +
> +	actual_pages_2m = vm_get_single_stat(vm, "pages_2m");
> +
> +	TEST_ASSERT(actual_pages_2m == expected_pages_2m,
> +		    "Unexpected 2m page count. Expected %d, got %d",
> +		    expected_pages_2m, actual_pages_2m);
> +}
> +
> +static void check_split_count(struct kvm_vm *vm, int expected_splits)
> +{
> +	int actual_splits;
> +
> +	actual_splits = vm_get_single_stat(vm, "nx_lpage_splits");
> +
> +	TEST_ASSERT(actual_splits == expected_splits,
> +		    "Unexpected nx lpage split count. Expected %d, got %d",
> +		    expected_splits, actual_splits);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct kvm_vm *vm;
> +	struct timespec ts;
> +	void *hva;
> +
> +	vm = vm_create_default(0, 0, guest_code);
> +
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> +				    HPAGE_GPA, HPAGE_SLOT,
> +				    HPAGE_SLOT_NPAGES, 0);
> +
> +	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
> +
> +	hva = addr_gpa2hva(vm, HPAGE_GPA);
> +	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
> +
> +	check_2m_page_count(vm, 0);
> +	check_split_count(vm, 0);
> +
> +	/*
> +	 * The guest code will first read from the first hugepage, resulting
> +	 * in a huge page mapping being created.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 0);
> +
> +	/*
> +	 * Then the guest code will read from the second hugepage, resulting
> +	 * in another huge page mapping being created.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 2);
> +	check_split_count(vm, 0);
> +
> +	/*
> +	 * Next, the guest will execute from the first huge page, causing it
> +	 * to be remapped at 4k.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 1);
> +
> +	/*
> +	 * Executing from the third huge page (previously unaccessed) will
> +	 * cause part to be mapped at 4k.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 2);
> +
> +	/* Reading from the first huge page again should have no effect. */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 2);
> +
> +	/*
> +	 * Give recovery thread time to run. The wrapper script sets
> +	 * recovery_period_ms to 100, so wait 5x that.
> +	 */
> +	ts.tv_sec = 0;
> +	ts.tv_nsec = 500000000;
> +	nanosleep(&ts, NULL);
> +
> +	/*
> +	 * Now that the reclaimer has run, all the split pages should be gone.
> +	 */
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 0);
> +
> +	/*
> +	 * The 4k mapping on hpage 3 should have been removed, so check that
> +	 * reading from it causes a huge page mapping to be installed.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 2);
> +	check_split_count(vm, 0);
> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> +
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> new file mode 100755
> index 000000000000..19fc95723fcb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -0,0 +1,25 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only */
> +
> +# tools/testing/selftests/kvm/nx_huge_page_test.sh
> +# Copyright (C) 2022, Google LLC.
> +
> +NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
> +NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> +NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> +HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
> +
> +echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> +echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +
> +./nx_huge_pages_test
> +RET=$?
> +
> +echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> +echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +
> +exit $RET
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
