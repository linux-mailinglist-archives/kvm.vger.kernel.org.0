Return-Path: <kvm+bounces-12039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 903AD87F36B
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44F82281CB6
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 380825B5A9;
	Mon, 18 Mar 2024 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O0Zx+WHD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930DF5B1FE;
	Mon, 18 Mar 2024 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802509; cv=none; b=C6rIUYhT6bd2aKzBTmDvGogRRy6OdMmF0sr6eye1llhVnzZzUFNgx5epYmztZ8lrHJ6bIhlHYtqdMsc9a6FVFfrFgMJn1IjJx2YMk5DYPQmoZinYHZWJz0krD3Tis4kJdPGs53+w/lSPCGYOW4+JRDUPfnWkmlWA9NdQodaqUvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802509; c=relaxed/simple;
	bh=YqUMy/R8ohYUsamG6py8FYzGr4xFpzoCnGvTBFrC4Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRWbHQh667JQ4RhcSUj6z6mEPAu+MJ/s8GidJgc/wtbz3jfOnnUR1gPy5AH9rbOAXt5DZ9s+zCMeEKwN67MG03Yzp4AepizVUYzMM315OstUQEjPXWZqevZ26uOYGrCvdwE7xsdzxQ/qf9V9B3ybHY3aWzrv0GyCPKGjb6ySZ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O0Zx+WHD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710802506; x=1742338506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YqUMy/R8ohYUsamG6py8FYzGr4xFpzoCnGvTBFrC4Ls=;
  b=O0Zx+WHDzKffy2rDzs3mU+85BtCZOT0W3+ZgGzOUE+QRH2swX0JB0dVJ
   qZKljNNYil94vgp0hWLJjYfZDt7i8z4ou4a37ffnECP+mBe+NBsgIVisQ
   gP5F6wErraDa3BX+YEV0AzUX1abUIWFLxbnvwNrUrJNoy7735xdnGlyBj
   cL0YE6iFFGT1fd10khMH0Ut3z5bHtKUTM11nIFSVIIejDHcvbmjBAtODB
   Pzw3+WoE+1hNZGvFoTHzA3iSHtlI0DdTSloQVgSDI8vSAt/PKPYumfrkb
   HJDTISf5CC8wmL/ywm1zJq0z/nFbR64HAWT9jcTkaIdgk24g+UUJfCAOu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="16188461"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="16188461"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 15:55:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="44552921"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 15:55:05 -0700
Date: Mon, 18 Mar 2024 15:55:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, aik@amd.com, isaku.yamahata@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v3 04/15] KVM: SVM: Compile sev.c if and only if
 CONFIG_KVM_AMD_SEV=y
Message-ID: <20240318225505.GB1645738@ls.amr.corp.intel.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226190344.787149-5-pbonzini@redhat.com>

On Mon, Feb 26, 2024 at 02:03:33PM -0500,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139cd24..52bc955ed06f 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -664,13 +664,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */
>  
> +#ifdef CONFIG_KVM_AMD_SEV
>  #define GHCB_VERSION_MAX	1ULL
>  #define GHCB_VERSION_MIN	1ULL
>  
> -
> -extern unsigned int max_sev_asid;
> -
> -void sev_vm_destroy(struct kvm *kvm);
>  int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
>  int sev_mem_enc_register_region(struct kvm *kvm,
>  				struct kvm_enc_region *range);
> @@ -681,19 +678,30 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
>  void sev_guest_memory_reclaimed(struct kvm *kvm);
>  
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
> -void __init sev_set_cpu_caps(void);
> -void __init sev_hardware_setup(void);
> -void sev_hardware_unsetup(void);
> -int sev_cpu_init(struct svm_cpu_data *sd);
>  void sev_init_vmcb(struct vcpu_svm *svm);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
> -void sev_free_vcpu(struct kvm_vcpu *vcpu);
>  int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>  void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +void sev_free_vcpu(struct kvm_vcpu *vcpu);
> +void sev_vm_destroy(struct kvm *kvm);
> +void __init sev_set_cpu_caps(void);
> +void __init sev_hardware_setup(void);
> +void sev_hardware_unsetup(void);
> +int sev_cpu_init(struct svm_cpu_data *sd);
> +extern unsigned int max_sev_asid;
> +#else
> +static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
> +static inline void sev_vm_destroy(struct kvm *kvm) {}
> +static inline void __init sev_set_cpu_caps(void) {}
> +static inline void __init sev_hardware_setup(void) {}
> +static inline void sev_hardware_unsetup(void) {}
> +static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
> +#define max_sev_asid 0
> +#endif
>  
>  /* vmenter.S */
>  
> -- 

This causes compile errors with -Werror=implicit-function-declaration when
CONFIG_KVM_AMD=y and CONFIG_KVM_AMD_SEV=n.  As discussed in [1], the stubs
aren't needed due to dead code elimination, but the declarations are needed.
[1] https://lore.kernel.org/kvm/ZdjCpX4LMCCyYev9@google.com/

Please feel free to squash the fix.


  CC      arch/x86/kvm/svm/svm.o
/linux/arch/x86/kvm/svm/svm.c: In function 'init_vmcb':
/linux/arch/x86/kvm/svm/svm.c:1367:17: error: implicit declaration of function 'sev_init_vmcb'; did you mean 'init_vmcb'? [-Werror=implicit-function-declaration]
 1367 |                 sev_init_vmcb(svm);
      |                 ^~~~~~~~~~~~~
      |                 init_vmcb

Similar warnings for sev_es_vcpu_reset(), sev_es_unmap_ghcb(),
sev_es_prepare_switch_to_guest(), sev_es_string_io(), pre_sev_run(),
sev_vcpu_after_set_cpuid(), and sev_vcpu_deliver_sipi_vector().

Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
 arch/x86/kvm/svm/svm.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 52bc955ed06f..eff9f19e5bcc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -663,6 +663,14 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 
 /* sev.c */
+void pre_sev_run(struct vcpu_svm *svm, int cpu);
+void sev_init_vmcb(struct vcpu_svm *svm);
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_es_vcpu_reset(struct vcpu_svm *svm);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 #ifdef CONFIG_KVM_AMD_SEV
 #define GHCB_VERSION_MAX	1ULL
@@ -677,15 +685,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void sev_guest_memory_reclaimed(struct kvm *kvm);
 
-void pre_sev_run(struct vcpu_svm *svm, int cpu);
-void sev_init_vmcb(struct vcpu_svm *svm);
-void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
-int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_vcpu_reset(struct vcpu_svm *svm);
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
-void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
-- 
2.43.2

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

