Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F4454ED8
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 21:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhKQVAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 16:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbhKQVAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 16:00:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE27C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 12:57:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so3623775pjb.5
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 12:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GKI+SD1yDpNp3ocje9HX9BSZ/X8pxcrXv2y7exF4+pE=;
        b=ep7ZJDg5FFOSlfdhSeiTQ3Unj2LmsS+WN52k01x4OhN+54b+P7IQkuQoQs5li5hWW3
         PnYytnyVUanmzvSxu4fu3+4DAfmXGEjzQCYacTvvHSz69eQ/U+PBgQpSWysqHsZiSpn/
         lZZowSFloCKYyCwFB57cWfUZRfQze7N4KfyIR/KUijyjWARRIT91v1jRdC+Rl7/5xkaS
         p6IDPlgMM9hfQ3Gff+6c6Q83SbUxVgtFoG3T3WOiirkjpdGVHmpQso6N1niEigbneEkZ
         qUFSdvNIRlEaIWga5+kJHYHo2hbmHTKKD5MIL1PqiiFwr4qlsyNMcHUAb4kmLaPZvsJb
         mg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GKI+SD1yDpNp3ocje9HX9BSZ/X8pxcrXv2y7exF4+pE=;
        b=OfcJ1cpL7R2R8wpZP80enzNs46uNm+Uu7OhFDWXcEdDuCH3fARj6gsQbYBtG1Y4dVE
         gsl4E35Vs8msqWbvxymGKHNxWi/qc2/t+Rn4RkqCXXtulqoO2uyvdcGHwjBmoAT+6P3M
         DpIJnOhs0/+s6NwOoEvyx3NIfLzN/UXANxrtNut/FYaMmIRAJb1kf0l/jhbAqCC8gXBe
         TtvwlpSS5XNxQj1ja0EhVeveBTWh7ftXQBg20M73Vj+YcR8PRyLlX9naQvKP1WiFA37x
         zZ6eEhK7NVp5XGB0qwxTnPLjjH3No2YPEyBCDqBvt8mXOPzcIAjXTWgiYE+QkA/D43t7
         aO8w==
X-Gm-Message-State: AOAM533FidThAoiYpaIR1XDotF2eQwX0RinukJZTLlJ/5KF32F7l1e4/
        /H2KAij1UFGODrhMFaRWnfTj/IGi4Gn6Kg==
X-Google-Smtp-Source: ABdhPJx59Vr421W/zCHcwsvCtDFut5od/byYarMtrpHYrCQWNjA56F+rM3W0dWLlOVqJOYrXy37b6A==
X-Received: by 2002:a17:90a:46c9:: with SMTP id x9mr3393896pjg.183.1637182625920;
        Wed, 17 Nov 2021 12:57:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u23sm488409pfl.185.2021.11.17.12.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:57:05 -0800 (PST)
Date:   Wed, 17 Nov 2021 20:57:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 4/4] x86/kvm: add boot parameter for setting max
 number of vcpus per guest
Message-ID: <YZVsnZ8e7cXls2P2@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-5-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116141054.17800-5-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Juergen Gross wrote:
> Today the maximum number of vcpus of a kvm guest is set via a #define
> in a header file.
> 
> In order to support higher vcpu numbers for guests without generally
> increasing the memory consumption of guests on the host especially on
> very large systems add a boot parameter for specifying the number of
> allowed vcpus for guests.
> 
> The default will still be the current setting of 1024. The value 0 has
> the special meaning to limit the number of possible vcpus to the
> number of possible cpus of the host.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V3:
> - rebase
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
>  arch/x86/include/asm/kvm_host.h                 | 5 ++++-
>  arch/x86/kvm/x86.c                              | 9 ++++++++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index e269c3f66ba4..409a72c2d91b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2445,6 +2445,13 @@
>  			feature (tagged TLBs) on capable Intel chips.
>  			Default is 1 (enabled)
>  
> +	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
> +			guest. The special value 0 sets the limit to the number
> +			of physical cpus possible on the host (including not
> +			yet hotplugged cpus). Higher values will result in
> +			slightly higher memory consumption per guest.
> +			Default: 1024

Rather than makes this a module param, I would prefer to start with the below
patch (originally from TDX pre-enabling) and then wire up a way for userspace to
_lower_ the max on a per-VM basis, e.g. add a capability.

VMs largely fall into two categories: (1) the max number of vCPUs is known prior
to VM creation, or (2) the max number of vCPUs is unbounded (up to KVM's hard
limit), e.g. for container-style use cases where "vCPUs" are created on-demand in
response to the "guest" creating a new task.

For #1, a per-VM control lets userspace lower the limit to the bare minimum.  For
#2, neither the module param nor the per-VM control is likely to be useful, but
a per-VM control does let mixed environments (both #1 and #2 VMs) lower the limits
for compatible VMs, whereas a module param must be set to the max of any potential VM.

From 0593cb4f73a6c3f0862f9411f0e14f00671f59ae Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 2 Jul 2021 15:04:27 -0700
Subject: [PATCH] KVM: Add max_vcpus field in common 'struct kvm'

Move arm's per-VM max_vcpus field into the generic "struct kvm", and use
it to check vcpus_created in the generic code instead of checking only
the hardcoded absolute KVM-wide max.  x86 TDX guests will reuse the
generic check verbatim, as the max number of vCPUs for a TDX guest is
user defined at VM creation and immutable thereafter.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 7 ++-----
 arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
 include/linux/kvm_host.h          | 1 +
 virt/kvm/kvm_main.c               | 3 ++-
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4be8486042a7..b51e1aa6ae27 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -108,9 +108,6 @@ struct kvm_arch {
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;

-	/* The maximum number of vCPUs depends on the used GIC model */
-	int max_vcpus;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f5490afe1ebf..97c3b83235b4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,7 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);

 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
+	kvm->max_vcpus = kvm_arm_default_max_vcpus();

 	set_default_spectre(kvm);

@@ -228,7 +228,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
 		if (kvm)
-			r = kvm->arch.max_vcpus;
+			r = kvm->max_vcpus;
 		else
 			r = kvm_arm_default_max_vcpus();
 		break;
@@ -304,9 +304,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
 		return -EBUSY;

-	if (id >= kvm->arch.max_vcpus)
-		return -EINVAL;
-
 	return 0;
 }

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a06d0648970..906aee52f2bc 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -97,11 +97,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	ret = 0;

 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
-		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
+		kvm->max_vcpus = VGIC_V2_MAX_CPUS;
 	else
-		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
+		kvm->max_vcpus = VGIC_V3_MAX_CPUS;

-	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
+	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret = -E2BIG;
 		goto out_unlock;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..5f56516e2f5a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -566,6 +566,7 @@ struct kvm {
 	 * and is accessed atomically.
 	 */
 	atomic_t online_vcpus;
+	int max_vcpus;
 	int created_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..e509b963651c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1052,6 +1052,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);

 	INIT_LIST_HEAD(&kvm->devices);
+	kvm->max_vcpus = KVM_MAX_VCPUS;

 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);

@@ -3599,7 +3600,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;

 	mutex_lock(&kvm->lock);
-	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
+	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
 		return -EINVAL;
 	}
--
2.34.0.rc1.387.gb447b232ab-goog
