Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A784F5512
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383999AbiDFF07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837658AbiDFAqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:46:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9D81925BC
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:55:29 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x31so802911pfh.9
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wMAyRl9S6hFfR9SM67ffSSu7pVXBn8qU69FHI8jYmbc=;
        b=iEo4ZU8haGYfbz38IbW+BV3gSab0fyIGXJUU6fzIIggiDW6FhbvlE99C2RpxyPWrZz
         wP7RJkS9FIHGmuSfPRlZLPYD700YdRWVe/xIKoD9hEpaBg7XVGwwqBx4uUbYIYLAjtp+
         t91q7rjO10F6YEUJn14RFeCBo/GMJ6Dk90RwHXlXeowEctJrPc7+DD7xJSDwH8bCJnCE
         kE1ZUllGlq96oY66A4WXhbbXufQb3R+ZwVzBhjCC1QSYQHrzU3rJBUHWX5DHzoRmcG0L
         /WU5oVjeE9sHrrwX74DVLvkUtKMuVArQv/nIhUiIiExdpo33n4dtZG3qWJ0nVEkDJtPK
         2J7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wMAyRl9S6hFfR9SM67ffSSu7pVXBn8qU69FHI8jYmbc=;
        b=4lIn+xcGzLQBwg4Gh/jkfTbEyJKLU5NO+vryCjZEULfVDQwU1MKV61Irxc9R2/zGCJ
         pn9xc0SaD1Y0p529cMUzjKHQdgTefIvKb6yUGgoc800dbIfplALcdGH57o3gqndcGI/C
         cKcP0QEz6/9kZxfk3TSSYrIe43JSx5qhRsCHil2HB9EYeQAvlXfFcn2qszFQu3y80cOV
         x8vq04J1PNlwrSKPtJYFgWurydXQGKGKLUMjuOXrab5naeKmCg93Z9CcfzDL1qVHbKQX
         afH2jI/gP0foB4e7NOzgCnq4V4oWNZn/ZjZNceltc52G7c7XoNiCGj4X91odHy0HnRp7
         cJJw==
X-Gm-Message-State: AOAM533UUHpQJaC/WXJkleOCsQQa9SYwWtJX0hslbZyRwjkkmcBwojUR
        r6hOxM3eYxzMFE/KW+uS8FY1Qw==
X-Google-Smtp-Source: ABdhPJxC3a9W9R9SKtI9Dsf4kxG8WauR2iht5ix5tUk0UmO6NVA1inslpomM++9PQveGGbC1h36sMQ==
X-Received: by 2002:a63:6c02:0:b0:398:833b:f739 with SMTP id h2-20020a636c02000000b00398833bf739mr4752899pgc.524.1649199325121;
        Tue, 05 Apr 2022 15:55:25 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id y24-20020a056a00181800b004fac7d687easm17103246pfa.66.2022.04.05.15.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:55:24 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:55:20 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 11/11] selftests: KVM: Test disabling NX hugepages on
 a VM
Message-ID: <YkzI2CL13ZMnPOb2@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-12-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:21AM -0700, Ben Gardon wrote:
> Add an argument to the NX huge pages test to test disabling the feature
> on a VM using the new capability.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ++
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 67 ++++++++++++++++---
>  .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
>  4 files changed, 66 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 72163ba2f878..4db8251c3ce5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -411,4 +411,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> +void vm_disable_nx_huge_pages(struct kvm_vm *vm);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9d72d1bb34fa..46a7fa08d3e0 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2765,3 +2765,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
>  	return value;
>  }
>  
> +void vm_disable_nx_huge_pages(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = { 0 };
> +
> +	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> +	vm_enable_cap(vm, &cap);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 2bcbe4efdc6a..a0c79f6ddc08 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -13,6 +13,8 @@
>  #include <fcntl.h>
>  #include <stdint.h>
>  #include <time.h>
> +#include <linux/reboot.h>
> +#include <sys/syscall.h>
>  
>  #include <test_util.h>
>  #include "kvm_util.h"
> @@ -57,13 +59,56 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>  		    expected_splits, actual_splits);
>  }
>  
> +static void help(void)
> +{
> +	puts("");
> +	printf("usage: nx_huge_pages_test.sh [-x]\n");
> +	puts("");
> +	printf(" -x: Allow executable huge pages on the VM.\n");

Making it a flag means we won't exercise it by default. Is there are
reason to avoid exercising KVM_CAP_VM_DISABLE_NX_HUGE_PAGES by default?

Assuming no, I would recommend factoring out the test to a helper
function that takes a parameter that tells it if nx_huge_pages is
enabled or disabled. Then run this helper function multiple times. E.g.
once with nx_huge_pages enabled, once with nx_huge_pages disabled via
KVM_CAP_VM_DISABLE_NX_HUGE_PAGES. This would also then let you test that
disabling via module param also works.

By the way, that brings up another issue. What if NX HugePages is not
enabled on this host? e.g. we're running on AMD, or we're running on a
non-affected Intel host, or we're running on a machine where nx huge
pages has been disabled by the admin? The test should probably return
KSFT_SKIP in those cases.

> +	puts("");
> +	exit(0);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct kvm_vm *vm;
>  	struct timespec ts;
> +	bool disable_nx = false;
> +	int opt;
> +	int r;
> +
> +	while ((opt = getopt(argc, argv, "x")) != -1) {
> +		switch (opt) {
> +		case 'x':
> +			disable_nx = true;
> +			break;
> +		case 'h':
> +		default:
> +			help();
> +			break;
> +		}
> +	}
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  
> +	if (disable_nx) {
> +		/*
> +		 * Check if this process has the reboot permissions needed to
> +		 * disable NX huge pages on a VM.
> +		 *
> +		 * The reboot call below will never have any effect because
> +		 * the magic values are not set correctly, however the
> +		 * permission check is done before the magic value check.
> +		 */
> +		r = syscall(SYS_reboot, 0, 0, 0, NULL);
> +		if (r == -EPERM)
> +			return KSFT_SKIP;
> +		TEST_ASSERT(r == -EINVAL,
> +			    "Reboot syscall should fail with -EINVAL");

Just check if KVM_CAP_VM_DISABLE_NX_HUGE_PAGES returns -EPERM?

> +
> +		vm_disable_nx_huge_pages(vm);
> +	}
> +
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>  				    HPAGE_PADDR_START, HPAGE_SLOT,
>  				    HPAGE_SLOT_NPAGES, 0);
> @@ -83,21 +128,21 @@ int main(int argc, char **argv)
>  	 * at 2M.
>  	 */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 2);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx ? 4 : 2);
> +	check_split_count(vm, disable_nx ? 0 : 2);
>  
>  	/*
>  	 * guest_code1 is in the same huge page as data1, so it will cause
>  	 * that huge page to be remapped at 4k.
>  	 */
>  	run_guest_code(vm, guest_code1);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	/* Run guest_code0 again to check that is has no effect. */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	/*
>  	 * Give recovery thread time to run. The wrapper script sets
> @@ -110,7 +155,7 @@ int main(int argc, char **argv)
>  	/*
>  	 * Now that the reclaimer has run, all the split pages should be gone.
>  	 */
> -	check_2m_page_count(vm, 1);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
>  	check_split_count(vm, 0);
>  
>  	/*
> @@ -118,13 +163,13 @@ int main(int argc, char **argv)
>  	 * again to check that pages are mapped at 2M again.
>  	 */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 2);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx ? 4 : 2);
> +	check_split_count(vm, disable_nx ? 0 : 2);
>  
>  	/* Pages are once again split from running guest_code1. */
>  	run_guest_code(vm, guest_code1);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	kvm_vm_free(vm);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index 19fc95723fcb..29f999f48848 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
>  echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
>  echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  
> -./nx_huge_pages_test
> +./nx_huge_pages_test "${@}"
>  RET=$?
>  
>  echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> -- 
> 2.35.1.1021.g381101b075-goog
> 
