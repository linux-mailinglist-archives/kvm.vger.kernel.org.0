Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDB626E19D
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 19:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgIQRB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 13:01:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728851AbgIQRBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 13:01:36 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 13:01:35 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600362092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AOcg7erdQiG6t1re3jBjRLL6u+BC9P88PDt8o+CU52k=;
        b=ez/sMK6MBIRNC4TbsSwUqlbi9k4T8zFbfaYnGVqDVLMcH1JEsC1dC6XybtO0VZkjmJam54
        qrQTYXCMy2Bq5nlxyMfzFunxe1i5JcWqWcU8cIK+MNULDfFUs/GW6HkcT7B/j09Dnm4+z5
        k036HCaHAwE3XigljIQLjAPZjc8uRpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-etVH8VP5NKa1lqdHXXr32w-1; Thu, 17 Sep 2020 13:01:30 -0400
X-MC-Unique: etVH8VP5NKa1lqdHXXr32w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 618EF800467;
        Thu, 17 Sep 2020 17:01:28 +0000 (UTC)
Received: from work-vm (ovpn-114-108.ams2.redhat.com [10.36.114.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9306078803;
        Thu, 17 Sep 2020 17:01:22 +0000 (UTC)
Date:   Thu, 17 Sep 2020 18:01:19 +0100
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
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 4/5] sev/i386: Don't allow a system reset under an
 SEV-ES guest
Message-ID: <20200917170119.GR2793@work-vm>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <058dcb33a9cc223e3180133d29e7a92bfdc40938.1600205384.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <058dcb33a9cc223e3180133d29e7a92bfdc40938.1600205384.git.thomas.lendacky@amd.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Tom Lendacky (thomas.lendacky@amd.com) wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> An SEV-ES guest does not allow register state to be altered once it has
> been measured. When a SEV-ES guest issues a reboot command, Qemu will
> reset the vCPU state and resume the guest. This will cause failures under
> SEV-ES, so prevent that from occurring.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  accel/kvm/kvm-all.c       | 9 +++++++++
>  include/sysemu/cpus.h     | 2 ++
>  include/sysemu/hw_accel.h | 5 +++++
>  include/sysemu/kvm.h      | 2 ++
>  softmmu/cpus.c            | 5 +++++
>  softmmu/vl.c              | 5 ++++-
>  6 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 20725b0368..63153b6e53 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2388,6 +2388,15 @@ void kvm_flush_coalesced_mmio_buffer(void)
>      s->coalesced_flush_in_progress = false;
>  }
>  
> +bool kvm_cpu_check_resettable(void)
> +{
> +    /*
> +     * If we have a valid reset vector override, then SEV-ES is active
> +     * and the CPU can't be reset.
> +     */
> +    return !kvm_state->reset_valid;

This seems a bit weird since it's in generic rather than x86 specific
code.

Dave

> +}
> +
>  static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
>  {
>      if (!cpu->vcpu_dirty) {
> diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
> index 3c1da6a018..6d688c757f 100644
> --- a/include/sysemu/cpus.h
> +++ b/include/sysemu/cpus.h
> @@ -24,6 +24,8 @@ void dump_drift_info(void);
>  void qemu_cpu_kick_self(void);
>  void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
>  
> +bool cpu_is_resettable(void);
> +
>  void cpu_synchronize_all_states(void);
>  void cpu_synchronize_all_post_reset(void);
>  void cpu_synchronize_all_post_init(void);
> diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
> index e128f8b06b..8b4536e7ae 100644
> --- a/include/sysemu/hw_accel.h
> +++ b/include/sysemu/hw_accel.h
> @@ -17,6 +17,11 @@
>  #include "sysemu/hvf.h"
>  #include "sysemu/whpx.h"
>  
> +static inline bool cpu_check_resettable(void)
> +{
> +    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
> +}
> +
>  static inline void cpu_synchronize_state(CPUState *cpu)
>  {
>      if (kvm_enabled()) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index f74cfa85ab..eb94bbbff9 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
>  
>  #endif /* NEED_CPU_H */
>  
> +bool kvm_cpu_check_resettable(void);
> +
>  void kvm_cpu_synchronize_state(CPUState *cpu);
>  void kvm_cpu_synchronize_post_reset(CPUState *cpu);
>  void kvm_cpu_synchronize_post_init(CPUState *cpu);
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index a802e899ab..32f286643f 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
>      abort();
>  }
>  
> +bool cpu_is_resettable(void)
> +{
> +    return cpu_check_resettable();
> +}
> +
>  void cpu_synchronize_all_states(void)
>  {
>      CPUState *cpu;
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 4eb9d1f7fd..422fbb1650 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
>  
>  void qemu_system_reset_request(ShutdownCause reason)
>  {
> -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> +    if (!cpu_is_resettable()) {
> +        error_report("cpus are not resettable, terminating");
> +        shutdown_requested = reason;
> +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>          shutdown_requested = reason;
>      } else {
>          reset_requested = reason;
> -- 
> 2.28.0
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

