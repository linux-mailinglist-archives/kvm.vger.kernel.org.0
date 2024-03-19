Return-Path: <kvm+bounces-12068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D47DA87F586
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18658282464
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 02:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E85A7BAE5;
	Tue, 19 Mar 2024 02:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGeX5pyS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F7E7B3E5
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710816194; cv=none; b=CEFGHStkYMUusRsr8QuX1DqKvH4n3aGrO/ZHSQEN8p5nraaZV6B1/WPvi0s6yu9Pt9Aj8VmqQe6+jp81nW1uQn3Jc/PWrBhiqYyFtfWKA8ScLmCcB0/mC7u+BR66W/JTemz+oYnh1yQngCx1lcMU5+GwjrTy+gKO8KYNoydlM4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710816194; c=relaxed/simple;
	bh=dPt5ePCniW2OMVq33doq0NPp4q/91R/ZMn9EupR0AO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLA5MO0YzadiRyT8ba6gSc9fJGFwEa//S6oRlvOShe+EwR8QhnFJdWTjWzq8i+BkALGBIgOzxVEYJtgz4GkxjRMuR5TKLAmllY/NN73LP9SpDXkjINxVrtujSoIjedY/TyQ5vLNejzMI9mTFXt5YBK7EA/laDCiUzhQ5ebiBCFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AGeX5pyS; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710816193; x=1742352193;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dPt5ePCniW2OMVq33doq0NPp4q/91R/ZMn9EupR0AO0=;
  b=AGeX5pySXfP5wn8PHZ5GQfemNr6kHoLIqSac1RqaARmUMw0fHG+Oy6Ve
   7JO8nltZo52ZH0Q7CPSCzy/7NNJ0St5UCi3PouswSYBX/TzXa2MSbXXsp
   Nobqo0eO2JmQWN34soh/wTfWahhXrWOW5M227DGKJSGM9ugfJPMwMpD2u
   Ysi2qFr5eOqi5d46JuI0BX6emC1pYbwOx1wY0kf23IcrWmHsUyNLBLsnF
   MSaA6mvuJdksch/jVUoZZmtoLLEBH1reNSwmJFbWNGBZ9SwuWFqenCPHv
   ktQjXZghJhdnaEvgNAm2D1s+SOY8ib4DxbLJ5s9TYC1Ew23HSoXZ4OAAn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5786961"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5786961"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:43:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="13751779"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.124.244.145]) ([10.124.244.145])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:43:06 -0700
Message-ID: <956432d9-68df-4591-a880-48e671435351@intel.com>
Date: Tue, 19 Mar 2024 10:43:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/65] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-16-xiaoyao.li@intel.com>
From: "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20240229063726.610065-16-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/29/2024 14:36, Xiaoyao Li wrote:> KVM provides TDX capabilities via sub
command KVM_TDX_CAPABILITIES of
> IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
> TDX context. It will be used to validate user's setting later.
> 
> Since there is no interface reporting how many cpuid configs contains in
> KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
> and abort when it exceeds KVM_MAX_CPUID_ENTRIES.
> 
> Besides, introduce the interfaces to invoke TDX "ioctls" at different
> scope (KVM, VM and VCPU) in preparation.

tdx_platform_ioctl() is dropped because no user so suggest rephrasing this
statement because no KVM scope ioctl interface is introduced in this patch.

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
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
>  target/i386/kvm/tdx.c      | 91 +++++++++++++++++++++++++++++++++++++-
>  3 files changed, 92 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 52d99d30bdc8..0e68e80f4291 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1685,8 +1685,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
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
> index d9a1dd46dc69..2b956450a083 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,18 +12,107 @@
>   */
>  
>  #include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "qapi/error.h"
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
> +    TDX_VM_IOCTL,
> +    TDX_VCPU_IOCTL,
> +};
> +
> +static int tdx_ioctl_internal(void *state, enum tdx_ioctl_level level, int cmd_id,
> +                        __u32 flags, void *data)
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
> +    return r;
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
>  static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>  {
>      MachineState *ms = MACHINE(qdev_get_machine());
> +    int r = 0;
>  
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

