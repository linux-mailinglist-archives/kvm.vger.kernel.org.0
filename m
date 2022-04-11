Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0539D4FC7BA
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 00:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348869AbiDKWjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 18:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348815AbiDKWjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 18:39:47 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25852E9F5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:37:30 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id q189so5328903ljb.13
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 15:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrGrjFARyK3ZA9nCZV7h5wEeBeAmrUW/GLDl2oKo2fA=;
        b=rRVbEE/gyJt83c9WZThZz5+fBdQ4MARLsuyRyjf+xMbIAmTMfFrkLJKe2yJNXW1Grb
         AVBRve2tLIU+xWeYnOLIF+HJnd4B/7z/C4gD/eZQixX5Z3TGpNIoF/Um2YM3ENqNaPMl
         DGoGqEl+QVl36k/FEmSpZjyUsOjVfxIZsge2ajcT1KSXJuvAvD7dd/SLUdDQA+TgqQPQ
         1Pj6Sa6L7R+lib1yEsGQUXhTpTyZwX7uCi8P7tvwCEbTn1r/PG//8skjaunKN+cUUbBJ
         Ss7J3uY+TPir54okXYABhAbuaIIU3VeymlHiKbDW+7/FqmhZnrcYp+yKETaVd8iL/gSB
         v6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrGrjFARyK3ZA9nCZV7h5wEeBeAmrUW/GLDl2oKo2fA=;
        b=f0ULpUVj1XUQ/7LG5FPo9WgeNSUytHdSwAeOsCduAW0LbHGLBJSIR6cQvZTxTLNaEy
         X1cjU4404qj1UslNf7wpGViKe4NzCfC3E1auPoqyysapDh2dfI8tigkswj8Q33kikQ0x
         7DNXUD4ECL6i2jGrh7s7XHDW3P7kFh8weY7aCfXt4Zs+Iwmmto7los3p8NilzHBCLTIo
         LNAqwAS+NXNILtSW+ULCDuJIghRJz3hXFfr5FrYwVjyL4+it3a8hPtRWJS744+QGDI4f
         qe2XRq7tjvED9gamgLQXlJ2tIPB5Jb7mtQqFFLI/1EbRysNQ466C4u3uuMWShX0a8/6N
         VWvw==
X-Gm-Message-State: AOAM5331V/zcz7t03pAPPOODwir/Yjy+ZMt6R3CIUfTS2WWRE6xX82Bx
        r+bw8YFn1z4zV6wdoXhXvEmXQxWBPLPaLHe7Y2qOuO4PB1I=
X-Google-Smtp-Source: ABdhPJxEnPNx3y8ibz7gBh5nQQPcSkBNcHIKnyOMAAxMAdgYpjjVIDCGFY7ZPeAxejNQlpldM2gkkDXJCn/+pYIN8ds=
X-Received: by 2002:a2e:390c:0:b0:248:1b88:d6c4 with SMTP id
 g12-20020a2e390c000000b002481b88d6c4mr21065587lja.49.1649716648790; Mon, 11
 Apr 2022 15:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-11-bgardon@google.com>
In-Reply-To: <20220411211015.3091615-11-bgardon@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 11 Apr 2022 15:37:02 -0700
Message-ID: <CALzav=difpgKq3X1OGiDPF+5z8AY9wB1sLFrEJ_V7VvuA9_fVA@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] KVM: selftests: Test disabling NX hugepages on a VM
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
>
> Add an argument to the NX huge pages test to test disabling the feature
> on a VM using the new capability.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 19 ++++++-
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 53 +++++++++++++++----
>  3 files changed, 64 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index f9c2ac0a5b97..15f24be6d93f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -412,4 +412,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
>
>  uint32_t guest_get_vcpuid(void);
>
> +int vm_disable_nx_huge_pages(struct kvm_vm *vm);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 833c7e63d62d..5fa5608eef03 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -112,6 +112,15 @@ int vm_check_cap(struct kvm_vm *vm, long cap)
>         return ret;
>  }
>
> +static int __vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
> +{
> +       int ret;
> +
> +       ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +
> +       return ret;
> +}
> +
>  /* VM Enable Capability
>   *
>   * Input Args:
> @@ -128,7 +137,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
>  {
>         int ret;
>
> -       ret = ioctl(vm->fd, KVM_ENABLE_CAP, cap);
> +       ret = __vm_enable_cap(vm, cap);
>         TEST_ASSERT(ret == 0, "KVM_ENABLE_CAP IOCTL failed,\n"
>                 "  rc: %i errno: %i", ret, errno);
>
> @@ -2662,3 +2671,11 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
>                     stat_name, ret);
>         return data;
>  }
> +
> +int vm_disable_nx_huge_pages(struct kvm_vm *vm)
> +{
> +       struct kvm_enable_cap cap = { 0 };
> +
> +       cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> +       return __vm_enable_cap(vm, &cap);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 3f21726b22c7..f8edf7910950 100644
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
> @@ -77,14 +79,41 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>                     expected_splits, actual_splits);
>  }
>
> -int main(int argc, char **argv)
> +void run_test(bool disable_nx)
>  {
>         struct kvm_vm *vm;
>         struct timespec ts;
>         void *hva;
> +       int r;
>
>         vm = vm_create_default(0, 0, guest_code);
>
> +       if (disable_nx) {
> +               kvm_check_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES);
> +
> +               /*
> +                * Check if this process has the reboot permissions needed to
> +                * disable NX huge pages on a VM.
> +                *
> +                * The reboot call below will never have any effect because
> +                * the magic values are not set correctly, however the
> +                * permission check is done before the magic value check.
> +                */
> +               r = syscall(SYS_reboot, 0, 0, 0, NULL);
> +               if (errno == EPERM) {

Should this be:

if (r && errno == EPERM) {

?

Otherwise errno might contain a stale value.

> +                       r = vm_disable_nx_huge_pages(vm);
> +                       TEST_ASSERT(r == EPERM,

TEST_ASSERT(r && errno == EPERM,

> +                                   "This process should not have permission to disable NX huge pages");
> +                       return;
> +               }
> +
> +               TEST_ASSERT(errno == EINVAL,

r && errno == EINVAL ?

> +                           "Reboot syscall should fail with -EINVAL");
> +
> +               r = vm_disable_nx_huge_pages(vm);
> +               TEST_ASSERT(!r, "Disabling NX huge pages should not fail if process has reboot permissions");

nit: s/not fail/succeed/

> +       }
> +
>         vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>                                     HPAGE_GPA, HPAGE_SLOT,
>                                     HPAGE_SLOT_NPAGES, 0);
> @@ -118,21 +147,21 @@ int main(int argc, char **argv)
>          * to be remapped at 4k.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 1);
> +       check_2m_page_count(vm, disable_nx ? 2 : 1);
> +       check_split_count(vm, disable_nx ? 0 : 1);
>
>         /*
>          * Executing from the third huge page (previously unaccessed) will
>          * cause part to be mapped at 4k.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx ? 3 : 1);
> +       check_split_count(vm, disable_nx ? 0 : 2);
>
>         /* Reading from the first huge page again should have no effect. */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 1);
> -       check_split_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx ? 3 : 1);
> +       check_split_count(vm, disable_nx ? 0 : 2);
>
>         /*
>          * Give recovery thread time to run. The wrapper script sets
> @@ -145,7 +174,7 @@ int main(int argc, char **argv)
>         /*
>          * Now that the reclaimer has run, all the split pages should be gone.
>          */
> -       check_2m_page_count(vm, 1);
> +       check_2m_page_count(vm, disable_nx ? 3 : 1);
>         check_split_count(vm, 0);
>
>         /*
> @@ -153,10 +182,16 @@ int main(int argc, char **argv)
>          * reading from it causes a huge page mapping to be installed.
>          */
>         vcpu_run(vm, 0);
> -       check_2m_page_count(vm, 2);
> +       check_2m_page_count(vm, disable_nx ? 3 : 2);
>         check_split_count(vm, 0);
>
>         kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       run_test(false);
> +       run_test(true);
>
>         return 0;
>  }
> --
> 2.35.1.1178.g4f1659d476-goog
>
