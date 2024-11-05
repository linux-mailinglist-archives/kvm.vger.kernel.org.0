Return-Path: <kvm+bounces-30714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B3149BCA75
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCB8E283C21
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515A91D279C;
	Tue,  5 Nov 2024 10:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOv5eysx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F761632DD
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730802637; cv=none; b=ZEylVvwafKhLiHXP9GmvAV45/TWaXlN966peB+UM2+ul0be2twAQps9Rj7jJP4XF0xk7756/TdGrYbS5P+W0PGTFCDSKZ4DzrSCIn+wvoiutLbYYJmkLxVWQ9egXZOD43OgcjJf0wVk+nDyKF4MjtM2xNA1BqBgYYjs/G9Q7GHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730802637; c=relaxed/simple;
	bh=fbCJ6PKIKDWJ7sBdWm+gvhrQOF+WfdHA5KL/GQ/Ou1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmiBkbRba/eSxUAJlYDyjTawuY1A2PTcsMhsP+xkxFRz/dX4qS+cUnOrkSA1VJ967LKr60iAdlzPg98o/XD8ycriPC1eYMMb2SgBPH9B6MqiP1Lo3SQbjtAfCfVkfKRgGynz0fl0mFn7fdROER0ZraAwl2t9TpGrS8xKz3FrEhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOv5eysx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730802634;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=omLt+paAOaPZrPQNaMMM2fwM/w25+sBkNVQx6IwIEuA=;
	b=gOv5eysxDXWr+1WQgtKVBpCB2DG33se9kINpkgynOWZUbN4jY+6gbCNpNgVXP4S8Jq4Eiw
	MHig70KASMmnwLXiAmi9kNRaGgx0F7jnpQzF+jOcpHggW8vOlOlOYdXKjZbnudle9h5J3b
	sAauXoPo86AhQcbGbJf8+WvLXYK329c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-d7orJl4AO5ue1Z39z7GPpw-1; Tue,
 05 Nov 2024 05:30:30 -0500
X-MC-Unique: d7orJl4AO5ue1Z39z7GPpw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F8921955F41;
	Tue,  5 Nov 2024 10:30:28 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.52])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B85C230001A3;
	Tue,  5 Nov 2024 10:30:20 +0000 (UTC)
Date: Tue, 5 Nov 2024 10:30:17 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 05/60] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Message-ID: <ZynzuSIWG7jRNBfE@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-6-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-6-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Nov 05, 2024 at 01:23:13AM -0500, Xiaoyao Li wrote:
> KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
> IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
> TDX context. It will be used to validate user's setting later.
> 
> Since there is no interface reporting how many cpuid configs contains in
> KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
> and abort when it exceeds KVM_MAX_CPUID_ENTRIES.
> 
> Besides, introduce the interfaces to invoke TDX "ioctls" at VCPU scope
> in preparation.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v6:
> - Pass CPUState * to tdx_vcpu_ioctl();
> - update commit message to remove platform scope thing;
> - dump hw_error when it's non-zero to help debug;
> 
> Changes in v4:
> - use {} to initialize struct kvm_tdx_cmd, to avoid memset();
> - remove tdx_platform_ioctl() because no user;
> 
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
>  target/i386/kvm/kvm.c      |  2 -
>  target/i386/kvm/kvm_i386.h |  2 +
>  target/i386/kvm/tdx.c      | 93 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 94 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 2bbac603da70..b843de7f2379 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1782,8 +1782,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
>  
>  static Error *invtsc_mig_blocker;
>  
> -#define KVM_MAX_CPUID_ENTRIES  100
> -
>  static void kvm_init_xsave(CPUX86State *env)
>  {
>      if (has_xsave2) {
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 9de9c0d30388..7ac4c3a91171 100644
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
> index 85f006c1d6b4..907044910fec 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,17 +12,108 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "qapi/error.h"
>  #include "qom/object_interfaces.h"
>  
>  #include "hw/i386/x86.h"
>  #include "kvm_i386.h"
>  #include "tdx.h"
>  
> +static struct kvm_tdx_capabilities *tdx_caps;
> +
> +enum tdx_ioctl_level {
> +    TDX_VM_IOCTL,
> +    TDX_VCPU_IOCTL,
> +};
> +
> +static int tdx_ioctl_internal(enum tdx_ioctl_level level, void *state,
> +                              int cmd_id, __u32 flags, void *data)
> +{
> +    struct kvm_tdx_cmd tdx_cmd = {};
> +    int r;
> +
> +    tdx_cmd.id = cmd_id;
> +    tdx_cmd.flags = flags;
> +    tdx_cmd.data = (__u64)(unsigned long)data;
> +
> +    switch (level) {
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
> +    if (r && tdx_cmd.hw_error) {
> +        error_report("TDX ioctl %d return with %d, hw_errors: 0x%llx",
> +                     cmd_id, r, tdx_cmd.hw_error);
> +    }
> +    return r;
> +}

I feel like the error handling of this method is rather inconsistent.
In one place we error_report() and then exit(), in another place
we error_report() but return, and in another place we report nothing
at all. When we return, the caller propagates an Error **errp object,
but this propagated message lacks the potentially useful 'hw_errors'
info.

IMHO this method ought to have an 'Error **errp' parameter and always
fill it & propagate. Let the caller decide whether to exit or not.

If you continue returning 'r', then the caller can still handle
E2BIG, discarding the 'Error' object in that case.


> +
> +static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
> +{
> +    return tdx_ioctl_internal(TDX_VM_IOCTL, NULL, cmd_id, flags, data);
> +}
> +
> +static inline int tdx_vcpu_ioctl(CPUState *cpu, int cmd_id, __u32 flags,
> +                                 void *data)
> +{
> +    return  tdx_ioctl_internal(TDX_VCPU_IOCTL, cpu, cmd_id, flags, data);
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
> +                      nr_cpuid_configs * sizeof(struct kvm_cpuid_entry2);
> +        caps = g_malloc0(size);
> +        caps->cpuid.nent = nr_cpuid_configs;
> +
> +        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
> +        if (r == -E2BIG) {
> +            g_free(caps);
> +            nr_cpuid_configs *= 2;
> +            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
> +                error_setg(errp, "%s: KVM TDX seems broken that number of CPUID"
> +                           " entries in kvm_tdx_capabilities exceeds limit %d",
> +                           __func__, KVM_MAX_CPUID_ENTRIES);
> +                return r;
> +            }
> +        } else if (r < 0) {
> +            g_free(caps);
> +            error_setg_errno(errp, -r, "%s: KVM_TDX_CAPABILITIES failed", __func__);
> +            return r;
> +        }
> +    } while (r == -E2BIG);
> +
> +    tdx_caps = caps;
> +
> +    return 0;
> +}
> +
>  static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  {
> +    int r = 0;
> +
>      kvm_mark_guest_state_protected();
>  
> -    return 0;
> +    if (!tdx_caps) {
> +        r = get_tdx_capabilities(errp);
> +    }
> +
> +    return r;
>  }
>  
>  static int tdx_kvm_type(X86ConfidentialGuest *cg)
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


