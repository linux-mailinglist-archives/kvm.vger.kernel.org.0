Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A496518C73
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbiECSiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiECSiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:38:06 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4783F33E
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:34:33 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2f7b815ac06so189724987b3.3
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTKkXmCcfeC5nUTve6x9LE3dukg3CPNvdHi3bnIfeD8=;
        b=biujXSPVywb6HGkOY6Qrhg0m3aOdzyyPr8g2MkTCBONdkB/qoKc2lFx0PEAHBusC42
         rB7dOGkDwtcTucmMGORn/KK7WN6usKA9/aowjhzBiCACV2X+z1ABKbo3omU+t74XB1Zk
         c1vrgIcYt55L04zzvyv788jBUsQDyS3lx2h9LZBO7NlcBK2Nxx/jiQO5KoftpJITM5Wp
         m1BNQTrUaeJvfcI9xCe4OWfxb91+q7ol81NQ44PUu6s6nl7MwtveMg1h2+k5PSM/y02V
         HV5Y9GIm24xKyISpEhmv8DTvhh5QWt+M7aBCSp5i/358Lgzt3hFXhuVOXtp78bPBCq2A
         zh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTKkXmCcfeC5nUTve6x9LE3dukg3CPNvdHi3bnIfeD8=;
        b=2+XHWgdmOp5xS7O9KXb/s/iL88A05ZiickH+ap6n/jjDBR8ukuRfeM38rCslZneeoB
         EThaBHOGf7C3IA511qq+LCk+nK9cMXBMdgc0fw4NpPki7Ni3mWXlJCB8GCpX85o92Q64
         pVajl8/agBQnSSn39hvjSdeHWWfANB+MYZgkWFssKI7iZ/Ly0n/LbABzIVp/LmF3NWFX
         i3Y9DcLI/ZM2DuM7NKNYW71kfNL9LbCWRaji6Xsasc/8PfbISWAWBMnnQNR7CkyOQZeL
         PK8mp25bdMTLZzEMLtjvLvttqmgviBkJulMZezP4rBIS8Fw98S2z110OOIE0FtmVWg0t
         bqxQ==
X-Gm-Message-State: AOAM53028HJh/LgEK5qvgh8dv5oZ4rGzKaEC6e2Rs1uu+gWaLSbdxm/t
        QNgv/BwOyXrLKHEap1lcO9a5aTc56mvWqTWCb2sVVlivRt8=
X-Google-Smtp-Source: ABdhPJwO9qSA0QZ2TcJcEL+ikWupEJsxz0bRSsvaDxVAkzDtcdTzlWpuisGminrCptuiG8854BTX2okXfYCxZ33E+V8=
X-Received: by 2002:a05:690c:306:b0:2f8:c59e:28a8 with SMTP id
 bg6-20020a05690c030600b002f8c59e28a8mr15879157ywb.472.1651602872202; Tue, 03
 May 2022 11:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220503183045.978509-1-bgardon@google.com> <20220503183045.978509-11-bgardon@google.com>
In-Reply-To: <20220503183045.978509-11-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 3 May 2022 11:34:21 -0700
Message-ID: <CANgfPd-Touu2OWufqcgrVdHvEDOhJO29Ym8mLdJKDB5CZ66jdQ@mail.gmail.com>
Subject: Re: [PATCH v7 10/11] KVM: selftests: Test disabling NX hugepages on a VM
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, May 3, 2022 at 11:31 AM Ben Gardon <bgardon@google.com> wrote:
>
> Add an argument to the NX huge pages test to test disabling the feature
> on a VM using the new capability.
>
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 70 +++++++++++++++----
>  .../kvm/x86_64/nx_huge_pages_test.sh          | 12 +++-
>  4 files changed, 95 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 1dac3c6607f1..eee96189c1c4 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -414,4 +414,6 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name);
>
>  uint32_t guest_get_vcpuid(void);
>
> +int __vm_disable_nx_huge_pages(struct kvm_vm *vm);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 27ffd2537df6..0ec7efc2900d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -112,6 +112,11 @@ int vm_check_cap(struct kvm_vm *vm, long cap)
>         return ret;
>  }
>
> +static int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
> +{
> +       return ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +}
> +
>  /* VM Enable Capability
>   *
>   * Input Args:
> @@ -128,7 +133,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
>  {
>         int ret;
>
> -       ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +       ret = __vm_enable_cap(vm, cap);
>         TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
>                 "  rc: %i errno: %i", ret, errno);
>
> @@ -2758,3 +2763,23 @@ uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
>                     stat_name, ret);
>         return data;
>  }
> +
> +/* VM disable NX huge pages
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *
> + * Output Args: None
> + *
> + * Return: On success, 0 -ERRNO on failure.
> + *
> + * Disables NX huge pages for the VM.
> + */
> +int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
> +{
> +       struct kvm_enable_cap cap = { 0 };
> +
> +       cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> +       cap.args[0] = 0;
> +       return __vm_enable_cap(vm, &cap);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 238a6047791c..1e7328dd33d2 100644
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
> @@ -89,18 +91,36 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>                     expected_splits, actual_splits);
>  }
>
> -int main(int argc, char **argv)
> +void run_test(bool disable_nx_huge_pages, bool reboot_permissions)
>  {
>         struct kvm_vm *vm;
>         struct timespec ts;
> +       uint64_t pages;
>         void *hva;
> -
> -       if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
> -               printf("This test must be run through nx_huge_pages_test.sh");
> -               return KSFT_SKIP;
> +       int r;
> +
> +       pages = vm_pages_needed(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
> +                               0, 0);
> +       vm = vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
> +
> +       if (disable_nx_huge_pages) {
> +               /*
> +                * Cannot run the test without NX huge pages if the kernel
> +                * does not support it.
> +                */
> +               if (!kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES))
> +                       return;
> +
> +               r = __vm_disable_nx_huge_pages(vm);
> +               if (reboot_permissions) {
> +                       TEST_ASSERT(!r, "Disabling NX huge pages should succeed if process has reboot permissions");
> +               } else {
> +                       TEST_ASSERT(r == -EPERM, "This process should not have permission to disable NX huge pages");
> +                       return;
> +               }
>         }
>
> -       vm = vm_create_default(0, 0, guest_code);
> +       vm_vcpu_add_default(vm, 0, guest_code);
>
>         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>                                     HPAGE_GPA, HPAGE_SLOT,
> @@ -133,23 +153,27 @@ int main(int argc, char **argv)
>         /*
>          * Next, the guest will execute from the first huge page, causing it
>          * to be remapped at 4k.
> +        *
> +        * If NX huge pages are disabled, this should have no effect.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 1);
> +       check_2m_page_count(vm, disable_nx_huge_pages ? 2 : 1);
> +       check_split_count(vm, disable_nx_huge_pages ? 0 : 1);
>
>         /*
>          * Executing from the third huge page (previously unaccessed) will
>          * cause part to be mapped at 4k.
> +        *
> +        * If NX huge pages are disabled, it should be mapped at 2M.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
> +       check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
>
>         /* Reading from the first huge page again should have no effect. */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
> +       check_split_count(vm, disable_nx_huge_pages ? 0 : 2);
>
>         /*
>          * Give recovery thread time to run. The wrapper script sets
> @@ -161,8 +185,11 @@ int main(int argc, char **argv)
>
>         /*
>          * Now that the reclaimer has run, all the split pages should be gone.
> +        *
> +        * If NX huge pages are disabled, the relaimer will not run, so
> +        * nothing should change from here on.
>          */
> -       check_2m_page_count(vm, 1);
> +       check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 1);
>         check_split_count(vm, 0);
>
>         /*
> @@ -170,10 +197,25 @@ int main(int argc, char **argv)
>          * reading from it causes a huge page mapping to be installed.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx_huge_pages ? 3 : 2);
>         check_split_count(vm, 0);
>
>         kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       bool reboot_permissions;
> +
> +       if (argc != 3 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {
> +               printf("This test must be run through nx_huge_pages_test.sh");
> +               return KSFT_SKIP;
> +       }
> +
> +       reboot_permissions = strtol(argv[2], NULL, 0);
> +
> +       run_test(false, reboot_permissions);
> +       run_test(true, reboot_permissions);
>
>         return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index 60bfed8181b9..c21c1f639141 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -16,6 +16,8 @@ HUGE_PAGES=$(sudo cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
>
>  set +e
>
> +NXECUTABLE="$(dirname $0)/nx_huge_pages_test"
> +
>  (
>         set -e
>
> @@ -24,7 +26,15 @@ set +e
>         sudo echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
>         sudo echo 3 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>
> -       "$(dirname $0)"/nx_huge_pages_test 887563923
> +       # Test with reboot permissions
> +       sudo setcap cap_sys_boot+ep $NXECUTABLE
> +       $NXECUTABLE 887563923 1
> +
> +       # Test without reboot permissions
> +       if [ $(whoami) != "root" ] ; then
> +               sudo setcap cap_sys_boot-ep $NXECUTABLE
> +               $NXECUTABLE 887563923 0
> +       fi
>  )
>  RET=$?

I feel lazy and dumb for not testing this as a non-root user, but I've
been working on setting up an environment to do such testing for over
a week just to test this commit, with no success. Perhaps I am too
ensconced in Google's development tools. In any case, if anyone is
willing to run this test as a non-root user to make sure it doesn't
blow up, I'd appreciate it. I can confirm that the test works fine
when run as root.

>
> --
> 2.36.0.464.gb9c8b46e94-goog
>
