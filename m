Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED1D4A395
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfFRONp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:13:45 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36279 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfFRONp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:13:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id i21so13318646ljj.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 07:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=kTF2KOba66vncg2OrIhfqhu+WMIDx8S8lB/RCQOcT1o=;
        b=VTJmahoDDXaJEdnWBVjGVdBDD+VAGBP6UORvKubloOk2QZRp/om10Nq658z0WKVo6b
         sOe92tsSx5+6/h5VbDf1JXnP2iL/xNmbXLTUs6duveS6J2Vj5JRBrUw5DKmyoOHYL5QN
         GNtnpnMtMECLXSHotMG14UHjTaXbyn9M0F9/IDkRYSPVWgWAmtwxLXzGZ/eW9aZgC0+U
         ud33wyATVPAkogMYKQRORdEwkARrG9L26e0puOfyMS9OhZLzhS5Ize0qp95YyzCBiEIF
         NR7gh5qyj2MB/sXa2HGfmApAC+Thc6c7GbzUtX/g4QDa7bu1RVqvzxfP6qDNRKDZitBX
         FSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=kTF2KOba66vncg2OrIhfqhu+WMIDx8S8lB/RCQOcT1o=;
        b=tRhHhk4SUjxh+566i4OaKwUckc9pT9HLftRWrj+CVy2ltzNdrjSevFmUKJOo3/ypg7
         3M8TOEri8BxGByH2Jh344XjBHup49Ta+NQR8lgBIU6+sO7xz0aYd0Zm6JIs/Ig2QexJd
         wQFx1ezOITrrwC8B61aEjxiVopVIQPKRaxvyC0FjS+ju/TwqHX7Z5ArF5YcGOX2pU1sQ
         k0+jix7B7ubHFbHyeUf/1aiYfXGrPQhwvXUuH+A5Dnr1k2F21DB8EGMgnXsIfXCLd2Me
         VMxgGnffinlA4MADEm/aJ8ngJUxnnbLDCgNDXDtCw7g/USbpaTnorl3xHvwo9nwEbFXN
         hWtA==
X-Gm-Message-State: APjAAAWz67MueAyLpLmj9209mtVoCO/JudIl0O4RC2ok9JqOssPTKlUz
        7AHI4hipqDWfzmrkw2wtDHRV4kDi338bPuHknQb3Dsvc/to=
X-Google-Smtp-Source: APXvYqwhmDKAyxi+XYA9xFZcOFpeloki6TLHkFqtvG7vJ6GaZeDa4hIugLmk2OFkKWF/ifklrXNkevg4BkCPTR17P0I=
X-Received: by 2002:a2e:994:: with SMTP id 142mr32687591ljj.130.1560867222775;
 Tue, 18 Jun 2019 07:13:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190531141452.158909-1-aaronlewis@google.com>
In-Reply-To: <20190531141452.158909-1-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 18 Jun 2019 07:13:31 -0700
Message-ID: <CAAAPnDHLk=8SMKVy9-mPWWt2t+WX4xS+BKLQJox7vbnHwK50BA@mail.gmail.com>
Subject: Re: [PATCH] tests: kvm: Check for a kernel warning
To:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 31, 2019 at 7:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When running with /sys/module/kvm_intel/parameters/unrestricted_guest=N,
> test that a kernel warning does not occur informing us that
> vcpu->mmio_needed=1.  This can happen when KVM_RUN is called after a
> triple fault.
> This test was made to detect a bug that was reported by Syzkaller
> (https://groups.google.com/forum/#!topic/syzkaller/lHfau8E3SOE) and
> fixed with commit bbeac2830f4de ("KVM: X86: Fix residual mmio emulation
> request to userspace").
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/include/x86_64/processor.h  |   2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  36 +++++
>  .../selftests/kvm/lib/x86_64/processor.c      |  16 +++
>  .../selftests/kvm/x86_64/mmio_warning_test.c  | 126 ++++++++++++++++++
>  7 files changed, 184 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
>
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index df1bf9230a74..41266af0d3dc 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -2,6 +2,7 @@
>  /x86_64/evmcs_test
>  /x86_64/hyperv_cpuid
>  /x86_64/kvm_create_max_vcpus
> +/x86_64/mmio_warning_test
>  /x86_64/platform_info_test
>  /x86_64/set_sregs_test
>  /x86_64/smm_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 79c524395ebe..670b938f1049 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -22,6 +22,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> +TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 8c6b9619797d..c5c427c86598 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -137,6 +137,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_size,
>                                  void *guest_code);
>  void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
>
> +bool vm_is_unrestricted_guest(struct kvm_vm *vm);
> +
>  struct kvm_userspace_memory_region *
>  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>                                  uint64_t end);
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6063d5b2f356..af4d26de32d1 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -303,6 +303,8 @@ static inline unsigned long get_xmm(int n)
>         return 0;
>  }
>
> +bool is_intel_cpu(void);
> +
>  struct kvm_x86_state;
>  struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
>  void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e9113857f44e..b93b09ad9a11 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1584,3 +1584,39 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>         return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
>  }
> +
> +/*
> + * Is Unrestricted Guest
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *
> + * Output Args: None
> + *
> + * Return: True if the unrestricted guest is set to 'Y', otherwise return false.
> + *
> + * Check if the unrestricted guest flag is enabled.
> + */
> +bool vm_is_unrestricted_guest(struct kvm_vm *vm)
> +{
> +       char val = 'N';
> +       size_t count;
> +       FILE *f;
> +
> +       if (vm == NULL) {
> +               /* Ensure that the KVM vendor-specific module is loaded. */
> +               f = fopen(KVM_DEV_PATH, "r");
> +               TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> +                           errno);
> +               fclose(f);
> +       }
> +
> +       f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> +       if (f) {
> +               count = fread(&val, sizeof(char), 1, f);
> +               TEST_ASSERT(count == 1, "Unable to read from param file.");
> +               fclose(f);
> +       }
> +
> +       return val == 'Y';
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index dc7fae9fa424..bcc0e70e1856 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1139,3 +1139,19 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
>                         r);
>         }
>  }
> +
> +bool is_intel_cpu(void)
> +{
> +       int eax, ebx, ecx, edx;
> +       const uint32_t *chunk;
> +       const int leaf = 0;
> +
> +       __asm__ __volatile__(
> +               "cpuid"
> +               : /* output */ "=a"(eax), "=b"(ebx),
> +                 "=c"(ecx), "=d"(edx)
> +               : /* input */ "0"(leaf), "2"(0));
> +
> +       chunk = (const uint32_t *)("GenuineIntel");
> +       return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> new file mode 100644
> index 000000000000..00bb97d76000
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> @@ -0,0 +1,126 @@
> +/*
> + * mmio_warning_test
> + *
> + * Copyright (C) 2019, Google LLC.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * Test that we don't get a kernel warning when we call KVM_RUN after a
> + * triple fault occurs.  To get the triple fault to occur we call KVM_RUN
> + * on a VCPU that hasn't been properly setup.
> + *
> + */
> +
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <kvm_util.h>
> +#include <linux/kvm.h>
> +#include <processor.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <test_util.h>
> +#include <unistd.h>
> +
> +#define NTHREAD 4
> +#define NPROCESS 5
> +
> +struct thread_context {
> +       int kvmcpu;
> +       struct kvm_run *run;
> +};
> +
> +void *thr(void *arg)
> +{
> +       struct thread_context *tc = (struct thread_context *)arg;
> +       int res;
> +       int kvmcpu = tc->kvmcpu;
> +       struct kvm_run *run = tc->run;
> +
> +       res = ioctl(kvmcpu, KVM_RUN, 0);
> +       printf("ret1=%d exit_reason=%d suberror=%d\n",
> +               res, run->exit_reason, run->internal.suberror);
> +
> +       return 0;
> +}
> +
> +void test(void)
> +{
> +       int i, kvm, kvmvm, kvmcpu;
> +       pthread_t th[NTHREAD];
> +       struct kvm_run *run;
> +       struct thread_context tc;
> +
> +       kvm = open("/dev/kvm", O_RDWR);
> +       TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
> +       kvmvm = ioctl(kvm, KVM_CREATE_VM, 0);
> +       TEST_ASSERT(kvmvm != -1, "KVM_CREATE_VM failed");
> +       kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
> +       TEST_ASSERT(kvmcpu != -1, "KVM_CREATE_VCPU failed");
> +       run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
> +                                   kvmcpu, 0);
> +       tc.kvmcpu = kvmcpu;
> +       tc.run = run;
> +       srand(getpid());
> +       for (i = 0; i < NTHREAD; i++) {
> +               pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
> +               usleep(rand() % 10000);
> +       }
> +       for (i = 0; i < NTHREAD; i++)
> +               pthread_join(th[i], NULL);
> +}
> +
> +int get_warnings_count(void)
> +{
> +       int warnings;
> +       FILE *f;
> +
> +       f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
> +       fscanf(f, "%d", &warnings);
> +       fclose(f);
> +
> +       return warnings;
> +}
> +
> +int main(void)
> +{
> +       int warnings_before, warnings_after;
> +
> +       if (!is_intel_cpu()) {
> +               printf("Must be run on an Intel CPU, skipping test\n");
> +               exit(KSFT_SKIP);
> +       }
> +
> +       if (vm_is_unrestricted_guest(NULL)) {
> +               printf("Unrestricted guest must be disabled, skipping test\n");
> +               exit(KSFT_SKIP);
> +       }
> +
> +       warnings_before = get_warnings_count();
> +
> +       for (int i = 0; i < NPROCESS; ++i) {
> +               int status;
> +               int pid = fork();
> +
> +               if (pid < 0)
> +                       exit(1);
> +               if (pid == 0) {
> +                       test();
> +                       exit(0);
> +               }
> +               while (waitpid(pid, &status, __WALL) != pid)
> +                       ;
> +       }
> +
> +       warnings_after = get_warnings_count();
> +       TEST_ASSERT(warnings_before == warnings_after,
> +                  "Warnings found in kernel.  Run 'dmesg' to inspect them.");
> +
> +       return 0;
> +}
> --
> 2.22.0.rc1.311.g5d7573a151-goog
>

ping
