Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D74C06CB
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfI0N6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 09:58:08 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41995 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0N6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 09:58:08 -0400
Received: by mail-ot1-f66.google.com with SMTP id c10so2292625otd.9
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 06:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/L1vk8ZEX1dDFsyoP8jdEPTbwfmUYl1fqd9uotjBFoQ=;
        b=x6m1c+RIp9S7ggPV9dD5W8bthMp/oigvGlUwn0P8vP5dyfwGciPgIqLFSuAVJxZPT4
         CP1cRDyy5hWppSOhv0KDBB61zO+IFpXNGI9iJem8UT4mVqmcgi88bOBU/9ZxJPZhBc66
         NYfbHGjn5kYCx10GDN4KZHp3WaSqs2qDXPPku+2r2jW2IdjNn2FRco56rhpVbNOECVrb
         Hi7Pbi+KAs7QTCI6zE6oGtw5lJM56TyEluaqfhrFZ0YCecLW7xlhTiy0ax39XnZTKVD9
         meU7mgozp/vriibdlNDuOGKLahraOnRjlW2dur9VMe5fVTVbmuGzJN4udrCOFHmDGOlN
         m0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/L1vk8ZEX1dDFsyoP8jdEPTbwfmUYl1fqd9uotjBFoQ=;
        b=QmftvDg5sS7Ih7XZOJfamXIoQMsZJfQ1RlV+2z+P/iJG9iINyTa9jX2bs3l9Re74v2
         LYmIfreACHRGKZDeH6ZOAq7YvRvTNHHAhAdOfC43/1EZNjCgEY0sVWdFQv6Ia6xvdFeR
         rg0aM/DrlqvaMkFVTiwJmKpFx/FarJhe+UOgO2dTWctKazZ7OBM+IXyqcdKRpXai5XKI
         7MBpDViL65EF4kTa70cVp8+5NcL6w/sT5fBTc5z4Who3orEsI3skj2LTQKpDVNHAPnXq
         X6noXr/9LRLLQqZHAQ0MPnFsNSRlbIpqg/MCfprNt+0naG4N/0ZbCkehPW8QKCnleZ6f
         bQCQ==
X-Gm-Message-State: APjAAAURTsWzB4UR45LjioUfGTE866A6G+3Rx+8R5M3kNa6vJH1GkoE1
        RWepO9q9OvrKJAlme3GHh2ojLWzIILBab9b4aNGmBw==
X-Google-Smtp-Source: APXvYqx/U/Fyiz/LD14vi413zuKKZi9VIQ+Ap4zw2wBTN+o9Bnb6t+a9XUiOR3Rrp5pKjc5Z52IKSf9Io7r6O3MckpI=
X-Received: by 2002:a05:6830:1357:: with SMTP id r23mr3354259otq.91.1569592685416;
 Fri, 27 Sep 2019 06:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190906083152.25716-1-zhengxiang9@huawei.com> <20190906083152.25716-7-zhengxiang9@huawei.com>
In-Reply-To: <20190906083152.25716-7-zhengxiang9@huawei.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 27 Sep 2019 14:57:54 +0100
Message-ID: <CAFEAcA9Y3J8uRDN+HQO74-codKhoj5CyPW=9q3GwH8Mk_PNYTA@mail.gmail.com>
Subject: Re: [PATCH v18 6/6] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        gengdongjiu <gengdongjiu@huawei.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Sep 2019 at 09:33, Xiang Zheng <zhengxiang9@huawei.com> wrote:
>
> From: Dongjiu Geng <gengdongjiu@huawei.com>
>
> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> translates the host VA delivered by host to guest PA, then fills this PA
> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> type.
>
> If guest accesses the poisoned memory, it generates Synchronous External
> Abort(SEA). Then host kernel gets an APEI notification and calls
> memory_failure() to unmapped the affected page in stage 2, finally
> returns to guest.
>
> Guest continues to access PG_hwpoison page, it will trap to KVM as
> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> Qemu, Qemu records this error address into guest APEI GHES memory and
> notifes guest using Synchronous-External-Abort(SEA).
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> ---
>  hw/acpi/acpi_ghes.c         | 252 ++++++++++++++++++++++++++++++++++++
>  include/hw/acpi/acpi_ghes.h |  40 ++++++
>  include/sysemu/kvm.h        |   2 +-
>  target/arm/kvm64.c          |  39 ++++++
>  4 files changed, 332 insertions(+), 1 deletion(-)

I'll let somebody else review the ACPI parts as that's not my
area of expertise, but I'll look at the target/arm parts below:

> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> index 20c45179ff..2d17c88045 100644
> --- a/hw/acpi/acpi_ghes.c
> +++ b/hw/acpi/acpi_ghes.c
> @@ -26,6 +26,168 @@
>  #include "sysemu/sysemu.h"
>  #include "qemu/error-report.h"
>
> +/* Total size for Generic Error Status Block

This block comment should start with '/*' on a line of its own
(as should others in this patch). Usually checkpatch catches these
but it's not infallible.

> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 909bcd77cf..5f57e4ed43 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -378,7 +378,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
>
> -#ifdef TARGET_I386
> +#if defined(TARGET_I386) || defined(TARGET_AARCH64)
>  #define KVM_HAVE_MCE_INJECTION 1
>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
>  #endif

Rather than introducing a new ifdef with lots of TARGET_*,
I think it would be better to have target/i386/cpu.h and
target/arm/cpu.h do "#define KVM_HAVE_MCE_INJECTION 1"
(nb that the arm cpu.h needs to define it only for aarch64,
not for 32-bit arm host compiles).

and then kvm.h can just do
#ifdef KVM_HAVE_MCE_INJECTION
void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
#endif

> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index bf6edaa3f6..186d855522 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -28,6 +28,8 @@
>  #include "kvm_arm.h"
>  #include "hw/boards.h"
>  #include "internals.h"
> +#include "hw/acpi/acpi.h"
> +#include "hw/acpi/acpi_ghes.h"
>
>  static bool have_guest_debug;
>
> @@ -1070,6 +1072,43 @@ int kvm_arch_get_registers(CPUState *cs)
>      return ret;
>  }
>
> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> +{
> +    ram_addr_t ram_addr;
> +    hwaddr paddr;
> +
> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> +
> +    if (acpi_enabled && addr &&
> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
> +        ram_addr = qemu_ram_addr_from_host(addr);
> +        if (ram_addr != RAM_ADDR_INVALID &&
> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> +            kvm_hwpoison_page_add(ram_addr);
> +            /* Asynchronous signal will be masked by main thread, so
> +             * only handle synchronous signal.
> +             */

I don't entirely understand this comment. The x86 version
of this function says:

    /* If we get an action required MCE, it has been injected by KVM
     * while the VM was running.  An action optional MCE instead should
     * be coming from the main thread, which qemu_init_sigbus identifies
     * as the "early kill" thread.
     */

so we can be called for action-optional MCE here (not on the vcpu
thread). We obviously can't deliver those as a synchronous exception
to a particular CPU, but is there no mechanism for reporting them
to the guest at all?

> +            if (code == BUS_MCEERR_AR) {
> +                kvm_cpu_synchronize_state(c);
> +                if (ACPI_GHES_CPER_FAIL !=
> +                    acpi_ghes_record_errors(ACPI_GHES_NOTIFY_SEA, paddr)) {
> +                    kvm_inject_arm_sea(c);
> +                } else {
> +                    fprintf(stderr, "failed to record the error\n");
> +                }
> +            }
> +            return;
> +        }
> +        fprintf(stderr, "Hardware memory error for memory used by "
> +                "QEMU itself instead of guest system!\n");
> +    }
> +
> +    if (code == BUS_MCEERR_AR) {
> +        fprintf(stderr, "Hardware memory error!\n");
> +        exit(1);
> +    }
> +}
> +
>  /* C6.6.29 BRK instruction */
>  static const uint32_t brk_insn = 0xd4200000;
>

thanks
-- PMM
