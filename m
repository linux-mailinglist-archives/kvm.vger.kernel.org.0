Return-Path: <kvm+bounces-9545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3EB86170E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2A651C222FE
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DB3126F2D;
	Fri, 23 Feb 2024 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DBrg5P+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24C83A01
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704426; cv=none; b=o8bkIEGXpdxsUDkwKlxwoCo1SQ+eZ25FCKqMjgwGEgwmsb5mhrp/NupN5fQbgG+6bavuWOOmunkxol2eXsitfEnBcuedoJL9lzDye5YlJbDoxF4eT/8BrVaHMHBPbWzFcloycxhWvXHtJ37oWoYxMsmbUKf4+8cKr2fm7TMvGf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704426; c=relaxed/simple;
	bh=rWCZ3mBWzT/GlPbPa2Gg+eYc3E/vgBWcY+qqwxtRmpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JnVUx7Fs6TecPhyVWU8q5wdNkhU1aS+PQ2r5OEVX8Thp1KkjO8MI95BRNus273V7j2eusuKtMXwULv2ccKvf1V0Af3cBW7soLWOkKpu4mbJCoALbQ5dOITUJzOcdR0UITOPm26r7UyyMjcJbbRfPir6jQxoL1M7EfKvxbccfVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DBrg5P+h; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6088fa18619so16054837b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708704424; x=1709309224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJZOOetSxpT2KpgzwkJggFPydq+/D36T/nanoyZ2GT8=;
        b=DBrg5P+h5vAuCaZzZGFzSpMN7FOrF5VtEV2/XAXycxc1bXJeHPe8hXhFdih4OkJJRF
         PwPlqt6qDDjp9uHQr7oCp8g75X/uAFvclp8mzQgFba8SOl0w1P448P/w6DY4zNJHPSwy
         P1aZW/nZx0CpSq0SvRrr8a4nEK8WTz4vDWx2yXdLQsnqOQyn+zB4lRUJwRUKSrRbDAA0
         2DpnHFdQGLYXTearZmVvx7WJdKZQTrl9yRVWJ0sx8bH/4QQHrDNvGPOMvDeWm8pBxc05
         dNE2WB/pkmo+rj/0nhnygOekpJxSn8x06fPu7PcW/nYZH0DbS7HHmyDR311r2KVcxYwx
         /RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708704424; x=1709309224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJZOOetSxpT2KpgzwkJggFPydq+/D36T/nanoyZ2GT8=;
        b=IGxVTw9F5D5rADzdwBKRqchBw7DOvTZamY1unYR8maEr/jppmp3Za/ntmQQHeDUeAb
         /1gMILiEKL219TzaWL85xAgOsbXQf2HPyz3uoibom3nRhFk81GMkTweTzxlD1MyyYEoj
         3Ja7ScS5mBsE8G1D5GDLrjKhf8GKicHgR/ve8qnDrZFgPoh4Q2rRQTFFcWpoujwKxNpo
         MHIX4DF+Uzo5JHfJuPf8Eh1qlGHAGyjzXw3jDQ8XjdCmuiHslejE46/HOEVD+tiMVrTw
         VjgM7Kkb65SQ4bJ7JCzFZwBuZ5+znH1xVe5r4aXr1gto29KvdLJ5EH2ABisOjAn3/D0J
         VHYw==
X-Forwarded-Encrypted: i=1; AJvYcCXGXMK6klf+uxkevBC8HKxW4uLmT40dttdIJGtzqu3E+7M3VSVGv/+38/X5YJPPnlXJ3BSsyVp9K1xxDavzYrnBaAmM
X-Gm-Message-State: AOJu0YwitqlUeRvqmNSFokObZ0YvtmUMbLOfP/kzBOVFDEHU9qIHTVi/
	nZPTtAppOJX3JwQJEttyh1ok9IgWjDR4sv0Yc5278S1otJmEU7wyrTLewuczaQ/iXeLL7ogJlLf
	dJQ==
X-Google-Smtp-Source: AGHT+IEdjgY7rkI5K3k9RbCi9/9LyilYbgtEeUI0HI31kNBzQaAIwNdjEAiEaBEwQe9thpfGqOswVtxplhU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:db01:0:b0:dc7:6f13:61d9 with SMTP id
 g1-20020a25db01000000b00dc76f1361d9mr2384ybf.4.1708704423630; Fri, 23 Feb
 2024 08:07:03 -0800 (PST)
Date: Fri, 23 Feb 2024 08:07:01 -0800
In-Reply-To: <20240223104009.632194-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-5-pbonzini@redhat.com>
Message-ID: <ZdjCpX4LMCCyYev9@google.com>
Subject: Re: [PATCH v2 04/11] KVM: SEV: publish supported VMSA features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: multipart/mixed; charset="UTF-8"; boundary="ZUo03/L5Jsb9rYOS"


--ZUo03/L5Jsb9rYOS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> Compute the set of features to be stored in the VMSA when KVM is
> initialized; move it from there into kvm_sev_info when SEV is initialized,
> and then into the initial VMSA.
> 
> The new variable can then be used to return the set of supported features
> to userspace, via the KVM_GET_DEVICE_ATTR ioctl.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20240209183743.22030-5-pbonzini@redhat.com>

Maybe in v3 we'll find out whether or not you can triple-stamp a double-stamp :-)

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f760106c31f8..53e958805ab9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,10 +59,12 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  /* enable/disable SEV-ES DebugSwap support */
>  static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
> +static u64 sev_supported_vmsa_features;
>  #else
>  #define sev_enabled false
>  #define sev_es_enabled false
>  #define sev_es_debug_swap_enabled false
> +#define sev_supported_vmsa_features 0

Ok, I've reached my breaking point.  Compiling sev.c for CONFIG_KVM_AMD_SEV=n is
getting untenable.  Splattering #ifdefs _inside_ SEV specific functions is weird
and confusing.

And unless dead code elimination isn't as effective as I think it is, we don't
even need any stuba  since sev_guest() and sev_es_guest() are __always_inline
specifically so that useless code can be elided.  Or if we want to avoid use of
IS_ENABLED(), we could add four stubs, which is still well worth it.

Note, I also have a separate series that I will post today (I hope) that gives
__svm_sev_es_vcpu_run() similar treatment (the 32-bit "support" in assembly is
all kinds of stupid).

Attached patches are compile-tested only, though I'll try to take them for a spin
on hardware later today.

--ZUo03/L5Jsb9rYOS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Call-sev_vm_destroy-and-sev_free_vcpu-only-f.patch"

From 835b63222be184596060207b8f9880266b3836ca Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 07:23:57 -0800
Subject: [PATCH 1/4] KVM: SVM: Call sev_vm_destroy() and sev_free_vcpu() only
 for SEV+ guests

Wrap the calls to sev_vm_destroy() and sev_free_vcpu() with sev_guest() to
take advantage of dead code elimination when CONFIG_KVM_AMD_SEV=n.  This
will allow compiling sev.c if and only if CONFIG_KVM_AMD_SEV=y without
needing to provide stubs.

Note, sev_free_vcpu() only frees resources for SEV-ES guests, which is why
the diff doesn't show any code removal.  Alternatively, sev_free_vcpu()
could be wrapped with sev_es_guest(), but then the name would also need to
be updated, skipping the call for SEV guests isn't all that interesting,
and doing so would create even more churn if KVM ever does need to free
resources for SEV guests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 ---
 arch/x86/kvm/svm/svm.c | 7 +++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f06f9e51ad9d..4f6052e29eb1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2137,9 +2137,6 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
-	if (!sev_guest(kvm))
-		return;
-
 	WARN_ON(!list_empty(&sev->mirror_vms));
 
 	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..c657e75fd2c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1497,7 +1497,8 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 	svm_leave_nested(vcpu);
 	svm_free_nested(svm);
 
-	sev_free_vcpu(vcpu);
+	if (sev_guest(vcpu->kvm))
+		sev_free_vcpu(vcpu);
 
 	__free_page(pfn_to_page(__sme_clr(svm->vmcb01.pa) >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
@@ -4883,7 +4884,9 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
-	sev_vm_destroy(kvm);
+
+	if (sev_guest(kvm))
+		sev_vm_destroy(kvm);
 }
 
 static int svm_vm_init(struct kvm *kvm)

base-commit: ec1e3d33557babed2c2c2c7da6e84293c2f56f58
-- 
2.44.0.rc0.258.g7320e95886-goog


--ZUo03/L5Jsb9rYOS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-SVM-Invert-handling-of-SEV-and-SEV_ES-feature-fl.patch"

From a74b61c74285af9aaebe5437dda5d85e7919d1d4 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 07:53:55 -0800
Subject: [PATCH 2/4] KVM: SVM: Invert handling of SEV and SEV_ES feature flags

Leave SEV and SEV_ES '0' in kvm_cpu_caps by default, and instead set them
in sev_set_cpu_caps() if SEV and SEV-ES support are fully enabled.  Aside
from the fact that sev_set_cpu_caps() is wildly misleading when it *clears*
capabilities, this will allow compiling out sev.c without falsely
advertising SEV/SEV-ES support in KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/sev.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..bde4df13a7e8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -761,7 +761,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
 
 	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
-		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
+		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4f6052e29eb1..a0f270f976aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2175,10 +2175,10 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
-	if (!sev_enabled)
-		kvm_cpu_cap_clear(X86_FEATURE_SEV);
-	if (!sev_es_enabled)
-		kvm_cpu_cap_clear(X86_FEATURE_SEV_ES);
+	if (sev_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SEV);
+	if (sev_es_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 }
 
 void __init sev_hardware_setup(void)
-- 
2.44.0.rc0.258.g7320e95886-goog


--ZUo03/L5Jsb9rYOS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-SVM-Gate-calls-to-SEV-un-setup-helpers-with-IS_E.patch"

From 7f469f81d4cc8300ddab322574fbe1e11a64c467 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 07:57:57 -0800
Subject: [PATCH 3/4] KVM: SVM: Gate calls to SEV (un)setup helpers with
 IS_ENABLED(CONFIG_KVM_AMD_SEV)

Invoke SEV helpers that aren't associated with a VM/vCPU, i.e. aren't
already guarded by sev_guest() or sev_es_guest(), if and only if
CONFIG_KVM_AMD_SEV=y.  This will allow compiling sev.c only when SEV
support is enabled without needing to add stubs.

Use IS_ENABLED() to avoid #ifdefs, as it's easy to unconditionally
declare the helpers.  Dead code elimination will take care of the rest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c657e75fd2c6..e036a0852161 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -707,9 +707,11 @@ static int svm_cpu_init(int cpu)
 	if (!sd->save_area)
 		return ret;
 
-	ret = sev_cpu_init(sd);
-	if (ret)
-		goto free_save_area;
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV)) {
+		ret = sev_cpu_init(sd);
+		if (ret)
+			goto free_save_area;
+	}
 
 	sd->save_area_pa = __sme_page_pa(sd->save_area);
 	return 0;
@@ -1110,7 +1112,8 @@ static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
-	sev_hardware_unsetup();
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV))
+		sev_hardware_unsetup();
 
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
@@ -5149,7 +5152,8 @@ static __init void svm_set_cpu_caps(void)
 	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
-	sev_set_cpu_caps();
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV))
+		sev_set_cpu_caps();
 }
 
 static __init int svm_hardware_setup(void)
@@ -5243,7 +5247,8 @@ static __init int svm_hardware_setup(void)
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
 	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
 	 */
-	sev_hardware_setup();
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV))
+		sev_hardware_setup();
 
 	svm_hv_hardware_setup();
 
-- 
2.44.0.rc0.258.g7320e95886-goog


--ZUo03/L5Jsb9rYOS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-SVM-Compile-sev.c-if-and-only-if-CONFIG_KVM_AMD_.patch"

From 8eb3303e35ee73a74c7f201370a4c531dad5866c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 07:29:53 -0800
Subject: [PATCH 4/4] KVM: SVM: Compile sev.c if and only if
 CONFIG_KVM_AMD_SEV=y

Stop compiling sev.c when CONFIG_KVM_AMD_SEV=n, as the number of #ifdefs
in sev.c is getting ridiculous, and having #ifdefs inside of SEV helpers
is quite confusing.

To minimize #ifdefs in code flows, #idef away only the kvm_x86_ops hooks
and the #VMGEXIT handler, and instead rely on dead code elimination to
take care of functions that are guarded with sev_guest(), sev_es_guest(),
or an IS_ENABLED(CONFIG_KVM_AMD_SEV).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Makefile  |  7 ++++---
 arch/x86/kvm/svm/sev.c | 23 -----------------------
 arch/x86/kvm/svm/svm.c |  6 ++++--
 arch/x86/kvm/svm/svm.h | 23 ++++++++++++++++-------
 4 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 475b5fa917a6..744a1ea3ee5c 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,9 +25,10 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
 
-kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
-			   svm/sev.o
-kvm-amd-$(CONFIG_KVM_HYPERV) += svm/hyperv.o
+kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
+
+kvm-amd-$(CONFIG_KVM_AMD_SEV)	+= svm/sev.o
+kvm-amd-$(CONFIG_KVM_HYPERV)	+= svm/hyperv.o
 
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a0f270f976aa..e1b356e1f6e8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,22 +32,6 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#ifndef CONFIG_KVM_AMD_SEV
-/*
- * When this config is not defined, SEV feature is not supported and APIs in
- * this file are not used but this file still gets compiled into the KVM AMD
- * module.
- *
- * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
- * misc_res_type {} defined in linux/misc_cgroup.h.
- *
- * Below macros allow compilation to succeed.
- */
-#define MISC_CG_RES_SEV MISC_CG_RES_TYPES
-#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
-#endif
-
-#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -59,11 +43,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
-#else
-#define sev_enabled false
-#define sev_es_enabled false
-#define sev_es_debug_swap_enabled false
-#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -2183,7 +2162,6 @@ void __init sev_set_cpu_caps(void)
 
 void __init sev_hardware_setup(void)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -2283,7 +2261,6 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
-#endif
 }
 
 void sev_hardware_unsetup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e036a0852161..13e4151bd297 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3310,7 +3310,9 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+#ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
+#endif
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -5019,7 +5021,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.leave_smm = svm_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
 #endif
-
+#ifdef CONFIG_KVM_AMD_SEV
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
@@ -5027,7 +5029,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
-
+#endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..80211ac02577 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -663,14 +663,12 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 
 /* sev.c */
-
+#ifdef CONFIG_KVM_AMD_SEV
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
-
 extern unsigned int max_sev_asid;
 
-void sev_vm_destroy(struct kvm *kvm);
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range);
@@ -680,20 +678,31 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void sev_guest_memory_reclaimed(struct kvm *kvm);
 
-void pre_sev_run(struct vcpu_svm *svm, int cpu);
+int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
+#else
+#define max_sev_asid 0
+#endif
+
+/*
+ * To minimize #ifdefs, declare functions that are called directly, i.e. aren't
+ * reached via kvm_x86_ops or something other function table.  Don't provide
+ * stubs as all calls should be dropped by dead code elimination before linking.
+ */
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+
 void sev_init_vmcb(struct vcpu_svm *svm);
-void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
-void sev_free_vcpu(struct kvm_vcpu *vcpu);
-int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
+void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
+void sev_vm_destroy(struct kvm *kvm);
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.44.0.rc0.258.g7320e95886-goog


--ZUo03/L5Jsb9rYOS--

