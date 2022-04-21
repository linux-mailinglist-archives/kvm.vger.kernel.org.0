Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF0950A939
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391980AbiDUTef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiDUTed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 252964D63E
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650569502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FRFiWfa55akKh1eKFs4VN65395Ffs0GkeSXbLxCs+J8=;
        b=aCEkhwYcu7kp2gPSDa4pSM1GJkonyox3Oyz+jrWVTeKTBYpB/pO2HkxwpMYw8+1lPOH/Lp
        mdDea7V+kb+972zfICuZeUPRBiS3lpzSMamBPlPliBVFx8k8SaV763cRonGKLVtLhO0Gnv
        Um70jrkjsknx8JTo01SDQn7keTorDjs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-p75jUJupPp-WiC1vUHtqGg-1; Thu, 21 Apr 2022 15:31:41 -0400
X-MC-Unique: p75jUJupPp-WiC1vUHtqGg-1
Received: by mail-il1-f197.google.com with SMTP id q9-20020a056e02106900b002cbc8d479eeso3189377ilj.1
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FRFiWfa55akKh1eKFs4VN65395Ffs0GkeSXbLxCs+J8=;
        b=Cp9U6P2yTcos0dSGKU83B3xWb1ZiDxGf/8SkT3XmGvwck8AuHG/5oJ6f/Ch74xEnS/
         KHgTNNRI8fwRmdD/FjwCMHExsn0Efkg0m2YwHjDmfAVeWWeAiJ26EhvagE9ajC5qaj9x
         BBbz/d6D+4umTqV7oRalz9yC3rJPNCEgJYUBANgWVPZMKI8gJMegnekfNf22boclNvNM
         gxU2hzbY+1BIPLmS3VITDBuRcHjPilJRUF8AzQswPAATyyUJuaFf2jXRwbqxQyQelZk8
         HvEuz56WnVwAl7i0flCvvO41ID2hqJ/QmKdY9QEY42Wea+XwTwqmU0aKxiG0V73TUQ/d
         3QeQ==
X-Gm-Message-State: AOAM530pvI8IGHzwuyCCVsNd65lVjTWsYfttX8p8VYAU24luERl51lkb
        Q9myYVII2uheT7eLGhSkFsDO1c2KKLQwulBnRif2megNRdHn4CuzS4rFGC4rcqdOtgYhh1CAJKr
        Ghoy7WBP6xCSS
X-Received: by 2002:a02:950c:0:b0:323:918d:a98f with SMTP id y12-20020a02950c000000b00323918da98fmr543440jah.190.1650569500127;
        Thu, 21 Apr 2022 12:31:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLQ/0WL7zFTfUg5nE85tx5/qWyvPdmkceYDk4M/Jrgov0C5puwQm/97/6Q3bC4IcDl2i+Xog==
X-Received: by 2002:a02:950c:0:b0:323:918d:a98f with SMTP id y12-20020a02950c000000b00323918da98fmr543426jah.190.1650569499804;
        Thu, 21 Apr 2022 12:31:39 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id c4-20020a6b4e04000000b00653e74540f0sm10285292iob.7.2022.04.21.12.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 12:31:39 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:31:37 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 10/10] KVM: selftests: Test disabling NX hugepages on
 a VM
Message-ID: <YmGxGa++9FEf9fgl@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-11-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:13AM -0700, Ben Gardon wrote:
> Add an argument to the NX huge pages test to test disabling the feature
> on a VM using the new capability.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 16 +++-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 75 +++++++++++++++----
>  .../kvm/x86_64/nx_huge_pages_test.sh          | 39 ++++++----
>  4 files changed, 104 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 1dac3c6607f1..8f6aad253392 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -414,4 +414,6 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> +int vm_disable_nx_huge_pages(struct kvm_vm *vm);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 392abd3c323d..96faa14f4f32 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -112,6 +112,11 @@ int vm_check_cap(struct kvm_vm *vm, long cap)
>  	return ret;
>  }
>  
> +static int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
> +{
> +	return ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +}
> +
>  /* VM Enable Capability
>   *
>   * Input Args:
> @@ -128,7 +133,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
>  {
>  	int ret;
>  
> -	ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +	ret = __vm_enable_cap(vm, cap);
>  	TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
>  		"  rc: %i errno: %i", ret, errno);
>  
> @@ -2756,3 +2761,12 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
>  		    stat_name, ret);
>  	return data;
>  }
> +
> +int vm_disable_nx_huge_pages(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = { 0 };
> +
> +	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> +	cap.args[0] = 0;
> +	return __vm_enable_cap(vm, &cap);
> +}

Nitpick: I think it's nicer if we name vm_disable_nx_huge_pages() as
__vm_disable_nx_huge_pages() to show that its retval is not checked,
comparing to most of the vm_*() existing helpers where we do check those.

> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 1c14368500b7..41b228b8cac3 100644
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
> @@ -86,18 +88,45 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>  		    expected_splits, actual_splits);
>  }
>  
> -int main(int argc, char **argv)
> +void run_test(bool disable_nx_huge_pages)
>  {
>  	struct kvm_vm *vm;
>  	struct timespec ts;
> +	uint64_t pages;
>  	void *hva;
> -
> -	if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
> -		printf("This test must be run through nx_huge_pages_test.sh");
> -		return KSFT_SKIP;
> +	int r;
> +
> +	pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
> +				0, 0);
> +	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
> +
> +	if (disable_nx_huge_pages) {
> +		kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES);

Nit: try to fail gracefully on old kernels?

> +
> +		/*
> +		 * Check if this process has the reboot permissions needed to
> +		 * disable NX huge pages on a VM.
> +		 *
> +		 * The reboot call below will never have any effect because
> +		 * the magic values are not set correctly, however the
> +		 * permission check is done before the magic value check.
> +		 */
> +		r = syscall(SYS_reboot, 0, 0, 0, NULL);

This looks fine, but instead of depending on the reboot syscall magics not
being set, how about we simply pass in an extra args to this test program
showing whether we have the correct permissions?

So:

  $NXECUTABLE 887563923 1

Means we have permissions and we should proceed well with disable nx
hugepages, 

  $NXECUTABLE 887563923 0

Otherwise.  I just think it's not necessary to add that layer of
dependency.  What do you think?

> +		if (r && errno == EPERM) {
> +			r = vm_disable_nx_huge_pages(vm);
> +			TEST_ASSERT(errno == EPERM,
> +				    "This process should not have permission to disable NX huge pages");

I just remembered one thing: in the previous patch on handling enablement
of this new cap, we checked args[0] before perm.  Maybe we want to check
perm before args[0] there to look even safer.  This is also a super-nit. :)

> +			return;
> +		}
> +
> +		TEST_ASSERT(r && errno == EINVAL,
> +			    "Reboot syscall should fail with -EINVAL");
> +
> +		r = vm_disable_nx_huge_pages(vm);
> +		TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
>  	}
>  
> -	vm = vm_create_default(0, 0, guest_code);
> +	vm_vcpu_add_default(vm, 0, guest_code);
>  
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>  				    HPAGE_GPA, HPAGE_SLOT,
> @@ -130,23 +159,27 @@ int main(int argc, char **argv)
>  	/*
>  	 * Next, the guest will execute from the first huge page, causing it
>  	 * to be remapped at 4k.
> +	 *
> +	 * If NX huge pages are disabled, this should have no effect.
>  	 */
>  	vcpu_run(vm, 0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 1);
> +	check_2m_page_count(vm, disable_nx_huge_pages ? 2 : 1);
> +	check_split_count(vm, disable_nx_huge_pages ? 0 : 1);
>  
>  	/*
>  	 * Executing from the third huge page (previously unaccessed) will
>  	 * cause part to be mapped at 4k.
> +	 *
> +	 * If NX huge pages are disabled, it should be mapped at 2M.
>  	 */
>  	vcpu_run(vm, 0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
> +	check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
>  
>  	/* Reading from the first huge page again should have no effect. */
>  	vcpu_run(vm, 0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
> +	check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
>  
>  	/*
>  	 * Give recovery thread time to run. The wrapper script sets
> @@ -158,8 +191,11 @@ int main(int argc, char **argv)
>  
>  	/*
>  	 * Now that the reclaimer has run, all the split pages should be gone.
> +	 *
> +	 * If NX huge pages are disabled, the relaimer will not run, so
> +	 * nothing should change from here on.
>  	 */
> -	check_2m_page_count(vm, 1);
> +	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
>  	check_split_count(vm, 0);
>  
>  	/*
> @@ -167,10 +203,21 @@ int main(int argc, char **argv)
>  	 * reading from it causes a huge page mapping to be installed.
>  	 */
>  	vcpu_run(vm, 0);
> -	check_2m_page_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 2);
>  	check_split_count(vm, 0);
>  
>  	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
> +		printf("This test must be run through nx_huge_pages_test.sh");
> +		return KSFT_SKIP;
> +	}
> +
> +	run_test(false);
> +	run_test(true);
>  
>  	return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index c2429ad8066a..b23993f3aab1 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -4,22 +4,35 @@
>  # tools/testing/selftests/kvm/nx_huge_page_test.sh
>  # Copyright (C) 2022, Google LLC.
>  
> -NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
> -NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> -NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> -HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
> +NX_HUGE_PAGES=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages)
> +NX_HUGE_PAGES_RECOVERY_RATIO=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> +NX_HUGE_PAGES_RECOVERY_PERIOD=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> +HUGE_PAGES=$(sudo cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
>  
> -echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> -echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> -echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> -echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> +sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +sudo echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +sudo echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

Shall we directly use these "sudo"s in the patch already where the new test
introduced?

Thanks,

> +
> +NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
> +
> +# Test with reboot permissions
> +sudo setcap cap_sys_boot+ep $NXECUTABLE
> +$NXECUTABLE 887563923
>  
> -"$(dirname $0)"/nx_huge_pages_test 887563923
>  RET=$?
>  
> -echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> -echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> -echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> -echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +if [ $RET -eq 0 ]; then
> +	# Test without reboot permissions
> +	sudo setcap cap_sys_boot-ep $NXECUTABLE
> +	$NXECUTABLE 887563923
> +
> +	RET=$?
> +fi
> +
> +sudo echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> +sudo echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +sudo echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +sudo echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  
>  exit $RET
> -- 
> 2.36.0.rc0.470.gd361397f0d-goog
> 

-- 
Peter Xu

