Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC38302C40
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 21:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbhAYUJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 15:09:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731422AbhAYUIA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 15:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611605193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VjY+Q6oat1z43JuxPE0IZ3Kv3T5sx064JjJN1c5n1Bk=;
        b=Wkg1Pbd3AVI1cNVucys7d6pdRE6n+wbUQIx8nq1VzXm2ZRHe952xgwsvKthtXJXHAgoEtH
        oQHx1uIXchHjlIrt1jgz8JWJ19wSJ3vrTz91XiHEUQHU5BnZsYE/DKqqmpEVI8PfSlVneR
        V6R/US2sEaOplYy1M52/BJ/jDo6Hlyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-FVduRbMZNhGBClCYTe9zjw-1; Mon, 25 Jan 2021 15:06:31 -0500
X-MC-Unique: FVduRbMZNhGBClCYTe9zjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B9E11005D44;
        Mon, 25 Jan 2021 20:06:28 +0000 (UTC)
Received: from work-vm (ovpn-114-3.ams2.redhat.com [10.36.114.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3961677707;
        Mon, 25 Jan 2021 20:06:17 +0000 (UTC)
Date:   Mon, 25 Jan 2021 20:06:14 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v5 4/6] sev/i386: Don't allow a system reset under an
 SEV-ES guest
Message-ID: <20210125200614.GT2925@work-vm>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
 <c1b45c0f74820dffbc28625c9c44f603f44b76ee.1610665956.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b45c0f74820dffbc28625c9c44f603f44b76ee.1610665956.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> An SEV-ES guest does not allow register state to be altered once it has
> been measured. When an SEV-ES guest issues a reboot command, Qemu will
> reset the vCPU state and resume the guest. This will cause failures under
> SEV-ES. Prevent that from occuring by introducing an arch-specific
> callback that returns a boolean indicating whether vCPUs are resettable.
> 
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks, that looks better than the earlier version.
Needs checking by one of the kvm guys, but I think:


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  accel/kvm/kvm-all.c       |  5 +++++
>  include/sysemu/cpus.h     |  2 ++
>  include/sysemu/hw_accel.h |  5 +++++
>  include/sysemu/kvm.h      | 10 ++++++++++
>  softmmu/cpus.c            |  5 +++++
>  softmmu/runstate.c        |  7 +++++--
>  target/arm/kvm.c          |  5 +++++
>  target/i386/kvm/kvm.c     |  6 ++++++
>  target/mips/kvm.c         |  5 +++++
>  target/ppc/kvm.c          |  5 +++++
>  target/s390x/kvm.c        |  5 +++++
>  11 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 9db74b465e..9ac44ad018 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2411,6 +2411,11 @@ void kvm_flush_coalesced_mmio_buffer(void)
>      s->coalesced_flush_in_progress = false;
>  }
>  
> +bool kvm_cpu_check_are_resettable(void)
> +{
> +    return kvm_arch_cpu_check_are_resettable();
> +}
> +
>  static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
>  {
>      if (!cpu->vcpu_dirty) {
> diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
> index e8156728c6..1cb4f9dbeb 100644
> --- a/include/sysemu/cpus.h
> +++ b/include/sysemu/cpus.h
> @@ -57,6 +57,8 @@ extern int icount_align_option;
>  /* Unblock cpu */
>  void qemu_cpu_kick_self(void);
>  
> +bool cpus_are_resettable(void);
> +
>  void cpu_synchronize_all_states(void);
>  void cpu_synchronize_all_post_reset(void);
>  void cpu_synchronize_all_post_init(void);
> diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
> index ffed6192a3..61672f9b32 100644
> --- a/include/sysemu/hw_accel.h
> +++ b/include/sysemu/hw_accel.h
> @@ -22,4 +22,9 @@ void cpu_synchronize_post_reset(CPUState *cpu);
>  void cpu_synchronize_post_init(CPUState *cpu);
>  void cpu_synchronize_pre_loadvm(CPUState *cpu);
>  
> +static inline bool cpu_check_are_resettable(void)
> +{
> +    return kvm_enabled() ? kvm_cpu_check_are_resettable() : true;
> +}
> +
>  #endif /* QEMU_HW_ACCEL_H */
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 875ca101e3..3e265cea3d 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -573,4 +573,14 @@ int kvm_get_max_memslots(void);
>  /* Notify resamplefd for EOI of specific interrupts. */
>  void kvm_resample_fd_notify(int gsi);
>  
> +/**
> + * kvm_cpu_check_are_resettable - return whether CPUs can be reset
> + *
> + * Returns: true: CPUs are resettable
> + *          false: CPUs are not resettable
> + */
> +bool kvm_cpu_check_are_resettable(void);
> +
> +bool kvm_arch_cpu_check_are_resettable(void);
> +
>  #endif
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index 1dc20b9dc3..89de46eae0 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -194,6 +194,11 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu)
>      }
>  }
>  
> +bool cpus_are_resettable(void)
> +{
> +    return cpu_check_are_resettable();
> +}
> +
>  int64_t cpus_get_virtual_clock(void)
>  {
>      /*
> diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> index 636aab0add..7b4f212d19 100644
> --- a/softmmu/runstate.c
> +++ b/softmmu/runstate.c
> @@ -523,8 +523,11 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
>  
>  void qemu_system_reset_request(ShutdownCause reason)
>  {
> -    if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
> -        reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> +    if (!cpus_are_resettable()) {
> +        error_report("cpus are not resettable, terminating");
> +        shutdown_requested = reason;
> +    } else if (reboot_action == REBOOT_ACTION_SHUTDOWN &&
> +               reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>          shutdown_requested = reason;
>      } else {
>          reset_requested = reason;
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ffe186de8d..00e124c812 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1045,3 +1045,8 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
>  {
>      return (data - 32) & 0xffff;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index aaae79557d..bb6bfc19de 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -27,6 +27,7 @@
>  #include "sysemu/kvm_int.h"
>  #include "sysemu/runstate.h"
>  #include "kvm_i386.h"
> +#include "sev_i386.h"
>  #include "hyperv.h"
>  #include "hyperv-proto.h"
>  
> @@ -4788,3 +4789,8 @@ bool kvm_has_waitpkg(void)
>  {
>      return has_msr_umwait;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return !sev_es_enabled();
> +}
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 477692566a..a907c59c5e 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -1289,3 +1289,8 @@ int mips_kvm_type(MachineState *machine, const char *vm_type)
>  
>      return -1;
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index daf690a678..f45ed11058 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2947,3 +2947,8 @@ void kvmppc_svm_off(Error **errp)
>          error_setg_errno(errp, -rc, "KVM_PPC_SVM_OFF ioctl failed");
>      }
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index b8385e6b95..5c5ba801f1 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -2601,3 +2601,8 @@ void kvm_s390_stop_interrupt(S390CPU *cpu)
>  
>      kvm_s390_vcpu_interrupt(cpu, &irq);
>  }
> +
> +bool kvm_arch_cpu_check_are_resettable(void)
> +{
> +    return true;
> +}
> -- 
> 2.30.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

