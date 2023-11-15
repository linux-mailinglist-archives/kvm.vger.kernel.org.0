Return-Path: <kvm+bounces-1818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D457EC10C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 12:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B95E5B20B23
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C8C156DE;
	Wed, 15 Nov 2023 11:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPZnQQ45"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642A814F76
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 11:01:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8818595
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700046103;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=xVxYyKJ0o6UCCa3NUBRh1/+ZZ0cMxtWvzO5pm3jMcHg=;
	b=ZPZnQQ45orKZl5mc2Uu06HAN4fB0UZ4Z7sgTb7XwLzYT+af7OpHwxK/4K5fnKb8V9g/8mz
	3wP14v9foYDZqcQaXAqMffgi0qOUQnXfSgHywrpGbc1j2BEhsP0kP+uvok+WscQToQ6VL6
	ZcsY9G3r7vkWhpD92sfyVilrdrC1TEw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-U4z8lEueMPKwovCpCVivpA-1; Wed,
 15 Nov 2023 06:01:40 -0500
X-MC-Unique: U4z8lEueMPKwovCpCVivpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4026E28B72EF;
	Wed, 15 Nov 2023 11:01:39 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D39D7AE5;
	Wed, 15 Nov 2023 11:01:24 +0000 (UTC)
Date: Wed, 15 Nov 2023 11:01:19 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 26/70] i386/tdx: Initialize TDX before creating TD
 vcpus
Message-ID: <ZVSk_-m-AAK7dYZ1@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-27-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-27-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Wed, Nov 15, 2023 at 02:14:35AM -0500, Xiaoyao Li wrote:
> Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
> configures global TD configurations, e.g. the canonical CPUID config,
> and must be executed prior to creating vCPUs.
> 
> Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM.
> 
> Note, this doesn't address the fact that QEMU may change the CPUID
> configuration when creating vCPUs, i.e. punts on refactoring QEMU to
> provide a stable CPUID config prior to kvm_arch_init().
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
> Changes in v3:
> - Pass @errp in tdx_pre_create_vcpu() and pass error info to it. (Daniel)
> ---
>  accel/kvm/kvm-all.c        |  9 +++++++-
>  target/i386/kvm/kvm.c      |  9 ++++++++
>  target/i386/kvm/tdx-stub.c |  5 +++++
>  target/i386/kvm/tdx.c      | 45 ++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.h      |  4 ++++
>  5 files changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 6b5f4d62f961..a92fff471b58 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -441,8 +441,15 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>  
>      trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>  
> +    /*
> +     * tdx_pre_create_vcpu() may call cpu_x86_cpuid(). It in turn may call
> +     * kvm_vm_ioctl(). Set cpu->kvm_state in advance to avoid NULL pointer
> +     * dereference.
> +     */
> +    cpu->kvm_state = s;
>      ret = kvm_arch_pre_create_vcpu(cpu, errp);
>      if (ret < 0) {
> +        cpu->kvm_state = NULL;
>          goto err;
>      }
>  
> @@ -450,11 +457,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>      if (ret < 0) {
>          error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
>                           kvm_arch_vcpu_id(cpu));
> +        cpu->kvm_state = NULL;
>          goto err;
>      }
>  
>      cpu->kvm_fd = ret;
> -    cpu->kvm_state = s;
>      cpu->vcpu_dirty = true;
>      cpu->dirty_pages = 0;
>      cpu->throttle_us_per_full = 0;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index dafe4d262977..fc840653ceb6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2268,6 +2268,15 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      return r;
>  }
>  
> +int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
> +{
> +    if (is_tdx_vm()) {
> +        return tdx_pre_create_vcpu(cpu, errp);
> +    }
> +
> +    return 0;
> +}
> +
>  int kvm_arch_destroy_vcpu(CPUState *cs)
>  {
>      X86CPU *cpu = X86_CPU(cs);
> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
> index 1d866d5496bf..3877d432a397 100644
> --- a/target/i386/kvm/tdx-stub.c
> +++ b/target/i386/kvm/tdx-stub.c
> @@ -6,3 +6,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>  {
>      return -EINVAL;
>  }
> +
> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> +{
> +    return -EINVAL;
> +}
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 1f5d8117d1a9..122a37c93de3 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -467,6 +467,49 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>      return 0;
>  }
>  
> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
> +{
> +    MachineState *ms = MACHINE(qdev_get_machine());
> +    X86CPU *x86cpu = X86_CPU(cpu);
> +    CPUX86State *env = &x86cpu->env;
> +    struct kvm_tdx_init_vm *init_vm;

Mark this as auto-free to avoid the g_free() requirement

  g_autofree  struct kvm_tdx_init_vm *init_vm = NULL;

> +    int r = 0;
> +
> +    qemu_mutex_lock(&tdx_guest->lock);

   QEMU_LOCK_GUARD(&tdx_guest->lock);

to eliminate the mutex_unlock requirement, thus eliminating all
'goto' jumps and label targets, in favour of a plain 'return -1'
everywhere.

> +    if (tdx_guest->initialized) {
> +        goto out;
> +    }
> +
> +    init_vm = g_malloc0(sizeof(struct kvm_tdx_init_vm) +
> +                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> +
> +    r = kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPUS, 0, ms->smp.cpus);
> +    if (r < 0) {
> +        error_setg(errp, "Unable to set MAX VCPUS to %d", ms->smp.cpus);
> +        goto out_free;
> +    }
> +
> +    init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
> +
> +    init_vm->attributes = tdx_guest->attributes;
> +
> +    do {
> +        r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
> +    } while (r == -EAGAIN);
> +    if (r < 0) {
> +        error_setg_errno(errp, -r, "KVM_TDX_INIT_VM failed");
> +        goto out_free;
> +    }
> +
> +    tdx_guest->initialized = true;
> +
> +out_free:
> +    g_free(init_vm);
> +out:
> +    qemu_mutex_unlock(&tdx_guest->lock);
> +    return r;
> +}
> +
>  /* tdx guest */
>  OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
>                                     tdx_guest,
> @@ -479,6 +522,8 @@ static void tdx_guest_init(Object *obj)
>  {
>      TdxGuest *tdx = TDX_GUEST(obj);
>  
> +    qemu_mutex_init(&tdx->lock);
> +
>      tdx->attributes = 0;
>  }
>  
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index 06599b65b827..432077723ac5 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -17,6 +17,9 @@ typedef struct TdxGuestClass {
>  typedef struct TdxGuest {
>      ConfidentialGuestSupport parent_obj;
>  
> +    QemuMutex lock;
> +
> +    bool initialized;
>      uint64_t attributes;    /* TD attributes */
>  } TdxGuest;
>  
> @@ -29,5 +32,6 @@ bool is_tdx_vm(void);
>  int tdx_kvm_init(MachineState *ms, Error **errp);
>  void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,

>                               uint32_t *ret);
> +int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
>  
>  #endif /* QEMU_I386_TDX_H */
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


