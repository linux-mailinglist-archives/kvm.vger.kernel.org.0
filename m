Return-Path: <kvm+bounces-10176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C85386A4AF
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:00:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD16D1F24E2E
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2A61865;
	Wed, 28 Feb 2024 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9UoROFq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30517A5F;
	Wed, 28 Feb 2024 01:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709082030; cv=none; b=EBKclWoEOmJWTF4AhcpTWTOfMHILI+v2OqhNvQe3Rx2RPfzKfMgsk81K1FOe9rqTZ3J1IJ4zUVuvOwfd22axYqlkDejnkXViFaPkEvp1d43iwYMWcYnGCJyLIJrtPjT6xB5dHShfBAxywZm/c6MhDVVRQUWoprDTLX8Lsmd9Ba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709082030; c=relaxed/simple;
	bh=tf9auf2TD76ybW8Mf+uvuiTqEGQji+pG8emtv+umHAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hj39ySQ0JJwFdaRcAS2dC8xif7sHQl/z3A5QkeaHZu8O4yCtlmLsW0Ge6rVn59bGumuBVcr+wC2v1nzq/0Pm2HxQnzqIhPb975U+uExwLdSIs4VZVilRO09PLfe+ZRbBfoBKOvDSboExpQXApTumxjmlpJEE4wukC6nZyHqVeTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9UoROFq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709082027; x=1740618027;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tf9auf2TD76ybW8Mf+uvuiTqEGQji+pG8emtv+umHAk=;
  b=E9UoROFqQ0OjfrDNVLDDURF1LJK3hLM83MnaMQy/7xSbWgVY6PVxa3MB
   jTHrxGNS1H5kT6V8dfjtralymaCQXbgGimX8jbIoku3n+aCJv4jMJ3NzI
   wN03qCNhJy1ayWrbUzgp41pBH7r3HWHvPBi0XtA6BnnpnuiznOq36C7Nn
   wR5q5HwpfqfTriGMVWDpSVWvA5O17FVNRw0ugrvHYHJBXfHtxljq3gX0Y
   EQigdsWC1iYsODU9MtGrVOWV/JMt7ycZZ66pe/u7zkjRZeWpFeqSpcxcE
   L2UWjPiC54w7wz+p4jVHjk8Uw3G1jkl+HCM1uXtQxw5hpWFIKjAzWjttc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3321341"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="3321341"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 17:00:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="11799684"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 17:00:22 -0800
Date: Tue, 27 Feb 2024 17:00:21 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, aik@amd.com, isaku.yamahata@linux.intel.com,
	isaku.yamahata@intel.com
Subject: Re: [PATCH v3 13/15] KVM: SEV: define VM types for SEV and SEV-ES
Message-ID: <20240228010021.GA10568@ls.amr.corp.intel.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-14-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-14-pbonzini@redhat.com>

On Mon, Feb 26, 2024 at 02:03:42PM -0500,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  |  2 ++
>  arch/x86/include/uapi/asm/kvm.h |  2 ++
>  arch/x86/kvm/svm/sev.c          | 16 +++++++++++++---
>  arch/x86/kvm/svm/svm.c          |  7 +++++++
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              |  2 ++
>  6 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0b5a33ee71ee..f0b76ff5030d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8819,6 +8819,8 @@ means the VM type with value @n is supported.  Possible values of @n are::
>  
>    #define KVM_X86_DEFAULT_VM	0
>    #define KVM_X86_SW_PROTECTED_VM	1
> +  #define KVM_X86_SEV_VM	2
> +  #define KVM_X86_SEV_ES_VM	3
>  
>  Note, KVM_X86_SW_PROTECTED_VM is currently only for development and testing.
>  Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index d0c1b459f7e9..9d950b0b64c9 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -857,5 +857,7 @@ struct kvm_hyperv_eventfd {
>  
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_SW_PROTECTED_VM	1
> +#define KVM_X86_SEV_VM		2
> +#define KVM_X86_SEV_ES_VM	3
>  
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2549a539a686..1248ccf433e8 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -247,6 +247,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (kvm->created_vcpus)
>  		return -EINVAL;
>  
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
> +		return -EINVAL;
> +
>  	if (unlikely(sev->active))
>  		return -EINVAL;
>  
> @@ -264,6 +267,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	INIT_LIST_HEAD(&sev->regions_list);
>  	INIT_LIST_HEAD(&sev->mirror_vms);
> +	sev->need_init = false;
>  
>  	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
>  
> @@ -1799,7 +1803,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	if (ret)
>  		goto out_fput;
>  
> -	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
> +	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
> +	    sev_guest(kvm) || !sev_guest(source_kvm)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -2118,6 +2123,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	mirror_sev->asid = source_sev->asid;
>  	mirror_sev->fd = source_sev->fd;
>  	mirror_sev->es_active = source_sev->es_active;
> +	mirror_sev->need_init = false;
>  	mirror_sev->handle = source_sev->handle;
>  	INIT_LIST_HEAD(&mirror_sev->regions_list);
>  	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
> @@ -2183,10 +2189,14 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  void __init sev_set_cpu_caps(void)
>  {
> -	if (sev_enabled)
> +	if (sev_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV);
> -	if (sev_es_enabled)
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
> +	}
> +	if (sev_es_enabled) {
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> +	}
>  }
>  
>  void __init sev_hardware_setup(void)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1cf9e5f1fd02..f4a750426b24 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4089,6 +4089,9 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
>  {
> +	if (to_kvm_sev_info(vcpu->kvm)->need_init)
> +		return -EINVAL;
> +
>  	return 1;
>  }
>  
> @@ -4890,6 +4893,10 @@ static void svm_vm_destroy(struct kvm *kvm)
>  
>  static int svm_vm_init(struct kvm *kvm)
>  {
> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM &&
> +	    kvm->arch.vm_type != KVM_X86_SW_PROTECTED_VM)
> +		to_kvm_sev_info(kvm)->need_init = true;
> +
>  	if (!pause_filter_count || !pause_filter_thresh)
>  		kvm->arch.pause_in_guest = true;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ebf2160bf0c6..7a921acc534f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,7 @@ enum {
>  struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
> +	bool need_init;		/* waiting for SEV_INIT2 */
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b87e65904ae..b9dfe3179332 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12576,6 +12576,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm->arch.vm_type = type;
>  	kvm->arch.has_private_mem =
>  		(type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.has_protected_state =
> +		(type == KVM_X86_SEV_ES_VM);

Can we push it down into init_vm() op? I hesitate to add TDX check here.
kvm_page_track_init() and kvm_mmu_init_vm() wouldn't depend on it.


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f4a750426b24..a083873b9057 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4893,6 +4893,9 @@ static void svm_vm_destroy(struct kvm *kvm)
 
 static int svm_vm_init(struct kvm *kvm)
 {
+       if (kvm->arch.vm_type == KVM_X86_SEV_ES_VM)
+               kvm->arch.has_protected_state = true;
+
        if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM &&
            kvm->arch.vm_type != KVM_X86_SW_PROTECTED_VM)
                to_kvm_sev_info(kvm)->need_init = true;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b9dfe3179332..3b87e65904ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12576,8 +12576,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        kvm->arch.vm_type = type;
        kvm->arch.has_private_mem =
                (type == KVM_X86_SW_PROTECTED_VM);
-       kvm->arch.has_protected_state =
-               (type == KVM_X86_SEV_ES_VM);
 
        ret = kvm_page_track_init(kvm);
        if (ret)

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

