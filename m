Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45C77825C3
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 10:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbjHUIrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 04:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjHUIrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 04:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB419A6
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 01:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692607595;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=KinkQpWMVM+Uw33LLiNw2lBPP3gHnMZJKG8+W5k8YU8=;
        b=Asa5XlrCKVKJdeCTaSnx6DpQbuvlvjNqVjUMaxnVgeoWGIokI3/aQG8UJyLiFt7D4zjpta
        3i+KuRmHvrehB9rtagNUi8cZuvqSfNc9p5XCE0SBcK7rzbQqG0qAs1/3NPAKmEqf9HbocN
        S5zSuDLJ3bBELbFRGKJEuyfkf+SSAEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-l1npuk_pOWCIVxQBVZ_igw-1; Mon, 21 Aug 2023 04:46:31 -0400
X-MC-Unique: l1npuk_pOWCIVxQBVZ_igw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C27A68030A9;
        Mon, 21 Aug 2023 08:46:30 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FE66492C13;
        Mon, 21 Aug 2023 08:46:27 +0000 (UTC)
Date:   Mon, 21 Aug 2023 09:46:26 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 06/58] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <ZOMkYvm9vsQs8sas@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-7-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:49:49AM -0400, Xiaoyao Li wrote:
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
> changes from v1:
>   - Make the error message more clear;
> 
> changes from RFC v4:
>   - start from nr_cpuid_configs = 6 for the loop;
>   - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
> ---
>  target/i386/kvm/kvm.c      |  2 -
>  target/i386/kvm/kvm_i386.h |  2 +
>  target/i386/kvm/tdx.c      | 93 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 95 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index d6b988d6c2d1..ec5c07bffd38 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1751,8 +1751,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>  
>  static Error *invtsc_mig_blocker;
>  
> -#define KVM_MAX_CPUID_ENTRIES  100
> -
>  static void kvm_init_xsave(CPUX86State *env)
>  {
>      if (has_xsave2) {
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index ea3a5b174ac0..769eadbba56c 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -13,6 +13,8 @@
>  
>  #include "sysemu/kvm.h"
>  
> +#define KVM_MAX_CPUID_ENTRIES  100
> +
>  #define kvm_apic_in_kernel() (kvm_irqchip_in_kernel())
>  
>  #ifdef CONFIG_KVM
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 77e33ae01147..255c47a2a553 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,14 +12,107 @@
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
> +static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
> +                        __u32 flags, void *data)

Names with an initial double underscore are reserved for us by the
platform implementation, so shouldn't be used in userspace app
code.

> +{
> +    struct kvm_tdx_cmd tdx_cmd;
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
> +    return __tdx_ioctl(NULL, TDX_PLATFORM_IOCTL, cmd_id, flags, data);
> +}
> +
> +static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
> +{
> +    return __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, flags, data);
> +}
> +
> +static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 flags,
> +                                 void *data)
> +{
> +    return  __tdx_ioctl(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, flags, data);
> +}
> +
> +static void get_tdx_capabilities(void)

Pass in 'Error **errp'

> +{
> +    struct kvm_tdx_capabilities *caps;
> +    /* 1st generation of TDX reports 6 cpuid configs */
> +    int nr_cpuid_configs = 6;
> +    int r, size;

It is preferrable to use  'size_t' for memory allocation sizes.

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
> +                error_report("KVM TDX seems broken that number of CPUID entries in kvm_tdx_capabilities exceeds limit");

Include the limit in the error message, so if we ever need to change
the limit, it'll be clear what limit the QEMU version was built with.

Also use error_setg(errp, ...);

> +                exit(1);

Return -1

> +            }
> +        } else if (r < 0) {
> +            g_free(caps);
> +            error_report("KVM_TDX_CAPABILITIES failed: %s", strerror(-r));

Use error_setg_errno(errp, ...) instead of calling strerror yourself;

> +            exit(1);

Return -1

> +        }
> +    }
> +    while (r == -E2BIG);
> +
> +    tdx_caps = caps;

Return 0

> +}
> +
>  int tdx_kvm_init(MachineState *ms, Error **errp)
>  {
> +    if (!tdx_caps) {
> +        get_tdx_capabilities();

Pass 'errp' into this method, and check return value for failure

> +    }
> +
>      return 0;
>  }
>  
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

