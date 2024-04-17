Return-Path: <kvm+bounces-14976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D798A8629
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72C0E282777
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB9E14036F;
	Wed, 17 Apr 2024 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AjNQTtmv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A413D24A
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 14:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713364808; cv=none; b=DrBA61KXtwYjU9M5rmwqvhHQ6AVNKcPa8qOMOwp+Jz+DgdhpXeI2DT0iU3ppwGxwIFxPpuOji6FhOBzTN6YGwFa+wgq2W2Vvkdp6NbzEiD80YyzcyxSUajiTGw1djqZtLTKzB1S+R8L7Fsxxnwl6kgbZMaqQJzKOknzs6NYH40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713364808; c=relaxed/simple;
	bh=1cnot3nzi+4KW5MGtDgSkIV4ZSgOc1G0Z8WhjTm5XHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F2HdjPjSugoEgWZp9HmVgT7C7wcJMcEu4YFlNEm3jfddJ33VlosjjOQQKMVpqVfSVwIqxk2g4b9199o5XfDmq1ABJJ5uTf81StuyDWCz287wjhxx2gb3kInVkNhaGlvRVbS5FbBLQEoAI72A/bJPjlK5jGhxaDRUESx54ky4N5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AjNQTtmv; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fe93b5cfso85180977b3.0
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 07:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713364805; x=1713969605; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dJEYFTsJc+pkZyHcTqAZU7jrM+C32T1M0H5QL1prYMs=;
        b=AjNQTtmvqcPTKOppL1heCFkzkosNoigCKPi5wz1yDcKdUECPj6VZ5Ibq3SM4egxhxu
         ZMOrQEaEAsyCvc19uQeIzSK2ze1T+LeoJ2iRYaSQSLAqlhyvWgH5CKYxd+ziy7ADivXl
         GBdZ+8p2J09szi6Zxk9L/FHjNmZ83G19lgR+PQK+VuLhn5tFzQTrW2dVuVuyCkBIoU32
         6tKUmvbAfuFhPVe7wcmZotjDwVPRv61aC4AcoN7E5r+GOAm3iMnTR5OjtfnH0FEtcp6j
         igY4kJ5kVum88TYAo/shahbr4Ta1X8zQ3xIA7vHZcb7H6HyKWjXwLDWbSwaMFHiC4tOW
         sNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713364805; x=1713969605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJEYFTsJc+pkZyHcTqAZU7jrM+C32T1M0H5QL1prYMs=;
        b=Bc3eSk5DmDAVDjyCyB8kfT/q7Eg7GXSo8AiNwRoLXmEo10+PhE+xi9PFsDQZ82dess
         RGnHjFCAyRqM6dftyh76RxU+dh66px4ylR08qfzlNHHJQIOh+SVb7pUDF6OHqq1D3uHK
         0jRmWWFDA7pmH4f5MtnxbA0V5kcp0RdxUl75R1+PPirQCIMFj9OvNO5HO4e6L5J/Ig8h
         vCWQQhhA+phJ+U3mIdPVN1JcadsVQWKHbMyzDsltyoy1YL/JK1PFmj1S8CCO7iGuq6L8
         NV0udxqzqSpEAlm4NFUqmzEDdqgPjXxLcEiXQuMO9VwHHHqPE/jso3Y8DZSEmc1C2+J1
         LcqA==
X-Forwarded-Encrypted: i=1; AJvYcCX09cBIa4o6eSOf824MZqNB6f2cmQqrxeJBWFvD8KHIeNGuVB496S1xtF8Z6C+7AERP98i+JF1iZr3YO5cQCOXJxK58
X-Gm-Message-State: AOJu0Yzy8qoKEvPTD+JZUy3qsnHUGusYMS6e82eTVm0qQu9QxLsyyjBX
	+tIHAEUaC7OmZ3qTxOrSEomopSLTBw9KIkljnnrwK39+EOqXJ0J1cH3uvK85reqSGG9N9n2Svqp
	h+Q==
X-Google-Smtp-Source: AGHT+IGXKdCZdT1hbYuSR3+eKpU2XT9ZmLp4dVFRqVzX5nFTv0EKxN438/xoKjYIHQ5naUGjnp57wEawr4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d50d:0:b0:618:66ef:b215 with SMTP id
 i13-20020a81d50d000000b0061866efb215mr4132036ywj.2.1713364805715; Wed, 17 Apr
 2024 07:40:05 -0700 (PDT)
Date: Wed, 17 Apr 2024 07:40:04 -0700
In-Reply-To: <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
 <20240322212321.GA1994522@ls.amr.corp.intel.com> <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com> <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com> <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com> <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
Message-ID: <Zh_exbWc90khzmYm@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 17, 2024, Kai Huang wrote:
> On Tue, 2024-04-16 at 13:58 -0700, Sean Christopherson wrote:
> > On Fri, Apr 12, 2024, Kai Huang wrote:
> > > On 12/04/2024 2:03 am, Sean Christopherson wrote:
> > > > On Thu, Apr 11, 2024, Kai Huang wrote:
> > > > > I can certainly follow up with this and generate a reviewable patchset if I
> > > > > can confirm with you that this is what you want?
> > > > 
> > > > Yes, I think it's the right direction.  I still have minor concerns about VMX
> > > > being enabled while kvm.ko is loaded, which means that VMXON will _always_ be
> > > > enabled if KVM is built-in.  But after seeing the complexity that is needed to
> > > > safely initialize TDX, and after seeing just how much complexity KVM already
> > > > has because it enables VMX on-demand (I hadn't actually tried removing that code
> > > > before), I think the cost of that complexity far outweighs the risk of "always"
> > > > being post-VMXON.
> > > 
> > > Does always leaving VMXON have any actual damage, given we have emergency
> > > virtualization shutdown?
> > 
> > Being post-VMXON increases the risk of kexec() into the kdump kernel failing.
> > The tradeoffs that we're trying to balance are: is the risk of kexec() failing
> > due to the complexity of the emergency VMX code higher than the risk of us breaking
> > things in general due to taking on a ton of complexity to juggle VMXON for TDX?
> > 
> > After seeing the latest round of TDX code, my opinion is that being post-VMXON
> > is less risky overall, in no small part because we need that to work anyways for
> > hosts that are actively running VMs.
> 
> How about we only keep VMX always on when TDX is enabled?

Paolo also suggested that forcing VMXON only if TDX is enabled, mostly because
kvm-intel.ko and kvm-amd.ko may be auto-loaded based on MODULE_DEVICE_TABLE(),
which in turn causes problems for out-of-tree hypervisors that want control over
VMX and SVM.

I'm not opposed to the idea, it's the complexity and messiness I dislike.  E.g.
the TDX code shouldn't have to deal with CPU hotplug locks, core KVM shouldn't
need to expose nolock helpers, etc.  And if we're going to make non-trivial
changes to the core KVM hardware enabling code anyways...

What about this?  Same basic idea as before, but instead of unconditionally doing
hardware enabling during module initialization, let TDX do hardware enabling in
a late_hardware_setup(), and then have KVM x86 ensure virtualization is enabled
when creating VMs.

This way, architectures that aren't saddled with out-of-tree hypervisors can do
the dead simple thing of enabling hardware during their initialization sequence,
and the TDX code is much more sane, e.g. invoke kvm_x86_enable_virtualization()
during late_hardware_setup(), and kvm_x86_disable_virtualization() during module
exit (presumably).

---
 Documentation/virt/kvm/locking.rst |   4 -
 arch/x86/include/asm/kvm_host.h    |   3 +
 arch/x86/kvm/svm/svm.c             |   5 +-
 arch/x86/kvm/vmx/vmx.c             |  18 ++-
 arch/x86/kvm/x86.c                 |  59 +++++++---
 arch/x86/kvm/x86.h                 |   2 +
 include/linux/kvm_host.h           |   2 +
 virt/kvm/kvm_main.c                | 181 +++++++----------------------
 8 files changed, 104 insertions(+), 170 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..0d6eff13fd46 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -227,10 +227,6 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-		- kvm_usage_count
-		- hardware virtualization enable/disable
-:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
-		enable/disable.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 73740d698ebe..7422239987d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/reboot.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -1605,6 +1606,8 @@ struct kvm_x86_ops {
 
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
+	cpu_emergency_virt_cb *emergency_disable;
+
 	void (*hardware_unsetup)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8d57d..7e118284934c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4917,6 +4917,7 @@ static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
+	.emergency_disable = svm_emergency_disable,
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.hardware_unsetup = svm_hardware_unsetup,
@@ -5348,8 +5349,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 static void __svm_exit(void)
 {
 	kvm_x86_vendor_exit();
-
-	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
 }
 
 static int __init svm_init(void)
@@ -5365,8 +5364,6 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
-	cpu_emergency_register_virt_callback(svm_emergency_disable);
-
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d18dcb1e11a6..0dbe74da7ee3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8320,6 +8320,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
+	.emergency_disable = vmx_emergency_disable,
+
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
@@ -8733,8 +8735,6 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
-
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8760,6 +8760,12 @@ static int __init vmx_init(void)
 	 */
 	hv_init_evmcs();
 
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
+		pi_init_cpu(cpu);
+	}
+
 	r = kvm_x86_vendor_init(&vmx_init_ops);
 	if (r)
 		return r;
@@ -8775,14 +8781,6 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
-		pi_init_cpu(cpu);
-	}
-
-	cpu_emergency_register_virt_callback(vmx_emergency_disable);
-
 	vmx_check_vmcs12_offsets();
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26288ca05364..fdf6e05000c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -134,6 +134,7 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
+static int kvm_usage_count;
 
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
@@ -9687,15 +9688,10 @@ static int kvm_x86_check_processor_compatibility(void)
 	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
-static void kvm_x86_check_cpu_compat(void *ret)
-{
-	*(int *)ret = kvm_x86_check_processor_compatibility();
-}
-
 int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
 	u64 host_pat;
-	int r, cpu;
+	int r;
 
 	guard(mutex)(&vendor_module_lock);
 
@@ -9771,11 +9767,11 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_ops_update(ops);
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
-		if (r < 0)
-			goto out_unwind_ops;
-	}
+	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable);
+
+	r = ops->late_hardware_setup();
+	if (r)
+		goto out_unwind_ops;
 
 	/*
 	 * Point of no return!  DO NOT add error paths below this point unless
@@ -9818,6 +9814,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	return 0;
 
 out_unwind_ops:
+	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable);
 	kvm_x86_ops.hardware_enable = NULL;
 	static_call(kvm_x86_hardware_unsetup)();
 out_mmu_exit:
@@ -9858,6 +9855,10 @@ void kvm_x86_vendor_exit(void)
 	static_key_deferred_flush(&kvm_xen_enabled);
 	WARN_ON(static_branch_unlikely(&kvm_xen_enabled.key));
 #endif
+
+	kvm_disable_virtualization();
+	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable);
+
 	mutex_lock(&vendor_module_lock);
 	kvm_x86_ops.hardware_enable = NULL;
 	mutex_unlock(&vendor_module_lock);
@@ -12522,6 +12523,33 @@ void kvm_arch_free_vm(struct kvm *kvm)
 	__kvm_arch_free_vm(kvm);
 }
 
+int kvm_x86_enable_virtualization(void)
+{
+	int r;
+
+	guard(mutex)(&vendor_module_lock);
+
+	if (kvm_usage_count++)
+		return 0;
+
+	r = kvm_enable_virtualization();
+	if (r)
+		--kvm_usage_count;
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_x86_enable_virtualization);
+
+void kvm_x86_disable_virtualization(void)
+{
+	guard(mutex)(&vendor_module_lock);
+
+	if (--kvm_usage_count)
+		return;
+
+	kvm_disable_virtualization();
+}
+EXPORT_SYMBOL_GPL(kvm_x86_disable_virtualization);
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
@@ -12533,9 +12561,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.vm_type = type;
 
+	ret = kvm_x86_enable_virtualization();
+	if (ret)
+		return ret;
+
 	ret = kvm_page_track_init(kvm);
 	if (ret)
-		goto out;
+		goto out_disable_virtualization;
 
 	kvm_mmu_init_vm(kvm);
 
@@ -12582,7 +12614,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
-out:
+out_disable_virtualization:
+	kvm_x86_disable_virtualization();
 	return ret;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8b71803777b..427c5d102525 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -32,6 +32,8 @@ struct kvm_caps {
 };
 
 void kvm_spurious_fault(void);
+int kvm_x86_enable_virtualization(void);
+void kvm_x86_disable_virtualization(void);
 
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
 ({									\
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..92da2eee7448 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1518,6 +1518,8 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
+int kvm_enable_virtualization(void);
+void kvm_disable_virtualization(void);
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f345dc15854f..326e3225c052 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -139,8 +139,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1261,10 +1259,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
-	if (r)
-		goto out_err_no_disable;
-
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
@@ -1304,8 +1298,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
-out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
@@ -1393,7 +1385,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
 	mmdrop(mm);
 }
 
@@ -5536,9 +5527,8 @@ __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
-static int kvm_usage_count;
 
-static int __hardware_enable_nolock(void)
+static int __kvm_enable_virtualization(void)
 {
 	if (__this_cpu_read(hardware_enabled))
 		return 0;
@@ -5553,34 +5543,18 @@ static int __hardware_enable_nolock(void)
 	return 0;
 }
 
-static void hardware_enable_nolock(void *failed)
-{
-	if (__hardware_enable_nolock())
-		atomic_inc(failed);
-}
-
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
-
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		ret = __hardware_enable_nolock();
-	mutex_unlock(&kvm_lock);
-	return ret;
+	return __kvm_enable_virtualization();
 }
 
-static void hardware_disable_nolock(void *junk)
+static void __kvm_disable_virtualization(void *ign)
 {
-	/*
-	 * Note, hardware_disable_all_nolock() tells all online CPUs to disable
-	 * hardware, not just CPUs that successfully enabled hardware!
-	 */
 	if (!__this_cpu_read(hardware_enabled))
 		return;
 
@@ -5591,78 +5565,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	mutex_unlock(&kvm_lock);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
-static void hardware_disable_all_nolock(void)
-{
-	BUG_ON(!kvm_usage_count);
-
-	kvm_usage_count--;
-	if (!kvm_usage_count)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
-}
-
-static void hardware_disable_all(void)
-{
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-}
-
-static int hardware_enable_all(void)
-{
-	atomic_t failed = ATOMIC_INIT(0);
-	int r;
-
-	/*
-	 * Do not enable hardware virtualization if the system is going down.
-	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
-	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
-	 * after kvm_reboot() is called.  Note, this relies on system_state
-	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
-	 * hook instead of registering a dedicated reboot notifier (the latter
-	 * runs before system_state is updated).
-	 */
-	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
-	    system_state == SYSTEM_RESTART)
-		return -EBUSY;
-
-	/*
-	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
-	 * is called, and so on_each_cpu() between them includes the CPU that
-	 * is being onlined.  As a result, hardware_enable_nolock() may get
-	 * invoked before kvm_online_cpu(), which also enables hardware if the
-	 * usage count is non-zero.  Disable CPU hotplug to avoid attempting to
-	 * enable hardware multiple times.
-	 */
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-
-	r = 0;
-
-	kvm_usage_count++;
-	if (kvm_usage_count == 1) {
-		on_each_cpu(hardware_enable_nolock, &failed, 1);
-
-		if (atomic_read(&failed)) {
-			hardware_disable_all_nolock();
-			r = -EBUSY;
-		}
-	}
-
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-
-	return r;
-}
-
 static void kvm_shutdown(void)
 {
 	/*
@@ -5678,34 +5584,22 @@ static void kvm_shutdown(void)
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(__kvm_disable_virtualization, NULL, 1);
 }
 
 static int kvm_suspend(void)
 {
-	/*
-	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
-	 */
-	lockdep_assert_not_held(&kvm_lock);
 	lockdep_assert_irqs_disabled();
 
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
+	__kvm_disable_virtualization(NULL);
 	return 0;
 }
 
 static void kvm_resume(void)
 {
-	lockdep_assert_not_held(&kvm_lock);
 	lockdep_assert_irqs_disabled();
 
-	if (kvm_usage_count)
-		WARN_ON_ONCE(__hardware_enable_nolock());
+	WARN_ON_ONCE(__kvm_enable_virtualization());
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5713,16 +5607,45 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume = kvm_resume,
 	.shutdown = kvm_shutdown,
 };
-#else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
-static int hardware_enable_all(void)
+
+int kvm_enable_virtualization(void)
 {
+	int r;
+
+	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+			      kvm_online_cpu, kvm_offline_cpu);
+	if (r)
+		return r;
+
+	register_syscore_ops(&kvm_syscore_ops);
+
+	/*
+	 * Manually undo virtualization enabling if the system is going down.
+	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
+	 * possible for an in-flight module load to enable virtualization
+	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
+	 * being invoked.  Note, this relies on system_state being set _before_
+	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
+	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
+	 * a syscore ops hook instead of registering a dedicated reboot
+	 * notifier (the latter runs before system_state is updated).
+	 */
+	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
+	    system_state == SYSTEM_RESTART) {
+		unregister_syscore_ops(&kvm_syscore_ops);
+		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
-static void hardware_disable_all(void)
+void kvm_disable_virtualization(void)
 {
-
+	unregister_syscore_ops(&kvm_syscore_ops);
+	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 }
+
 #endif /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 
 static void kvm_iodevice_destructor(struct kvm_io_device *dev)
@@ -6418,15 +6341,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	int r;
 	int cpu;
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
-				      kvm_online_cpu, kvm_offline_cpu);
-	if (r)
-		return r;
-
-	register_syscore_ops(&kvm_syscore_ops);
-#endif
-
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
@@ -6437,10 +6351,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 					   offsetofend(struct kvm_vcpu, stats_id)
 					   - offsetof(struct kvm_vcpu, arch),
 					   NULL);
-	if (!kvm_vcpu_cache) {
-		r = -ENOMEM;
-		goto err_vcpu_cache;
-	}
+	if (!kvm_vcpu_cache)
+		return -ENOMEM;
 
 	for_each_possible_cpu(cpu) {
 		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
@@ -6497,11 +6409,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
-err_vcpu_cache:
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	unregister_syscore_ops(&kvm_syscore_ops);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-#endif
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init);
@@ -6523,10 +6430,6 @@ void kvm_exit(void)
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-	unregister_syscore_ops(&kvm_syscore_ops);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-#endif
 	kvm_irqfd_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);

base-commit: 2d181d84af38146748042a6974c577fc46c3f1c3
-- 


