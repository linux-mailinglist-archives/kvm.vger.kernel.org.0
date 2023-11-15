Return-Path: <kvm+bounces-1817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF957EC0FC
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E5941F26B02
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6618E156D4;
	Wed, 15 Nov 2023 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbnbTpwA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B87314A8B
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:54:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E24BDA
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 02:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700045672;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=PGSD05Xo1v6BMI+OEkPp5u00WWpxqZma8zNybsCwH+s=;
	b=VbnbTpwAL7Fs0mCyIi8/LeNhT6gKujRBe1lseNzLe9cxEJl5vDOnLAyicySAEu5Dm7Q1rL
	5ncw80Zru5w7GjMyPweGubsO3szGFW01VvguNpnb+Iysaf/0ERfJBSgYrSu2FJRLN0HWYi
	9owDKaGHvQ62ynmATlH5PIODnf7jzBc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-jFtbbHkdN0CiafWWUkkcQw-1; Wed,
 15 Nov 2023 05:54:28 -0500
X-MC-Unique: jFtbbHkdN0CiafWWUkkcQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BADA73816DA1;
	Wed, 15 Nov 2023 10:54:27 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FBFC2026D66;
	Wed, 15 Nov 2023 10:54:22 +0000 (UTC)
Date: Wed, 15 Nov 2023 10:54:19 +0000
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
Subject: Re: [PATCH v3 18/70] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <ZVSjWxI6c1qt3X9M@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-19-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-19-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Nov 15, 2023 at 02:14:27AM -0500, Xiaoyao Li wrote:
> KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
> IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
> TDX context. It will be used to validate user's setting later.
> 
> Since there is no interface reporting how many cpuid configs contains in
> KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
> and abort when it exceeds KVM_MAX_CPUID_ENTRIES.
> 
> Besides, introduce the interfaces to invoke TDX "ioctls" at different
> scope (KVM, VM and VCPU) in preparation.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
> - rename __tdx_ioctl() to tdx_ioctl_internal()
> - Pass errp in get_tdx_capabilities();
> 
> changes in v2:
>   - Make the error message more clear;
> 
> changes in v1:
>   - start from nr_cpuid_configs = 6 for the loop;
>   - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
> ---
>  target/i386/kvm/kvm.c      |   2 -
>  target/i386/kvm/kvm_i386.h |   2 +
>  target/i386/kvm/tdx.c      | 102 ++++++++++++++++++++++++++++++++++++-
>  3 files changed, 103 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 7abcdebb1452..28e60c5ea4a7 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1687,8 +1687,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>  
>  static Error *invtsc_mig_blocker;
>  
> -#define KVM_MAX_CPUID_ENTRIES  100
> -
>  static void kvm_init_xsave(CPUX86State *env)
>  {
>      if (has_xsave2) {
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 55fb25fa8e2e..c3ef46a97a7b 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -13,6 +13,8 @@
>  
>  #include "sysemu/kvm.h"
>  
> +#define KVM_MAX_CPUID_ENTRIES  100
> +
>  #ifdef CONFIG_KVM
>  
>  #define kvm_pit_in_kernel() \
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 621a05beeb4e..cb0040187b27 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,17 +12,117 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include "qemu/error-report.h"
>  #include "qapi/error.h"
>  #include "qom/object_interfaces.h"
> +#include "sysemu/kvm.h"
>  
>  #include "hw/i386/x86.h"
> +#include "kvm_i386.h"
>  #include "tdx.h"
>  
> +static struct kvm_tdx_capabilities *tdx_caps;
> +
> +enum tdx_ioctl_level{
> +    TDX_PLATFORM_IOCTL,
> +    TDX_VM_IOCTL,
> +    TDX_VCPU_IOCTL,
> +};
> +
> +static int tdx_ioctl_internal(void *state, enum tdx_ioctl_level level, int cmd_id,
> +                        __u32 flags, void *data)
> +{
> +    struct kvm_tdx_cmd tdx_cmd;

Add   ' = {}'  to initialize to all-zeros, avoiding the explicit
memset call

> +    int r;
> +
> +    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
> +
> +    tdx_cmd.id = cmd_id;
> +    tdx_cmd.flags = flags;
> +    tdx_cmd.data = (__u64)(unsigned long)data;
> +
> +    switch (level) {
> +    case TDX_PLATFORM_IOCTL:
> +        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    case TDX_VM_IOCTL:
> +        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    case TDX_VCPU_IOCTL:
> +        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
> +        break;
> +    default:
> +        error_report("Invalid tdx_ioctl_level %d", level);
> +        exit(1);
> +    }
> +
> +    return r;
> +}
> +
> +static inline int tdx_platform_ioctl(int cmd_id, __u32 flags, void *data)
> +{
> +    return tdx_ioctl_internal(NULL, TDX_PLATFORM_IOCTL, cmd_id, flags, data);
> +}
> +
> +static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
> +{
> +    return tdx_ioctl_internal(NULL, TDX_VM_IOCTL, cmd_id, flags, data);
> +}
> +
> +static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 flags,
> +                                 void *data)
> +{
> +    return  tdx_ioctl_internal(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, flags, data);
> +}
> +
> +static int get_tdx_capabilities(Error **errp)
> +{
> +    struct kvm_tdx_capabilities *caps;
> +    /* 1st generation of TDX reports 6 cpuid configs */
> +    int nr_cpuid_configs = 6;
> +    size_t size;
> +    int r;
> +
> +    do {
> +        size = sizeof(struct kvm_tdx_capabilities) +
> +               nr_cpuid_configs * sizeof(struct kvm_tdx_cpuid_config);
> +        caps = g_malloc0(size);
> +        caps->nr_cpuid_configs = nr_cpuid_configs;
> +
> +        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
> +        if (r == -E2BIG) {
> +            g_free(caps);
> +            nr_cpuid_configs *= 2;
> +            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
> +                error_setg(errp, "%s: KVM TDX seems broken that number of CPUID "
> +                           "entries in kvm_tdx_capabilities exceeds limit %d",
> +                           __func__, KVM_MAX_CPUID_ENTRIES);
> +                return r;
> +            }
> +        } else if (r < 0) {
> +            g_free(caps);
> +            error_setg_errno(errp, -r, "%s: KVM_TDX_CAPABILITIES failed", __func__);
> +            return r;
> +        }
> +    }
> +    while (r == -E2BIG);
> +
> +    tdx_caps = caps;
> +
> +    return 0;
> +}
> +
>  int tdx_kvm_init(MachineState *ms, Error **errp)
>  {
> +    int r = 0;
> +
>      ms->require_guest_memfd = true;
>  
> -    return 0;
> +    if (!tdx_caps) {
> +        r = get_tdx_capabilities(errp);
> +    }
> +
> +    return r;
>  }
>  
>  /* tdx guest */
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


