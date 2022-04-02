Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B34D4F05C8
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 21:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiDBT2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Apr 2022 15:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiDBT2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Apr 2022 15:28:47 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08FF39807
        for <kvm@vger.kernel.org>; Sat,  2 Apr 2022 12:26:54 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id i186so5638005vsc.9
        for <kvm@vger.kernel.org>; Sat, 02 Apr 2022 12:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t/LC14YDwSQI5azw7ZF6FVDGNIAV0jkW1G7okaOGqRk=;
        b=nEtckNjOBTMKrbOIJasT7EOXCkxcZrAXX8Hf8vWDFS5Wf89sktGV058venfJBa4a7o
         hya4/qffZtsCGpkhiTeokA/sUlOJRpVrMQykZzLuwpiOzGrqCxBtDNtQm+xZr05FGc7q
         g0yRQUHCxftpBEaEp+AHnb0uLZO3JMSc7ANyXudIAKvODNn2HM1/3ZPyX+mpP24dkJiX
         uMmMiLVaNneXc6FEcikUA8mddRTzMB1HoBTGEtAAdg86JsNnZAGlGPnLMQJgiR8Zb1Mz
         NDUTtn/3SQOTOW7Acba5+BESDbAip+Q42MN8xc4vz0sqbtIr8uZeCro6uw/SOqftA+Wz
         SXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t/LC14YDwSQI5azw7ZF6FVDGNIAV0jkW1G7okaOGqRk=;
        b=kvHHQO9ivQwMZaS+Y/o/LT+z6aWCBmsFkgq+uQ0Dmy8i7k8ldr5ei4Bm7Xq2GV2ZXG
         VVVwDBzQbnvOm3VoZdlncAsuKMOOI2Vkq1opHZmk5mJwggEC7FgdYUjQL5Y4BpmqshQJ
         nGiI8bC59+f3st9RDpQ6w4YF7ACxJB3V7zd0PITPy7/AKvRZYRpZWvoYFudGyAqYGZnw
         qjolKKEsnN0Rx22g82Jt5bZSjdlqeDUQ2QitUqPIbl7+bSjl4HKnqoJXZ/0d6KvrccR6
         PDQ8jixTURyje5pSOcGkZpSqFvgX4rlpEpW3Vr172NPy4nb7Sm/K69Kv4ugWpld10AZx
         NKnA==
X-Gm-Message-State: AOAM531Q3Y8ZMs4xfl3xwO5RN/Z+iK9IpoSuIRwX4plOdMZ5cUdqcYPp
        43E6Y/iMcIr6qzL53zaUwRJRw0nHQV7NIhqAtp1JCA==
X-Google-Smtp-Source: ABdhPJwLoXKzHzsBiEB7M9xDR4ymXqNoGSUoH8thPTWAdfRCM7w8J8tF92PXQIdN09YqyktiqFV+OuhFJaFHVURxbdA=
X-Received: by 2002:a05:6102:cd1:b0:325:932b:2c51 with SMTP id
 g17-20020a0561020cd100b00325932b2c51mr5111223vst.38.1648927613782; Sat, 02
 Apr 2022 12:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com> <20220402174044.2263418-4-oupton@google.com>
In-Reply-To: <20220402174044.2263418-4-oupton@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Sat, 2 Apr 2022 12:26:42 -0700
Message-ID: <CAAdAUthAHgWpmzg+bVrN7wLunA6cKJBpkyz8tgtYxmpxiYW5Qw@mail.gmail.com>
Subject: Re: [PATCH 3/4] selftests: KVM: Don't leak GIC FD across dirty log
 test iterations
To:     Oliver Upton <oupton@google.com>
Cc:     KVM ARM <kvmarm@lists.cs.columbia.edu>, KVM <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

On Sat, Apr 2, 2022 at 10:40 AM Oliver Upton <oupton@google.com> wrote:
>
> dirty_log_perf_test instantiates a VGICv3 for the guest (if supported by
> hardware) to reduce the overhead of guest exits. However, the test does
> not actually close the GIC fd when cleaning up the VM between test
> iterations, meaning that the VM is never actually destroyed in the
> kernel.
>
> While this is generally a bad idea, the bug was detected from the kernel
> spewing about duplicate debugfs entries as subsequent VMs happen to
> reuse the same FD even though the debugfs directory is still present.
>
> Abstract away the notion of setup/cleanup of the GIC FD from the test
> by creating arch-specific helpers for test setup/cleanup. Close the GIC
> FD on VM cleanup and do nothing for the other architectures.
>
> Fixes: c340f7899af6 ("KVM: selftests: Add vgic initialization for dirty log perf test for ARM")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
>  1 file changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index c9d9e513ca04..7b47ae4f952e 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -18,11 +18,40 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +
>  #ifdef __aarch64__
>  #include "aarch64/vgic.h"
>
>  #define GICD_BASE_GPA                  0x8000000ULL
>  #define GICR_BASE_GPA                  0x80A0000ULL
> +
> +static int gic_fd;
> +
> +static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
> +{
> +       /*
> +        * The test can still run even if hardware does not support GICv3, as it
> +        * is only an optimization to reduce guest exits.
> +        */
> +       gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +}
> +
> +static void arch_cleanup_vm(struct kvm_vm *vm)
> +{
> +       if (gic_fd > 0)
> +               close(gic_fd);
> +}
> +
> +#else /* __aarch64__ */
> +
> +static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
> +{
> +}
> +
> +static void arch_cleanup_vm(struct kvm_vm *vm)
> +{
> +}
> +
>  #endif
>
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> @@ -206,9 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 vm_enable_cap(vm, &cap);
>         }
>
> -#ifdef __aarch64__
> -       vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> -#endif
> +       arch_setup_vm(vm, nr_vcpus);
>
>         /* Start the iterations */
>         iteration = 0;
> @@ -302,6 +329,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         }
>
>         free_bitmaps(bitmaps, p->slots);
> +       arch_cleanup_vm(vm);
>         perf_test_destroy_vm(vm);
>  }
>
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
