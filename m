Return-Path: <kvm+bounces-33633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964B39EF012
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F128172B36
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D05A229684;
	Thu, 12 Dec 2024 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKxkH+Mk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF0E229679
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019248; cv=none; b=EPk8tKzYwn88l/lrQ2sMk01/nJaq/7bx9yCh2dHoqAz8OcOv9A9K0LnqkTwJFQuzZfoYB48PQz4MSIzgU/swvS3rdrjR5LA7WRaImphvrAUdCGt84qYz8xR7cYGBJEBuL8+xqk1MedA0zaySZzzYi+sv+xFIhJ416BLtr6Xee4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019248; c=relaxed/simple;
	bh=spXPe6J+hAd1xcstIc+wLBGw0T0Z4b3dnrQPIqfwW34=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfZcJ2xUSrEp0X0zaXmtURZiNX4Als6pbbe2NxA9UyTNHtb6gi/LzlMn/eOL7j2sDrOG0d/RnbCEu5bp7ncLtZDHN7j1qZcFx4K2xgB0UiJqkg4+qoApqE3BBQNaAMzp08wS3f75vse8eB4c0pCpXUOS9xEIDOxYlU+AsxuaVwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKxkH+Mk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734019245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1xUt3njQqKB3GxrQmc7u8qp2nc5B6UvBhDcKxZw3dI=;
	b=QKxkH+Mk27jzP6YrLOgxa72W0xWHnYQOKbas3pEDmFvJgHBX3Hr2p9H+qZzZ4Y6ce5UBfj
	ruzww3/jabEWoCdD8ueIGZHv7mRBDbojjiSJE8yNQxZLWcRyjyEwlRaGhVxbxzI4iCrpRu
	AWExT9AmJoWoz0Q/u4p080Hn+tqR+34=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-SWZT7hJuPKy8NSsJFyKh3Q-1; Thu, 12 Dec 2024 11:00:43 -0500
X-MC-Unique: SWZT7hJuPKy8NSsJFyKh3Q-1
X-Mimecast-MFC-AGG-ID: SWZT7hJuPKy8NSsJFyKh3Q
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436289a570eso2300295e9.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 08:00:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734019242; x=1734624042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1xUt3njQqKB3GxrQmc7u8qp2nc5B6UvBhDcKxZw3dI=;
        b=inItm6VRfdM2xodiIRZ3j338JpcNI6ypUFEr1tIZ59ByhlzCfn/sSRf8QFFvMvjgrB
         fOtcYwr3G7v5wyiKPor/eOe9rwidsrB92mEhy+bS62AGzOlCGEXiJzuoIxXq0HzTcf5e
         LfOkOouEv5Os/XapCwvlvo4ZoB8I8ZE0F48blKEIdFkHPu1g6I8/Cv/x3fAj3nwtiNYt
         d7LJJAIx3mLbFG3rCPDDQYQ7f7bjIgZySnybsnZoL42dmZUcS2676vEcPYlLYDSFUdR3
         G5T1x1BBP9UOJfIQ7C8Rb5PDMoPbejbKtRgEl3eOfG0MOzckrcevqGAeWDTAG5S80AxQ
         T7oA==
X-Forwarded-Encrypted: i=1; AJvYcCWXshLhY7zZCTW7MpoStUU0nBc2Jt5GxGxIgTEargmXsY0pgX+xrYrpI7T4/GCz7GoWoh0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8NC3ROe7A70I9GQSjma+5FwwxBZA8o3LZV4poMVnJbFlJ1dIU
	JhZKurNUnn2ghCbIxsDkDQPU+8TIXAGzzYglleeGtIpPj1BxrPugO8RCQQwP0bcoKBhkBtKWm+o
	PxZlDZKZYS5cq90LT3EXqxSKbBEo1Z8ByWnaZonSB2KS5b6zs6w==
X-Gm-Gg: ASbGnctsaFXYGc/w700qUgRp0oPLcesZCc2CTB6ZDYqSNJUz3eTL2f9/2qlbCFxMBn3
	ZYC/dNqolRrmvi+MbuJUsRc24ezKxPnIDIj4THGU9euCKvyEo5x9I4YBP8Qj0FygGsps4EckZcB
	ZuiaLgxMB9HUL+bvC3fCNpRNR6THjvDsxc7omoJpvq8Ur2D1eV8PcH4kMWSswTVr5PnctGen+KL
	1YRx+BczjV3GMzOUbUfZPQ4wiEwyBxO5qq30bcCkXEDdQOD/LtCyS0UKlbNYuasgbZZjvK+018t
	yT5749UNdlYGds9zPs1snKOOy6oR
X-Received: by 2002:a05:600c:35c9:b0:434:a734:d279 with SMTP id 5b1f17b1804b1-4361c3c6fbfmr77212635e9.16.1734019242397;
        Thu, 12 Dec 2024 08:00:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7u0oYx1r7VH0iNnzyx8lXhphV11Pdrlgtw2BV0y+oru5OMlvI5mJMkYXy9VHum2h0WgePHA==
X-Received: by 2002:a05:600c:35c9:b0:434:a734:d279 with SMTP id 5b1f17b1804b1-4361c3c6fbfmr77207515e9.16.1734019239178;
        Thu, 12 Dec 2024 08:00:39 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4362559ec46sm20705235e9.20.2024.12.12.08.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 08:00:37 -0800 (PST)
Date: Thu, 12 Dec 2024 17:00:34 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org
Subject: Re: [PATCH] target/i386: Reset TSCs of parked vCPUs too on VM reset
Message-ID: <20241212170034.081aa98f@imammedo.users.ipa.redhat.com>
In-Reply-To: <5a605a88e9a231386dc803c60f5fed9b48108139.1734014926.git.maciej.szmigiero@oracle.com>
References: <5a605a88e9a231386dc803c60f5fed9b48108139.1734014926.git.maciej.szmigiero@oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Dec 2024 15:51:15 +0100
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> wrote:

> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Since commit 5286c3662294 ("target/i386: properly reset TSC on reset")
> QEMU writes the special value of "1" to each online vCPU TSC on VM reset
> to reset it.
> 
> However parked vCPUs don't get that handling and due to that their TSCs
> get desynchronized when the VM gets reset.
> This in turn causes KVM to turn off PVCLOCK_TSC_STABLE_BIT in its exported
> PV clock.
> Note that KVM has no understanding of vCPU being currently parked.
> 
> Without PVCLOCK_TSC_STABLE_BIT the sched clock is marked unstable in
> the guest's kvm_sched_clock_init().
> This causes a performance regressions to show in some tests.
> 
> Fix this issue by writing the special value of "1" also to TSCs of parked
> vCPUs on VM reset.

does TSC still ticks when vCPU is parked or it is paused at some value?

> 
> 
> Reproducing the issue:
> 1) Boot a VM with "-smp 2,maxcpus=3" or similar
> 
> 2) device_add host-x86_64-cpu,id=vcpu,node-id=0,socket-id=0,core-id=2,thread-id=0
> 
> 3) Wait a few seconds
> 
> 4) device_del vcpu
> 
> 5) Inside the VM run:
> # echo "t" >/proc/sysrq-trigger; dmesg | grep sched_clock_stable
> Observe the sched_clock_stable() value is 1.
> 
> 6) Reboot the VM
> 
> 7) Once the VM boots once again run inside it:
> # echo "t" >/proc/sysrq-trigger; dmesg | grep sched_clock_stable
> Observe the sched_clock_stable() value is now 0.
> 
> 
> Fixes: 5286c3662294 ("target/i386: properly reset TSC on reset")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  accel/kvm/kvm-all.c                | 11 +++++++++++
>  configs/targets/i386-softmmu.mak   |  1 +
>  configs/targets/x86_64-softmmu.mak |  1 +
>  include/sysemu/kvm.h               |  8 ++++++++
>  target/i386/kvm/kvm.c              | 15 +++++++++++++++
>  5 files changed, 36 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5a2..dec1d1c16a0d 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -437,6 +437,16 @@ int kvm_unpark_vcpu(KVMState *s, unsigned long vcpu_id)
>      return kvm_fd;
>  }
>  
> +static void kvm_reset_parked_vcpus(void *param)
> +{
> +    KVMState *s = param;
> +    struct KVMParkedVcpu *cpu;
> +
> +    QLIST_FOREACH(cpu, &s->kvm_parked_vcpus, node) {
> +        kvm_arch_reset_parked_vcpu(cpu->vcpu_id, cpu->kvm_fd);
> +    }
> +}
> +
>  int kvm_create_vcpu(CPUState *cpu)
>  {
>      unsigned long vcpu_id = kvm_arch_vcpu_id(cpu);
> @@ -2728,6 +2738,7 @@ static int kvm_init(MachineState *ms)
>      }
>  
>      qemu_register_reset(kvm_unpoison_all, NULL);
> +    qemu_register_reset(kvm_reset_parked_vcpus, s);
>  
>      if (s->kernel_irqchip_allowed) {
>          kvm_irqchip_create(s);
> diff --git a/configs/targets/i386-softmmu.mak b/configs/targets/i386-softmmu.mak
> index 2ac69d5ba370..2eb0e8625005 100644
> --- a/configs/targets/i386-softmmu.mak
> +++ b/configs/targets/i386-softmmu.mak
> @@ -1,4 +1,5 @@
>  TARGET_ARCH=i386
>  TARGET_SUPPORTS_MTTCG=y
>  TARGET_KVM_HAVE_GUEST_DEBUG=y
> +TARGET_KVM_HAVE_RESET_PARKED_VCPU=y
>  TARGET_XML_FILES= gdb-xml/i386-32bit.xml
> diff --git a/configs/targets/x86_64-softmmu.mak b/configs/targets/x86_64-softmmu.mak
> index e12ac3dc59bf..920e9a42006f 100644
> --- a/configs/targets/x86_64-softmmu.mak
> +++ b/configs/targets/x86_64-softmmu.mak
> @@ -2,4 +2,5 @@ TARGET_ARCH=x86_64
>  TARGET_BASE_ARCH=i386
>  TARGET_SUPPORTS_MTTCG=y
>  TARGET_KVM_HAVE_GUEST_DEBUG=y
> +TARGET_KVM_HAVE_RESET_PARKED_VCPU=y
>  TARGET_XML_FILES= gdb-xml/i386-64bit.xml
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index c3a60b28909a..ab17c09a551f 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -377,6 +377,14 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
>  int kvm_arch_init_vcpu(CPUState *cpu);
>  int kvm_arch_destroy_vcpu(CPUState *cpu);
>  
> +#ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
> +void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
> +#else
> +static inline void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd)
> +{
> +}
> +#endif
> +
>  bool kvm_vcpu_id_is_valid(int vcpu_id);
>  
>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 8e17942c3ba1..2ff618fbf138 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2415,6 +2415,21 @@ void kvm_arch_after_reset_vcpu(X86CPU *cpu)
>      }
>  }
>  
> +void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd)
> +{
> +    g_autofree struct kvm_msrs *msrs = NULL;
> +
> +    msrs = g_malloc0(sizeof(*msrs) + sizeof(msrs->entries[0]));
> +    msrs->entries[0].index = MSR_IA32_TSC;
> +    msrs->entries[0].data = 1; /* match the value in x86_cpu_reset() */
> +    msrs->nmsrs++;
> +
> +    if (ioctl(kvm_fd, KVM_SET_MSRS, msrs) != 1) {
> +        warn_report("parked vCPU %lu TSC reset failed: %d",
> +                    vcpu_id, errno);
> +    }
> +}
> +
>  void kvm_arch_do_init_vcpu(X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
> 


