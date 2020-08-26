Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7609E2537DE
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 21:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHZTHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 15:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726936AbgHZTHw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Aug 2020 15:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598468871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a07nTm9p+uFL/cBgcEJoDBqsweuoxo7VFuGlsvwVi7g=;
        b=idwZagCVap9bM4chbt0I4Vzdj3zmq7OtDohHYH4OX//qpjXetKDoz6NVk4ed8323RZ1erA
        h8IIAh9jqg+2auBuHgEmQ9S2dLEFa57a/L4rP37Fc/TwP7tsrBYWPkDSpHYQjZO/QV0HZ6
        No4VvQeehqn8zonJoHsEmXR0K09TP04=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-khS1T2f5PfOoex8IciMisw-1; Wed, 26 Aug 2020 15:07:49 -0400
X-MC-Unique: khS1T2f5PfOoex8IciMisw-1
Received: by mail-qk1-f198.google.com with SMTP id e63so2518244qkd.14
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 12:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a07nTm9p+uFL/cBgcEJoDBqsweuoxo7VFuGlsvwVi7g=;
        b=XlGQhmjQs35LG0VPgvQtZSO/5nGVhEiAEY3WkTkB6a2n+/65VLOG/GQZ1Mjfnu6zXK
         D2SCkemRpzDprlxfB/TK2ZXsXQhVKmMb0bMheG7lkiUx+GQVCHt8UJlrYe49VCOoHv+C
         eRlNADdxPUOVflgINoS5APdgOd16C2x26KPYk+YSmsTIsk4bLy/rwrt30ARM8uBVPvAD
         4TDye1MWbeaS5AsPc9uAj6tYg4txEKTGB2rrmJH06Skm5VsKQT38Io7CNnIUCFuoAW38
         NKjZL0fSJD64Rv0oua0E2ko4gbmT5yYK4kkaWiEpegeMlvVoppl4pSol7ctUYC8KFiaA
         u7jg==
X-Gm-Message-State: AOAM533rFwvzCbECaOdUliPrK3fqa8UHuSYQ5n0jYgpQmCla2CnQxx7A
        fr1+i1qAU7kB5WWRgkbZL3Bz7wfNKQsBa8V3gpriAGr9FRT2ZSWlDDttaXVPP7RXXUlEUn2ja9X
        llS8SG+HL4ZOZ
X-Received: by 2002:ac8:73c4:: with SMTP id v4mr7726527qtp.116.1598468868884;
        Wed, 26 Aug 2020 12:07:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfSJRaiXyFaBnrtMqYioa6gOA8mWlW2AiQlgfUQDXoQJXHGjysYw3Myhe4RXoiDi92cVEGdw==
X-Received: by 2002:ac8:73c4:: with SMTP id v4mr7726501qtp.116.1598468868637;
        Wed, 26 Aug 2020 12:07:48 -0700 (PDT)
Received: from [192.168.0.172] (ip68-103-222-6.ks.ok.cox.net. [68.103.222.6])
        by smtp.gmail.com with ESMTPSA id q34sm2885634qtk.32.2020.08.26.12.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 12:07:48 -0700 (PDT)
Subject: Re: [PATCH 3/4] sev/i386: Don't allow a system reset under an SEV-ES
 guest
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
 <b394ef2e743ebd57d3b8fb5ce1d5069c030ffcfc.1598382343.git.thomas.lendacky@amd.com>
From:   Connor Kuehl <ckuehl@redhat.com>
Message-ID: <cfca1081-15e1-c57c-e3b9-d26421cfc21a@redhat.com>
Date:   Wed, 26 Aug 2020 14:07:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b394ef2e743ebd57d3b8fb5ce1d5069c030ffcfc.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/20 2:05 PM, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> An SEV-ES guest does not allow register state to be altered once it has
> been measured. When a SEV-ES guest issues a reboot command, Qemu will
> reset the vCPU state and resume the guest. This will cause failures under
> SEV-ES, so prevent that from occurring.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   accel/kvm/kvm-all.c       | 8 ++++++++
>   include/sysemu/cpus.h     | 2 ++
>   include/sysemu/hw_accel.h | 4 ++++
>   include/sysemu/kvm.h      | 2 ++
>   softmmu/cpus.c            | 5 +++++
>   softmmu/vl.c              | 5 ++++-
>   6 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 54e8fd098d..1d925821b2 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2384,6 +2384,14 @@ void kvm_flush_coalesced_mmio_buffer(void)
>       s->coalesced_flush_in_progress = false;
>   }
>   
> +bool kvm_cpu_check_resettable(void)
> +{
> +    /* If we have a valid reset vector override, then SEV-ES is active
> +     * and the CPU can't be reset.
> +     */
> +    return !kvm_state->reset_valid;
> +}
> +
>   static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
>   {
>       if (!cpu->vcpu_dirty) {
> diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
> index 3c1da6a018..6d688c757f 100644
> --- a/include/sysemu/cpus.h
> +++ b/include/sysemu/cpus.h
> @@ -24,6 +24,8 @@ void dump_drift_info(void);
>   void qemu_cpu_kick_self(void);
>   void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
>   
> +bool cpu_is_resettable(void);
> +
>   void cpu_synchronize_all_states(void);
>   void cpu_synchronize_all_post_reset(void);
>   void cpu_synchronize_all_post_init(void);
> diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
> index e128f8b06b..1fddf4f5e1 100644
> --- a/include/sysemu/hw_accel.h
> +++ b/include/sysemu/hw_accel.h
> @@ -17,6 +17,10 @@
>   #include "sysemu/hvf.h"
>   #include "sysemu/whpx.h"
>   
> +static inline bool cpu_check_resettable(void)
> +{
> +    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
> +}

There's a missing newline here that would separate the closing brace 
from the function below this one.

>   static inline void cpu_synchronize_state(CPUState *cpu)
>   {
>       if (kvm_enabled()) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index f74cfa85ab..eb94bbbff9 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
>   
>   #endif /* NEED_CPU_H */
>   
> +bool kvm_cpu_check_resettable(void);
> +
>   void kvm_cpu_synchronize_state(CPUState *cpu);
>   void kvm_cpu_synchronize_post_reset(CPUState *cpu);
>   void kvm_cpu_synchronize_post_init(CPUState *cpu);
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index a802e899ab..32f286643f 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
>       abort();
>   }
>   
> +bool cpu_is_resettable(void)
> +{
> +    return cpu_check_resettable();
> +}
> +
>   void cpu_synchronize_all_states(void)
>   {
>       CPUState *cpu;
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 4eb9d1f7fd..422fbb1650 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
>   
>   void qemu_system_reset_request(ShutdownCause reason)
>   {
> -    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
> +    if (!cpu_is_resettable()) {
> +        error_report("cpus are not resettable, terminating");
> +        shutdown_requested = reason;
> +    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
>           shutdown_requested = reason;
>       } else {
>           reset_requested = reason;
> 

