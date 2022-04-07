Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056A54F872B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346873AbiDGSlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiDGSlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:41:44 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23948B1E4
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:39:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j2so11229546ybu.0
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAeh1ndb0Eg7crGtnJw58Z18iLuAWHcKGHUFeHgg7EU=;
        b=iAGglqeFMyEMYEbXVVJz2ahPPQGXs05Lu40ZiS45GElujDVJbJUy9Efi4NNnHKc3SG
         vauY2UtrCTtXZiMkbtBUVZ4BbybaOWNabqExTPkDE+ApFK41H5n3EtY+BY7X95Ujks2/
         2HuKA6ppec7EC29v7VtlAGMs1EapnORaIfA0/Ep0eNojwKwUTZtHyP6lOXC/OdzeFyat
         ReHyDFc007uF1OBxM5KUwgVdqyr0HKD/wpwrU5qw3J/bbgnayP9rdseycOONPBDwjXO7
         APJNhwxI4aZYdSU7fl/998zIlhLafQ2kaDNLHYzt7Z4LxDMuW3rvwGm1OvHcpYggTx0H
         mT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAeh1ndb0Eg7crGtnJw58Z18iLuAWHcKGHUFeHgg7EU=;
        b=j1AOmhtp4MEzNnxvBhl4aNY5K8bRGZkNYU1nsPlItKU6lxNwtnCdv6PP9T/sjG0kIZ
         OCgFUCO35bmNnCyHdoXFHuA/Imh9NHtepSlliFr6EhH0DHyIH7/KjIeg6XO24/Je29BF
         qpAWD8lSco0WGaeL7klBDGr/9rrzjOj19snumA41EjkJna2Qxu0CzTLvrve9xnD23sIB
         BXUKCrSIfYHVhDQ5xP6rFoZCg3OuhPYEZV6E2iUfmtHvAP1LNfxIFD0doPy123bqxpuL
         JNZ/hcQOUXNXVgjjdNwmEjYcB0fhZkcEiCEbyYldOekp0toFSUTHg2fvQsWvA74K5dzW
         lvfg==
X-Gm-Message-State: AOAM531/aDKCIsWidkzmRB0uTnyJl/fe2+KEhOIOzQ+mATFMHwMnekHI
        P8lL/os0eFia+lnnUjGxzyQ4bl4dX8hdFeNyc4gjKLFqRk4=
X-Google-Smtp-Source: ABdhPJw6fUkBOot/5tKJVB/SZ4xNUe+ZQDw7nGdUNTRn7ju/pEMnTWpQL3KjGTxKq5iRZ15sy8GNE95wxOek3GcEHuU=
X-Received: by 2002:a25:94a:0:b0:615:7cf4:e2cd with SMTP id
 u10-20020a25094a000000b006157cf4e2cdmr11831622ybm.227.1649356782119; Thu, 07
 Apr 2022 11:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-12-bgardon@google.com>
 <YkzI2CL13ZMnPOb2@google.com> <CANgfPd9b90NTM5CS19KU187-mFD3Kx_0FYX1cZ1YEonhbYqL0A@mail.gmail.com>
In-Reply-To: <CANgfPd9b90NTM5CS19KU187-mFD3Kx_0FYX1cZ1YEonhbYqL0A@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 7 Apr 2022 11:39:31 -0700
Message-ID: <CANgfPd9zbKx655-m=jkN4kC4v8LBr5DY+5=wa1L=fAftkjmp_A@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] selftests: KVM: Test disabling NX hugepages on a VM
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
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

On Thu, Apr 7, 2022 at 11:26 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Tue, Apr 5, 2022 at 3:55 PM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, Mar 30, 2022 at 10:46:21AM -0700, Ben Gardon wrote:
> > > Add an argument to the NX huge pages test to test disabling the feature
> > > on a VM using the new capability.
> > >
> > > Signed-off-by: Ben Gardon <bgardon@google.com>
> > > ---
> > >  .../selftests/kvm/include/kvm_util_base.h     |  2 +
> > >  tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ++
> > >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 67 ++++++++++++++++---
> > >  .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
> > >  4 files changed, 66 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > index 72163ba2f878..4db8251c3ce5 100644
> > > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > > @@ -411,4 +411,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
> > >
> > >  uint32_t guest_get_vcpuid(void);
> > >
> > > +void vm_disable_nx_huge_pages(struct kvm_vm *vm);
> > > +
> > >  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index 9d72d1bb34fa..46a7fa08d3e0 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -2765,3 +2765,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
> > >       return value;
> > >  }
> > >
> > > +void vm_disable_nx_huge_pages(struct kvm_vm *vm)
> > > +{
> > > +     struct kvm_enable_cap cap = { 0 };
> > > +
> > > +     cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> > > +     vm_enable_cap(vm, &cap);
> > > +}
> > > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > index 2bcbe4efdc6a..a0c79f6ddc08 100644
> > > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > > @@ -13,6 +13,8 @@
> > >  #include <fcntl.h>
> > >  #include <stdint.h>
> > >  #include <time.h>
> > > +#include <linux/reboot.h>
> > > +#include <sys/syscall.h>
> > >
> > >  #include <test_util.h>
> > >  #include "kvm_util.h"
> > > @@ -57,13 +59,56 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
> > >                   expected_splits, actual_splits);
> > >  }
> > >
> > > +static void help(void)
> > > +{
> > > +     puts("");
> > > +     printf("usage: nx_huge_pages_test.sh [-x]\n");
> > > +     puts("");
> > > +     printf(" -x: Allow executable huge pages on the VM.\n");
> >
> > Making it a flag means we won't exercise it by default. Is there are
> > reason to avoid exercising KVM_CAP_VM_DISABLE_NX_HUGE_PAGES by default?
> >
> > Assuming no, I would recommend factoring out the test to a helper
> > function that takes a parameter that tells it if nx_huge_pages is
> > enabled or disabled. Then run this helper function multiple times. E.g.
> > once with nx_huge_pages enabled, once with nx_huge_pages disabled via
> > KVM_CAP_VM_DISABLE_NX_HUGE_PAGES. This would also then let you test that
> > disabling via module param also works.
> >
> > By the way, that brings up another issue. What if NX HugePages is not
> > enabled on this host? e.g. we're running on AMD, or we're running on a
> > non-affected Intel host, or we're running on a machine where nx huge
> > pages has been disabled by the admin? The test should probably return
> > KSFT_SKIP in those cases.

The wrapper script just always turns nx_huge_pages on, which I think
is a better solution, but perhaps it should check for permission
errors when doing that.

>
> That's all a good idea. Will do.
>
> >
> > > +     puts("");
> > > +     exit(0);
> > > +}
> > > +
> > >  int main(int argc, char **argv)
> > >  {
> > >       struct kvm_vm *vm;
> > >       struct timespec ts;
> > > +     bool disable_nx = false;
> > > +     int opt;
> > > +     int r;
> > > +
> > > +     while ((opt = getopt(argc, argv, "x")) != -1) {
> > > +             switch (opt) {
> > > +             case 'x':
> > > +                     disable_nx = true;
> > > +                     break;
> > > +             case 'h':
> > > +             default:
> > > +                     help();
> > > +                     break;
> > > +             }
> > > +     }
> > >
> > >       vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > >
> > > +     if (disable_nx) {
> > > +             /*
> > > +              * Check if this process has the reboot permissions needed to
> > > +              * disable NX huge pages on a VM.
> > > +              *
> > > +              * The reboot call below will never have any effect because
> > > +              * the magic values are not set correctly, however the
> > > +              * permission check is done before the magic value check.
> > > +              */
> > > +             r = syscall(SYS_reboot, 0, 0, 0, NULL);
> > > +             if (r == -EPERM)
> > > +                     return KSFT_SKIP;
> > > +             TEST_ASSERT(r == -EINVAL,
> > > +                         "Reboot syscall should fail with -EINVAL");
> >
> > Just check if KVM_CAP_VM_DISABLE_NX_HUGE_PAGES returns -EPERM?

We could do that but then we wouldn't be checking that the permission
checks work as expected.

> >
> > > +
> > > +             vm_disable_nx_huge_pages(vm);
> > > +     }
> > > +
> > >       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> > >                                   HPAGE_PADDR_START, HPAGE_SLOT,
> > >                                   HPAGE_SLOT_NPAGES, 0);
> > > @@ -83,21 +128,21 @@ int main(int argc, char **argv)
> > >        * at 2M.
> > >        */
> > >       run_guest_code(vm, guest_code0);
> > > -     check_2m_page_count(vm, 2);
> > > -     check_split_count(vm, 2);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 2);
> > > +     check_split_count(vm, disable_nx ? 0 : 2);
> > >
> > >       /*
> > >        * guest_code1 is in the same huge page as data1, so it will cause
> > >        * that huge page to be remapped at 4k.
> > >        */
> > >       run_guest_code(vm, guest_code1);
> > > -     check_2m_page_count(vm, 1);
> > > -     check_split_count(vm, 3);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > > +     check_split_count(vm, disable_nx ? 0 : 3);
> > >
> > >       /* Run guest_code0 again to check that is has no effect. */
> > >       run_guest_code(vm, guest_code0);
> > > -     check_2m_page_count(vm, 1);
> > > -     check_split_count(vm, 3);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > > +     check_split_count(vm, disable_nx ? 0 : 3);
> > >
> > >       /*
> > >        * Give recovery thread time to run. The wrapper script sets
> > > @@ -110,7 +155,7 @@ int main(int argc, char **argv)
> > >       /*
> > >        * Now that the reclaimer has run, all the split pages should be gone.
> > >        */
> > > -     check_2m_page_count(vm, 1);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > >       check_split_count(vm, 0);
> > >
> > >       /*
> > > @@ -118,13 +163,13 @@ int main(int argc, char **argv)
> > >        * again to check that pages are mapped at 2M again.
> > >        */
> > >       run_guest_code(vm, guest_code0);
> > > -     check_2m_page_count(vm, 2);
> > > -     check_split_count(vm, 2);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 2);
> > > +     check_split_count(vm, disable_nx ? 0 : 2);
> > >
> > >       /* Pages are once again split from running guest_code1. */
> > >       run_guest_code(vm, guest_code1);
> > > -     check_2m_page_count(vm, 1);
> > > -     check_split_count(vm, 3);
> > > +     check_2m_page_count(vm, disable_nx ? 4 : 1);
> > > +     check_split_count(vm, disable_nx ? 0 : 3);
> > >
> > >       kvm_vm_free(vm);
> > >
> > > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > > index 19fc95723fcb..29f999f48848 100755
> > > --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > > @@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> > >  echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> > >  echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > >
> > > -./nx_huge_pages_test
> > > +./nx_huge_pages_test "${@}"
> > >  RET=$?
> > >
> > >  echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> > > --
> > > 2.35.1.1021.g381101b075-goog
> > >
