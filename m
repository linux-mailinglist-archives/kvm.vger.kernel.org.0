Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB217B992
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 10:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgCFJub (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 04:50:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbgCFJub (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Mar 2020 04:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583488229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=poxxj/9iq8zb5a6l+ZyJL3MXP6LwvYLpsOz/kaW2Dcc=;
        b=dAmCWEAQFvSyPKLx+gfAdOlrwRNdxINaH0FJ5de8EhebOxhI3KkBUyAstUWifAYek5uIOu
        NDYL3FRjvW5WI0q5PqylEnBd2S6T673cKF6rTyOn991phOhgKsNaCycvsAC3dZsnYZg6er
        5iCBDmVx0w1p1NRSDJk6fVvwVC4HiyA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-0GCwGZrJNO-FUJHbM7Vlvw-1; Fri, 06 Mar 2020 04:50:25 -0500
X-MC-Unique: 0GCwGZrJNO-FUJHbM7Vlvw-1
Received: by mail-wr1-f69.google.com with SMTP id c6so761930wrm.18
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 01:50:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=poxxj/9iq8zb5a6l+ZyJL3MXP6LwvYLpsOz/kaW2Dcc=;
        b=ieStGfMBYwD/t0LPL8vI2tJcq2T5FO0edBu8e24mHkNHc0/Vj2HSC2xOENXnyzG1WD
         W2Yr3Ip+KTQBKF6/RUpnxYENv+irZspaqHT+en5UIr+gvyKhrxH4Z5U7f1+rQ1sAs28R
         5ne2HB6K/2Pe0KWl5crCwBQ6wkEujt9lDFidpvyPLAq7JnqQJmChimFrJihm7ZOfwzz+
         eAwP1QcAonFHJH564Pg77Yt/Ii0PXLl5ibmGtF0hDHcLo1JZ3EoS1w8guxYOuFaOU3cR
         19qzvRqpKv8gRxiSQ8ykrnPzPl3SkJQufrD/ZI8EcFd7sCPf8ch/Q6xq2GOGOxJaeNZW
         xCzA==
X-Gm-Message-State: ANhLgQ0ePO2r6dsJm6JT43VoYhlvhc8S0pYzmZE9l+VAGId1YdhGWMZa
        rbg6ZfNcUQXWITybI9iTyHDtZwlOfAhwun5TtuKHEzfMW20u4t/x5+71ITpxuIff40svPSqjaf+
        8UKZyTMlkXZV0
X-Received: by 2002:a05:600c:2213:: with SMTP id z19mr2973674wml.141.1583488224230;
        Fri, 06 Mar 2020 01:50:24 -0800 (PST)
X-Google-Smtp-Source: ADFU+vttv3nU7GxeVgxNL51JzTycZC8Olc7hDv3bpsCOSTqZ/RdPfnDhviHBSaZ92j0j84HV09Sy9g==
X-Received: by 2002:a05:600c:2213:: with SMTP id z19mr2973655wml.141.1583488223952;
        Fri, 06 Mar 2020 01:50:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b99a:4374:773d:f32e? ([2001:b07:6468:f312:b99a:4374:773d:f32e])
        by smtp.gmail.com with ESMTPSA id z2sm43698168wrq.95.2020.03.06.01.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 01:50:23 -0800 (PST)
Subject: Re: [PATCH RFC 4/4] kvm: Implement atomic memory region resizes via
 region_resize()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org
References: <20200303141939.352319-1-david@redhat.com>
 <20200303141939.352319-5-david@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <102af47e-7ec0-7cf9-8ddd-0b67791b5126@redhat.com>
Date:   Fri, 6 Mar 2020 10:50:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303141939.352319-5-david@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 15:19, David Hildenbrand wrote:
> virtio-mem wants to resize (esp. grow) ram memory regions while the guest
> is already aware of them and makes use of them. Resizing a KVM slot can
> only currently be done by removing it and re-adding it. While the kvm slot
> is temporarily removed, VCPUs that try to read from these slots will fault.

Only fetches I think?  Data reads and write would be treated as MMIO
accesses and they should just work (using either the old or new FlatView).

> But also, other ioctls might depend on all slots being in place.
> 
> Let's inhibit most KVM ioctls while performing the resize. Once we have an
> ioctl that can perform atomic resizes (e.g., KVM_SET_USER_MEMORY_REGION
> extensions), we can make inhibiting optional at runtime.
> 
> Also, make sure to hold the kvm_slots_lock while performing both
> actions (removing+re-adding).
>
> Note: Resizes of memory regions currently seems to happen during bootup
> only, so I don't think any existing RT users should be affected.

rwlocks are not efficient, they cause cache line contention.  For
MMIO-heavy workloads the impact will be very large (well, not that large
because right now they all take the BQL, but one can always hope).

I would very much prefer to add a KVM_SET_USER_MEMORY_REGION extension
right away.

Paolo

> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  accel/kvm/kvm-all.c   | 121 +++++++++++++++++++++++++++++++++++++++---
>  include/hw/core/cpu.h |   3 ++
>  2 files changed, 117 insertions(+), 7 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 439a4efe52..bba58db098 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -149,6 +149,21 @@ bool kvm_msi_use_devid;
>  static bool kvm_immediate_exit;
>  static hwaddr kvm_max_slot_size = ~0;
>  
> +/*
> + * While holding this lock in write, no new KVM ioctls can be started, but
> + * kvm ioctl inhibitors will have to wait for existing ones to finish
> + * (indicated by cpu->in_ioctl and kvm_in_ioctl, both updated with this lock
> + * held in read when entering the ioctl).
> + */
> +pthread_rwlock_t kvm_ioctl_lock;
> +/*
> + * Atomic counter of active KVM ioctls except
> + * - The KVM ioctl inhibitor is doing an ioctl
> + * - kvm_ioctl(): Harmless and not interesting for inhibitors.
> + * - kvm_vcpu_ioctl(): Tracked via cpu->in_ioctl.
> + */
> +static int kvm_in_ioctl;
> +
>  static const KVMCapabilityInfo kvm_required_capabilites[] = {
>      KVM_CAP_INFO(USER_MEMORY),
>      KVM_CAP_INFO(DESTROY_MEMORY_REGION_WORKS),
> @@ -1023,6 +1038,7 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
>      kvm_max_slot_size = max_slot_size;
>  }
>  
> +/* Called with KVMMemoryListener.slots_lock held */
>  static void kvm_set_phys_mem(KVMMemoryListener *kml,
>                               MemoryRegionSection *section, bool add)
>  {
> @@ -1052,14 +1068,12 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>      ram = memory_region_get_ram_ptr(mr) + section->offset_within_region +
>            (start_addr - section->offset_within_address_space);
>  
> -    kvm_slots_lock(kml);
> -
>      if (!add) {
>          do {
>              slot_size = MIN(kvm_max_slot_size, size);
>              mem = kvm_lookup_matching_slot(kml, start_addr, slot_size);
>              if (!mem) {
> -                goto out;
> +                return;
>              }
>              if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>                  kvm_physical_sync_dirty_bitmap(kml, section);
> @@ -1079,7 +1093,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>              start_addr += slot_size;
>              size -= slot_size;
>          } while (size);
> -        goto out;
> +        return;
>      }
>  
>      /* register the new slot */
> @@ -1108,9 +1122,6 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
>          ram += slot_size;
>          size -= slot_size;
>      } while (size);
> -
> -out:
> -    kvm_slots_unlock(kml);
>  }
>  
>  static void kvm_region_add(MemoryListener *listener,
> @@ -1119,7 +1130,9 @@ static void kvm_region_add(MemoryListener *listener,
>      KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
>  
>      memory_region_ref(section->mr);
> +    kvm_slots_lock(kml);
>      kvm_set_phys_mem(kml, section, true);
> +    kvm_slots_unlock(kml);
>  }
>  
>  static void kvm_region_del(MemoryListener *listener,
> @@ -1127,10 +1140,68 @@ static void kvm_region_del(MemoryListener *listener,
>  {
>      KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
>  
> +    kvm_slots_lock(kml);
>      kvm_set_phys_mem(kml, section, false);
> +    kvm_slots_unlock(kml);
>      memory_region_unref(section->mr);
>  }
>  
> +/*
> + * Certain updates (e.g., resizing memory regions) require temporarily removing
> + * kvm memory slots. Make sure any ioctl sees a consistent memory slot state.
> + */
> +static void kvm_ioctl_inhibit_begin(void)
> +{
> +    CPUState *cpu;
> +
> +    /*
> +     * We allow to inhibit only when holding the BQL, so we can identify
> +     * when an inhibitor wants to issue an ioctl easily.
> +     */
> +    g_assert(qemu_mutex_iothread_locked());
> +
> +    pthread_rwlock_wrlock(&kvm_ioctl_lock);
> +
> +    /* Inhibiting happens rarely, we can keep things simple and spin here. */
> +    while (true) {
> +        bool any_cpu_in_ioctl = false;
> +
> +        CPU_FOREACH(cpu) {
> +            if (atomic_read(&cpu->in_ioctl)) {
> +                any_cpu_in_ioctl = true;
> +                qemu_cpu_kick(cpu);
> +            }
> +        }
> +        if (!any_cpu_in_ioctl && !atomic_read(&kvm_in_ioctl)) {
> +            break;
> +        }
> +        g_usleep(100);
> +    }
> +}
> +
> +static void kvm_ioctl_inhibit_end(void)
> +{
> +    pthread_rwlock_unlock(&kvm_ioctl_lock);
> +}
> +
> +static void kvm_region_resize(MemoryListener *listener,
> +                              MemoryRegionSection *section, Int128 new)
> +{
> +    KVMMemoryListener *kml = container_of(listener, KVMMemoryListener,
> +                                          listener);
> +    MemoryRegionSection new_section = *section;
> +
> +    new_section.size = new;
> +
> +    kvm_slots_lock(kml);
> +    /* Inhibit KVM ioctls while temporarily removing slots. */
> +    kvm_ioctl_inhibit_begin();
> +    kvm_set_phys_mem(kml, section, false);
> +    kvm_set_phys_mem(kml, &new_section, true);
> +    kvm_ioctl_inhibit_end();
> +    kvm_slots_unlock(kml);
> +}
> +
>  static void kvm_log_sync(MemoryListener *listener,
>                           MemoryRegionSection *section)
>  {
> @@ -1249,6 +1320,7 @@ void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>  
>      kml->listener.region_add = kvm_region_add;
>      kml->listener.region_del = kvm_region_del;
> +    kml->listener.region_resize = kvm_region_resize;
>      kml->listener.log_start = kvm_log_start;
>      kml->listener.log_stop = kvm_log_stop;
>      kml->listener.log_sync = kvm_log_sync;
> @@ -1894,6 +1966,7 @@ static int kvm_init(MachineState *ms)
>      assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size);
>  
>      s->sigmask_len = 8;
> +    pthread_rwlock_init(&kvm_ioctl_lock, NULL);
>  
>  #ifdef KVM_CAP_SET_GUEST_DEBUG
>      QTAILQ_INIT(&s->kvm_sw_breakpoints);
> @@ -2304,6 +2377,34 @@ static void kvm_eat_signals(CPUState *cpu)
>      } while (sigismember(&chkset, SIG_IPI));
>  }
>  
> +static void kvm_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl)
> +{
> +    if (unlikely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +    if (in_ioctl) {
> +        pthread_rwlock_rdlock(&kvm_ioctl_lock);
> +        atomic_set(&cpu->in_ioctl, true);
> +        pthread_rwlock_unlock(&kvm_ioctl_lock);
> +    } else {
> +        atomic_set(&cpu->in_ioctl, false);
> +    }
> +}
> +
> +static void kvm_set_in_ioctl(bool in_ioctl)
> +{
> +    if (likely(qemu_mutex_iothread_locked())) {
> +        return;
> +    }
> +    if (in_ioctl) {
> +        pthread_rwlock_rdlock(&kvm_ioctl_lock);
> +        atomic_inc(&kvm_in_ioctl);
> +        pthread_rwlock_unlock(&kvm_ioctl_lock);
> +    } else {
> +        atomic_dec(&kvm_in_ioctl);
> +    }
> +}
> +
>  int kvm_cpu_exec(CPUState *cpu)
>  {
>      struct kvm_run *run = cpu->kvm_run;
> @@ -2488,7 +2589,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
>      va_end(ap);
>  
>      trace_kvm_vm_ioctl(type, arg);
> +    kvm_set_in_ioctl(true);
>      ret = ioctl(s->vmfd, type, arg);
> +    kvm_set_in_ioctl(false);
>      if (ret == -1) {
>          ret = -errno;
>      }
> @@ -2506,7 +2609,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
>      va_end(ap);
>  
>      trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
> +    kvm_cpu_set_in_ioctl(cpu, true);
>      ret = ioctl(cpu->kvm_fd, type, arg);
> +    kvm_cpu_set_in_ioctl(cpu, false);
>      if (ret == -1) {
>          ret = -errno;
>      }
> @@ -2524,7 +2629,9 @@ int kvm_device_ioctl(int fd, int type, ...)
>      va_end(ap);
>  
>      trace_kvm_device_ioctl(fd, type, arg);
> +    kvm_set_in_ioctl(true);
>      ret = ioctl(fd, type, arg);
> +    kvm_set_in_ioctl(false);
>      if (ret == -1) {
>          ret = -errno;
>      }
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index 73e9a869a4..4fbff6f3d7 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -431,6 +431,9 @@ struct CPUState {
>      /* shared by kvm, hax and hvf */
>      bool vcpu_dirty;
>  
> +    /* kvm only for now: CPU is in kvm_vcpu_ioctl() (esp. KVM_RUN) */
> +    bool in_ioctl;
> +
>      /* Used to keep track of an outstanding cpu throttle thread for migration
>       * autoconverge
>       */
> 

